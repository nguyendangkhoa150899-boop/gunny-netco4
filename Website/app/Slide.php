<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Slide extends Model
{
    protected $connection = 'sqlsrv';
    protected $table = 'slide_config';
    protected $primaryKey = 'id';
    protected $fillable = ['title', 'link', 'image'];
    public $timestamps = true;
    public $incrementing = true;
}
