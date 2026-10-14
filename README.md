# Gunny92 NetCo4 — dựng & vận hành server

README này gộp toàn bộ kết quả soát bộ Gunny92 (server, web, client, database) thành hướng dẫn dựng server test cho ~20 người. **Claude phiên sau: đọc hết file này trước khi làm.** Chi tiết bổ sung ở `docs/BAN-GIAO.md`.

> **Repo này = MÃ NGUỒN để phát triển. Phần CHẠY (binary + 5 database .bak + Flash + Resource.Server + launcher) tải riêng** (TeraBox/Drive) giải nén ra `C:\Gunny92`. Repo một mình không chạy được.

---

## 0. Mục tiêu của chủ server
- **Tắt hết web nạp tiền + web thừa.** Chỉ giữ `website_backend` (để launcher đăng nhập).
- **Xóa sạch dữ liệu của admin cũ**, đăng ký **về trắng** (người chơi tự tạo tài khoản mới).
- **Xu chỉ lấy trong game** (điểm danh / boss / túi boss), không nạp tiền.
- Làm giống cách vận hành server TLBB NetCo4.

## 1. Máy & phần mềm
Chỉ chạy **Windows** (.NET Framework + IIS), không có đường Linux thực tế.
| Thứ | Yêu cầu |
|---|---|
| Hệ điều hành | Windows Server 2019/2022 (hoặc Windows 10/11) |
| CPU/RAM/ổ | 4 nhân / 8 GB / 80 GB cho ~20 người |
| SQL Server | **2022** bắt buộc (file `.bak` tạo từ SQL 2022 RTM 16.0.1000; bản cũ không restore được). Developer/Express đều đủ, nên cài **Default instance** để `localhost` chạy |
| .NET | Framework **4.8** |
| IIS | + **URL Rewrite 2.1** (thiếu là lỗi 500.19) + CGI (cho PHP) |
| PHP | **7.4** NTS x64 + `sqlsrv`/`pdo_sqlsrv` + MS ODBC Driver 18 + VC++ redist (cho `website_backend`) |

