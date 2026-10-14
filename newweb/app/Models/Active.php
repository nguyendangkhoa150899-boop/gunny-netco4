<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class Active extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */
    protected $connection = 'sqlsrv_tank';

    protected $table = 'Active';
    protected $primaryKey = 'ActiveID';
    public $timestamps = false;
//    protected $guarded = ['ActiveID'];
    protected $fillable = ['ActiveID', 'Title', 'Description', 'Content', 'AwardContent', 'HasKey', 'StartDate', 'EndDate', 'IsOnly', 'Type', 'ActionTimeContent', 'IsAdvance', 'GoodsExchangeTypes', 'GoodsExchangeNum', 'limitType', 'limitValue', 'IsShow', 'ActiveType', 'IconID', 'CanGetCode', 'CodePrefix'];
//     protected $hidden = [];
    // protected $dates = [];
    public $incrementing = false;
    protected $attributes = [
        'HasKey' => 1,
        'IsAdvance' => 0,
        'GoodsExchangeTypes' => null,
        'GoodsExchangeNum' => null,
        'limitType' => null,
        'limitValue' => null,
        'IsShow' => 0,
        'ActiveType' => 0,
        'IconID' => 0,
    ];

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */
    public function createActiveNumberForCreator($prefix = '', $creator = 0)
    {
        $code = createGiftcode('YES'.$this->ActiveID, 15);
        $code = $prefix.$code;
        $activeNumber = new ActiveNumber();
        $activeNumber->AwardID = $code;
        $activeNumber->ActiveID = $this->ActiveID;
        $activeNumber->PullDown = false;
        $activeNumber->UserID = 0;
        $activeNumber->Mark = 0;
        $activeNumber->Creator = $creator;
        if ($activeNumber->save()) {
            return $activeNumber;
        }
        return null;
    }


    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */
    public function ActiveNumber()
    {
        return $this->hasMany(ActiveNumber::class, 'ActiveID', 'ActiveID');
    }

    public function ActiveAward()
    {
        return $this->hasMany(ActiveAward::class, 'ActiveID', 'ActiveID');
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
}
