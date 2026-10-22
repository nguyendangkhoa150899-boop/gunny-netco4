Va client Flash/2.png ngay 23/10/2026 (2 loi trong tran). Goc: 2.png md5 ca60180e... (sau dot 3 tiem-nang), sau va 54ebea5d...
Sao luu tren VPS: C:\Gunny92\Flash\2.png.bak20261023 (hoan tac: copy de len 2.png).
Cong cu: JPEXS FFDec "C:\Program Files (x86)\FFDec\ffdec-cli.exe", node _setup/va-nut/timham.js (tim chi so body).

1. O phim R (vu khi phu) trong tran trong hinh voi vu khi phu moi (LEGEND-Thien Su 17017...).
   Loi: WeaponPropCell.creatDeputyWeaponIcon viet cung icon theo TemplateID (17000-17006, 17011-17013), ma khac -> null -> o trong.
   Sua (info/set, body 7): icon null thi lay hinh cua chinh mon do: new BagCell(0, _info.Template).getSmallContent()
   (giong DeputyWeaponInfo.getDeputyWeaponIcon o phong cho), dat x=y=3, 32x32 nhu icon may bay (o F), gan vao _asset.
   (Lan dau thu map 17017 -> icon Super-Thien su: sai hinh, da bo.)
2. Pet dung ky nang loai dan (BallType 1, vd Dan Liet Bang) 1 lan thi MOI phat ban sau van hien canh pet.
   Loi: GamePlayer.__usePetSkill them vao UsedPetSkill nhung khong bao gio xoa; PrepareShootAction.prepare xet UsedPetSkill.list[0].
   Sua (doPrepareToShootAction, body 5): dau ham them "_player.UsedPetSkill.clear()" (chay sau canh pet hoac khi khong co canh).

Lam lai:
  ffdec-cli -replace 2.png 2-moi.png game.actions.PrepareShootAction PrepareShootAction-doPrepareToShootAction.pcode 5 game.view.prop.WeaponPropCell WeaponPropCell-info-set.pcode 7
Kiem: chi 2 tag DoABC doi: game/view/prop/WeaponPropCell (3626 -> 3753), game/actions/PrepareShootAction (2789 -> 2806).
