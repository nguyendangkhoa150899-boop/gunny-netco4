# Gunny NetCo4 — repo phát triển server

Repo này chứa **mã nguồn + config + script** để phát triển một server Gunny (DDTank) riêng, chơi với bạn bè (~20 người). Phần chạy nặng (binary, database `.bak`, Flash, launcher) **không nằm ở đây** — tải riêng qua Drive (xem `docs/BAN-GIAO.md`).

> Dành cho Claude phiên sau: đọc `docs/BAN-GIAO.md` trước. Đó là kết quả soát toàn bộ bộ Gunny (server, web, client, database) + checklist dựng + các lỗ hổng phải vá.

## Có gì trong repo
| Thư mục | Là gì |
|---|---|
| `gameSrc/` | Mã nguồn **server game** (C#, .NET Framework 4.8): Center, Fighting, Road, Request. Đây là phần chính để phát triển gameplay |
| `flashbaseSrc/` | Mã nguồn **client** (ActionScript 3, build bằng Flex/AIR SDK ra `library.swf`) |
| `Request/` | Mã nguồn API web cho client (ASP.NET: đăng nhập, danh sách server) — không gồm `bin/` |
| `website_backend/` | Laravel — API launcher dùng (đăng nhập, đăng ký). Không gồm `vendor/`, `.env`, `storage/` |
| `_setup/` | Script dựng server tự động (SQL, config, IIS/PHP, tường lửa, hosts) |
| `docs/` | Bàn giao + nhật ký |

## KHÔNG nằm trong repo (tải qua Drive)
Binary đã build (`Server/*.exe`, `*.dll`), database `.bak` (5 cái), `Flash/`, `Resource.Server/`, `launcher_base/`, `GM/`, các web trùng (`Website/`, `Website1/`, `newweb/`), `HelperV1.1/`. Lý do: nặng, là binary, chứa secret/dữ liệu người chơi cũ, có bản quyền.

## Quy tắc
- Mật khẩu / IP / domain thật **không commit**. Dùng `127.0.0.1` + mật khẩu test trong script; bản thật đặt riêng.
- File chạy (`.exe`) của bộ là **chưa tin được** — quét VirusTotal trước khi chạy. Có `._cache_FuckNewPng.exe` dấu vết nghi sâu Xred.
- **3 cửa sau bắt buộc gỡ** trước khi mở ra internet (xem `docs/BAN-GIAO.md` + `_setup/2-go-backdoor-nap.ps1`).
- Mục tiêu chủ server: **tắt hết web nạp, chỉ giữ game + đăng nhập launcher; xu lấy trong game (điểm danh / boss); đăng ký về trắng.**

## Dựng server (tóm tắt, chi tiết ở `_setup/run.txt`)
1. Windows Server 2019 + SQL Server 2022 (Developer, Default instance).
2. Tải bộ chạy từ Drive về `C:\Gunny92`.
3. `_setup/B1-sql.ps1` (mixed mode + mật khẩu sa + khôi phục 5 DB).
4. `_setup/B2-config.ps1` (config → localhost, tường lửa, hosts).
5. `_setup/B3-iis-php.ps1` (IIS + URL Rewrite + PHP).
6. Bật: SQL → IIS → Center → Fighting → Road. Mở launcher, đăng ký, test.
7. Trước khi cho bạn bè vào: `_setup/2-go-backdoor-nap.ps1` + xóa account cũ trong DB.
