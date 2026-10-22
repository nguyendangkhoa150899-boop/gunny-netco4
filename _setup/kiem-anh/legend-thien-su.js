// Client cung so voi _setup/sql/legend-thien-su.sql: LEGEND-Thien Su Ban Phuc (17017) Property1 = dan (ball), Property7 = luong hoi mau.
//   node legend-thien-su.js <Request dir> [ball, mac dinh 98] [hoi, mac dinh 3000]      (hoan tac: 298 900)
const fs = require('fs'), zlib = require('zlib');
const p = process.argv[2] + '/TemplateAlllist.xml', ball = +(process.argv[3] || 98), hoi = +(process.argv[4] || 3000);
let x = zlib.inflateSync(fs.readFileSync(p)).toString('utf8'), n = 0;
x = x.replace(/<Item [^>]*TemplateID="17017"[^>]*>/, t => {
  n++;
  return t.replace(/ Property1="\d+"/, ` Property1="${ball}"`).replace(/ Property7="\d+"/, ` Property7="${hoi}"`);
});
if (n !== 1) throw new Error('khong thay 17017');
fs.writeFileSync(p, zlib.deflateSync(Buffer.from(x, 'utf8')));
console.log('17017: Property1 = ' + ball + ', Property7 = ' + hoi);
