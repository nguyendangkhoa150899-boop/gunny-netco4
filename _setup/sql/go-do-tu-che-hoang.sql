-- 15/10/2026: hoang (UserID 243) ket man hinh giay khi vao game.
-- Nguyen nhan: 17 mon 352xxxxx (do admin cu tu che, client KHONG co trong TemplateAlllist.xml) tu gui qua "Gui qua test"
-- -> client loi trong HallStateView.enter, sanh khong dung duoc. Code chan tu commit cbc049b (VatPham::trongClient).
-- Script: sao luu 17 dong roi danh dau IsExist=0 (khong xoa). CHAY KHI HOANG DA THOAT HAN (dong launcher), neu khong Road
-- dang giu tui trong RAM se ghi de lai.
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i C:\Gunny92\_setup\sql\go-do-tu-che-hoang.sql
-- Hoan tac: UPDATE g SET IsExist=1 FROM Db_Tank41.dbo.Sys_Users_Goods g JOIN Db_Tank41.dbo.bak20261015_hoang_goods b ON b.ItemID=g.ItemID
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF EXISTS (SELECT 1 FROM Db_Tank41.dbo.Sys_Users_Detail WHERE UserID=243 AND State=1)
BEGIN
  RAISERROR(N'hoang (243) dang State=1: dong launcher cua hoang, cho 1 phut roi chay lai. Neu chac chan da thoat ma van 1 thi admin > Reset trang thai.', 16, 1);
  RETURN;
END

BEGIN TRAN;

IF OBJECT_ID('Db_Tank41.dbo.bak20261015_hoang_goods') IS NULL
  SELECT * INTO Db_Tank41.dbo.bak20261015_hoang_goods
  FROM Db_Tank41.dbo.Sys_Users_Goods
  WHERE UserID=243 AND IsExist=1 AND TemplateID IN
    (35210457,35210462,35210552,35210553,35210976,35211013,35211115,35211168,35211216,35211275,35211356,35211572,35211624,35211720,35211725);

UPDATE g SET IsExist=0
FROM Db_Tank41.dbo.Sys_Users_Goods g
JOIN Db_Tank41.dbo.bak20261015_hoang_goods b ON b.ItemID=g.ItemID
WHERE g.UserID=243 AND g.IsExist=1;

PRINT N'Da go ' + CAST(@@ROWCOUNT AS nvarchar(10)) + N' mon (mong doi 17).';
COMMIT;
