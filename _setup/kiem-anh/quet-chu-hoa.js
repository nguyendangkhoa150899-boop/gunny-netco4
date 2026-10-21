// Quet chuoi tieng Hoa trong ma nguon (khong tinh chu thich):  node quet-chu-hoa.js <thu muc> <duoi file, vd .cs|.as> [out.json]
// In: so chuoi theo thu muc con + vi du. Chuoi nam trong "..." co chu Han (U+4E00..U+9FFF) va khong nam sau //.
const fs = require('fs'), path = require('path');
const [goc, duoi, out] = process.argv.slice(2);
const HAN = /[㐀-鿿]/;
const kq = [];
(function quet(d) {
  for (const f of fs.readdirSync(d, { withFileTypes: true })) {
    const p = path.join(d, f.name);
    if (f.isDirectory()) { if (!/^(bin|obj|\.git)$/.test(f.name)) quet(p); continue; }
    if (!duoi.split('|').some(x => f.name.endsWith(x))) continue;
    const dong = fs.readFileSync(p, 'utf8').split(/\r?\n/);
    let trongChuThich = false;
    dong.forEach((l, i) => {
      let s = l;
      if (trongChuThich) { const e = s.indexOf('*/'); if (e < 0) return; s = s.slice(e + 2); trongChuThich = false; }
      s = s.replace(/\/\*.*?\*\//g, '');
      const b = s.indexOf('/*'); if (b >= 0) { trongChuThich = true; s = s.slice(0, b); }
      // bo phan sau // (khong nam trong chuoi, uoc luong)
      const cmt = s.search(/(^|[^:"'])\/\//); if (cmt >= 0) s = s.slice(0, cmt + 1);
      for (const m of s.matchAll(/"((?:[^"\\]|\\.)*)"/g)) if (HAN.test(m[1])) kq.push({ f: path.relative(goc, p).replace(/\\/g, '/'), d: i + 1, s: m[1] });
    });
  }
})(goc);
const nhom = {};
for (const x of kq) { const k = x.f.split('/').slice(0, 2).join('/'); (nhom[k] = nhom[k] || []).push(x); }
console.log('tong chuoi co chu Hoa: ' + kq.length + ' trong ' + new Set(kq.map(x => x.f)).size + ' file');
for (const [k, v] of Object.entries(nhom).sort((a, b) => b[1].length - a[1].length).slice(0, 25))
  console.log(String(v.length).padStart(5) + '  ' + k.padEnd(45) + ' vd: ' + v[0].s.slice(0, 60));
if (out) fs.writeFileSync(out, JSON.stringify(kq, null, 1));
