<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class ItemStrengthen extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */
    protected $connection = 'sqlsrv_tank';
    protected $table = 'Item_Strengthen';
    protected $primaryKey = 'StrengthenLevel';

    protected $fillable = ['StrengthenLevel','Rock','Random','Rock1','Rock2','Rock3','StoneLevelMin'];
    public $timestamps = false;
    public $incrementing = true;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }
}
