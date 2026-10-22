-- go-do-la-nguon2.sql (22/10/2026), tiep go-do-la-nguon.sql:
-- 1. Hop qua con 14 loai TRUNG thu cung ma con thu ben trong (Property5) khong co trong client pettemplateinfo.xml
--    -> ap ra pet loi hinh (pet/null). Go khoi Shop_Goods_Box. Sao luu bak20261022_la_box_trung.
-- 2. Hoang (UserID 243) co 95384 (tu Ruong phat tai, client khong co) -> ket man hinh giay luc vao sanh. Chi go khi offline.
-- Hop: phai restart Road moi co hieu luc. Chay lai an toan.
USE Db_Tank;
GO
SET NOCOUNT ON;
DECLARE @trung TABLE(ID int PRIMARY KEY);
INSERT INTO @trung VALUES (35350201),(35290201),(35390101),(35330101),(35270201),(35250101),(35310201),(35240201),(35300101),(35380101),(35280101),(35220101),(35340201),(35230201);
IF OBJECT_ID('dbo.bak20261022_la_box_trung') IS NULL SELECT b.* INTO dbo.bak20261022_la_box_trung FROM dbo.Shop_Goods_Box b JOIN @trung x ON x.ID = b.TemplateId;
DELETE b FROM dbo.Shop_Goods_Box b JOIN @trung x ON x.ID = b.TemplateId;
PRINT N'Shop_Goods_Box trung pet la: ' + CAST(@@ROWCOUNT AS nvarchar(10));
GO
USE Db_Tank41;
GO
SET NOCOUNT ON;
IF (SELECT State FROM dbo.Sys_Users_Detail WHERE UserID = 243) = 0
BEGIN
  IF OBJECT_ID('dbo.bak20261022_hoang_goods') IS NULL SELECT * INTO dbo.bak20261022_hoang_goods FROM dbo.Sys_Users_Goods WHERE UserID = 243 AND TemplateID = 95384 AND IsExist = 1;
  UPDATE dbo.Sys_Users_Goods SET IsExist = 0 WHERE UserID = 243 AND TemplateID = 95384 AND IsExist = 1;
  PRINT N'Hoang: go ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' mon';
END
ELSE PRINT N'Hoang dang online, chua go 95384';
GO
