-- giftcode-vip-test.sql: su kien code "Code VIP test pho ban" = tron bo trang bi manh nhat theo logic game (de test pho ban).
--
-- Chon do (15/10/2026): moi o trang bi lay mon diem cao nhat (Tan cong+Phong thu+Nhanh nhen+May man, roi Property7) trong cac mon
--   (1) co trong du lieu client goc (TemplateAlllist.xml), (2) co nguon kiem hop le trong game:
--   ban o Shop, roi tu Drop_Item, mo hop Shop_Goods_Box, dung hop Item_Fusion, tien hoa Item_Strengthen_Goods (GainEquip),
--   thuong nhiem vu Quest_Goods; (3) bo ten danh dau tu che (*, SUPER, GM, test).
-- Mon CanStrengthen=1 duoc cuong hoa +12 (Server_Config.MaxStrengthLevel). Do nam/nu dung cot Sex (1 nam, 2 nu, 0 ca hai):
--   SP_Active_PullDown chi gui mon co Sex = gioi tinh nhan vat hoac 0.
-- Code mac dinh: NETCO4VIP (dung chung, moi nguoi nhap 1 lan; can _setup/sql/giftcode-dung-chung.sql). Them ten khac o admin > Giftcode.
-- Chay lai an toan: neu da co su kien cung ten thi bo qua.
USE Db_Tank;
GO
SET NOCOUNT ON;
DECLARE @title nvarchar(100) = N'Code VIP test phó bản';
IF EXISTS(SELECT 1 FROM Active WHERE Title=@title) BEGIN PRINT N'Da co su kien, bo qua.'; RETURN; END
DECLARE @id int = (SELECT ISNULL(MAX(ActiveID),0)+1 FROM Active);
DECLARE @desc nvarchar(400) = N'Trọn bộ trang bị mạnh nhất (cường hóa +12) để test phó bản. Mỗi nhân vật nhận 1 lần.';
INSERT INTO Active(ActiveID,Title,Description,Content,AwardContent,HasKey,StartDate,EndDate,IsOnly,Type,ActionTimeContent,IsAdvance,GoodsExchangeTypes,GoodsExchangeNum,limitType,limitValue,IsShow,ActiveType,IconID,CanGetCode,CodePrefix)
  SELECT @id,@title,@desc,@desc,@desc,1,DATEADD(hour,-1,GETDATE()),DATEADD(day,90,GETDATE()),1,Type,ActionTimeContent,IsAdvance,GoodsExchangeTypes,GoodsExchangeNum,limitType,limitValue,IsShow,ActiveType,IconID,CanGetCode,'VIP'
  FROM Active WHERE ActiveID=(SELECT TOP 1 ActiveID FROM Active WHERE Type=1 AND HasKey=1 ORDER BY ActiveID DESC);

-- (TemplateID, so luong, Sex)
DECLARE @a TABLE(TemplateID int, Cnt int, Sex int);
INSERT INTO @a VALUES
 (71964,1,0),   -- Vu khi: LEGEND-Thanh Kiem Theia (tien hoa)      A888 D168 N898 M228, sat thuong 288
 (17017,1,0),   -- Vu khi phu: LEGEND-Thien Su Ban Phuc (hop)      A50x4, P7 900
 (95354,2,0),   -- Nhan 12 Tuoi +10 (shop)                         A703 D651 N703 M651
 (85204,2,0),   -- Vong Tay 12 Tuoi +10 (shop)                     A584 D531 N584 M531
 (14045,1,0),   -- Day chuyen: S-Con Con Duc Than                  A30x4
 (15137,1,0),   -- Canh Huyen Dieu                                 A50x4
 (13890,1,0),   -- Bo: Khac Ten Top 2                              A70x4
 (1757,1,1),(1858,1,2),         -- Mu: Khai Hoan Khoi nam / nu      A20x4, P7 65
 (2310,1,1),(2407,1,2),         -- Kinh: Hoang Long Khoi nam / nu   A20x4
 (60000042,1,1),(60000101,1,2), -- Ao [Cao Cap]: Sulan nam / Minotaure nu  A23x4, P7 72
 (6352,1,1),(6410,1,2),         -- Mat                              A10x4
 (3533,1,1),(3671,1,2),         -- Toc                              A10x4
 (4360,1,1),(4627,1,2);         -- Hieu ung mat                     A10x4

DECLARE @maxStr int = ISNULL((SELECT TOP 1 CAST(CAST(Value AS nvarchar(20)) AS int) FROM Db_Tank41.dbo.Server_Config WHERE Name='MaxStrengthLevel'),12);
INSERT INTO Active_Award(ActiveID,ItemID,Count,ValidDate,StrengthenLevel,AttackCompose,DefendCompose,LuckCompose,AgilityCompose,Gold,Money,Sex,Mark)
  SELECT @id,a.TemplateID,a.Cnt,0,CASE WHEN g.CanStrengthen=1 THEN @maxStr ELSE 0 END,0,0,0,0,0,0,a.Sex,0
  FROM @a a JOIN Shop_Goods g ON g.TemplateID=a.TemplateID;

INSERT INTO Db_Tank41.dbo.Active_Number(AwardID,ActiveID,PullDown,GetDate,UserID,Mark,Creator) VALUES('NETCO4VIP',@id,0,GETDATE(),0,0,-1);
SELECT N'Da tao su kien #'+CAST(@id AS nvarchar(10))+N', qua: '+CAST((SELECT COUNT(*) FROM Active_Award WHERE ActiveID=@id) AS nvarchar(10))+N' dong, code: NETCO4VIP';
GO
