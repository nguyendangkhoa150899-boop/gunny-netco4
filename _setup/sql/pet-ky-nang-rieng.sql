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

-- 2. 4 loai pet tro sang ma rieng (SkillID va DeleteSkillIDs "a,b,"). DeleteSkillIDs moi tinh truoc vao #del
--    (STRING_AGG trong subquery cua UPDATE bi loi 130).
SELECT d.KindID, d.DeleteSkillIDs Cu,
  STRING_AGG(CAST(IIF(TRY_CAST(v.value AS int) BETWEEN 1 AND 99, 90000 + d.KindID * 100 + TRY_CAST(v.value AS int), TRY_CAST(v.value AS int)) AS nvarchar(12)), ',') + ',' Moi
  INTO #del
  FROM (SELECT DISTINCT KindID, DeleteSkillIDs FROM dbo.Pet_Skill_Template_Info WHERE KindID IN (19, 20, 22, 23) AND SkillID BETWEEN 1 AND 99) d
  CROSS APPLY STRING_SPLIT(d.DeleteSkillIDs, ',') v WHERE v.value <> ''
  GROUP BY d.KindID, d.DeleteSkillIDs;
UPDATE t SET t.DeleteSkillIDs = ISNULL(x.Moi, t.DeleteSkillIDs), t.SkillID = 90000 + t.KindID * 100 + t.SkillID
  FROM dbo.Pet_Skill_Template_Info t LEFT JOIN #del x ON x.KindID = t.KindID AND x.Cu = t.DeleteSkillIDs
  WHERE t.KindID IN (19, 20, 22, 23) AND t.SkillID BETWEEN 1 AND 99;
PRINT N'Doi dong template: ' + CAST(@@ROWCOUNT AS nvarchar(10));
COMMIT;

SELECT t.KindID, COUNT(*) dong, SUM(IIF(t.MinLevel = 1, 1, 0)) cap1, MIN(t.SkillID) tu, MAX(t.SkillID) den,
  SUM(IIF(EXISTS (SELECT 1 FROM dbo.Pet_Skill_Info s WHERE s.ID = t.SkillID), 0, 1)) thieu_skill
  FROM dbo.Pet_Skill_Template_Info t WHERE t.KindID IN (19, 20, 22, 23) GROUP BY t.KindID;
-- Hoan tac: xoa Pet_Skill_Info ID 91900..92399 roi chep lai Pet_Skill_Template_Info tu bak20261022_pet_skill_template
GO
