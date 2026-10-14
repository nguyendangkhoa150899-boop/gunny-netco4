<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class PveInfoHards extends Model
{
    use CrudTrait;

    protected $connection = '';

    protected $table = '';
    protected $primaryKey = '';
    public $timestamps = false;
    protected $fillable = [];
    public $autoincrement = false;
    protected $appends = [
        'ID',
        'name'
    ];
}
