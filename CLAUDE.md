# GunnyNetco4: quy tắc cho Claude

Đọc `README.md` trước (hiện trạng, kiến trúc, lỗi đã gặp). File này chỉ là luật làm việc.

## Quy trình bắt buộc
- Sửa code → `git commit` → `./_setup/deploy.sh` (tự push GitHub rồi đẩy file đổi lên VPS). **Không sửa tay trên VPS** những file có trong git, lần deploy sau sẽ đè.
- SQL thay đổi DB: viết thành file trong `_setup/sql/`, commit, deploy, rồi chạy `sqlcmd -S localhost -E -C -b -f 65001 -i C:\Gunny92\_setup\sql\<file>.sql` trên VPS (**`-f 65001` bắt buộc**: file UTF-8, thiếu là chữ tiếng Việt trong DB bị vỡ thành `phÃ³`).
- Kết thúc mỗi thay đổi: test thật (curl/Invoke-WebRequest qua domain, đăng nhập admin, xem log), báo kết quả cụ thể.
- Commit kết thúc bằng dòng `Co-Authored-By` theo hướng dẫn của phiên.

## Bí mật
- Không commit mật khẩu, khóa, chuỗi kết nối. Chúng nằm ở `C:\Gunny92\website_backend\.env` và `C:\Gunny92\Request\appsettings.secret.config` (gitignore). Chủ server giữ bản sao + key SSH ở thư mục `GunnyNetco4-BAO-MAT` trên Desktop.
- Code đọc bí mật từ `.env` lúc chạy (xem `admin/lib.php`). `LoginKey`=`KEY_REQUEST`, `ChargeKey`=`CHARGE_KEY` phải khớp giữa Request và website_backend.
- Lệnh SSH chứa mật khẩu dễ bị chặn: sinh/đọc bí mật ngay trên VPS thay vì truyền qua lệnh.

## VPS (Windows, SSH key, shell PowerShell 5.1)
- Không có `&&`. Lệnh phức tạp: base64 UTF-16LE + `powershell -EncodedCommand`. File lớn dùng `scp`.
- Bật server game bằng WMI (`_setup/start-servers.ps1`), không `Start-Process` (chết theo phiên SSH).
- Tạo scheduled task / sửa quyền hệ thống có thể bị chặn: đưa lệnh cho chủ server tự chạy.

## Bẫy của game (đọc kỹ)
- Dữ liệu người đang online nằm trong RAM Road: **không UPDATE trực tiếp** vàng/xu/cấp của người online. Dùng `ChargeMoney.aspx` (xu) hoặc `SendMailAndItem.aspx` (thư).
- Center chỉ đọc `Server_List` lúc khởi động. Đổi Server_List / LevelInfo / Server_Config / Game_Commands / Drop_Item → restart (Road hoặc cả 3).
- `Game_Commands` phải luôn có ≥ 1 dòng, rỗng thì Road tự tắt.
- **Không chạy `CreateAllXml.ashx`**: DB thiếu nhiệm vụ so với XML client gốc (179 so với 1.115). Chỉ dựng lại từng file `.ashx` khi chắc chắn; XML gốc ở git + `C:\inst2\xml-backup-20261015`.
- `.cs` trong `Request/` là bản cũ không khớp DLL; nguồn thật là `gameSrc/Tank.Request/`. Sửa phải build lại `Tank.Request.dll`.
- Launcher Mac: sửa zip Electron tại chỗ bằng 7-Zip, không giải nén trên Windows (mất symlink).

## Giao diện (portal + admin)
- Giữ đủ dấu tiếng Việt. **Không dùng dấu gạch ngang dài "—"** trong chữ hiển thị.
- Màu chữ luôn tương phản nền; các lựa chọn đặt cạnh nhau mỗi cái một màu riêng (ví dụ nút Windows cam, MacBook xanh).
- Không dùng `confirm()/alert()/prompt()`: dùng ô xác nhận / thông báo trong trang.
- Ưu tiên giao diện PC, mobile chỉ cần CSS responsive nhẹ.
- `welcome.blade.php` là Blade: CSS `@media` phải viết `@@media`, tránh `{{` và `@` lẻ.

## Mục tiêu chủ server
Server **test**: tắt nạp tiền thật; nhân vật mới cấp tối đa (60) + nhiều tài nguyên; admin can thiệp được (gửi quà, cộng xu, giftcode, tỉ lệ, GM). Cho bạn bè (~20 người) tải client ở https://gunny.netco4.click và chơi.
