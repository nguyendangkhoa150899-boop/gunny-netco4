-- max-the-tuluyen-tienhoa.sql (23/10/2026, server test): max The bai + Tu luyen + Tien hoa pet cho nhieu nhan vat.
--   sqlcmd -S localhost -E -C -b -f 65001 -v UIDS=227_252_253 -i max-the-tuluyen-tienhoa.sql
--   (UserID noi bang dau _ vi PowerShell tach dau phay thanh mang)
-- The bai: Db_Tank41.Sys_Users_Card (Place 0-4 = dang trang bi, 5-99 = tui the). Chi 44 the co Db_Tank.CardUpdateInfo
--   (cap 1..30) moi nang duoc; CardDataHandler case 3 cong chi so tung cap -> cap 30 = tong 30 dong, CardGP = CardUpdateCondition cap 30.
--   The nao chua co trong tui thi them vao o trong (5..99); the dang trang bi (Count >= 0) chep chi so nhu cardEquip.CopyProp.
-- Tu luyen: Sys_Users_Texp 5 chi so = GP cap cao nhat ExerciseInfo + 1 (ExerciseMgr.GetExercise lay cap duoi khi exp = GP dung moc).
-- Tien hoa pet (Co Thien Diep, PetEvolution): Sys_Users_Detail.evolutionGrade/evolutionExp = cap cao nhat Pet_Fight_Property
--   (tinh theo nhan vat, ap cho moi pet).
-- CHI nhan vat offline (State=0); nhan vat online bi bo qua. Sao luu: bak20261023_max2_card / _texp / _evo (chi tao lan dau).
USE Db_Tank41;
GO
SET NOCOUNT ON;
DECLARE @u TABLE(UserID int PRIMARY KEY);
INSERT INTO @u SELECT UserID FROM dbo.Sys_Users_Detail WHERE ',' + REPLACE('$(UIDS)', '_', ',') + ',' LIKE '%,' + CAST(UserID AS varchar(10)) + ',%' AND State = 0;
SELECT d.UserID, d.NickName, N'ONLINE - bo qua, thoat game roi chay lai' ghi_chu FROM dbo.Sys_Users_Detail d WHERE ',' + REPLACE('$(UIDS)', '_', ',') + ',' LIKE '%,' + CAST(d.UserID AS varchar(10)) + ',%' AND d.State <> 0;

IF OBJECT_ID('dbo.bak20261023_max2_card') IS NULL SELECT c.* INTO dbo.bak20261023_max2_card FROM dbo.Sys_Users_Card c JOIN @u x ON x.UserID = c.UserID;
IF OBJECT_ID('dbo.bak20261023_max2_texp') IS NULL SELECT t.* INTO dbo.bak20261023_max2_texp FROM dbo.Sys_Users_Texp t JOIN @u x ON x.UserID = t.UserID;
IF OBJECT_ID('dbo.bak20261023_max2_evo') IS NULL SELECT d.UserID, d.evolutionGrade, d.evolutionExp INTO dbo.bak20261023_max2_evo FROM dbo.Sys_Users_Detail d JOIN @u x ON x.UserID = d.UserID;

-- The bai
DECLARE @lv int = (SELECT MAX(Level) FROM Db_Tank.dbo.CardUpdateInfo);
DECLARE @gp int = (SELECT Exp FROM Db_Tank.dbo.CardUpdateCondition WHERE Level = @lv);
SELECT Id TemplateID, SUM(Attack) A, SUM(Defend) D, SUM(Agility) G, SUM(Lucky) L, SUM(Guard) Gu, SUM(Damage) Dm
  INTO #mx FROM Db_Tank.dbo.CardUpdateInfo WHERE Level <= @lv GROUP BY Id;

UPDATE c SET Level = @lv, CardGP = @gp, Attack = m.A, Defence = m.D, Agility = m.G, Luck = m.L, Guard = m.Gu, Damage = m.Dm
  FROM dbo.Sys_Users_Card c JOIN @u x ON x.UserID = c.UserID JOIN #mx m ON m.TemplateID = c.TemplateID
  WHERE c.Place >= 5 OR c.Count >= 0;
PRINT N'The bai: nang ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' the co san len cap ' + CAST(@lv AS nvarchar(5));

;WITH o AS (SELECT TOP 95 ROW_NUMBER() OVER (ORDER BY object_id) + 4 Place FROM sys.all_objects),
  trong AS (SELECT x.UserID, o.Place, ROW_NUMBER() OVER (PARTITION BY x.UserID ORDER BY o.Place) rn
            FROM @u x CROSS JOIN o WHERE NOT EXISTS (SELECT 1 FROM dbo.Sys_Users_Card c WHERE c.UserID = x.UserID AND c.Place = o.Place)),
  thieu AS (SELECT x.UserID, m.*, ROW_NUMBER() OVER (PARTITION BY x.UserID ORDER BY m.TemplateID) rn
            FROM @u x CROSS JOIN #mx m WHERE NOT EXISTS (SELECT 1 FROM dbo.Sys_Users_Card c WHERE c.UserID = x.UserID AND c.TemplateID = m.TemplateID AND c.Place >= 5))
INSERT INTO dbo.Sys_Users_Card (UserID, TemplateID, Place, Count, Attack, Defence, Agility, Luck, Guard, AttackReset, DefenceReset, AgilityReset, LuckReset, Damage, Level, CardGP, isFirstGet)
SELECT t.UserID, t.TemplateID, tr.Place, 1, t.A, t.D, t.G, t.L, t.Gu, 0, 0, 0, 0, t.Dm, @lv, @gp, 1
  FROM thieu t JOIN trong tr ON tr.UserID = t.UserID AND tr.rn = t.rn;
PRINT N'The bai: them ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' the moi';

-- Tu luyen
DECLARE @tx int = (SELECT MAX(GP) FROM Db_Tank.dbo.ExerciseInfo) + 1;
UPDATE t SET attTexpExp = @tx, defTexpExp = @tx, spdTexpExp = @tx, lukTexpExp = @tx, hpTexpExp = @tx
  FROM dbo.Sys_Users_Texp t JOIN @u x ON x.UserID = t.UserID;
PRINT N'Tu luyen: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' nhan vat -> exp ' + CAST(@tx AS nvarchar(10));

-- Tien hoa pet
DECLARE @eg int, @ee int;
SELECT TOP 1 @eg = ID, @ee = Exp FROM Db_Tank.dbo.Pet_Fight_Property ORDER BY Exp DESC;
UPDATE d SET evolutionGrade = @eg, evolutionExp = @ee FROM dbo.Sys_Users_Detail d JOIN @u x ON x.UserID = d.UserID;
PRINT N'Tien hoa pet: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' nhan vat -> cap ' + CAST(@eg AS nvarchar(5));

SELECT c.UserID, COUNT(*) the, SUM(CASE WHEN c.Level = @lv THEN 1 ELSE 0 END) the_max, MAX(c.Place) o_cuoi
  FROM dbo.Sys_Users_Card c JOIN @u x ON x.UserID = c.UserID GROUP BY c.UserID;
DROP TABLE #mx;
GO
