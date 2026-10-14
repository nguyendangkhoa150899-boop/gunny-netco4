<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class EmailVerify extends Model
{
    protected $connection = 'sqlsrv_mem';

    protected $table = 'Verify_Email';

    protected $primaryKey = 'Email';

    protected $fillable = ['Email', 'Token', 'IsActivated', 'CreatedAt'];

    public $timestamps = false;

}
