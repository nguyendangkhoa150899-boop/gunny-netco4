// Dung P-code va 2 loi Gia Cong (22/10/2026), tu P-code xuat bang: ffdec-cli -format script:pcode -selectclass ... -export script
//   node dung-pcode-giacong.js <BagStoreFrame.pcode> <FineGhostView.pcode> <ra dir>
// 1. ddt.bagStore.BagStoreFrame.__changeHandler: dau ham them "ForgeMainView.IsExalt = false;"
//    (Lo Ren > Tang cap > Gia Cong: IsExalt van true -> BagInfo gui UPDATE_Exalt thay UPDATE -> FineGhostView khong cap nhat, do bo vao mat)
// 2. store.fineStore.view.FineGhostView.initView: truoc "EquipList.setData(canGhostEquipList)" them
//    "(this._view as StoreBagView).setData(this._controller.model);" (StoreBagController dung bang truoc khi currentPanel = 7:
//    tab Tiem ren cuoi la Chuyen thi bang o che do 1 luoi, danh sach Gia Cong nam trong luoi dang an)
const fs = require('fs');
const [p1, p2, ra] = process.argv.slice(2);
function layMethod(file, ten) {
  const L = fs.readFileSync(file, 'utf8').split(/\r?\n/);
  const t = L.findIndex(l => l.includes(`trait method QName(PrivateNamespace(`) && l.includes(`"${ten}")`));
  if (t < 0) throw new Error('khong thay ' + ten);
  const a = L.findIndex((l, i) => i > t && l.trim() === 'method');
  const b = L.findIndex((l, i) => i > a && l.trim() === 'end ; method');
  return L.slice(a, b + 1);
}
const pad = s => s.match(/^\s*/)[0];

// 1
let M = layMethod(p1, '__changeHandler');
let i = M.findIndex(l => l.trim() === 'pushscope');
while (M[i + 1].trim().startsWith('debug ')) i++;   // sau pushscope + debug (khai bao tham so)
const p = pad(M[i]);
M.splice(i + 1, 0, ...['findpropstrict QName(PackageNamespace("store.forge"),"ForgeMainView")',
  'getproperty QName(PackageNamespace("store.forge"),"ForgeMainView")', 'pushfalse',
  'setproperty QName(PackageNamespace(""),"IsExalt")'].map(x => p + x));
fs.writeFileSync(ra + '/BagStoreFrame-changeHandler.pcode', M.join('\n') + '\n');

// 2
M = layMethod(p2, 'initView');
const g = M.findIndex(l => l.includes('"canGhostEquipList"'));
if (g < 0) throw new Error('khong thay canGhostEquipList');
let s = g; while (M[s].trim() !== 'getlocal0' || !M[s + 1].includes('"_view"')) s--;   // dau cau lenh dong 212
const q = pad(M[s]);
const viewTo = M.slice(s, M.findIndex((l, k) => k > s && l.includes('"EquipList"')));   // getlocal0 / getproperty _view / getlex StoreBagView / astypelate
const ctrl = M.slice(M.findIndex((l, k) => k > s && l.includes('"EquipList"')) + 1, g);  // getlocal0 / getproperty _controller / getproperty model
if (viewTo.length < 3 || ctrl.length < 3) throw new Error('mau lenh khac du kien: ' + viewTo.length + '/' + ctrl.length);
M.splice(s, 0, ...viewTo, ...ctrl, q + 'callpropvoid QName(PackageNamespace(""),"setData"), 1');
fs.writeFileSync(ra + '/FineGhostView-initView.pcode', M.join('\n') + '\n');
console.log('chen 1: 4 lenh | chen 2: ' + (viewTo.length + ctrl.length + 1) + ' lenh');
console.log(viewTo.concat(ctrl).map(x => x.trim()).join(' ; '));
