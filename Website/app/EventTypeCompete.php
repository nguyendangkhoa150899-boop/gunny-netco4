<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class EventTypeCompete extends Model
{
    protected $connection = 'sqlsrv';
    protected $table = 'event_type_compete';
    protected $primaryKey = 'id';
    protected $fillable = ['type_name', 'type_description'];
    public $timestamps = true;

    public function EventCompete()
    {
        return $this->belongsTo('App\EventCompete','event_type_id','id');
    }
}
