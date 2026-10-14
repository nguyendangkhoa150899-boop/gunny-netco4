<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class ClothPropertyTemplate extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'Cloth_Property_Template';
    protected $primaryKey = 'ID';
    public $timestamps = false;
    protected $fillable = ['ID','Sex','Name','Attack','Defend','Agility','Luck','Blood','Damage','HoGiap','Cost','Type','Disabled'];
    public $autoincrement = false;

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

    public function getGuardAttribute()
    {
        return $this->getAttribute('Guard');
    }
}
