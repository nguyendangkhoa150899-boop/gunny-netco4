-- cong-diem-1ty.sql (21/10/2026, chu server yeu cau de test): moi tai khoan web (Db_Member.Mem_Account) +1.000.000.000
--   diem hoat dong (xu tim, Web_Diem). Ghi so cai Web_SoDiem (Loai='admin', GhiChu = @note).
-- Chay lai an toan: tai khoan da co dong so cai @note thi bo qua. Tai khoan dang ky SAU khi chay khong duoc cong.
-- Web_Diem.Diem la int (toi da 2.147.483.647): cong qua tran thi dung o tran.
-- Hoan tac: tru lai theo so cai, vd
--   UPDATE d SET Diem = IIF(d.Diem > s.Delta, d.Diem - s.Delta, 0) FROM Web_Diem d JOIN Web_SoDiem s ON s.MemberID=d.MemberID
--   WHERE s.Loai='admin' AND s.GhiChu=N'Tặng 1 tỉ điểm test 21/10';
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i cong-diem-1ty.sql
USE Db_Member;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE @add int = 1000000000, @note nvarchar(200) = N'Tặng 1 tỉ điểm test 21/10';
DECLARE @t TABLE(MemberID int, Delta int, SoDu int);

BEGIN TRAN;
INSERT INTO dbo.Web_Diem(MemberID, Diem)
  SELECT a.UserID, 0 FROM dbo.Mem_Account a
  WHERE NOT EXISTS (SELECT 1 FROM dbo.Web_Diem d WHERE d.MemberID = a.UserID);

UPDATE d SET d.Diem = d.Diem + IIF(d.Diem > 2147483647 - @add, 2147483647 - d.Diem, @add)
  OUTPUT inserted.MemberID, inserted.Diem - deleted.Diem, inserted.Diem INTO @t
  FROM dbo.Web_Diem d JOIN dbo.Mem_Account a ON a.UserID = d.MemberID
  WHERE NOT EXISTS (SELECT 1 FROM dbo.Web_SoDiem s WHERE s.MemberID = d.MemberID AND s.Loai = 'admin' AND s.GhiChu = @note);

INSERT INTO dbo.Web_SoDiem(MemberID, Delta, SoDu, Loai, GhiChu)
  SELECT MemberID, Delta, SoDu, 'admin', @note FROM @t WHERE Delta > 0;
COMMIT;

DECLARE @n int = (SELECT COUNT(*) FROM @t WHERE Delta > 0), @tong int = (SELECT COUNT(*) FROM dbo.Mem_Account);
PRINT N'Da cong diem cho ' + CAST(@n AS nvarchar(10)) + N' / ' + CAST(@tong AS nvarchar(10)) + N' tai khoan.';
SELECT TOP 10 a.UserName, d.Diem FROM dbo.Web_Diem d JOIN dbo.Mem_Account a ON a.UserID = d.MemberID ORDER BY d.Diem DESC;
GO
