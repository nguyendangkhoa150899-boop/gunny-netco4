-- minigame-web.sql: vi xu web + tai xiu + do min + lat the sau pho ban + ruong web (trang /dashboard).
--
-- Tien choi = XU WEB = Db_Member.dbo.Mem_Account.Money (doi sang xu game bang /api/convertCoin co san, qua ChargeMoney).
-- Moi lan cong/tru xu web ghi 1 dong Web_SoXu (so cai). Tru xu luon bang 1 lenh UPDATE ... WHERE Money>=@x (khong am, khong dua).
-- Lat the: server game da tu ghi moi man thang vao Db_Tank41.dbo.Sys_Users_Log (Type='WinMission', Content=Mission_Info.Id),
--   web doc bang do -> thang AI CUOI cua pho ban thi tao 1 luot lat (9 la, lat 3). Gioi han moi pho ban N luot/ngay (mac dinh 3).
-- Ruong web: qua lat the (vat pham) nam o Web_Ruong, nguoi choi bam "Rut vao game" -> gui thu (SendMailAndItem.aspx).
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i minigame-web.sql   (chay lai an toan; khong ghi de cau hinh/qua da sua)
USE Db_Member;
GO
SET NOCOUNT ON;

IF OBJECT_ID('dbo.Web_SoXu') IS NULL
  CREATE TABLE dbo.Web_SoXu(
    ID bigint IDENTITY(1,1) PRIMARY KEY,
    MemberID int NOT NULL,
    Delta int NOT NULL,              -- + cong, - tru
    SoDu int NOT NULL,               -- so du sau giao dich
    Loai varchar(20) NOT NULL,       -- taixiu, domin, latthe, diemdanh, admin, ...
    GhiChu nvarchar(200) NULL,
    ThoiGian datetime NOT NULL DEFAULT GETDATE());
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Web_SoXu_Member')
  CREATE INDEX IX_Web_SoXu_Member ON dbo.Web_SoXu(MemberID, ID DESC);

-- cau hinh dang khoa/gia tri, admin sua o trang Mini game
IF OBJECT_ID('dbo.Web_CauHinh') IS NULL
  CREATE TABLE dbo.Web_CauHinh(Khoa varchar(50) PRIMARY KEY, GiaTri nvarchar(200) NOT NULL, MoTa nvarchar(200) NULL);
MERGE dbo.Web_CauHinh AS t USING (VALUES
  ('tx_min','100',N'Tài xỉu: cược tối thiểu (xu web)'),
  ('tx_max','1000000',N'Tài xỉu: cược tối đa'),
  ('tx_heso','1.95',N'Tài xỉu: thắng nhận x (bão 3 viên giống nhau = thua), 1.95 ~ nhà cái 5%'),
  ('dm_min','100',N'Dò mìn: cược tối thiểu'),
  ('dm_max','1000000',N'Dò mìn: cược tối đa'),
  ('dm_rtp','0.95',N'Dò mìn: tỉ lệ trả thưởng (0.95 = nhà cái 5%)'),
  ('dm_tran','50',N'Dò mìn: hệ số tối đa'),
  ('lt_solan','3',N'Lật thẻ: số lượt mặc định mỗi phó bản mỗi ngày'),
  ('lt_mo','1',N'Lật thẻ: 1 = bật, 0 = tắt')
) AS s(Khoa,GiaTri,MoTa) ON t.Khoa=s.Khoa
WHEN NOT MATCHED THEN INSERT(Khoa,GiaTri,MoTa) VALUES(s.Khoa,s.GiaTri,s.MoTa);

IF OBJECT_ID('dbo.Web_DoMin') IS NULL
  CREATE TABLE dbo.Web_DoMin(
    ID bigint IDENTITY(1,1) PRIMARY KEY,
    MemberID int NOT NULL,
    Cuoc int NOT NULL,
    SoMin int NOT NULL,
    Min varchar(100) NOT NULL,       -- vi tri min (0..24), cach dau phay; KHONG gui ve trinh duyet khi van dang mo
    DaMo varchar(100) NOT NULL DEFAULT '',
    TrangThai tinyint NOT NULL DEFAULT 0,  -- 0 dang choi, 1 da rut tien, 2 trung min
    Nhan int NOT NULL DEFAULT 0,     -- so xu nhan ve
    ThoiGian datetime NOT NULL DEFAULT GETDATE(),
    KetThuc datetime NULL);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Web_DoMin_Member')
  CREATE INDEX IX_Web_DoMin_Member ON dbo.Web_DoMin(MemberID, TrangThai);

