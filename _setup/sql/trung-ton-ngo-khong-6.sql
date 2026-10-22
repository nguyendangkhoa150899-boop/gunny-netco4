-- trung-ton-ngo-khong-6.sql (23/10/2026): trung 35210201 "Ton Ngo Khong 6" -> pet 210201 KHONG co trong Db_Tank.Pet_Template_Info
-- (client co, KindID 12, nhung KindID 12 tren server la loai pet khac) -> nhan/ap trung bao "Du lieu server loi".
-- 1. Go khoi Ruong phat tai (Shop_Goods_Box 190000), phai restart Road moi co hieu luc. Sao luu bak20261023_tnk6_box.
-- 2. Trung da phat (thu chua nhan UserID 0 + tui nhan vat OFFLINE) doi sang 35210101 "Ton Ngo Khong 5" (pet 210101, dung duoc).
--    Nhan vat online bo qua, chay lai sau. Sao luu bak20261023_tnk6_goods.
-- Web/admin an trung nay qua _setup/do-vo-dung.json (nhom trung_pet_server_khong_co). Chay lai an toan.
USE Db_Tank;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.bak20261023_tnk6_box') IS NULL SELECT * INTO dbo.bak20261023_tnk6_box FROM dbo.Shop_Goods_Box WHERE TemplateId = 35210201;
DELETE FROM dbo.Shop_Goods_Box WHERE TemplateId = 35210201;
PRINT N'Shop_Goods_Box: go ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' dong';
GO
USE Db_Tank41;
GO
SET NOCOUNT ON;
-- UNION ALL voi TOP 0 de bo thuoc tinh IDENTITY cua ItemID (khong thi INSERT vao bang sao luu bi Msg 8101)
SELECT g.* INTO #doi FROM dbo.Sys_Users_Goods g
  WHERE g.TemplateID = 35210201 AND g.IsExist = 1
    AND (g.UserID = 0 OR EXISTS (SELECT 1 FROM dbo.Sys_Users_Detail d WHERE d.UserID = g.UserID AND d.State = 0))
UNION ALL SELECT TOP 0 * FROM dbo.Sys_Users_Goods;
IF COLUMNPROPERTY(OBJECT_ID('dbo.bak20261023_tnk6_goods'), 'ItemID', 'IsIdentity') = 1
BEGIN
  SELECT * INTO #bk FROM dbo.bak20261023_tnk6_goods UNION ALL SELECT TOP 0 * FROM dbo.bak20261023_tnk6_goods;
  DROP TABLE dbo.bak20261023_tnk6_goods;
  SELECT * INTO dbo.bak20261023_tnk6_goods FROM #bk;
  DROP TABLE #bk;
END
IF OBJECT_ID('dbo.bak20261023_tnk6_goods') IS NULL SELECT * INTO dbo.bak20261023_tnk6_goods FROM #doi
ELSE INSERT INTO dbo.bak20261023_tnk6_goods SELECT d.* FROM #doi d WHERE NOT EXISTS (SELECT 1 FROM dbo.bak20261023_tnk6_goods b WHERE b.ItemID = d.ItemID);
UPDATE g SET TemplateID = 35210101 FROM dbo.Sys_Users_Goods g JOIN #doi d ON d.ItemID = g.ItemID;
PRINT N'Doi trung: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' mon -> 35210101';
SELECT g.UserID, g.ItemID, N'con 35210201 (dang online, chay lai sau)' ghi_chu FROM dbo.Sys_Users_Goods g WHERE g.TemplateID = 35210201 AND g.IsExist = 1;
DROP TABLE #doi;
GO
