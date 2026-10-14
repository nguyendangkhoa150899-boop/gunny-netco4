<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class PveInfoTemplates extends Model
{
    use CrudTrait;

    protected $connection = '';

    protected $table = '';
    protected $primaryKey = 'TemplateID';
    public $timestamps = false;
    protected $fillable = [];
    public $autoincrement = false;
    protected $appends = [
        'TemplateID',
        'row_number',
        'parentEntryId',
    ];

    public function Item()
    {
        return $this->hasOne(ShopGoods::class, 'TemplateID', 'TemplateID');
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    public function getParentEntryId()
    {
        return $this->parentEntryId;
    }
}
