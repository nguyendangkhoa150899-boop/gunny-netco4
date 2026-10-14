<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Config extends Model
{
    protected $connection = 'sqlsrv';

    protected $table = 'admin_client_configs';
    protected $primaryKey = 'id';
    protected $fillable = ['key', 'value', 'description'];

    public $timestamps = false;

    /**
     * Grab a setting value from the database.
     *
     * @param string $key The setting key, as defined in the key db column
     *
     * @return string The setting value.
     */
    public static function get($key)
    {
        $setting = new self();
        $entry = $setting->where('key', $key)->first();
        if (!$entry) {
            return;
        }

        return $entry->Value;
    }
}
