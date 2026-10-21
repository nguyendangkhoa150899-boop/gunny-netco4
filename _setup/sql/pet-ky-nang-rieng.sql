-- pet-ky-nang-rieng.sql (22/10/2026): 4 loai pet ban hiem (KindID 19,20,22,23: Kien Lua Nho, Ga Con Hung Du, Dau Si Hiem,
-- Mam Xanh Lap Lanh...) dung Y NGUYEN ma ky nang cua loai thuong (2,1,3,4). PetMgr nap Pet_Skill_Template_Info vao Dictionary
-- theo khoa SkillID (lan dau giu) -> 4 loai nay khong con ky nang nao -> PetMgr.UpdateSkillPet lay [0] cua danh sach rong,
-- ArgumentOutOfRange: nhan nuoi / ap trung ra pet nay la loi (Error.log "PetLogicProcessor ADD_PET", 22/10 00:08).
-- Sua bang du lieu, khong dong DLL: nhan ban ky nang sang ma rieng = 90000 + KindID*100 + ma cu (ma cu < 100; ma lon nhat dang co 10809).
-- Client: _setup/kiem-anh/pet-ky-nang-rieng.js sua petskillinfo.xml + petskilltemplateinfo.xml cung quy tac.
-- Sao luu: Db_Tank.dbo.bak20261022_pet_skill_info, bak20261022_pet_skill_template. Chay lai an toan. Doi xong restart Road.
USE Db_Tank;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
IF OBJECT_ID('dbo.bak20261022_pet_skill_info') IS NULL SELECT * INTO dbo.bak20261022_pet_skill_info FROM dbo.Pet_Skill_Info;
IF OBJECT_ID('dbo.bak20261022_pet_skill_template') IS NULL SELECT * INTO dbo.bak20261022_pet_skill_template FROM dbo.Pet_Skill_Template_Info;

DECLARE @map TABLE(Kind int, Cu int, Moi int PRIMARY KEY);
INSERT INTO @map SELECT DISTINCT t.KindID, t.SkillID, 90000 + t.KindID * 100 + t.SkillID
  FROM dbo.Pet_Skill_Template_Info t WHERE t.KindID IN (19, 20, 22, 23) AND t.SkillID BETWEEN 1 AND 99;

