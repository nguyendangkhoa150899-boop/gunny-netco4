<?php

namespace App;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class UserLogs extends Model
{
    protected $connection = 'sqlsrv_tank41';

    protected $table = 'Sys_Users_Log';
    protected $primaryKey = 'ID';
    protected $fillable = ['UserID','UserName','NickName','Type','Content','TimeCreate'];
    public $timestamps = false;
    public $incrementing = true;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }


}
