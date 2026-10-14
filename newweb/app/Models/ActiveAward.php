<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class ActiveAward extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */
    protected $connection = 'sqlsrv_tank';

    protected $table = 'Active_Award';
    protected $primaryKey = 'ID';
    public $timestamps = false;
//    protected $guarded = ['ActiveID'];
    protected $fillable = ['ActiveID', 'ItemID', 'Count', 'ValidDate', 'StrengthenLevel', 'AttackCompose', 'DefendCompose', 'LuckCompose', 'AgilityCompose', 'Gold', 'Money', 'Sex', 'Mark'];
//     protected $hidden = [];
    // protected $dates = [];
    public $autoincrement = true;
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

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */
    public function combine4Column()
    {
        return $this->AttackCompose.'-'.$this->DefendCompose.'-'.$this->AgilityCompose.'-'.$this->LuckCompose;
    }


    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */
    public function Active()
    {
        return $this->belongsTo(Active::class, 'ActiveID', 'ActiveID');
    }

    public function Item()
    {
        return $this->hasOne(ShopGoods::class, 'TemplateID', 'ItemID');
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    /*
    |--------------------------------------------------------------------------
    | SCOPES
    |--------------------------------------------------------------------------
    */

    /*
    |--------------------------------------------------------------------------
    | ACCESSORS
    |--------------------------------------------------------------------------
    */
//    public function getSexAttribute()
//    {
//        switch($this->Sex) {
//            default: return 'Không'; break;
//            case 1: return 'Nam'; break;
//            case 2: return 'Nữ'; break;
//        }
//    }

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */
}
