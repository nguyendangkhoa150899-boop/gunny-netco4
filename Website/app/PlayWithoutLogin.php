<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PlayWithoutLogin extends Model
{
    protected $connection = 'sqlsrv_mem';


    protected $table = 'Mem_Launcher';

    protected $primaryKey = 'UserID';

    protected $fillable = ['UserID', 'Email', 'KeyVerify', 'TimeCreate'];

    public $incrementing = false;
    public $timestamps = false;

}
