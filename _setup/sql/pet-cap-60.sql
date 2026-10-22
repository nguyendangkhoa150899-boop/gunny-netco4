-- pet-cap-60.sql (23/10/2026, server test): nang cap toi da cua pet 50 -> 60.
-- Ly do: do pet (Gay Nhu Y 30105, Non Long Phuong 31105, Giap Hoang Kim 32105...) Property2 = 60 = "Cap thu cung yeu cau Lv.60",
--   nhung Pet_Config.MaxLevel = 50 nen pet khong bao gio du cap -> client khong cong chi so do pet.
-- Pet_Level (server) da co 70 cap; PetInventory.MaxLevelByGrade = min(MaxLevel, cap nhan vat) nen 60 = cap nhan vat toi da.
-- Client: Request/petconfiginfo.xml MaxLevel 60 + Request/petlevelinfo.xml them cap 51-60 (GP lay tu Pet_Level).
-- Ap dung: PHAI restart Road (PetMgr nap Pet_Config luc khoi dong). Hoan tac: UPDATE ... SET Value = '50' + tra 2 file XML.
USE Db_Tank;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.bak20261023_pet_config') IS NULL SELECT * INTO dbo.bak20261023_pet_config FROM dbo.Pet_Config WHERE Name = 'MaxLevel';
UPDATE dbo.Pet_Config SET Value = '60' WHERE Name = 'MaxLevel';
SELECT Name, Value FROM dbo.Pet_Config WHERE Name = 'MaxLevel';
GO
