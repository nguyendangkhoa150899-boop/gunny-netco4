-- giftcode-sua-gioi-tinh.sql (21/10/2026): qua giftcode phat dung gioi tinh.
--
-- Loi 1: code NETCO4VIP (su kien "Code VIP test pho ban") gan ao 60000101 cho NU (Sex=2), nhung 60000101 la
--   "Ao Giap Mathias (Sieu cap)" ban NAM (NeedSex=1). Nhan vat nu nhan ao khong mac duoc. Ban nu la 60000102 (cung chi so).
-- Loi 2: admin > Giftcode > Them qua luon ghi Active_Award.Sex=0, nen do nam/nu phat cho ca 2 gioi tinh
--   (SP_Active_PullDown chi gui mon co Sex = gioi tinh nhan vat hoac 0). Sua: Sex = Shop_Goods.NeedSex.
--   Code admin da sua (actions.php gc_award_add), file nay sua cac dong da co.
-- Sao luu: Db_Tank.dbo.bak20261021_active_award (ca bang, chi tao 1 lan).
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i giftcode-sua-gioi-tinh.sql   (chay lai an toan)
-- Doi qua xong khong can restart: SP doc DB moi lan nhap code. Muon client hien dung danh sach qua: admin > He thong > xuat ban ActiveList.
USE Db_Tank;
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.bak20261021_active_award') IS NULL
  SELECT * INTO dbo.bak20261021_active_award FROM dbo.Active_Award;

IF NOT EXISTS (SELECT 1 FROM dbo.Shop_Goods WHERE TemplateID=60000102 AND NeedSex=2)
BEGIN RAISERROR(N'Khong thay 60000102 (Ao Giap Mathias nu) trong Shop_Goods, khong sua.',16,1); RETURN; END

DECLARE @vip int = (SELECT TOP 1 ActiveID FROM dbo.Active WHERE Title LIKE N'Code VIP test ph%' ORDER BY ActiveID);
DECLARE @n1 int, @n2 int;

-- 1. NETCO4VIP: ao nu 60000101 -> 60000102
UPDATE dbo.Active_Award SET ItemID=60000102 WHERE ActiveID=@vip AND ItemID=60000101 AND Sex=2;
SET @n1 = @@ROWCOUNT;

-- 2. qua Sex=0 ma mon chi cho 1 gioi tinh -> Sex = NeedSex
UPDATE w SET w.Sex = g.NeedSex
  FROM dbo.Active_Award w JOIN dbo.Shop_Goods g ON g.TemplateID = w.ItemID
  WHERE w.ItemID > 0 AND w.Sex = 0 AND g.NeedSex IN (1,2);
SET @n2 = @@ROWCOUNT;

PRINT N'Su kien VIP #' + ISNULL(CAST(@vip AS nvarchar(10)), N'(khong co)') + N': doi ' + CAST(@n1 AS nvarchar(10)) + N' dong ao nu sang 60000102.';
PRINT N'Gan lai gioi tinh: ' + CAST(@n2 AS nvarchar(10)) + N' dong qua.';

-- 3. con lech (qua phat cho gioi tinh khac voi mon): chi liet ke, sua tay o admin
SELECT w.ActiveID, w.ID, w.ItemID, g.Name, g.NeedSex, w.Sex AS PhatCho
  FROM dbo.Active_Award w JOIN dbo.Shop_Goods g ON g.TemplateID = w.ItemID
  WHERE w.ItemID > 0 AND g.NeedSex IN (1,2) AND w.Sex <> g.NeedSex;

-- 4. nhan vat NU da nhap NETCO4VIP truoc khi sua (da nhan ao nam 60000101): can gui bu 60000102 +12 qua admin > Gui qua
--    (khong INSERT thang: nguoi online du lieu nam trong RAM Road). Sys_Users_Detail.Sex: 1 nam, 0 nu.
SELECT d.UserID, d.NickName, n.AwardID AS Code, n.[GetDate] AS NgayNhan
  FROM Db_Tank41.dbo.Active_Number n JOIN Db_Tank41.dbo.Sys_Users_Detail d ON d.UserID = n.UserID
  WHERE n.ActiveID = @vip AND n.UserID <> 0 AND d.Sex = 0
  ORDER BY n.[GetDate];
GO
