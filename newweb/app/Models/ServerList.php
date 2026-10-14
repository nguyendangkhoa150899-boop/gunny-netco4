<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Backpack\CRUD\app\Models\Traits\CrudTrait;

class ServerList extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_mem';

    protected $table = 'Server_List';

    protected $fillable = ['ServerID', 'ServerName', 'Host', 'Username', 'Password', 'Database', 'LinkCenter', 'LinkRequest', 'LinkConfig'];

    protected $hidden = [
        'Password',
    ];

    protected $primaryKey = 'ServerID';

    public $timestamps = false;
}
