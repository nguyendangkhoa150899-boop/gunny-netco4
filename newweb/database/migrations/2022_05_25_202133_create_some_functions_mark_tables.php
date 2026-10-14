<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class CreateSomeFunctionsMarkTables extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::connection('sqlsrv_tank41')->beginTransaction();
        Schema::connection('sqlsrv_tank41')->table('QuestData', function (Blueprint $table) {
            $table->boolean('isFinishHalf')->default(0);
            $table->boolean('isDoubleAward')->default(0);
            $table->boolean('isFinishNow')->default(0);
        });
        DB::connection('sqlsrv_tank41')->statement('ALTER  PROCEDURE [dbo].[SP_QuestData_Add]
 @UserId int,
 @QuestID int,
 @CompletedDate DateTime,
 @IsComplete bit,
 @Condition1 int,
 @Condition2 int,
 @Condition3 int,
 @Condition4 int,
 @IsExist bit,
 @RepeatFinish int,
 @RandDobule int,
 @isFinishHalf bit,
 @isDoubleAward bit,
 @isFinishNow bit
as
declare
	@temp int,
	@tempComplete bit,
	@canRepeat bit
select @temp = count(*)  from QuestData where UserId=@UserId and QuestID=@QuestID
if @temp=0
   begin
     INSERT INTO QuestData(UserId, QuestID,CompletedDate,IsComplete,Condition1,Condition2,Condition3,Condition4,IsExist,RepeatFinish,RandDobule,isFinishHalf,isDoubleAward,isFinishNow)
     VALUES(@UserId, @QuestID,@CompletedDate,@IsComplete,@Condition1,@Condition2,@Condition3,@Condition4,@IsExist,@RepeatFinish,@RandDobule,@isFinishHalf,@isDoubleAward,@isFinishNow)
 end
 else
   begin
	   select @tempComplete=IsComplete from QuestData where UserId=@UserId and QuestID=@QuestID
	   select @canRepeat=CanRepeat from [Db_Tank].[dbo].Quest where ID=@QuestID

	   if @tempComplete=0 OR @canRepeat=1
		begin
		 UPDATE QuestData Set CompletedDate= @CompletedDate,IsComplete=@IsComplete,Condition1=@Condition1,Condition2=@Condition2,Condition3=@Condition3,Condition4=@Condition4,IsExist=@IsExist,RepeatFinish=@RepeatFinish,RandDobule=@RandDobule,isFinishHalf=@isFinishHalf,isDoubleAward=@isDoubleAward,isFinishNow=@isFinishNow  WHERE UserId=@UserId and QuestID=@QuestID
		 end
   end;');
        DB::connection('sqlsrv_tank41')->commit();
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::connection('sqlsrv_tank41')->beginTransaction();
        Schema::connection('sqlsrv_tank41')->table('QuestData', function (Blueprint $table) {
            $table->dropColumn(['isFinishHalf', 'isDoubleAward', 'isFinishNow']);
        });
        DB::connection('sqlsrv_tank41')->statement('ALTER  PROCEDURE [dbo].[SP_QuestData_Add]
 @UserId int,
 @QuestID int,
 @CompletedDate DateTime,
 @IsComplete bit,
 @Condition1 int,
 @Condition2 int,
 @Condition3 int,
 @Condition4 int,
 @IsExist bit,
 @RepeatFinish int,
 @RandDobule int
as
declare
	@temp int,
	@tempComplete bit,
	@canRepeat bit
select @temp = count(*)  from QuestData where UserId=@UserId and QuestID=@QuestID
if @temp=0
   begin
     INSERT INTO QuestData(UserId, QuestID,CompletedDate,IsComplete,Condition1,Condition2,Condition3,Condition4,IsExist,RepeatFinish,RandDobule)
     VALUES(@UserId, @QuestID,@CompletedDate,@IsComplete,@Condition1,@Condition2,@Condition3,@Condition4,@IsExist,@RepeatFinish,@RandDobule)
 end
 else
   begin
	   select @tempComplete=IsComplete from QuestData where UserId=@UserId and QuestID=@QuestID
	   select @canRepeat=CanRepeat from [Db_Tank].[dbo].Quest where ID=@QuestID

	   if @tempComplete=0 OR @canRepeat=1
		begin
		 UPDATE QuestData Set CompletedDate= @CompletedDate,IsComplete=@IsComplete,Condition1=@Condition1,Condition2=@Condition2,Condition3=@Condition3,Condition4=@Condition4,IsExist=@IsExist,RepeatFinish=@RepeatFinish,RandDobule=@RandDobule  WHERE UserId=@UserId and QuestID=@QuestID
		 end
   end;');
        DB::connection('sqlsrv_tank41')->commit();
    }
}