## 2. Thành phần & thứ tự bật
| # | Tiến trình | Đường | Vai trò | Cổng |
|---|---|---|---|---|
| 0 | SQL Server | — | DB, bật trước | 1433 (nội bộ) |
| 1 | IIS site **Request** | `C:\Gunny92\Request\` (ASP.NET 4.8) | API client: đăng nhập, ServerList | 80 |
| 1b | IIS **Resource** | `C:\Gunny92\Resource.Server\` | ảnh, âm thanh | 80 |
| 1c | IIS **website_backend** | `C:\Gunny92\website_backend\public\` (PHP) | launcher đăng nhập (`/api/login131`) | 8080 |
| 2 | **Center.Service.exe** | `Server\center\` | login/world, WCF | 9302 / 2108 / 2109 |
| 3 | **Fighting.Service.exe** | `Server\fight\` | server đánh nhau | 9308 |
| 4 | **Road.Service.exe** | `Server\road\` | server người chơi vào | **9200** |

Bật: **SQL → IIS → Center → Fighting → Road**. Tắt ngược lại, **Road trước** (lưu dữ liệu). 3 exe là .NET Costura (gộp DLL), DLL thiếu là bình thường.

## 3. Database (5 cái, bỏ tank-gku)
| .bak | DB | Vai trò | Logic name |
|---|---|---|---|
| tank41.bak (45M) | **Db_Tank41** | chính: người chơi, `Server_List`, `Server_Config` | Db_Tank41 / Db_Tank41_log |
| tank.bak (27M) | **Db_Tank** | dữ liệu game: Shop_Goods, Quest, `AreaConfig` | Db_Tank / Db_Tank_log |
| member.bak (11M) | Db_Member | tài khoản web/launcher, `Server_List` | Db_Member / _log |
| admin.bak (113M) | Db_Admin | `settings` (hệ số đổi coin) | Db_Admin / _log |
| gm.bak (4M) | Db_Gm | tool GM (tùy chọn) | Db_Gm / _log |
| ~~tank-gku.bak~~ | — | **BỎ** (của server khác, đè Db_Tank) | |

Khôi phục `WITH MOVE` (data là `.ndf`). Nếu lệch tên logic: `RESTORE FILELISTONLY FROM DISK=N'...'`.

**Bảng phải sửa IP sau restore:**
- `Db_Tank41.Server_List` → `IP`=IP máy, `Port`=9200 (ID phải khớp `ServerID=4` trong config).
- `Db_Tank.AreaConfig` → `DataSource`/`Catalog`/`RequestUrl` về máy mình (đang trỏ server khác).
- `Db_Member.Server_List` → `Host`, `LinkCenter`, `LinkRequest`, `LinkConfig`.
- `Db_Gm.Url_Tank`.
- **Xóa dữ liệu người chơi cũ** (tài khoản, nhân vật, log) — dữ liệu cá nhân người khác + "về trắng".

## 4. Config phải đổi khi sang máy mới
Giá trị cũ cần thay: tên máy SQL **`WIN-DME2N9KU5B0`** → `localhost`; IP cũ **`15.235.163.5`** → IP máy (test: `127.0.0.1`); mật khẩu sa cũ **`abcd@12344`** → mới.
| File | Khóa |
|---|---|
| `Server\center\Center.Service.exe.config` | IP, Port 9302, baseAddress 2108, net.tcp 2109, conString, crosszoneString |
| `Server\fight\Fighting.Service.exe.config` | IP, Port 9308, conString, crosszoneString |
| `Server\road\Road.Service.exe.config` | IP, Port 9200, request, LoginServerIp 9302, WorldServerIp 9202, FightServerIp 9308, PassPort .asmx, net.tcp 2109 |
| `Server\road\battle.xml` | `<server ip=... port=9308>` |
| `Request\Web.config` | ReqPath (`C:\Gunny92\Request\`), LogPath, LoginIP/ChargeIP/AdminIP/SentRewardIP, net.tcp 2109, LoginKey, ChargeKey |
| `website_backend\.env` | APP_KEY, APP_URL, DB_* (4 kết nối), KEY_REQUEST (khớp Request LoginKey), CHARGE_KEY (khớp Request ChargeKey), LAUNCHER_APP_VERSION |

**3 mâu thuẫn phải sửa cho khớp:** AreaID (Road 1004 vs Center/Fight 1001); cổng GM (tool 2009 vs Center 2109); LoginKey (web `-megun`/`-gunny92` vs Request — phải giống nhau).

**Mẹo khỏi build lại launcher:** trỏ domain `*.gunny92.com` về IP máy bằng file **hosts** (`_setup/hosts-them.txt`), giữ nguyên config domain.

## 5. Script dựng tự động (thư mục `_setup`)
Chạy PowerShell Admin trên VPS, theo thứ tự:
1. `B1-sql.ps1` — Mixed Mode + mật khẩu sa + khôi phục 5 DB + sửa Server_List.
2. `B2-config.ps1` — sửa config (localhost + IP + mật khẩu) + mở tường lửa 9200/80 + sửa hosts.
3. `B3-iis-php.ps1` — bật IIS + CGI, cài URL Rewrite/PHP/ODBC/VC++, tạo site Request + website_backend.
4. (trước khi cho bạn bè vào) `2-go-backdoor-nap.ps1` — gỡ 3 cửa sau + route nạp + file nguy hiểm.
Hướng dẫn tay đầy đủ: `_setup/run.txt`.

## 6. Tường lửa
| Cổng | Mở ra internet? |
|---|---|
| 9200 (Road, game) | **CÓ** |
| 80 / 443 (web) | **CÓ** |
| 9302 (Center), 9308 (Fight), 2108, **2109 (WCF, không xác thực)**, 1433 (SQL), 11211 (memcached) | **KHÔNG** |

## 7. ⚠️ BẮT BUỘC vá trước khi mở ra internet
**3 cửa sau:**
1. `website_backend\routes\web.php` dòng ~20 `/chargeTo/{acc}/{coin}` → `ChargeController@index`: **nạp xu vô hạn vào tài khoản bất kỳ, không cần đăng nhập**.
2. `website_backend\routes\web.php` dòng ~24 `/playdebug/{email}` → `PlayController@play3`: **vào game bằng tài khoản bất kỳ, chỉ cần email** (kể cả bị khóa).
3. `newweb\...\ApiController.php` ~461 `loginGameWithLauncher`: ghi cứng tài khoản **`koolkiizz`**.

**Khác:** `/api/cardCallback` (+ `newweb`, `Website`) **không kiểm chữ ký** — tin số tiền người gửi; `newweb` `CheckIfAdmin` **luôn trả true** (ai đăng nhập cũng thành admin: gửi đồ/giftcode/khóa người); admin mặc định `admin@gmail.com`/`password`; `Resource.Server\index.php` **đọc trộm file bất kỳ** (`?url=../Request/Web.config`); `Request\CreateLogin.aspx.cs` tắt kiểm IP + khóa RSA mặc định → **giả được token đăng nhập mọi tài khoản**.

**Đổi hết các khóa đã lộ:** sa password, `APP_KEY`, `KEY_REQUEST`/`LoginKey`, `CHARGE_KEY`/`ChargeKey`, OAuth trong `GM\output\Web.config`.

**Tiền nạp đang chảy về người lạ:** số ACB/Techcombank "PHAM TRUNG KIEN", MoMo 0868862312 "TRAN THI NGUYET" (`website_backend\...\PaymentController.php`, `newweb\...\nap_coin.blade.php`); Gmail người khác trong `Mailer.php`. Chủ server muốn tắt nạp nên **xóa hết route + view nạp**.

**File .exe nghi ngờ — quét VirusTotal trước khi chạy:** `._cache_FuckNewPng.exe` (dấu vết sâu Xred), launcher + GM + Helper không chữ ký. **Không dùng `HelperV1.1`** (tự gửi dữ liệu về `yeubxa.com`, có bộ tự cập nhật ngoài, DevExpress crack, archive .exe giả đuôi .txt).

## 8. Client / launcher
- Launcher = **Electron 11 + Flash nhúng** (PepperFlash). **Trình duyệt thường không chơi được** (Flash đã chết 2021), chỉ chơi qua launcher.
- Bản build sẵn trỏ cứng `gunny92.com` trong `app.asar` → **build lại** (Node + electron-builder, sửa `launcher_base\const.js`) HOẶC dùng mẹo file hosts (mục 4). **Bản 64-bit thiếu thư mục `flashver`** → Flash không chạy; dùng bản 32-bit hoặc thêm `flashver` khi build.
- `flashbaseSrc\` = mã nguồn client (AS3, build bằng Flex/AIR ra `library.swf`). **`Flash\2.png` thật ra là `.swf` đã build — dùng luôn, khỏi build.** Địa chỉ server client lấy từ `ServerList.ashx` (DB), không nằm trong .swf.
- Launcher lưu **mật khẩu người chơi dạng chữ thường** trong `accounts.txt`; updater tải qua HTTP không kiểm chữ ký. Lưu ý khi mở public.

## 9. Lỗi sẵn có
- Thiếu file đạn `bomb\11425–11459` và `13001–13003` (log "can't find bomb file") → vài vũ khí bắn lỗi.
- `website_backend\public\updates\` chỉ có bản 1.2.6 / 1.2.9 nhưng `.env` khai `LAUNCHER_APP_VERSION` cao hơn → launcher kẹt vòng cập nhật. Đặt về bản có thật.

## 10. Nguồn tải phần chạy
Bản chạy (Server, 5 `.bak`, Flash, Resource.Server, launcher): tải từ TeraBox/Drive giải nén `C:\Gunny92`. Link: _(chủ server điền)_. Bản trim sẵn: `Gunny92-run.zip` (4 GB).
