-- CU, DUNG DUNG (15/10/2026): xoa ca bang cau hinh moi (Rate, Web_DiemDanh_Qua, Active_Number, Web_*...). Dung lam-trang.sql.
SET NOCOUNT ON;
USE Db_Tank41;
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all';
DECLARE @s NVARCHAR(MAX)=N'';
SELECT @s=@s+N'DELETE FROM ['+name+N'];' FROM sys.tables
 WHERE name NOT IN ('Shop_Goods','Server_Config','Server_List','Server_Event','GM_Active_Condition','GM_Active_Reward','GM_Activity','GM_Gift_Bag','Game_Commands');
EXEC sp_executesql @s;
EXEC sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT all';
GO
USE Db_Member;
DELETE FROM Mem_Account;
DELETE FROM Mem_History;
DELETE FROM Mem_Launcher;
DELETE FROM Verify_Email;
DELETE FROM Password_Resets;
DELETE FROM WSs_LogCardCham;
GO
PRINT '=== Db_Tank41 remaining (non-empty) ===';
USE Db_Tank41;
SELECT t.name, SUM(p.rows) rows FROM sys.tables t JOIN sys.partitions p ON t.object_id=p.object_id WHERE p.index_id IN (0,1) GROUP BY t.name HAVING SUM(p.rows)>0 ORDER BY t.name;
PRINT '=== Db_Member remaining (non-empty) ===';
USE Db_Member;
SELECT t.name, SUM(p.rows) rows FROM sys.tables t JOIN sys.partitions p ON t.object_id=p.object_id WHERE p.index_id IN (0,1) GROUP BY t.name HAVING SUM(p.rows)>0 ORDER BY t.name;
GO
