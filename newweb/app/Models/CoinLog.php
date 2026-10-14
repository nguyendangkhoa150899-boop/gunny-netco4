<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class CoinLog extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */
    protected $connection = 'sqlsrv';
    protected $table = 'admin_coin_logs';
    // protected $primaryKey = 'id';
    // public $timestamps = false;
    protected $guarded = ['id'];
    // protected $fillable = [];
    // protected $hidden = [];
    // protected $dates = [];
    public $timestamps = false;

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
    public function User()
    {
        return $this->hasOne('App\User', 'id', 'OwnerActionId');
    }

    public function Member()
    {
        return $this->hasOne('App\Models\Member', 'Email', 'MemberUserName');
    }

    public function CoinLogMember()
    {
        return $this->hasOne('App\Models\CoinLogMember', 'Email', 'MemberUserName');
    }

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

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */

    public function setTimeAttribute($value)
    {
        $this->attributes['Time'] = date('Y-m-d H:i:s');
    }
}
