// Mo phó ban dang an tren client: dat Ordering trong Request/LoadPVEItems.xml (file nen zlib). Client chi hien phó ban Ordering >= 1.
//   node mo-pho-ban-client.js <Request dir>        (chay lai an toan; khop voi _setup/sql/mo-het-pho-ban.sql)
const fs = require('fs'), zlib = require('zlib');
const p = process.argv[2] + '/LoadPVEItems.xml';
const MO = { 12: 8, 18: 13, 19: 14, 20: 15, 33: 16 };   // ID -> Ordering
const buf = fs.readFileSync(p);
let xml, nen = true;
try { xml = zlib.inflateSync(buf).toString('utf8'); } catch (e) { xml = buf.toString('utf8'); nen = false; }
let doi = 0;
xml = xml.replace(/<Item [^>]*>/g, tag => {
  const id = (tag.match(/ ID="(\d+)"/) || [])[1];
  if (!(id in MO)) return tag;
  const moi = tag.replace(/ Ordering="[^"]*"/, ` Ordering="${MO[id]}"`);
  if (moi !== tag) doi++;
  return moi;
});
fs.writeFileSync(p, nen ? zlib.deflateSync(Buffer.from(xml, 'utf8')) : xml);
console.log(`LoadPVEItems.xml: doi Ordering ${doi} phó ban (${nen ? 'nen zlib' : 'khong nen'})`);
