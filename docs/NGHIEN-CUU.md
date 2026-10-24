# Gunny NetCo4 – kiến thức nghiên cứu & dịch ngược (tra cứu khi cập nhật)

Tổng hợp những gì đã đọc code / dịch ngược / đo thật trên server (tới 24/10/2026). Lịch sử từng lần sửa ở `README.md` (mục 1–34), bẫy ở README mục 21, dựng lại máy ở `docs/MO-LAI-SERVER.md`.
Quy ước đường dẫn code: `gameSrc/` = mã nguồn server C# (đã dịch ngược, tên biến kiểu `int_25`, `dictionary_6` là của trình dịch ngược), `flashbaseSrc/src/` = mã nguồn client AS3 (gần đúng với `Flash/2.png` đang chạy, **luôn kiểm lại bằng P-code xuất từ 2.png trước khi vá**).

## 1. Luồng chạy & nơi dữ liệu sống

| Thành phần | Ghi chú |
|---|---|
| Launcher (Electron 11 + PepperFlash, `launcher_base/`) | Mở `gunny.netco4.click/play2/<token>` trong `<webview>` (không partition). Nút "Tải lại game" = `session.clearCache()` (không chờ) + đặt lại `src` |
| Web (Laravel, IIS `gunweb`, PHP chạy dưới **IUSR**) | `PlayController@play` gọi `Request/CreateLogin.aspx` rồi trả `playLauncher.blade.php` nhúng `Flash/Loading.swf` (flashvars `user,key,config`) |
| Client | `Loading.swf` → `config.xml?rnd=` → `DDT_Loading.swf` → **`2.png?lv=<version to>`** (code game chính) + `ui/spain/swf/*.swf`, `ui/spain/xml/xml.png`. Ảnh vật phẩm ở `res.netco4.click/image/...` (`PathManager.solveGoodsPath`) |
| Request (ASP.NET) | XML dữ liệu cho client (`TemplateAlllist.xml` zlib, `LoadPVEItems.xml`, `petconfiginfo.xml`, `petlevelinfo.xml`, `BallList.xml`, `newtitleinfo.xml`...), `NoticeServerUpdate.aspx`, `SendMailAndItem.aspx`, `ChargeMoney.aspx`, `KitoffUser.aspx`, `SystemNotice.aspx` |
| Center (WCF 2108) → Road (9200, game) → Fighting (9308) | Road giữ **toàn bộ dữ liệu người online trong RAM**; ghi DB lúc lưu định kỳ / thoát |
| DB | `Db_Tank` (dữ liệu game, compat 120), `Db_Tank41` (người chơi), `Db_Member` (web), `Db_Admin`, `Db_Gm` |

Nạp lại dữ liệu khi đang chạy (`NoticeServerUpdate.aspx?serverID=4&type=<n>`, trả `0` = Center nhận): `eReloadType` 1 ball (chỉ bảng `Ball`), 2 map, 3 fallitem, 8 item (bảng mẫu; **món đã trong túi giữ mẫu cũ tới khi restart**), 9 quest, 60 newtitle, 61 petmoeproperty... **Chỉ nạp lúc Road khởi động** (phải restart): `Shop_Goods_Box`, `Drop_Item`/`Drop_Condiction`, `Pve_Info`, `Server_Config`, `BallConfig`, `Pet_Config`, `Totem_Info`...

## 2. Bản đồ hệ thống → code → DB

