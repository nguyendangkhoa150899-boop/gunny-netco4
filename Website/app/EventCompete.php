<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class EventCompete extends Model
{
    protected $connection = 'sqlsrv';
    protected $table = 'event_compete';
    protected $primaryKey = 'id';
    protected $fillable = ['category_event_id', 'event_type_id', 'event_name'];
    public $timestamps = true;

    public function EventCategory()
    {
        return $this->hasOne('App\CategoryEventCompete','id','category_event_id');
    }

    public function EventType()
    {
        return $this->hasOne('App\EventTypeCompete','id','event_type_id');
    }

    public function EventAwardCompete()
    {
        return $this->hasOne('App\EventAwardCompete', 'event_compete_id', 'id');
    }


    public function re()
    {
        return 'hello';
    }
}