IF OBJECT_ID('dbo.Web_TaiXiu') IS NULL
  CREATE TABLE dbo.Web_TaiXiu(
    ID bigint IDENTITY(1,1) PRIMARY KEY,
    MemberID int NOT NULL, Cua varchar(4) NOT NULL, Cuoc int NOT NULL,
    X1 tinyint NOT NULL, X2 tinyint NOT NULL, X3 tinyint NOT NULL,
    Nhan int NOT NULL, ThoiGian datetime NOT NULL DEFAULT GETDATE());

-- ruong web: moi dong 1 mon (gop so luong khi cung loai)
IF OBJECT_ID('dbo.Web_Ruong') IS NULL
  CREATE TABLE dbo.Web_Ruong(
    ID bigint IDENTITY(1,1) PRIMARY KEY,
    MemberID int NOT NULL,
    TemplateID int NOT NULL,
    [Count] int NOT NULL,
    ValidDate int NOT NULL DEFAULT 0,
    StrengthenLevel int NOT NULL DEFAULT 0,
    IsBind bit NOT NULL DEFAULT 1,
    Nguon nvarchar(100) NULL,
    ThoiGian datetime NOT NULL DEFAULT GETDATE());

-- pho ban de lat the: Khoa = ten man bo phan " S4"/" ai 4" o cuoi (vd "Ga De"), ManCuoi = Mission_Info.Id cua ai cuoi (boss)
IF OBJECT_ID('dbo.Web_The_PhoBan') IS NULL
  CREATE TABLE dbo.Web_The_PhoBan(
    Khoa nvarchar(100) PRIMARY KEY,
    ManCuoi int NOT NULL,
    SoLanNgay int NULL,              -- NULL = dung lt_solan
    BatTat bit NOT NULL DEFAULT 1);
IF OBJECT_ID('dbo.Web_The_Man') IS NULL
  CREATE TABLE dbo.Web_The_Man(MissionId int PRIMARY KEY, Khoa nvarchar(100) NOT NULL, Ai int NOT NULL);

-- qua trong 9 la bai. Khoa NULL = bo qua chung (dung khi pho ban chua co bo qua rieng). TemplateID 0 = chi xu web.
IF OBJECT_ID('dbo.Web_The_Qua') IS NULL
BEGIN
  CREATE TABLE dbo.Web_The_Qua(
    ID int IDENTITY(1,1) PRIMARY KEY,
    Khoa nvarchar(100) NULL,
    TemplateID int NOT NULL DEFAULT 0,
    [Count] int NOT NULL DEFAULT 1,
    ValidDate int NOT NULL DEFAULT 0,
    StrengthenLevel int NOT NULL DEFAULT 0,
    IsBind bit NOT NULL DEFAULT 1,
    XuWeb int NOT NULL DEFAULT 0,
    TrongSo int NOT NULL DEFAULT 10);   -- trong so ngau nhien
  INSERT INTO dbo.Web_The_Qua(Khoa,TemplateID,[Count],ValidDate,XuWeb,TrongSo) VALUES
    (NULL,0,1,0,500,35),(NULL,0,1,0,1000,25),(NULL,0,1,0,3000,12),(NULL,0,1,0,10000,3),
    (NULL,11512,1,0,0,15),        -- Ruong CB Dat vang
    (NULL,11560,1,7,0,10);        -- Chau bau chuc phuc cong kich (7 ngay)
END

