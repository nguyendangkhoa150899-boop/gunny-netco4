// Ap ban dich tieng Viet (tu-dien.json {chu Hoa: tieng Viet}) vao XML client + sinh SQL cap nhat DB cung noi dung.
//   node ap-ban-dich.js <tu-dien.json> <Request dir> <out.sql>
// XML: chi thay GIA TRI thuoc tinh trung khop nguyen chuoi voi khoa (khoa la chuoi tho trong XML, co the chua &quot;...).
// Giu kieu nen cua tung file (zlib hay khong). SQL: UPDATE ... WHERE cot = N'<chu Hoa>' (chi dong dang la tieng Hoa).
const fs = require('fs'), zlib = require('zlib');
const [dictF, dir, sqlF] = process.argv.slice(2);
const dict = JSON.parse(fs.readFileSync(dictF, 'utf8'));
const FILES = ['TemplateAlllist.xml', 'loadallquestions.xml', 'LoadMapsItems.xml', 'QuestList.xml', 'petskillinfo.xml', 'petskillelementinfo.xml'];
const escAttr = s => s.replace(/&(?!(amp|lt|gt|quot|apos|#\d+|#x[0-9a-fA-F]+);)/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
const decode = s => s.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&apos;/g, "'").replace(/&#xD;/gi, '\r').replace(/&#xA;/gi, '\n').replace(/&#(\d+);/g, (m, n) => String.fromCharCode(+n)).replace(/&amp;/g, '&');
const HAN = /[㐀-鿿]/;
const dung = {};   // file -> {thuoc tinh -> Set(chu Hoa)} da thay, de sinh SQL
for (const f of FILES) {
  const p = dir + '/' + f, buf = fs.readFileSync(p);
  let xml, nen = true;
  try { xml = zlib.inflateSync(buf).toString('utf8'); } catch (e) { xml = buf.toString('utf8'); nen = false; }
  let doi = 0, conHoa = 0; dung[f] = {};
  xml = xml.replace(/<[A-Za-z]+ [^>]*>/g, tag => tag.replace(/ (\w+)="([^"]*)"/g, (m, k, v) => {
    if (!HAN.test(v)) return m;
    const vi = dict[v];
    if (vi === undefined) { conHoa++; return m; }
    doi++; (dung[f][k] = dung[f][k] || new Set()).add(v);
    return ` ${k}="${escAttr(vi)}"`;
  }));
  fs.writeFileSync(p, nen ? zlib.deflateSync(Buffer.from(xml, 'utf8')) : xml);
  console.log(`${f.padEnd(26)} thay ${doi} gia tri, con chu Hoa ${conHoa} (${nen ? 'zlib' : 'thuong'})`);
}
// SQL cho DB (bang/cot tuong ung), chi cac chuoi da thay trong XML
const DB = [
  ['TemplateAlllist.xml', 'Name', 'Db_Tank.dbo.Shop_Goods', 'Name'], ['TemplateAlllist.xml', 'Description', 'Db_Tank.dbo.Shop_Goods', 'Description'],
  ['QuestList.xml', 'Title', 'Db_Tank.dbo.Quest', 'Title'], ['QuestList.xml', 'Detail', 'Db_Tank.dbo.Quest', 'Detail'],
  ['petskillinfo.xml', 'Name', 'Db_Tank.dbo.Pet_Skill_Info', 'Name'], ['petskillinfo.xml', 'Description', 'Db_Tank.dbo.Pet_Skill_Info', 'Description'],
  ['petskillelementinfo.xml', 'Name', 'Db_Tank.dbo.Pet_Skill_Element_Info', 'Name'], ['petskillelementinfo.xml', 'Description', 'Db_Tank.dbo.Pet_Skill_Element_Info', 'Description'],
];
const q = s => "N'" + s.replace(/'/g, "''") + "'";
const sql = ['-- sinh boi _setup/kiem-anh/ap-ban-dich.js: dich chu Hoa -> tieng Viet trong DB (cung noi dung XML client). Chay lai an toan.', 'SET NOCOUNT ON;', 'DECLARE @n int = 0;'];
for (const [f, a, bang, cot] of DB) for (const zh of (dung[f][a] || [])) {
  // cot ntext (Description/Detail) khong so sanh = duoc -> CAST
  sql.push(`UPDATE ${bang} SET ${cot} = ${q(decode(dict[zh]))} WHERE CAST(${cot} AS nvarchar(4000)) = ${q(decode(zh))}; SET @n += @@ROWCOUNT;`);
}
sql.push("PRINT N'So dong DB da dich: ' + CAST(@n AS nvarchar(10));");
fs.writeFileSync(sqlF, sql.join('\n') + '\n');
console.log('SQL: ' + (sql.length - 4) + ' cau -> ' + sqlF);
