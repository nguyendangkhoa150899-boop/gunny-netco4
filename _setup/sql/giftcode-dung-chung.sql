-- giftcode-dung-chung.sql: them "code dung chung" cho giftcode (nhieu nguoi nhap cung 1 ten code, moi nguoi 1 lan).
--
-- Ban goc SP_Active_PullDown (HasKey=1/4): danh dau da dung bang
--   UPDATE Active_Number SET PullDown=1 ... WHERE AwardID=@AwardID   -> 1 ten code chi dung duoc 1 lan toan server.
-- Ban nay: dong code co Creator = -1 la "dung chung":
--   * dong goc (UserID=0) khong bi khoa;
--   * moi nguoi nhan thi ghi them 1 dong (AwardID, UserID=nguoi do) -> nhap lan 2 tra ma 5 (da dung);
--   * code thuong (Creator khac -1) giu nguyen hanh vi cu.
-- Sua bang REPLACE tren OBJECT_DEFINITION ngay trong SQL Server (giu nguyen chu Trung/Unicode cua SP goc).
-- Sao luu ban goc thanh SP_Active_PullDown_goc (chi lan dau). Hoan tac: xem cuoi file.
USE Db_Tank41;
GO
SET NOCOUNT ON;
DECLARE @d nvarchar(max) = OBJECT_DEFINITION(OBJECT_ID('dbo.SP_Active_PullDown'));
IF CHARINDEX(N'@Shared', @d) > 0 BEGIN PRINT N'Da va roi, bo qua.'; RETURN; END

DECLARE @sel nvarchar(400) = N'Select @ActiveID=Isnull(ActiveID,0),@PullDown=Isnull(PullDown,0),@Mark=Mark From  Active_Number Where ActiveID=@ActiveID and AwardID =@AwardID';
DECLARE @upd nvarchar(400) = N'Update Active_Number Set PullDown=1,[GetDate]=getdate(),UserID=@UserID Where AwardID = @AwardID';
DECLARE @dec nvarchar(100) = N'Declare @Mark Int';
IF CHARINDEX(@sel,@d)=0 OR CHARINDEX(@upd,@d)=0 OR CHARINDEX(@dec,@d)=0 BEGIN RAISERROR(N'SP khac ban da khao sat, khong va.',16,1); RETURN; END

-- sao luu ban goc
IF OBJECT_ID('dbo.SP_Active_PullDown_goc') IS NULL
BEGIN
  DECLARE @b nvarchar(max) = STUFF(@d, CHARINDEX(N'[SP_Active_PullDown]', @d), LEN(N'[SP_Active_PullDown]'), N'[SP_Active_PullDown_goc]');
  EXEC sp_executesql @b;
END

SET @d = STUFF(@d, CHARINDEX(N'CREATE PROCEDURE', @d), LEN(N'CREATE PROCEDURE'), N'ALTER PROCEDURE');
SET @d = REPLACE(@d, @dec, @dec + NCHAR(13)+NCHAR(10) + N'Declare @Shared Int' + NCHAR(13)+NCHAR(10) + N'Set @Shared=0');
SET @d = REPLACE(@d, @sel,
  N'Select TOP 1 @ActiveID=Isnull(ActiveID,0),@PullDown=Isnull(PullDown,0),@Mark=Mark,@Shared=IIF(Creator=-1,1,0) From  Active_Number Where ActiveID=@ActiveID and AwardID =@AwardID Order By UserID'
  + NCHAR(13)+NCHAR(10) + N'       If @Shared=1 And Exists(Select 1 From Active_Number Where ActiveID=@ActiveID And AwardID=@AwardID And UserID=@UserID) Return 5');
SET @d = REPLACE(@d, @upd,
  N'If @Shared=1 Insert Into Active_Number(AwardID,ActiveID,PullDown,[GetDate],UserID,Mark,Creator) Values(@AwardID,@ActiveID,1,Getdate(),@UserID,@Mark,0)'
  + NCHAR(13)+NCHAR(10) + N'       Else ' + @upd);
EXEC sp_executesql @d;
PRINT N'Da va SP_Active_PullDown (code dung chung: Creator = -1).';
GO
-- Hoan tac:
--   DECLARE @g nvarchar(max)=OBJECT_DEFINITION(OBJECT_ID('dbo.SP_Active_PullDown_goc'));
--   SET @g=STUFF(@g,CHARINDEX(N'CREATE PROCEDURE',@g),LEN(N'CREATE PROCEDURE'),N'ALTER PROCEDURE');
--   SET @g=STUFF(@g,CHARINDEX(N'[SP_Active_PullDown_goc]',@g),LEN(N'[SP_Active_PullDown_goc]'),N'[SP_Active_PullDown]');
--   EXEC sp_executesql @g;
