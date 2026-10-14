<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class PveInfoDropItem extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'Drop_Item';
    protected $primaryKey = 'Id';
    public $timestamps = false;
    protected $fillable = ['DropId', 'ItemId', 'ValueDate', 'IsBind', 'Random', 'BeginData', 'EndData', 'IsTips', 'IsLogs'];
    public $autoincrement = true;

    public function Item()
    {
        return $this->hasOne(ShopGoods::class, 'TemplateID', 'ItemId');
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    public function DropCondiction()
    {
        return $this->belongsTo(PveInfoDropCondiction::class, 'DropId', 'DropID');
    }

    public function getParentEntryId()
    {
        return $this->DropId;
    }
}
