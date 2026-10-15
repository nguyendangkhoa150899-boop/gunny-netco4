// quetnut.js <src AS3> <thu muc xml> [--json ra.json]
// Moi lop co 1 bien nut "dong y" + 1 bien nut "huy" tao bang ComponentFactory(style): tra x,y cua 2 style trong XML;
// ghi nhan neu code tu dat .x / PositionUtils cho nut (khi do XML khong quyet dinh).
const fs = require('fs'), path = require('path');
const [, , src, xdir, , outJson] = process.argv;
const OKV = /^_?(ok|okbtn|okbutton|okbt|confirm|confirmbtn|confirmbutton|confirmbt|submit|submitbtn|submitbutton|sure|surebtn|surebutton|surebt|yes|yesbtn|agree|agreebtn|accept|acceptbtn|enter|enterbtn|enterbutton|okbutton|btnok|btnconfirm|btnsure|btnsubmit|buybtn|buy|okBtn)$/i;
const NOV = /^_?(cancel|cancelbtn|cancelbutton|cancelbt|cancle|canclebtn|canclebutton|no|nobtn|refuse|refusebtn|reject|rejectbtn|disagree|btncancel|btncancle|btnno|exitbtn)$/i;
// style -> {x,y,f}
const sty = {};
for (const f of fs.readdirSync(xdir).filter(x => x.endsWith('.xml'))) {
  const t = fs.readFileSync(path.join(xdir, f), 'utf8');
  for (const m of t.matchAll(/<(component|custom)\b[^>]*?stylename="([^"]+)"[^>]*>/g)) {
    const x = /\sx="(-?[\d.]+)"/.exec(m[0]), y = /\sy="(-?[\d.]+)"/.exec(m[0]);
    sty[m[2]] = { x: x ? +x[1] : null, y: y ? +y[1] : null, f, tag: m[0].length };
  }
}
const files = [];
(function walk(d) { for (const e of fs.readdirSync(d, { withFileTypes: true })) { const p = path.join(d, e.name); if (e.isDirectory()) walk(p); else if (p.endsWith('.as')) files.push(p); } })(src);
const out = [];
for (const p of files) {
  const t = fs.readFileSync(p, 'utf8');
  const vars = {};
  for (const m of t.matchAll(/this\.(\w+)\s*=\s*ComponentFactory\.Instance\.(?:creatComponentByStylename|creat)\("([^"]+)"\)/g)) vars[m[1]] = m[2];
  const txt = {}; for (const m of t.matchAll(/this\.(\w+)\.text\s*=\s*LanguageMgr\.GetTranslation\("([^"]+)"\)/g)) txt[m[1]] = m[2];
  const OKK = /(^ok$|oklabel$|okbtntext$|okTable$|readyOk$|sure|confirm)/i, NOK = /(^cancel$|\.cancel$|cancle)/i;
  const ok = Object.keys(vars).filter(v => OKV.test(v) || (txt[v] && OKK.test(txt[v]))), no = Object.keys(vars).filter(v => NOV.test(v) || (txt[v] && NOK.test(txt[v])));
  if (!ok.length || !no.length) continue;
  for (const a of ok) for (const b of no) {
    const sa = sty[vars[a]], sb = sty[vars[b]];
    const codePos = new RegExp('this\\.(' + a + '|' + b + ')\\.x\\s*=|PositionUtils\\.setPos\\(this\\.(' + a + '|' + b + ')').test(t);
    let s;
    if (!sa || !sb) s = 'khong thay style';
    else if (sa.x == null || sb.x == null) s = 'style khong co x';
    else if (sa.y !== sb.y) s = 'khac hang';
    else s = sa.x < sb.x ? 'OK TRAI' : 'ok phai';
    out.push({ cls: path.relative(src, p).replace(/\\/g, '/'), ok: a, no: b, sOk: vars[a], sNo: vars[b], xOk: sa && sa.x, xNo: sb && sb.x, y: sa && sa.y, f: sa && sa.f, s, codePos });
  }
}
const dem = {};
for (const r of out) { dem[r.s + (r.codePos ? ' +code' : '')] = (dem[r.s + (r.codePos ? ' +code' : '')] || 0) + 1; }
for (const r of out.sort((a, b) => a.s.localeCompare(b.s))) console.log((r.s + (r.codePos ? ' +code' : '')).padEnd(22), r.cls.padEnd(60), r.sOk, r.xOk, '|', r.sNo, r.xNo);
console.log(JSON.stringify(dem));
if (outJson) fs.writeFileSync(outJson, JSON.stringify(out, null, 1));
