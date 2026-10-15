-- tao-nhan-vat-max.sql: server TEST, nhan vat moi tao ra la cap toi da + nhieu tai nguyen.
-- Chay 1 lan tren VPS:  sqlcmd -S localhost -E -C -b -i tao-nhan-vat-max.sql
--
-- Ban goc ghi cung GP=1, Grade=1, Gold=0, Money=0 (bo qua DefaultGold/DefaultMoney cua Request/Web.config).
-- Ban nay:
--   * Cap = cap cao nhat trong Db_Tank.dbo.LevelInfo (server lay MaxLevel = so dong bang nay, hien la 30).
--     GP = GP cua cap do -> LevelMgr.GetLevel(GP) tra ve cap toi da.
--   * Gold  = @Gold  (Request/Web.config appSettings DefaultGold)
--   * Money = @Money (Request/Web.config appSettings DefaultMoney) = Xu
--   * MoneyLock (Xu khoa) = @Money
-- Muon doi so luong tai nguyen: sua DefaultGold/DefaultMoney trong Request/Web.config (git) roi deploy.
-- Muon tra ve ban goc: bo cac dong co danh dau [TEST].
USE Db_Tank41;
GO
ALTER PROCEDURE [dbo].[SP_Users_Active]
@UserID int out,
@Attack int,
@Colors Nvarchar(200),
@ConsortiaID int,
@Defence int,
@Gold int,
@GP int,
@Grade int,
@Luck int,
@Money int,
@Style Nvarchar(200),
@Agility int,
@State int,
@UserName Nvarchar(200),
@PassWord Nvarchar(200),
@Sex bit,
@Hide int,
@ActiveIP Nvarchar(50),
@Skin Nvarchar(500),
@Site nvarchar(200)
as
declare @count int
-- [TEST] cap toi da thay cho GP=1/Grade=1
select top 1 @Grade = Grade, @GP = GP from Db_Tank.dbo.LevelInfo order by Grade desc
set @GP = isnull(@GP,1)
set @Grade = isnull(@Grade,1)
select @count= isnull(count(*),0) from Sys_Users_Detail where UserName = @UserName
if @count <> 0
begin
  return 1
end
set xact_abort on
begin tran
-- [TEST] Gold/Money/MoneyLock lay tu tham so thay cho 0
insert into Sys_Users_Detail(UserName,[PassWord],NickName,[Date],IsConsortia,ConsortiaID,Sex,Win,Total,[Escape],GP,Honor,Gold,[Money],MoneyLock,Style,Colors,Hide,LastDate,Grade,State,IsFirst,Repute,ActiveIP,IsExist,Skin,Site)
values(@UserName,@PassWord,'',getdate(),0,0,@Sex,0,0,0,@GP,'',isnull(@Gold,0),isnull(@Money,0),isnull(@Money,0),@Style,@Colors,@Hide,GETDATE(),@Grade,@State,0,0,@ActiveIP,1,@Skin,@Site)
if @@error <> 0
begin
  rollback tran
  return @@error
end
select @UserID = isnull(@@IDENTITY ,0)
if @UserID = 0
begin
  rollback tran
  return 1
end
insert into Sys_Users_Fight(UserID,Attack,Defence,Luck,Agility,[Delay],Honor,Map,Directory,IsExist)
values(@UserID,@Attack,@Defence,@Luck,@Agility,0,'','','',1)
if @@error<>0
begin
  rollback tran
  return @@error
end
SET IDENTITY_INSERT [dbo].[Sys_VIP_Info] ON
INSERT INTO [dbo].[Sys_VIP_Info]([UserID])
VALUES(@UserID)
if @@error<>0
begin
  rollback tran
  return @@error
end
INSERT INTO [dbo].[Sys_Users_Texp]([UserID])
VALUES(@UserID)
if @@error<>0
begin
  rollback tran
  return @@error
end
insert into [dbo].[DailyLogList]([UserID])
values(@UserID)
if @@error<>0
begin
  rollback tran
  return @@error
end
commit tran
set xact_abort off
return 0
GO
