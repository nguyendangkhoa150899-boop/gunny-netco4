// vanut.js <vao.swf> <ra.swf> [--ghi]
// Doi cho nut Xac nhan / Huy trong BaseAlerFrame (Gunny client): o nhanh mac dinh (co ca 2 nut, khong customPos)
//   _submitButton.x = (_width - sub.w - can.w - gap)/2 ; _cancelButton.x = sub.x + sub.w + gap
// doi cheo moi tham chieu _submitButton <-> _cancelButton trong doan do -> Huy ben trai, Xac nhan ben phai.
// Khong --ghi: chi in ma truoc/sau.
const fs = require('fs'), zlib = require('zlib');
const [, , vao, ra, ghi] = process.argv;
const raw = fs.readFileSync(vao);
if (raw.toString('latin1', 0, 3) !== 'CWS') throw new Error('khong phai CWS');
const swf = Buffer.concat([raw.slice(0, 8), zlib.inflateSync(raw.slice(8))]);

// ---- tim DoABC2 ten BaseAlerFrame
const nbits = swf[8] >> 3; let p = 8 + Math.ceil((5 + nbits * 4) / 8) + 4; let abcAt = -1, abcEnd = -1;
while (p < swf.length) {
  const h = swf.readUInt16LE(p); p += 2; const code = h >> 6; let l = h & 0x3f;
  if (l === 0x3f) { l = swf.readUInt32LE(p); p += 4; }
  if (code === 82) {
    let e = swf.indexOf(0, p + 4); const name = swf.toString('latin1', p + 4, e);
    if (name === 'com/pickgliss/ui/controls/alert/BaseAlerFrame') { abcAt = e + 1; abcEnd = p + l; }
  }
  if (code === 0) break; p += l;
}
if (abcAt < 0) throw new Error('khong thay BaseAlerFrame');

