-- 22/10/2026: chu server muon moi mon vao game la MON GOC TRON (khong cuong hoa, vinh vien, khong khoa) cho do loi.
-- Code da ep o GameMail::send / admin actions.php / vaoRuong. File nay dua du lieu CU ve tron cho hien dung:
--   Web_Ruong (do dang cho rut) va Web_Shop (cau hinh ke shop, hien "Khoa" / "Han n ngay").
-- Sao luu 1 lan vao bak20261022_*. Chay lai an toan. Sau do chay ruong-gop-chong.sql de cong don cac o giong nhau.
-- Hoan tac: UPDATE r SET ValidDate=b.ValidDate, StrengthenLevel=b.StrengthenLevel, IsBind=b.IsBind FROM Web_Ruong r JOIN bak20261022_Web_Ruong b ON b.ID=r.ID
--   (chi dung truoc khi gop; gop xong ID doi).
USE Db_Member;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
IF OBJECT_ID('dbo.bak20261022_Web_Ruong') IS NULL SELECT * INTO dbo.bak20261022_Web_Ruong FROM dbo.Web_Ruong;
IF OBJECT_ID('dbo.bak20261022_Web_Shop') IS NULL SELECT * INTO dbo.bak20261022_Web_Shop FROM dbo.Web_Shop;
BEGIN TRAN;
UPDATE dbo.Web_Ruong SET ValidDate = 0, StrengthenLevel = 0, IsBind = 0 WHERE ValidDate <> 0 OR StrengthenLevel <> 0 OR IsBind <> 0;
DECLARE @r int = @@ROWCOUNT;
UPDATE dbo.Web_Shop SET ValidDate = 0, StrengthenLevel = 0, IsBind = 0 WHERE ValidDate <> 0 OR StrengthenLevel <> 0 OR IsBind <> 0;
DECLARE @s int = @@ROWCOUNT;
COMMIT;
PRINT N'Web_Ruong ve tron: ' + CAST(@r AS nvarchar(10)) + N' o; Web_Shop ve tron: ' + CAST(@s AS nvarchar(10)) + N' dong';
GO
