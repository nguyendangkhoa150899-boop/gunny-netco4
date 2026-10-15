-- lam-trang.sql : XOA SACH DU LIEU NGUOI CHOI, GIU NGUYEN CAU HINH (thay wipe-ve-trang.sql cu, file cu xoa ca bang cau hinh moi).
-- Dung 2 cach:
--   a) Dong goi ban trang tu server dang chay: chay tren BAN SAO (restore ten *_TRANG), xem _setup/dong-goi.ps1:
--        sqlcmd -S localhost -E -C -b -f 65001 -i lam-trang.sql -v T41=Db_Tank41_TRANG MEM=Db_Member_TRANG ADM=Db_Admin_TRANG
--   b) Xoa trang ngay tren server (TAT Road/Fighting/Center truoc, nguoi online nam trong RAM Road):
--        sqlcmd -S localhost -E -C -b -f 65001 -i lam-trang.sql -v T41=Db_Tank41 MEM=Db_Member ADM=Db_Admin
-- GIU: Shop_Goods, Server_Config, Server_List, Server_Event, GM_*, Game_Commands (chi UserID 1), Rate, Web_DiemDanh_Qua,
--      Active_Number dong goc (UserID=0, ma giftcode), nhan vat NganHang (UserID 241, dung cho rut xu), moi bang Db_Tank,
--      Db_Member: Server_List, Settings, Shop_Goods, Support_Category, Web_CauHinh, Web_Shop, Web_The_PhoBan/Man/Qua.
--      Db_Admin: settings (he-so-doi-coin), bang quyen/cau hinh. Db_Gm: khong dung (tool GM cu khong trien khai), giu nguyen.
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO
USE [$(T41)];
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all';
DECLARE @s nvarchar(max) = N'';
SELECT @s = @s + N'DELETE FROM [' + name + N'];' FROM sys.tables
 WHERE name NOT IN ('Shop_Goods','Server_Config','Server_List','Server_Event','GM_Active_Condition','GM_Active_Reward',
                    'GM_Activity','GM_Gift_Bag','Game_Commands','Rate','Web_DiemDanh_Qua','Active_Number','Sys_Users_Detail')
   AND name NOT LIKE 'bak2026%';
EXEC sp_executesql @s;
DELETE FROM Active_Number WHERE UserID <> 0;                 -- luot nguoi da nhan giftcode
DELETE FROM Sys_Users_Detail WHERE UserID <> 241;            -- giu NganHang
UPDATE Sys_Users_Detail SET State = 0 WHERE UserID = 241;
DELETE FROM Game_Commands WHERE UserID <> 1;                 -- bang rong thi Road tu tat: giu dong UserID 1
IF NOT EXISTS (SELECT 1 FROM Game_Commands) RAISERROR(N'Game_Commands rong: Road se khong khoi dong. Them lai 1 dong.', 16, 1);
DECLARE @d nvarchar(max) = N'';
SELECT @d = @d + N'DROP TABLE [' + name + N'];' FROM sys.tables WHERE name LIKE 'bak2026%';
EXEC sp_executesql @d;
EXEC sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT all';
GO
USE [$(MEM)];
DECLARE @s nvarchar(max) = N'';
SELECT @s = @s + N'DELETE FROM [' + name + N'];' FROM sys.tables
 WHERE name IN ('Mem_Account','Mem_History','Mem_Launcher','Verify_Email','Password_Resets','WSs_LogCardCham',
                'Web_Diem','Web_SoDiem','Web_SoXu','Web_DoMin','Web_TaiXiu','Web_QuaTest','Web_Ruong','Web_RutXu',
                'Web_ShopMua','Web_The_Luot','Web_The_Quet');
EXEC sp_executesql @s;
GO
USE [$(ADM)];
DECLARE @s nvarchar(max) = N'';
SELECT @s = @s + N'DELETE FROM [' + name + N'];' FROM sys.tables
 WHERE name IN ('member_token','admin_operation_log','online_report','User_Processes','admin_coin_logs','ban_member_reason',
                'clear_bag_password_code','forgotpass_attempts');
EXEC sp_executesql @s;
GO
PRINT N'=== Con du lieu (de soat) ===';
SELECT '$(T41)' db, t.name, SUM(p.rows) dong FROM [$(T41)].sys.tables t JOIN [$(T41)].sys.partitions p ON p.object_id=t.object_id AND p.index_id IN (0,1) GROUP BY t.name HAVING SUM(p.rows)>0 ORDER BY t.name;
SELECT '$(MEM)' db, t.name, SUM(p.rows) dong FROM [$(MEM)].sys.tables t JOIN [$(MEM)].sys.partitions p ON p.object_id=t.object_id AND p.index_id IN (0,1) GROUP BY t.name HAVING SUM(p.rows)>0 ORDER BY t.name;
SELECT '$(ADM)' db, t.name, SUM(p.rows) dong FROM [$(ADM)].sys.tables t JOIN [$(ADM)].sys.partitions p ON p.object_id=t.object_id AND p.index_id IN (0,1) GROUP BY t.name HAVING SUM(p.rows)>0 ORDER BY t.name;
GO
