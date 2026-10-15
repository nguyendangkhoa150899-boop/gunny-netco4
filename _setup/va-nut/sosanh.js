// sosanh.js <goc> <va> : giai nen 2 SWF CWS, dem byte khac
const fs = require('fs'), zlib = require('zlib');
const un = f => { const b = fs.readFileSync(f); return Buffer.concat([b.slice(0, 8), zlib.inflateSync(b.slice(8))]); };
const a = un(process.argv[2]), b = un(process.argv[3]);
if (a.length !== b.length) { console.log('DO DAI KHAC', a.length, b.length); process.exit(1); }
const d = []; for (let i = 0; i < a.length; i++) if (a[i] !== b[i]) d.push(i + ':' + a[i] + '->' + b[i]);
console.log(process.argv[3].split(/[\\/]/).pop(), 'khac', d.length, 'byte:', d.join(' '));
