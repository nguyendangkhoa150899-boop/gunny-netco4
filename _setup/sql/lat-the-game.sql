-- lat-the-game.sql: lat the tren web dung BANG ROI DO CUA GAME (Drop_Condiction loai 5 + Drop_Item) va thuat toan cua PVEGame.TakeCard.
-- lt_nguon: 'game' = bang roi do game (khong co thi bo qua web), 'web' = chi bo qua web (Web_The_Qua).
-- lt_solat: so la duoc lat moi luot (game goc: thang ai giua 1 la, thang boss cuoi 2 la; server nay chon 3).
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i lat-the-game.sql   (chay lai an toan)
USE Db_Member;
GO
SET NOCOUNT ON;
MERGE dbo.Web_CauHinh AS t USING (VALUES
  ('lt_nguon','game',N'Lật thẻ: game = quà theo bảng rơi đồ của game (y hệt lật bài trong game), web = chỉ dùng bộ quà web'),
  ('lt_solat','3',N'Lật thẻ: số lá được lật mỗi lượt (game gốc: boss cuối 2 lá)')
) AS s(Khoa,GiaTri,MoTa) ON t.Khoa=s.Khoa
WHEN NOT MATCHED THEN INSERT(Khoa,GiaTri,MoTa) VALUES(s.Khoa,s.GiaTri,s.MoTa);
PRINT N'Da cau hinh lat the theo game.';
GO
