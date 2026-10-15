-- giftcode-nhieu-lan.sql: them kieu code "dung nhieu lan, gioi han tong so luot" (can giftcode-dung-chung.sql da va truoc).
--
-- Quy uoc cot Creator cua dong code goc (UserID=0) trong Db_Tank41.dbo.Active_Number:
--   0        code 1 lan (ban goc game): nguoi dau nhap xong la het
--   -1       moi nguoi 1 lan, khong gioi han so nguoi (giftcode-dung-chung.sql)
--   < -1     nhieu lan: tong so luot = -Creator - 1 (vd -51 = 50 luot), mot nguoi nhap lai duoc; kieu -1 va < -1 khong bi IsOnly cua su kien chan
-- Khoa chinh bang la (AwardID, UserID) nen moi nguoi chi co 1 dong nhan cho moi code:
--   kieu -1: dong nhan Creator=0; kieu < -1: Creator cua dong nhan = so lan nguoi do da nhan (nhan lai thi +1).
--   Da dung (tong luot) = SUM(IIF(Creator>0,Creator,1)) cac dong UserID<>0.
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
  + NCHAR(13)+NCHAR(10) + N'       If @Multi>0 And (Select IsNull(Sum(IIF(Creator>0,Creator,1)),0) From Active_Number Where ActiveID=@ActiveID And AwardID=@AwardID And UserID<>0)>=@Multi Return 5');
-- IsOnly cua su kien (1 nguoi chi nhan 1 code trong su kien) chi ap cho code 1 lan kieu cu; code -1 / < -1 tu quan luot theo tung code
SET @d = REPLACE(@d, @only, N'If @CanGet=1 And @Multi=0 And @Shared=0 ');
-- nhan lan dau: them 1 dong (Creator=1 neu nhieu lan); nhan lai (nhieu lan): tang Creator cua dong do. Dong goc giu nguyen.
DECLARE @val nvarchar(100) = N'Values(@AwardID,@ActiveID,1,Getdate(),@UserID,@Mark,0)';
IF CHARINDEX(@val,@d)=0 BEGIN RAISERROR(N'SP khac ban da khao sat, khong va.',16,1); RETURN; END
SET @d = REPLACE(@d, @val, N'Values(@AwardID,@ActiveID,1,Getdate(),@UserID,@Mark,IIF(@Multi>0,1,0))');
SET @d = REPLACE(@d, @ins,
  N'If @Multi>0 And Exists(Select 1 From Active_Number Where AwardID=@AwardID And UserID=@UserID) Update Active_Number Set Creator=IIF(Creator>0,Creator,1)+1,[GetDate]=Getdate() Where AwardID=@AwardID And UserID=@UserID'
  + NCHAR(13)+NCHAR(10) + N'       Else If @Shared=1 Or @Multi>0 Insert Into Active_Number');
EXEC sp_executesql @d;
PRINT N'Da va SP_Active_PullDown (code nhieu lan: Creator < -1).';
GO
