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

    const PET_XML = 'C:\\Gunny92\\Request\\pettemplateinfo.xml';

    /**
     * Mon dua vao game duoc khong, xet DUNG nhu client (22/10). Phai du:
     *  1. client biet ID (TemplateAlllist.xml): do admin cu tu che (352xxxxx...) client khong biet -> ket man hinh giay (15/10: hoang);
     *  2. co anh o DUNG duong client xin (duongDanClient, lay Pic/loai/gioi tinh tu XML client, khong thu duong du phong):
     *     truoc day thu ca prop/unfrightprop/doi m-f nen lot ~300 mon vao game khong co hinh (vd do noi that bed402);
     *  3. trung (loai 35): thu cung ben trong (Property5) co trong pettemplateinfo.xml + co anh (trung cua Vinhvinh 22/10 ra pet null).
     * Kiem tren may: node _setup/kiem-anh/kiem-anh.js. Khong doc duoc file -> chan het, khong cho lot.
     */
    public static function trongClient(int $tid): bool
    {
        if (self::$dsClient === null) {
            $mt = (int)@filemtime(self::CLIENT_XML);
            self::$dsClient = !$mt ? [] : Cache::rememberForever('client_ok_' . $mt . '_' . (int)@filemtime(self::PET_XML), function () {
                $raw = @file_get_contents(self::CLIENT_XML);
                $xml = $raw === false ? false : @gzuncompress($raw);
                if ($xml === false) return [];
                $pet = [];
                if (preg_match_all('/<item [^>]*>/i', (string)@file_get_contents(self::PET_XML), $pm))
                    foreach ($pm[0] as $t) if (preg_match('/ TemplateID="(\d+)"/', $t, $a) && preg_match('/ Pic="([^"]*)"/', $t, $b)) $pet[$a[1]] = $b[1];
                $co = function ($rel) { return is_file(self::RES_DIR . str_replace('/', '\\', $rel)); };
                $ok = [];
                preg_match_all('/<Item [^>]*>/', $xml, $m);
                foreach ($m[0] as $t) {
                    $g = function ($k) use ($t) { return preg_match('/ ' . $k . '="([^"]*)"/', $t, $x) ? $x[1] : ''; };
                    $pic = $g('Pic');
                    if ($pic === '' || $pic === 'null' || !preg_match('#^[A-Za-z0-9_\- ]+$#', $pic)) continue;
                    $cat = (int)$g('CategoryID');
                    if (!$co(self::duongDanClient($cat, $pic, (int)$g('NeedSex')))) continue;
                    if ($cat === 35) {
                        $pp = $pet[$g('Property5')] ?? null;
                        if ($pp === null || !$co("image/pet/$pp/icon1.png")) continue;
                    }
                    $ok[(int)$g('TemplateID')] = 1;
                }
                return $ok;
            });
        }
        return isset(self::$dsClient[$tid]);
    }

    /** = PathManager.solveGoodsPath(cat, pic, NeedSex == 1, "icon") cua client: anh icon trong tui (giong _setup/kiem-anh/kiem-anh.js) */
    public static function duongDanClient(int $cat, string $pic, int $needSex): string
    {
        $T = ['', 'head', 'glass', 'hair', 'eff', 'cloth', 'face', 'arm', 'armlet', 'ring', '', '', '', 'suits', 'necklace', 'wing', 'chatBall', '', '', '', '', '', '', '', '', '', '', '', 'armlet', 'ring'];
        if ($cat == 7 || $cat == 27) return "image/arm/$pic/1/icon.png";
        if (in_array($cat, [11, 24, 65, 68, 69, 72], true)) return "image/unfrightprop/$pic/icon.png";
        if ($cat == 12) return "image/task/$pic/icon.png";
        if ($cat == 16) return "image/specialprop/chatBall/$pic/icon.png";
        if ($cat < 10 || in_array($cat, [13, 14, 28, 29], true)) {
            $t = $T[$cat] ?? '';
            if (in_array($cat, [8, 9, 14, 28, 29], true)) return "image/equip/$t/$pic/icon.png";
            return 'image/equip/' . ($needSex === 1 ? 'm' : 'f') . "/$t/$pic/icon_1.png";
        }
        if ($cat == 15) return "image/equip/wing/$pic/icon.png";
        if ($cat == 17 || $cat == 31) return "image/equip/offhand/$pic/icon.png";
        if ($cat == 25) return "image/gift/$pic/icon.png";
        if ($cat == 26) return "image/card/$pic/icon.jpg";
        if ($cat == 18) return "image/cardbox/$pic/icon.png";
        if ($cat == 19) return "image/equip/recover/$pic/icon.png";
        if (in_array($cat, [20, 23, 30, 40, 34, 35], true)) return "image/unfrightprop/$pic/icon.png";
        if ($cat == 32 || $cat == 36) return "image/farm/Crops/$pic/seed.png";
        if ($cat == 33) return "image/farm/Fertilizer/$pic/icon.png";
        if ($cat == 52) return "image/petequip/cloth/$pic/icon.png";
        if ($cat == 50) return "image/petequip/arm/$pic/icon.png";
        if ($cat == 51) return "image/petequip/hat/$pic/icon.png";
        return "image/prop/$pic/icon.png";
    }

    /** dua vao game duoc (xem trongClient: xet theo du lieu client, khong theo DB). $i = dong co TemplateID */
    public static function dungDuoc($i): bool
    {
        return $i && self::trongClient((int)$i->TemplateID);
    }

    /**
     * Moi mon dua vao game duoc (dungDuoc) de tim nhanh o Gui qua test, cache 6 gio (doi TemplateAlllist.xml la dung lai).
     * Moi dong: [id, ten, cat, sex, q, lv, atk, def, agi, luck, cs, moTa]. Lan dau mat vai giay (kiem anh ~19k mon).
     */
    public static function tatCaDungDuoc(): array
    {
        $mt = (int)@filemtime(self::CLIENT_XML);
        return Cache::remember('vp_dungduoc2_' . $mt . '_' . (int)@filemtime(self::PET_XML), 21600, function () {
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
