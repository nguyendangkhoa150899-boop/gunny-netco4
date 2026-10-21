# GunnyNetco4: server Gunny (DDTank) test

Server Gunny riêng để chơi thử với bạn bè. **Claude phiên sau: đọc hết file này + `CLAUDE.md` trước khi làm gì.**
Mật khẩu, key SSH, cách kết nối VPS **không nằm trong repo**: chủ server giữ ở thư mục `GunnyNetco4-BAO-MAT` (Desktop), hỏi chủ server nếu cần.

| | |
|---|---|
| Trang người chơi | https://gunny.netco4.click (tải client Windows/Mac, đăng ký, đăng nhập) |
| Admin panel | https://admingunny.netco4.click |
| VPS | Windows Server, `171.244.39.225`, thư mục chạy `C:\Gunny92` |
| Repo | https://github.com/nguyendangkhoa150899-boop/gunny-netco4 (riêng tư) |

**Mở lại server trên máy mới (gói bản trắng): `docs/MO-LAI-SERVER.md`** · tạo gói: `_setup/dong-goi.ps1`.

**Đọc nhanh:** bẫy và kinh nghiệm ở **mục 21**, cấu hình web **mục 22**, dựng lại web **mục 23**, việc cần làm khi mở thật **mục 24**. Web người chơi: điểm danh (13), dashboard (14), mini game (15), rút xu (16), shop (18), gửi quà test (19), lật thẻ (20).

---

## 1. Kiến trúc

```
Người chơi
  launcher (Electron 11 + PepperFlash)  --http-->  gunny.netco4.click  (IIS site gunweb = website_backend, Laravel/PHP 7.4)
      /api/login131, /api/register  -> Db_Member.Mem_Account
      /play2/{token} --(server gọi nội bộ http://127.0.0.1/CreateLogin.aspx)--> Request -> Center (WCF 2109)
      trả trang game: Loading.swf + config.xml từ flash1.netco4.click
  Flash client  --http-->  flash1 (C:\Gunny92\Flash), res (C:\Gunny92\Resource.Server),
                           quest1 (Request: ServerList.ashx ...)
               --tcp---->  171.244.39.225:9200 (Road)  ->  9308 (Fighting) khi đánh trận
```

| Tiến trình | Đường | Cổng | Ghi chú |
|---|---|---|---|
| SQL Server 2022 | | 1433 (đóng ngoài) | 5 DB: Db_Tank41 (người chơi + cấu hình), Db_Tank (dữ liệu game), Db_Member (tài khoản web), Db_Admin, Db_Gm |
| IIS `Request` | `C:\Gunny92\Request` | 80 (bắt mọi host còn lại, gồm quest1) | ASP.NET 4, app pool DefaultAppPool |
| IIS `gunweb` | `C:\Gunny92\website_backend\public` | 80/443 host `gunny.netco4.click` (+8080) | Laravel, PHP FastCGI `C:\PHP7` |
| IIS `flashsite` | `C:\Gunny92\Flash` | 80 host `flash1.netco4.click` | tĩnh, MIME .swf |
| IIS `ressite` | `C:\Gunny92\Resource.Server` | 80 host `res.netco4.click` | tĩnh |
| IIS `adminsite` | `C:\Gunny92\admin` | 80/443 host `admingunny.netco4.click` | PHP |
| Center.Service.exe | `Server\center` | 9302, 2108, 2109 (đóng ngoài) | đọc `Server_List` **chỉ lúc khởi động** |
| Fighting.Service.exe | `Server\fight` | 9308 (mở) | bind `0.0.0.0` |
| Road.Service.exe | `Server\road` | 9200 (mở) | bind `0.0.0.0` |

Bật: SQL → IIS → Center → Fighting → Road. Tắt ngược lại. 3 server chạy tách khỏi SSH bằng WMI (`_setup/start-servers.ps1`).
Domain cũ `*.gunny92.com` vẫn còn binding IIS nhưng không dùng nữa.

---

## 2. Quy trình phát triển (sửa → GitHub → VPS)

```bash
# máy dev (Git Bash), key SSH ở ~/.ssh/gunny_vps
git commit ...
./_setup/deploy.sh          # push GitHub rồi đẩy file đã đổi lên VPS
DRY=1 ./_setup/deploy.sh    # xem trước
```
`deploy.sh` so commit trên VPS (`C:\Gunny92\.deployed-commit`) với HEAD, chỉ đẩy file đổi trong `website_backend/ Request/ admin/ _setup/`, xóa cache Laravel, recycle app pool Request, ghi commit mới. **Luôn commit + deploy bằng script này, không sửa tay trên VPS** (sửa tay sẽ bị lần deploy sau đè).

Không đi qua `deploy.sh`, phải làm tay:
- **Bí mật**: `website_backend/.env`, `Request/appsettings.secret.config` (gitignore, chỉ trên VPS; bản sao ở thư mục bảo mật của chủ server).
- **SQL** trong `_setup/sql/`: deploy xong thì chạy `sqlcmd -S localhost -E -C -b -i C:\Gunny92\_setup\sql\<file>.sql`.
- **Server game / Request .cs**: sửa `gameSrc/`, build Visual Studio (.NET 4.8), copy exe/dll lên VPS, restart. Lưu ý: file `.cs` trong thư mục `Request/` là **bản cũ không khớp DLL**; nguồn thật là `gameSrc/Tank.Request/`.
- **Launcher**: xem mục 6.

### SSH vào VPS (cho Claude)
- Shell mặc định là **PowerShell 5.1**: không có `&&`; lệnh nhiều nháy thì mã hóa: `node -e 'process.stdout.write(Buffer.from(process.argv[1],"utf16le").toString("base64"))' "$CMD"` rồi `ssh ... "powershell -EncodedCommand $B64"`.
- Output hay lẫn rác CLIXML (`#< CLIXML`, `Preparing modules`): ghi kết quả ra file rồi `cmd /c type`, đặt `$ProgressPreference='SilentlyContinue'`.
- File lớn (>~10KB) không nhét vào `-EncodedCommand` được (vượt độ dài lệnh): dùng `scp`.
- Process bật bằng `Start-Process` qua SSH sẽ **chết khi phiên SSH đóng** → bật server game bằng `Invoke-CimMethod Win32_Process Create` (xem `start-servers.ps1`).

---

## 3. Cấu hình server TEST (đang áp dụng)

**Nhân vật mới = cấp tối đa + nhiều tài nguyên.**
- `SP_Users_Active` (Db_Tank41) vá bởi `_setup/sql/tao-nhan-vat-max.sql`: cấp = dòng cao nhất của `Db_Tank.dbo.LevelInfo` (**60**, GP 100.000.000), `Gold/Money/MoneyLock` lấy từ tham số. Bản gốc ghi cứng cấp 1 và 0 vàng/xu.
- Số tài nguyên: `DefaultGold` (50.000.000) và `DefaultMoney` (10.000.000, cũng dùng cho xu khóa) trong `Request/Web.config`. Hàm tạo nhân vật chạy trong tiến trình **Request** (`gameSrc/Tank.Request/Login.cs` → `BaseInterface.CreateLogin` → `ActivePlayer`).
- **Cấp tối đa 60**: server dùng `LevelMgr.MaxLevel = số dòng LevelInfo`; client dùng `Request/LevelList.xml` (`Experience.MAX_LEVEL = số mục + 1`) và vẽ icon tới 60 (`LevelIcon.MAX_LEVEL=60`). `tank.bak` chỉ có 30 dòng LevelInfo (cấp 26 đến 30 còn lệch 1 bậc), `_setup/sql/levelinfo-60.sql` nạp lại đủ 60 cấp từ `LevelList.xml` gốc. Đổi LevelInfo xong phải restart Center/Fighting/Road.

**Tiền tệ** (`Db_Tank41.Sys_Users_Detail`): `Gold` = vàng, `Money` = xu, `MoneyLock` = xu khóa. `Db_Member.Mem_Account.Money` là xu web (khác xu trong game).

**Dữ liệu người chơi đang online nằm trong RAM của Road**, lúc thoát/định kỳ server ghi xuống DB → sửa DB trực tiếp cho người đang online sẽ **bị ghi đè**. Cộng xu đúng cách dùng kênh nạp (mục 4).

---

## 4. Admin panel (`admin/`)
Đăng nhập `admin` + `ADMIN_PANEL_PASS` trong `.env`. Đọc mọi bí mật từ `.env` (không hardcode).
Cấu trúc: `index.php` (đăng nhập, menu, điều phối POST có CSRF rồi chuyển hướng), `lib.php` (hàm chung, `req()` gọi endpoint Request, danh sách XML được xuất bản), `actions.php` (mọi thao tác), `pages/*.php` (mỗi trang một file, đầu file có `if (!defined('GN_ADMIN')) exit;`).