IF OBJECT_ID('dbo.Web_The_Luot') IS NULL
  CREATE TABLE dbo.Web_The_Luot(
    ID bigint IDENTITY(1,1) PRIMARY KEY,
    MemberID int NOT NULL,
    GameUserID int NOT NULL,
    LogID int NOT NULL,              -- Db_Tank41.Sys_Users_Log.ID (moi lan thang chi tao 1 luot)
    Khoa nvarchar(100) NOT NULL,
    MissionId int NOT NULL,
    Bai nvarchar(max) NOT NULL,      -- JSON 9 la (qua sinh san luc tao luot, chi lo khi lat)
    DaLat varchar(40) NOT NULL DEFAULT '',
    Xong bit NOT NULL DEFAULT 0,
    ThoiGian datetime NOT NULL,      -- luc thang boss
    Ngay date NOT NULL);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Web_The_Luot_Log')
  CREATE UNIQUE INDEX UX_Web_The_Luot_Log ON dbo.Web_The_Luot(LogID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Web_The_Luot_Member')
  CREATE INDEX IX_Web_The_Luot_Member ON dbo.Web_The_Luot(MemberID, Xong);
IF OBJECT_ID('dbo.Web_The_Quet') IS NULL
  CREATE TABLE dbo.Web_The_Quet(GameUserID int PRIMARY KEY, LogID int NOT NULL);
GO

-- dung lai danh sach pho ban tu Mission_Info (giu SoLanNgay/BatTat da sua)
SET NOCOUNT ON;
DECLARE @m TABLE(Id int, Khoa nvarchar(100), Ai int);
INSERT INTO @m
SELECT m.Id,
  LTRIM(RTRIM(CASE
    WHEN x.so>0 AND RIGHT(RTRIM(LEFT(m.Name,LEN(m.Name)-x.so)),3)=N' ải' THEN LEFT(RTRIM(LEFT(m.Name,LEN(m.Name)-x.so)),LEN(RTRIM(LEFT(m.Name,LEN(m.Name)-x.so)))-3)
    WHEN x.so>0 AND RIGHT(RTRIM(LEFT(m.Name,LEN(m.Name)-x.so)),2)=N' S' THEN LEFT(RTRIM(LEFT(m.Name,LEN(m.Name)-x.so)),LEN(RTRIM(LEFT(m.Name,LEN(m.Name)-x.so)))-2)
    WHEN x.so>0 THEN LEFT(m.Name,LEN(m.Name)-x.so)
    ELSE m.Name END)),
  CASE WHEN x.so>0 THEN CAST(RIGHT(RTRIM(m.Name),x.so) AS int) ELSE 1 END
FROM Db_Tank.dbo.Mission_Info m
CROSS APPLY (SELECT CASE WHEN PATINDEX('%[^0-9]%',REVERSE(RTRIM(m.Name)))>1 AND PATINDEX('%[^0-9]%',REVERSE(RTRIM(m.Name)))<=4
                         THEN PATINDEX('%[^0-9]%',REVERSE(RTRIM(m.Name)))-1 ELSE 0 END so) x
WHERE ISNULL(m.Name,'')<>'';
DELETE FROM dbo.Web_The_Man;
INSERT INTO dbo.Web_The_Man(MissionId,Khoa,Ai) SELECT Id,Khoa,Ai FROM @m;
MERGE dbo.Web_The_PhoBan AS t
USING (SELECT Khoa, (SELECT TOP 1 Id FROM @m b WHERE b.Khoa=a.Khoa ORDER BY Ai DESC, Id DESC) ManCuoi, MIN(Id) MinId FROM @m a GROUP BY Khoa) AS s
ON t.Khoa=s.Khoa
WHEN MATCHED THEN UPDATE SET ManCuoi=s.ManCuoi
WHEN NOT MATCHED THEN INSERT(Khoa,ManCuoi,BatTat) VALUES(s.Khoa,s.ManCuoi,CASE WHEN s.MinId BETWEEN 100 AND 199 THEN 0 ELSE 1 END);  -- 101..125 la man tap ban
DECLARE @n int = (SELECT COUNT(*) FROM dbo.Web_The_PhoBan);
PRINT N'Pho ban lat the: '+CAST(@n AS nvarchar(10));
GO

-- diem danh co them xu web
USE Db_Tank41;
GO
IF COL_LENGTH('dbo.Web_DiemDanh_Qua','XuWeb') IS NULL
BEGIN
  ALTER TABLE dbo.Web_DiemDanh_Qua ADD XuWeb int NOT NULL CONSTRAINT DF_Web_DiemDanh_Qua_XuWeb DEFAULT 0;
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Web_DiemDanh_Qua WHERE XuWeb>0)
  INSERT INTO dbo.Web_DiemDanh_Qua(Moc,TemplateID,[Count],ValidDate,StrengthenLevel,IsBind,Gold,[Money],XuWeb) VALUES(0,0,1,0,0,1,0,0,5000);  -- moi ngay +5.000 xu web
PRINT N'Da tao bang mini game web.';
GO
