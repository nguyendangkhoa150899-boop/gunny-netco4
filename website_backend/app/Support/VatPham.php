<?php

namespace App\Support;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

/**
 * Ten + anh vat pham cho portal. Anh doc tu C:\Gunny92\Resource.Server (res.netco4.click khong co HTTPS nen khong nhung truc tiep duoc).
 * Duong dan anh chep cong thuc PathManager.solveGoodsPath cua client (giong admin/lib.php item_icon_rel).
 */
class VatPham
{
    const RES_DIR = 'C:\\Gunny92\\Resource.Server\\';
    /** danh sach vat pham client tai ve (quest1/TemplateAlllist.xml, nen zlib) */
    const CLIENT_XML = 'C:\\Gunny92\\Request\\TemplateAlllist.xml';

    private static $dsClient = null;

    /**
     * Mon co trong TemplateAlllist.xml cua client khong. CO ANH CHUA DU: do admin cu tu che (352xxxxx...) dung lai anh do that
     * nhung client khong biet ID -> nam trong tui la client loi khi dung sanh, ket man hinh giay (15/10: hoang).
     * Khong doc duoc file -> coi nhu khong co mon nao (chan het, khong cho lot).
     */
    public static function trongClient(int $tid): bool
    {
        if (self::$dsClient === null) {
            $mt = @filemtime(self::CLIENT_XML);
            self::$dsClient = !$mt ? [] : Cache::rememberForever('client_tpl_' . $mt, function () {
                $raw = @file_get_contents(self::CLIENT_XML);
                $xml = $raw === false ? false : @gzuncompress($raw);
                if ($xml === false) return [];
                preg_match_all('/<Item [^>]*?TemplateID="(\d+)"/', $xml, $m);
                return array_fill_keys(array_map('intval', $m[1]), 1);
            });
        }
        return isset(self::$dsClient[$tid]);
    }

    /** dua vao game duoc: client biet ID va co anh. $i = dong tu thongTin() */
    public static function dungDuoc($i): bool
    {
        return $i && self::trongClient((int)$i->TemplateID) && self::file($i->CategoryID, $i->Pic, $i->NeedSex) !== null;
    }

    /**
     * Moi mon dua vao game duoc (dungDuoc) de tim nhanh o Gui qua test, cache 6 gio (doi TemplateAlllist.xml la dung lai).
     * Moi dong: [id, ten, cat, sex, q, lv, atk, def, agi, luck, cs, moTa]. Lan dau mat vai giay (kiem anh ~19k mon).
     */
    public static function tatCaDungDuoc(): array
    {
        $mt = (int)@filemtime(self::CLIENT_XML);
        return Cache::remember('vp_dungduoc_' . $mt, 21600, function () {
            $rows = DB::connection('sqlsrv_tank41')->select("SELECT TemplateID,Name,CategoryID,Pic,NeedSex,Quality,NeedLevel,Attack,Defence,Agility,Luck,CanStrengthen,CAST(Description AS nvarchar(200)) Description FROM Db_Tank.dbo.Shop_Goods ORDER BY TemplateID");
            $out = [];
            foreach ($rows as $x) {
                if (!self::dungDuoc($x)) continue;
                $out[] = [(int)$x->TemplateID, (string)$x->Name, (int)$x->CategoryID, (int)$x->NeedSex, (int)$x->Quality, (int)$x->NeedLevel,
                    (int)$x->Attack, (int)$x->Defence, (int)$x->Agility, (int)$x->Luck, (bool)$x->CanStrengthen, mb_substr((string)$x->Description, 0, 120)];
            }
            return $out;
        });
    }

    /** ten loai (Shop_Goods.CategoryID) theo EquipType cua client; loai khong ro ten tra null */
    public static function tenLoai(int $cat): ?string
    {
        return [1 => 'Nón', 2 => 'Kính', 3 => 'Tóc', 4 => 'Hiệu ứng mắt', 5 => 'Áo', 6 => 'Mặt', 7 => 'Vũ khí', 8 => 'Vòng tay', 9 => 'Nhẫn',
            10 => 'Đạo cụ chiến đấu', 11 => 'Đạo cụ', 12 => 'Vật phẩm nhiệm vụ', 13 => 'Bộ trang phục', 14 => 'Dây chuyền', 15 => 'Cánh',
            16 => 'Bóng chat', 17 => 'Vũ khí phụ', 18 => 'Hộp thẻ', 19 => 'Bùa hộ thân', 20 => 'Kinh nghiệm', 23 => 'Sách tu luyện',
            24 => 'Đạo cụ khác', 25 => 'Hộp quà', 26 => 'Thẻ', 27 => 'Vũ khí đặc biệt', 28 => 'Vòng tay đặc biệt', 29 => 'Nhẫn đặc biệt',
            30 => 'Đồ ăn', 31 => 'Vũ khí phụ đặc biệt', 32 => 'Hạt giống', 33 => 'Phân bón', 34 => 'Thức ăn thú', 35 => 'Trứng thú cưng',
            50 => 'Vũ khí thú', 51 => 'Mũ thú', 52 => 'Áo thú'][$cat] ?? null;
    }

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
