<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class ConsortiaLevel extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';
    protected $table = 'Consortia_Level';
    protected $primaryKey = 'Level';

    protected $fillable = ['Level', 'Riches', 'Deduct', 'NeedGold', 'NeedItem', 'Reward', 'Count', 'StoreRiches', 'SmithRiches', 'ShopRiches', 'BufferRiches', 'KickMax', 'BossCount'];
    protected $attributes = [
        'NeedItem' => 0,
        'Reward' => 0
    ];

    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }
}
