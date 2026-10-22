-- chien-hon-x10.sql (22/10/2026, server test): "Chien hon don" (100100) tang 10 -> 10000 EXP (chu server chot; ban dau 100 = giam 90%).
-- Server cong EXP = item.Template.Property2 (FigSpiritUpGradeHandler), nen chi doi Property2 (+ mo ta) cua 100100.
-- 1 hon 0 -> cap 6: 32.086 -> ~33 vien; 1 mon (3 hon): ~96.000 -> ~100 vien.
-- Client: _setup/kiem-anh/chien-hon-x10.js sua Request/TemplateAlllist.xml cung so.
-- Ap dung khong can restart: nap lai vat pham NoticeServerUpdate.aspx type=8 (admin > He thong > nap lai "vat pham").
-- Hoan tac: UPDATE Db_Tank.dbo.Shop_Goods SET Property2 = 10, Description = N'Tăng 10 EXP chiến hồn' WHERE TemplateID = 100100;
--   + chay lai chien-hon-x10.js voi tham so 10, roi nap lai type 8.
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i chien-hon-x10.sql   (chay lai an toan)
USE Db_Tank;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.bak20261022_chien_hon') IS NULL
  SELECT TemplateID, Property2, Description INTO dbo.bak20261022_chien_hon FROM dbo.Shop_Goods WHERE TemplateID = 100100;
UPDATE dbo.Shop_Goods SET Property2 = 10000, Description = N'Tăng 10000 EXP chiến hồn' WHERE TemplateID = 100100;
SELECT TemplateID, Name, Property2, CAST(Description AS nvarchar(100)) Description FROM dbo.Shop_Goods WHERE TemplateID = 100100;
GO
