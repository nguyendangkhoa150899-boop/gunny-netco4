<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class PveInfoMissions extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'Mission_Info';
    protected $primaryKey = 'Id';
    public $timestamps = false;
    protected $fillable = ['Id', 'Name', 'TotalCount', 'TotalTurn', 'Script', 'Success', 'Failure', 'Description', 'IncrementDelay', 'Delay', 'Title', 'Param1', 'Param2', 'TakeCard'];
    public $autoincrement = false;

    protected $appends = [
        'parentEntryId',
    ];

    public function getParentEntryId()
    {
        if (property_exists($this, 'parentEntryId')) {
            return $this->parentEntryId;
        }
        return null;
    }

    public function getParentEntryIdAttribute()
    {
        return $this->getParentEntryId();
    }

    public function Condictions()
    {
        return PveInfoDropCondiction::where('Para1', 'like', '%,'.$this->Id.',%')->get();
    }
}
