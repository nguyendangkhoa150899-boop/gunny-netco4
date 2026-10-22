-- 22/10/2026: 4 ban lat the demo Vong Xoay Thoi Gian (De / Thuong / Kho / AH) cho bialk, gan dung AI CUOI (S4) cua tung do kho
-- -> lat ra dung qua bang ai cuoi cua game (10081 / 10181 / 10184 / 10187). Giong lat-the-demo.sql: LogID am, ngay hom qua
-- (khong an gioi han ngay), khong cong diem; qua khi lat la that. Chay lai se tao them 4 ban.
USE Db_Member;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE @g int, @ten nvarchar(50), @m int;
SELECT @g = UserID, @ten = NickName FROM Db_Tank41.dbo.Sys_Users_Detail WHERE UserName = 'bialk';
SELECT @m = UserID FROM dbo.Mem_Account WHERE Email = 'bialk';
IF @g IS NULL OR @m IS NULL BEGIN RAISERROR(N'Khong thay bialk', 16, 1); RETURN; END
DECLARE @nguoi nvarchar(1000) = N'[{"u":' + CAST(@g AS nvarchar(12)) + N',"n":"' + STRING_ESCAPE(@ten, 'json') + N'"}]';
DECLARE @pb TABLE(n int IDENTITY(1,1), Khoa nvarchar(100), ManCuoi int);
INSERT INTO @pb(Khoa, ManCuoi) SELECT Khoa, ManCuoi FROM dbo.Web_The_PhoBan WHERE Khoa LIKE N'Vòng Xoáy Thời Gian%' AND ManCuoi IS NOT NULL ORDER BY ManCuoi;
BEGIN TRAN;
DECLARE @i int = 1, @k nvarchar(100), @mis int, @t datetime, @id bigint, @log int;
SELECT @log = ISNULL(MIN(LogID), 0) FROM dbo.Web_The_Luot WHERE LogID < 0;
WHILE @i <= (SELECT COUNT(*) FROM @pb)
BEGIN
  SELECT @k = Khoa, @mis = ManCuoi FROM @pb WHERE n = @i;
  SET @t = DATEADD(minute, -3 * @i, DATEADD(day, -1, GETDATE()));
  INSERT INTO dbo.Web_The_Ban(Khoa, MissionId, ThoiGian, Ngay, NguoiChoi) VALUES(@k, @mis, @t, CAST(@t AS date), @nguoi);
  SET @id = SCOPE_IDENTITY();
  INSERT INTO dbo.Web_The_Luot(MemberID, GameUserID, LogID, Khoa, MissionId, Bai, ThoiGian, Ngay, BanID)
  VALUES(@m, @g, @log - @i, @k, @mis, '[]', @t, CAST(@t AS date), @id);
  SET @i += 1;
END
COMMIT;
SELECT b.ID, b.Khoa, b.MissionId FROM dbo.Web_The_Ban b JOIN dbo.Web_The_Luot l ON l.BanID = b.ID WHERE l.GameUserID = @g AND l.LogID < 0 AND b.Khoa LIKE N'Vòng Xoáy%';
GO
