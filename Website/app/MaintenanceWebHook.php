<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MaintenanceWebHook extends Model
{
    protected $connection = 'sqlsrv';
    protected $table = 'maintenance_webhook_discord_tables';
    protected $primaryKey = 'id';
    protected $fillable = ['webhook_url', 'is_active', 'title', 'content'];
    public $timestamps = false;

}
