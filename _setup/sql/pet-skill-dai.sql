-- pet-skill-dai.sql (23/10/2026): dang nhap bao "ket noi that bai" sau khi mo pet cap 60 (pet-cap-60.sql).
-- Pet len cap 52/55 duoc them ky nang thu 9 -> chuoi Skill dai > 50 ky tu, nhung cot Sys_Users_Pet.Skill/SkillEquip = nvarchar(50)
-- va tham so @Skill/@SkillEquip cua SP_UserPet_Update / SP_User_Add_Pet / SP_User_AdoptPet = nvarchar(50) -> bi CAT CUT
-- ("...|376,7|37") -> AbstractPacketLib.SendUpdateUserPet: skill.Split(',')[1] IndexOutOfRange -> GamePlayer "Error Login!".
-- Sua: noi cot + 3 SP len nvarchar(500); va chuoi da bi cat (pet 47 cua biabia, Ton Ngo Khong cap 60: ky nang loai 11 cap 52 = 377).
-- Chay lai an toan. Khong can restart Road (SP va cot doi ngay; pet nap lai luc dang nhap).
USE Db_Tank41;
GO
SET NOCOUNT ON;
IF COL_LENGTH('dbo.Sys_Users_Pet', 'Skill') < 1000 ALTER TABLE dbo.Sys_Users_Pet ALTER COLUMN Skill nvarchar(500) NULL;
IF COL_LENGTH('dbo.Sys_Users_Pet', 'SkillEquip') < 1000 ALTER TABLE dbo.Sys_Users_Pet ALTER COLUMN SkillEquip nvarchar(500) NULL;
GO
DECLARE @sp sysname, @def nvarchar(max);
DECLARE c CURSOR LOCAL FAST_FORWARD FOR SELECT name FROM sys.procedures WHERE name IN ('SP_UserPet_Update', 'SP_User_Add_Pet', 'SP_User_AdoptPet');
OPEN c;
FETCH NEXT FROM c INTO @sp;
WHILE @@FETCH_STATUS = 0
BEGIN
  SET @def = OBJECT_DEFINITION(OBJECT_ID('dbo.' + @sp));
  IF @def LIKE '%@Skill nvarchar(50)%' OR @def LIKE '%@SkillEquip nvarchar(50)%'
  BEGIN
    SET @def = REPLACE(REPLACE(@def, '@Skill nvarchar(50)', '@Skill nvarchar(500)'), '@SkillEquip nvarchar(50)', '@SkillEquip nvarchar(500)');
    SET @def = STUFF(@def, CHARINDEX('CREATE', @def), 6, 'ALTER');
    EXEC (@def);
    PRINT N'Noi tham so: ' + @sp;
  END
  FETCH NEXT FROM c INTO @sp;
END
CLOSE c; DEALLOCATE c;
GO
-- chuoi da bi cat (dang co, ket thuc khong co dau phay)
IF OBJECT_ID('dbo.bak20261023_pet_skill_cat') IS NULL SELECT ID, UserID, Skill, SkillEquip INTO dbo.bak20261023_pet_skill_cat FROM dbo.Sys_Users_Pet WHERE LEN(Skill) = 50;
UPDATE dbo.Sys_Users_Pet SET Skill = '262,0|267,1|269,2|271,3|273,4|274,5|365,6|376,7|377,8'
  WHERE ID = 47 AND Skill = '262,0|267,1|269,2|271,3|273,4|274,5|365,6|376,7|37';
PRINT N'Va pet 47: ' + CAST(@@ROWCOUNT AS nvarchar(5));
SELECT ID, UserID, TemplateID, Level, IsExit, Skill FROM dbo.Sys_Users_Pet WHERE IsExit = 1 AND (Skill LIKE '%|' OR RIGHT(Skill, CHARINDEX('|', REVERSE(Skill) + '|') - 1) NOT LIKE '%,%');
GO
