<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class Ball extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'Ball';
    protected $primaryKey = 'ID';
    public $timestamps = false;
    protected $fillable = ['ID','Name','Power','Radii','FlyingPartical','BombPartical','Crater','AttackResponse','IsSpin','Mass','SpinVA','SpinV','Amount','Wind','DragIndex','Weight','Shake','ShootSound','BombSound','Delay','ActionType','HasTunnel'];
    public $autoincrement = false;

}
