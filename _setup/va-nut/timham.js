// timham.js <swf> <ten DoABC, vd store/forge/ForgeMainView> <ten ham trong ABC, vd store.forge:ForgeMainView/changeHandler>
// In chi so method body (methodBodyIndex cho "ffdec-cli -replace ... <file.pcode> <index>") cua ham trong tag DoABC do.
const fs = require('fs'), zlib = require('zlib');
const [, , vao, abcTen, hamTen] = process.argv;
const raw = fs.readFileSync(vao);
const swf = raw.toString('latin1', 0, 3) === 'CWS' ? Buffer.concat([raw.slice(0, 8), zlib.inflateSync(raw.slice(8))]) : raw;
const nbits = swf[8] >> 3; let p = 8 + Math.ceil((5 + nbits * 4) / 8) + 4; let abcAt = -1;
while (p < swf.length) {
  const h = swf.readUInt16LE(p); p += 2; const code = h >> 6; let l = h & 0x3f;
  if (l === 0x3f) { l = swf.readUInt32LE(p); p += 4; }
  if (code === 82) { const e = swf.indexOf(0, p + 4); if (swf.toString('latin1', p + 4, e) === abcTen) abcAt = e + 1; }
  if (code === 0) break; p += l;
}
if (abcAt < 0) throw new Error('khong thay DoABC ' + abcTen);
let q = abcAt;
const u8 = () => swf[q++];
const u30 = () => { let r = 0, s = 0, b; do { b = swf[q++]; r |= (b & 0x7f) << s; s += 7; } while (b & 0x80 && s < 35); return r >>> 0; };
q += 4;
const n1 = u30(); for (let i = 1; i < n1; i++) u30();
const n2 = u30(); for (let i = 1; i < n2; i++) u30();
const n3 = u30(); q += Math.max(0, n3 - 1) * 8;
const strs = ['']; const ns = u30(); for (let i = 1; i < ns; i++) { const l = u30(); strs.push(swf.toString('utf8', q, q + l)); q += l; }
const nn = u30(); for (let i = 1; i < nn; i++) { u8(); u30(); }
const nss = u30(); for (let i = 1; i < nss; i++) { const c = u30(); for (let j = 0; j < c; j++) u30(); }
const nm = u30();
for (let i = 1; i < nm; i++) {
  const k = u8();
  if (k === 0x07 || k === 0x0D) { u30(); u30(); }
  else if (k === 0x0F || k === 0x10) u30();
  else if (k === 0x11 || k === 0x12) { }
  else if (k === 0x09 || k === 0x0E) { u30(); u30(); }
  else if (k === 0x1B || k === 0x1C) u30();
  else if (k === 0x1D) { u30(); const c = u30(); for (let j = 0; j < c; j++) u30(); }
  else throw new Error('multiname kind ' + k);
}
const ten = []; const nmeth = u30();
for (let i = 0; i < nmeth; i++) {
  const pc = u30(); u30(); for (let j = 0; j < pc; j++) u30(); ten.push(strs[u30()]); const fl = u8();
  if (fl & 0x08) { const oc = u30(); for (let j = 0; j < oc; j++) { u30(); u8(); } }
  if (fl & 0x80) for (let j = 0; j < pc; j++) u30();
}
const nmeta = u30(); for (let i = 0; i < nmeta; i++) { u30(); const c = u30(); for (let j = 0; j < c * 2; j++) u30(); }
function traits() {
  const c = u30();
  for (let i = 0; i < c; i++) {
    u30(); const k = u8(), t = k & 0x0f;
    if (t === 0 || t === 6) { u30(); u30(); const v = u30(); if (v) u8(); }
    else if (t >= 1 && t <= 5) { u30(); u30(); }
    else throw new Error('trait kind ' + t);
    if ((k >> 4) & 0x04) { const m = u30(); for (let j = 0; j < m; j++) u30(); }
  }
}
const ncls = u30();
for (let i = 0; i < ncls; i++) { u30(); u30(); const f = u8(); if (f & 0x08) u30(); const ic = u30(); for (let j = 0; j < ic; j++) u30(); u30(); traits(); }
for (let i = 0; i < ncls; i++) { u30(); traits(); }
const nscr = u30(); for (let i = 0; i < nscr; i++) { u30(); traits(); }
const nb = u30();
for (let i = 0; i < nb; i++) {
  const m = u30(); u30(); u30(); u30(); u30(); const cl = u30(); q += cl;
  const ec = u30(); for (let j = 0; j < ec * 5; j++) u30(); traits();
  if (!hamTen || ten[m] === hamTen) console.log(`body ${i}  method ${m}  ${ten[m]}  (${cl} byte)`);
}