// ---- doc ABC
let q = abcAt;
const u8 = () => swf[q++];
const u30 = () => { let r = 0, s = 0, b; do { b = swf[q++]; r |= (b & 0x7f) << s; s += 7; } while (b & 0x80 && s < 35); return r >>> 0; };
q += 4; // version
const n1 = u30(); for (let i = 1; i < n1; i++) u30();
const n2 = u30(); for (let i = 1; i < n2; i++) u30();
const n3 = u30(); q += Math.max(0, n3 - 1) * 8;
const strs = ['']; const ns = u30(); for (let i = 1; i < ns; i++) { const l = u30(); strs.push(swf.toString('utf8', q, q + l)); q += l; }
const nn = u30(); for (let i = 1; i < nn; i++) { u8(); u30(); }
const nss = u30(); for (let i = 1; i < nss; i++) { const c = u30(); for (let j = 0; j < c; j++) u30(); }
const mnName = [null]; const nm = u30();
for (let i = 1; i < nm; i++) {
  const k = u8();
  if (k === 0x07 || k === 0x0D) { u30(); mnName.push(strs[u30()]); }
  else if (k === 0x0F || k === 0x10) mnName.push(strs[u30()]);
  else if (k === 0x11 || k === 0x12) mnName.push(null);
  else if (k === 0x09 || k === 0x0E) { mnName.push(strs[u30()]); u30(); }
  else if (k === 0x1B || k === 0x1C) { u30(); mnName.push(null); }
  else if (k === 0x1D) { u30(); const c = u30(); for (let j = 0; j < c; j++) u30(); mnName.push(null); }
  else throw new Error('multiname kind ' + k);
}
const nmeth = u30();
for (let i = 0; i < nmeth; i++) {
  const pc = u30(); u30(); for (let j = 0; j < pc; j++) u30(); u30(); const fl = u8();
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
const bodies = []; const nb = u30();
for (let i = 0; i < nb; i++) {
  u30(); u30(); u30(); u30(); u30(); const cl = u30(); bodies.push({ at: q, len: cl }); q += cl;
  const ec = u30(); for (let j = 0; j < ec * 5; j++) u30(); traits();
}
if (q !== abcEnd) throw new Error('doc ABC lech: ' + q + ' != ' + abcEnd);

// ---- giai ma lenh
const U30 = new Set([0x04, 0x05, 0x06, 0x08, 0x25, 0x2c, 0x2d, 0x2e, 0x2f, 0x31, 0x40, 0x41, 0x42, 0x49, 0x53, 0x55, 0x56, 0x58, 0x59, 0x5a, 0x5d, 0x5e, 0x5f, 0x60, 0x61, 0x62, 0x63, 0x66, 0x68, 0x6a, 0x6c, 0x6d, 0x6e, 0x6f, 0x80, 0x86, 0xb2, 0x92, 0x94, 0xc2, 0xc3, 0xf0, 0xf1, 0xf2]);
const U30x2 = new Set([0x32, 0x43, 0x44, 0x45, 0x46, 0x4a, 0x4c, 0x4e, 0x4f]);
const MN = new Set([0x04, 0x05, 0x59, 0x5d, 0x5e, 0x60, 0x61, 0x66, 0x68, 0x6a, 0x80, 0x86, 0xb2, 0x45, 0x46, 0x4a, 0x4c, 0x4e, 0x4f]);
const TEN = { 0x60: 'getlex', 0x61: 'setproperty', 0x66: 'getproperty', 0x68: 'initproperty', 0x46: 'callproperty', 0x4f: 'callpropvoid', 0xd0: 'getlocal0', 0x10: 'jump', 0x11: 'iftrue', 0x12: 'iffalse', 0xa0: 'add', 0xa1: 'subtract', 0xa3: 'divide', 0x24: 'pushbyte', 0x20: 'pushnull', 0x14: 'ifne', 0x13: 'ifeq', 0x75: 'convert_d', 0x29: 'pop', 0x2a: 'dup', 0x47: 'returnvoid', 0x96: 'not', 0x76: 'convert_b', 0xab: 'equals' };
function dis(at, len) {
  const out = []; q = at;
  while (q < at + len) {
    const o = q, op = u8(); let a = [];
    if (U30.has(op)) a = [{ v: u30(), p: o + 1 }];
    else if (U30x2.has(op)) { const p1 = q; const v1 = u30(); a = [{ v: v1, p: p1 }, { v: u30() }]; }
    else if (op >= 0x0c && op <= 0x1a) { a = [{ v: swf.readIntLE(q, 3) }]; q += 3; }
    else if (op === 0x24 || op === 0x65) a = [{ v: u8() }];
    else if (op === 0x1b) { q += 3; const c = u30(); q += 3 * (c + 1); }
    else if (op === 0xef) { u8(); u30(); u8(); u30(); }
    out.push({ o, op, a, end: q, mn: MN.has(op) ? a[0].v : null });
  }
  return out;
}
const tenMn = i => mnName[i] || '#' + i;
const body = bodies.find(b => { const ins = dis(b.at, b.len); const s = new Set(ins.filter(x => x.mn).map(x => tenMn(x.mn))); return s.has('customPos') && s.has('buttonGape') && s.has('_submitButton'); });
if (!body) throw new Error('khong thay ham dat vi tri nut');
const ins = dis(body.at, body.len);
const setX = ins.map((x, i) => [x, i]).filter(([x]) => x.op === 0x61 && tenMn(x.mn) === 'x').map(([, i]) => i);
if (setX.length < 4) throw new Error('chi co ' + setX.length + ' lenh set x');
const tu = setX[setX.length - 3] + 1, den = setX[setX.length - 1];
const sub = [...new Set(ins.slice(tu, den + 1).filter(x => tenMn(x.mn) === '_submitButton').map(x => x.mn))];
const can = [...new Set(ins.slice(tu, den + 1).filter(x => tenMn(x.mn) === '_cancelButton').map(x => x.mn))];
if (sub.length !== 1 || can.length !== 1) throw new Error('mn submit/cancel khong duy nhat: ' + sub + ' / ' + can);
const enc = v => { const b = []; do { let c = v & 0x7f; v >>>= 7; if (v) c |= 0x80; b.push(c); } while (v); return Buffer.from(b); };
const eS = enc(sub[0]), eC = enc(can[0]);
if (eS.length !== eC.length) throw new Error('do dai u30 khac nhau, khong va tai cho duoc');
const in1 = () => ins.slice(tu, den + 1).map(x => '  ' + (TEN[x.op] || '0x' + x.op.toString(16)) + (x.mn ? ' ' + tenMn(x.mn) : x.a.length ? ' ' + x.a.map(y => y.v).join(',') : '')).join('\n');
console.log(vao.split(/[\\/]/).pop(), '| ham dai', body.len, 'B | doan lenh', tu, '..', den, '| mn submit', sub[0], 'cancel', can[0]);
console.log('TRUOC:\n' + in1());
let doi = 0;
for (const x of ins.slice(tu, den + 1)) {
  if (x.mn === sub[0]) { eC.copy(swf, x.a[0].p); x.mn = can[0]; doi++; }
  else if (x.mn === can[0]) { eS.copy(swf, x.a[0].p); x.mn = sub[0]; doi++; }
}
console.log('SAU (doi ' + doi + ' tham chieu):\n' + in1());
if (ghi === '--ghi') {
  const out = Buffer.concat([swf.slice(0, 8), zlib.deflateSync(swf.slice(8), { level: 9 })]);
  fs.writeFileSync(ra, out);
  console.log('Da ghi', ra, out.length, 'B (goc', raw.length, 'B)');
}
