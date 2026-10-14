<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class PaymentACBHistory extends Model
{
    use CrudTrait;

    protected $table = 'payment_acb_history';
    public $incrementing = true;
    public $timestamps = true;

    protected $fillable = ['id', 'transactionID', 'amount', 'description', 'created_at', 'updated_at'];
}
