-- go-do-la-pexuanmai.sql (22/10/2026): PeXuanMai (UserID 252) ket man hinh giay trong khi vao sanh vi tui co 3 mon client khong biet
-- (mo "Ruong phat tai" 190000 luc 21:40): 85382 / 85381 Vong Tay 13 Tuoi +8/+7, 160126 Vu Khi Bach Diem Thanh Ho Lv4 (vu khi pet).
-- Chi chay khi nhan vat OFFLINE (State=0), online thi Road ghi de. Sao luu: Db_Tank41.dbo.bak20261022_pexuanmai_goods. IsExist=0 (khong xoa).
USE Db_Tank41;
GO
SET NOCOUNT ON;
IF (SELECT State FROM dbo.Sys_Users_Detail WHERE UserID = 252) <> 0 BEGIN RAISERROR(N'PeXuanMai dang online, khong sua.', 16, 1); RETURN; END
IF OBJECT_ID('dbo.bak20261022_pexuanmai_goods') IS NULL
  SELECT * INTO dbo.bak20261022_pexuanmai_goods FROM dbo.Sys_Users_Goods WHERE UserID = 252 AND TemplateID IN (85381, 85382, 160126) AND IsExist = 1;
UPDATE dbo.Sys_Users_Goods SET IsExist = 0 WHERE UserID = 252 AND TemplateID IN (85381, 85382, 160126) AND IsExist = 1;
PRINT N'Go: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' mon';
GO
