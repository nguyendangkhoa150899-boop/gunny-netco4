<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class ShopGoodsBox extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */
    protected $connection = 'sqlsrv_tank';

    protected $table = 'Shop_Goods_Box';
    protected $primaryKey = 'AI_ID';
    public $timestamps = false;
    protected $fillable = ['ID', 'TemplateId', 'IsSelect', 'IsBind', 'ItemValid', 'ItemCount', 'StrengthenLevel', 'AttackCompose', 'DefendCompose', 'AgilityCompose', 'LuckCompose', 'Random', 'IsTips', 'IsLogs'];
    public $incrementing = true;

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */


    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */

    public function Item()
    {
        return $this->hasOne(ShopGoods::class, 'TemplateID', 'TemplateId')->withDefault();
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    public function ItemName()
    {
        return $this->Item->Name;
    }

    public function combine4Column()
    {
        return $this->AttackCompose.'-'.$this->DefendCompose.'-'.$this->AgilityCompose.'-'.$this->LuckCompose;
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

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */
}
