<?php

namespace App\Support;

use Illuminate\Support\Facades\DB;

/**
 * Diem hoat dong (Db_Member.dbo.Web_Diem): tien cua ke hiem trong shop web. KHONG doi tu xu duoc,
 * chi kiem tu diem danh va thang boss pho ban -> acc phu co 10 trieu xu cung khong don ve duoc.
 * Cong/tru 1 lenh co dieu kien (khong am) + so cai Web_SoDiem. Ben goi tu boc transaction khi can.
 */
class Diem
{
    private static function db()
    {
        return DB::connection('sqlsrv_mem');
    }

    public static function doi(int $memberId, int $delta, string $loai, string $ghiChu = ''): ?int
    {
        if ($delta > 0) {
            self::db()->statement("IF NOT EXISTS (SELECT 1 FROM Web_Diem WHERE MemberID=?) INSERT INTO Web_Diem(MemberID,Diem) VALUES(?,0)", [$memberId, $memberId]);
        }
        $r = self::db()->selectOne("SET NOCOUNT ON; UPDATE Web_Diem SET Diem=Diem+? OUTPUT inserted.Diem AS d WHERE MemberID=? AND Diem+?>=0", [$delta, $memberId, $delta]);
        if (!$r) return null;
        self::db()->insert("INSERT INTO Web_SoDiem(MemberID,Delta,SoDu,Loai,GhiChu) VALUES(?,?,?,?,?)", [$memberId, $delta, (int)$r->d, $loai, mb_substr($ghiChu, 0, 200)]);
        return (int)$r->d;
    }

    public static function soDu(int $memberId): int
    {
        return (int)(self::db()->selectOne("SELECT Diem d FROM Web_Diem WHERE MemberID=?", [$memberId])->d ?? 0);
    }

    /** so diem da nhan hom nay theo loai (de ap tran) */
    public static function homNay(int $memberId, string $loai): int
    {
        return (int)self::db()->selectOne("SELECT ISNULL(SUM(Delta),0) n FROM Web_SoDiem WHERE MemberID=? AND Loai=? AND Delta>0 AND ThoiGian>=CAST(GETDATE() AS date)", [$memberId, $loai])->n;
    }
}
