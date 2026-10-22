-- 22/10/2026: lat the CHUNG BAN nhu trong game. Nguoi di chung 1 tran pho ban (log WinMission cung ai, lech <= 5 giay)
-- dung chung 1 ban 21 la; moi nguoi lat lt_solat la, la nguoi khac da lat thi hien mat + ten. Chay lai an toan.
-- Web_The_Ban.Bai: JSON 21 o, o da lat = qua + "u" (GameUserID nguoi lat) + "n" (ten nhan vat); o null = chua lat.
-- Web_The_Luot.BanID: luot cua tung nguoi tro vao ban chung. Luot cu (truoc 22/10) chua co BanID: code tu tao ban rieng khi mo.
USE Db_Member;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.Web_The_Ban') IS NULL
  CREATE TABLE dbo.Web_The_Ban(
    ID bigint IDENTITY(1,1) PRIMARY KEY,
    Khoa nvarchar(100) NOT NULL,
    MissionId int NOT NULL,
    ThoiGian datetime NOT NULL,          -- luc thang boss (log dau tien cua nhom)
    Ngay date NOT NULL,
    Bai nvarchar(max) NOT NULL DEFAULT '[]',
    NguoiChoi nvarchar(1000) NOT NULL DEFAULT '[]',   -- JSON [{"u":GameUserID,"n":"ten"}] ca nhom (ke ca nguoi het luot ngay)
    Xong bit NOT NULL DEFAULT 0,         -- moi luot cua ban da lat du -> an han
    TaoLuc datetime NOT NULL DEFAULT GETDATE());
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Web_The_Ban_Man')
  CREATE INDEX IX_Web_The_Ban_Man ON dbo.Web_The_Ban(MissionId, ThoiGian);
IF COL_LENGTH('dbo.Web_The_Luot', 'BanID') IS NULL
  ALTER TABLE dbo.Web_The_Luot ADD BanID bigint NULL;
-- ca nhom lat xong thi ban hien lai cho moi nguoi (ca la bo lo); nguoi xem bam Xong -> DaXem=1 -> an khoi danh sach cua ho
IF COL_LENGTH('dbo.Web_The_Luot', 'DaXem') IS NULL
  ALTER TABLE dbo.Web_The_Luot ADD DaXem bit NOT NULL CONSTRAINT DF_Web_The_Luot_DaXem DEFAULT 0;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Web_The_Luot_Ban')
  CREATE INDEX IX_Web_The_Luot_Ban ON dbo.Web_The_Luot(BanID, Xong);
PRINT N'Da tao lat the chung ban.';
GO
-- Gop luot tao truoc khi co ban chung: luot CHUA LAT LA NAO dang o ban rieng, trong khi da co ban chung cua cung tran
-- (cung ai, lech <= 5 giay) liet ke nguoi nay -> chuyen luot sang ban chung, xoa ban rieng rong. Neu khong, ban chung
-- khong bao gio "du nguoi lat xong" de hien ket qua. Code (taoBan) cung tu gop tu nay ve sau.
SET NOCOUNT ON;
BEGIN TRAN;
DECLARE @gop TABLE(LuotID bigint, BanCu bigint, BanMoi bigint);
INSERT INTO @gop
SELECT l.ID, l.BanID, (SELECT TOP 1 b2.ID FROM dbo.Web_The_Ban b2 WHERE b2.ID <> ISNULL(l.BanID, 0) AND b2.Xong = 0 AND b2.MissionId = l.MissionId
    AND ABS(DATEDIFF(second, b2.ThoiGian, l.ThoiGian)) <= 5 AND b2.NguoiChoi LIKE N'%"u":' + CAST(l.GameUserID AS nvarchar(12)) + N',%' ORDER BY b2.ID)
FROM dbo.Web_The_Luot l
WHERE l.Xong = 0 AND l.DaLat = '' AND l.LogID > 0;
DELETE FROM @gop WHERE BanMoi IS NULL;
UPDATE l SET BanID = g.BanMoi FROM dbo.Web_The_Luot l JOIN @gop g ON g.LuotID = l.ID;
DELETE b FROM dbo.Web_The_Ban b JOIN @gop g ON g.BanCu = b.ID WHERE NOT EXISTS (SELECT 1 FROM dbo.Web_The_Luot x WHERE x.BanID = b.ID);
COMMIT;
DECLARE @so int = (SELECT COUNT(*) FROM @gop);
PRINT N'Gop luot cu vao ban chung: ' + CAST(@so AS nvarchar(10));
GO
