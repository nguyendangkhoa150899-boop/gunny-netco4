<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class News extends Model
{
    protected $connection = 'sqlsrv_mem';

    protected $table = 'News';

    protected $fillable = ['Title', 'Type', 'Content', 'Link'];

    protected $primaryKey = 'NewsID';

    public $timestamps = false;

}
