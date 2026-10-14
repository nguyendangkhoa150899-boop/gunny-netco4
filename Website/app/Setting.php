<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Setting extends Model
{
    protected $connection = 'sqlsrv_mem';

    protected $table = 'Settings';
    protected $primaryKey = 'ID';
    protected $fillable = ['ID', 'Key', 'Name', 'Description', 'Value', 'Field', 'Active'];
    public $timestamps = true;

    /**
     * Grab a setting value from the database.
     *
     * @param string $key The setting key, as defined in the key db column
     *
     * @return string The setting value.
     */
    public static function get($key, $default = null)
    {
        $setting = new self();
        $entry = $setting->where('Key', $key)->first();
        if (!$entry) {
            return $default;
        }

        return $entry->Value;
    }
}
