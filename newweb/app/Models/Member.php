<?php


namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;

class Member extends \Illuminate\Database\Eloquent\Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_mem';

    protected $table = 'Mem_Account';

    protected $fillable = ['Email', 'Password', 'Fullname', 'Phone', 'Money', 'MoneyLock', 'TotalMoney', 'MoneyEvent', 'Point', 'CountLucky', 'VIPLevel', 'VIPExp', 'IsBan', 'IPCreate', 'AllowSocialLogin', 'TimeCreate', 'Pass2'];

    protected $hidden = [
        'Password', 'Pass2',
    ];

    protected $primaryKey = 'UserID';

    public $timestamps = false;

    public function chargeMoney($coin)
    {
        $this->Money -= $coin;
        return $this->save();
    }

    public function BanReason()
    {
        if (!$this->IsBan) {
            return '';
        }
        $reason = BanMemberReason::where('UserID', $this->UserID)->first();
        if (!empty($reason)) {
            return $reason->reason;
        }
        return '';
    }

    public function Histories()
    {
        return $this->hasMany(MemHistory::class, 'UserID', 'UserID');
    }

    public function CoinLogs()
    {
        return $this->hasMany(CoinLog::class, 'MemberUserName', 'Email');
    }

    public function getTotalCharged()
    {
        $memhis = $this->Histories;
        $coinlog = $this->CoinLogs;
        $amount = 0;
        foreach ($memhis as $his) {
            if ($his->TypeCode == 3) {
                continue;
            }
            $amount += $his->Value;
        }
        foreach ($coinlog as $log) {
            if ($log->Value <= 0) {
                continue;
            }
            $amount += $log->Value;
        }
        return $amount;
    }
}
