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

    /** danh sach mon game KHONG dung duoc, dung chung voi admin (item_in_client): C:\Gunny92\_setup\do-vo-dung.json */
    const VO_DUNG_JSON = 'C:\\Gunny92\\_setup\\do-vo-dung.json';

    private static $voDung = null;

    /**
     * [TemplateID => 1] mon client co ma game khong dung duoc (ra soat 22/10, ly do tung nhom trong file): hop rong (mo ra mat hop,
     * khong nhan gi), chien hon gia 201264, vat pham nhiem vu, khung nhan vat khong mac duoc, do test, do su kien khong dung...
     * Khong doc duoc file thi coi nhu rong (khong chan them).
     */
    public static function voDung(): array
    {
        if (self::$voDung === null) {
            self::$voDung = [];
            $j = json_decode((string)@file_get_contents(self::VO_DUNG_JSON), true);
            if (is_array($j)) foreach ($j as $nhom) if (is_array($nhom)) foreach ($nhom['ids'] ?? [] as $id) self::$voDung[(int)$id] = 1;
        }
        return self::$voDung;
    }

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
            self::$dsClient = !$mt ? [] : Cache::rememberForever('client_ok4_' . $mt . '_' . (int)@filemtime(self::PET_XML), function () {
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
                    // 22/10 an mon loi: ID am = diem/tien ao (-200 Xu, -100 vang, -1300 Danh vong...) khong phai vat pham;
                    // do "Mac dinh" = o trong cua game, anh trong suot ~190 byte (1101, 1201, 13101...). Giong admin item_in_client.
                    $ten = trim(html_entity_decode($g('Name'), ENT_QUOTES, 'UTF-8'));
                    if ((int)$g('TemplateID') <= 0 || $ten === '' || mb_stripos($ten, 'mặc định') !== false) continue;
                    $anh = self::RES_DIR . str_replace('/', '\\', self::duongDanClient($cat, $pic, (int)$g('NeedSex')));
                    if (!is_file($anh) || filesize($anh) < 400) continue;
                    if ($cat === 35) {
                        $pp = $pet[$g('Property5')] ?? null;
                        if ($pp === null || !$co("image/pet/$pp/icon1.png")) continue;
                    }
                    $ok[(int)$g('TemplateID')] = 1;
                }
                return $ok;
            });
        }
        return isset(self::$dsClient[$tid]) && !isset(self::voDung()[$tid]);
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

    private static $tenClient = null;

    /**
     * [TemplateID => ten] theo client (TemplateAlllist.xml) = ten nguoi choi thay trong game. DB co the khac
     * (7024: DB "VIP-Boomerang", game "SUPER-Boomerang"), nen web hien ten client, tim duoc ca 2 ten.
     */
    public static function tenClient(): array
    {
        if (self::$tenClient === null) {
            $mt = (int)@filemtime(self::CLIENT_XML);
            self::$tenClient = !$mt ? [] : Cache::rememberForever('client_ten_' . $mt, function () {
                $raw = @file_get_contents(self::CLIENT_XML);
                $xml = $raw === false ? false : @gzuncompress($raw);
                if ($xml === false) return [];
                $out = [];
                preg_match_all('/<Item [^>]*>/', $xml, $m);
                foreach ($m[0] as $t) {
                    if (!preg_match('/ TemplateID="(-?\d+)"/', $t, $a) || !preg_match('/ Name="([^"]*)"/', $t, $b)) continue;
                    $ten = trim(html_entity_decode($b[1], ENT_QUOTES, 'UTF-8'));
                    if ($ten !== '') $out[(int)$a[1]] = $ten;
                }
                return $out;
            });
        }
        return self::$tenClient;
    }

    /** dua vao game duoc (xem trongClient: xet theo du lieu client, khong theo DB). $i = dong co TemplateID */
    public static function dungDuoc($i): bool
    {
        return $i && self::trongClient((int)$i->TemplateID);
    }

    /**
     * Moi mon dua vao game duoc (dungDuoc) de tim nhanh o Gui qua test, cache 6 gio (doi TemplateAlllist.xml la dung lai).
     * Moi dong: [id, ten (theo client), cat, sex, q, lv, atk, def, agi, luck, cs, moTa, chuoi tim (ten client + ten DB), MaxCount].
     * Lan dau mat vai giay (kiem anh ~19k mon).
     */
    public static function tatCaDungDuoc(): array
    {
        $mt = (int)@filemtime(self::CLIENT_XML);
        return Cache::remember('vp_dungduoc9_' . $mt . '_' . (int)@filemtime(self::PET_XML) . '_' . (int)@filemtime(self::VO_DUNG_JSON), 21600, function () {
            $rows = DB::connection('sqlsrv_tank41')->select("SELECT TemplateID,Name,CategoryID,Pic,NeedSex,Quality,NeedLevel,Attack,Defence,Agility,Luck,CanStrengthen,MaxCount,CAST(Description AS nvarchar(200)) Description FROM Db_Tank.dbo.Shop_Goods ORDER BY TemplateID");
            $bac = self::banBac();
            $tenC = self::tenClient();
            $out = [];
            foreach ($rows as $x) {
                if (!self::dungDuoc($x) || isset($bac[(int)$x->TemplateID])) continue;
                $ten = $tenC[(int)$x->TemplateID] ?? trim((string)$x->Name);
                $out[] = [(int)$x->TemplateID, $ten, (int)$x->CategoryID, (int)$x->NeedSex, (int)$x->Quality, (int)$x->NeedLevel,
                    (int)$x->Attack, (int)$x->Defence, (int)$x->Agility, (int)$x->Luck, (bool)$x->CanStrengthen, mb_substr((string)$x->Description, 0, 120),
                    $ten . ' | ' . trim((string)$x->Name), max(1, (int)$x->MaxCount)];
            }
            return $out;
        });
    }

    /**
     * [TemplateID => 1] cac ban BAC cua vu khi: cuong hoa toi moc thi game tu doi sang ma moi + hinh moi
     * (Item_Strengthen_Goods.GainEquip: +10/+11 bac 1, +12 bac 2, +15 bac 3) va ban dat vang (GoldEquipTemplateLoad.NewTemplateId).
     * Gui qua test chi cho chon BAN GOC (chu server chot 22/10): moi mon vao game la +0 (GameMail::send) nen gui ban bac
     * se thanh "hinh +12 ma ghi +0"; tiem ren dang 100% nen nguoi choi tu cuong hoa len bac. Ban dac biet khong cay ra duoc
     * (Hoang kim vu, Chien than...) khong nam trong 2 bang nay nen van hien. Admin > Gui qua van thay du.
     */
    public static function banBac(): array
    {
        return Cache::remember('vp_banbac2', 21600, function () {
            $t = DB::connection('sqlsrv_tank41');
            $ds = [];
            foreach ($t->select("SELECT DISTINCT GainEquip i FROM Db_Tank.dbo.Item_Strengthen_Goods WHERE GainEquip <> OrginEquip") as $r) $ds[(int)$r->i] = 1;
            foreach ($t->select("SELECT DISTINCT NewTemplateId i FROM Db_Tank.dbo.GoldEquipTemplateLoad WHERE NewTemplateId <> OldTemplateId AND NewTemplateId > 0") as $r) $ds[(int)$r->i] = 1;
            // ban KHOA tiem ren (CanStrengthen=0) cua vu khi co ban cung ten (bo dau *) cuong hoa duoc -> chi de ban lam duoc viec
            // (chu server 22/10): 70244 Hoang kim vu / 70245 Hoang Kim Vu*, 70274 Chien than / 70275 Chien than*,
            // 70246/70266/70276 SUPER-...* (bac 2 khoa) / ban goc 7024/7026/7027. Ten theo client (DB co the khac).
            $tenC = self::tenClient();
            $nhom = [];
            foreach ($t->select("SELECT TemplateID, CanStrengthen FROM Db_Tank.dbo.Shop_Goods WHERE CategoryID IN (7, 27)") as $r) {
                $ten = $tenC[(int)$r->TemplateID] ?? null;
                if ($ten === null) continue;
                $k = mb_strtolower(trim(rtrim(trim($ten), '*')), 'UTF-8');
                $nhom[$k][(int)$r->TemplateID] = (bool)$r->CanStrengthen;
            }
            foreach ($nhom as $ma) if (in_array(true, $ma, true)) foreach ($ma as $id => $cuong) if (!$cuong) $ds[$id] = 1;
            return $ds;
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
            50 => 'Vũ khí thú', 51 => 'Mũ thú', 52 => 'Áo thú',
            // dat ten theo mon ben trong (client chi co hang so cho 36 VEGETABLE, 40 BADGE, 72 EXPLORER_MANUAL)
            36 => 'Nông sản', 40 => 'Huy hiệu', 43 => 'Quà khung nhân vật', 60 => 'Chiến hồn', 63 => 'Quà chế tạo',
            66 => 'Hộp thẻ quái', 72 => 'Sổ thám hiểm', 73 => 'Khung nhân vật', 80 => 'Thuốc ma pháp', 81 => 'Khoáng thạch'][$cat] ?? null;
    }

    /** [TemplateID => {Name, CategoryID, Pic, NeedSex, Quality}] */
    public static function thongTin(array $ids): array
    {
        $ids = array_values(array_unique(array_filter(array_map('intval', $ids))));
        if (!$ids) return [];
        $out = [];
        $rows = DB::connection('sqlsrv_tank41')->select("SELECT TemplateID,Name,CategoryID,Pic,NeedSex,Quality FROM Db_Tank.dbo.Shop_Goods WHERE TemplateID IN (" . implode(',', $ids) . ")");
        $tenC = self::tenClient();   // ten nguoi choi thay trong game (DB co the khac, vd 7024)
        foreach ($rows as $r) {
            if (isset($tenC[(int)$r->TemplateID])) $r->Name = $tenC[(int)$r->TemplateID];
            $out[(int)$r->TemplateID] = $r;
        }
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
        // co dau cach: client co anh ten "Legend Na Than-8bit" (200270), truoc day web chan nen hien o "?"
        if ($pic === '' || strpos($pic, '..') !== false || !preg_match('#^[A-Za-z0-9_\-/ ]+$#', $pic)) return null;
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
