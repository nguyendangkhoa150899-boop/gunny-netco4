-- lat-the-can-bang.sql: can bo qua web (Khoa NULL, dung cho 28 pho ban khong co bang roi do game) theo gia shop web.
-- Gia shop (xu web): manh ghep Thien su 150-250 nghin, VIP/WOW Thien su 0,8 / 1,5 trieu, vu khi SUPER 2 - 2,5 trieu.
-- Mot la xu web trung binh ~4.900 -> cay deu ~10 luot/ngay x 3 la ~ 90-100 nghin/ngay -> ~3 tuan du 1 vu khi SUPER (khop lo trinh 2 thang).
-- Vang trong bang roi do game quy thanh xu web: lt_vang_xuweb (mac dinh 1 vang = 1 xu web).
-- CHAY LAI SE GHI DE xu web cua bo qua chung (mon do giu nguyen). Chay: sqlcmd -S localhost -E -C -b -f 65001 -i lat-the-can-bang.sql
USE Db_Member;
GO
SET NOCOUNT ON;
MERGE dbo.Web_CauHinh AS t USING (VALUES
  ('lt_vang_xuweb','1',N'Lật thẻ: 1 vàng trong bảng rơi đồ game = bao nhiêu xu web')
) AS s(Khoa,GiaTri,MoTa) ON t.Khoa=s.Khoa
WHEN NOT MATCHED THEN INSERT(Khoa,GiaTri,MoTa) VALUES(s.Khoa,s.GiaTri,s.MoTa);

BEGIN TRAN;
DELETE FROM dbo.Web_The_Qua WHERE Khoa IS NULL AND TemplateID=0;          -- bo cac dong chi xu web cu (500/1.000/3.000/10.000)
INSERT INTO dbo.Web_The_Qua(Khoa,TemplateID,[Count],ValidDate,StrengthenLevel,IsBind,XuWeb,TrongSo) VALUES
  (NULL,0,1,0,0,1,2000,30),
  (NULL,0,1,0,0,1,5000,20),
  (NULL,0,1,0,0,1,10000,10),
  (NULL,0,1,0,0,1,30000,3),       -- hiem
  (NULL,0,1,0,0,1,100000,1);      -- rat hiem (mat bai VIP)
-- vat pham trong bo chung: Ruong CB Dat vang 15, da dat vang 11560 x?, giu nguyen trong so; dat lai neu chua co
IF NOT EXISTS (SELECT 1 FROM dbo.Web_The_Qua WHERE Khoa IS NULL AND TemplateID=11512) INSERT INTO dbo.Web_The_Qua(Khoa,TemplateID,[Count],ValidDate,IsBind,XuWeb,TrongSo) VALUES(NULL,11512,1,0,1,0,15);
UPDATE dbo.Web_The_Qua SET TrongSo=8 WHERE Khoa IS NULL AND TemplateID=11560;
COMMIT;
SELECT q.TemplateID, q.XuWeb, q.TrongSo, CAST(100.0*q.TrongSo/SUM(q.TrongSo) OVER() AS decimal(5,1)) pct FROM dbo.Web_The_Qua q WHERE q.Khoa IS NULL ORDER BY q.TrongSo DESC;
GO