**Nguyên tắc:** chạy cái gì lên server đang sống thì đi qua **endpoint của Request trên 127.0.0.1** (AdminIP/ChargeIP), Request gọi Center qua WCF. PHP không gọi WCF net.tcp được. Ghi thẳng DB chỉ dùng cho nhân vật offline.

| Trang | Chức năng | Cơ chế |
|---|---|---|
| Dashboard | online (`Sys_Users_Detail.State=1`), tài khoản, nhân vật, đăng ký hôm nay (`Mem_Account.TimeCreate` là Unix time), bị khóa, tỉ lệ đang chạy | đọc DB |
| Tài khoản | tìm, Khóa / Mở khóa đăng nhập launcher | `Mem_Account.IsBan` |
| Nhân vật | tìm, online/offline; **Cộng xu** (online nhận ngay); Lên cấp tối đa, Buff mọi nhân vật offline | `ChargeMoney.aspx?content=chargeID\|user\|xu\|admin\|0\|md5(5 trường+ChargeKey)&nickname=<UserID số>`; còn lại ghi DB |
| Gửi quà | 5 ô quà kiểu ô vật phẩm (ảnh, viền màu phẩm chất, ID), tìm theo **ID hoặc tên** gõ tới đâu ra tới đó (`?ajax=items`), lọc loại, tooltip chỉ số; số lượng / hạn ngày / cường hóa (tối đa `Server_Config.MaxStrengthLevel` = 12) / khóa; gửi 1 tài khoản / người online (-10) / tất cả (-9) | `SendMailAndItem.aspx?title&content&user_id&gold&money&str=tid,count,ngày,cường hóa,0,0,0,0,true\|...` → `SP_Admin_SendAllItem` + Center `MailNotice`. Vật phẩm và vàng/xu về 2 thư riêng |
| Giftcode | danh sách sự kiện (`Db_Tank.Active`), tạo sự kiện mới (chép cờ từ sự kiện code mẫu Type=1), thêm/xóa quà có ảnh (`Active_Award`), đổi hạn, tạo code 2 kiểu: **nhiều lần có số lượt** / **mỗi người 1 lần**, bảng code có nút sao chép (mục 11) | người chơi nhập code trong game → `ActivePullDown.ashx` → quà về thư. Đổi sự kiện xong xuất bản `ActiveList` |
| Hệ thống | tỉ lệ EXP/vàng/công hiến (`Db_Tank41.Rate`, áp dụng ngay `ExperienceRate.aspx`); thông báo toàn server (`SystemNotice.aspx`); xuất bản XML **từng file** + nạp lại server (`NoticeServerUpdate.aspx type=8 item,9 quest,14 shop,12 rate...`); bảo trì (`KitoffUser.aspx`, đếm ngược 6 phút rồi đá hết); GM trong game (`Game_Commands`); sửa `Db_Tank41.Server_Config` | |

Mã kết quả: ChargeMoney 0 ok/2 không thấy user/5 sai IP/7 sai chữ ký; SendMailAndItem 1 ok/5 sai IP/999 lỗi; SystemNotice 0 ok; ExperienceRate, NoticeServerUpdate 0 ok (`ExperienceRate.aspx` in kèm HTML trang sau con số, `req()` chỉ lấy số đầu); KitoffUser 1 ok.

**Phải khởi động lại Road** mới có hiệu lực: Server_Config, GM (`Game_Commands`), rơi đồ (`Drop_Item`), sự kiện GM (`GM_Activity...`). Không có endpoint nạp lại từ xa cho các phần này.

**GM trong game:** UserID có trong `Game_Commands` gõ được `$kick$tên$lý do`, `$ban$tên$lý do$ngày`, `$unban$tên$lý do`, `$mute$tên$phút$lý do` (lý do ≥ 8 ký tự). Hiện GM: UserID 1 (nhân vật cũ đã xóa, giữ làm dòng tối thiểu) và 227 (`bialk`). **Bảng rỗng thì Road tự tắt.**

---

## 5. Bảo mật đã làm
- Gỡ backdoor: `/chargeTo` (nạp xu vô hạn), `/playdebug` (vào game bằng tài khoản bất kỳ), route nạp thẻ/momo/QR; xóa `KeyGenerator.ashx`, `AccountRegister.ashx`, các trang test, `Resource.Server/index.php` (đọc trộm file), `klsaflf.php`.
- **Đổi LoginKey/ChargeKey** (bộ gốc lộ công khai; `CreateLogin.aspx` tắt kiểm IP nên ai có LoginKey cũ là đăng nhập được mọi tài khoản). Khóa mới sinh ngẫu nhiên trên VPS, nằm trong `Request/appsettings.secret.config` (Web.config dùng `<appSettings file=...>`) và `.env` (`KEY_REQUEST`, `CHARGE_KEY`). Thiếu file bí mật thì đăng nhập bị từ chối, không rơi về khóa cũ.
- Chuỗi kết nối DB (mật khẩu sa) chuyển khỏi `Request/Web.config` vào file bí mật. Script dựng đọc `$env:GUNNY_SA_PASSWORD`.
- Bỏ IP server cũ `15.235.163.1` khỏi LoginIP/ChargeIP/AdminIP/SentRewardIP.
- Đăng ký lưu bcrypt (trước lưu md5, nên đăng ký xong không đăng nhập được).
- Tường lửa: chỉ mở 80, 443, 9200, 9308.

Còn lại: mật khẩu sa có trong lịch sử git cũ; `privateKey` RSA trong Web.config là khóa cũ bị lộ (đổi phải build lại client); Defender realtime đang tắt; `SentRewardKey=asdfgh` yếu (nhưng chỉ nhận từ 127.0.0.1).

---

