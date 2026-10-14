<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class EventRewardCondiction extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';
    protected $table = 'Event_Reward_Condiction';
    protected $primaryKey = 'ID';

    protected $fillable = ['Label'];

    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }
}
