-- giftcode-nhieu-lan.sql: them kieu code "dung nhieu lan, gioi han tong so luot" (can giftcode-dung-chung.sql da va truoc).
--
-- Quy uoc cot Creator cua dong code goc (UserID=0) trong Db_Tank41.dbo.Active_Number:
--   0        code 1 lan (ban goc game): nguoi dau nhap xong la het
--   -1       moi nguoi 1 lan, khong gioi han so nguoi (giftcode-dung-chung.sql)
--   < -1     nhieu lan: tong so luot = -Creator - 1 (vd -51 = 50 luot), mot nguoi nhap lai duoc, bo qua IsOnly cua su kien
-- Moi lan nhan (kieu -1 va < -1) ghi them 1 dong (AwardID, UserID nguoi nhan, PullDown=1, Creator=0); da dung = so dong UserID<>0.
-- Chay: sqlcmd -S localhost -E -C -b -f 65001 -i giftcode-nhieu-lan.sql   (chay lai an toan)
-- Hoan tac ve ban goc game: xem cuoi giftcode-dung-chung.sql (SP_Active_PullDown_goc).
USE Db_Tank41;
GO
SET NOCOUNT ON;
DECLARE @d nvarchar(max) = OBJECT_DEFINITION(OBJECT_ID('dbo.SP_Active_PullDown'));
IF CHARINDEX(N'@Multi', @d) > 0 BEGIN PRINT N'Da va roi, bo qua.'; RETURN; END
IF CHARINDEX(N'@Shared', @d) = 0 BEGIN RAISERROR(N'Chua va giftcode-dung-chung.sql.',16,1); RETURN; END

DECLARE @dec  nvarchar(200) = N'Declare @Shared Int';
DECLARE @sel  nvarchar(200) = N'@Shared=IIF(Creator=-1,1,0) From  Active_Number Where ActiveID=@ActiveID and AwardID =@AwardID Order By UserID';
DECLARE @only nvarchar(100) = N'If @CanGet=1 ';
DECLARE @ins  nvarchar(100) = N'If @Shared=1 Insert Into Active_Number';
IF CHARINDEX(@dec,@d)=0 OR CHARINDEX(@sel,@d)=0 OR CHARINDEX(@only,@d)=0 OR CHARINDEX(@ins,@d)=0
BEGIN RAISERROR(N'SP khac ban da khao sat, khong va.',16,1); RETURN; END

SET @d = STUFF(@d, CHARINDEX(N'CREATE PROCEDURE', @d), LEN(N'CREATE PROCEDURE'), N'ALTER PROCEDURE');
SET @d = REPLACE(@d, @dec, @dec + NCHAR(13)+NCHAR(10) + N'Declare @Multi Int' + NCHAR(13)+NCHAR(10) + N'Set @Multi=0');
-- doc so luot tu Creator; het luot tra 5 (da dung)
SET @d = REPLACE(@d, @sel,
  N'@Shared=IIF(Creator=-1,1,0),@Multi=IIF(Creator<-1,-Creator-1,0) From  Active_Number Where ActiveID=@ActiveID and AwardID =@AwardID Order By UserID'
  + NCHAR(13)+NCHAR(10) + N'       If @Multi>0 And (Select Count(*) From Active_Number Where ActiveID=@ActiveID And AwardID=@AwardID And UserID<>0)>=@Multi Return 5');
-- code nhieu lan khong bi chan boi IsOnly (1 nguoi nhan lai duoc)
SET @d = REPLACE(@d, @only, N'If @CanGet=1 And @Multi=0 ');
-- moi lan nhan ghi 1 dong, dong goc giu nguyen
SET @d = REPLACE(@d, @ins, N'If @Shared=1 Or @Multi>0 Insert Into Active_Number');
EXEC sp_executesql @d;
PRINT N'Da va SP_Active_PullDown (code nhieu lan: Creator < -1).';
GO
