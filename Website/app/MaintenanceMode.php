<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MaintenanceMode extends Model
{
    protected $connection = 'sqlsrv';
    protected $table = 'maintenance_whitelist_tables';
    protected $primaryKey = 'id';
    protected $fillable = ['mode', 'ip_whitelist', 'owner_ip', 'ip_real_headers_param'];
    public $timestamps = true;
}
