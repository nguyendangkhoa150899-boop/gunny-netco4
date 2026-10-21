// Client cung quy tac voi _setup/sql/pet-ky-nang-rieng.sql: 4 loai pet hiem (KindID 19,20,22,23) dung ma ky nang rieng
// = 90000 + KindID*100 + ma cu (ma cu 1..99).  node pet-ky-nang-rieng.js <Request dir>   (chay lai an toan)
const fs = require('fs');
const dir = process.argv[2];
const KIND = [19, 20, 22, 23];
const moi = (k, s) => (s >= 1 && s <= 99 ? 90000 + k * 100 + s : s);

// 1. petskilltemplateinfo.xml: doi SkillID + DeleteSkillIDs cua 4 loai
const pt = dir + '/petskilltemplateinfo.xml';
let x = fs.readFileSync(pt, 'utf8'); const can = new Map(); let n1 = 0;
x = x.replace(/<item [^>]*>/gi, t => {
  const k = +(t.match(/ KindID="(\d+)"/) || [])[1];
  if (!KIND.includes(k)) return t;
  const s = +(t.match(/ SkillID="(\d+)"/) || [])[1];
  if (!(s >= 1 && s <= 99)) return t;
  can.set(moi(k, s), s); n1++;
  return t.replace(/ SkillID="\d+"/, ` SkillID="${moi(k, s)}"`)
    .replace(/ DeleteSkillIDs="([^"]*)"/, (m, d) => ` DeleteSkillIDs="${d.split(',').map(v => v === '' ? v : String(moi(k, +v))).join(',')}"`);
});
fs.writeFileSync(pt, x);

// 2. petskillinfo.xml: them ban sao ky nang voi ID moi (chep dong cua ma cu)
const pi = dir + '/petskillinfo.xml';
let y = fs.readFileSync(pi, 'utf8');
const dong = {}; for (const m of y.matchAll(/<item [^>]*\/>/gi)) dong[(m[0].match(/ ID="(\d+)"/) || [])[1]] = m[0];
const them = [];
for (const [id, cu] of [...can.entries()].sort((a, b) => a[0] - b[0])) {
  if (dong[id]) continue;
  if (!dong[cu]) { console.log('THIEU ky nang goc ' + cu + ' trong client, bo qua ' + id); continue; }
  them.push('  ' + dong[cu].replace(/ ID="\d+"/, ` ID="${id}"`));
}
if (them.length) { const i = y.lastIndexOf('</Result>'); y = y.slice(0, i) + them.join('\n') + '\n' + y.slice(i); fs.writeFileSync(pi, y); }
console.log(`petskilltemplateinfo: doi ${n1} dong | petskillinfo: them ${them.length} ky nang`);
