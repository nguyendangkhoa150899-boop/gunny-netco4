<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class ShopGoodsCategory extends Model
{
    protected $connection = 'sqlsrv_tank';
    protected $table = 'Shop_Goods_Categorys';
    protected $primaryKey = 'ID';
    public $timestamps = false;
//    protected $guarded = ['ID'];
//     protected $fillable = [];
    // protected $hidden = [];
    // protected $dates = [];
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }
}
