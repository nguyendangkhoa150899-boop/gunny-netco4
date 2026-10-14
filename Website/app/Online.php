<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Online extends Model
{
    protected $connection = 'sqlsrv_tank41';

    protected $table = 'Server_List';
    protected $primaryKey = 'ID';
//    protected $guarded = ['ActiveID'];
    protected $fillable = ['Name', 'IP', 'Port', 'State', 'Online', 'Total', 'Room', 'Remark', 'RSA', 'MustLevel', 'LowestLevel', 'NewerServer', 'ZoneId', 'ZoneName'];
    //     protected $hidden = [];
    // protected $dates = [];
    public $autoincrement = true;
    public $timestamps = false;

}
