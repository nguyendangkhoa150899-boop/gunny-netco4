<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Admin extends Model
{
    protected $connection = 'sqlsrv';

    protected $table = 'admin_users';

    protected $primaryKey = 'id';

    protected $fillable = ['username','password', 'current_tank', 'name','avatar'];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password',
        'remember_token'
    ];


    public $timestamps = true;
}
