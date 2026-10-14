<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PasswordReset extends Model
{
    protected $connection = 'sqlsrv_mem';

    protected $table = 'Password_Resets';

    protected $fillable = ['email','token', 'created_at'];

    public $timestamps = false;
}
