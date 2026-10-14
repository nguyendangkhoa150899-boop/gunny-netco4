<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class LoginAwardItemTemplate extends Model
{
    /*
     * Quà đăng nhập 7 ngày
     */
    protected $connection = 'sqlsrv_tank';
    protected $table = 'Login_Award_Item_Template';
    protected $primaryKey = 'ID';
    protected $fillable = ['ID', 'Count', 'RewardItemID', 'IsSelect', 'IsBind', 'RewardItemValid', 'RewardItemCount', 'StrengthenLevel', 'AttackCompose', 'DefendCompose', 'AgilityCompose', 'LuckCompose'];

    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function Reward()
    {
        return $this->hasOne('App\ShopGoods','TemplateID','RewardItemID');
    }


}
