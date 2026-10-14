<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class CoinLog extends Model
{
    protected $connection = 'sqlsrv';

    protected $table = 'admin_coin_logs';

    protected $primaryKey = 'id';

    protected $fillable = ['MemberUserName', 'OwnerActionId', 'Type', 'Vendor', 'Bonus', 'Value', 'Description'];

    public $timestamps = true;


    public function admin()
    {
        return $this->hasOne('App\Admin','id','OwnerActionId');
    }
}
