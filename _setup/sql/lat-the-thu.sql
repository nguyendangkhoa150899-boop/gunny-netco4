-- lat-the-thu.sql (23/10/2026, server test): tao 1 BAN LAT THE WEB chung cho nhieu nhan vat ma khong can danh boss ai cuoi.
--   sqlcmd -S localhost -E -C -b -f 65001 -v MIS=300002 UIDS=227_252 -i lat-the-thu.sql
--   MIS = ai cuoi cua pho ban (Web_The_Man / Web_The_PhoBan.ManCuoi); UIDS = UserID game noi bang dau _ (PowerShell tach dau phay).
-- Giong MiniGameController::taoBan: 1 Web_The_Ban + moi nguoi 1 Web_The_Luot (LogID AM = luot thu, khong dung log that,
--   UX_Web_The_Luot_Log bat LogID duy nhat). Qua quay luc bam lat theo bang roi do game cua ai do. Tinh vao so luot/ngay cua pho ban.
USE Db_Member;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE @mis int = $(MIS);
DECLARE @khoa nvarchar(100) = (SELECT TOP 1 p.Khoa FROM dbo.Web_The_PhoBan p WHERE p.ManCuoi = @mis);
IF @khoa IS NULL BEGIN RAISERROR(N'Ai %d khong phai ai cuoi cua pho ban nao trong Web_The_PhoBan', 16, 1, @mis); RETURN; END
DECLARE @nv TABLE(GameUserID int, NickName nvarchar(50), MemberID int, rn int);
INSERT INTO @nv
SELECT d.UserID, d.NickName, m.UserID, ROW_NUMBER() OVER (ORDER BY d.UserID)
  FROM Db_Tank41.dbo.Sys_Users_Detail d JOIN dbo.Mem_Account m ON m.Email = d.UserName
  WHERE ',' + REPLACE('$(UIDS)', '_', ',') + ',' LIKE '%,' + CAST(d.UserID AS varchar(10)) + ',%';
IF NOT EXISTS (SELECT 1 FROM @nv) BEGIN RAISERROR(N'Khong thay nhan vat / tai khoan web', 16, 1); RETURN; END
DECLARE @now datetime = GETDATE(), @log int = ISNULL((SELECT MIN(LogID) FROM dbo.Web_The_Luot WHERE LogID < 0), 0);
DECLARE @nguoi nvarchar(max) = N'[' + (SELECT STRING_AGG(N'{"u":' + CAST(GameUserID AS nvarchar(10)) + N',"n":"' + STRING_ESCAPE(NickName, 'json') + N'"}', N',') FROM @nv) + N']';
BEGIN TRAN;
DECLARE @ban TABLE(id bigint);
INSERT INTO dbo.Web_The_Ban(Khoa, MissionId, ThoiGian, Ngay, NguoiChoi) OUTPUT inserted.ID INTO @ban VALUES(@khoa, @mis, @now, CAST(@now AS date), @nguoi);
INSERT INTO dbo.Web_The_Luot(MemberID, GameUserID, LogID, Khoa, MissionId, Bai, ThoiGian, Ngay, BanID)
SELECT n.MemberID, n.GameUserID, @log - n.rn, @khoa, @mis, '[]', @now, CAST(@now AS date), (SELECT id FROM @ban) FROM @nv n;
COMMIT;
SELECT l.ID, l.GameUserID, n.NickName, l.Khoa, l.MissionId, l.LogID, l.BanID FROM dbo.Web_The_Luot l JOIN @nv n ON n.GameUserID = l.GameUserID WHERE l.BanID = (SELECT id FROM @ban);
GO
