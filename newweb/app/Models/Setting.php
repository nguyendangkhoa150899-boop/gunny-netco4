<?php


namespace App\Models;

use Illuminate\Support\Facades\Cache;

class Setting extends \Backpack\Settings\app\Models\Setting
{
    public static function get($key)
    {
        $cache_key = slugify('setting-'.$key);
        if (!Cache::has($cache_key)) {
            Cache::rememberForever($cache_key, function () use ($key) {
                return parent::get($key);
            });
        }
        return Cache::get($cache_key);
    }

    /**
     * Update a setting's value.
     *
     * @param string $key   The setting key, as defined in the key db column
     * @param string $value The new value.
     */
    public static function set($key, $value = null)
    {
        $v = parent::set($key, $value);
        if ($v) {
            $cache_key = slugify('setting-'.$key);
            if (Cache::has($cache_key)) {
                Cache::forget($cache_key);
            }
            Cache::rememberForever($cache_key, function () use ($value) {
                return $value;
            });
        }
        return $v;
    }
}
