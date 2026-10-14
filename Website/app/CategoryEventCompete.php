<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class CategoryEventCompete extends Model
{
    protected $connection = 'sqlsrv';

    protected $table = 'category_event_compete';
    protected $primaryKey = 'id';
    protected $fillable = ['category_name', 'description', 'start_time', 'end_time', 'is_active', 'is_show_popup', 'image'];
    public $timestamps = true;

    public function EventCompete()
    {
        return $this->hasMany('App\EventCompete','category_event_id', 'id');
    }

    public function getImage()
    {
        $url = Storage::url($this->image);
        return '<img src="'.$url.'" width="100" height="100" />';
    }

    public function getImageUrl()
    {
        return Storage::url($this->image);
    }
}