BEGIN TRAN;
-- 1. ban sao ky nang (moi cot giu nguyen, chi doi ID)
DECLARE @cot nvarchar(max) = (SELECT STRING_AGG(QUOTENAME(COLUMN_NAME), ',') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Pet_Skill_Info' AND COLUMN_NAME <> 'ID');
DECLARE @sql nvarchar(max) = N'INSERT INTO dbo.Pet_Skill_Info(ID,' + @cot + N') SELECT m.Moi,' + REPLACE(@cot, '[', 's.[') +
  N' FROM dbo.Pet_Skill_Info s JOIN #m m ON m.Cu = s.ID WHERE NOT EXISTS (SELECT 1 FROM dbo.Pet_Skill_Info x WHERE x.ID = m.Moi)';
SELECT * INTO #m FROM @map;
IF COLUMNPROPERTY(OBJECT_ID('dbo.Pet_Skill_Info'), 'ID', 'IsIdentity') = 1 SET @sql = N'SET IDENTITY_INSERT dbo.Pet_Skill_Info ON; ' + @sql + N'; SET IDENTITY_INSERT dbo.Pet_Skill_Info OFF;';
EXEC sp_executesql @sql;
PRINT N'Them ky nang ban sao: ' + CAST(@@ROWCOUNT AS nvarchar(10));

-- 2. 4 loai pet tro sang ma rieng: SkillID va DeleteSkillIDs ("a,b,"). Cau lenh sinh san tu SP_PetSkillTemplateInfo_All
--    (DB muc tuong thich 120: khong co STRING_SPLIT; STRING_AGG trong subquery UPDATE bi loi 130).
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91919, DeleteSkillIDs=N'' WHERE KindID=19 AND SkillID=19;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91920, DeleteSkillIDs=N'91919,' WHERE KindID=19 AND SkillID=20;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91921, DeleteSkillIDs=N'91919,91920,' WHERE KindID=19 AND SkillID=21;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91934, DeleteSkillIDs=N'' WHERE KindID=19 AND SkillID=34;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91935, DeleteSkillIDs=N'91934,' WHERE KindID=19 AND SkillID=35;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91936, DeleteSkillIDs=N'91934,91935,' WHERE KindID=19 AND SkillID=36;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91950, DeleteSkillIDs=N'' WHERE KindID=19 AND SkillID=50;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91951, DeleteSkillIDs=N'91950,' WHERE KindID=19 AND SkillID=51;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91952, DeleteSkillIDs=N'91950,91951,' WHERE KindID=19 AND SkillID=52;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91965, DeleteSkillIDs=N'' WHERE KindID=19 AND SkillID=65;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91966, DeleteSkillIDs=N'91965,' WHERE KindID=19 AND SkillID=66;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91976, DeleteSkillIDs=N'' WHERE KindID=19 AND SkillID=76;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91977, DeleteSkillIDs=N'91976,' WHERE KindID=19 AND SkillID=77;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91984, DeleteSkillIDs=N'' WHERE KindID=19 AND SkillID=84;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91985, DeleteSkillIDs=N'91984,' WHERE KindID=19 AND SkillID=85;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91993, DeleteSkillIDs=N'' WHERE KindID=19 AND SkillID=93;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91994, DeleteSkillIDs=N'91993,' WHERE KindID=19 AND SkillID=94;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=91999, DeleteSkillIDs=N'' WHERE KindID=19 AND SkillID=99;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92001, DeleteSkillIDs=N'' WHERE KindID=20 AND SkillID=1;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92002, DeleteSkillIDs=N'92001,' WHERE KindID=20 AND SkillID=2;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92003, DeleteSkillIDs=N'92001,92002,' WHERE KindID=20 AND SkillID=3;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92025, DeleteSkillIDs=N'' WHERE KindID=20 AND SkillID=25;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92026, DeleteSkillIDs=N'92025,' WHERE KindID=20 AND SkillID=26;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92027, DeleteSkillIDs=N'92025,92026,' WHERE KindID=20 AND SkillID=27;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92037, DeleteSkillIDs=N'' WHERE KindID=20 AND SkillID=37;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92038, DeleteSkillIDs=N'92037,' WHERE KindID=20 AND SkillID=38;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92039, DeleteSkillIDs=N'92037,92038,' WHERE KindID=20 AND SkillID=39;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92056, DeleteSkillIDs=N'' WHERE KindID=20 AND SkillID=56;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92057, DeleteSkillIDs=N'92056,' WHERE KindID=20 AND SkillID=57;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92069, DeleteSkillIDs=N'' WHERE KindID=20 AND SkillID=69;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92070, DeleteSkillIDs=N'92069,' WHERE KindID=20 AND SkillID=70;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92078, DeleteSkillIDs=N'' WHERE KindID=20 AND SkillID=78;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92079, DeleteSkillIDs=N'92078,' WHERE KindID=20 AND SkillID=79;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92086, DeleteSkillIDs=N'' WHERE KindID=20 AND SkillID=86;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92087, DeleteSkillIDs=N'92086,' WHERE KindID=20 AND SkillID=87;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92095, DeleteSkillIDs=N'' WHERE KindID=20 AND SkillID=95;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92313, DeleteSkillIDs=N'' WHERE KindID=23 AND SkillID=13;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92314, DeleteSkillIDs=N'92313,' WHERE KindID=23 AND SkillID=14;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92315, DeleteSkillIDs=N'92313,92314,' WHERE KindID=23 AND SkillID=15;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92331, DeleteSkillIDs=N'' WHERE KindID=23 AND SkillID=31;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92332, DeleteSkillIDs=N'92331,' WHERE KindID=23 AND SkillID=32;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92333, DeleteSkillIDs=N'92331,92332,' WHERE KindID=23 AND SkillID=33;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92344, DeleteSkillIDs=N'' WHERE KindID=23 AND SkillID=44;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92345, DeleteSkillIDs=N'92344,' WHERE KindID=23 AND SkillID=45;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92346, DeleteSkillIDs=N'92344,92345,' WHERE KindID=23 AND SkillID=46;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92361, DeleteSkillIDs=N'' WHERE KindID=23 AND SkillID=61;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92362, DeleteSkillIDs=N'92361,' WHERE KindID=23 AND SkillID=62;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92374, DeleteSkillIDs=N'' WHERE KindID=23 AND SkillID=74;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92375, DeleteSkillIDs=N'92374,' WHERE KindID=23 AND SkillID=75;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92382, DeleteSkillIDs=N'' WHERE KindID=23 AND SkillID=82;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92383, DeleteSkillIDs=N'92382,' WHERE KindID=23 AND SkillID=83;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92391, DeleteSkillIDs=N'' WHERE KindID=23 AND SkillID=91;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92392, DeleteSkillIDs=N'92391,' WHERE KindID=23 AND SkillID=92;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92397, DeleteSkillIDs=N'' WHERE KindID=23 AND SkillID=97;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92207, DeleteSkillIDs=N'' WHERE KindID=22 AND SkillID=7;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92208, DeleteSkillIDs=N'92207,' WHERE KindID=22 AND SkillID=8;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92209, DeleteSkillIDs=N'92207,92208,' WHERE KindID=22 AND SkillID=9;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92228, DeleteSkillIDs=N'' WHERE KindID=22 AND SkillID=28;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92229, DeleteSkillIDs=N'92228,' WHERE KindID=22 AND SkillID=29;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92230, DeleteSkillIDs=N'92228,92229,' WHERE KindID=22 AND SkillID=30;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92240, DeleteSkillIDs=N'' WHERE KindID=22 AND SkillID=40;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92241, DeleteSkillIDs=N'92240,' WHERE KindID=22 AND SkillID=41;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92242, DeleteSkillIDs=N'' WHERE KindID=22 AND SkillID=42;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92243, DeleteSkillIDs=N'92242,' WHERE KindID=22 AND SkillID=43;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92259, DeleteSkillIDs=N'' WHERE KindID=22 AND SkillID=59;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92260, DeleteSkillIDs=N'92259,' WHERE KindID=22 AND SkillID=60;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92272, DeleteSkillIDs=N'' WHERE KindID=22 AND SkillID=72;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92273, DeleteSkillIDs=N'92272,' WHERE KindID=22 AND SkillID=73;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92280, DeleteSkillIDs=N'' WHERE KindID=22 AND SkillID=80;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92281, DeleteSkillIDs=N'92280,' WHERE KindID=22 AND SkillID=81;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92289, DeleteSkillIDs=N'' WHERE KindID=22 AND SkillID=89;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92290, DeleteSkillIDs=N'92289,' WHERE KindID=22 AND SkillID=90;
UPDATE dbo.Pet_Skill_Template_Info SET SkillID=92296, DeleteSkillIDs=N'' WHERE KindID=22 AND SkillID=96;
PRINT N'Doi dong template: 73';
COMMIT;

-- (SUM(IIF(EXISTS(...))) bi loi 130 -> dung LEFT JOIN)
SELECT t.KindID, COUNT(*) dong, SUM(IIF(t.MinLevel = 1, 1, 0)) cap1, MIN(t.SkillID) tu, MAX(t.SkillID) den,
  SUM(IIF(s.ID IS NULL, 1, 0)) thieu_skill
  FROM dbo.Pet_Skill_Template_Info t LEFT JOIN dbo.Pet_Skill_Info s ON s.ID = t.SkillID
  WHERE t.KindID IN (19, 20, 22, 23) GROUP BY t.KindID;
-- Hoan tac: xoa Pet_Skill_Info ID 91900..92399 roi chep lai Pet_Skill_Template_Info tu bak20261022_pet_skill_template
GO
