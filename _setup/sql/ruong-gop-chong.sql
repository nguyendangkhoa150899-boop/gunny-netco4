-- ruong-gop-chong.sql: gop do dang co trong Web_Ruong theo luat chong cua game (Shop_Goods.MaxCount).
-- Cung MemberID + TemplateID + ValidDate + StrengthenLevel + IsBind va MaxCount > 1 -> gop, chia lai moi o toi da MaxCount.
-- Mon MaxCount = 1 (chau bau, trang bi...) giu nguyen tung o. Tu nay web tu cong don khi do vao ruong (MiniGameController::vaoRuong).
-- Chay lai an toan. Chay: sqlcmd -S localhost -E -C -b -f 65001 -i ruong-gop-chong.sql
USE Db_Member;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRAN;
SELECT r.MemberID, r.TemplateID, r.ValidDate, r.StrengthenLevel, r.IsBind, SUM(r.[Count]) Tong, MAX(r.Nguon) Nguon, MAX(r.ThoiGian) ThoiGian, MAX(g.MaxCount) Mx
INTO #g
FROM dbo.Web_Ruong r WITH (UPDLOCK) JOIN Db_Tank.dbo.Shop_Goods g ON g.TemplateID=r.TemplateID
WHERE g.MaxCount > 1
GROUP BY r.MemberID, r.TemplateID, r.ValidDate, r.StrengthenLevel, r.IsBind
HAVING COUNT(*) > 1 OR SUM(r.[Count]) > MAX(g.MaxCount);
DECLARE @truoc int = (SELECT COUNT(*) FROM dbo.Web_Ruong);
DELETE r FROM dbo.Web_Ruong r JOIN #g ON #g.MemberID=r.MemberID AND #g.TemplateID=r.TemplateID AND #g.ValidDate=r.ValidDate AND #g.StrengthenLevel=r.StrengthenLevel AND #g.IsBind=r.IsBind;
-- chia lai: o thu k (0..) giu min(Mx, Tong - k*Mx)
INSERT INTO dbo.Web_Ruong(MemberID,TemplateID,[Count],ValidDate,StrengthenLevel,IsBind,Nguon,ThoiGian)
SELECT #g.MemberID, #g.TemplateID, CASE WHEN #g.Tong - n.k*#g.Mx > #g.Mx THEN #g.Mx ELSE #g.Tong - n.k*#g.Mx END,
       #g.ValidDate, #g.StrengthenLevel, #g.IsBind, #g.Nguon, #g.ThoiGian
FROM #g JOIN (SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 k FROM sys.all_objects) n ON n.k*#g.Mx < #g.Tong;
DECLARE @sau int = (SELECT COUNT(*) FROM dbo.Web_Ruong);
COMMIT;
PRINT N'Gop ruong: ' + CAST(@truoc AS nvarchar(10)) + N' o -> ' + CAST(@sau AS nvarchar(10)) + N' o';
GO
