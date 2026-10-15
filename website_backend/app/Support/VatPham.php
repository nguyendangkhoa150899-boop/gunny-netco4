<?php

namespace App\Support;

use Illuminate\Support\Facades\DB;

/**
 * Ten + anh vat pham cho portal. Anh doc tu C:\Gunny92\Resource.Server (res.netco4.click khong co HTTPS nen khong nhung truc tiep duoc).
 * Duong dan anh chep cong thuc PathManager.solveGoodsPath cua client (giong admin/lib.php item_icon_rel).
 */
class VatPham
{
    const RES_DIR = 'C:\\Gunny92\\Resource.Server\\';

    /** [TemplateID => {Name, CategoryID, Pic, NeedSex, Quality}] */
    public static function thongTin(array $ids): array
    {
        $ids = array_values(array_unique(array_filter(array_map('intval', $ids))));
        if (!$ids) return [];
        $out = [];
        $rows = DB::connection('sqlsrv_tank41')->select("SELECT TemplateID,Name,CategoryID,Pic,NeedSex,Quality FROM Db_Tank.dbo.Shop_Goods WHERE TemplateID IN (" . implode(',', $ids) . ")");
        foreach ($rows as $r) $out[(int)$r->TemplateID] = $r;
        return $out;
    }

    public static function mau(int $q): string
    {
        return [0 => '#6b7a90', 1 => '#9aa7b8', 2 => '#3fbf6f', 3 => '#3b8cff', 4 => '#a35bff', 5 => '#ff9a1f', 6 => '#ff4d5e'][$q] ?? '#6b7a90';
    }

    private static function duongDan($cat, $pic, $sex): string
    {
        $T = ['', 'head', 'glass', 'hair', 'eff', 'cloth', 'face', 'arm', 'armlet', 'ring', '', '', '', 'suits', 'necklace', 'wing', 'chatBall', '', '', '', '', '', '', '', '', '', '', '', 'armlet', 'ring'];
        $c = (int)$cat; $p = $pic;
        if ($c == 7 || $c == 27) return "image/arm/$p/1/icon.png";
        if (in_array($c, [11, 24, 65, 68, 69, 72], true)) return "image/unfrightprop/$p/icon.png";
        if ($c == 12) return "image/task/$p/icon.png";
        if ($c == 16) return "image/specialprop/chatBall/$p/icon.png";
        if ($c < 10 || in_array($c, [13, 14, 28, 29], true)) {
            $t = $T[$c] ?? '';
            if (in_array($c, [8, 9, 14, 28, 29], true)) return "image/equip/$t/$p/icon.png";
            return 'image/equip/' . ((int)$sex === 2 ? 'f' : 'm') . "/$t/$p/icon_1.png";
        }
        if ($c == 15) return "image/equip/wing/$p/icon.png";
        if ($c == 17 || $c == 31) return "image/equip/offhand/$p/icon.png";
        if ($c == 25) return "image/gift/$p/icon.png";
        if ($c == 26) return "image/card/$p/icon.jpg";
        if ($c == 18) return "image/cardbox/$p/icon.png";
        if ($c == 19) return "image/equip/recover/$p/icon.png";
        if (in_array($c, [20, 23, 30, 40, 34, 35], true)) return "image/unfrightprop/$p/icon.png";
        if ($c == 32 || $c == 36) return "image/farm/Crops/$p/seed.png";
        if ($c == 33) return "image/farm/Fertilizer/$p/icon.png";
        if ($c == 52) return "image/petequip/cloth/$p/icon.png";
        if ($c == 50) return "image/petequip/arm/$p/icon.png";
        if ($c == 51) return "image/petequip/hat/$p/icon.png";
        return "image/prop/$p/icon.png";
    }

    /** duong dan file anh that tren dia, null neu client khong co anh */
    public static function file($cat, $pic, $sex): ?string
    {
        $pic = (string)$pic;
        if ($pic === '' || strpos($pic, '..') !== false || !preg_match('#^[A-Za-z0-9_\-/]+$#', $pic)) return null;
        $first = self::duongDan($cat, $pic, $sex);
        $try = [$first, "image/unfrightprop/$pic/icon.png", "image/prop/$pic/icon.png"];
        $try[] = (int)$sex !== 2 ? str_replace('/m/', '/f/', $first) : str_replace('/f/', '/m/', $first);
        foreach ($try as $r) {
            $f = self::RES_DIR . str_replace('/', '\\', $r);
            if (is_file($f)) return $f;
        }
        return null;
    }
}
