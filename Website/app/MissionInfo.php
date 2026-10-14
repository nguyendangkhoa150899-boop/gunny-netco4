<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class MissionInfo extends Model
{
    protected $connection = 'sqlsrv_tank';

    protected $table = 'Mission_Info';
    protected $primaryKey = 'Id';
    protected $fillable =  ['Id', 'Name', 'TotalCount', 'TotalTurn', 'Script', 'Success', 'Failure', 'Description', 'IncrementDelay', 'Delay', 'Title', 'Param1', 'Param2', 'TakeCard'];

    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }
}
