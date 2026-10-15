-- rut-xu-ngan-hang.sql: rut xu game ra xu web bang cach GUI THU KEM XU cho nhan vat "NganHang" trong game.
--
-- Vi sao an toan khi dang online: gui thu kem xu la chuc nang goc cua game (UserSendMailHandler): server tu tru xu
--   trong RAM (RemoveMoney), tao thu Type=1 co Money trong User_Messages, roi SaveIntoDatabase ngay.
--   Nhan vat NganHang khong co tai khoan dang nhap (khong co Mem_Account) nen thu khong bao gio bi nhan trong game.
-- Web (MiniGameController::nhanXuNganHang) xoa thu (DELETE ... 1 lan duy nhat), ghi Web_RutXu, cong xu web.
-- Thu kem DO (Annex) khong xu ly, de nguyen. Thu thu tien (Payment, Type 2) bo qua.
-- Ty le: rut_tile xu game = 1 xu web (mac dinh 1). Doi chieu nap (DB_Admin.settings he-so-doi-coin) cung de 1, neu lech se bi quay vong in xu.
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i rut-xu-ngan-hang.sql   (chay lai an toan)
USE Db_Member;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.Web_RutXu') IS NULL
  CREATE TABLE dbo.Web_RutXu(
    ID bigint IDENTITY(1,1) PRIMARY KEY,
    MemberID int NOT NULL,
    GameUserID int NOT NULL,
    MailID int NOT NULL,
    XuGame int NOT NULL,
    XuWeb int NOT NULL,
    ThoiGian datetime NOT NULL DEFAULT GETDATE());
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Web_RutXu_Mail')
  CREATE UNIQUE INDEX UX_Web_RutXu_Mail ON dbo.Web_RutXu(MailID);
MERGE dbo.Web_CauHinh AS t USING (VALUES
  ('rut_mo','1',N'Rút xu game ra web: 1 = bật, 0 = tắt'),
  ('rut_ten','NganHang',N'Tên nhân vật nhận thư rút xu (người chơi gửi thư kèm xu cho tên này)'),
  ('rut_tile','1',N'Rút xu: bao nhiêu xu game = 1 xu web (giữ bằng Settings.he-so-doi-coin để không quay vòng in xu)'),
  ('rut_tran_ngay','2000000',N'Rút xu: tối đa xu game mỗi tài khoản mỗi ngày (vượt thì chờ sang ngày sau)')
) AS s(Khoa,GiaTri,MoTa) ON t.Khoa=s.Khoa
WHEN NOT MATCHED THEN INSERT(Khoa,GiaTri,MoTa) VALUES(s.Khoa,s.GiaTri,s.MoTa);
-- nap xu web -> xu game 1:1 (truoc la 2)
UPDATE DB_Admin.dbo.settings SET [value]='1' WHERE [key]='he-so-doi-coin';   -- Setting::get (ket noi sqlsrv = DB_Admin)
GO

-- nhan vat NganHang (khong co tai khoan web/launcher => khong ai dang nhap duoc)
USE Db_Tank41;
GO
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM dbo.Sys_Users_Detail WHERE NickName=N'NganHang')
BEGIN
  DECLARE @u int;
  EXEC dbo.SP_Users_Active @UserID=@u OUTPUT,@Attack=0,@Colors='',@ConsortiaID=0,@Defence=0,@Gold=0,@GP=0,@Grade=0,@Luck=0,@Money=0,
    @Style='',@Agility=0,@State=0,@UserName='zz_nganhang_web',@PassWord='khongdangnhap',@Sex=1,@Hide=0,@ActiveIP='',@Skin='',@Site='';
  UPDATE dbo.Sys_Users_Detail SET NickName=N'NganHang', Gold=0, Money=0, MoneyLock=0 WHERE UserID=@u;
  PRINT N'Da tao nhan vat NganHang, UserID='+CAST(@u AS nvarchar(10));
END
ELSE PRINT N'Da co nhan vat NganHang.';
GO
