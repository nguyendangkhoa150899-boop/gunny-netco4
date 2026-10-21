// Tach chuoi tieng Hoa trong code server: chuoi dung lam KHOA cua LanguageMgr.GetTranslation("...") ma Language-vn.txt chua co
// (in thang chu Hoa ra game), va chuoi viet cung (khong qua file ngon ngu, phai va DLL moi doi duoc).
//   node khoa-ngon-ngu.js <han-server.json tu quet-chu-hoa.js> <gameSrc> <Language-vn.txt> <dll1,dll2,...> <out.json>
// Chi giu chuoi CO trong DLL dang chay (tim theo UTF-16 trong file DLL).
const fs = require('fs'), path = require('path');
const [jsonIn, src, langFile, dlls, out] = process.argv.slice(2);
const kq = JSON.parse(fs.readFileSync(jsonIn, 'utf8'));
const lang = new Set(fs.readFileSync(langFile, 'utf8').replace(/^\uFEFF/, '').split(/\r?\n/)
  .filter(l => !l.startsWith('#') && l.includes(':')).map(l => l.slice(0, l.indexOf(':'))));
const bin = dlls.split(',').map(f => fs.readFileSync(f));
const coTrongDll = s => { const u = Buffer.from(s, 'utf16le'); return bin.some(b => b.indexOf(u) >= 0); };
const unesc = s => s.replace(/\\(["\\nrt])/g, (m, c) => ({ n: '\n', r: '\r', t: '\t' }[c] || c));
const khoa = new Map(), cung = new Map(); let boQua = 0;
for (const x of kq) {
  const dong = fs.readFileSync(path.join(src, x.f), 'utf8').split(/\r?\n/)[x.d - 1] || '';
  const s = unesc(x.s);
  if (!coTrongDll(s)) { boQua++; continue; }
  const laKhoa = new RegExp('GetTranslation\\(\\s*"' + x.s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '"').test(dong);
  const m = laKhoa ? khoa : cung;
  if (!m.has(s)) m.set(s, { s, f: x.f, d: x.d, coTrongFile: lang.has(s) });
}
const thieu = [...khoa.values()].filter(k => !k.coTrongFile);
console.log(`khoa GetTranslation tieng Hoa: ${khoa.size} (file ngon ngu da co ${khoa.size - thieu.length}, THIEU ${thieu.length})`);
console.log(`chuoi viet cung (khong qua file ngon ngu): ${cung.size} | bo qua (khong co trong DLL dang chay): ${boQua}`);
fs.writeFileSync(out, JSON.stringify({ thieu: thieu.map(k => ({ s: k.s, f: k.f + ':' + k.d })), cung: [...cung.values()].map(k => ({ s: k.s, f: k.f + ':' + k.d })) }, null, 1));
