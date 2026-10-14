<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use App\Models\Setting;
use Illuminate\Database\Eloquent\Model;

class MemHistory extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */

    protected $connection = 'sqlsrv_mem';

    protected $table = 'Mem_History';
     protected $primaryKey = 'ID';
     public $timestamps = false;
    protected $guarded = ['ID'];
    // protected $fillable = [];
    // protected $hidden = [];
    // protected $dates = [];

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */
    public function memberChargeMoneyLog($UserID, $Value, $ServerName, $ip)
    {
        $this->UserID = $UserID;
        $this->Type = 'Chuyển xu';
        $this->TypeCode = 3;
        $this->Content = 'Chuyển '.$Value*Setting::get('he-so-doi-coin').' vào máy chủ '.$ServerName;
        $this->Value = $Value;
        $this->TimeCreate = time();
        $this->IPCreate = $ip;
        return $this->save();
    }

    public function memberTotalChargedToday($UserID)
    {
        $total_changed = 0;
        $rows = self::where('UserID', $UserID)
            ->where('TypeCode', 3)
            ->where('TimeCreate', '>=', strtotime(date('Y-m-d 00:00:00')))
            ->get();
        if (!empty($rows) && $rows->count()) {
            foreach ($rows as $history) {
                $total_changed += abs(intval($history->Value));
            }
        }
        return $total_changed;
    }

    public function memberChangeNickNameLog($UserID, $previousNickName, $newNickName, $Value, $ServerName, $ip)
    {
        $this->UserID = $UserID;
        $this->Type = 'Đổi tên';
        $this->TypeCode = 6;
        $this->Content = 'Đổi tên nhân vật từ '.$previousNickName.' thành '.$newNickName.' trong máy chủ '.$ServerName;
        $this->Value = $Value;
        $this->TimeCreate = time();
        $this->IPCreate = $ip;
        return $this->save();
    }
    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */
    public function Member()
    {
        return $this->hasOne(\App\Models\Member::class, 'UserID', 'UserID');
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
    public function created_at()
    {
        if (!empty($this->TimeCreate)) {
            return date('Y-m-d H:i:s', $this->TimeCreate);
        }
        return $this->TimeCreate;
    }

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */
}
