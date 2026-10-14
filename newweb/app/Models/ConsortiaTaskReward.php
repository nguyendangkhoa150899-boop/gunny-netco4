<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class ConsortiaTaskReward extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';
    protected $table = 'Consortia_TaskRewards';
    protected $primaryKey = 'ID';

    protected $fillable = ['Lv', 'ItemID', 'Count', 'ValidDate', 'StrengthenLevel', 'AttackCompose', 'DefendCompose', 'LuckCompose', 'AgilityCompose', 'IsBind'];

    public $timestamps = false;
    public $incrementing = true;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }

    public function GuildLevel()
    {
        return $this->belongsTo(ConsortiaLevel::class, 'Lv', 'Level');
    }

    public function combine4Column()
    {
        return $this->AttackCompose.'-'.$this->DefendCompose.'-'.$this->AgilityCompose.'-'.$this->LuckCompose;
    }

    public function Item()
    {
        return $this->hasOne('App\Models\ShopGoods', 'TemplateID', 'ItemID');
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }
}
