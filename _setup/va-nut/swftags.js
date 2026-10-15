// swftags.js <file> : liet ke tag (ma, kich thuoc), DefineBinaryData thi in 16 byte dau
const fs = require('fs'), zlib = require('zlib');
const raw = fs.readFileSync(process.argv[2]);
const b = raw.toString('latin1', 0, 3) === 'CWS' ? Buffer.concat([raw.slice(0, 8), zlib.inflateSync(raw.slice(8))]) : raw;
const nbits = b[8] >> 3; let p = 8 + Math.ceil((5 + nbits * 4) / 8) + 4;
const dem = {};
while (p < b.length) {
  const h = b.readUInt16LE(p); p += 2; const code = h >> 6; let l = h & 0x3f;
  if (l === 0x3f) { l = b.readUInt32LE(p); p += 4; }
  dem[code] = (dem[code] || 0) + 1;
  if (code === 87) { const id = b.readUInt16LE(p); console.log('BinaryData id', id, 'len', l - 6, 'dau:', b.slice(p + 6, p + 22).toString('hex'), JSON.stringify(b.slice(p + 6, p + 22).toString('latin1'))); }
  if (code === 82) { const e = b.indexOf(0, p + 4); console.log('DoABC', JSON.stringify(b.toString('latin1', p + 4, e)), 'len', l); }
  if (code === 76) { const n = b.readUInt16LE(p); let q = p + 2; const s = []; for (let i = 0; i < n; i++) { q += 2; const e = b.indexOf(0, q); s.push(b.toString('latin1', q, e)); q = e + 1; } console.log('SymbolClass', s.join(', ').slice(0, 300)); }
  if (code === 0) break; p += l;
}
console.log('dem tag:', JSON.stringify(dem));
