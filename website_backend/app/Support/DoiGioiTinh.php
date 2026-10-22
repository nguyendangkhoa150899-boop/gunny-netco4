<?php

namespace App\Support;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

/**
 * Doi do theo gioi tinh: nhan vat dung The Bien Tinh (11569, ChangeSexHandler) chi lat Sex, do giu nguyen.
 * Do khac gioi dang mac van mac tiep, nhung thao ra la client chan mac lai ("Khong dong dang, khong the trang bi").
 * Gioi tinh xet theo CLIENT (TemplateAlllist.xml) vi client la ben chan; mon dich con phai dung gioi tinh trong DB.
 * Ghep cap (thu tu uu tien): bang ghep tay (bo NETCO4VIP) -> cung loai + cung ten bo chu nam/nu -> cung loai + cung chi so,
 * pham chat, cap, cuong hoa duoc. Thu tren client 22/10: ghep duoc 3.285 / 3.296 mon co gioi tinh.
 */
class DoiGioiTinh
{
    /** bo NETCO4VIP (_setup/sql/giftcode-vip-test.sql): ten khac nhau, chi so le nhau nen ghep tay */
    const GHEP_TAY = [60000042 => 60000062, 2310 => 2407, 6352 => 6410, 3533 => 3671, 4360 => 4627];

    private static $ds = null;

    /** [TemplateID => [ten, cat, sex, khoaTen, khoaChiSo]] lay tu XML client, cache theo ngay sua file */
    private static function ds(): array
    {
        if (self::$ds === null) {
            $mt = (int)@filemtime(VatPham::CLIENT_XML);
            self::$ds = !$mt ? [] : Cache::rememberForever('doigt_' . $mt, function () {
                $raw = @file_get_contents(VatPham::CLIENT_XML);
                $xml = $raw === false ? false : @gzuncompress($raw);
                if ($xml === false) return [];
                $out = [];
                preg_match_all('/<Item [^>]*>/', $xml, $m);
                foreach ($m[0] as $t) {
                    $g = function ($k) use ($t) { return preg_match('/ ' . $k . '="([^"]*)"/', $t, $x) ? html_entity_decode($x[1], ENT_QUOTES, 'UTF-8') : ''; };
                    $cat = (int)$g('CategoryID');
                    $out[(int)$g('TemplateID')] = [$g('Name'), $cat, (int)$g('NeedSex'), $cat . '|' . self::boGioiTinh($g('Name')),
                        implode('|', [$cat, $g('Attack'), $g('Defence'), $g('Agility'), $g('Luck'), $g('Quality'), $g('NeedLevel'), $g('CanStrengthen')])];
                }
                return $out;
            });
        }
        return self::$ds;
    }

    /** "Khai Hoan Khoi nam (S)" / "Hoang Long Khoi(nu)" / "Toc Hamster-Nu" -> ten chung */
    private static function boGioiTinh(string $ten): string
    {
        $s = mb_strtolower($ten, 'UTF-8');
        $s = preg_replace('/\((nam|nữ)\)/u', ' ', $s);
        $s = preg_replace('/(^|[\s\-_])(nam|nữ)(?=$|[\s\-_(])/u', ' ', $s);
        return trim(preg_replace('/[^\p{L}\p{N}]+/u', ' ', $s));
    }

    /** gioi tinh cua mon theo client: 0 ca hai (hoac client khong biet), 1 nam, 2 nu */
    public static function gioiTinh(int $tid): int
    {
        return self::ds()[$tid][2] ?? 0;
    }

    /** cac mon dich co the (chua kiem anh/DB), uu tien truoc */
    private static function ungVien(int $tid, int $gt): array
    {
        $ds = self::ds();
        $a = $ds[$tid] ?? null;
        if (!$a) return [];
        $tay = self::GHEP_TAY[$tid] ?? (array_flip(self::GHEP_TAY)[$tid] ?? null);
        $out = $tay ? [$tay] : [];
        $ten = []; $ten0 = []; $cs = [];
        foreach ($ds as $id => $b) {
            if ($id === $tid || $b[1] !== $a[1]) continue;
            if ($b[3] === $a[3]) {
                if ($b[2] === $gt) $ten[] = $id; elseif ($b[2] === 0) $ten0[] = $id;
            } elseif ($b[4] === $a[4] && $b[2] === $gt) $cs[] = $id;
        }
        // trong moi nhom: ID gan nhat truoc (ban nam/nu cua cung 1 bo thuong nam gan nhau)
        $gan = function ($x, $y) use ($tid) { return abs($x - $tid) <=> abs($y - $tid); };
        usort($ten, $gan); usort($ten0, $gan); usort($cs, $gan);
        return array_values(array_unique(array_merge($out, $ten, $ten0, $cs)));
    }

    /**
     * Mon thay the cho $tid voi nhan vat gioi tinh $gt (1 nam, 2 nu), null neu khong co.
     * Mon dich phai: dua vao game duoc (VatPham::trongClient), cung loai va dung gioi tinh ca o client lan DB (server doc DB).
     */
    public static function thayThe(int $tid, int $gt): ?int
    {
        $uv = array_slice(self::ungVien($tid, $gt), 0, 40);
        if (!$uv) return null;
        $db = [];
        foreach (DB::connection('sqlsrv_tank41')->select("SELECT TemplateID,CategoryID,NeedSex FROM Db_Tank.dbo.Shop_Goods WHERE TemplateID IN (" . implode(',', array_map('intval', $uv)) . ")") as $r)
            $db[(int)$r->TemplateID] = $r;
        $cat = self::ds()[$tid][1];
        foreach ($uv as $id) {
            $r = $db[$id] ?? null;
            if (!$r || (int)$r->CategoryID !== $cat || !in_array((int)$r->NeedSex, [0, $gt], true)) continue;
            if (!in_array(self::gioiTinh($id), [0, $gt], true) || !VatPham::trongClient($id)) continue;
            return $id;
        }
        return null;
    }
}
