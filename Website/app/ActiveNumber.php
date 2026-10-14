<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class ActiveNumber extends Model
{
    protected $connection = 'sqlsrv_tank41';

    protected $table = 'Active_Number';

    protected $primaryKey = 'AwardID';

    protected $fillable = ['AwardID', 'ActiveID', 'PullDown', 'UserID', 'Mark', 'Creator'];

    public $incrementing = false;

    public $timestamps = false;

    public function Active()
    {
        return $this->hasOne('App\Active','ActiveID',' ActiveID');
    }

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $server = ServerList::where('TankConnection', $currentTank)->firstOrFail();
        $serverConnection = $server->Connection;
        $this->connection = $serverConnection;
        parent::__construct($attributes);
    }

}