| Hệ thống (tên trong game) | Code server | DB người chơi (`Db_Tank41`) | Bảng mẫu (`Db_Tank`) / tối đa |
|---|---|---|---|
| Cấp nhân vật | `LevelMgr.MaxLevel = _levels.Count` | `Sys_Users_Detail.Grade/GP` | `LevelInfo` 60 cấp (cấp 60 = 100.000.000 GP) |
| Chiến hồn (Lò Rèn) | `FigSpiritUpGradeHandler` (+EXP = `Property2` của đá 100100) | `Sys_User_Gemstone` 5 dòng/nv (EquipPlace 2,3,5,11,13), `FigSpiritIdValue = "cấp,exp,ô|..."` | `Server_Config.FightSpiritMaxLevel` = 6 |
| Gia Công – Tạo | `FineStoreSuitHandler`, `SetsBuildTempMgr.GetSetsBuildProp` | `Sys_Users_Detail.fineSuitExp` | `Sets_Build_Temp` 70 cấp (max 345860) |
| Tu luyện | `TexpHandler`, `ExerciseMgr.GetExercise/getLv` | `Sys_Users_Texp` (5 exp: hp/att/def/spd/luk) | `ExerciseInfo` 70 cấp (GP cấp 70 = 1.280.550). **Lệch 1 cấp**: exp = đúng mốc thì tính cấp dưới → ghi mốc+1 |
| Thẻ bài | `CardDataHandler` (case 3 nâng cấp: cộng `CardUpdateInfo` từng cấp), `CardMgr.MaxLevel = CardUpdateCondition.Count` (40) | `Sys_Users_Card` (Place 0–4 đang đeo = bản sao chỉ số, 5–99 túi; `Count` = thẻ trùng) | `CardUpdateInfo` 44 thẻ × 30 cấp (thẻ không có dòng ở đây không lên cấp được), `CardUpdateCondition` (Exp/cấp) |
| Vật tổ | `OpenOneTotemHandler`, `TotemMgr.MaxTotem() = 10350` (cứng) | `Sys_Users_Detail.totemId` (chỉ số cộng dồn tới id) | `Totem_Info` 10001–10350 |
| Bộ sưu tập thời trang | `AvatarCollectionActive`, `PlayerAvataInventory.ActiveAvatarColection`, `UserAvatarColectionInfo.FullActive/HaftActive/isValidate` | `User_Avatar_Colection` (1 dòng/bộ: `ActiveDress` = TemplateID nối dấu phẩy, `ActiveCount`, `endTime` – hết hạn là mất thuộc tính) | `Cloth_Group_Template` (món của bộ), `Cloth_Property_Template` (thuộc tính), 71 bộ |
| Tiềm năng (Gia Công) | `LatentEnergyHandler`: random `[Property2, Property3)` của đá, hạn 7 ngày; `AddBaseLatentProperty` | `Sys_Users_Goods.latentEnergyCurStr/NewStr/EndTime` | Client chỉ cho món thời trang: cat 2,3,4,6,13,15 (`InventoryItemInfo.isCanLatentEnergy`). Đá: Đá năng lượng Sơ/Trung/Cao (max 29), Nguồn sức mạnh 11689 (80). Các "Nguồn sức mạnh +150…+50000" là đồ admin cũ, **client không có** |
| Tinh luyện (nút trong túi) | Client `RetrieveController` = **tái chế** đồ đổi quà, không phải tăng chỉ số. Cột `StrengthenRefineryLevel` không có code nào dùng | | |
| Cường hóa / hợp thành / lỗ | `ItemStrengthenHandler`, `ItemInfo.OpenHole` (lỗ 1–4 mở theo cường hóa 3/6/9/12 trong `Shop_Goods.Hole` "cấp,loại|..."), `OpenFiveSixHoleHandler` (lỗ 5–6 chỉ mũ/áo/vũ khí, cấp lỗ theo `HoleLevelUpExpList`) | `Sys_Users_Goods.StrengthenLevel`, `*Compose`, `Hole1..6`, `Hole5Level/Hole6Level` | Loại lỗ: 1 công, 2 thủ, 3 thuộc tính |
| Châu báu thuộc tính (cat 11, P1=31, P2=3) | `PlayerEquipInventory.AddBaseProperty` (P3–6 → công/thủ/nhanh/may), `GamePlayer.BaseAttack` (P7 → sát thương), `BaseDefence` (P8 → hộ giáp) | | Huyền Thoại -S Lv5 (31363x–31364x) = 2 chỉ số/viên, mạnh hơn S Lv5 thường |
| Pet: cấp | `PetInventory.MaxLevelByGrade = min(Pet_Config.MaxLevel, cấp nv)`, `FeedPet` | `Sys_Users_Pet` (`Skill`/`SkillEquip` nvarchar(500) từ 23/10) | `Pet_Config.MaxLevel` (đang 60) + client `petconfiginfo.xml`/`petlevelinfo.xml`; `Pet_Level` 70 cấp |
| Pet: kỹ năng | `PetMgr` nạp `Pet_Skill_Template_Info` theo KindID + MinLevel (thêm kỹ năng khi lên cấp, `DeleteSkillIDs` thay kỹ năng cũ) | | Kiểm độ dài chuỗi kỹ năng khi mở cấp mới |
| Pet: tiến hóa (Cỏ Thiên Diệp 11163) | `PetEvolution` | `Sys_Users_Detail.evolutionGrade/evolutionExp` (theo **nhân vật**, mọi pet hưởng) | `Pet_Fight_Property` 50 cấp |
| Pet: mạnh hóa (Đá Mạnh Hóa 201567) | `EatPet` (phải nâng 3 món đều nhau), chỉ số cộng trong `PlayerEquipInventory` khi pet đeo đủ từng món | `Sys_Eat_Pets` (weapon/clothes/hat Level+Exp) | `Pet_Moe_Property` 30 cấp |
| Pet: đồ (cat 50/51/52) | `AddPetEquip` (kiểm cấp đã tắt), `UsersPetInfo.TotalAttack...` = chỉ số pet + chỉ số đồ → cộng vào **nhân vật** | `Sys_Users_Pet.eQPets` (JSON) | `Property2` = cấp pet yêu cầu (60). **Không có thưởng "đúng bộ"** |
| Pet: tăng sao (Linh Lộ Đan 11162) | `PetRisingStar` | | |
| Danh hiệu | `PlayerRank` (bản đang chạy ~dòng 325+), `PlayerEquipInventory`: **cộng MỌI danh hiệu còn hạn** (`rank.Info.Att...`) | `Sys_User_Rank` (`NewTitleID`, `Validate` 0 = vĩnh viễn) | `New_Title` (372 cái có chỉ số); client `newtitleinfo.xml` + `image/title/<Pic>/icon.png` |
| Sổ tay thám hiểm | `PlayerEquipInventory` (~dòng 499–697): cấp sổ ≤ `manualLevel` cộng Boost/ma công/ma kháng; trang đủ mảnh cộng `Collect_*`, trang `activate` cộng `Activate_*` (nhân `1+boost`) | `Sys_Users_ExplorerManualInfo` (`manualLevel`), `...InfoPages` (`activate`), `...InfoDebris` | `JampsManualItemList` 21 cấp, `JampsPageItemList` 25 trang, `JampsDebrisItemList` 350 mảnh, `JampsUpgradeItemList` điều kiện |
| Vũ khí phụ | `Player.UseSecondWeapon` → `SetCurrentWeapon` lấy đạn từ **`BallConfig` theo TemplateID** (không phải `Property1`); hồi máu `SimpleBomb` CURE = `Property7 × 1,1^cường hóa` (chia số người trúng); `BallMgr.GetBallType`: đạn hồi máu chỉ 5,59,64,97,98,120,10009; `Player.IsCure()` danh sách cứng | `Sys_Users_Goods` Place 15 | Client: `WeaponPropCell.creatDeputyWeaponIcon` icon cứng theo ID (đã vá lấy hình món), `LocalPlayer.deputyWeaponEnabled` |
| Phó bản & rơi đồ | `PVEGame.TakeCard` → `DropInventory.CopyDrop(missionId, 1)`; `DropMgr.FindCondiction` lấy **dòng đầu** khớp (`Drop_Condiction` CondictionType 5, Para1 ",mission,", Para2 ",1,"; trùng điều kiện thì DropID nhỏ thắng); `GetDropItems`: ngưỡng = rand[0, max Random), giữ món `Random ≥ ngưỡng`, chọn đều 1 | `Sys_Users_Log` Type `WinMission` (Content = mission) | `Mission_Info`, `Pve_Info` (`*TemplateIds` chỉ là bảng thưởng HIỂN THỊ, không phải rơi thật) |
| Lật thẻ web | `MiniGameController::quetPhoBan/taoBan/latTheLat` (bàn chung theo `WinMission` cách nhau ≤5 giây, bảng rơi y game) | `Db_Member.Web_The_*` | `_setup/sql/lat-the-thu.sql` tạo bàn thử |
| Trứng pet (cat 35) | `Property5` = TemplateID pet | | Pet phải có ở **cả** `Pet_Template_Info` lẫn client `pettemplateinfo.xml`, không thì "Dữ liệu server lỗi"/pet null |

