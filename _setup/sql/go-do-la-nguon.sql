-- go-do-la-nguon.sql (22/10/2026): go moi mon client KHONG co (khong co trong Request/TemplateAlllist.xml) khoi nguon do trong game.
-- Do roi / mo hop / thuong nhiem vu di thang vao tui, khong qua bo loc web/admin -> nguoi nhan ket man hinh giay khi vao sanh
-- (PeXuanMai mo "Ruong phat tai" 190000 ra 85381/85382/160126, 22/10 21:40).
-- Danh sach doi chieu bang node (TemplateAlllist.xml) luc viet file:
--   Shop_Goods_Box: 160126,160127,161126,161127,162126,162127,85381,85382,85383,95383,95384,14056 (12 mon trong Ruong phat tai 190000 + 14056)
--   Drop_Item: 100101,100201,110101,110201,120101,120201,130201 (DropId 6131), 10014 (DropId 801)
--   Quest_Goods: 111631, 112015 | Active_Award: 35211689
-- Sao luu tung bang: Db_Tank.dbo.bak20261022_la_<bang>. Hop/bang roi van con mon khac (190000: 70/82, DropId 6131: 1/8, 801: 17/18).
-- Hieu luc: Quest nap lai duoc (NoticeServerUpdate type 9); hop + roi do phai RESTART ROAD (khong co lenh nap lai).
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i go-do-la-nguon.sql   (chay lai an toan)
USE Db_Tank;
GO
SET NOCOUNT ON;
DECLARE @box TABLE(ID int PRIMARY KEY);   INSERT INTO @box VALUES (160126),(160127),(161126),(161127),(162126),(162127),(85381),(85382),(85383),(95383),(95384),(14056);
DECLARE @drop TABLE(ID int PRIMARY KEY);  INSERT INTO @drop VALUES (100101),(100201),(110101),(110201),(120101),(120201),(130201),(10014);
DECLARE @quest TABLE(ID int PRIMARY KEY); INSERT INTO @quest VALUES (111631),(112015);
DECLARE @act TABLE(ID int PRIMARY KEY);   INSERT INTO @act VALUES (35211689);
-- chi go mon VAN khong co trong Shop_Goods hoac client (an toan neu sau nay them vao DB: khong kiem duoc client tu SQL nen giu danh sach co dinh)
IF OBJECT_ID('dbo.bak20261022_la_box') IS NULL   SELECT b.* INTO dbo.bak20261022_la_box   FROM dbo.Shop_Goods_Box b JOIN @box x ON x.ID = b.TemplateId;
IF OBJECT_ID('dbo.bak20261022_la_drop') IS NULL  SELECT d.* INTO dbo.bak20261022_la_drop  FROM dbo.Drop_Item d     JOIN @drop x ON x.ID = d.ItemId;
IF OBJECT_ID('dbo.bak20261022_la_quest') IS NULL SELECT q.* INTO dbo.bak20261022_la_quest FROM dbo.Quest_Goods q   JOIN @quest x ON x.ID = q.RewardItemID;
IF OBJECT_ID('dbo.bak20261022_la_act') IS NULL   SELECT a.* INTO dbo.bak20261022_la_act   FROM dbo.Active_Award a  JOIN @act x ON x.ID = a.ItemID;
DELETE b FROM dbo.Shop_Goods_Box b JOIN @box x ON x.ID = b.TemplateId;     PRINT N'Shop_Goods_Box: ' + CAST(@@ROWCOUNT AS nvarchar(10));
DELETE d FROM dbo.Drop_Item d JOIN @drop x ON x.ID = d.ItemId;             PRINT N'Drop_Item: ' + CAST(@@ROWCOUNT AS nvarchar(10));
DELETE q FROM dbo.Quest_Goods q JOIN @quest x ON x.ID = q.RewardItemID;    PRINT N'Quest_Goods: ' + CAST(@@ROWCOUNT AS nvarchar(10));
DELETE a FROM dbo.Active_Award a JOIN @act x ON x.ID = a.ItemID;           PRINT N'Active_Award: ' + CAST(@@ROWCOUNT AS nvarchar(10));
-- Hoan tac: INSERT lai tu 4 bang bak20261022_la_* (Shop_Goods_Box/Drop_Item co cot identity thi SET IDENTITY_INSERT ON).
GO
