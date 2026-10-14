<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class EventAwardCompete extends Model
{
    protected $connection = 'sqlsrv';
    protected $table = 'event_award_compete';
    protected $primaryKey = 'id';
    protected $fillable = ['event_compete_id', 'rank', 'item_id', 'amount', 'date', 'strengthen', 'composes'];
    public $timestamps = true;

    public function EventCompete()
    {
        return $this->hasOne('App\EventCompete', 'id', 'event_compete_id');
    }

    public function Item()
    {
        return $this->hasOne('App\ShopGoods', 'TemplateID', 'item_id');
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

}
