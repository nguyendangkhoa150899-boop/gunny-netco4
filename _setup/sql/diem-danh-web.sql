-- diem-danh-web.sql: bang cho diem danh tren web gunny.netco4.click (thay diem danh trong game, ban goc da khoa cung trong Game.Server.dll).
--
-- Web_DiemDanh      moi dong = 1 nhan vat diem danh 1 ngay. Khoa chinh (UserID, Ngay) => khong the nhan 2 lan/ngay ke ca bam dong thoi.
-- Web_DiemDanh_Qua  qua: Moc = 0 la qua moi ngay; Moc = N la qua them khi so ngay diem danh trong THANG dat dung N.
-- Qua gui vao hop thu trong game qua Request/SendMailAndItem.aspx (an toan ca khi dang online). Sua qua o admin > Diem danh.
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i diem-danh-web.sql   (chay lai an toan, khong ghi de qua da sua)
USE Db_Tank41;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.Web_DiemDanh') IS NULL
  CREATE TABLE dbo.Web_DiemDanh(
    UserID int NOT NULL,
    Ngay date NOT NULL,
    ThoiGian datetime NOT NULL CONSTRAINT DF_Web_DiemDanh_ThoiGian DEFAULT GETDATE(),
    CONSTRAINT PK_Web_DiemDanh PRIMARY KEY (UserID, Ngay));

IF OBJECT_ID('dbo.Web_DiemDanh_Qua') IS NULL
BEGIN
  CREATE TABLE dbo.Web_DiemDanh_Qua(
    ID int IDENTITY(1,1) PRIMARY KEY,
    Moc int NOT NULL,              -- 0 = moi ngay; N = khi du N ngay trong thang
    TemplateID int NOT NULL,       -- 0 = chi vang/xu
    [Count] int NOT NULL DEFAULT 1,
    ValidDate int NOT NULL DEFAULT 0,  -- ngay, 0 = vinh vien
    StrengthenLevel int NOT NULL DEFAULT 0,
    IsBind bit NOT NULL DEFAULT 1,
    Gold int NOT NULL DEFAULT 0,
    [Money] int NOT NULL DEFAULT 0);
  -- qua mac dinh: theo logic game (ruong CB Dat vang mo ra da dat vang 7 ngay); sua tuy y o admin
  INSERT INTO dbo.Web_DiemDanh_Qua(Moc,TemplateID,[Count],ValidDate,StrengthenLevel,IsBind,Gold,[Money]) VALUES
    (0, 11512,1,0,0,1, 0,0),   -- moi ngay: 1 Ruong CB Dat vang (ngau nhien 1 trong 3 da)
    (7, 11560,1,7,0,1, 0,0),   -- du 7 ngay: 1 Chau bau chuc phuc cong kich (dat vang vu khi +12)
    (14,11560,2,7,0,1, 0,0),
    (21,11560,3,7,0,1, 0,0),
    (28,11560,5,7,0,1, 0,0);
END
PRINT N'Da tao bang diem danh web.';
GO
