<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class PveInfoDropCondiction extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'Drop_Condiction';
    protected $primaryKey = 'DropID';
    public $timestamps = false;
    protected $fillable = ['DropID', 'CondictionType', 'Para1', 'Para2', 'Detail'];
    public $autoincrement = false;
    public $appends = [
        'parentEntryId'
    ];

    public function getText()
    {
        $text = '';
        if (strpos($this->Para2, ',1,') !== false) {
            $text .= 'Thật';
        }
        if (strpos($this->Para2, ',2,') !== false) {
            if (!empty($text)) {
                $text .= ' - ';
            }
            $text .= 'Ảo';
        }
        return $text;
    }

    public function getParentEntryId()
    {
        return $this->parentEntryId;
    }

    public function DropItems()
    {
        return $this->hasMany(PveInfoDropItem::class, 'DropId', 'DropID')->with('Item');
    }
}
