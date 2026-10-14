<?php

namespace App;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class PVPLogs extends Model
{
    protected $connection = 'sqlsrv_tank41';

    protected $table = 'User_PVP_1vs1';
    protected $primaryKey = 'UserID';
    protected $fillable = ['UserID','Year','Month','Hour','Count'];
    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }


}
