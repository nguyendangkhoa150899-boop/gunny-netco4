<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class ActiveAward extends Model
{
    protected $connection = 'sqlsrv_tank';

    protected $table = 'Active_Award';
    protected $primaryKey = 'ID';
//    protected $guarded = ['ActiveID'];
    protected $fillable = ['ActiveID', 'ItemID', 'Count', 'ValidDate', 'StrengthenLevel', 'AttackCompose', 'DefendCompose', 'LuckCompose', 'AgilityCompose', 'Gold', 'Money', 'Sex', 'Mark'];
//     protected $hidden = [];
    // protected $dates = [];
    public $autoincrement = true;
    public $timestamps = false;

    protected $attributes = [
        'ValidDate' => 0,
        'StrengthenLevel' => 0,
        'AttackCompose' => 0,
        'DefendCompose' => 0,
        'LuckCompose' => 0,
        'AgilityCompose' => 0,
        'Gold' => 0,
        'Money' => 0,
        'Sex' => 0,
        'Mark' => 0,
    ];

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function combine4Column()
    {
        return $this->AttackCompose.'-'.$this->DefendCompose.'-'.$this->AgilityCompose.'-'.$this->LuckCompose;
    }

    public function Active()
    {
        return $this->belongsTo('App\Active', 'ActiveID', 'ActiveID');
    }

    public function Item()
    {
        return $this->hasOne('App\ShopGoods', 'TemplateID', 'ItemID');
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }
}
