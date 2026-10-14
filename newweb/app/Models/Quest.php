<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class Quest extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'Quest';
    protected $primaryKey = 'ID';
    protected $fillable = ['ID', 'EndDate', 'RewardGP', 'QuestID', 'Title', 'Detail', 'NeedMinLevel', 'NeedMaxLevel', 'PreQuestID', 'NextQuestID', 'IsOther', 'CanRepeat', 'RepeatInterval', 'RepeatMax', 'RewardGold', 'RewardGiftToken', 'RewardOffer', 'RewardRiches', 'RewardBuffID', 'RewardBuffDate', 'RewardMoney', 'Rands', 'RandDouble', 'TimeMode', 'StartDate', 'MapID', 'AutoEquip', 'RewardMedal', 'Rank', 'StarLev', 'NotMustCount', 'CanDoubleAward', 'DoubleAwardPrice', 'CanFinishHalf', 'FinishHalfPrice', 'CanFinishNow', 'FinishNowPrice'];

    public $timestamps = false;
    public $incrementing = false;

    protected $attributes = [
        'Objective' => '',
    ];

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }

//    public static function boot() {
//        parent::boot();
//
//        static::deleting(function($quest) {
//            $quest->QuestGoods()->delete();
//            $quest->QuestCondiction()->delete();
//        });
//    }

    public function QuestCondiction()
    {
//        return $this->hasMany(QuestCondiction::class,'QuestID','ID');
    }

    public function QuestGoods()
    {
//        return $this->hasMany(QuestGoods::class,'QuestID','ID');
    }

    public function QuestType()
    {
        $questID = (int)$this->QuestID;
        $questTypes = self::QuestTypes();
        return !empty($questTypes[$questID])?$questTypes[$questID]:'';
    }

    public function PreQuest()
    {
        $prequests = [];
        if (!empty($this->PreQuestID)) {
            $prequests = explode(',', $this->PreQuestID);
            $prequests = array_filter($prequests);
        }
        if (!empty($prequests)) {
            return self::whereIn('ID', $prequests)->get();
        }
        return null;
    }

    public function NextQuest()
    {
        $nextquests = [];
        if (!empty($this->NextQuestID)) {
            $nextquests = explode(',', $this->NextQuestID);
            $nextquests = array_filter($nextquests);
        }
        if (!empty($nextquests)) {
            return self::whereIn('ID', $nextquests)->get();
        }
        return null;
    }

    public static function QuestTypes()
    {
        return [
            0 => "Nhiệm vụ chủ tuyến",
            1 => "Nhiệm vụ phụ",
            2 => "Nhiệm vụ hằng ngày",
            3 => "Nhiệm vụ sự kiện",
            4 => "Nhiệm vụ VIP",
            6 => "Nhiệm vụ sử thi",
        ];
    }

    public function getStartDateAttribute($value)
    {
        return date('Y-m-d', strtotime($value));
    }

    public function getEndDateAttribute($value)
    {
        return date('Y-m-d', strtotime($value));
    }

//    public function setStartDateAttribute($value)
//    {
//        return date('Y-m-d 00:00:00.000', strtotime($value));
//    }
//
//    public function setEndDateAttribute($value)
//    {
//        return date('Y-m-d 23:59:59.000', strtotime($value));
//    }
}
