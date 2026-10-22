-- legend-thien-su.sql (23/10/2026): LEGEND-Thien Su Ban Phuc (17017) ban ra khong hoi mau.
-- Property1 (dan) = 298 = dan "giam tri lieu" cua Hoa Hong Hac Am (17018/17019), BallMgr.GetBallType(298) = Normal
--   (dan hoi mau chi co 5, 59, 64, 97, 98, 120, 10009) -> ban ra dan thuong suc manh 0, khong ai duoc hoi.
-- Doi sang 98 = dan hoi mau cua Super-Thien su ban phuc (17000, client co du anh bombs/98.swf). Property7 = 900 (luong hoi) giu nguyen.
-- Client: node _setup/kiem-anh/legend-thien-su.js Request (TemplateAlllist.xml cung so).
-- Ap dung: nap lai type 8 doi bang mau; mon DA NAM trong tui van giu mau cu toi khi Road restart.
-- Hoan tac: UPDATE Db_Tank.dbo.Shop_Goods SET Property1 = 298 WHERE TemplateID = 17017; + legend-thien-su.js voi tham so 298.
USE Db_Tank;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.bak20261023_legend_thien_su') IS NULL SELECT TemplateID, Property1 INTO dbo.bak20261023_legend_thien_su FROM dbo.Shop_Goods WHERE TemplateID = 17017;
UPDATE dbo.Shop_Goods SET Property1 = 98 WHERE TemplateID = 17017;
SELECT TemplateID, Name, Property1, Property3, Property7 FROM dbo.Shop_Goods WHERE TemplateID = 17017;
GO
