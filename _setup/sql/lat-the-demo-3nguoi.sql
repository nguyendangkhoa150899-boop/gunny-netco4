-- 22/10/2026: 2 ban lat the CHUNG demo 3 nguoi: bialk + daulk456 (PeXuanMai) + dau123 (2 tai khoan cua Dau).
-- Giong lat-the-demo.sql: LogID am, ngay hom qua (khong an gioi han ngay), khong cong diem; qua khi lat la that. Chay lai se tao them.
USE Db_Member;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE @acc TABLE(n int IDENTITY(1,1), Acc varchar(50), G int, Ten nvarchar(50), M int);
INSERT INTO @acc(Acc) VALUES('bialk'), ('daulk456'), ('dau123');
UPDATE a SET G = d.UserID, Ten = d.NickName, M = m.UserID FROM @acc a
  JOIN Db_Tank41.dbo.Sys_Users_Detail d ON d.UserName = a.Acc JOIN dbo.Mem_Account m ON m.Email = a.Acc;
IF EXISTS (SELECT 1 FROM @acc WHERE G IS NULL OR M IS NULL) BEGIN RAISERROR(N'Thieu tai khoan / nhan vat', 16, 1); RETURN; END
DECLARE @nguoi nvarchar(1000) = N'[' + (SELECT STRING_AGG(N'{"u":' + CAST(G AS nvarchar(12)) + N',"n":"' + STRING_ESCAPE(Ten, 'json') + N'"}', N',') WITHIN GROUP (ORDER BY n) FROM @acc) + N']';
-- pho ban co bang roi do that, khac 3 ban cua lat-the-demo.sql (bo 3 dau theo ten)
DECLARE @pb TABLE(n int IDENTITY(1,1), Khoa nvarchar(100), ManCuoi int);
INSERT INTO @pb(Khoa, ManCuoi)
SELECT p.Khoa, p.ManCuoi FROM dbo.Web_The_PhoBan p
WHERE p.BatTat = 1 AND p.ManCuoi IS NOT NULL AND EXISTS (SELECT 1 FROM Db_Tank.dbo.Drop_Condiction c
  WHERE c.CondictionType = 5 AND c.Para1 LIKE '%,' + CAST(p.ManCuoi AS varchar(12)) + ',%' AND EXISTS (SELECT 1 FROM Db_Tank.dbo.Drop_Item i WHERE i.DropId = c.DropID))
ORDER BY p.Khoa OFFSET 3 ROWS FETCH NEXT 2 ROWS ONLY;
BEGIN TRAN;
DECLARE @i int = 1, @k nvarchar(100), @mis int, @t datetime, @id bigint, @log int;
SELECT @log = ISNULL(MIN(LogID), 0) FROM dbo.Web_The_Luot WHERE LogID < 0;
WHILE @i <= (SELECT COUNT(*) FROM @pb)
BEGIN
  SELECT @k = Khoa, @mis = ManCuoi FROM @pb WHERE n = @i;
  SET @t = DATEADD(minute, -5 * @i, DATEADD(day, -1, GETDATE()));
  INSERT INTO dbo.Web_The_Ban(Khoa, MissionId, ThoiGian, Ngay, NguoiChoi) VALUES(@k, @mis, @t, CAST(@t AS date), @nguoi);
  SET @id = SCOPE_IDENTITY();
  INSERT INTO dbo.Web_The_Luot(MemberID, GameUserID, LogID, Khoa, MissionId, Bai, ThoiGian, Ngay, BanID)
  SELECT M, G, @log - 3 * @i - n, @k, @mis, '[]', @t, CAST(@t AS date), @id FROM @acc;
  SET @i += 1;
END
COMMIT;
SELECT b.ID, b.Khoa, (SELECT COUNT(*) FROM dbo.Web_The_Luot l WHERE l.BanID = b.ID) so_luot, b.NguoiChoi
FROM dbo.Web_The_Ban b WHERE b.ID IN (SELECT TOP 2 ID FROM dbo.Web_The_Ban ORDER BY ID DESC);
GO
