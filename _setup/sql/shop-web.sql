-- shop-web.sql: shop tren web (/dashboard > Shop) voi 2 loai tien:
--   A. XU WEB (Mem_Account.Money, doi 1:1 voi xu game)  -> ke thuong / trung cap
--   B. DIEM HOAT DONG (Web_Diem, KHONG doi tu xu duoc) -> ke hiem. Chi kiem tu: diem danh, thang boss pho ban (moi luot lat the).
--      Vi khong mua bang xu duoc nen acc phu cam 10 trieu xu cung khong don ve duoc.
-- Do mua xong vao Ruong web (Web_Ruong, mac dinh KHOA) roi rut vao game nhu do lat the.
-- Chi ban DO GOC CUA GAME co trong client (TemplateAlllist.xml): Boomerang / Thuong Co / Bua / Thien Su ban phuc.
--   Do admin cu tu che (1000x4, "Bac Max", "( VIP n )", "Sieu Thuong Co"...) client KHONG co -> vo hinh, khong ban.
-- Lo trinh 2 thang (xem README muc 18): mua mon GOC -> cuong hoa +10/+12 trong game tu tien hoa bac 1/2 -> dat vang (da 11560, 5%/vien) -> ban vang.
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i shop-web.sql   (chay lai an toan; khong ghi de hang da sua)
USE Db_Member;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.Web_Diem') IS NULL
  CREATE TABLE dbo.Web_Diem(MemberID int PRIMARY KEY, Diem int NOT NULL DEFAULT 0 CHECK (Diem >= 0));
IF OBJECT_ID('dbo.Web_SoDiem') IS NULL
  CREATE TABLE dbo.Web_SoDiem(
    ID bigint IDENTITY(1,1) PRIMARY KEY, MemberID int NOT NULL, Delta int NOT NULL, SoDu int NOT NULL,
    Loai varchar(20) NOT NULL, GhiChu nvarchar(200) NULL, ThoiGian datetime NOT NULL DEFAULT GETDATE());
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Web_SoDiem_Member')
  CREATE INDEX IX_Web_SoDiem_Member ON dbo.Web_SoDiem(MemberID, ID DESC);

IF OBJECT_ID('dbo.Web_Shop') IS NULL
  CREATE TABLE dbo.Web_Shop(
    ID int IDENTITY(1,1) PRIMARY KEY,
    Ke nvarchar(50) NOT NULL,            -- ten ke (nhom hien tren web)
    TemplateID int NOT NULL,
    [Count] int NOT NULL DEFAULT 1,
    ValidDate int NOT NULL DEFAULT 0,    -- ngay, 0 = vinh vien
    StrengthenLevel int NOT NULL DEFAULT 0,
    IsBind bit NOT NULL DEFAULT 1,
    Tien varchar(4) NOT NULL,            -- 'xu' = xu web, 'diem' = diem hoat dong
    Gia int NOT NULL,
    GioiHanNgay int NULL,                -- moi tai khoan / ngay (NULL = khong gioi han)
    GioiHanTuan int NULL,                -- moi tai khoan / 7 ngay
    GioiHanTong int NULL,                -- moi tai khoan / tron doi
    Kho int NULL,                        -- con lai toan server (NULL = khong gioi han)
    BatDau datetime NULL, KetThuc datetime NULL,
    BatTat bit NOT NULL DEFAULT 1,
    ThuTu int NOT NULL DEFAULT 100,
    MoTa nvarchar(200) NULL);
IF OBJECT_ID('dbo.Web_ShopMua') IS NULL
  CREATE TABLE dbo.Web_ShopMua(
    ID bigint IDENTITY(1,1) PRIMARY KEY, MemberID int NOT NULL, ShopID int NOT NULL, SoLuong int NOT NULL,
    Tien varchar(4) NOT NULL, Gia int NOT NULL, ThoiGian datetime NOT NULL DEFAULT GETDATE());
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Web_ShopMua_Member')
  CREATE INDEX IX_Web_ShopMua_Member ON dbo.Web_ShopMua(MemberID, ShopID, ThoiGian);

