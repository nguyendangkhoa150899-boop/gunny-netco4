-- max-vatto-thoitrang-manhhoa.sql (23/10/2026, server test): max Vat to + Bo suu tap thoi trang + Manh hoa pet cho nhieu nhan vat.
--   sqlcmd -S localhost -E -C -b -f 65001 -v UIDS=227_247_252_253 -i max-vatto-thoitrang-manhhoa.sql
--   (UserID noi bang dau _ vi PowerShell tach dau phay thanh mang)
-- Vat to: Sys_Users_Detail.totemId = ID cao nhat Db_Tank.Totem_Info (10350 = TotemMgr.MaxTotem); chi so cong don theo totemId.
-- Thoi trang: User_Avatar_Colection (1 dong/bo, dataId = Cloth_Group_Template.ID). ActiveDress = moi TemplateID cua bo
--   (AvatarCollectionActive noi dau phay), ActiveCount = so mon cua bo -> FullActive; endTime 2099 (isValidate = endTime >= hom nay).
--   Bo chua co dong thi them.
-- Manh hoa pet (EatPet, Da Manh Hoa 201567): Sys_Eat_Pets vu khi/ao/non = cap cao nhat Pet_Moe_Property, exp 0 (nhu EatPet khi dat max).
-- CHI nhan vat offline (State=0); online bi bo qua. Sao luu: bak20261023_max3_totem / _avatar / _eat (chi tao lan dau).
USE Db_Tank41;
GO
SET NOCOUNT ON;
DECLARE @u TABLE(UserID int PRIMARY KEY);
INSERT INTO @u SELECT UserID FROM dbo.Sys_Users_Detail WHERE ',' + REPLACE('$(UIDS)', '_', ',') + ',' LIKE '%,' + CAST(UserID AS varchar(10)) + ',%' AND State = 0;
SELECT d.UserID, d.NickName, N'ONLINE - bo qua, thoat game roi chay lai' ghi_chu FROM dbo.Sys_Users_Detail d WHERE ',' + REPLACE('$(UIDS)', '_', ',') + ',' LIKE '%,' + CAST(d.UserID AS varchar(10)) + ',%' AND d.State <> 0;

IF OBJECT_ID('dbo.bak20261023_max3_totem') IS NULL SELECT d.UserID, d.totemId INTO dbo.bak20261023_max3_totem FROM dbo.Sys_Users_Detail d JOIN @u x ON x.UserID = d.UserID
ELSE INSERT INTO dbo.bak20261023_max3_totem SELECT d.UserID, d.totemId FROM dbo.Sys_Users_Detail d JOIN @u x ON x.UserID = d.UserID WHERE NOT EXISTS (SELECT 1 FROM dbo.bak20261023_max3_totem b WHERE b.UserID = d.UserID);
IF OBJECT_ID('dbo.bak20261023_max3_avatar') IS NULL SELECT a.* INTO dbo.bak20261023_max3_avatar FROM dbo.User_Avatar_Colection a JOIN @u x ON x.UserID = a.UserID
ELSE INSERT INTO dbo.bak20261023_max3_avatar SELECT a.* FROM dbo.User_Avatar_Colection a JOIN @u x ON x.UserID = a.UserID WHERE NOT EXISTS (SELECT 1 FROM dbo.bak20261023_max3_avatar b WHERE b.UserID = a.UserID);
IF OBJECT_ID('dbo.bak20261023_max3_eat') IS NULL SELECT e.* INTO dbo.bak20261023_max3_eat FROM dbo.Sys_Eat_Pets e JOIN @u x ON x.UserID = e.UserID
ELSE INSERT INTO dbo.bak20261023_max3_eat SELECT e.* FROM dbo.Sys_Eat_Pets e JOIN @u x ON x.UserID = e.UserID WHERE NOT EXISTS (SELECT 1 FROM dbo.bak20261023_max3_eat b WHERE b.UserID = e.UserID);

-- Vat to
DECLARE @totem int = (SELECT MAX(ID) FROM Db_Tank.dbo.Totem_Info);
UPDATE d SET totemId = @totem FROM dbo.Sys_Users_Detail d JOIN @u x ON x.UserID = d.UserID;
PRINT N'Vat to: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' nhan vat -> totemId ' + CAST(@totem AS nvarchar(10));

-- Thoi trang (STRING_AGG ra bang tam truoc: dung truc tiep trong UPDATE bi Msg 130)
SELECT g.ID dataId, MIN(g.Sex) Sex, COUNT(*) n, STRING_AGG(CAST(g.TemplateID AS nvarchar(max)), ',') dress
  INTO #bo FROM Db_Tank.dbo.Cloth_Group_Template g GROUP BY g.ID;
DECLARE @het datetime = '2099-12-31';
UPDATE a SET ActiveDress = b.dress, ActiveCount = b.n, endTime = @het
  FROM dbo.User_Avatar_Colection a JOIN @u x ON x.UserID = a.UserID JOIN #bo b ON b.dataId = a.dataId;
PRINT N'Thoi trang: kich hoat ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' bo co san';
INSERT INTO dbo.User_Avatar_Colection (UserID, endTime, dataId, ActiveCount, Sex, ActiveDress)
SELECT x.UserID, @het, b.dataId, b.n, b.Sex, b.dress FROM @u x CROSS JOIN #bo b
  WHERE NOT EXISTS (SELECT 1 FROM dbo.User_Avatar_Colection a WHERE a.UserID = x.UserID AND a.dataId = b.dataId);
PRINT N'Thoi trang: them ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' bo moi';
DROP TABLE #bo;

-- Manh hoa pet
DECLARE @moe int = (SELECT MAX(Level) FROM Db_Tank.dbo.Pet_Moe_Property);
UPDATE e SET weaponLevel = @moe, weaponExp = 0, clothesLevel = @moe, clothesExp = 0, hatLevel = @moe, hatExp = 0
  FROM dbo.Sys_Eat_Pets e JOIN @u x ON x.UserID = e.UserID;
PRINT N'Manh hoa pet: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' nhan vat -> cap ' + CAST(@moe AS nvarchar(5));
INSERT INTO dbo.Sys_Eat_Pets (UserID, weaponExp, weaponLevel, clothesExp, clothesLevel, hatExp, hatLevel)
SELECT x.UserID, 0, @moe, 0, @moe, 0, @moe FROM @u x WHERE NOT EXISTS (SELECT 1 FROM dbo.Sys_Eat_Pets e WHERE e.UserID = x.UserID);

SELECT d.UserID, d.NickName, d.totemId,
       (SELECT COUNT(*) FROM dbo.User_Avatar_Colection a WHERE a.UserID = d.UserID AND a.endTime >= @het) bo_thoi_trang,
       e.weaponLevel, e.clothesLevel, e.hatLevel
  FROM dbo.Sys_Users_Detail d JOIN @u x ON x.UserID = d.UserID LEFT JOIN dbo.Sys_Eat_Pets e ON e.UserID = d.UserID;
GO
