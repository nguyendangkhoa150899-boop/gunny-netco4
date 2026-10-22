Va icon vu khi phu LEGEND-Thien Su Ban Phuc (17017) o phim R trong tran (Flash/2.png), 23/10/2026.
Loi: game.view.prop.WeaponPropCell.creatDeputyWeaponIcon viet cung icon theo TemplateID (17000-17006, 17011-17013),
 ma khac -> default: return null -> o R trong (van bam duoc).
Sua: chen nhanh "17017 -> case 3" (icon Prop36Asset = Super-Thien su ban phuc 17000) truoc nhanh 17006.

Cach lam lai (JPEXS FFDec: "C:\Program Files (x86)\FFDec\ffdec-cli.exe"):
  node _setup/va-nut/timham.js 2.png game/view/prop/WeaponPropCell game.view.prop:WeaponPropCell/private:creatDeputyWeaponIcon   -> body 1
  ffdec-cli -replace 2.png 2-moi.png game.view.prop.WeaponPropCell WeaponPropCell-creatDeputyWeaponIcon.pcode 1
Kiem: chi tag DoABC game/view/prop/WeaponPropCell doi (3626 -> 3641 byte). md5 truoc ca60180e..., sau 5b9f0e11...
Hoan tac tren VPS: copy C:\Gunny92\Flash\2.png.bak20261023 de len 2.png.
Them vu khi phu moi can icon: chen them nhanh "pushshort <ID> / getlocal2 / ifstrictne <nhan sau> / pushshort <case> / jump ofs0177" tuong tu.
