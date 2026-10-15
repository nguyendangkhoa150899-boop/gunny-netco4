<?php

namespace App\Support;

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
        foreach ($items as $it) {
            // chot cuoi: mon client khong biet ID lam nguoi nhan ket man hinh giay khi vao game (VatPham::trongClient)
            if (!VatPham::trongClient((int)$it[0])) return 'mon ' . (int)$it[0] . ' khong co trong client';
            // TemplateID,Count,ValidDate,StrengthenLevel,AttackCompose,DefendCompose,AgilityCompose,LuckCompose,IsBind
            $str[] = implode(',', [(int)$it[0], max(1, (int)$it[1]), (int)($it[2] ?? 0), (int)($it[3] ?? 0), 0, 0, 0, 0, !empty($it[4]) ? 'true' : 'false']);
        }
        $q = http_build_query(['title' => $title, 'content' => $title, 'user_id' => $gameUserId, 'gold' => $gold, 'money' => $money,
            'str' => implode('|', $str)], '', '&', PHP_QUERY_RFC3986);
        $ctx = stream_context_create(['http' => ['timeout' => 30, 'ignore_errors' => true]]);
        $r = @file_get_contents('http://127.0.0.1/SendMailAndItem.aspx?' . $q, false, $ctx);
        if ($r === false) return 'khong goi duoc';
        return preg_match('/^\s*(-?\d+)/', $r, $m) ? $m[1] : trim($r);
    }
}
