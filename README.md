# GunnyNetco4: server Gunny (DDTank) test

Server Gunny riêng để chơi thử với bạn bè. **Claude phiên sau: đọc hết file này + `CLAUDE.md` trước khi làm gì.**
Mật khẩu, key SSH, cách kết nối VPS **không nằm trong repo**: chủ server giữ ở thư mục `GunnyNetco4-BAO-MAT` (Desktop), hỏi chủ server nếu cần.

| | |
|---|---|
| Trang người chơi | https://gunny.netco4.click (tải client Windows/Mac, đăng ký, đăng nhập) |
| Admin panel | https://admingunny.netco4.click |
| VPS | Windows Server, `171.244.39.225`, thư mục chạy `C:\Gunny92` |
| Repo | https://github.com/nguyendangkhoa150899-boop/gunny-netco4 (riêng tư) |

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
- `SP_Users_Active` (Db_Tank41) vá bởi `_setup/sql/tao-nhan-vat-max.sql`: cấp = dòng cao nhất của `Db_Tank.dbo.LevelInfo` (**hiện 30**, GP 3.490.849), `Gold/Money/MoneyLock` lấy từ tham số. Bản gốc ghi cứng cấp 1 và 0 vàng/xu.
- Số tài nguyên: `DefaultGold` (50.000.000) và `DefaultMoney` (10.000.000, cũng dùng cho xu khóa) trong `Request/Web.config`. Hàm tạo nhân vật chạy trong tiến trình **Request** (`gameSrc/Tank.Request/Login.cs` → `BaseInterface.CreateLogin` → `ActivePlayer`).
- Cấp tối đa server dùng `LevelMgr.MaxLevel = số dòng LevelInfo`. `Server_Config.MAXLevel=60` **không** quyết định cấp. Muốn trên 30 phải thêm dòng LevelInfo và client phải hỗ trợ.

**Tiền tệ** (`Db_Tank41.Sys_Users_Detail`): `Gold` = vàng, `Money` = xu, `MoneyLock` = xu khóa. `Db_Member.Mem_Account.Money` là xu web (khác xu trong game).

**Dữ liệu người chơi đang online nằm trong RAM của Road**, lúc thoát/định kỳ server ghi xuống DB → sửa DB trực tiếp cho người đang online sẽ **bị ghi đè**. Cộng xu đúng cách dùng kênh nạp (mục 4).

---

## 4. Admin panel (`admin/index.php`)
Đăng nhập `admin` + `ADMIN_PANEL_PASS` trong `.env`. Đọc mọi bí mật từ `.env` (không hardcode).
- Dashboard: tổng tài khoản, nhân vật, đăng ký hôm nay (`Mem_Account.TimeCreate` là **Unix time**), số bị khóa.
- Tài khoản: 80 mới nhất, Khóa / Mở khóa (`Mem_Account.IsBan`).
- Nhân vật: cấp, vàng, xu, xu khóa.
- Công cụ:
  - **Cộng xu**: gọi `http://127.0.0.1/ChargeMoney.aspx?content=<chargeID|user|xu|admin|0|md5(5 trường + ChargeKey)>&nickname=<UserID số>`. Request ghi `Charge_Money` + báo Center → người đang online nhận ngay. Chỉ nhận từ IP trong `ChargeIP` (= 127.0.0.1). Tham số `nickname` phải là **UserID dạng số** (thiếu thì lỗi mã 2).
  - **Cộng vàng / Lên cấp tối đa / Buff toàn server**: ghi thẳng DB, nhân vật phải offline.

Mã kết quả ChargeMoney: 0 ok, 2 không thấy user, 3 số xu ≤ 0, 5 sai IP, 7 sai chữ ký.

_(Danh sách chức năng của bộ admin cũ: xem mục 9.)_

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
- Client tải template qua `Request/TemplateAllList.ashx` (XML sinh từ DB, `CreateAllXml.ashx` tạo lại). Sửa DB → tạo lại XML → restart Road để server nạp lại.
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
| Cộng xu lỗi mã 2 | thiếu `nickname=<UserID>` | truyền UserID |
| ServerList trả rỗng khi test | thiếu tham số `rnd` | gọi `ServerList.ashx?rnd=0.123` |
| deploy.sh lỗi trên VPS | shell SSH là PowerShell | lệnh từ xa viết cú pháp PowerShell |

---

## 9. Bộ admin cũ (server gốc) làm được gì
_(đang khảo sát, sẽ bổ sung)_

---

## 10. Dựng lại từ đầu (VPS mới)
Xem `_setup/run.txt` và các script `_setup/B1-sql.ps1` (SQL + restore 5 DB), `B2-config.ps1` (config), `B3-iis-php.ps1` (IIS/PHP), `2-go-backdoor-nap.ps1`, `sql/wipe-ve-trang.sql` (xóa dữ liệu người chơi cũ, giữ cấu hình), `sql/links-localhost.sql`, `sql/tao-nhan-vat-max.sql`, `runtime/config.xml` (config.xml của Flash). Sau đó đặt lại các bước trong mục 8 (php.ini, quyền Temp, bind 0.0.0.0, IIS bindings, SSL win-acme, file bí mật).
Bộ chạy nặng (Server binary, 5 `.bak`, Flash, Resource.Server, launcher_base) tải riêng (TeraBox/Drive) → `C:\Gunny92`.
