<?php

namespace App\Support;

use Illuminate\Support\Facades\DB;

/**
 * Vi xu web = Db_Member.dbo.Mem_Account.Money. Moi lan cong/tru ghi so cai Web_SoXu.
 * Tru xu bang 1 lenh UPDATE co dieu kien Money+delta>=0 nen khong bao gio am, ke ca bam dong thoi.
 * Khong tu mo transaction: ben goi boc DB::connection('sqlsrv_mem')->transaction(...) khi can gop nhieu buoc.
 */
class XuWeb
{
    public static function db()
    {
        return DB::connection('sqlsrv_mem');
    }

    /** cong (delta>0) hoac tru (delta<0). Tra so du moi, null neu khong du xu. */
    public static function doi(int $memberId, int $delta, string $loai, string $ghiChu = ''): ?int
    {
        $r = self::db()->selectOne("SET NOCOUNT ON; UPDATE Mem_Account SET Money=Money+? OUTPUT inserted.Money AS m WHERE UserID=? AND Money+?>=0",
            [$delta, $memberId, $delta]);
        if (!$r) return null;
        self::db()->insert("INSERT INTO Web_SoXu(MemberID,Delta,SoDu,Loai,GhiChu) VALUES(?,?,?,?,?)",
            [$memberId, $delta, (int)$r->m, $loai, mb_substr($ghiChu, 0, 200)]);
        return (int)$r->m;
    }

    public static function soDu(int $memberId): int
    {
        return (int)(self::db()->selectOne("SELECT Money m FROM Mem_Account WHERE UserID=?", [$memberId])->m ?? 0);
    }
}
