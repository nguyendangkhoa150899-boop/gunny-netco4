-- pho-ban-anh-hung.sql (22/10/2026): mo do kho Anh hung (Terror) cho Bo lac Ta than (3), Phao dai hac am (4), Dai chien rong (5).
-- Loi: client hien do kho Anh hung (LoadPVEItems.xml co TerrorTemplateIds) nhung Pve_Info.TerrorGameScript rong
--   -> Road loi "String cannot have zero length" o ScriptMgr.CreateInstance, bao "副本尚未开启或者副本已经关闭!", ket loading 98%.
-- Kich ban da co san trong Game.Server.dll dang chay (da kiem): EvilTribeTerrorGame (ai 3301-3303,3306), DarkCastleTerrorGame
--   (4301-4303), DragonWarTerrorGame (5301-5304); cac ai co trong Mission_Info va kich ban ai (BLTTAH/PDHAAH/DCR53xx) cung co trong DLL.
-- Sao luu: Db_Tank.dbo.bak20261022_pve_info. Doi Pve_Info xong phai restart Road (khong co lenh nap lai tu xa).
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i pho-ban-anh-hung.sql   (chay lai an toan)
USE Db_Tank;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.bak20261022_pve_info') IS NULL
  SELECT * INTO dbo.bak20261022_pve_info FROM dbo.Pve_Info;
UPDATE dbo.Pve_Info SET TerrorGameScript = N'GameServerScript.AI.Game.EvilTribeTerrorGame'  WHERE ID = 3 AND ISNULL(TerrorGameScript, '') = '';
UPDATE dbo.Pve_Info SET TerrorGameScript = N'GameServerScript.AI.Game.DarkCastleTerrorGame' WHERE ID = 4 AND ISNULL(TerrorGameScript, '') = '';
UPDATE dbo.Pve_Info SET TerrorGameScript = N'GameServerScript.AI.Game.DragonWarTerrorGame'  WHERE ID = 5 AND ISNULL(TerrorGameScript, '') = '';
SELECT ID, Name, TerrorGameScript FROM dbo.Pve_Info WHERE ID IN (3, 4, 5);
-- Hoan tac: UPDATE p SET p.TerrorGameScript = b.TerrorGameScript FROM dbo.Pve_Info p JOIN dbo.bak20261022_pve_info b ON b.ID = p.ID WHERE p.ID IN (3,4,5);
GO
