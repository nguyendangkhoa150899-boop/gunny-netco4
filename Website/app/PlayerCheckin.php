<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PlayerCheckin extends Model
{
    protected $connection = 'sqlsrv';
    protected $table = 'player_checkin';
    protected $primaryKey = 'ID';
    protected $fillable = ['PlayerID', 'LastCheckedIn', 'Time'];
    public $timestamps = false;

    public function Player()
    {
        return $this->hasOne('App\Player', 'ID', 'PlayerID');
    }
}
