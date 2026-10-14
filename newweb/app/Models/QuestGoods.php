<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class QuestGoods extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'Quest_Goods';
    protected $primaryKey = 'ID';
    protected $fillable = ['QuestID', 'RewardItemID', 'IsSelect', 'RewardItemValid', 'RewardItemCount', 'StrengthenLevel', 'AttackCompose', 'DefendCompose', 'AgilityCompose', 'LuckCompose', 'IsCount', 'IsBind'];
    public $timestamps = false;
    public $incrementing = true;
    protected $appends = ['RewardImage'];

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }

    public function QuestCondiction()
    {
        return $this->belongsTo('App\Models\QuestCondiction', 'QuestID', 'QuestID');
    }

    public function Item()
    {
        return $this->belongsTo('App\Models\ShopGoods', 'RewardItemID', 'TemplateID');
    }

    public function Quest()
    {
        return $this->belongsTo('App\Models\Quest', 'QuestID', 'ID');
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    public function getFakeKeyAttribute()
    {
        return $this->QuestID.'-'.$this->RewardItemID;
    }

    public function getRewardImageAttribute()
    {
        return $this->Item->ResourceImageColumnForQuest();
    }

    public function combine4Column()
    {
        return $this->AttackCompose.'-'.$this->DefendCompose.'-'.$this->AgilityCompose.'-'.$this->LuckCompose;
    }
}
