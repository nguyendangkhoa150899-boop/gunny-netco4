<?php

namespace App\Support;

use Illuminate\Support\Facades\DB;

/**
 * Gui thu kem vat pham vao hop thu game qua Request/SendMailAndItem.aspx (chi nhan tu 127.0.0.1).
 * An toan ca khi nhan vat dang online (server game tu nap thu moi). Toi da 5 mon moi thu.
 */
class GameMail
{
    /**
     * @param array $items moi phan tu [TemplateID, Count, ValidDate, StrengthenLevel, IsBind]
     * @return string '1' la thanh cong, con lai la ma loi
     */
    public static function send(int $gameUserId, string $title, array $items, int $gold = 0, int $money = 0): string
    {
        $str = [];
        $mx = [];
        if ($items) foreach (DB::connection('sqlsrv_tank41')->select("SELECT TemplateID,MaxCount FROM Db_Tank.dbo.Shop_Goods WHERE TemplateID IN ("
            . implode(',', array_map(function ($it) { return (int)$it[0]; }, $items)) . ")") as $r) $mx[(int)$r->TemplateID] = max(1, (int)$r->MaxCount);
        foreach ($items as $it) {
            // chot cuoi: mon client khong biet ID lam nguoi nhan ket man hinh giay khi vao game (VatPham::trongClient)
            if (!VatPham::trongClient((int)$it[0])) return 'mon ' . (int)$it[0] . ' khong co trong client';
            // 22/10 chu server: moi mon vao game la MON GOC TRON (khong cuong hoa, vinh vien, khong khoa) cho do loi;
            // so luong giu (do trong ruong la so nguoi choi so huu) nhung kep theo MaxCount: do khong chong duoc luon la 1.
            // $it[2..4] (han, cuong hoa, khoa) cua ben goi bi bo qua.
            // TemplateID,Count,ValidDate,StrengthenLevel,AttackCompose,DefendCompose,AgilityCompose,LuckCompose,IsBind
            $str[] = implode(',', [(int)$it[0], min(max(1, (int)$it[1]), $mx[(int)$it[0]] ?? 1), 0, 0, 0, 0, 0, 0, 'false']);
        }
        $q = http_build_query(['title' => $title, 'content' => $title, 'user_id' => $gameUserId, 'gold' => $gold, 'money' => $money,
            'str' => implode('|', $str)], '', '&', PHP_QUERY_RFC3986);
        $ctx = stream_context_create(['http' => ['timeout' => 30, 'ignore_errors' => true]]);
        $r = @file_get_contents('http://127.0.0.1/SendMailAndItem.aspx?' . $q, false, $ctx);
        if ($r === false) return 'khong goi duoc';
        return preg_match('/^\s*(-?\d+)/', $r, $m) ? $m[1] : trim($r);
    }
}