## 3. Client Flash (`Flash/2.png`)

- `2.png` là SWF (CWS) chứa code game; `1.png`, `xml.png` (zip XML giao diện) đi kèm. Bản gốc chưa vá: `Flash-goc-chua-va/` trong gói.
- **Cách vá** (không cần Flex SDK): JPEXS FFDec CLI (`C:\Program Files (x86)\FFDec\ffdec-cli.exe`):
  1. Xuất P-code lớp: `ffdec-cli -format script:pcode -selectclass <lớp.đủ.tên> -export script <thư mục> 2.png`.
  2. Tìm chỉ số body: `node _setup/va-nut/timham.js 2.png <tên/DoABC> "<ns:Lớp/hàm>"` (để trống tên hàm = liệt kê hết).
  3. Sửa P-code của **đúng 1 hàm** (giữ khối `method ... end ; method`), đổi `localcount` nếu thêm biến, nhãn tự đặt được (`ofs00feA`). FFDec tự thêm hằng/QName mới vào constant pool.
  4. `ffdec-cli -replace 2.png 2-moi.png <lớp> <file.pcode> <body> [<lớp2> <file2> <body2> ...]`.
  5. Kiểm chỉ đổi đúng tag: `node _setup/va-nut/swftags.js` hai file rồi `diff`.
  6. Sao lưu `2.png.bak<ngày>` trên VPS, chép lên, **tăng `<version to>` trong `Flash/config.xml`**.
