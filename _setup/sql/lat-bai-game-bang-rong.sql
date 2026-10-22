-- 22/10/2026: LAT BAI TRONG GAME ra la trang, khong nhan gi: 17 bang roi do lat bai (Drop_Condiction CondictionType=5)
-- khong co dong Drop_Item nao (PVEGame.TakeCard -> DropInventory.CopyDrop quay bang rong). Vd Vong Xoay Thoi Gian AH S1 = DropID 10186.
-- Sua: chep do tu bang co do CUNG pho ban (ai khac / do kho khac), giong cach web lat the chon bang (MiniGameController::dropIdCua).
-- Them: go 200549 "Ruong trang suc so cap" khoi bang 10096 (hop rong: mo ra mat hop, _setup/do-vo-dung.json).
-- Drop_Item nap luc Road khoi dong: PHAI RESTART ROAD moi co hieu luc. Chay lai an toan (chi chep vao bang con rong).
-- Hoan tac: DELETE FROM Db_Tank.dbo.Drop_Item WHERE DropId IN (27,10067,10068,10075,10091,10094,10100,10103,10180,10181,10182,10183,10184,10185,10186,10187,10188);
--           INSERT lai 200549 tu Db_Tank.dbo.bak20261022_drop_200549.
USE Db_Tank;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE @map TABLE(Dich int PRIMARY KEY, Nguon int);
INSERT INTO @map VALUES (27,26),(10067,10102),(10068,10102),(10075,10090),(10091,10090),(10094,10093),(10100,11091),(10103,10102),
  (10180,10081),(10181,10081),(10182,10081),(10183,10081),(10184,10081),(10185,10081),(10186,10081),(10187,10081),(10188,10081);
BEGIN TRAN;
INSERT INTO dbo.Drop_Item(DropId, ItemId, ValueDate, IsBind, Random, BeginData, EndData, IsTips, IsLogs)
SELECT m.Dich, i.ItemId, i.ValueDate, i.IsBind, i.Random, i.BeginData, i.EndData, i.IsTips, i.IsLogs
FROM @map m JOIN dbo.Drop_Item i ON i.DropId = m.Nguon
WHERE NOT EXISTS (SELECT 1 FROM dbo.Drop_Item x WHERE x.DropId = m.Dich);   -- chi bang con rong
DECLARE @them int = @@ROWCOUNT;
IF OBJECT_ID('dbo.bak20261022_drop_200549') IS NULL SELECT * INTO dbo.bak20261022_drop_200549 FROM dbo.Drop_Item WHERE ItemId = 200549;
DELETE FROM dbo.Drop_Item WHERE ItemId = 200549;
DECLARE @go int = @@ROWCOUNT;
COMMIT;
DECLARE @con int = (SELECT COUNT(*) FROM dbo.Drop_Condiction c WHERE c.CondictionType = 5 AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item i WHERE i.DropId = c.DropID));
PRINT N'Chep ' + CAST(@them AS nvarchar(10)) + N' dong vao bang lat bai rong, go ' + CAST(@go AS nvarchar(10)) + N' dong 200549. Bang lat bai con rong: ' + CAST(@con AS nvarchar(10));
GO
