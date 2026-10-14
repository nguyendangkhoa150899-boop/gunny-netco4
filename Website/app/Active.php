<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class Active extends Model
{
    /*
    * THIS TABLE FOR GIFTCODE IN GAME
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

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

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

    public function ActiveNumber()
    {
        return $this->hasMany('App\ActiveNumber', 'ActiveID', 'ActiveID');
    }

    public function ActiveAward()
    {
        return $this->hasMany('App\ActiveAward', 'ActiveID', 'ActiveID');
    }
}