## 6. Launcher / client
- Nguồn: `launcher_base/` (Electron 11.5.0, **gitignore**, nằm trong bộ chạy). `const.js` → `host: 'http://gunny.netco4.click'`.
- Windows: `launcher_base/dist/win-ia32-unpacked` (bản 32-bit, có `flashver`). Exe đổi tên `netco4gunny.exe`. Zip `GunnyNetco4-Launcher.zip` (thư mục gốc `GunnyNetco4`).
- Mac: lấy `electron-v11.5.0-darwin-x64.zip` chính chủ, **sửa zip tại chỗ bằng 7-Zip** (đổi `Electron.app`→`GunnyNetco4.app`, xóa `default_app.asar`, thêm `Resources/app.asar` + `Resources/flashver/PepperFlashPlayer.plugin`, sửa Info.plist). **Không giải nén trên Windows**: sẽ mất 14 symlink trong .app. Plugin Flash Mac là x86_64 → máy chip Apple chạy qua Rosetta. Người dùng chạy `xattr -cr` + `codesign --force --deep --sign -` (hướng dẫn trên trang tải). Chưa test trên Mac thật.
- Đổi domain/host trong launcher: `asar extract app.asar` → sửa `const.js` (và `preloads/play.js`) → `asar pack` (dùng `launcher_base/node_modules/.bin/asar`), không cần electron-builder.
- Cập nhật launcher: launcher gọi `/api/update/{platform}/{version}`, chỉ cập nhật khi server trả đúng chữ `noup`. `.env LAUNCHER_APP_VERSION=1.2.9`.
- File tải đặt ở `C:\Gunny92\website_backend\public\downloads\` (upload bằng scp).
- Trình duyệt thường không chơi được (Flash đã chết). Web version không khả thi nếu không viết lại client.

---

## 7. Tùy biến game
Khác TLBB, phần lớn dữ liệu hiển thị lấy từ server nên sửa được:
- **Vật phẩm/vũ khí**: `Db_Tank.dbo.Shop_Goods` (19.122 dòng; `TemplateID, Name, Description, Attack, Defence, Agility, Luck, Property1..8, NeedLevel, Quality...`; vũ khí `CategoryID=7`, ví dụ 7003 "AK-48"). Tên + chỉ số trong tooltip lấy từ đây.
- Client đọc `Request/TemplateAlllist.xml` (XML nén zlib). Sửa `Shop_Goods` → admin Hệ thống → xuất bản **riêng** `TemplateAllList` + nạp lại server loại 8 (vật phẩm). Lưu ý file dựng từ DB có 19.122 vật phẩm còn bản gốc 13.080 (mục 9); thử trên một máy client trước. Client có thể lưu cache XML.
- Rơi đồ `Drop_Item`, shop `ShopGoodsShowList`/`Shop_Goods_Box`, cấp `LevelInfo`, quest `Quest_Goods`...
- Cấu hình chung: `Db_Tank41.dbo.Server_Config` (523 khóa: tỉ lệ, giá, giới hạn...).
- Giao diện client: mã AS3 trong `flashbaseSrc/` (build bằng Flex/AIR SDK) — sửa được nhưng nặng.

---

## 8. Các lỗi đã gặp và cách sửa (đọc để khỏi mất thời gian)
| Triệu chứng | Nguyên nhân | Sửa |
|---|---|---|
| PHP "Failed to load php_sqlsrv_74_nts" | php.ini thiếu đuôi `.dll` | `extension=php_sqlsrv_74_nts.dll` |
| Laravel 500 `Class 'Memcached' not found` | `CACHE_DRIVER=memcached` | `CACHE_DRIVER=file` |
| Mọi trang .aspx 500, event log CS0016 "Access is denied" | app pool không ghi được `C:\Windows\Temp` | cấp quyền IIS_IUSRS/Users cho `C:\Windows\Temp` + `tempDirectory` trong Web.config |
| `/play2` 500 | DB còn link server cũ (`quest1.megun.vn:88`) | sửa `Db_Member.Server_List` + `Db_Tank.AreaConfig` (`_setup/sql/links-localhost.sql`) |
| Đăng ký xong không đăng nhập được | register md5, login bcrypt | register bcrypt |
| Vào game 99% "kết nối thất bại" | Road/Fight bind `127.0.0.1`; `Server_List.IP=127.0.0.1`; Center chưa restart | config `IP=0.0.0.0`; IP = IP public; restart Center |
| Server game chết khi đóng SSH | `Start-Process` gắn với phiên SSH | bật qua WMI |
| sqlcmd lỗi SSL | ODBC 18 | thêm `-C` |
| Chữ tiếng Việt trong DB bị vỡ (`phÃ³`) sau khi chạy file .sql | `sqlcmd -i` đọc file UTF-8 theo bảng mã Windows | **luôn thêm `-f 65001`** khi file .sql có chữ có dấu |
| Phó bản đặc biệt vào 1 người là thua / lỗi | kịch bản sư đồ cần ≥ 2 người (`player_1`) | đi 2 người; kịch bản biên dịch sẵn trong exe Road, `ScriptsPVE` không được dùng (mục 9) |
| Cộng xu lỗi mã 2 | thiếu `nickname=<UserID>` | truyền UserID |
| ServerList trả rỗng khi test | thiếu tham số `rnd` | gọi `ServerList.ashx?rnd=0.123` |
| deploy.sh lỗi trên VPS | shell SSH là PowerShell | lệnh từ xa viết cú pháp PowerShell |
| Mọi `.ashx` dựng XML báo "Fail!", log Request đứng từ 2023 | IIS chỉ được tạo file, không được ghi đè trong `Request\` | cấp IIS_IUSRS quyền sửa riêng `Request\*.xml` và `Request\logs` |
| Admin đọc mã trả về của ExperienceRate rỗng | trang in "0" rồi in luôn HTML | `req()` lấy số đầu |
| Nhân vật kẹt cấp 30 | LevelInfo chỉ 30 dòng | `_setup/sql/levelinfo-60.sql` + restart |
| Road tự tắt khi khởi động | bảng `Game_Commands` rỗng | giữ ít nhất 1 dòng |

---

## 9. Bộ admin cũ (server gốc) làm được gì, và dữ liệu đang thiếu

Server gốc có 3 lớp quản trị:
- **GM tool** (`GM/`, ASP.NET MVC, user trong `Db_Gm`): gửi đồ qua thư, phần thưởng đua top, khóa/kick, sửa nhân vật, giftcode, sự kiện, giá shop, rơi đồ, nhiệm vụ, nhập/xuất XML khoảng 70 bảng, khu/kênh server, gộp server. **Hợp đồng WCF của nó không khớp Center trong bộ này** (gọi `MailNotice(id,zone)`, `GetAllChat`, `Shutdown`... không tồn tại; trỏ cổng 2009) nên phần "chạy trực tiếp" của nó hỏng; có đăng ký mở, SQL injection, SSRF. **Không triển khai.**
- **newweb / Website / Website1** (Laravel): CRUD dữ liệu game, gửi đồ qua `SendMailAndItem.aspx`, sinh giftcode, cộng xu web, khóa tài khoản, nút `createallxml`. Có backdoor `CheckIfAdmin` luôn true, admin mặc định `admin@gmail.com/password`. **Không triển khai.**
- **Lệnh console** của Road/Center (khoảng 50 lệnh reload, `senditem`, `shutdown`...) và lệnh chat GM.

Admin mới (mục 4) đã gom các chức năng đáng dùng: gửi quà, cộng xu, khóa, giftcode, tỉ lệ, thông báo, xuất bản, bảo trì, GM, Server_Config. Phần CRUD dữ liệu game còn lại (shop, rơi đồ, nhiệm vụ...) làm bằng SSMS hoặc bổ sung dần vào admin.

**Dữ liệu `tank.bak` thiếu/lệch so với bộ XML client gốc (13/12/2023)** (dựng lại từ DB rồi đếm):
| XML | Client gốc | Dựng từ DB |
|---|---|---|
| QuestList (nhiệm vụ) | 1.115 | **179** |
| NPCInfoList | 1.274 | 1.033 |
| ShopGoodsShowList | 1.372 | 1.258 |
| TemplateAlllist (vật phẩm) | 13.080 | 19.122 |
| LevelList | 60 | 30 (đã sửa, mục 3) |

Hệ quả: server (đọc DB) chỉ biết 179 nhiệm vụ trong khi client hiện 1.115. **Không chạy `CreateAllXml.ashx`** (dựng lại tất cả sẽ làm client mất nhiệm vụ); admin chỉ cho xuất bản từng file. XML gốc nằm trong git (`Request/*.xml`) và bản sao `C:\inst2\xml-backup-20261015` trên VPS. Hướng sửa tốt nhất: nạp ngược nhiệm vụ/NPC/shop từ XML gốc vào DB như đã làm với LevelInfo (`Item`/`Item_Condiction`/`Item_Good` của QuestList ↔ `Quest`/`Quest_Condiction`/`Quest_Goods`).

**Đã khôi phục (15/10)** bằng `_setup/restore-from-xml.ps1` (chỉ thêm dòng thiếu, sao lưu `Db_Tank.dbo.bak20261015_*`): +1.013 nhiệm vụ (1.241 điều kiện, 1.822 phần thưởng; bỏ 15 phần thưởng trỏ vật phẩm không tồn tại), +250 quái (129 con khung va chạm mặc định), +164 hàng shop.

**Phó bản:** tab "Phó bản cao cấp" chỉ có 4 phó bản (ô còn lại là ô trống, client vẽ ổ khóa, chữ "LC đề cử" trên ô trống là chữ sót từ tab trước). Tab "Phó bản đặc biệt" (loại 6, phòng sư đồ, server không bắt buộc cặp sư đồ) vốn trống vì `Ordering=0`; đã mở 4 phó bản Gamazon/Xatara/Daucula/Cariga bằng `_setup/sql/mo-pho-ban-dac-biet.sql` + sửa `Request/LoadPVEItems.xml` (chỉ độ khó Thường). Client chỉ hiện phó bản có `Ordering >= 1`. **Phó bản sư đồ bắt buộc ≥ 2 người**: kịch bản (vd `GZS801`) kết thúc ván khi `GetAllLivingPlayers().Count < 2` và dùng `player_1` (người thứ 2), vào 1 người là thua ngay / lỗi NullReference. Kịch bản PVE được biên dịch sẵn trong exe Road; thư mục `Server/road/ScriptsPVE` **không được dùng** (Road chỉ biên dịch `Server/road/scripts`, đang trống). Muốn sửa kịch bản mà không build lại: đặt file `.cs` cùng tên lớp vào `scripts` (DLL biên dịch từ đây được đăng ký trước exe nên đè được), nhưng phải tách `Game.Base/Game.Logic/Game.Server/SqlDataProvider/Bussiness.dll` (Costura) ra cạnh exe trước, thiếu thì biên dịch lỗi và Road không khởi động.

IIS (IIS_IUSRS) được cấp quyền sửa **riêng các file `Request/*.xml` và `Request/logs`** (không phải cả thư mục) để `.ashx` ghi được XML và log.

---

## 10. Dựng lại từ đầu (VPS mới)
Xem `_setup/run.txt` và các script `_setup/B1-sql.ps1` (SQL + restore 5 DB), `B2-config.ps1` (config), `B3-iis-php.ps1` (IIS/PHP), `2-go-backdoor-nap.ps1`, `sql/wipe-ve-trang.sql` (xóa dữ liệu người chơi cũ, giữ cấu hình), `sql/links-localhost.sql`, `sql/tao-nhan-vat-max.sql`, `runtime/config.xml` (config.xml của Flash). Sau đó đặt lại các bước trong mục 8 (php.ini, quyền Temp, bind 0.0.0.0, IIS bindings, SSL win-acme, file bí mật).
Bộ chạy nặng (Server binary, 5 `.bak`, Flash, Resource.Server, launcher_base) tải riêng (TeraBox/Drive) → `C:\Gunny92`.

---

## 11. Giftcode (code quà)

**Cách game xử lý** (`Db_Tank41.SP_Active_PullDown`, gọi từ `ActivePullDown.ashx`): sự kiện `Db_Tank.Active` có `HasKey=1` thì client hiện ô nhập code trong bảng Hoạt động/Lịch; code là dòng `Db_Tank41.Active_Number`; quà là các dòng `Db_Tank.Active_Award` của sự kiện, lọc `Sex = giới tính nhân vật hoặc 0` và `Mark` = Mark của code; quà gửi qua thư, **mỗi thư 5 món** (nhiều món thì nhiều thư). `IsOnly=1`: mỗi người nhận 1 lần mỗi sự kiện. Mã trả về: 0 ok, 4 code sai, 5 đã dùng, 6 đã nhận sự kiện này, 7 chưa tới ngày, 8 hết hạn, 1 không có sự kiện.

**Code dùng chung** (`_setup/sql/giftcode-dung-chung.sql`, đã áp): bản gốc đánh dấu đã dùng bằng `UPDATE ... WHERE AwardID=@AwardID` nên 1 tên code chỉ dùng 1 lần toàn server. Bản vá: dòng code có `Creator = -1` là dùng chung, dòng gốc (`UserID=0`) không bị khóa, mỗi người nhận thì thêm 1 dòng `(AwardID, UserID)`, nhập lại trả 5. Code thường giữ nguyên. SP gốc sao lưu `SP_Active_PullDown_goc`. Đã test trong transaction: dùng chung (người 1 ok, nhập lại 5, người 2 ok), code thường (người 1 ok, người 2 → 5). Code không phân biệt hoa thường.

**Kiểu code** (`_setup/sql/giftcode-nhieu-lan.sql`, chạy SAU `giftcode-dung-chung.sql`; khóa chính bảng là (AwardID, UserID)): cột `Creator` của dòng gốc (`UserID=0`) quyết định kiểu. `0` = 1 lần (kiểu cũ của game); `-1` = mỗi người 1 lần; `< -1` = nhiều lần, tổng `-Creator-1` lượt, 1 người nhập lại được (dòng nhận của người đó có `Creator` = số lần đã nhận). Lượt đã dùng = `SUM(IIF(Creator>0,Creator,1))` các dòng `UserID<>0`. Cờ `IsOnly` của sự kiện (1 người chỉ nhận 1 code trong sự kiện) chỉ áp cho kiểu cũ. Đã test trong transaction: nhiều lần 3 lượt (bialk 2 lần + người 2 → hết lượt trả 5), mỗi người 1 lần (lần 2 trả 5). Admin > Giftcode > Chọn sự kiện: ô tên code (trống = tự sinh) + chọn 1 trong 2 kiểu; bảng "Code của sự kiện" có nút Sao chép, số lượt đã dùng, Xóa (chỉ xóa dòng gốc, giữ lịch sử).

Dựng lại SP từ đầu: hoàn tác về `SP_Active_PullDown_goc` (cuối `giftcode-dung-chung.sql`), chạy `giftcode-dung-chung.sql`, rồi `giftcode-nhieu-lan.sql`.

**Code VIP test phó bản** (`_setup/sql/giftcode-vip-test.sql`, sự kiện **#61**, hạn 90 ngày, code dùng chung **`NETCO4VIP`**): mỗi ô trang bị lấy món mạnh nhất trong các món (1) có trong client gốc, (2) có nguồn kiếm hợp lệ (Shop, Drop_Item, Shop_Goods_Box, Item_Fusion, tiến hóa Item_Strengthen_Goods, Quest_Goods), (3) không có tên đánh dấu tự chế. Món cường hóa được (vũ khí, vũ khí phụ, mũ, áo) là +12. 15 món mỗi nhân vật (nam/nữ theo giới tính):
| Ô | Món |
|---|---|
| Vũ khí | 71964 LEGEND-Thánh Kiếm Theia +12 (A888 D168 N898 M228, sát thương 288) |
| Vũ khí phụ | 17017 LEGEND-Thiên Sứ Ban Phúc +12 |
| Nhẫn ×2 / Vòng tay ×2 | 95354 Nhẫn 12 Tuổi +10 / 85204 Vòng Tay 12 Tuổi +10 |
| Dây chuyền / Cánh / Bộ | 14045 S-Côn Con Dục Thần / 15137 Cánh Huyền Diệu / 13890 Khắc Tên Top 2 |
| Mũ +12 / Kính / Áo +12 | 1757 / 1858 Khải Hoàn Khôi; 2310 / 2407 Hoàng Long Khôi; 60000042 Cơn thịnh nộ Sulan / 60000102 Áo Giáp Mathias nữ (Siêu cấp) |
| Mặt / Tóc / Hiệu ứng mắt | 6352 / 6410; 3533 / 3671; 4360 / 4627 |
Đã test nhận code trong transaction: mã 0, 3 thư, 15 món, đúng +12. **Sửa 21/10** (`_setup/sql/giftcode-sua-gioi-tinh.sql`): áo nữ trước ghi nhầm 60000101 (Mathias bản **nam**, nữ không mặc được) → 60000102. Test cũ chỉ đếm `Sex` của quà, không đối chiếu `NeedSex` của món, nên không bắt được.

**Giới tính quà:** `Active_Award.Sex` (1 nam, 2 nữ, 0 cả hai). Admin > Giftcode > Thêm quà tự lấy `Shop_Goods.NeedSex` của món (trước 21/10 luôn ghi 0, đồ nam/nữ phát cho cả hai). Bảng quà có cột "Phát cho", món lệch hiện đỏ. Món chỉ có một giới tính thì thêm cả bản nam và bản nữ. Đổi sự kiện/quà xong: admin > Hệ thống > xuất bản `ActiveList`, client phải tắt mở lại launcher.

## 12. Ảnh vật phẩm (admin)
`admin/lib.php` `item_icon_rel()` chép công thức `PathManager.solveGoodsPath` của client (theo `CategoryID` + `Pic` + `NeedSex`, bảng `EquipType.TYPES`); không có thì thử `image/unfrightprop|prop|error/<pic>/icon.png`. `admin/icon.php` đọc file từ `C:\Gunny92\Resource.Server` và trả ảnh (chỉ admin đã đăng nhập), vì `res.netco4.click` không có HTTPS. Thử mẫu: 1.313/1.919 mẫu có ảnh, trang bị/vũ khí gần đủ; các loại client 3.0 không có (10, 37, 61, 62, 71, 74, 82 đến 91) hiện ô "?". DB có 19.122 vật phẩm nhưng client chỉ biết 13.047.

## 13. Điểm danh trên web (thay điểm danh trong game)
Điểm danh trong game bị server gốc **khóa cứng trong `Game.Server.dll`** (đã kiểm IL của bản đang chạy: `SignAwardHandler` chỉ còn lệnh báo "Tính năng bị khóa!", `DailyAwardHandler` loại 0 và 2 cũng vậy). Thêm nữa, bản gốc tin số ngày client gửi lên (nhận quà mốc lặp được). Nên chuyển ra web:
- `_setup/sql/diem-danh-web.sql`: `Db_Tank41.dbo.Web_DiemDanh` (khóa chính `UserID, Ngay` → không nhận 2 lần/ngày kể cả bấm đồng thời) và `Web_DiemDanh_Qua` (`Moc` 0 = mỗi ngày, N = khi đủ N ngày trong tháng).
- `website_backend/app/Http/Controllers/DiemDanhController.php`: `POST /api/diemdanh/info`, `POST /api/diemdanh` (bearer token của portal). Ngày lấy theo `GETDATE()` của SQL Server (giờ VN). Quà gửi qua `SendMailAndItem.aspx` (an toàn cả khi online); gửi lỗi thì xóa dòng điểm danh để bấm lại.
- Portal: khung "Điểm danh tháng" trong bảng tài khoản (lịch tháng, quà mỗi ngày, các mốc). Admin > **Điểm danh**: thêm/xóa quà, thống kê, danh sách điểm danh gần đây.
- Đã test đầu cuối bằng tài khoản tạm (đăng ký → tạo nhân vật → đăng nhập → điểm danh → lần 2 bị chặn → thư có vật phẩm → token sai bị 403) rồi xóa sạch.

## 14. Portal: trang chủ + trang cá nhân `/dashboard`
- **CSS chung** `website_backend/public/css/portal.css` (màu, nút, ô nhập, điểm danh). Sửa giao diện ở đây; mỗi trang chỉ thêm CSS riêng của nó.
- **Trang chủ** (`welcome.blade.php`): tải client + khung **Đăng nhập hiện trước**, link "Đăng ký ngay" mới mở form đăng ký (đăng ký xong tự quay về đăng nhập, điền sẵn tên). Đăng nhập xong chuyển `/dashboard`. Token lưu `localStorage.gn_token` (bearer của `/api/login131`).
- **Trang cá nhân** (`dashboard.blade.php`, route `/dashboard`): menu trái (`#hoso`, `#diemdanh`, các mục "sắp có": rương đồ, đổi mật khẩu, lịch sử). Thêm mục mới = thêm 1 `<a data-sec="x">` + 1 `<section id="sec-x">`. Không có token → về `/`; token hết hạn (403) → đăng xuất.
- **API hồ sơ** `POST /api/hoso` (`HoSoController`): tài khoản + nhân vật (cấp, % lên cấp, lực chiến, vàng, xu, xu khóa, thắng/trận, bang, công hiến, thành tích, ngày tạo, lần cuối). Nhân vật đang online thì số trong DB có thể chậm vài phút so với game.
- Admin > Gửi quà: mặc định **ẩn món client không có file ảnh** (vd đồ thú cưng `hat28`, `cloth28` trở lên của bản game mới hơn: vào game cũng vô hình). Ô chọn "Chỉ món KHÔNG có ảnh (để test)" để xem riêng các món này.

## 15. Mini game web trên `/dashboard` (xu web)
- **Bảng:** `_setup/sql/minigame-web.sql` (Db_Member, chạy lại an toàn). **Code:** `website_backend/app/Http/Controllers/MiniGameController.php` + `app/Support/{XuWeb,CauHinh,GameMail,VatPham}.php`. **Admin:** trang **Mini game** (`admin/pages/minigame.php`).
- **Xu web** = `Db_Member.Mem_Account.Money`. Cộng/trừ chỉ qua `XuWeb::doi()` (1 lệnh `UPDATE ... WHERE Money+delta>=0`, không âm kể cả bấm đồng thời) + sổ cái `Web_SoXu`. Đổi sang xu game bằng `/api/convertCoin` có sẵn (ChargeMoney, tạo lệnh chờ nhận `Charge_Money`, **1 xu web = 2 xu game**). Nguồn xu web: điểm danh (`Web_DiemDanh_Qua.XuWeb`, mặc định +5.000/ngày), lật thẻ, admin cộng.
- **Tài xỉu:** 3 xúc xắc `random_int`, thắng x`tx_heso` (1,95), bão = cả 2 cửa thua (nhà cái ~5,2%). Chén kéo mở theo giao diện TLBB.
- **Dò mìn:** 25 ô, 1 đến 24 mìn, hệ số = `dm_rtp` × ∏(25-i)/(25-mìn-i), trần `dm_tran`. Vị trí mìn không gửi về trình duyệt khi ván đang mở. 1 ván mở/người; ván treo quá 2 giờ tự rút theo hệ số hiện tại.
- **Lật thẻ sau phó bản:** server game đã tự ghi mỗi màn thắng vào `Db_Tank41.Sys_Users_Log` (`Type='WinMission'`, `Content`=Mission_Info.Id, do `GamePlayer.OnMissionOver` gọi `SP_Insert_UsersLog`). Web đọc bảng này khi người chơi mở dashboard. Thắng **ải cuối** của phó bản (`Web_The_PhoBan.ManCuoi`, tách từ tên ải bỏ " S4"/" ải 4") thì có 1 lượt, giới hạn `SoLanNgay` (trống = `lt_solan` = 3) mỗi phó bản mỗi ngày. Bàn **21 lá** (3×7, ảnh tách từ `Flash/ui/spain/swf/gameover.swf`), lật **3 lá**. Lá bài chỉ là UI: quà quay theo `Web_The_Qua.TrongSo` **lúc bấm lật**; lật đủ 3 thì quay nốt 18 lá còn lại để hiện "đã bỏ lỡ". Phó bản có bộ quà riêng (`Khoa`) thì dùng, không thì bộ chung (`Khoa NULL`). Quà vật phẩm vào `Web_Ruong`, xu vào ví.
- **Rương web:** rút tối đa 5 món/lần vào hộp thư game (`GameMail::send` → SendMailAndItem). Xóa khỏi rương trong transaction, gửi thư lỗi thì rollback.
- **Ảnh vật phẩm công khai:** `GET /hinh/{TemplateID}` (đọc Resource.Server, client không có ảnh thì trả ô "?").
- **Không có công cụ ép kết quả** (khác bản TLBB). Đã test đầu cuối bằng tài khoản tạm rồi xóa sạch: chặn cược sai, số dư khớp sổ cái, dò mìn không lộ mìn, lượt lật chỉ tạo khi thắng ải cuối, giới hạn 3/ngày, lá thứ 4 bị chặn, rút rương ra thư thật, đổi xu tạo lệnh chờ nhận.
- IIS nhớ 404 của file tĩnh mới thêm một lúc: link ảnh mới nên kèm `?v=`.

## 16. Rút xu game ra web (thư gửi nhân vật NganHang)
- `_setup/sql/rut-xu-ngan-hang.sql`: bảng `Db_Member.Web_RutXu` (unique MailID), cấu hình `rut_mo / rut_ten / rut_tile / rut_tran_ngay`, tạo nhân vật **NganHang** (UserID 241, UserName `zz_nganhang_web`, **không có Mem_Account nên không ai đăng nhập được**), và đặt `DB_Admin.settings he-so-doi-coin = 1` (nạp xu web→game 1:1; trước là 2).
- Người chơi trong game gửi **thư kèm xu, không kèm đồ** cho `NganHang`. Game gốc (`UserSendMailHandler`, đã kiểm IL bản đang chạy) tự `RemoveMoney` + tạo thư `Type=1, Money>0` + `SaveIntoDatabase` ngay, nên **an toàn cả khi đang online**.
- `MiniGameController::nhanXuNganHang` chạy mỗi lần gọi `/api/vi` (mục Ví tự gọi 10 giây/lần): `DELETE` từng thư (chỉ 1 lần) → `Web_RutXu` → cộng xu web `floor(xu / rut_tile)`. Vượt `rut_tran_ngay` thì thư nằm chờ sang ngày. Thư kèm đồ / thư thu tiền (Type 2) bỏ qua, nằm lại ở NganHang.
- **Giữ `rut_tile` = `he-so-doi-coin`**, lệch nhau là người chơi quay vòng nạp/rút để in xu.
- Đã test (thư giả lập đúng như game tạo): 1,5 triệu → 1,5 triệu xu web; 800 nghìn vượt trần → chờ; kèm đồ / thu tiền bỏ qua; gọi lại không cộng trùng; sổ cái khớp.

## 17. Vận hành: khởi động lại VPS (15/10/2026)
- Đã tạo 2 tác vụ SYSTEM: `GunnyServers` (onstart) và `GunnyWatchdog` (5 phút/lần), cùng chạy `C:\Gunny92\start-servers.ps1` (chờ SQL rồi bật Center → Fighting → Road nếu chưa chạy). Đã test qua 1 lần reboot: game tự lên sau khoảng 3 phút.
- `sshd` trước đây để Manual nên reboot xong mất SSH. Đã đặt `Automatic`. Nếu mất SSH: vào bảng điều khiển VPS trên web nhà cung cấp (QEMU console), PowerShell Run as administrator: `Start-Service sshd; Set-Service sshd -StartupType Automatic`.
- Windows Update tự cài bản vá SQL Server, làm SQL tắt khoảng 3 phút (15:27 đến 15:30 ngày 15/10), rồi chờ reboot. Gặp thì kiểm tra `Get-Service MSSQLSERVER` và khóa `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired`; reboot lúc vắng người (game tự lên nhờ GunnyServers).

## 18. Shop web + kế hoạch kinh tế 2 tháng (Boomerang · Thương Cổ · Búa · Thiên Sứ)
**Code:** `_setup/sql/shop-web.sql` (Db_Member `Web_Shop`, `Web_ShopMua`, `Web_Diem`, `Web_SoDiem`), `MiniGameController::shop/shopMua`, `app/Support/Diem.php`, admin **Shop web** (`admin/pages/shop.php`).
- **A. Xu web**: đổi 1:1 với xu game nên ai cũng nhiều (nhân vật mới có 10 triệu). Dùng cho kệ thường/trung cấp.
- **B. Điểm hoạt động**: **không đổi từ xu được**, chỉ kiếm: điểm danh +10/ngày (`diem_diemdanh`), đủ 7/14/21/28 ngày +20 (`diem_moc`), mỗi lượt lật thẻ (thắng boss phó bản) +5 (`diem_phoban`), tối đa 50/ngày (`diem_phoban_tran`). Acc phụ 10 triệu xu không dồn được nên đồ hiếm bán bằng điểm.
- Mua: khóa dòng hàng + lịch sử mua của người đó (UPDLOCK) nên bấm đồng thời không vượt giới hạn; trừ tiền 1 lệnh không âm; đồ vào `Web_Ruong` (mặc định khóa) rồi rút vào game.
- **Chỉ bán đồ gốc có trong client.** Đã kiểm: Boomerang / SUPER-Boomerang (DB ghi "VIP-Boomerang") / Legend-Boomerang, Thương cổ / SUPER / LEGEND-Thương Cổ, Búa Minotaure / SUPER-Búa Thor / LEGEND-Búa Thor, Thiên sứ ban phúc / VIP / WOW / Super / LEGEND, mảnh ghép VIP/WOW đều có trong client và có ảnh. Đồ admin cũ tự chế (chỉ số 1000×4, sát thương 7.000 đến 15.000, "Bậc Max", "( VIP n )", "Siêu/Supper/Wow Thương cổ", ID 1300xxxxxx / 2222xxxxx / 3222xxxxx) **client không có**: không bán.
- **Tiến hóa đúng logic game** (`Item_Strengthen_Goods`): món gốc cường hóa +10/+11 lên bậc 1, +12 lên bậc 2; bậc 2 dát vàng (`GoldEquipTemplateLoad`, đá 11560, 5%/viên, giữ 30 ngày) thành bản vàng. Shop chỉ bán **bản gốc**, phần lên cấp người chơi tự cày.

**Thu nhập điểm ước tính:** chơi đều ~60/ngày (≈3.600 / 2 tháng), chơi thường ~25/ngày (≈1.500).

| Giai đoạn | Mục tiêu | Mua ở đâu |
|---|---|---|
| Tuần 1 đến 2 | Vũ khí SUPER (Boomerang / Thương cổ / Búa Minotaure 2 triệu, Búa Thor 2,5 triệu) + VIP/WOW Thiên sứ (0,8 / 1,5 triệu), cường hóa +12 lên bậc 2 | Kệ xu web, 1 cái/tài khoản |
| Tuần 3 đến 5 | Vũ khí LEGEND bản gốc: Thương Cổ / Búa Thor 900 điểm, Legend-Boomerang 700 (chơi đều ~15 ngày, chơi thường ~5 tuần), cường hóa +12 | Kệ điểm, 1 cái/tài khoản |
| Tuần 6 đến 8 | Dát vàng LEGEND bậc 2 (kỳ vọng ~20 viên đá 11560 × 30 điểm, 5 viên/ngày) + LEGEND-Thiên Sứ Ban Phúc 1.200 điểm cho người cày nhiều | Kệ điểm + lật thẻ |

Chỉnh giá/giới hạn ở admin, không cần sửa code. Mở thật nên **bỏ 10 triệu xu tặng sẵn** và **tắt code NETCO4VIP** (code test cho thẳng Thánh Kiếm vàng vĩnh viễn).

## 19. Gửi quà test (người chơi tự gửi đồ vào thư game của mình)
- Mục **📮 Gửi quà test** trên `/dashboard`: tìm vật phẩm theo ID/tên/loại (chỉ món client có ảnh), tối đa 5 món/lần (số lượng ≤ `quatest_sl_max`, cường hóa ≤ MaxStrengthLevel, hạn ngày), gửi bằng `SendMailAndItem.aspx` vào **hộp thư của nhân vật thuộc tài khoản đang đăng nhập** (không chọn người nhận khác được).
- Code: `MiniGameController::quaTestTim / quaTestGui`, bảng `_setup/sql/qua-test-web.sql` (`Web_QuaTest` nhật ký, cấu hình `quatest_mo`, `quatest_luot_ngay` = 50, `quatest_sl_max` = 999). Admin > Mini game có bảng nhật ký 15 lần gần nhất.
- **Mở server thật: đặt `quatest_mo` = 0** (admin > Mini game > Cấu hình). Menu tự ẩn, API trả "đang tắt".
- Test PowerShell lưu ý: PS 5.1 làm mất dấu `"` khi truyền JSON cho `curl.exe`. Gửi JSON bằng file (`--data-urlencode ds@file.json`).

## 20. Lật thẻ y hệt game (bảng rơi đồ của game)
- `lt_nguon = game` (`_setup/sql/lat-the-game.sql`): mỗi lá lật trên web quay giống `PVEGame.TakeCard` → `DropInventory.CopyDrop(mã màn, 1)`: `Drop_Condiction` (CondictionType 5, Para1 chứa `,mã màn,`, Para2 chứa `,1,`) → `Drop_Item`; ngưỡng = rand[0, Random lớn nhất), giữ món `Random ≥ ngưỡng`, chọn đều 1; số lượng rand[BeginData, EndData). `-100` vàng / `-200` xu game gửi thư game ngay; tiền tệ khác và món client không có ảnh thì quay lại.
- Chọn bảng (`dropIdCua`), **chỉ bảng có đồ** (113 khai báo loại 5 nhưng 17 bảng rỗng, vd Vòng Xoáy Thường/Khó/AH 10180 đến 10188 = 0 món): (1) bảng lá bài ải boss → (2) bảng rương boss Para2=2 → (3) ải khác cùng phó bản → (4) **cùng phó bản độ khó khác** (bỏ đuôi Dễ/Thường/Khó/Anh hùng/AH/Ác mộng: Vòng Xoáy Thường/Khó/AH dùng bảng boss Vòng Xoáy dễ 10081, 68 món) → (5) bộ quà web. Phó bản không có bảng nào trong DB (Thành Phố Trên Không, Xưởng Hơi Nước, Xatara, Cariga, Dracula, Niên Thú...) dùng bộ quà web (xu web + đồ), cân theo giá shop ở `_setup/sql/lat-the-can-bang.sql`. Vàng (-100) / xu (-200) trong bảng game quy thành xu web (`lt_vang_xuweb`).
- `lt_solat` = 3 lá/lượt (game gốc: ải giữa 1, boss cuối 2). **Lưu ý:** trong game người chơi vẫn được lật bài như cũ; web là phần thưởng **thêm** (giới hạn `SoLanNgay` 3 lượt/phó bản/ngày).


---

## 21. Kinh nghiệm và bẫy đã gặp (ĐỌC TRƯỚC KHI SỬA)
Mỗi dòng dưới đây từng làm mất thời gian ít nhất 1 lần.

**Công cụ trên máy dev (Windows + Git Bash)**
- **Bash tool nuốt dấu `\`** trong `node -e '...'` và heredoc: namespace PHP (`App\Support\X`), đường dẫn `C:\...`, regex `\s` bị hỏng, phép thay chuỗi báo "MISS" hoặc âm thầm sai. Cách làm: viết script `.js` bằng công cụ Write (dùng `String.raw` cho namespace) rồi `node file.js`; sửa file nhỏ dùng công cụ Edit.
- Không nối `&&` một bước sửa có thể lỗi rồi để dòng sau chạy vô điều kiện (đã từng: routes chỉ được ghi một nửa).
- `curl` **không ghi được file vào đường dẫn có dấu tiếng Việt** (thư mục scratchpad `Thiên Long...`): dùng `curl ... | node -e` (đọc stdin) hoặc lưu ở `C:\inst2` trên VPS rồi `scp`.
- Kiểm tra nhanh JS của trang: `curl -s https://gunny.netco4.click/dashboard | node -e '<tách <script>>' && node --check file.js`.

**PowerShell 5.1 trên VPS**
- Không có `&&`, `??`, `?.`. `$home`, `$host` là biến hệ thống, không đặt tên biến như vậy.
- Truyền JSON cho `curl.exe` thì PS 5.1 **làm mất dấu `"`**: ghi JSON ra file rồi `--data-urlencode ds@file.json`.
- POST không có body thì IIS trả **411**: luôn gửi `--data z=0`.
- Script test dài: viết `.ps1` ở máy dev, `scp` lên `C:\inst2\`, chạy `powershell -File ... *> out.txt`, `scp` kết quả về. Output là UTF-16 (đọc bằng `toString('utf16le')`).

**sqlcmd / SQL Server**
- `-f 65001` khi chạy file `.sql` có chữ Việt. `-h -1` và `-y 0` không đi cùng nhau; `-W` và `-y` cũng vậy.
- Kết quả có chữ Việt: `-f 65001 -o C:\inst2\x.txt -u` (file Unicode) rồi `scp` về, in trên console sẽ ra dấu `?`.
- `PRINT` không nhận truy vấn con (gán vào biến trước). `SUM(CASE WHEN EXISTS(...))` lỗi 130: bọc bằng CTE.
- Từ khóa trùng tên cột (`Escape`) phải để trong `[ ]`.
- SP mã hóa: `OBJECT_DEFINITION` trả NULL; muốn biết nó ghi vào đâu thì gọi thử trong `BEGIN TRAN ... ROLLBACK`.

**IIS / Laravel / deploy**
- `deploy.sh` **từ chối chạy khi còn file chưa commit** (kể cả file mới). Đang làm dở thì `git stash push -u -- <file>` → deploy → `git stash pop`.
- `.gitignore` chặn `*.png`. Ảnh của web phải nằm trong `website_backend/public/img/` (đã mở ngoại lệ), nếu không sẽ không lên git và không được deploy.
- IIS **nhớ 404** của file tĩnh vừa thêm một lúc: link ảnh mới kèm `?v=`.
- Blade: `@media` / `@keyframes` phải viết `@@`. Nút và ô nhập **không kế thừa phông** của trang: đã có `button,input,select,textarea{font-family:inherit}` trong `portal.css` (lỗi cũ "BẮT ĐẦU" vỡ dấu).
- Đặt tên class CSS cẩn thận: ô dò mìn từng dùng class `coin` trùng với đồng xu tròn 20px nên ô co thành viên vàng.
- PSR-4 của Laravel tự nhận class mới trong `app/` (không cần `composer dump-autoload`); `deploy.sh` xóa cache route/view/config sau mỗi lần đẩy.

**VPS / vận hành**
- Windows Update tự cài bản vá SQL Server: **SQL tắt vài phút** rồi chờ reboot (15/10 15:27). Reboot lúc vắng người; `GunnyServers` (onstart) + `GunnyWatchdog` (5 phút) tự bật Center → Fighting → Road.
- `sshd` từng để Manual nên reboot xong mất SSH; đã đặt Automatic. Mất SSH: dùng bảng điều khiển QEMU trên web nhà cung cấp VPS (đã ở sẵn trong máy, **không** mở Remote Desktop bên trong nó), PowerShell Run as administrator.
- Đếm người đang chơi: `Sys_Users_Detail.State=1`, hoặc kết nối Established tới cổng 9200.

**Dữ liệu / logic của game (đã kiểm IL bản đang chạy, không chỉ đọc `gameSrc`)**
- Lấy DLL thật để kiểm: các DLL được Costura nhúng trong `Road.Service.exe`. Tách bằng `[Reflection.Assembly]::Load` + `GetManifestResourceStream('costura.<ten>.dll.compressed')` + `DeflateStream`, rồi đọc IL (`GetMethodBody().GetILAsByteArray()`, tìm `ldstr` 0x72 và `call` 0x28/0x6F).
- **Điểm danh trong game bị khóa cứng** trong DLL (`SignAwardHandler` chỉ báo "Tính năng bị khóa!"). Vì vậy làm điểm danh trên web.
- **Mỗi màn thắng, server tự ghi** `Db_Tank41.Sys_Users_Log` (`Type='WinMission'`, `Content`=Mission_Info.Id) qua `SP_Insert_UsersLog`. Lật thẻ trên web dựa vào bảng này, không cần sửa game.
- Tên ải mã hóa phó bản: "Gà Dễ S1", "Vòng Xoáy Thời Gian Thường S4", "Đấu trường gà thường ải 4". Bỏ đuôi `S4` / `ải 4` là ra phó bản, ải số lớn nhất là boss.
- Bảng rơi đồ lật bài (`Drop_Condiction` loại 5 → `Drop_Item`): **113 khai báo nhưng 17 bảng rỗng** (vd Vòng Xoáy Thường/Khó/AH). Luôn kiểm `EXISTS Drop_Item`.
- Thuật toán rơi đồ của game: ngưỡng = rand[0, Random lớn nhất), giữ món `Random ≥ ngưỡng`, chọn đều 1 món. Món trọng số 10.000 ra khoảng 7,5%, món 6.000 khoảng 0,9% (không phải tỉ lệ thuận trọng số).
- **Gửi thư kèm xu trong game** (`UserSendMailHandler`): server tự `RemoveMoney` + tạo thư `Type=1` + `SaveIntoDatabase` ngay. Đây là đường rút xu an toàn khi online (nhân vật `NganHang`). Đồ **khóa** không gửi thư được.
- Lúc thoát game: `State=0` và xu được lưu trong **cùng một lần** `SaveIntoDatabase`.
- **Cộng dồn đồ** theo `Shop_Goods.MaxCount` (1 = không chồng: châu báu, trang bị; đá 99.999; rương 999). Đồ khóa và không khóa không chồng.
- Danh sách vật phẩm client: `Request/TemplateAlllist.xml` (**nén zlib**, 13.047 món), DB có 19.122. Món DB có mà client không có thì vào game thành ô vô hình. Admin cũ tạo nhiều đồ "1000/1000/1000/1000" (ID 1300xxxxxx, 2222xxxxx, 3222xxxxx, "Bậc Max", "( VIP n )"), client đều không có. Kiểm có ảnh bằng `VatPham::file()` / `item_icon_file()`.
- Đồ thú cưng `hat28`, `cloth28` trở lên: client không có ảnh, mặc định ẩn ở admin Gửi quà.
- Tên DB và tên client có thể khác: DB ghi "VIP-Boomerang" nhưng client hiện "SUPER-Boomerang" (cùng ID 7024).
- Tiến hóa vũ khí (`Item_Strengthen_Goods`): +10/+11 lên bậc 1, +12 lên bậc 2. Dát vàng (`GoldEquipTemplateLoad`, đá 11560, `WishBeadRate` 5000/100.000 = 5%, giữ 30 ngày) chỉ áp cho bản **chưa** vàng (71964 là bản vàng của 71962/71963).

---

## 22. Cấu hình web (`Db_Member.dbo.Web_CauHinh`, sửa ở admin > Mini game > Cấu hình)
| Khóa | Hiện tại | Ý nghĩa |
|---|---|---|
| `tx_min` / `tx_max` / `tx_heso` | 100 / 1.000.000 / 1,95 | Tài xỉu: cược, thắng nhận x (bão = thua) |
| `dm_min` / `dm_max` / `dm_rtp` / `dm_tran` | 100 / 1.000.000 / 0,95 / 50 | Dò mìn |
| `lt_mo` / `lt_nguon` / `lt_solan` / `lt_solat` / `lt_vang_xuweb` | 1 / game / 3 / 3 / 1 | Lật thẻ: bật, nguồn quà (game/web), lượt/phó bản/ngày, số lá lật, quy vàng → xu web |
| `diem_diemdanh` / `diem_moc` / `diem_phoban` / `diem_phoban_tran` | 10 / 20 / 5 / 50 | Điểm hoạt động |
| `rut_mo` / `rut_ten` / `rut_tile` / `rut_tran_ngay` | 1 / NganHang / 1 / 2.000.000 | Rút xu game ra web |
| `shop_mo` | 1 | Shop web |
| `quatest_mo` / `quatest_luot_ngay` / `quatest_sl_max` | 1 / 50 / 999 | Gửi quà test (**mở thật đặt 0**) |

Ngoài ra: `DB_Admin.dbo.settings` `he-so-doi-coin` = **1** (nạp xu web → xu game 1:1, phải bằng `rut_tile`). `Server_Config`: `MaxStrengthLevel` 12, `MAXLevel` 60, `WishBeadRate` (Road .config) 5000.

---

## 23. Dựng lại phần web từ đầu (thứ tự chạy SQL trên VPS)
`sqlcmd -S localhost -E -C -b -f 65001 -i C:\Gunny92\_setup\sql\<file>` theo thứ tự:
1. `tao-nhan-vat-max.sql`, `levelinfo-60.sql`, `mo-pho-ban-dac-biet.sql` (cấu hình test)
2. `giftcode-dung-chung.sql` → `giftcode-nhieu-lan.sql` (thứ tự bắt buộc), `giftcode-vip-test.sql`
3. `diem-danh-web.sql` → `minigame-web.sql` (tạo bảng + tách 80 phó bản từ Mission_Info)
4. `rut-xu-ngan-hang.sql` (tạo nhân vật NganHang, đặt tỉ lệ 1:1)
5. `shop-web.sql`, `qua-test-web.sql`, `lat-the-game.sql`, `lat-the-can-bang.sql`
6. `ruong-gop-chong.sql` (gộp rương, chạy lại lúc nào cũng được)

Mọi file đều chạy lại an toàn, trừ `lat-the-can-bang.sql` (ghi đè các dòng xu web của bộ quà chung).

---

## 24. Việc cần làm khi MỞ SERVER THẬT
1. Admin > Mini game > Cấu hình: `quatest_mo` = **0** (tắt gửi quà test).
2. Tắt / xóa code **NETCO4VIP** (admin > Giftcode, sự kiện #61), vì nó cho thẳng Thánh Kiếm vàng vĩnh viễn.
3. Bỏ **10 triệu xu tặng sẵn** cho nhân vật mới (`Request/Web.config` DefaultGold/DefaultMoney, `SP_Users_Active`).
4. Xóa 2 món hiếm test trong bộ quà lật thẻ chung (Thánh Kiếm Theia 71963, Vòng Tay 12 Tuổi 85204) nếu không muốn giữ.
5. Xem lại giá shop sau 1 đến 2 tuần dữ liệu thật (admin > Shop web: đã bán, ai nhiều điểm).
6. Cân nhắc wipe dữ liệu test (`_setup/sql/wipe-ve-trang.sql`, giữ cấu hình) và đổi mật khẩu sa (README mục 5).

## 25. Bot ghép trận PvP (đã cân bằng 15/10/2026)
**Game có sẵn bot, bật cứng:** vào Ghép trận (`eRoomType.Match`) 40 giây không có người (`Fighting ProxyRoomMgr.PickUpRooms`, hằng 40) thì Road tạo bot copy từ chính người chơi (`RingStationMgr.CreateAutoBot`); nhân vật cấp ≤ 3 gặp bot ngay (`GetAutoBot`). `robot.json` / `robotRoom.json` chỉ là người chơi và phòng giả ở sảnh, không đánh. Bot bắn bằng `Game.Logic.Cmd.BotCommand` (lệnh 143): server tự giải đường đạn, nhắm thẳng tọa độ đối thủ.
**Bản gốc lệch:** chỉ số /3 nhưng sát thương gốc, giáp, máu copy 100%; bắn **không sai số**; lệnh 143 **không kiểm tra người gửi** (người thật gửi gói này được server bắn trúng hộ + đạo cụ free).
**Đã vá (không build lại game, dùng Mono.Cecil):** `_setup/botpatch/` (BotTuning = logic; Patcher = chèn IL).
- `Game.Server.dll` (đặt ở `C:\Gunny92\Server\road\`): `CreateAutoBot` `/3` → `BotTuning.Bot.SucManh`, hằng `0.0` → `KGoc/KMau`; `GetAutoBot` `/2`, `/2.0`, `/1.65` → theo `BotPowerPercent`. Bot = **90%** người chơi.
- `Game.Logic.dll` (đặt ở `C:\Gunny92\Server\fight\`): trước `ShootPoint` chèn `x = Bot.Lech(x, player.X)` (trúng/trượt theo `BotHitPercent`); đầu `HandleCommand` chèn `if (!PlayerCharacter.IsAutoBot) return;` (chặn lỗ hổng).
- `BotTuning.dll` ở cả 2 thư mục. Tham số trong `Road.Service.exe.config` / `Fighting.Service.exe.config` (`.bak-bot` là bản trước khi thêm): `BotPowerPercent` 90, `BotHitPercent` 70 (**tỉ lệ trúng theo lượt**: 10 lượt nhắm chuẩn ~7, còn lại cố tình trượt), `BotMissMin` 90 / `BotMissMax` 180 (lượt trượt lệch bao nhiêu pixel); các phát trong 1 lượt (đạo cụ 3 tia) dùng chung kết quả. Đã mô phỏng 10.000 lượt: 70,0%. Sửa tham số → restart Road + Fighting, không cần vá lại.
- CLR nạp DLL rời cạnh exe trước bản Costura nhúng (DLL game không ký strong-name). **Hoàn tác:** xóa `Game.Server.dll`, `Game.Logic.dll`, `BotTuning.dll` trong 2 thư mục rồi restart.
- Vá lại (khi đổi exe game): tách DLL từ exe (README mục 21) → `dotnet run --project _setup/botpatch/Patcher -- <road-dll> <fight-dll> <BotTuning.dll> <ra>`. Patcher tự dừng nếu mẫu IL không khớp. Đã ép JIT thử các hàm vá (`RuntimeHelpers.PrepareMethod`) trước khi đưa lên.

- Kiểm bản vá có được nạp: DLL thuần IL không hiện trong danh sách module (kể cả PowerShell 32-bit). Thử mở file độc quyền `[IO.File]::Open(f,'Open','ReadWrite','None')`: bị khóa = process đang dùng. `BotTuning.dll` chỉ nạp khi có bot đầu tiên.
- Admin: `center_online()` (lib.php) đọc số người đang chơi thật từ Center (`ServerList.ashx` `total`); `State=1` trong DB có thể kẹt sau khi server game tắt ngang. Nút **Reset trạng thái** đặt hết về 0, người đang chơi thật được Road ghi lại `State=1` ở lần lưu tự động kế tiếp.

## 26. Client: đổi chỗ nút Xác nhận / Hủy (15/10/2026)
Mọi hộp thoại xác nhận dùng `com.pickgliss.ui.controls.alert.BaseAlerFrame`, vị trí nút viết cứng trong code (`BaseAlerFrame.as` dòng 331-332, Xác nhận trái / Hủy phải). Không có Flex SDK nên **vá thẳng bytecode**: `node _setup/va-nut/vanut.js <vào.swf> <ra.swf> [--ghi]`. Script tìm hàm có `customPos` + `buttonGape`, đổi chéo tham chiếu `_submitButton` ↔ `_cancelButton` giữa 3 lệnh `set x` cuối, tức nhánh mặc định có cả 2 nút, thành Hủy trái / Xác nhận phải. Nhánh `customPos` (vài khung tự đặt vị trí) giữ nguyên.
- Lớp có trong **`Flash/2.png`** (game chính) và **`Flash/1.png`**: vá cả hai. Sau giải nén mỗi file chỉ khác 8 byte (`sosanh.js`). Muốn kiểm file nào chứa lớp nào: `swfinfo.js`.
- md5: gốc 1.png `7a4a3f50…`, 2.png `240987fd…`; đã vá 1.png `8f18b66c…`, 2.png `6b76732f…`. Bản gốc trên VPS: `C:\inst2\flash-goc-20261015\`.
- Người chơi phải tắt hẳn launcher rồi mở lại (launcher tạo thư mục dữ liệu mới mỗi lần mở, nên không còn cache cũ).
- **Đợt 2 (15/10 tối):**
  - `vacp.js`: vá nhánh `customPos` cùng độ dài. Lệnh [C] đổi đích thành `_submitButton`; lệnh [D] thay bằng `jump` tới đoạn "đặt Hủy vào cp" có sẵn, phần thừa lấp `nop`. Có 2 nút thì Hủy ở vị trí `cp`, Xác nhận nằm bên phải. Chỉ có 1 nút thì giữ như cũ. Áp cho các khung nông trại, thú cưng, nạp đồ shop, tân thủ, league.
  - `quetnut.js` + `doixml.js`: tìm các khung tự đặt nút trong XML, theo tên biến hoặc chữ trên nút (`ok`/`cancel`), rồi đổi `x` của 14 cặp trong `Flash/ui/spain/xml/xml.png`. Đó là bán đồ, khóa túi, kết hôn, tạo/rời/chuyển/nâng cấp bang, thuế bang, nhận thành viên, mua ruộng. File zip được ghi lại: entry không sửa giữ nguyên byte, entry sửa thì nén lại và cập nhật CRC.
  - md5 sau đợt 2: 1.png `f942a1c8…`, 2.png `41b2ace9…`, xml.png `15908ed9…`. Bản gốc của cả 3 nằm trong `C:\inst2\flash-goc-20261015\`.
  - **Còn sót:** khung tự đặt `.x` trong code (`quetnut.js` đánh dấu `+code`), và khung có nút vẽ sẵn trong swf. Gặp khung nào thì sửa riêng khung đó.
