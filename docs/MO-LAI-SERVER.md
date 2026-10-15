# Mở lại GunnyNetco4 trên máy chủ mới (từ gói bản trắng)

**Claude đọc file này trước, sau đó đọc `README.md` và `CLAUDE.md` của repo** (https://github.com/nguyendangkhoa150899-boop/gunny-netco4).
Làm đúng thứ tự dưới đây là có server giống hệt server cũ: cùng code, cấu hình, bản vá, dữ liệu game. Khác ở 2 điểm: **không có người chơi**, và **phải tạo bí mật mới**.

## 0. Gói bản trắng là gì

File `GunnyNetco4-ban-trang-<ngày>.zip` tạo bằng `_setup/dong-goi.ps1`. Nhật ký lúc tạo ở `C:\GoiGunny\dong-goi.log` trên máy cũ.

| Trong gói | Nội dung |
|---|---|
| `Gunny92\` | Toàn bộ `C:\Gunny92` của máy cũ: `Server\` (exe game, DLL bot đã vá, map, config), `Request\` (ASP.NET + XML client), `Flash\` (client đã vá nút), `Resource.Server\` (ảnh, âm thanh), `website_backend\` (Laravel, có `vendor`, file tải launcher), `admin\`, `launcher_base\`, `_setup\`, `start-servers.ps1`. Đã bỏ: log, session, cache, `.bak` cũ, dữ liệu runtime, **bí mật** |
| `DB\*.bak` | 5 DB **bản trắng**: giữ toàn bộ cấu hình và dữ liệu game, xóa sạch tài khoản, nhân vật, thư, ví, nhật ký (`_setup/sql/lam-trang.sql`). Có giữ nhân vật `NganHang` (UserID 241), cần cho tính năng rút xu |
| `DB\PHIEN-BAN-SQL.txt` | Phiên bản SQL Server đã tạo `.bak`. **Máy mới phải cài bản bằng hoặc mới hơn** |
| `PHP7\` | PHP 7.4 NTS x64 đã cấu hình sẵn (`php.ini` + `sqlsrv`) |
| `Flash-goc-chua-va\` | `1.png`, `2.png`, `xml.png` gốc trước khi vá nút, để hoàn tác (README mục 26) |
| `HE-THONG\` | Cấu hình xuất từ máy cũ: `iis-sites.xml`, `iis-apppools.xml`, `task-GunnyServers.xml`, `task-GunnyWatchdog.xml`, `tuong-lua.txt`, `quyen-Request-xml.txt` |
| `BI-MAT-MAU\` | Mẫu `.env` và `appsettings.secret.config`: đủ tên khóa, **không có giá trị** (`__DIEN__`) |
| `dat-mat-khau.ps1` | Thay `__SA_PASSWORD__` trong mọi config bằng mật khẩu sa mới |
| `GIT-COMMIT.txt` | Commit GitHub đang chạy lúc đóng gói (code trong gói = code ở commit này) |
| `MO-LAI-SERVER.md` | File này |

**Không có trong gói, phải làm mới:** mật khẩu sa, `.env`, `appsettings.secret.config`, chứng chỉ SSL, key SSH. Bản sao bí mật của server cũ nằm trong thư mục `GunnyNetco4-BAO-MAT` của chủ server. Không dùng lại mấy khóa đã lộ.

## 1. Thuê máy

- **Windows Server 2019/2022** (máy cũ là bản Windows Server có Cloudbase-Init). Cấu hình 4 nhân, 8 GB RAM, 80 GB ổ cho khoảng 20 người. Gói giải nén khoảng 6 GB.
- Server game là .NET Framework 4.8 + IIS. **Không chạy được trên Linux.**
- Mở cổng (tường lửa nhà cung cấp + Windows): **80, 443** (web), **9200** (Road), **9308** (Fighting), cổng SSH. Không mở 1433, 9302, 2108, 2109.

## 2. Cài phần mềm (PowerShell Admin trên máy mới)

1. **SQL Server**, bản bằng hoặc mới hơn bản trong `DB\PHIEN-BAN-SQL.txt` (máy cũ: 17.x = SQL Server 2025 Express). Chọn **default instance `MSSQLSERVER`** và **Mixed Mode**, đặt mật khẩu sa mới. Cài thêm `sqlcmd` (ODBC 18) và SSMS nếu muốn.
   - Đặt biến cho các script: `$env:GUNNY_SA_PASSWORD = '<mật khẩu sa mới>'`
2. **IIS** + CGI + ASP.NET 4.8 + **URL Rewrite 2.1** + VC++ redist x64/x86. Phần IIS trong `_setup/B3-iis-php.ps1` làm sẵn được (nó tìm bộ cài trong `C:\inst`).
3. **7-Zip**, **Git for Windows** (để Claude dùng bash/scp), **OpenSSH Server** (mục 7).

## 3. Giải nén và DB

```powershell
# giai nen goi vao C:\GoiGunny\GunnyNetco4 roi:
robocopy C:\GoiGunny\GunnyNetco4\Gunny92 C:\Gunny92 /E
robocopy C:\GoiGunny\GunnyNetco4\PHP7 C:\PHP7 /E
powershell -ExecutionPolicy Bypass -File C:\Gunny92\_setup\dat-mat-khau.ps1      # thay __SA_PASSWORD__
```
Khôi phục 5 DB, **đúng tên**: `Db_Tank41`, `Db_Tank`, `Db_Member`, `Db_Admin`, `Db_Gm`. Có thể dùng SSMS (Restore Database, chọn file) hoặc:
```powershell
$bak = 'C:\GoiGunny\GunnyNetco4\DB'; $data = 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA'  # sua theo ban SQL
foreach ($d in 'Db_Tank41','Db_Tank','Db_Member','Db_Admin','Db_Gm') {
  $f = sqlcmd -S localhost -E -C -h -1 -W -Q "SET NOCOUNT ON; RESTORE FILELISTONLY FROM DISK=N'$bak\$d.bak'" | Where-Object { $_ -match '\S' } | ForEach-Object { ($_ -split '\s+')[0] }
  $mv = ($f | ForEach-Object -Begin { $i = 0 } -Process { "MOVE N'$_' TO N'$data\${d}_$i." + $(if ($i -eq 0) { 'mdf' } else { 'ldf' }) + "'"; $i++ }) -join ', '
  sqlcmd -S localhost -E -C -b -Q "RESTORE DATABASE [$d] FROM DISK=N'$bak\$d.bak' WITH REPLACE, $mv"
}
```
(Nếu `RESTORE FILELISTONLY` trả về nhiều cột khó tách thì dùng SSMS, nhanh hơn.)

## 4. Bí mật mới

- `C:\Gunny92\website_backend\.env`: chép từ `BI-MAT-MAU\website_backend.env`, điền các `__DIEN__`:
  - `DB_PASSWORD` = mật khẩu sa.
  - `APP_KEY`: chạy `C:\PHP7\php.exe artisan key:generate` trong `website_backend`.
  - `KEY_REQUEST`, `CHARGE_KEY`: chuỗi ngẫu nhiên mới (32 ký tự).
  - `ADMIN_PANEL_PASS`: mật khẩu admin panel.
  - Các khóa khác (mail...) để trống nếu không dùng.
- `C:\Gunny92\Request\appsettings.secret.config`: chép từ `BI-MAT-MAU\Request-appsettings.secret.config`. Điền **`LoginKey` = `KEY_REQUEST`**, **`ChargeKey` = `CHARGE_KEY`** (hai cặp phải giống hệt nhau, lệch là không vào được game), rồi thay `__SA_PASSWORD__`.
- Sinh chuỗi ngẫu nhiên: `-join ((48..57)+(65..90)+(97..122) | Get-Random -Count 32 | ForEach-Object {[char]$_})`

## 5. Đổi IP / tên miền

Mọi chỗ ghi IP cũ `171.244.39.225`. Đổi hết sang IP mới:

| Chỗ | Cách đổi |
|---|---|
| DNS (iNET, `netco4.click`) | Bản ghi A `gunny`, `flash1`, `res`, `quest1`, `admingunny` trỏ IP mới. **Tắt OneShield** (proxy làm hỏng kết nối game) |
| `Db_Tank41.dbo.Server_List` | `UPDATE Db_Tank41.dbo.Server_List SET IP='<IP mới>', Port=9200` (client nối thẳng IP này) |
| `Db_Member.dbo.Server_List`, `Db_Tank.dbo.AreaConfig`, `Db_Gm.dbo.Url_Tank` | Xem trước bằng `SELECT`, rồi thay IP cũ (`_setup/sql/links-localhost.sql` là mẫu) |
| `C:\Gunny92\Server\*\*.config`, `Server\road\battle.xml` | `Select-String -Path C:\Gunny92\Server\*\*.config,C:\Gunny92\Server\road\battle.xml -Pattern '171.244.39.225'` rồi thay. Road/Fighting bind `0.0.0.0` |
| `Request\Web.config` (`LoginIP`/`ChargeIP`/`AdminIP`) | Chỉ được để `127.0.0.1` (web và admin gọi nội bộ). **Không để trống**: trống là mở cho mọi IP |
| `Flash\config.xml` | Dùng tên miền, không cần đổi nếu giữ `netco4.click` |
| Launcher (`launcher_base`, file tải về) | Gọi `http://gunny.netco4.click`, không cần đổi. Đổi tên miền thì xem README mục 6 |

**Center chỉ đọc `Server_List` lúc khởi động**: đổi xong phải restart Center.

## 6. IIS, quyền, SSL

- Dựng 5 site theo `HE-THONG\iis-sites.xml`:
  - `Request`: bắt mọi host cổng 80, trỏ `C:\Gunny92\Request`.
  - `gunweb`: `gunny.netco4.click` 80/443 (+8080), trỏ `website_backend\public`, PHP FastCGI `C:\PHP7\php-cgi.exe`.
  - `flashsite`: `flash1` 80, trỏ `Flash`, có MIME `.swf`.
  - `ressite`: `res` 80, trỏ `Resource.Server`.
  - `adminsite`: `admingunny` 80/443, trỏ `admin`.
  - Có thể nhập thẳng: `appcmd add site /in < iis-sites.xml` (xóa site Default trước, sửa đường dẫn nếu khác).
- Quyền (README mục 8, 9):
  - `IIS_IUSRS` được **Modify** riêng các file `Request\*.xml` và thư mục `Request\logs`. Danh sách quyền máy cũ ở `HE-THONG\quyen-Request-xml.txt`.
  - `website_backend\storage` và `bootstrap\cache` cho `IIS_IUSRS`.
  - `C:\Windows\Temp` cho `IIS_IUSRS`/Users. Thiếu quyền này thì mọi `.aspx` báo 500 CS0016.
- `php.ini`: `extension=php_sqlsrv_74_nts.dll` (phải có đuôi `.dll`). `.env`: `CACHE_DRIVER=file`.
- SSL: win-acme cho `gunny` và `admingunny`, rồi gia hạn bằng `wacs.exe --renew --force`. Bản cũ không tự gia hạn, nên đặt task.

## 7. Chạy game, tự bật, SSH cho Claude

- Thứ tự bật: SQL, IIS, **Center, Fighting, Road** (tắt thì làm ngược lại). Bật bằng `powershell -ExecutionPolicy Bypass -File C:\Gunny92\start-servers.ps1` (WMI, không chết theo phiên SSH).
- Task tự bật lại (máy cũ đã chạy ổn):
  ```
  schtasks /create /tn GunnyServers /tr "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\Gunny92\start-servers.ps1" /sc onstart /ru SYSTEM /rl HIGHEST /f
  schtasks /create /tn GunnyWatchdog /tr "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\Gunny92\start-servers.ps1" /sc minute /mo 5 /ru SYSTEM /rl HIGHEST /f
  ```
- SSH:
  - `Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0; Set-Service sshd -StartupType Automatic; Start-Service sshd`.
  - Thêm public key vào `C:\ProgramData\ssh\administrators_authorized_keys`, rồi `icacls ... /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"`.
  - Tắt đăng nhập bằng mật khẩu.
- Windows Defender realtime đã phải tắt trên máy cũ mới chạy được exe game. Quét exe trước, chấp nhận rủi ro.

## 8. Kiểm tra (theo thứ tự)

1. `http://quest1.netco4.click/ServerList.ashx?rnd=0.1` trả về `<Item ... IP="<IP mới>" Port="9200" ...>`.
2. Mở https://gunny.netco4.click, đăng ký tài khoản, đăng nhập. Tải launcher, vào game. **Nhân vật mới tự lên cấp 60**, có 50 triệu vàng và 10 triệu xu (cấu hình server test).
3. Mở https://admingunny.netco4.click, đăng nhập `admin` + `ADMIN_PANEL_PASS`. Dashboard phải thấy số người online.
4. Hộp thoại trong game: **Hủy bên trái, OK bên phải** (bản vá README mục 26).
5. Log: `C:\Gunny92\Server\road\logs\Error.log` (Road có thể ghi lỗi `bomb` lúc khởi động, đó là bình thường) và `website_backend\storage\logs`.
6. **GM:** trong bản trắng `Game_Commands` chỉ còn dòng `UserID 1`. Tạo nhân vật xong thì cấp GM ở admin > Hệ thống.

## 9. Trước khi mở cho người thật

README mục 24:
- `quatest_mo = 0` (tắt gửi quà test).
- Tắt code `NETCO4VIP`.
- Bỏ 10 triệu xu tặng sẵn (`Request/Web.config` DefaultGold/DefaultMoney, `SP_Users_Active`).
- Xem lại quà lật thẻ và giá shop.
- Bật lại giới hạn tốc độ API, cân nhắc đóng đăng ký công khai.
- Giới hạn IP admin panel.
- Đặt sao lưu DB hằng ngày (máy cũ **chưa có**).

## 10. Những gì đã nghiên cứu (tóm tắt, chi tiết ở README)

| Chủ đề | Kết luận | README |
|---|---|---|
| Kiến trúc | Launcher Electron 11 + PepperFlash. Web Laravel (`/play2`) gọi `CreateLogin.aspx`, rồi Center (WCF). Client nối Road 9200, sang Fighting 9308 khi đánh | 1 |
| Client tải gì | `Loading.swf`, `config.xml`, `DDT_Loading.swf` (chỉ là màn loading), `ui/spain/xml/xml.png` (zip XML giao diện), **`2.png` = code game chính** (`?lv=259`), `ui/spain/swf/*.swf`. Launcher **không cache**: mỗi lần mở dùng `userData` mới | 26 |
| Gỡ lỗi client | Không có log client. Xem **log IIS** `C:\inetpub\logs\LogFiles\W3SVC3` (flash1) để biết máy người chơi tải file nào, bao nhiêu byte. Chạy `netsh http flush logbuffer` trước khi đọc | 26 |
| Vá client không cần Flex SDK | Vá bytecode AVM2 tại chỗ (`_setup/va-nut/*.js`: đọc ABC, tìm hàm, đổi tham chiếu/lệnh cùng độ dài), sửa XML trong `xml.png` (ghi lại zip giữ nguyên byte các entry khác). Nút Hủy trái, OK phải | 26 |
| Màn hình giấy trống khi vào game | Do đồ có ID **không có trong `Request/TemplateAlllist.xml`** (đồ admin cũ tự chế 352xxxxx…) nằm trong túi, client lỗi lúc dựng sảnh. Web/admin giờ chặn qua `VatPham::dungDuoc` / `item_in_client` / `GameMail` | CLAUDE.md |
| Dữ liệu `tank.bak` thiếu so với client | Nhiệm vụ 179 so với 1.115, NPC, shop. Đã nạp lại từ XML gốc. **Không chạy `CreateAllXml.ashx`** | 9 |
| Người online | Dữ liệu nằm trong RAM Road: không UPDATE thẳng vàng/xu/đồ. Xu dùng `ChargeMoney.aspx`, đồ dùng `SendMailAndItem.aspx` | 3, 4 |
| Tiền tệ web | Xu web = `Mem_Account.Money`, chỉ đổi qua `XuWeb::doi` (nguyên tử). Đổi web sang game 1:1 (`ConvertCoin`, đã vá chi tiêu kép). Rút game sang web: gửi thư kèm xu cho `NganHang` | 15, 16 |
| Giftcode | SP `SP_Active_PullDown` đã vá: code dùng chung, nhiều lượt | 11 |
| Điểm danh trong game | Bị khóa cứng trong DLL, nên làm trên web | 13 |
| Lật thẻ web | Dựa vào `Sys_Users_Log` `WinMission`. Bảng rơi giống game | 15, 20 |
| Bot PvP | Vá IL bằng Mono.Cecil (`_setup/botpatch`). DLL rời đặt cạnh exe đè bản Costura | 25 |
| Cấp tối đa 60 | `LevelInfo` 60 dòng + `LevelList.xml` | 3 |
| Bẫy công cụ | PS 5.1 (không có `&&`, JSON mất `"`, POST rỗng bị 411), `sqlcmd -f 65001`, Bash nuốt `\`, IIS nhớ 404 | 8, 21 |

## 11. Cho Claude (phiên dựng máy mới)

- Đọc: file này, rồi `CLAUDE.md`, rồi `README.md` (mục 21 bẫy, 8 lỗi đã gặp).
- Cần chủ server đưa: IP máy mới, cách vào (RDP/SSH), mật khẩu sa mới (đặt vào `$env:GUNNY_SA_PASSWORD`, **không in ra chat**), quyền DNS.
- Lệnh từ xa: `ssh -i <key> Administrator@<IP> "<PowerShell>"`. Lệnh dài: viết `.ps1`, `scp` lên `C:\inst2`, rồi chạy `powershell -File`.
- Sau khi dựng: sửa `README.md` (IP, đường dẫn), và đổi IP mặc định trong `_setup/deploy.sh` (hoặc đặt biến `GUNNY_VPS=Administrator@<IP mới>`). `deploy.sh` so sánh với `C:\Gunny92\.deployed-commit`: trên máy mới tạo file này bằng nội dung `GIT-COMMIT.txt` trong gói (commit đã deploy lúc đóng gói), để lần deploy đầu chỉ đẩy phần đổi.
