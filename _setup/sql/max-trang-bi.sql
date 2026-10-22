-- max-trang-bi.sql (23/10/2026, server test): day trang bi dang mac cua 1 nhan vat len muc cao nhat dung duoc (client co du lieu + hinh).
--   sqlcmd -S localhost -E -C -b -f 65001 -v UID=227 -i max-trang-bi.sql
-- 1. Vu khi LEGEND-Ca Chep (71554/71555) -> 71556 "Ca Chep - Doi Vo Dich": cung chi so/hinh (Llotuscarp4), sat thuong 245 -> 300.
--    Doi TemplateID tai cho nen giu nguyen cuong hoa, hop thanh, chau bau.
-- 2. Lo 5, 6 cua mu/ao/vu khi (OpenFiveSixHoleHandler, chi 3 loai nay): cap 6 (HoleLevelUpExpList 6 moc), exp 0.
-- 3. Chau bau: lo loai 3 (thuoc tinh) -> 313638 Huyen Thoai -S Sieu Sat Lv5 (Property7 56 sat thuong + Property8 19 ho giap,
--    GamePlayer.BaseAttack/BaseDefence); lo loai 1/2 giu nguyen, trong thi kham 311525 (Xuyen giap Lv5) / 312514 (Hap thu Lv5).
--    Loai lo lay tu Shop_Goods.Hole ("cap,loai|..."); chi dong vao mau co bo lo quen thuoc (mu/ao '3,3|6,2|...', vu khi '3,1|6,3|...').
-- 4. Tiem nang 6 mon thoi trang (kinh 2, toc 3, hieu ung 4, mat 6, bo 13, canh 15 = InventoryItemInfo.isCanLatentEnergy client):
--    80,80,80,80 = "Nguon suc manh" 11689 (Property2 = Property3 = 80, client co), het han 2099 thay vi 7 ngay.
-- CHI khi offline. Sao luu: bak20261023_trangbi_<UID> (chi tao lan dau).
USE Db_Tank41;
GO
SET NOCOUNT ON;
DECLARE @u int = $(UID);
IF NOT EXISTS (SELECT 1 FROM dbo.Sys_Users_Detail WHERE UserID = @u) BEGIN RAISERROR(N'Khong co nhan vat %d', 16, 1, @u); RETURN; END
IF (SELECT State FROM dbo.Sys_Users_Detail WHERE UserID = @u) <> 0 BEGIN RAISERROR(N'Nhan vat %d dang online: thoat game han roi chay lai.', 16, 1, @u); RETURN; END
DECLARE @bk sysname = N'bak20261023_trangbi_' + CAST(@u AS nvarchar(10));
-- EXEC(...) chi nhan bien/chuoi, khong goi ham (CAST) ben trong -> ghep cau lenh ra bien truoc
DECLARE @sql nvarchar(max) = N'SELECT * INTO dbo.' + @bk + N' FROM dbo.Sys_Users_Goods WHERE UserID = ' + CAST(@u AS nvarchar(10)) + N' AND BagType = 0 AND Place < 31 AND IsExist = 1';
IF OBJECT_ID(N'dbo.' + @bk) IS NULL EXEC(@sql);

-- 1. vu khi
UPDATE dbo.Sys_Users_Goods SET TemplateID = 71556
  WHERE UserID = @u AND BagType = 0 AND Place = 6 AND IsExist = 1 AND TemplateID IN (71554, 71555);
PRINT N'Vu khi -> Ca Chep Doi Vo Dich: ' + CAST(@@ROWCOUNT AS nvarchar(5));

-- 2 + 3. lo va chau bau (mu 0, ao 4, vu khi 6)
DECLARE @SAT int = 313638, @T1 int = 311525, @T2 int = 312514;
SELECT g.ItemID, CAST(s.Hole AS nvarchar(100)) Hole INTO #tb
  FROM dbo.Sys_Users_Goods g JOIN Db_Tank.dbo.Shop_Goods s ON s.TemplateID = g.TemplateID
  WHERE g.UserID = @u AND g.BagType = 0 AND g.Place IN (0, 4, 6) AND g.IsExist = 1 AND s.CategoryID IN (1, 5, 7)
    AND CAST(s.Hole AS nvarchar(100)) IN ('3,3|6,2|9,3|12,3|0,3|0,3', '3,1|6,3|9,3|12,3|0,3|0,3');
UPDATE g SET
    Hole1 = CASE WHEN t.Hole LIKE '3,3|%' THEN @SAT ELSE CASE WHEN g.Hole1 > 0 THEN g.Hole1 ELSE @T1 END END,
    Hole2 = CASE WHEN t.Hole LIKE '3,1|%' THEN @SAT ELSE CASE WHEN g.Hole2 > 0 THEN g.Hole2 ELSE @T2 END END,
    Hole3 = @SAT, Hole4 = @SAT, Hole5 = @SAT, Hole6 = @SAT,
    Hole5Level = 6, Hole5Exp = 0, Hole6Level = 6, Hole6Exp = 0
  FROM dbo.Sys_Users_Goods g JOIN #tb t ON t.ItemID = g.ItemID
  WHERE g.StrengthenLevel >= 12;   -- lo 1-4 mo theo cap cuong hoa 3/6/9/12 (ItemInfo.OpenHole)
PRINT N'Lo 5-6 cap 6 + chau bau Sieu Sat: ' + CAST(@@ROWCOUNT AS nvarchar(5)) + N' mon';
DROP TABLE #tb;

-- 4. tiem nang thoi trang
UPDATE g SET latentEnergyCurStr = '80,80,80,80', latentEnergyNewStr = '80,80,80,80', latentEnergyEndTime = '2099-12-31'
  FROM dbo.Sys_Users_Goods g JOIN Db_Tank.dbo.Shop_Goods s ON s.TemplateID = g.TemplateID
  WHERE g.UserID = @u AND g.BagType = 0 AND g.Place < 31 AND g.IsExist = 1 AND s.CategoryID IN (2, 3, 4, 6, 13, 15);
PRINT N'Tiem nang 80 (het han 2099): ' + CAST(@@ROWCOUNT AS nvarchar(5)) + N' mon';

SELECT g.Place, g.TemplateID, g.StrengthenLevel st, g.Hole1, g.Hole2, g.Hole3, g.Hole4, g.Hole5, g.Hole6, g.Hole5Level, g.Hole6Level, g.latentEnergyCurStr
  FROM dbo.Sys_Users_Goods g WHERE g.UserID = @u AND g.BagType = 0 AND g.Place < 31 AND g.IsExist = 1 ORDER BY g.Place;
GO
