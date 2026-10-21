// Kiem do nao vao game KHONG CO HINH: mo phong dung PathManager.solveGoodsPath cua client (icon trong tui)
// roi doi chieu voi danh sach file that tren Resource.Server.
//   node kiem-anh.js <Request dir> <resfiles.txt> [out.json]
// resfiles.txt: moi dong 1 duong dan "image/..." (tao tren VPS bang lenh trong README muc 28).
// Trung (CategoryID 35): con kiem thu cung ben trong (Property5) co trong pettemplateinfo.xml va co anh image/pet/<Pic>/icon1.png.
const fs = require('fs'), zlib = require('zlib');
const [dir, resList, out] = process.argv.slice(2);
const rd = f => { const b = fs.readFileSync(f); try { return zlib.inflateSync(b).toString('utf8'); } catch (e) { return b.toString('utf8'); } };
const attrs = t => { const o = {}; for (const m of t.matchAll(/ (\w+)="([^"]*)"/g)) o[m[1]] = m[2]; return o; };
const co = new Set(fs.readFileSync(resList, 'utf8').split(/\r?\n/).filter(Boolean).map(s => s.toLowerCase()));

const TYPES = ['', 'head', 'glass', 'hair', 'eff', 'cloth', 'face', 'arm', 'armlet', 'ring', '', '', '', 'suits', 'necklace', 'wing', 'chatBall', '', '', '', '', '', '', '', '', '', '', '', 'armlet', 'ring'];
// = PathManager.solveGoodsPath(cat, pic, NeedSex == 1, "icon", "A", "1") cua client (IconLayer)
function duongDan(cat, pic, needSex) {
  if (cat === 7 || cat === 27) return `image/arm/${pic}/1/icon.png`;
  if ([11, 24, 65, 68, 69, 72].includes(cat)) return `image/unfrightprop/${pic}/icon.png`;
  if (cat === 12) return `image/task/${pic}/icon.png`;
  if (cat === 16) return `image/specialprop/chatBall/${pic}/icon.png`;
  if (cat < 10 || [13, 14, 28, 29].includes(cat)) {
    const t = TYPES[cat] + '/';
    if ([8, 9, 14, 28, 29].includes(cat)) return `image/equip/${t}${pic}/icon.png`;
    return `image/equip/${needSex === 1 ? 'm' : 'f'}/${t}${pic}/icon_1.png`;
  }
  if (cat === 15) return `image/equip/wing/${pic}/icon.png`;
  if (cat === 17 || cat === 31) return `image/equip/offhand/${pic}/icon.png`;
  if (cat === 25) return `image/gift/${pic}/icon.png`;
  if (cat === 26) return `image/card/${pic}/icon.jpg`;
  if (cat === 18) return `image/cardbox/${pic}/icon.png`;
  if (cat === 19) return `image/equip/recover/${pic}/icon.png`;
  if ([20, 23, 30, 40].includes(cat)) return `image/unfrightprop/${pic}/icon.png`;
  if (cat === 32 || cat === 36) return `image/farm/Crops/${pic}/seed.png`;
  if (cat === 33) return `image/farm/Fertilizer/${pic}/icon.png`;
  if (cat === 34 || cat === 35) return `image/unfrightprop/${pic}/icon.png`;
  if (cat === 52) return `image/petequip/cloth/${pic}/icon.png`;
  if (cat === 50) return `image/petequip/arm/${pic}/icon.png`;
  if (cat === 51) return `image/petequip/hat/${pic}/icon.png`;
  return `image/prop/${pic}/icon.png`;
}

const pets = {};
for (const m of rd(dir + '/pettemplateinfo.xml').matchAll(/<item [^>]*>/gi)) { const a = attrs(m[0]); pets[a.TemplateID] = a; }

const loi = {}; let tong = 0, hong = 0; const ds = [];
for (const m of rd(dir + '/TemplateAlllist.xml').matchAll(/<Item [^>]*>/g)) {
  const a = attrs(m[0]); const cat = +a.CategoryID, id = +a.TemplateID; tong++;
  const p = duongDan(cat, a.Pic, +a.NeedSex);
  let ly = null;
  if (!a.Pic || a.Pic === 'null' || !co.has(p.toLowerCase())) ly = 'thieu anh ' + p;
  else if (cat === 35) {
    const pet = pets[a.Property5];
    if (!pet) ly = 'trung: thu cung ' + a.Property5 + ' khong co trong pettemplateinfo.xml';
    else if (!co.has(`image/pet/${pet.Pic}/icon1.png`.toLowerCase())) ly = 'trung: thieu anh thu cung image/pet/' + pet.Pic + '/icon1.png';
  }
  if (ly) { hong++; (loi[cat] = loi[cat] || []).push(id); ds.push({ id, cat, ten: a.Name, ly }); }
}
console.log(`client co ${tong} mon, KHONG HIEN HINH / LOI: ${hong}`);
for (const [c, ids] of Object.entries(loi).sort((x, y) => y[1].length - x[1].length)) {
  const vd = ds.filter(d => d.cat === +c).slice(0, 2).map(d => d.id + ' ' + d.ten + ' (' + d.ly + ')').join(' | ');
  console.log(`  loai ${c}: ${ids.length}   vd ${vd}`);
}
if (out) fs.writeFileSync(out, JSON.stringify(ds.map(d => d.id)));