- Các lần vá đã làm: `_setup/va-nut/tiem-nang/README.txt` (Lò Rèn/Gia Công/6 lỗi nhỏ), `_setup/va-nut/thien-su/README.txt` (icon vũ khí phụ, cảnh pet lặp), README mục 26 (nút Hủy/OK, bằng `vanut.js` đổi bytecode cùng độ dài).
- Lớp hay đụng: `game.view.prop.WeaponPropBar/WeaponPropCell`, `game.model.LocalPlayer`, `game.actions.PrepareShootAction`, `game.objects.GamePlayer` (`UsedPetSkill`), `bagAndInfo.cell.BaseCell/BagCell` (`setContentSize`, `PicPos`, `updateSize` co hình sau khi tải), `ddt.data.EquipType`, `ddt.manager.PathManager.solveGoodsPath`, `store.forge.ForgeMainView`, `latentEnergy.*`.
- Cấp hiển thị trong client nhiều chỗ đọc XML của Request (`petconfiginfo.xml` MaxLevel...): đổi server phải đổi cả XML.
- Không có log client: xem log IIS (W3SVC3 = flash1, W3SVC4 = res; giờ **UTC**; `netsh http flush logbuffer` trước khi đọc) để biết máy người chơi tải file nào / 404 gì.

## 4. Server C# – cách vá DLL

- Không build lại cả solution: vá IL bằng Mono.Cecil (`_setup/forgepatch` – rèn 100%, `_setup/botpatch` – bot PvP, `_setup/turnpatch` – thời gian bắn). DLL rời đặt cạnh exe đè bản nhúng Costura. Sao lưu `*.bak-<tên>` cạnh file.
- Ưu tiên sửa **dữ liệu** (SQL + XML client) thay vì DLL khi được (vd kỹ năng pet riêng, LEGEND-Thiên Sứ, pet 60).

## 5. Công thức / số liệu đã đo

- Hồi máu vũ khí phụ: `Property7 × 1,1^cường hóa` (+15 → ×4,177). LEGEND-Thiên Sứ 2394 → 10.000.
- Tỉ lệ rơi một món = Σ theo ngưỡng (Random/maxRandom) ÷ số món còn trong pool; ví dụ Bộ lạc nguyên thủy ải 3: Thánh Kiếm Theia ≈ 0,2%/lá, trang bị bất kỳ ≈ 8–9%/lá.
- Danh hiệu: 370 cái hiển thị được ≈ +7.450 công / 7.208 thủ / 7.466 nhanh / 7.118 may.
- Đồ pet bộ Tôn Ngộ Không + mạnh hóa 30 ≈ +1.035 công/thủ/may, +880 nhanh, +2.905 máu cho nhân vật.

## 6. Việc nên làm tiếp (đã phân tích, chưa làm)

- Cân bằng danh hiệu (chỉ tính cái đang đeo: sửa vòng lặp trong `PlayerEquipInventory`, hoặc hạ chỉ số `New_Title`).
- Bỏ hạn 7 ngày cho trang bị rơi phó bản / tiềm năng nếu muốn giữ người chơi.
- Bảng thưởng hiển thị `Pve_Info.*TemplateIds` lệch với rơi thật (có ID 999999997/8 không tồn tại); `Drop_Condiction` trùng (vd 11090–11092 không bao giờ dùng).
- Nút "Tải lại game" của launcher không chờ xóa cache (đã né bằng tăng `lv`); sửa launcher thì phải phát bản cài mới.
