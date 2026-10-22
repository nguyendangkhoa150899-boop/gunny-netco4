-- max-danh-hieu.sql (23/10/2026, server test): tang TAT CA danh hieu co cong chi so (vinh vien) cho nhieu nhan vat offline.
--   sqlcmd -S localhost -E -C -b -f 65001 -v UIDS=227_247_252_253 -i max-danh-hieu.sql   (UserID noi bang dau _)
-- Server cong DON moi danh hieu con han (PlayerEquipInventory: foreach rank in Rank.ListRank, IsValidRank -> + rank.Info.Att/Def/Agi/Luck,
--   Info = New_Title theo NewTitleID), khong chi danh hieu dang deo. Validate = 0 = vinh vien.
-- Lay New_Title co Att+Def+Agi+Luck > 0 (372), bo 2 mon client khong hien duoc (kiem 23/10 voi Request/newtitleinfo.xml + image/title/<Pic>/icon.png):
--   60009 "Top 1 Sever" (client khong co ID), 50014 "Fan Cung FANPAGE" (khong co anh). Con 370 -> tong khoang +7500 moi chi so.
-- CHI nhan vat offline (PlayerRank nap luc dang nhap, luu lai luc thoat). Hoan tac: xoa dong NewTitleID trong bak20261023_danhhieu_moi.
USE Db_Tank41;
GO
SET NOCOUNT ON;
DECLARE @u TABLE(UserID int PRIMARY KEY);
INSERT INTO @u SELECT UserID FROM dbo.Sys_Users_Detail WHERE ',' + REPLACE('$(UIDS)', '_', ',') + ',' LIKE '%,' + CAST(UserID AS varchar(10)) + ',%' AND State = 0;
SELECT d.UserID, d.NickName, N'ONLINE - bo qua, thoat game roi chay lai' ghi_chu FROM dbo.Sys_Users_Detail d WHERE ',' + REPLACE('$(UIDS)', '_', ',') + ',' LIKE '%,' + CAST(d.UserID AS varchar(10)) + ',%' AND d.State <> 0;

SELECT x.UserID, t.ID NewTitleID, t.Name INTO #moi
  FROM @u x CROSS JOIN Db_Tank.dbo.New_Title t
  WHERE t.Att + t.Def + t.Agi + t.Luck > 0 AND t.ID NOT IN (60009, 50014)
    AND NOT EXISTS (SELECT 1 FROM dbo.Sys_User_Rank r WHERE r.UserID = x.UserID AND r.NewTitleID = t.ID);
-- danh hieu da co nhung co han (Validate > 0, vd Vua Luc Chien) -> vinh vien
UPDATE r SET Validate = 0, EndDate = '2099-12-31', IsExit = 1
  FROM dbo.Sys_User_Rank r JOIN @u x ON x.UserID = r.UserID JOIN Db_Tank.dbo.New_Title t ON t.ID = r.NewTitleID
  WHERE t.Att + t.Def + t.Agi + t.Luck > 0 AND (r.Validate <> 0 OR r.IsExit = 0);
PRINT N'Danh hieu co han -> vinh vien: ' + CAST(@@ROWCOUNT AS nvarchar(10));
INSERT INTO dbo.Sys_User_Rank (UserID, NewTitleID, Name, Attack, Defence, Luck, Agility, HP, Damage, Guard, BeginDate, EndDate, Validate, IsExit)
SELECT m.UserID, m.NewTitleID, m.Name, 0, 0, 0, 0, 0, 0, 0, GETDATE(), '2099-12-31', 0, 1 FROM #moi m;
PRINT N'Them danh hieu: ' + CAST(@@ROWCOUNT AS nvarchar(10));
IF OBJECT_ID('dbo.bak20261023_danhhieu_moi') IS NULL SELECT * INTO dbo.bak20261023_danhhieu_moi FROM #moi
ELSE INSERT INTO dbo.bak20261023_danhhieu_moi SELECT * FROM #moi;
DROP TABLE #moi;

SELECT r.UserID, COUNT(*) danh_hieu, SUM(t.Att) cong, SUM(t.Def) thu, SUM(t.Agi) nhanh, SUM(t.Luck) may
  FROM dbo.Sys_User_Rank r JOIN @u x ON x.UserID = r.UserID JOIN Db_Tank.dbo.New_Title t ON t.ID = r.NewTitleID
  WHERE r.IsExit = 1 AND (r.Validate = 0 OR r.BeginDate > DATEADD(day, -r.Validate, GETDATE())) GROUP BY r.UserID;
GO
