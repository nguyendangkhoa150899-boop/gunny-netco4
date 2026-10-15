// doixml.js <xml.png vao> <xml.png ra> <quetnut.json> [--ghi]
// Doi cho x cua moi cap style (Xac nhan, Huy) cung hang trong XML giao dien nam trong zip xml.png.
// Entry khong doi chep nguyen byte; entry doi nen lai (deflate) + cap nhat CRC/kich thuoc o local header va central directory.
const fs = require('fs'), zlib = require('zlib');
const [, , vao, ra, jf, ghi] = process.argv;
const z = fs.readFileSync(vao);
const CRC = (() => { const t = new Int32Array(256); for (let n = 0; n < 256; n++) { let c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1; t[n] = c; } return b => { let c = -1; for (const x of b) c = t[(c ^ x) & 255] ^ (c >>> 8); return (c ^ -1) >>> 0; }; })();
// --- doc central directory
const eocd = z.lastIndexOf(Buffer.from([0x50, 0x4b, 0x05, 0x06]));
const cdN = z.readUInt16LE(eocd + 10), cdOff = z.readUInt32LE(eocd + 16);
const ents = []; let p = cdOff;
for (let i = 0; i < cdN; i++) {
  if (z.readUInt32LE(p) !== 0x02014b50) throw new Error('CD hong');
  const e = { cd: p, flag: z.readUInt16LE(p + 8), method: z.readUInt16LE(p + 10), csize: z.readUInt32LE(p + 20), usize: z.readUInt32LE(p + 24),
    nlen: z.readUInt16LE(p + 28), xlen: z.readUInt16LE(p + 30), clen: z.readUInt16LE(p + 32), lho: z.readUInt32LE(p + 42) };
  e.name = z.toString('latin1', p + 46, p + 46 + e.nlen); e.cdLen = 46 + e.nlen + e.xlen + e.clen;
  const l = e.lho; if (z.readUInt32LE(l) !== 0x04034b50) throw new Error('LH hong ' + e.name);
  e.lhLen = 30 + z.readUInt16LE(l + 26) + z.readUInt16LE(l + 28);
  if (e.flag & 8) throw new Error('co data descriptor, khong ho tro: ' + e.name);
  ents.push(e); p += e.cdLen;
}
const data = e => { const c = z.slice(e.lho + e.lhLen, e.lho + e.lhLen + e.csize); return e.method === 8 ? zlib.inflateRawSync(c) : c; };
// --- cap can doi (gop theo style, bo trung)
const caps = new Map();
for (const r of JSON.parse(fs.readFileSync(jf, 'utf8'))) if (r.s === 'OK TRAI') caps.set(r.sOk + '|' + r.sNo, r);
const sua = {}; let dem = 0;
for (const r of caps.values()) {
  const e = ents.find(x => x.name.endsWith('/' + r.f) || x.name === r.f); if (!e) throw new Error('khong thay ' + r.f + ' trong zip');
  let t = sua[e.name] || data(e).toString('latin1');
  const doiX = (st, xMoi) => {
    const re = new RegExp('(<component\\b[^>]*?stylename="' + st.replace(/\./g, '\\.') + '"[^>]*?\\sx=")(-?[\\d.]+)(")');
    const m = re.exec(t); if (!m) throw new Error('khong thay ' + st);
    t = t.slice(0, m.index) + m[1] + xMoi + m[3] + t.slice(m.index + m[0].length);
  };
  doiX(r.sOk, r.xNo); doiX(r.sNo, r.xOk);
  sua[e.name] = t; dem++;
  console.log(e.name.padEnd(28), r.sOk, r.xOk, '->', r.xNo, '|', r.sNo, r.xNo, '->', r.xOk);
}
console.log('doi', dem, 'cap trong', Object.keys(sua).length, 'file');
if (ghi !== '--ghi') process.exit(0);
// --- ghi zip moi
const parts = [], cds = []; let off = 0;
for (const e of ents) {
  let lh = Buffer.from(z.slice(e.lho, e.lho + e.lhLen)), body = z.slice(e.lho + e.lhLen, e.lho + e.lhLen + e.csize);
  let cd = Buffer.from(z.slice(e.cd, e.cd + e.cdLen));
  if (sua[e.name] != null) {
    const raw = Buffer.from(sua[e.name], 'latin1'); body = zlib.deflateRawSync(raw, { level: 9 });
    for (const [b, o] of [[lh, 14], [cd, 16]]) { b.writeUInt32LE(CRC(raw), o); b.writeUInt32LE(body.length, o + 4); b.writeUInt32LE(raw.length, o + 8); }
    lh.writeUInt16LE(8, 8); cd.writeUInt16LE(8, 10);
  }
  cd.writeUInt32LE(off, 42); parts.push(lh, body); cds.push(cd); off += lh.length + body.length;
}
const cdBuf = Buffer.concat(cds); const end = Buffer.from(z.slice(eocd, z.length));
end.writeUInt32LE(cdBuf.length, 12); end.writeUInt32LE(off, 16);
const out = Buffer.concat([...parts, cdBuf, end]); fs.writeFileSync(ra, out);
// kiem: doc lai moi entry
console.log('ghi', ra, out.length, 'B (goc', z.length, ')');
