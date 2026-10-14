<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class EventRewardGoods extends Model
{
    protected $connection = 'sqlsrv_tank';
    protected $table = 'Event_Reward_Goods';
    protected $primaryKey = 'ActivityType';

    protected $fillable = ['ActivityType', 'SubActivityType', 'TemplateId', 'StrengthLevel', 'AttackCompose', 'DefendCompose', 'LuckCompose', 'AgilityCompose', 'IsBind', 'ValidDate', 'Count'];

    protected $appends = ['fake'];

    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function Item()
    {
        return $this->hasOne('App\ShopGoods', 'TemplateID', 'TemplateId');
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    public function getFakeAttribute()
    {
        return $this->ActivityType.'-'.$this->SubActivityType.'-'.$this->TemplateId;
    }

    /**
     * @param string $primaryKey
     */
    public function setPrimaryKey(string $primaryKey): void
    {
        $this->primaryKey = $primaryKey;
    }

    /**
     * @return string
     */
    public function getPrimaryKey(): string
    {
        return $this->primaryKey;
    }

    public function getActivityTypeText()
    {
        switch ($this->ActivityType){
            case 1:
                return 'Mốc level ';
            case 2:
                return 'Mốc cường cmn hoá';
            case 3:
                return 'Mốc tiêu xu';
            case 4:
                return 'Mốc nạp xu';
            case 5:
                return 'Mốc level VIP';
            case 6:
                return 'Mốc quà LC';
            case 7:
                return 'Nạp xu đặc biệt';
            case 8:
                return 'Tiêu xu đặc biệt';
            case 9:
                return 'Nạp lần đầu';
        }
    }
}
