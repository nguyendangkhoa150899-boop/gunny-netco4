<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MemberGoGun extends Model
{
    protected $connection = 'sqlsrv_mem_backup';

    protected $guard = 'member';

    protected $table = 'Mem_Account';

    protected $primaryKey = 'UserID';

    protected $fillable = ['Email', 'Password', 'Fullname', 'Phone', 'Money', 'MoneyLock', 'TotalMoney', 'MoneyEvent', 'Point', 'CountLucky', 'VIPLevel', 'VIPExp', 'IsBan', 'IPCreate', 'AllowSocialLogin', 'TimeCreate', 'Pass2', 'TwoFactorStatus', 'VerifiedEmail', 'TwoFactorCode', 'TwoFactorCodeExpiresAt'];
    protected $hidden = [
        'Password', 'Pass2',
    ];

    //This below function play an fucking important role in Model.

    //Which Password field it not like 'password'.
    //This function override custom field
    public function getAuthPassword()
    {
        return $this->Password;
    }

    public $timestamps = false;

}
