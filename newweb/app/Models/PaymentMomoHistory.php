<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class PaymentMomoHistory extends Model
{
    use CrudTrait;

    protected $table = 'payment_momo_history';
    public $incrementing = true;
    public $timestamps = true;

    protected $fillable = ['ID', 'tranId', 'user', 'partnerId', 'partnerName', 'amount', 'comment', 'status'];
}
