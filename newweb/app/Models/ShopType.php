<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class ShopType extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'Shop_Type';
    protected $primaryKey = 'ID';
    public $timestamps = false;
    protected $fillable = ['ID', 'Name'];
    public $autoincrement = false;
}
