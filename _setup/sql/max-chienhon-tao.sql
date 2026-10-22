-- max-chienhon-tao.sql (23/10/2026, server test): max Chien hon (Lo Ren) + "Tao" (Gia Cong) cho 1 nhan vat.
--   sqlcmd -S localhost -E -C -b -f 65001 -v UID=227 -i max-chienhon-tao.sql
-- Chien hon: Db_Tank41.Sys_User_Gemstone, moi nhan vat 5 dong (EquipPlace 2,3,5,11,13), FigSpiritIdValue "cap,exp,o|cap,exp,o|cap,exp,o"
--   -> cap = Server_Config FightSpiritMaxLevel (6), exp 0, giu nguyen thu tu o.
-- Tao: Sys_Users_Detail.fineSuitExp = Exp cua cap cao nhat trong Db_Tank.Sets_Build_Temp (cap 70 Ngoc = 345860, SetsBuildTempMgr.SetsBuildMax).
-- CHI khi offline (State=0): online thi Road giu trong RAM, thoat game ghi de. Sao luu: bak20261023_max_<UID>_gem / _detail.
USE Db_Tank41;
GO
SET NOCOUNT ON;
DECLARE @u int = $(UID);
IF NOT EXISTS (SELECT 1 FROM dbo.Sys_Users_Detail WHERE UserID = @u) BEGIN RAISERROR(N'Khong co nhan vat %d', 16, 1, @u); RETURN; END
IF (SELECT State FROM dbo.Sys_Users_Detail WHERE UserID = @u) <> 0 BEGIN RAISERROR(N'Nhan vat %d dang online: thoat game han roi chay lai.', 16, 1, @u); RETURN; END
DECLARE @lv int = ISNULL((SELECT TOP 1 CAST(CAST(Value AS nvarchar(20)) AS int) FROM dbo.Server_Config WHERE Name = 'FightSpiritMaxLevel'), 6);
DECLARE @exp int = (SELECT TOP 1 Exp FROM Db_Tank.dbo.Sets_Build_Temp ORDER BY Level DESC);
DECLARE @bg sysname = N'bak20261023_max_' + CAST(@u AS nvarchar(10)) + N'_gem', @bd sysname = N'bak20261023_max_' + CAST(@u AS nvarchar(10)) + N'_detail';
IF OBJECT_ID(N'dbo.' + @bg) IS NULL EXEC(N'SELECT * INTO dbo.' + @bg + N' FROM dbo.Sys_User_Gemstone WHERE UserID = ' + @u);
IF OBJECT_ID(N'dbo.' + @bd) IS NULL EXEC(N'SELECT UserID, fineSuitExp INTO dbo.' + @bd + N' FROM dbo.Sys_Users_Detail WHERE UserID = ' + @u);
-- "a,b,o|c,d,o2|e,f,o3" -> "lv,0,o|lv,0,o2|lv,0,o3" (giu o = phan sau dau phay cuoi cua moi doan; PARSENAME chi tach 4 phan nen khong dung)
DECLARE @L nvarchar(5) = CAST(@lv AS nvarchar(5));
UPDATE g SET FigSpiritIdValue =
    @L + ',0,' + REVERSE(LEFT(REVERSE(s.s1), CHARINDEX(',', REVERSE(s.s1)) - 1)) + '|' +
    @L + ',0,' + REVERSE(LEFT(REVERSE(s.s2), CHARINDEX(',', REVERSE(s.s2)) - 1)) + '|' +
    @L + ',0,' + REVERSE(LEFT(REVERSE(s.s3), CHARINDEX(',', REVERSE(s.s3)) - 1))
  FROM dbo.Sys_User_Gemstone g
  CROSS APPLY (SELECT CHARINDEX('|', g.FigSpiritIdValue) p1) a
  CROSS APPLY (SELECT CHARINDEX('|', g.FigSpiritIdValue, a.p1 + 1) p2) b
  CROSS APPLY (SELECT LEFT(g.FigSpiritIdValue, a.p1 - 1) s1, SUBSTRING(g.FigSpiritIdValue, a.p1 + 1, b.p2 - a.p1 - 1) s2, SUBSTRING(g.FigSpiritIdValue, b.p2 + 1, 100) s3) s
  WHERE g.UserID = @u AND a.p1 > 0 AND b.p2 > 0;
PRINT N'Chien hon: ' + CAST(@@ROWCOUNT AS nvarchar(5)) + N' dong -> cap ' + CAST(@lv AS nvarchar(5));
UPDATE dbo.Sys_Users_Detail SET fineSuitExp = @exp WHERE UserID = @u;
PRINT N'Tao: fineSuitExp = ' + CAST(@exp AS nvarchar(10));
SELECT FigSpiritId, FigSpiritIdValue, EquipPlace FROM dbo.Sys_User_Gemstone WHERE UserID = @u ORDER BY EquipPlace;
GO
