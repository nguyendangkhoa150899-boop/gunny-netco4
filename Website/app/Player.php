<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Player extends Model
{

    protected $connection = 'sqlsrv_tank41';

    protected $table = 'Sys_Users_Detail';

    protected $primaryKey = 'UserID';

    protected $fillable = ['UserID','UserName','Password','NickName','Date','IsConsortia','ConsortiaID','Sex','Win','Total','Escape','GP','Honor','Gold','Money','MoneyLock','Style','Colors','Hide','Grade','State','IsFirst','Repute','LastDate','ChargeDate','ExpendDate','ActiveIP','ForbidDate','Skin','Offer','IsExist','ReputeOffer','LastDateSecond','LastDateThird','LoginCount','OnlineTime','AntiAddiction','AntiDate','RichesOffer','RichesRob','UseOffer','LastDayGP','AddDayGP','LastWeekGP','AddWeekGP','LastDayOffer','AddDayOffer','LastWeekOffer','AddWeekOffer','CheckCount','Site','IsMarried','SpouseID','SpouseName','MarryInfoID','DayLoginCount','ForbidReason','IsCreatedMarryRoom','PasswordTwo','SelfMarryRoomID','IsGotRing','ServerName','Rename','Nimbus','LastAward','GiftToken','PvePermission','FightLabPermission','FightPower','AnswerSite','LastAuncherAward','WeaklessGuildProgressStr','AchievementPoint','IsShowConsortia','OptionOnOff','badgeID','IsRecharged','IsGetAward','MoneyPlus','evolutionGrade','evolutionExp','hardCurrency','EliteScore','CanSentMoney','apprenticeshipState','masterID','masterOrApprentices','graduatesCount','honourOfMaster','freezesDate','ShopFinallyGottenTime','charmGP','Medal','ChatCount','SpaPubGoldRoomLimit','LastSpaDate','IsInSpaPubGoldToday','IsInSpaPubMoneyToday','LastWeekly','LastWeeklyVersion','IsOldPlayer','Score','isOldPlayerHasValidEquitAtLogin','badLuckNumber','luckyNum','lastLuckyNumDate','lastLuckNum','NewDay','BoxGetDate','AlreadyGetBox','BoxProgression','GetBoxLevel','AddWeekLeagueScore','WeekLeagueRanking','SpaPubMoneyRoomLimit','LastGetEgg','IsFistGetPet','LastRefreshPet','petScore','accumulativeLoginDays','accumulativeAwardDays','honorId','referenceUserId','LoginDevice','TotalCharged'];

    protected $hidden = ['QuestSite'];

    public $timestamps = false;


    public function launcherLoggedin()
    {
        $this->LoginDevice = 1;
        return $this->save();
    }
}
