// Dot 3 (22/10/2026): 6 loi client nho, P-code tu "ffdec-cli -format script:pcode -export script" cua 2.png dang chay.
//   node dung-pcode-dot3.js <thu muc pcode/scripts> <ra dir>      -> <ra>/*.pcode + in lenh ffdec -replace
// Moi cho sua deu kiem mau lenh, lech mau la dung (khong ghi gi).
const fs = require('fs');
const [goc, ra] = process.argv.slice(2);
function lay(file, nsTrait, ten) {
  const L = fs.readFileSync(goc + '/' + file, 'utf8').split(/\r?\n/);
  const t = L.findIndex(l => l.includes('trait method QName(' + nsTrait) && l.includes(`"${ten}")`));
  if (t < 0) throw new Error(file + ': khong thay ham ' + ten);
  const a = L.findIndex((l, i) => i > t && l.trim() === 'method');
  const b = L.findIndex((l, i) => i > a && l.trim() === 'end ; method');
  return L.slice(a, b + 1);
}
const pad = s => s.match(/^\s*/)[0];
const can = (ok, msg) => { if (!ok) throw new Error('SAI MAU: ' + msg); };
const out = [];

// 1. Dung luyen: StoreIIFusionBG.updateData: setItemInfo(_loc2_, StoreBag.items[_loc2_ + 5]) -> items[_loc2_] (refreshData dung items[slot])
{
  const M = lay('store/view/fusion/StoreIIFusionBG.pcode', 'PackageNamespace(""),', 'updateData');
  const i = M.findIndex((l, k) => l.trim() === 'pushbyte 5' && M[k - 1].trim() === 'getlocal2');
  can(i > 0 && M[i + 1].trim() === 'add' && M[i + 2].includes('getproperty MultinameL'), 'fusion +5');
  M.splice(i, 2);
  out.push(['store.view.fusion.StoreIIFusionBG', 'StoreIIFusionBG-updateData.pcode', 30, M]);
}
// 2. Bang hoi: ConsortionUpGradeFrame.checkGoldOrLevel case 4, nhanh max ky nang: thong bao roi "jump" ra ngoai -> return false
{
  const M = lay('consortion/view/selfConsortia/ConsortionUpGradeFrame.pcode', 'PrivateNamespace(', 'checkGoldOrLevel');
  const i = M.findIndex(l => l.includes('MyConsortiaUpgrade.skill"'));
  can(i > 0 && M[i + 2].includes('"show"') && M[i + 3].trim() === 'pop' && M[i + 4].trim().startsWith('jump '), 'guild skill');
  const p = pad(M[i + 4]);
  M.splice(i + 4, 1, p + 'pushfalse', p + 'returnvalue');
  out.push(['consortion.view.selfConsortia.ConsortionUpGradeFrame', 'ConsortionUpGradeFrame-checkGoldOrLevel.pcode', 14, M]);
}
// 3. Shop: ShopRightView.gotoPage khong dat EXCHANGE_TYPE (static, con tu lan mo truoc) -> giong __topBtnClick
{
  const M = lay('shop/view/ShopRightView.pcode', 'PackageNamespace(""),', 'gotoPage');
  const i = M.findIndex(l => l.trim() === 'ofs0049:');
  can(i > 0 && M[i - 1].includes('setproperty QName(PackageNamespace(""),"TOP_TYPE")'), 'shop TOP_TYPE');
  const p = pad(M[i + 1]);
  const EX = 'QName(PrivateNamespace("shop.view:ShopRightView"),"EXCHANGE_TYPE")', TOP = 'QName(PackageNamespace(""),"TOP_TYPE")';
  const L = [
    `findpropstrict ${TOP}`, `getproperty ${TOP}`, 'pushbyte 4', 'ifeq ofsE0001',
    `findproperty ${EX}`, 'pushbyte -1', `setproperty ${EX}`, 'jump ofsE0002',
  ].map(x => p + x);
  const L2 = [`findpropstrict ${EX}`, `getproperty ${EX}`, 'pushbyte 0', 'ifge ofsE0002', `findproperty ${EX}`, 'pushbyte 0', `setproperty ${EX}`].map(x => p + x);
  M.splice(i + 1, 0, ...L, pad(M[i]) + 'ofsE0001:', ...L2, pad(M[i]) + 'ofsE0002:');
  out.push(['shop.view.ShopRightView', 'ShopRightView-gotoPage.pcode', 29, M]);
}
// 4-5. removeEvents goi addEventListener thay removeEventListener (StoreMainView: transf_Btn; BagView: _btnGroup, _bagLockControl)
for (const [file, cls, tenF, idx, ns, soCho] of [
  ['store/StoreMainView.pcode', 'store.StoreMainView', 'StoreMainView-removeEvents.pcode', 8, 'PrivateNamespace(', 1],
  ['bagAndInfo/bag/BagView.pcode', 'bagAndInfo.bag.BagView', 'BagView-removeEvents.pcode', 31, 'ProtectedNamespace(', 2]]) {
  const M = lay(file, ns, 'removeEvents');
  let n = 0;
  for (let k = 0; k < M.length; k++) if (/call(propvoid|property) QName\(PackageNamespace\(""\),"addEventListener"\), 2/.test(M[k])) { M[k] = M[k].replace('"addEventListener"', '"removeEventListener"'); n++; }
  can(n === soCho, cls + ' addEventListener: ' + n + ' cho (du kien ' + soCho + ')');
  out.push([cls, tenF, idx, M]);
}
// 6. Tang cap: StoreExaltBG.dispose khong huy _bagList/_proBagList (WishBeadBagListView nghe WishBeadManager) -> them nhu cac o khac
{
  const M = lay('store/view/exalt/StoreExaltBG.pcode', 'PackageNamespace(""),', 'dispose');
  const r = M.findIndex(l => l.trim() === 'returnvoid');
  const b = M.findIndex(l => l.includes('"_buyBtn")') && l.includes('getproperty'));   // ObjectUtils.disposeObject(this._buyBtn); this._buyBtn = null
  can(r > 0 && b > 0, 'exalt dispose');
  let s = b; while (!M[s].includes('"ObjectUtils")') || !M[s].trim().startsWith('find')) s--;
  let e = b; while (!(M[e].includes('setproperty') && M[e].includes('"_buyBtn")'))) e++;
  const mau = M.slice(s, e + 1).filter(l => !l.trim().startsWith('debugline'));
  can(mau.length >= 7, 'mau disposeObject');
  const them = [];
  for (const f of ['_bagList', '_proBagList']) them.push(...mau.map(l => l.replace('"_buyBtn")', `"${f}")`)));
  M.splice(r, 0, ...them);
  out.push(['store.view.exalt.StoreExaltBG', 'StoreExaltBG-dispose.pcode', 39, M]);
}
const args = [];
for (const [cls, f, idx, M] of out) { fs.writeFileSync(ra + '/' + f, M.join('\n') + '\n'); args.push(cls, ra + '/' + f, String(idx)); }
fs.writeFileSync(ra + '/dot3-args.txt', args.join('\n') + '\n');
console.log('ok ' + out.length + ' ham: ' + out.map(o => o[1]).join(', '));
