<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class ClothGroupTemplate extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'Cloth_Group_Template';
    protected $primaryKey = 'ItemID';
    public $timestamps = false;
    protected $fillable = ['ID','TemplateID','Sex','Description','Cost','Type','OtherTemplateID'];
    public $autoincrement = false;

    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */
    public function Group()
    {
        return $this->belongsTo(ClothPropertyTemplate::class, 'ID', 'ID');
    }

    public function Item()
    {
        return $this->hasOne(ShopGoods::class, 'TemplateID', 'TemplateID')->withDefault();
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    public function getSexText()
    {
        switch ($this->Sex) {
            case 1: return 'Nam';
            case 2: return 'Nữ';
            case 3: return 'Cả 2';
        }
        return '';
    }

    public function getTypeText()
    {
        switch ($this->Type) {
            case 1: return 'Trang phục';
            case 2: return 'Vũ khí';
        }
        return '';
    }

}
