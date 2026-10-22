-- max-so-tay.sql (23/10/2026, server test): max So Tay Tham Hiem (explorer manual) cho nhieu nhan vat offline.
--   sqlcmd -S localhost -E -C -b -f 65001 -v UIDS=227_252_253 -i max-so-tay.sql   (UserID noi bang dau _)
-- Chi so tinh luc dang nhap (PlayerEquipInventory.UpdatePlayerProperties): moi cap so <= manualLevel cong Boost/MagicAttack/MagicResistance
--   (JampsManualItemList, 21 cap); trang du manh (DebrisCount = so manh co PageID do) cong Collect_*; trang activate = 1 cong them Activate_*.
-- -> manualLevel = cap cao nhat, du 350 manh (JampsDebrisItemList), 25 trang (JampsPageItemList) activate = 1.
-- Cac cot Attack/Defense... cua Sys_Users_ExplorerManualInfo server tu tinh lai, khong can ghi.
-- CHI nhan vat offline (online bi bo qua). Sao luu: bak20261023_sotay_info / _pages / _debris (chi tao lan dau, nhan vat moi thi them).
USE Db_Tank41;
GO
SET NOCOUNT ON;
DECLARE @u TABLE(UserID int PRIMARY KEY);
INSERT INTO @u SELECT UserID FROM dbo.Sys_Users_Detail WHERE ',' + REPLACE('$(UIDS)', '_', ',') + ',' LIKE '%,' + CAST(UserID AS varchar(10)) + ',%' AND State = 0;
SELECT d.UserID, d.NickName, N'ONLINE - bo qua, thoat game roi chay lai' ghi_chu FROM dbo.Sys_Users_Detail d WHERE ',' + REPLACE('$(UIDS)', '_', ',') + ',' LIKE '%,' + CAST(d.UserID AS varchar(10)) + ',%' AND d.State <> 0;

IF OBJECT_ID('dbo.bak20261023_sotay_info') IS NULL SELECT i.* INTO dbo.bak20261023_sotay_info FROM dbo.Sys_Users_ExplorerManualInfo i WHERE 1 = 0 UNION ALL SELECT TOP 0 * FROM dbo.Sys_Users_ExplorerManualInfo;
IF OBJECT_ID('dbo.bak20261023_sotay_pages') IS NULL SELECT p.* INTO dbo.bak20261023_sotay_pages FROM dbo.Sys_Users_ExplorerManualInfoPages p WHERE 1 = 0;
IF OBJECT_ID('dbo.bak20261023_sotay_debris') IS NULL SELECT d.* INTO dbo.bak20261023_sotay_debris FROM dbo.Sys_Users_ExplorerManualInfoDebris d WHERE 1 = 0;
-- dong info trong bak = da sao luu nhan vat nay (ca trang/manh) -> trang/manh chep TRUOC info
INSERT INTO dbo.bak20261023_sotay_pages SELECT p.* FROM dbo.Sys_Users_ExplorerManualInfoPages p JOIN @u x ON x.UserID = p.UserID WHERE NOT EXISTS (SELECT 1 FROM dbo.bak20261023_sotay_info b WHERE b.UserID = p.UserID);
INSERT INTO dbo.bak20261023_sotay_debris SELECT d.* FROM dbo.Sys_Users_ExplorerManualInfoDebris d JOIN @u x ON x.UserID = d.UserID WHERE NOT EXISTS (SELECT 1 FROM dbo.bak20261023_sotay_info b WHERE b.UserID = d.UserID);
INSERT INTO dbo.bak20261023_sotay_info SELECT i.* FROM dbo.Sys_Users_ExplorerManualInfo i JOIN @u x ON x.UserID = i.UserID WHERE NOT EXISTS (SELECT 1 FROM dbo.bak20261023_sotay_info b WHERE b.UserID = i.UserID);

DECLARE @lv int = (SELECT MAX(Level) FROM Db_Tank.dbo.JampsManualItemList);
-- nhan vat chua mo so lan nao thi chua co dong (SP_Single_ExplorerManualInfo tao luc dang nhap): tao truoc
INSERT INTO dbo.Sys_Users_ExplorerManualInfo (UserID, manualLevel, progress, maxProgress, havePage, conditionCount, Agility, Armor, Attack, Damage, Defense, HP, Lucky, MagicAttack, MagicResistance, Stamina)
SELECT x.UserID, @lv, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 FROM @u x WHERE NOT EXISTS (SELECT 1 FROM dbo.Sys_Users_ExplorerManualInfo i WHERE i.UserID = x.UserID);
UPDATE i SET manualLevel = @lv, progress = 0 FROM dbo.Sys_Users_ExplorerManualInfo i JOIN @u x ON x.UserID = i.UserID;
PRINT N'Cap so: ' + CAST(@@ROWCOUNT AS nvarchar(5)) + N' nhan vat -> ' + CAST(@lv AS nvarchar(5));

INSERT INTO dbo.Sys_Users_ExplorerManualInfoDebris (UserID, ID, [date], chapterID, pageID)
SELECT x.UserID, d.ID, GETDATE(), p.ChapterID, d.PageID
  FROM @u x CROSS JOIN Db_Tank.dbo.JampsDebrisItemList d JOIN Db_Tank.dbo.JampsPageItemList p ON p.ID = d.PageID
  WHERE NOT EXISTS (SELECT 1 FROM dbo.Sys_Users_ExplorerManualInfoDebris e WHERE e.UserID = x.UserID AND e.ID = d.ID);
PRINT N'Manh: them ' + CAST(@@ROWCOUNT AS nvarchar(10));

UPDATE pg SET activate = 1 FROM dbo.Sys_Users_ExplorerManualInfoPages pg JOIN @u x ON x.UserID = pg.UserID;
INSERT INTO dbo.Sys_Users_ExplorerManualInfoPages (UserID, pageID, activate)
SELECT x.UserID, p.ID, 1 FROM @u x CROSS JOIN Db_Tank.dbo.JampsPageItemList p
  WHERE NOT EXISTS (SELECT 1 FROM dbo.Sys_Users_ExplorerManualInfoPages e WHERE e.UserID = x.UserID AND e.pageID = p.ID);
PRINT N'Trang: them ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' (tat ca activate)';

SELECT i.UserID, i.manualLevel,
       (SELECT COUNT(*) FROM dbo.Sys_Users_ExplorerManualInfoDebris d WHERE d.UserID = i.UserID) manh,
       (SELECT COUNT(*) FROM dbo.Sys_Users_ExplorerManualInfoPages p WHERE p.UserID = i.UserID AND p.activate = 1) trang
  FROM dbo.Sys_Users_ExplorerManualInfo i JOIN @u x ON x.UserID = i.UserID;
GO
