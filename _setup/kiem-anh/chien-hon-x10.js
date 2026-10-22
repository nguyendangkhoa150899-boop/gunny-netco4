// Client cung so voi _setup/sql/chien-hon-x10.sql: "Chien hon don" (100100) Property2 + mo ta.
//   node chien-hon-x10.js <Request dir> [exp, mac dinh 100]      (hoan tac: tham so 10)
const fs = require('fs'), zlib = require('zlib');
const p = process.argv[2] + '/TemplateAlllist.xml', exp = +(process.argv[3] || 100);
let x = zlib.inflateSync(fs.readFileSync(p)).toString('utf8'), n = 0;
x = x.replace(/<Item [^>]*TemplateID="100100"[^>]*>/, t => {
  n++;
  return t.replace(/ Property2="\d+"/, ` Property2="${exp}"`).replace(/ Description="[^"]*"/, ` Description="Tăng ${exp} EXP chiến hồn"`);
});
if (n !== 1) throw new Error('khong thay 100100');
fs.writeFileSync(p, zlib.deflateSync(Buffer.from(x, 'utf8')));
console.log('100100: Property2 = ' + exp);
