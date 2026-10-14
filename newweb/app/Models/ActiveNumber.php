<?php


namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;

class ActiveNumber extends \Illuminate\Database\Eloquent\Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank41';

    protected $table = 'Active_Number';

    protected $fillable = ['AwardID', 'ActiveID', 'PullDown', 'UserID', 'Mark', 'Creator'];

//    protected $hidden = [];

    protected $primaryKey = 'AwardID';

    public $incrementing = false;

    public $timestamps = false;
}
