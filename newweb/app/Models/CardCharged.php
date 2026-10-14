<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class CardCharged extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */
    protected $connection = 'sqlsrv_mem';

    protected $table = 'WSs_LogCardCham';
    protected $primaryKey = 'TaskID';
    public $timestamps = false;
    protected $guarded = false;
    // protected $fillable = [];
    // protected $hidden = [];
    // protected $dates = [];
    public $incrementing = false;

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

    public function getStatusAttribute($value)
    {
        if ($value == 1) {
            return '<span style="color: green">'.trans('cardcharged.success').'</span>';
        }
        if ($value == 0) {
            if ($this->Active == 1) {
                return '<span style="color: blue">'.trans('cardcharged.onhold').'</span>';
            }
        }
        return '<span style="color: red">'.trans('cardcharged.fail').'</span>';
    }

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */
}
