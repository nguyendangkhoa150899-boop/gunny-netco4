<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class ShopGoodsBox extends Model
{
    protected $connection = 'sqlsrv_tank';
    protected $table = 'Shop_Goods_Box';
    protected $primaryKey = 'ID';
//    protected $guarded = ['ID'];
    protected $fillable = ['ID', 'TemplateId', 'IsSelect', 'IsBind', 'ItemValid', 'ItemCount', 'StrengthenLevel', 'AttackCompose', 'DefendCompose', 'AgilityCompose', 'LuckCompose', 'Random', 'IsTips', 'IsLogs'];
    // protected $hidden = [];
    protected $appends = ['fake'];

    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function BoxItem()
    {
        return $this->hasOne('App\ShopGoods','TemplateID','ID')->withDefault();
    }

    public function ResourceImageColumnForId()
    {
        if(!empty($this->BoxItem)){
            return $this->BoxItem->ResourceImageColumn();
        }
        return '';
    }

    public function Item()
    {
        return $this->hasOne('App\ShopGoods','TemplateID','TemplateId')->withDefault();
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    public function getFakeAttribute()
    {
        return $this->ID.'-'.$this->TemplateId;
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
