-- mo-het-pho-ban.sql (22/10/2026): mo het phó ban thuong (Type 4) chay duoc + sua do kho client cho chon ma khong co kich ban.
-- Da ra soat bang _setup/kiem-anh/kiem-pho-ban.js (kich ban game -> ai -> kich ban ai deu co trong Game.Server.dll dang chay).
--   * Dau truong ga (6): client cho chon Anh hung nhung TerrorGameScript rong -> gan GuluOlympicsTerrorGame (ai 6301-6304, DTGAH1165-1168).
--   * Ordering trong DB lech client (client moi la cai quyet dinh hien hay an, Request/LoadPVEItems.xml): dong bo DB = client
--     de lo xuat ban lai LoadPVEItems tu admin cung khong an mat. Mo them: Vong xoay thoi gian (12) 8, Bo lac nguyen thuy (18) 13,
--     Lau Dai Phep Thuat (19) 14, Phe tich thanh ga (20) 15, To Kien Lua (33) 16. Khong mo 1005 (trung Vong xoay 12, chi co De).
-- Sao luu: Db_Tank.dbo.bak20261022_pve_info (tao boi pho-ban-anh-hung.sql; chua co thi tao o day).
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i mo-het-pho-ban.sql   (chay lai an toan). Doi xong restart Road.
USE Db_Tank;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.bak20261022_pve_info') IS NULL
  SELECT * INTO dbo.bak20261022_pve_info FROM dbo.Pve_Info;
UPDATE dbo.Pve_Info SET TerrorGameScript = N'GameServerScript.AI.Game.GuluOlympicsTerrorGame' WHERE ID = 6 AND ISNULL(TerrorGameScript, '') = '';
-- thu tu giong client (Request/LoadPVEItems.xml sau khi sua)
DECLARE @o TABLE(ID int PRIMARY KEY, Ord int);
INSERT INTO @o VALUES (2,1),(7,2),(1,3),(3,4),(4,5),(5,6),(6,7),(12,8),(13,9),(15,10),(16,11),(17,12),(18,13),(19,14),(20,15),(33,16);
UPDATE p SET p.Ordering = o.Ord FROM dbo.Pve_Info p JOIN @o o ON o.ID = p.ID;
SELECT p.ID, p.Name, p.Ordering, p.TerrorGameScript FROM dbo.Pve_Info p JOIN @o o ON o.ID = p.ID ORDER BY p.Ordering;
-- Hoan tac: UPDATE p SET p.Ordering = b.Ordering, p.TerrorGameScript = b.TerrorGameScript FROM dbo.Pve_Info p JOIN dbo.bak20261022_pve_info b ON b.ID = p.ID;
GO
