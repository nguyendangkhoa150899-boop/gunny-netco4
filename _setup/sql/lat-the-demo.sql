-- 22/10/2026 (chu server yeu cau): xoa du lieu lat the cua bialk + tao 3 ban lat the CHUNG demo giua bialk va dau123
-- de xem giao dien lat chung ban (lat-the-chung.sql). Khong dung nhan vat / do / xu.
-- Ban demo: LogID AM (khong trung log that), ngay HOM QUA (khong an vao gioi han lt_solan/ngay), khong cong diem hoat dong.
-- Quà khi lat demo la that (quay nhu lat the thuong, vao Ruong web). Chay lai se tao them 3 ban nua.
-- Hoan tac phan xoa: INSERT lai tu bak20261022_lt_bialk_Luot / bak20261022_lt_bialk_Ban (SET IDENTITY_INSERT ON).
USE Db_Member;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE @gA int, @nA nvarchar(50), @mA int, @gB int, @nB nvarchar(50), @mB int;
SELECT @gA = UserID, @nA = NickName FROM Db_Tank41.dbo.Sys_Users_Detail WHERE UserName = 'bialk';
SELECT @gB = UserID, @nB = NickName FROM Db_Tank41.dbo.Sys_Users_Detail WHERE UserName = 'dau123';
SELECT @mA = UserID FROM dbo.Mem_Account WHERE Email = 'bialk';
SELECT @mB = UserID FROM dbo.Mem_Account WHERE Email = 'dau123';
IF @gA IS NULL OR @gB IS NULL OR @mA IS NULL OR @mB IS NULL BEGIN RAISERROR(N'Khong thay bialk / dau123', 16, 1); RETURN; END

-- 1. sao luu + xoa lat the cua bialk (luot + ban chi con minh bialk)
IF OBJECT_ID('dbo.bak20261022_lt_bialk_Luot') IS NULL SELECT * INTO dbo.bak20261022_lt_bialk_Luot FROM dbo.Web_The_Luot WHERE GameUserID = @gA;
IF OBJECT_ID('dbo.bak20261022_lt_bialk_Ban') IS NULL
  SELECT b.* INTO dbo.bak20261022_lt_bialk_Ban FROM dbo.Web_The_Ban b WHERE b.ID IN (SELECT BanID FROM dbo.Web_The_Luot WHERE GameUserID = @gA);
BEGIN TRAN;
DECLARE @bans TABLE(ID bigint);
INSERT INTO @bans SELECT DISTINCT BanID FROM dbo.Web_The_Luot WHERE GameUserID = @gA AND BanID IS NOT NULL;
DELETE FROM dbo.Web_The_Luot WHERE GameUserID = @gA;
DECLARE @xl int = @@ROWCOUNT;
DELETE b FROM dbo.Web_The_Ban b JOIN @bans x ON x.ID = b.ID WHERE NOT EXISTS (SELECT 1 FROM dbo.Web_The_Luot l WHERE l.BanID = b.ID);
DECLARE @xb int = @@ROWCOUNT;

-- 2. 3 ban chung demo: pho ban co bang roi do that cho ai cuoi
DECLARE @pb TABLE(n int IDENTITY(1,1), Khoa nvarchar(100), ManCuoi int);
INSERT INTO @pb(Khoa, ManCuoi)
SELECT TOP 3 p.Khoa, p.ManCuoi FROM dbo.Web_The_PhoBan p
WHERE p.BatTat = 1 AND p.ManCuoi IS NOT NULL AND EXISTS (SELECT 1 FROM Db_Tank.dbo.Drop_Condiction c
  WHERE c.CondictionType = 5 AND c.Para1 LIKE '%,' + CAST(p.ManCuoi AS varchar(12)) + ',%' AND EXISTS (SELECT 1 FROM Db_Tank.dbo.Drop_Item i WHERE i.DropId = c.DropID))
ORDER BY p.Khoa;
DECLARE @nguoi nvarchar(1000) = N'[{"u":' + CAST(@gA AS nvarchar(12)) + N',"n":"' + STRING_ESCAPE(@nA, 'json') + N'"},{"u":'
  + CAST(@gB AS nvarchar(12)) + N',"n":"' + STRING_ESCAPE(@nB, 'json') + N'"}]';
DECLARE @i int = 1, @k nvarchar(100), @mis int, @t datetime, @id bigint, @log int;
SELECT @log = ISNULL(MIN(LogID), 0) FROM dbo.Web_The_Luot WHERE LogID < 0;
WHILE @i <= (SELECT COUNT(*) FROM @pb)
BEGIN
  SELECT @k = Khoa, @mis = ManCuoi FROM @pb WHERE n = @i;
  SET @t = DATEADD(minute, -10 * @i, DATEADD(day, -1, GETDATE()));
  INSERT INTO dbo.Web_The_Ban(Khoa, MissionId, ThoiGian, Ngay, NguoiChoi) VALUES(@k, @mis, @t, CAST(@t AS date), @nguoi);
  SET @id = SCOPE_IDENTITY();
  SET @log = @log - 2;
  INSERT INTO dbo.Web_The_Luot(MemberID, GameUserID, LogID, Khoa, MissionId, Bai, ThoiGian, Ngay, BanID)
  VALUES(@mA, @gA, @log, @k, @mis, '[]', @t, CAST(@t AS date), @id), (@mB, @gB, @log + 1, @k, @mis, '[]', @t, CAST(@t AS date), @id);
  SET @i += 1;
END
COMMIT;
PRINT N'bialk: xoa ' + CAST(@xl AS nvarchar(10)) + N' luot, ' + CAST(@xb AS nvarchar(10)) + N' ban. Tao ' + CAST(@i - 1 AS nvarchar(10))
  + N' ban demo ' + @nA + N' + ' + @nB;
SELECT b.ID, b.Khoa, b.MissionId, CONVERT(varchar(16), b.ThoiGian, 120) tg, (SELECT COUNT(*) FROM dbo.Web_The_Luot l WHERE l.BanID = b.ID) so_luot
FROM dbo.Web_The_Ban b WHERE b.ID IN (SELECT BanID FROM dbo.Web_The_Luot WHERE GameUserID = @gA);
GO
