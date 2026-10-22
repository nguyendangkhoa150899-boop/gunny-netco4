-- qua-test-web.sql: muc "Gui qua test" tren /dashboard: nguoi choi tu tim vat pham va gui vao HOP THU GAME cua chinh minh.
-- Dung cho giai doan test (thay vi dua admin portal cho tung nguoi). MO THAT THI TAT: admin > Mini game > quatest_mo = 0
-- (tat thi API tu choi va muc nay an khoi menu). Moi lan gui ghi nhat ky Web_QuaTest de admin xem ai lay gi.
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i qua-test-web.sql   (chay lai an toan)
USE Db_Member;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.Web_QuaTest') IS NULL
  CREATE TABLE dbo.Web_QuaTest(
    ID bigint IDENTITY(1,1) PRIMARY KEY, MemberID int NOT NULL, GameUserID int NOT NULL,
    VatPham nvarchar(1000) NOT NULL,      -- "TemplateID x so luong +cuong hoa (han)" cach nhau dau ;
    ThoiGian datetime NOT NULL DEFAULT GETDATE());
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Web_QuaTest_Member')
  CREATE INDEX IX_Web_QuaTest_Member ON dbo.Web_QuaTest(MemberID, ThoiGian);
MERGE dbo.Web_CauHinh AS t USING (VALUES
  ('quatest_mo','1',N'Gửi quà test (người chơi tự gửi đồ vào thư game): 1 = bật, 0 = tắt. MỞ SERVER THẬT THÌ TẮT'),
  ('quatest_luot_ngay','0',N'Gửi quà test: số lần gửi tối đa mỗi tài khoản mỗi ngày (0 = không giới hạn)'),
  ('quatest_sl_max','999',N'Gửi quà test: số lượng tối đa mỗi món mỗi lần')
) AS s(Khoa,GiaTri,MoTa) ON t.Khoa=s.Khoa
WHEN NOT MATCHED THEN INSERT(Khoa,GiaTri,MoTa) VALUES(s.Khoa,s.GiaTri,s.MoTa);
PRINT N'Da tao gui qua test.';
GO
