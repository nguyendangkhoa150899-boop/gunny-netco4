<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class DropItem extends Model
{
    protected $connection = 'sqlsrv_tank';

    protected $table = 'Drop_Item';
    protected $primaryKey = 'Id';
    protected $fillable = ['DropId', 'ItemId', 'ValueDate', 'IsBind', 'Random', 'BeginData', 'EndData', 'IsTips', 'IsLogs'];

    public $timestamps = false;
    public $incrementing = true;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function DropCondiction()
    {
        return $this->belongsTo('App\DropCondiction','DropID','DropID');
    }

    public function Item()
    {
        return $this->hasOne('App\ShopGoods', 'TemplateID', 'ItemId')->withDefault();
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }


}
