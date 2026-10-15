<?php

namespace App\Support;

use Illuminate\Support\Facades\DB;

/** Cau hinh mini game (Db_Member.dbo.Web_CauHinh, admin sua o trang Mini game). */
class CauHinh
{
    private static $cache = null;

    public static function get(string $khoa, $macDinh = null)
    {
        if (self::$cache === null) {
            self::$cache = [];
            foreach (DB::connection('sqlsrv_mem')->select("SELECT Khoa,GiaTri FROM Web_CauHinh") as $r) self::$cache[$r->Khoa] = $r->GiaTri;
        }
        return self::$cache[$khoa] ?? $macDinh;
    }

    public static function int(string $khoa, int $macDinh): int
    {
        return (int)self::get($khoa, $macDinh);
    }

    public static function float(string $khoa, float $macDinh): float
    {
        return (float)self::get($khoa, $macDinh);
    }
}
