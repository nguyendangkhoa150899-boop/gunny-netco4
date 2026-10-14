<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class Quest extends Model
{
    protected $connection = 'sqlsrv_tank';

    protected $table = 'Quest';
    protected $primaryKey = 'ID';
    protected $fillable = ['ID', 'EndDate', 'RewardGP', 'QuestID', 'Title', 'Detail', 'Objective', 'NeedMinLevel', 'NeedMaxLevel', 'PreQuestID', 'NextQuestID', 'IsOther', 'CanRepeat', 'RepeatInterval', 'RepeatMax', 'RewardGold', 'RewardGiftToken', 'RewardOffer', 'RewardRiches', 'RewardBuffID', 'RewardBuffDate', 'RewardMoney', 'Rands', 'RandDouble', 'TimeMode', 'StartDate', 'MapID', 'AutoEquip', 'RewardMedal', 'Rank', 'StarLev', 'NotMustCoun'];

    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public static function boot() {
        parent::boot();

        static::deleting(function($quest) {
            $quest->QuestGoods()->delete();
            $quest->QuestCondiction()->delete();
        });
    }

    public function QuestCondiction()
    {
        return $this->hasMany('App\QuestCondiction','QuestID','ID');
    }

    public function QuestGoods()
    {
        return $this->hasMany('App\QuestGoods','QuestID','ID');
    }

    public function QuestType()
    {
        switch ((int) $this->QuestID){
            case 0:
                return "Nhiệm vụ chủ tuyến";
            case 1:
                return "Nhiệm vụ phụ";
            case 2:
                return "Nhiệm vụ hằng ngày";
            case 3:
                return "Nhiệm vụ sự kiện";
            case 4:
                return "Nhiệm vụ VIP";
            case 6:
                return "Nhiệm vụ sử thi";

        }
    }


}
