<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class EventRewardGoods extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';
    protected $table = 'Event_Reward_Goods';
    protected $primaryKey = 'ID';

    protected $fillable = ['ID', 'ActivityType', 'SubActivityType', 'TemplateId', 'StrengthLevel', 'AttackCompose', 'DefendCompose', 'LuckCompose', 'AgilityCompose', 'IsBind', 'ValidDate', 'Count'];

    public $timestamps = false;
    public $incrementing = true;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }

    public function Item()
    {
        return $this->hasOne('App\Models\ShopGoods', 'TemplateID', 'TemplateId');
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    public function Activity()
    {
        return $this->belongsTo(EventReward::class, 'ActivityType', 'ID');
    }

    public function combine4Column()
    {
        return $this->AttackCompose.'-'.$this->DefendCompose.'-'.$this->AgilityCompose.'-'.$this->LuckCompose;
    }

    public function getParentEntryId()
    {
        return $this->SubActivityType;
    }
}
