// Them ky nang thu cung con thieu vao XML client (22/10/2026).
// Loi: petskilltemplateinfo.xml cho 13 loai pet (Ton Ngo Khong, Xanh biec...) dung 207 ky nang KHONG CO trong petskillinfo.xml
//   (client 229 ky nang, DB Pet_Skill_Info 1.461) -> client ra anh "image/petskill/null", ket loading 98% khi vao tran chung
//   voi nguoi mang pet do (vu Dau / PeXuanMai mang Ton Ngo Khong, 22/10).
// Khong dung lai tu DB (DB chi co 211/229 ky nang client dang co -> mat 18): GIU NGUYEN file cu, chi chen dong con thieu truoc </Result>.
//   node them-ky-nang-pet.js <export.txt> <Request dir>
// export.txt: ket qua sqlcmd -u (UTF-16) cua xuat-ky-nang-pet.sql: phan ky nang "<item .../>..." + "@@@" + phan nguyen to.
// Chay lai an toan: dong da co ID thi bo qua.
const fs = require('fs');
const [exp, dir] = process.argv.slice(2);
const raw = fs.readFileSync(exp);
const t = (raw[0] === 0xFF ? raw.toString('utf16le') : raw.toString('utf8')).replace(/^﻿/, '');
const [phanSkill, phanEl] = t.split('@@@');
const items = s => [...s.matchAll(/<item [^>]*\/>/g)].map(m => m[0]);
const idCua = s => (s.match(/ ID="(\d+)"/) || [])[1];

function chen(file, moi, chiLay) {
  const p = dir + '/' + file;
  const cu = fs.readFileSync(p, 'utf8');
  const co = new Set([...cu.matchAll(/<item [^>]*?\bID="(\d+)"/gi)].map(m => m[1]));
  const them = moi.filter(x => !co.has(idCua(x)) && (!chiLay || chiLay.has(idCua(x))))
    .map(x => '  ' + x.replace(/\/>$/, ' />'));
  if (!them.length) { console.log(file + ': khong co gi them'); return new Set(); }
  const i = cu.lastIndexOf('</Result>');
  if (i < 0) throw new Error(file + ': khong thay </Result>');
  fs.writeFileSync(p, cu.slice(0, i) + them.join('\n') + '\n' + cu.slice(i));
  console.log(`${file}: ${co.size} -> ${co.size + them.length} dong (+${them.length})`);
  return new Set(them.map(idCua));
}

const skills = items(phanSkill);
chen('petskillinfo.xml', skills);
// chi them nguyen to ma cac ky nang moi can, khong do ca bang DB vao
const can = new Set();
for (const s of skills) ((s.match(/ ElementIDs="([^"]*)"/) || [])[1] || '').split(',').filter(Boolean).forEach(e => can.add(e));
chen('petskillelementinfo.xml', items(phanEl), can);
