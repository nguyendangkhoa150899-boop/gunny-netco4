// swfinfo.js <file...> : giai nen SWF (FWS/CWS), liet ke tag DoABC + co chuoi "BaseAlerFrame" khong
const fs = require('fs'), zlib = require('zlib');
function unpack(b) {
  const sig = b.toString('latin1', 0, 3);
  if (sig === 'FWS') return b;
  if (sig === 'CWS') return Buffer.concat([b.slice(0, 8), zlib.inflateSync(b.slice(8))]);
  return null; // ZWS (lzma) chua ho tro
}
for (const f of process.argv.slice(2)) {
  const raw = fs.readFileSync(f), b = unpack(raw);
  if (!b) { console.log(f, 'sig', raw.toString('latin1', 0, 3), 'khong giai duoc'); continue; }
  const ver = b[3], len = b.readUInt32LE(4);
  // bo qua RECT
  const nbits = b[8] >> 3, rectBytes = Math.ceil((5 + nbits * 4) / 8);
  let p = 8 + rectBytes + 4; const abcs = [];
  while (p < b.length) {
    const h = b.readUInt16LE(p); p += 2; const code = h >> 6; let l = h & 0x3f;
    if (l === 0x3f) { l = b.readUInt32LE(p); p += 4; }
    if (code === 82 || code === 72) {
      let q = p, name = '';
      if (code === 82) { q += 4; let e = b.indexOf(0, q); name = b.toString('latin1', q, e); q = e + 1; }
      abcs.push({ code, name, at: q, len: l - (q - p), has: b.slice(q, p + l).includes('BaseAlerFrame') });
    }
    if (code === 0) break;
    p += l;
  }
  console.log(f, raw.toString('latin1', 0, 3), 'v' + ver, 'len', len, 'DoABC:', abcs.length,
    'co BaseAlerFrame:', abcs.filter(a => a.has).map(a => `${a.name || '(khong ten)'}@${a.at} ${a.len}B`).join(', ') || 'khong');
}
