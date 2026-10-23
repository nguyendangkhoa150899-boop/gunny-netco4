-- 23/10/2026: Road goi SP_Suit_Manager_Reset / SP_Suit_Manager_Update qua ProduceBussiness (BaseCrossBussiness = ket noi Db_Tank)
-- moi lan tinh luc chien bo do (PlayerEquipInventory.luc_Chien_Suit), nhung 2 SP nay chi co o Db_Tank41 -> luon loi
-- "Could not find stored procedure" (Event Log Application ~1.700 lan/ngay), Suit_Manager.Kill_List khong bao gio cap nhat.
-- Sua bang du lieu, khong dung code game: tao trong Db_Tank 2 SP CHUYEN TIEP goi ban that o Db_Tank41 (cung tham so).
-- Chay lai an toan. Hoan tac: DROP PROCEDURE Db_Tank.dbo.SP_Suit_Manager_Reset, Db_Tank.dbo.SP_Suit_Manager_Update.
USE Db_Tank;
GO
CREATE OR ALTER PROCEDURE dbo.SP_Suit_Manager_Reset @UserID int
AS
  EXEC Db_Tank41.dbo.SP_Suit_Manager_Reset @UserID = @UserID;
GO
CREATE OR ALTER PROCEDURE dbo.SP_Suit_Manager_Update @kill nvarchar(200), @UserID int
AS
  EXEC Db_Tank41.dbo.SP_Suit_Manager_Update @kill = @kill, @UserID = @UserID;
GO
PRINT N'Da tao SP chuyen tiep SP_Suit_Manager_Reset / _Update trong Db_Tank';
GO