MERGE dbo.Web_CauHinh AS t USING (VALUES
  ('shop_mo','1',N'Shop web: 1 = bật, 0 = tắt'),
  ('diem_diemdanh','10',N'Điểm hoạt động: mỗi lần điểm danh'),
  ('diem_moc','20',N'Điểm hoạt động: thưởng thêm khi điểm danh đủ 7/14/21/28 ngày trong tháng'),
  ('diem_phoban','5',N'Điểm hoạt động: mỗi lần đánh xong boss phó bản (mỗi lượt lật thẻ)'),
  ('diem_phoban_tran','50',N'Điểm hoạt động: tối đa từ phó bản mỗi ngày')
) AS s(Khoa,GiaTri,MoTa) ON t.Khoa=s.Khoa
WHEN NOT MATCHED THEN INSERT(Khoa,GiaTri,MoTa) VALUES(s.Khoa,s.GiaTri,s.MoTa);

-- hang mau theo lo trinh 2 thang. Diem kiem duoc: cay deu ~60/ngay (~3.600/2 thang), choi thuong ~25/ngay (~1.500).
IF NOT EXISTS (SELECT 1 FROM dbo.Web_Shop)
INSERT INTO dbo.Web_Shop(Ke,TemplateID,[Count],ValidDate,IsBind,Tien,Gia,GioiHanNgay,GioiHanTuan,GioiHanTong,Kho,ThuTu,MoTa) VALUES
 -- B. KE HIEM (diem hoat dong): vu khi chu dao ban GOC, tu cuong hoa +12 trong game de tien hoa
 (N'Vũ khí huyền thoại',7194,1,0,1,'diem',900,NULL,NULL,1,NULL,10,N'Bản gốc. Cường hóa +10 lên bậc 1, +12 lên bậc 2 (A676), dát vàng thành bản vàng'),
 (N'Vũ khí huyền thoại',7141,1,0,1,'diem',900,NULL,NULL,1,NULL,11,N'Bản gốc. +10 bậc 1, +12 bậc 2 (A714), dát vàng thành bản vàng (A898)'),
 (N'Vũ khí huyền thoại',7099,1,0,1,'diem',700,NULL,NULL,1,NULL,12,N'Bản gốc. +10 bậc 1, +12 bậc 2 (A323), dát vàng thành bản vàng'),
 (N'Vũ khí huyền thoại',17017,1,0,1,'diem',1200,NULL,NULL,1,NULL,13,N'Vũ khí phụ mạnh nhất (A50 x4, chỉ số phụ 900)'),
 (N'Dát vàng',11560,1,7,1,'diem',30,5,NULL,NULL,NULL,20,N'Dát vàng vũ khí +12 bậc 2, thành công 5%/viên, bản vàng giữ 30 ngày'),
 (N'Dát vàng',11512,1,0,1,'diem',15,5,NULL,NULL,NULL,21,N'Mở ra 1 trong 3 đá dát vàng (vũ khí / y phục / nón)'),
 -- A. KE XU WEB: bac SUPER (truoc LEGEND) + thien su VIP/WOW + manh ghep
 (N'Vũ khí SUPER',7024,1,0,1,'xu',2000000,NULL,NULL,1,NULL,30,N'SUPER-Boomerang bản gốc, +12 lên bậc 2'),
 (N'Vũ khí SUPER',7026,1,0,1,'xu',2000000,NULL,NULL,1,NULL,31,N'SUPER-Thương cổ bản gốc, +12 lên bậc 2'),
 (N'Vũ khí SUPER',7027,1,0,1,'xu',2000000,NULL,NULL,1,NULL,32,N'SUPER-Búa Minotaure bản gốc, +12 lên bậc 2'),
 (N'Vũ khí SUPER',7140,1,0,1,'xu',2500000,NULL,NULL,1,NULL,33,N'SUPER-Búa Thor bản gốc, +12 lên bậc 2'),
 (N'Thiên sứ ban phúc',17002,1,0,1,'xu',800000,NULL,NULL,1,NULL,40,N'VIP·Thiên sứ ban phúc (vũ khí phụ, chỉ số phụ 700)'),
 (N'Thiên sứ ban phúc',17005,1,0,1,'xu',1500000,NULL,NULL,1,NULL,41,N'WOW-Thiên sứ ban phúc (chỉ số phụ 850)'),
 (N'Thiên sứ ban phúc',11038,1,0,1,'xu',150000,NULL,10,NULL,NULL,42,N'Mảnh ghép cao cấp VIP·Thiên sứ ban phúc'),
 (N'Thiên sứ ban phúc',11050,1,0,1,'xu',250000,NULL,10,NULL,NULL,43,N'Mảnh ghép cao cấp WOW-Thiên sứ ban phúc');
PRINT N'Da tao shop web.';
GO
