<?php

namespace App;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class QuestGoods extends Model
{
    protected $connection = 'sqlsrv_tank';

    protected $table = 'Quest_Goods';
    protected $primaryKey = 'QuestID';
    protected $fillable = ['QuestID', 'RewardItemID', 'IsSelect', 'RewardItemValid', 'RewardItemCount', 'StrengthenLevel', 'AttackCompose', 'DefendCompose', 'AgilityCompose', 'LuckCompose', 'IsCount', 'IsBind'];
    public $timestamps = false;
    public $incrementing = false;
    protected $appends = ['fake', 'RewardImage'];

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function QuestCondiction()
    {
        return $this->belongsTo('App\QuestCondiction', 'QuestID', 'QuestID');
    }

    public function Item()
    {
        return $this->hasOne('App\ShopGoods', 'TemplateID', 'RewardItemID');
    }

    public function Quest()
    {
        return $this->hasOne('App\Quest', 'ID', 'QuestID');
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    public function getFakeAttribute()
    {
        return $this->QuestID.'-'.$this->RewardItemID;
    }

    public function getRewardImageAttribute()
    {
        return $this->Item->ResourceImageColumnForQuest();
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
}
