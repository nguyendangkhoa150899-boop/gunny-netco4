<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class BallConfig extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'BallConfig';
    protected $primaryKey = 'TemplateID';
    public $timestamps = false;
    protected $fillable = ['TemplateID','Common','CommonAddWound','CommonMultiBall','Special'];
    public $autoincrement = false;

    public function CommonBall()
    {
        return $this->hasOne(Ball::class, 'ID', 'Common');
    }

    public function CommonAddWoundBall()
    {
        return $this->hasOne(Ball::class, 'ID', 'CommonAddWound');
    }

    public function CommonMultiBallBall()
    {
        return $this->hasOne(Ball::class, 'ID', 'CommonMultiBall');
    }

    public function SpecialBall()
    {
        return $this->hasOne(Ball::class, 'ID', 'Special');
    }
}
