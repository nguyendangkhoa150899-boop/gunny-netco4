-- 22/10/2026: go do VO DUNG khoi tui nguoi choi (cung danh sach an o web/admin, VatPham::KHONG_DUNG):
--   201264 "Chien hon don" gia (server chi nhan 100100: ItemInfo.isGemStone), 100001-100005 ma o chien hon (khong phai vat pham).
-- CHI nhan vat OFFLINE (State=0): do nguoi online nam trong RAM Road, sua DB se bi lan luu sau ghi de. Online thi bo qua, chay lai sau.
-- Sao luu bak20261022_dovodung (them dong moi moi lan chay), go bang IsExist=0 nhu go-do-tu-che-hoang.sql. Chay lai an toan.
-- Hoan tac: UPDATE g SET IsExist=1 FROM Db_Tank41.dbo.Sys_Users_Goods g JOIN Db_Tank41.dbo.bak20261022_dovodung b ON b.ItemID=g.ItemID
USE Db_Tank41;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE @ma TABLE(TemplateID int PRIMARY KEY);
INSERT INTO @ma VALUES (201264), (100001), (100002), (100003), (100004), (100005);
-- UNION ALL de bang sao luu KHONG ke thua cot tu tang (khoi IDENTITY_INSERT)
IF OBJECT_ID('dbo.bak20261022_dovodung') IS NULL
  SELECT TOP 0 * INTO dbo.bak20261022_dovodung FROM (SELECT * FROM dbo.Sys_Users_Goods UNION ALL SELECT * FROM dbo.Sys_Users_Goods) x;
BEGIN TRAN;
DECLARE @go TABLE(ItemID int PRIMARY KEY);
INSERT INTO @go
SELECT g.ItemID FROM dbo.Sys_Users_Goods g WITH (UPDLOCK)
JOIN @ma m ON m.TemplateID = g.TemplateID
JOIN dbo.Sys_Users_Detail d ON d.UserID = g.UserID
WHERE g.IsExist = 1 AND g.UserID > 0 AND d.State = 0;
-- dinh kem mo coi (UserID 0, khong thu nao tro toi): khong ai nhan duoc nua
INSERT INTO @go
SELECT g.ItemID FROM dbo.Sys_Users_Goods g WITH (UPDLOCK)
JOIN @ma m ON m.TemplateID = g.TemplateID
WHERE g.IsExist = 1 AND g.UserID = 0 AND NOT EXISTS (SELECT 1 FROM dbo.User_Messages u WHERE CAST(g.ItemID AS nvarchar(20)) IN
  (CAST(u.Annex1 AS nvarchar(20)), CAST(u.Annex2 AS nvarchar(20)), CAST(u.Annex3 AS nvarchar(20)), CAST(u.Annex4 AS nvarchar(20)), CAST(u.Annex5 AS nvarchar(20))));
INSERT INTO dbo.bak20261022_dovodung(ItemID,UserID,BagType,TemplateID,Place,[Count],IsJudge,Color,IsExist,StrengthenLevel,StrengthenExp,AttackCompose,DefendCompose,LuckCompose,AgilityCompose,Skin,IsBinds,IsUsed,BeginDate,ValidDate,RemoveDate,RemoveType,Hole1,Hole2,Hole3,Hole4,Hole5,Hole6,Hole5Level,Hole5Exp,Hole6Level,Hole6Exp,StrengthenTimes,StrengthenRefineryLevel,isGold,goldValidDate,goldBeginTime,Blood,latentEnergyCurStr,latentEnergyNewStr,latentEnergyEndTime,cellLocked,curExp)
SELECT g.ItemID,g.UserID,g.BagType,g.TemplateID,g.Place,g.[Count],g.IsJudge,g.Color,g.IsExist,g.StrengthenLevel,g.StrengthenExp,g.AttackCompose,g.DefendCompose,g.LuckCompose,g.AgilityCompose,g.Skin,g.IsBinds,g.IsUsed,g.BeginDate,g.ValidDate,g.RemoveDate,g.RemoveType,g.Hole1,g.Hole2,g.Hole3,g.Hole4,g.Hole5,g.Hole6,g.Hole5Level,g.Hole5Exp,g.Hole6Level,g.Hole6Exp,g.StrengthenTimes,g.StrengthenRefineryLevel,g.isGold,g.goldValidDate,g.goldBeginTime,g.Blood,g.latentEnergyCurStr,g.latentEnergyNewStr,g.latentEnergyEndTime,g.cellLocked,g.curExp
FROM dbo.Sys_Users_Goods g JOIN @go x ON x.ItemID = g.ItemID
WHERE NOT EXISTS (SELECT 1 FROM dbo.bak20261022_dovodung b WHERE b.ItemID = g.ItemID);
UPDATE g SET IsExist = 0 FROM dbo.Sys_Users_Goods g JOIN @go x ON x.ItemID = g.ItemID;
DECLARE @n int = @@ROWCOUNT;
COMMIT;
DECLARE @on int = (SELECT COUNT(DISTINCT g.UserID) FROM dbo.Sys_Users_Goods g JOIN @ma m ON m.TemplateID = g.TemplateID
  JOIN dbo.Sys_Users_Detail d ON d.UserID = g.UserID WHERE g.IsExist = 1 AND g.UserID > 0 AND d.State = 1);
PRINT N'Go ' + CAST(@n AS nvarchar(10)) + N' o do vo dung. Nhan vat dang online con giu (chay lai khi ho thoat): ' + CAST(@on AS nvarchar(10));
GO
