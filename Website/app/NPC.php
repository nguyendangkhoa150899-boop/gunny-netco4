<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class NPC extends Model
{
    protected $connection = 'sqlsrv_tank';

    protected $table = 'NPC_Info';
    protected $primaryKey = 'ID';
    protected $fillable = ['ID', 'Name', 'Level', 'Camp', 'Type', 'X', 'Y', 'Width', 'Height', 'Blood', 'MoveMin', 'MoveMax', 'BaseDamage', 'BaseGuard', 'Defence', 'Agility', 'Lucky', 'Attack', 'ModelID', 'ResourcesPath', 'DropRate', 'Experience', 'Delay', 'Immunity', 'Alert', 'Range', 'Preserve', 'Script', 'FireX', 'FireY', 'DropId', 'CurrentBallId', 'speed', 'MagicAttack', 'MagicDefence'];

    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }
}
