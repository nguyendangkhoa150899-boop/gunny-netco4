// Ra soat phó ban: moi phó ban x do kho, kiem tu kich ban game -> ai -> kich ban ai, va client co hien khong.
//   node kiem-pho-ban.js <pve-export.txt> <Game.Server.dll dang chay> <gameSrc dir> <Request dir> [out.json]
// pve-export.txt: sqlcmd -u (UTF-16) cua xuat-pve.sql: "<p .../>..." + "@@@" + "<m .../>...".
// SetupMissions lay tu ma nguon (gameSrc) theo ten lop; ten lop / kich ban ai kiem bang chuoi trong DLL dang chay.
const fs = require('fs'), path = require('path'), zlib = require('zlib');
const [exp, dllPath, src, req, out] = process.argv.slice(2);
const raw = fs.readFileSync(exp); const t = (raw[0] === 0xFF ? raw.toString('utf16le') : raw.toString('utf8')).replace(/^﻿/, '');
const [a, b] = t.split('@@@');
const at = s => { const o = {}; for (const m of s.matchAll(/ (\w+)="([^"]*)"/g)) o[m[1]] = m[2]; return o; };
const pves = [...a.matchAll(/<p [^>]*\/>/g)].map(m => at(m[0]));
const mis = {}; for (const m of b.matchAll(/<m [^>]*\/>/g)) { const o = at(m[0]); mis[o.Id] = o; }
const dll = fs.readFileSync(dllPath).toString('latin1');
const coLop = full => { const n = full.split('.').pop(); return n && dll.includes(n); };

// lop kich ban game -> danh sach ai (tu ma nguon)
const setup = {};
(function quet(d) {
  for (const f of fs.readdirSync(d, { withFileTypes: true })) {
    const p = path.join(d, f.name);
    if (f.isDirectory()) quet(p);
    else if (f.name.endsWith('.cs')) {
      const s = fs.readFileSync(p, 'utf8');
      const c = s.match(/class\s+(\w+)\s*:\s*APVEGameControl/); if (!c) continue;
      const m = s.match(/SetupMissions\(\s*"([^"]*)"/);
      if (!setup[c[1]]) setup[c[1]] = m ? m[1].split(',').map(x => x.trim()).filter(Boolean) : null;
    }
  }
})(src);

// client: LoadPVEItems.xml (do kho hien khi XxxTemplateIds khong rong)
const rd = f => { const b = fs.readFileSync(f); try { return zlib.inflateSync(b).toString('utf8'); } catch (e) { return b.toString('utf8'); } };
const cli = {}; for (const m of rd(req + '/LoadPVEItems.xml').matchAll(/<Item [^>]*>/g)) { const o = at(m[0]); cli[o.ID] = o; }

const DK = [['S1', 'T1', 'Simple', 'Dễ'], ['S2', 'T2', 'Normal', 'Thường'], ['S3', 'T3', 'Hard', 'Khó'], ['S4', 'T4', 'Terror', 'Anh hùng'], ['S5', 'T5', 'Nightmare', 'Ác mộng']];
const ketqua = [];
for (const p of pves) {
  const c = cli[p.ID];
  const dong = { id: +p.ID, ten: p.Name, type: +p.Type, ordering: +p.Ordering, client: !!c, dk: [] };
  for (const [s, tk, en, vi] of DK) {
    const script = p[s];
    const clientHien = !!(c && c[en + 'TemplateIds']);
    if (!script && !clientHien) continue;
    const loi = [];
    let ai = null;
    if (!script) loi.push('khong co kich ban game');
    else if (!coLop(script)) loi.push('lop ' + script.split('.').pop() + ' khong co trong DLL');
    else {
      ai = setup[script.split('.').pop()];
      if (ai === undefined) loi.push('khong thay ma nguon lop (khong biet ai)');
      else if (ai === null) loi.push('kich ban khong dung SetupMissions co dinh (khong kiem duoc ai)');
      else for (const id of ai) {
        const m = mis[id];
        if (!m) loi.push('ai ' + id + ' khong co trong Mission_Info');
        else if (!m.Script) loi.push('ai ' + id + ' khong co kich ban');
        else if (!coLop(m.Script)) loi.push('ai ' + id + ' kich ban ' + m.Script.split('.').pop() + ' khong co trong DLL');
      }
    }
    dong.dk.push({ dk: vi, en, script, clientHien, ai, ok: !loi.length, loi });
  }
  ketqua.push(dong);
}
for (const d of ketqua) {
  const tt = d.dk.map(x => (x.ok ? '+' : 'X') + x.dk + (x.clientHien ? '' : '(an)')).join(' ');
  console.log(`${String(d.id).padStart(3)} T${d.type} ord=${d.ordering} ${d.client ? 'client' : 'KHONG-client'}  ${d.ten.padEnd(28).slice(0, 28)} ${tt}`);
  for (const x of d.dk) if (!x.ok) console.log('        ' + x.dk + ': ' + x.loi.slice(0, 4).join('; ') + (x.loi.length > 4 ? ' ...(+' + (x.loi.length - 4) + ')' : ''));
}
if (out) fs.writeFileSync(out, JSON.stringify(ketqua, null, 1));
