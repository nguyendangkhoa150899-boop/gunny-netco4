<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class ItemFusionList extends Model
{
    /*
     * Hiển thị dung luyện
     */
    protected $connection = 'sqlsrv_tank';
    protected $table = 'Items_Fusion_List';
    protected $primaryKey = 'ID';
    protected $fillable = ['ID', 'TemplateID', 'Show', 'Real'];

    public $timestamps = false;
    public $incrementing = true;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function Item()
    {
        return $this->hasOne('App\ShopGoods','TemplateID','TemplateID')->withDefault();
    }

}
