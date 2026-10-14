<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class NPCInfo extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */
    protected $connection = 'sqlsrv_tank';
    protected $table = 'NPC_Info';
    protected $primaryKey = 'ID';

    protected $fillable = ['ID','Name','Level','Blood','MoveMin','MoveMax','BaseDamage','BaseGuard','Defence','Agility','Lucky','Attack'];
    public $timestamps = false;
    public $incrementing = true;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }
}
