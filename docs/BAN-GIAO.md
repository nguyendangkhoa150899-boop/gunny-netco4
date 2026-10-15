> **Tài liệu lịch sử**: kết quả soát bộ Gunny92 ngày 14/10/2026, trước khi dựng. Hiện trạng và cách làm hiện tại xem `README.md` + `CLAUDE.md`.

# Bàn giao — Gunny92 NetCo4 (soát 14/10/2026)

Kết quả soát toàn bộ bộ Gunny92 (4 agent: server, web, client, database). Dùng để dựng server test và phát triển tiếp.

## 1. Tổng quan
- Bộ **chạy được** (log cho thấy từng chạy 12/2023). Là cấu hình nguyên của một server đã mở trước đây.
- Mọi mật khẩu/khóa trong bộ **đã lộ công khai** (đã có ≥4 server khác chạy từ bộ này: gunxua.vn, gunnygold.com, gunhuyenthoai.net, yeugunny.com). Phải đổi hết trước khi mở thật.
- Server **chỉ chạy Windows** (.NET Framework 4.8 + IIS). Không có đường Linux thực tế.

## 2. Thành phần & thứ tự bật
SQL Server → IIS (Request + website_backend) → `Center.Service.exe` → `Fighting.Service.exe` → `Road.Service.exe`. Tắt ngược lại, Road trước.
- Center: login/world, WCF cổng 2108/2109, socket 9302.
- Fighting: server đánh nhau, 9308.
- Road: server người chơi kết nối, **9200** (cổng duy nhất + web mở ra ngoài).
- 3 exe là .NET Costura (gộp DLL), không packer.

## 3. Yêu cầu máy
Windows Server 2019/2022 · **SQL Server 2022** (bắt buộc, `.bak` tạo từ 2022) · .NET 4.8 · IIS + URL Rewrite · PHP 7.4 + sqlsrv (cho website_backend). 4 nhân / 8 GB / 80 GB cho ~20 người.

## 4. Database (5 cái cần, bỏ tank-gku)
| .bak | DB | Vai trò |
|---|---|---|
| tank41.bak | **Db_Tank41** | DB chính: người chơi, `Server_List`, `Server_Config` |
| tank.bak | **Db_Tank** | dữ liệu game: shop, quest, `AreaConfig` |
| member.bak | Db_Member | tài khoản web/launcher, `Server_List` (link Center/Request/config) |
| admin.bak | Db_Admin | `settings` (hệ số đổi coin) |
| gm.bak | Db_Gm | tool GM (tùy chọn) |
| ~~tank-gku.bak~~ | — | của server khác, BỎ |
- Bảng phải sửa IP sau khi restore: `Db_Tank41.Server_List` (IP→máy mình, Port 9200), `Db_Tank.AreaConfig`, `Db_Member.Server_List`, `Db_Gm.Url_Tank`.
- **Xóa dữ liệu người chơi cũ** (tài khoản, nhân vật, log) — dữ liệu cá nhân của người khác + chủ server muốn "về trắng".

## 5. Phải đổi khi sang máy mới
- Tên máy SQL cũ `WIN-DME2N9KU5B0` → `localhost`; IP cũ `15.235.163.5` → máy mình; mật khẩu sa cũ `abcd@12344` → mới.
- File: `Server/{center,fight,road}/*.config`, `Server/road/battle.xml`, `Request/Web.config`, `website_backend/.env`, `Flash/config.xml`.
- Mâu thuẫn phải sửa: AreaID (Road 1004 vs 1001), cổng GM (2009 vs 2109), LoginKey (web vs Request phải khớp).
- **Mẹo khỏi build lại launcher:** trỏ domain `*.gunny92.com` về IP máy bằng file hosts (xem `_setup/hosts-them.txt`).

## 6. ⚠️ Lỗ hổng BẮT BUỘC vá trước khi mở internet
**3 cửa sau:**
1. `website_backend/routes/web.php` `/chargeTo/{acc}/{coin}` — nạp xu vô hạn vào tài khoản bất kỳ, không cần đăng nhập.
2. `website_backend/routes/web.php` `/playdebug/{email}` — vào game bằng tài khoản bất kỳ, chỉ cần email.
3. `newweb` `ApiController@loginGameWithLauncher` dòng ~461 — ghi cứng tài khoản `koolkiizz`.

**Khác:** callback nạp thẻ không kiểm chữ ký (`/api/cardCallback`); `newweb` `CheckIfAdmin` luôn trả true (ai đăng nhập cũng thành admin); admin mặc định `admin@gmail.com`/`password`; tài khoản ngân hàng/MoMo người lạ ("PHAM TRUNG KIEN", "TRAN THI NGUYET") ghi cứng trong phần nạp; `Resource.Server/index.php` đọc trộm file bất kỳ.
→ Script `_setup/2-go-backdoor-nap.ps1` gỡ phần lớn. Đổi `APP_KEY`/`KEY_REQUEST`/`CHARGE_KEY`.

**File .exe nghi ngờ:** `._cache_FuckNewPng.exe` (dấu vết sâu Xred), launcher + helper không chữ ký, `HelperV1.1` tự gửi dữ liệu về `yeubxa.com`. Quét VirusTotal trước khi chạy. **Không dùng HelperV1.1.**

## 7. Client / launcher
- Launcher = Electron 11 + Flash nhúng (PepperFlash). Có bản Windows/macOS/Linux. **Chơi trên trình duyệt thường không được** (Flash đã chết), chỉ chơi qua launcher.
- Bản build sẵn trỏ cứng `gunny92.com` → hoặc build lại (Node + electron-builder), hoặc dùng mẹo file hosts (mục 5). Bản 64-bit thiếu thư mục Flash.
- `flashbaseSrc/` là mã nguồn client; `Flash/*.png` thật ra là `.swf` đã build, dùng được luôn, khỏi build lại.

## 8. Mục tiêu chủ server
Tắt hết web nạp + web thừa (chỉ giữ `website_backend` cho launcher đăng nhập), xóa hết của admin cũ, **xu chỉ lấy trong game** (điểm danh / boss / túi boss), đăng ký về trắng. Phần "xu trong game" cần mở DB + mã server lên mới chỉnh được — làm sau khi dựng xong.

## 9. Nguồn tải phần chạy (điền sau)
Bộ chạy nặng (Server binary, 5 `.bak`, Flash, Resource.Server, launcher): tải từ TeraBox/Drive → giải nén `C:\Gunny92`. Link: _(chủ server tự điền)_.
