// Tach chuoi tieng Hoa (khong trung) trong cac XML client can dich -> JSON {file: {thuoc tinh: [chuoi]}}
//   node tach-chu-hoa.js <Request dir> <out.json>
const fs = require('fs'), zlib = require('zlib');
const [dir, out] = process.argv.slice(2);
const HAN = /[㐀-鿿]/;
const FILES = ['TemplateAlllist.xml', 'loadallquestions.xml', 'LoadMapsItems.xml', 'QuestList.xml', 'petskillinfo.xml', 'petskillelementinfo.xml'];
const rd = f => { const b = fs.readFileSync(f); try { return zlib.inflateSync(b).toString('utf8'); } catch (e) { return b.toString('utf8'); } };
const kq = {}; let tong = 0;
for (const f of FILES) {
  const x = rd(dir + '/' + f); const m = {};
  for (const t of x.matchAll(/<[A-Za-z]+ [^>]*>/g))
    for (const a of t[0].matchAll(/ (\w+)="([^"]*)"/g))
      if (HAN.test(a[2])) (m[a[1]] = m[a[1]] || new Set()).add(a[2]);
  kq[f] = {}; for (const [k, v] of Object.entries(m)) { kq[f][k] = [...v]; tong += v.size; }
  console.log(f.padEnd(26), Object.entries(kq[f]).map(([k, v]) => k + ':' + v.length).join('  '));
}
console.log('tong chuoi khong trung: ' + tong);
fs.writeFileSync(out, JSON.stringify(kq, null, 1));
