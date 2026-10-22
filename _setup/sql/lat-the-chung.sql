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
