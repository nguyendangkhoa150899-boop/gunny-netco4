<?php

namespace App\Http\Controllers;

use App\Models\Player;
use App\Support\CauHinh;
use App\Support\Diem;
use App\Support\GameMail;
use App\Support\VatPham;
use App\Support\XuWeb;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Mini game tren /dashboard, tien choi = xu web (App\Support\XuWeb). Bang: _setup/sql/minigame-web.sql.
 * Moi ket qua ngau nhien sinh o SERVER bang random_int (CSPRNG); trinh duyet chi nhan ket qua de dien hoat canh.
 * Khong co cong cu "ep ket qua" cho admin.
 */
class MiniGameController extends \App\Http\BaseController
{
    /** so la bai moi luot lat (3 hang x 7 nhu man lat bai trong game), lat 3 la */
    const SO_LA = 21;
    const SO_LAT = 3;

    private function mid(): int
    {
        return (int)auth()->user()->UserID;
    }

    private function mem()
    {
        return XuWeb::db();
    }

    /** nhan vat cua tai khoan (server nay moi tai khoan 1 nhan vat) */
    private function nhanVat()
    {
        return Player::select(['UserID', 'NickName', 'Sex'])->where('UserName', auth()->user()->Email)
            ->where('NickName', '<>', '')->orderBy('UserID')->first();
    }

    /** gioi tinh theo NeedSex cua Shop_Goods: 1 nam, 2 nu, 0 chua co nhan vat (Sys_Users_Detail.Sex: 1 nam, 0 nu) */
    private function gioiTinh($nv = null): int
    {
        $nv = $nv ?: $this->nhanVat();
        return $nv ? ((int)$nv->Sex === 1 ? 1 : 2) : 0;
    }

    private function soCuoc(Request $r, string $loai)
    {
        $cuoc = (int)$r->input('cuoc');
        $min = CauHinh::int($loai . '_min', 100);
        $max = CauHinh::int($loai . '_max', 1000000);
        if ($cuoc < $min || $cuoc > $max) return $this->error('Cược từ ' . number_format($min, 0, ',', '.') . ' đến ' . number_format($max, 0, ',', '.') . ' xu web.');
        return $cuoc;
    }

    /* ======================= VI ======================= */

    /**
     * Rut xu game ra web: nguoi choi GUI THU KEM XU cho nhan vat rut_ten (NganHang) trong game. Game tu tru xu (an toan ca khi online).
     * Ham nay quet thu gui toi NganHang cua nhan vat nay: xoa thu (1 lan duy nhat) -> ghi Web_RutXu -> cong xu web theo rut_tile.
     * Vuot rut_tran_ngay thi thu de nguyen, sang ngay sau tu xu ly tiep. Goi moi khi mo Vi (trang tu goi lai moi 10 giay).
     */
    private function nhanXuNganHang(int $mid, $nv): array
    {
        $kq = ['nhan' => [], 'cho' => 0, 'choXu' => 0, 'daRutHomNay' => 0];
        if (!$nv || CauHinh::int('rut_mo', 1) !== 1) return $kq;
        $bank = $this->mem()->selectOne("SELECT UserID FROM Db_Tank41.dbo.Sys_Users_Detail WHERE NickName=?", [CauHinh::get('rut_ten', 'NganHang')]);
        if (!$bank) return $kq;
        $tile = max(1, CauHinh::float('rut_tile', 1));
        $tran = CauHinh::int('rut_tran_ngay', 2000000);
        $gid = (int)$nv->UserID;
        $this->mem()->transaction(function () use ($mid, $gid, $bank, $tile, $tran, &$kq) {
            $da = (int)$this->mem()->selectOne("SELECT ISNULL(SUM(XuGame),0) n FROM Web_RutXu WITH (UPDLOCK,HOLDLOCK) WHERE MemberID=? AND ThoiGian>=CAST(GETDATE() AS date)", [$mid])->n;
            $thu = $this->mem()->select("SELECT ID, Money FROM Db_Tank41.dbo.User_Messages WITH (UPDLOCK,ROWLOCK)
                WHERE ReceiverID=? AND SenderID=? AND Type=1 AND Money>0 AND ISNULL(Annex1,'')='' AND ISNULL(Annex2,'')='' AND ISNULL(Annex3,'')=''
                  AND ISNULL(Annex4,'')='' AND ISNULL(Annex5,'')='' ORDER BY ID", [(int)$bank->UserID, $gid]);
            foreach ($thu as $t) {
                $xu = (int)$t->Money;
                if ($da + $xu > $tran) { $kq['cho']++; $kq['choXu'] += $xu; continue; }
                if ($this->mem()->delete("DELETE FROM Db_Tank41.dbo.User_Messages WHERE ID=?", [(int)$t->ID]) !== 1) continue;
                $web = (int)floor($xu / $tile);
                $this->mem()->insert("INSERT INTO Web_RutXu(MemberID,GameUserID,MailID,XuGame,XuWeb) VALUES(?,?,?,?,?)", [$mid, $gid, (int)$t->ID, $xu, $web]);
                if ($web > 0) XuWeb::doi($mid, $web, 'rutxu', 'Rút ' . number_format($xu, 0, ',', '.') . ' xu từ game');
                $da += $xu;
                $kq['nhan'][] = ['xuGame' => $xu, 'xuWeb' => $web];
            }
            $kq['daRutHomNay'] = $da;
        });
        return $kq;
    }

    public function vi()
    {
        $mid = $this->mid();
        $nv = $this->nhanVat();
        $rut = $this->nhanXuNganHang($mid, $nv);
        $ls = $this->mem()->select("SELECT TOP 40 Delta,SoDu,Loai,GhiChu,ThoiGian FROM Web_SoXu WHERE MemberID=? ORDER BY ID DESC", [$mid]);
        $sv = $this->mem()->selectOne("SELECT TOP 1 ServerID ID FROM Server_List ORDER BY ServerID");
        return $this->success('ok', [
            'rut' => $rut + ['mo' => CauHinh::int('rut_mo', 1), 'ten' => CauHinh::get('rut_ten', 'NganHang'),
                'tile' => CauHinh::float('rut_tile', 1), 'tran' => CauHinh::int('rut_tran_ngay', 2000000)],
            'soDu' => XuWeb::soDu($mid),
            'lichSu' => array_map(function ($x) {
                return ['d' => (int)$x->Delta, 'sd' => (int)$x->SoDu, 'loai' => $x->Loai, 'gc' => $x->GhiChu, 'tg' => substr((string)$x->ThoiGian, 0, 16)];
            }, $ls),
            'serverId' => $sv ? (int)$sv->ID : 0,
            'playerId' => $nv ? (int)$nv->UserID : 0,
            'diem' => Diem::soDu($mid),
            'quaTest' => CauHinh::int('quatest_mo', 0),
            'lichSuDiem' => array_map(function ($x) {
                return ['d' => (int)$x->Delta, 'loai' => $x->Loai, 'gc' => $x->GhiChu, 'tg' => substr((string)$x->ThoiGian, 0, 16)];
            }, $this->mem()->select("SELECT TOP 20 Delta,Loai,GhiChu,ThoiGian FROM Web_SoDiem WHERE MemberID=? ORDER BY ID DESC", [$mid])),
        ]);
    }

    /* ======================= SHOP WEB ======================= */
    // 2 loai tien: 'xu' = xu web (XuWeb), 'diem' = diem hoat dong (Diem). Do vao Ruong web. Bang: _setup/sql/shop-web.sql

    /** so luong da mua cua 1 mon trong khoang (ngay / 7 ngay / tron doi) */
    private function daMua(int $mid, int $sid): array
    {
        $r = $this->mem()->selectOne("SELECT
            ISNULL(SUM(CASE WHEN ThoiGian>=CAST(GETDATE() AS date) THEN SoLuong END),0) ngay,
            ISNULL(SUM(CASE WHEN ThoiGian>=DATEADD(day,-7,GETDATE()) THEN SoLuong END),0) tuan,
            ISNULL(SUM(SoLuong),0) tong FROM Web_ShopMua WHERE MemberID=? AND ShopID=?", [$mid, $sid]);
        return ['ngay' => (int)$r->ngay, 'tuan' => (int)$r->tuan, 'tong' => (int)$r->tong];
    }

    /** con mua duoc toi da bao nhieu (null = khong gioi han) */
    private static function conMua($h, array $da)
    {
        $con = null;
        foreach (['GioiHanNgay' => 'ngay', 'GioiHanTuan' => 'tuan', 'GioiHanTong' => 'tong'] as $cot => $k) {
            if ($h->$cot !== null) $con = min($con ?? PHP_INT_MAX, max(0, (int)$h->$cot - $da[$k]));
        }
        if ($h->Kho !== null) $con = min($con ?? PHP_INT_MAX, max(0, (int)$h->Kho));
        return $con;
    }

    public function shop()
    {
        $mid = $this->mid();
        $rows = $this->mem()->select("SELECT * FROM Web_Shop WHERE BatTat=1 AND (BatDau IS NULL OR BatDau<=GETDATE()) AND (KetThuc IS NULL OR KetThuc>GETDATE()) ORDER BY Tien DESC, ThuTu, ID");
        $tt = VatPham::thongTin(array_map(function ($x) { return (int)$x->TemplateID; }, $rows));
        $ds = array_map(function ($h) use ($mid, $tt) {
            $i = $tt[(int)$h->TemplateID] ?? null;
            $da = $this->daMua($mid, (int)$h->ID);
            return ['id' => (int)$h->ID, 'ke' => $h->Ke, 'ten' => ($i->Name ?? ('Vật phẩm ' . $h->TemplateID)) . ((int)$h->Count > 1 ? ' x' . $h->Count : '') . ((int)$h->StrengthenLevel ? ' +' . $h->StrengthenLevel : ''),
                'hinh' => '/hinh/' . (int)$h->TemplateID, 'mau' => VatPham::mau((int)($i->Quality ?? 0)), 'q' => (int)($i->Quality ?? 0),
                'tien' => $h->Tien, 'gia' => (int)$h->Gia, 'han' => (int)$h->ValidDate, 'khoa' => (bool)$h->IsBind, 'moTa' => $h->MoTa,
                'gh' => ['ngay' => $h->GioiHanNgay, 'tuan' => $h->GioiHanTuan, 'tong' => $h->GioiHanTong], 'da' => $da,
                'kho' => $h->Kho === null ? null : (int)$h->Kho, 'con' => self::conMua($h, $da),
                'ketThuc' => $h->KetThuc ? substr((string)$h->KetThuc, 0, 16) : null];
        }, $rows);
        return $this->success('ok', ['ds' => $ds, 'xu' => XuWeb::soDu($mid), 'diem' => Diem::soDu($mid), 'mo' => CauHinh::int('shop_mo', 1)]);
    }

    public function shopMua(Request $r)
    {
        if (CauHinh::int('shop_mo', 1) !== 1) return $this->error('Shop đang tạm đóng.');
        $mid = $this->mid();
        $sid = (int)$r->input('id');
        $sl = max(1, min(99, (int)$r->input('sl', 1)));
        $out = null;
        try {
            $this->mem()->transaction(function () use ($mid, $sid, $sl, &$out) {
                $h = $this->mem()->selectOne("SELECT * FROM Web_Shop WITH (UPDLOCK,ROWLOCK) WHERE ID=? AND BatTat=1 AND (BatDau IS NULL OR BatDau<=GETDATE()) AND (KetThuc IS NULL OR KetThuc>GETDATE())", [$sid]);
                if (!$h) { $out = 'Món này không còn bán.'; return; }
                // khoa theo nguoi mua de 2 lan bam cung luc khong vuot gioi han
                $this->mem()->select("SELECT TOP 1 ID FROM Web_ShopMua WITH (UPDLOCK,HOLDLOCK) WHERE MemberID=? AND ShopID=?", [$mid, $sid]);
                $con = self::conMua($h, $this->daMua($mid, $sid));
                if ($con !== null && $sl > $con) { $out = $con > 0 ? ('Bạn chỉ mua thêm được ' . $con . ' món này.') : ($h->Kho !== null && (int)$h->Kho <= 0 ? 'Hết hàng.' : 'Đã đạt giới hạn mua món này.'); return; }
                $tong = (int)$h->Gia * $sl;
                $tt = VatPham::thongTin([(int)$h->TemplateID])[(int)$h->TemplateID] ?? null;
                $ten = $tt->Name ?? ('Vật phẩm ' . $h->TemplateID);
                $con2 = $h->Tien === 'diem' ? Diem::doi($mid, -$tong, 'shop', 'Mua ' . $ten . ' x' . $sl) : XuWeb::doi($mid, -$tong, 'shop', 'Mua ' . $ten . ' x' . $sl);
                if ($con2 === null) { $out = $h->Tien === 'diem' ? 'Không đủ điểm hoạt động.' : 'Không đủ xu web.'; return; }
                if ($h->Kho !== null) $this->mem()->update("UPDATE Web_Shop SET Kho=Kho-? WHERE ID=?", [$sl, $sid]);
                $this->mem()->insert("INSERT INTO Web_ShopMua(MemberID,ShopID,SoLuong,Tien,Gia) VALUES(?,?,?,?,?)", [$mid, $sid, $sl, $h->Tien, (int)$h->Gia]);
                $this->vaoRuong($mid, (int)$h->TemplateID, max(1, (int)$h->Count) * $sl, (int)$h->ValidDate, (int)$h->StrengthenLevel, (bool)$h->IsBind, 'Shop web');
                $out = ['ten' => $ten, 'sl' => $sl, 'tong' => $tong, 'tien' => $h->Tien];
            });
        } catch (\Throwable $e) {
            return $this->error('Có lỗi khi mua, chưa trừ tiền. Thử lại sau.');
        }
        if (!is_array($out)) return $this->error($out ?: 'Có lỗi xảy ra.');
        return $this->success('Đã mua ' . $out['ten'] . ' x' . $out['sl'] . ', đồ đã vào Rương web.', $out + ['xu' => XuWeb::soDu($mid), 'diem' => Diem::soDu($mid)]);
    }

    /* ======================= TAI XIU ======================= */
    // 3 xuc xac, tong 11-17 Tai, 4-10 Xiu, BAO (3 vien giong nhau) = ca 2 cua thua. Thang nhan cuoc x tx_heso (mac dinh 1.95).
    // Nha cai ~5,2%: 105/216 x 1.95 = 0.948.

    public function taiXiu(Request $r)
    {
        $cua = $r->input('cua');
        if (!in_array($cua, ['tai', 'xiu'], true)) return $this->error('Chọn Tài hoặc Xỉu.');
        $cuoc = $this->soCuoc($r, 'tx');
        if (!is_int($cuoc)) return $cuoc;
        $mid = $this->mid();
        $heso = CauHinh::float('tx_heso', 1.95);
        $out = null;
        $this->mem()->transaction(function () use ($mid, $cua, $cuoc, $heso, &$out) {
            if (XuWeb::doi($mid, -$cuoc, 'taixiu', 'Cược ' . ($cua === 'tai' ? 'Tài' : 'Xỉu')) === null) { $out = 'thieu'; return; }
            $x = [random_int(1, 6), random_int(1, 6), random_int(1, 6)];
            $tong = array_sum($x);
            $bao = $x[0] === $x[1] && $x[1] === $x[2];
            $kq = $bao ? 'bao' : ($tong >= 11 ? 'tai' : 'xiu');
            $nhan = $kq === $cua ? (int)floor($cuoc * $heso) : 0;
            $soDu = $nhan > 0 ? XuWeb::doi($mid, $nhan, 'taixiu', 'Thắng ' . ($cua === 'tai' ? 'Tài' : 'Xỉu') . ' (' . $tong . ')') : XuWeb::soDu($mid);
            $this->mem()->insert("INSERT INTO Web_TaiXiu(MemberID,Cua,Cuoc,X1,X2,X3,Nhan) VALUES(?,?,?,?,?,?,?)", [$mid, $cua, $cuoc, $x[0], $x[1], $x[2], $nhan]);
            $out = ['xx' => $x, 'tong' => $tong, 'kq' => $kq, 'nhan' => $nhan, 'cuoc' => $cuoc, 'soDu' => $soDu];
        });
        if ($out === 'thieu') return $this->error('Không đủ xu web.');
        return $this->success('ok', $out);
    }

    public function taiXiuLichSu()
    {
        $rows = $this->mem()->select("SELECT TOP 20 Cua,Cuoc,X1,X2,X3,Nhan,ThoiGian FROM Web_TaiXiu WHERE MemberID=? ORDER BY ID DESC", [$this->mid()]);
        return $this->success('ok', ['ds' => array_map(function ($x) {
            return ['cua' => $x->Cua, 'cuoc' => (int)$x->Cuoc, 'xx' => [(int)$x->X1, (int)$x->X2, (int)$x->X3], 'nhan' => (int)$x->Nhan, 'tg' => substr((string)$x->ThoiGian, 11, 5)];
        }, $rows), 'heso' => CauHinh::float('tx_heso', 1.95), 'min' => CauHinh::int('tx_min', 100), 'max' => CauHinh::int('tx_max', 1000000)]);
    }

    /* ======================= DO MIN ======================= */
    // 25 o, chon so min 1-24. Mo k o an toan: he so = dm_rtp * tich (25-i)/(25-min-i), toi da dm_tran.

    private static function heSo(int $k, int $soMin, float $rtp, float $tran): float
    {
        if ($k <= 0) return 0;
        $p = 1.0;
        for ($i = 0; $i < $k; $i++) $p *= (25 - $i) / (25 - $soMin - $i);
        return min($tran, floor($rtp * $p * 100) / 100);
    }

    private function vanMin($row, bool $loMin = false): array
    {
        $rtp = CauHinh::float('dm_rtp', 0.95);
        $tran = CauHinh::float('dm_tran', 50);
        $mo = $row->DaMo === '' ? [] : array_map('intval', explode(',', $row->DaMo));
        $k = count($mo);
        $hs = self::heSo($k, (int)$row->SoMin, $rtp, $tran);
        $con = 25 - (int)$row->SoMin - $k;
        return [
            'id' => (int)$row->ID, 'cuoc' => (int)$row->Cuoc, 'soMin' => (int)$row->SoMin, 'mo' => $mo, 'trangThai' => (int)$row->TrangThai,
            'heSo' => $hs, 'heSoTiep' => $con > 0 ? self::heSo($k + 1, (int)$row->SoMin, $rtp, $tran) : null,
            'rut' => (int)floor((int)$row->Cuoc * $hs), 'nhan' => (int)$row->Nhan,
            'min' => ($loMin || (int)$row->TrangThai !== 0) ? array_map('intval', explode(',', $row->Min)) : null,
        ];
    }

    /** van dang mo qua 2 gio: tu rut tien theo he so hien tai (khong mo o nao thi tra lai cuoc) */
    private function dongVanCu(int $mid): void
    {
        $cu = $this->mem()->select("SELECT * FROM Web_DoMin WHERE MemberID=? AND TrangThai=0 AND ThoiGian<DATEADD(hour,-2,GETDATE())", [$mid]);
        foreach ($cu as $v) $this->ketThucMin($mid, (int)$v->ID, true);
    }

    private function ketThucMin(int $mid, int $id, bool $tuDong = false)
    {
        $res = null;
        $this->mem()->transaction(function () use ($mid, $id, $tuDong, &$res) {
            $v = $this->mem()->selectOne("SELECT * FROM Web_DoMin WITH (UPDLOCK,ROWLOCK) WHERE ID=? AND MemberID=? AND TrangThai=0", [$id, $mid]);
            if (!$v) return;
            $info = $this->vanMin($v);
            $nhan = $info['mo'] ? $info['rut'] : (int)$v->Cuoc;
            if ($nhan > 0) XuWeb::doi($mid, $nhan, 'domin', ($tuDong ? 'Tự rút ván cũ' : 'Rút tiền') . ' x' . $info['heSo']);
            $this->mem()->update("UPDATE Web_DoMin SET TrangThai=1,Nhan=?,KetThuc=GETDATE() WHERE ID=?", [$nhan, $id]);
            $v->TrangThai = 1; $v->Nhan = $nhan;
            $res = $this->vanMin($v, true);
        });
        return $res;
    }

    public function doMin()
    {
        $mid = $this->mid();
        $this->dongVanCu($mid);
        $v = $this->mem()->selectOne("SELECT TOP 1 * FROM Web_DoMin WHERE MemberID=? AND TrangThai=0 ORDER BY ID DESC", [$mid]);
        return $this->success('ok', ['van' => $v ? $this->vanMin($v) : null, 'soDu' => XuWeb::soDu($mid),
            'min' => CauHinh::int('dm_min', 100), 'max' => CauHinh::int('dm_max', 1000000)]);
    }

    public function doMinBatDau(Request $r)
    {
        $cuoc = $this->soCuoc($r, 'dm');
        if (!is_int($cuoc)) return $cuoc;
        $soMin = (int)$r->input('soMin');
        if ($soMin < 1 || $soMin > 24) return $this->error('Số mìn từ 1 đến 24.');
        $mid = $this->mid();
        $this->dongVanCu($mid);
        $out = null;
        $this->mem()->transaction(function () use ($mid, $cuoc, $soMin, &$out) {
            if ($this->mem()->selectOne("SELECT TOP 1 ID FROM Web_DoMin WITH (UPDLOCK) WHERE MemberID=? AND TrangThai=0", [$mid])) { $out = 'dangchoi'; return; }
            if (XuWeb::doi($mid, -$cuoc, 'domin', 'Cược dò mìn (' . $soMin . ' mìn)') === null) { $out = 'thieu'; return; }
            $o = range(0, 24);
            for ($i = 24; $i > 0; $i--) { $j = random_int(0, $i); [$o[$i], $o[$j]] = [$o[$j], $o[$i]]; }
            $min = array_slice($o, 0, $soMin);
            sort($min);
            $id = (int)$this->mem()->selectOne("SET NOCOUNT ON; INSERT INTO Web_DoMin(MemberID,Cuoc,SoMin,Min) OUTPUT inserted.ID id VALUES(?,?,?,?)", [$mid, $cuoc, $soMin, implode(',', $min)])->id;
            $out = $this->vanMin($this->mem()->selectOne("SELECT * FROM Web_DoMin WHERE ID=?", [$id]));
        });
        if ($out === 'dangchoi') return $this->error('Bạn đang có ván chưa xong.');
        if ($out === 'thieu') return $this->error('Không đủ xu web.');
        return $this->success('ok', ['van' => $out, 'soDu' => XuWeb::soDu($mid)]);
    }

    public function doMinMo(Request $r)
    {
        $o = (int)$r->input('o');
        $id = (int)$r->input('id');
        if ($o < 0 || $o > 24) return $this->error('Ô không hợp lệ.');
        $mid = $this->mid();
        $out = null;
        $this->mem()->transaction(function () use ($mid, $id, $o, &$out) {
            $v = $this->mem()->selectOne("SELECT * FROM Web_DoMin WITH (UPDLOCK,ROWLOCK) WHERE ID=? AND MemberID=? AND TrangThai=0", [$id, $mid]);
            if (!$v) { $out = 'het'; return; }
            $min = array_map('intval', explode(',', $v->Min));
            $mo = $v->DaMo === '' ? [] : array_map('intval', explode(',', $v->DaMo));
            if (in_array($o, $mo, true)) { $out = $this->vanMin($v); return; }
            if (in_array($o, $min, true)) {
                $this->mem()->update("UPDATE Web_DoMin SET TrangThai=2,KetThuc=GETDATE() WHERE ID=?", [$id]);
                $v->TrangThai = 2;
                $out = $this->vanMin($v, true) + ['no' => $o];
                return;
            }
            $mo[] = $o;
            $v->DaMo = implode(',', $mo);
            $this->mem()->update("UPDATE Web_DoMin SET DaMo=? WHERE ID=?", [$v->DaMo, $id]);
            $out = $this->vanMin($v);
        });
        if ($out === 'het') return $this->error('Ván đã kết thúc.');
        // mo het o an toan: tu rut
        if ($out['trangThai'] === 0 && $out['heSoTiep'] === null) $out = $this->ketThucMin($mid, $id);
        return $this->success('ok', ['van' => $out, 'soDu' => XuWeb::soDu($mid)]);
    }

    public function doMinRut(Request $r)
    {
        $mid = $this->mid();
        $id = (int)$r->input('id');
        $v = $this->mem()->selectOne("SELECT DaMo FROM Web_DoMin WHERE ID=? AND MemberID=? AND TrangThai=0", [$id, $mid]);
        if (!$v) return $this->error('Ván đã kết thúc.');
        if ($v->DaMo === '') return $this->error('Mở ít nhất 1 ô rồi mới rút được.');
        $out = $this->ketThucMin($mid, $id);
        if (!$out) return $this->error('Ván đã kết thúc.');
        return $this->success('ok', ['van' => $out, 'soDu' => XuWeb::soDu($mid)]);
    }

    /* ======================= LAT THE SAU PHO BAN ======================= */

    /** doc Sys_Users_Log (WinMission) moi -> thang ai cuoi cua pho ban dang bat -> tao luot lat (trong gioi han ngay) */
    private function quetPhoBan(int $mid, int $gid): void
    {
        if (CauHinh::int('lt_mo', 1) !== 1) return;
        $tank = DB::connection('sqlsrv_tank41');
        $q = $this->mem()->selectOne("SELECT LogID FROM Web_The_Quet WHERE GameUserID=?", [$gid]);
        $last = $q ? (int)$q->LogID : 0;
        $logs = $tank->select("SELECT TOP 200 ID, Content, TimeCreate FROM Sys_Users_Log WHERE UserID=? AND Type='WinMission' AND ID>? AND TimeCreate>=DATEADD(day,-1,GETDATE()) ORDER BY ID", [$gid, $last]);
        $max = $last;
        $macDinh = CauHinh::int('lt_solan', 3);
        foreach ($logs as $l) {
            $max = max($max, (int)$l->ID);
            $pb = $this->mem()->selectOne("SELECT p.Khoa, ISNULL(p.SoLanNgay,?) SoLan FROM Web_The_Man m JOIN Web_The_PhoBan p ON p.Khoa=m.Khoa
                WHERE m.MissionId=? AND p.ManCuoi=m.MissionId AND p.BatTat=1", [$macDinh, (int)$l->Content]);
            if (!$pb) continue;
            $ngay = substr((string)$l->TimeCreate, 0, 10);
            $da = (int)$this->mem()->selectOne("SELECT COUNT(*) n FROM Web_The_Luot WHERE GameUserID=? AND Khoa=? AND Ngay=?", [$gid, $pb->Khoa, $ngay])->n;
            if ($da >= (int)$pb->SoLan) continue;
            try {
                $this->mem()->insert("INSERT INTO Web_The_Luot(MemberID,GameUserID,LogID,Khoa,MissionId,Bai,ThoiGian,Ngay) VALUES(?,?,?,?,?,?,?,?)",
                    [$mid, $gid, (int)$l->ID, $pb->Khoa, (int)$l->Content, '[]', $l->TimeCreate, $ngay]);
            } catch (\Throwable $e) { continue; /* LogID da co luot */ }
            // diem hoat dong: moi lan thang boss (moi luot lat) +diem_phoban, tran diem_phoban_tran/ngay
            $cong = min(CauHinh::int('diem_phoban', 5), CauHinh::int('diem_phoban_tran', 50) - Diem::homNay($mid, 'phoban'));
            if ($cong > 0) Diem::doi($mid, $cong, 'phoban', 'Thắng ' . $pb->Khoa);
        }
        if ($max > $last) {
            $this->mem()->statement("MERGE Web_The_Quet t USING (SELECT ? g, ? l) s ON t.GameUserID=s.g WHEN MATCHED THEN UPDATE SET LogID=s.l WHEN NOT MATCHED THEN INSERT(GameUserID,LogID) VALUES(s.g,s.l);", [$gid, $max]);
        }
    }

    /**
     * La bai chi la UI: qua chi duoc quay (theo trong so) LUC BAM LAT, truoc do khong co du lieu nao.
     * Bo qua rieng cua pho ban, khong co thi dung bo qua chung (Khoa NULL). Mon hiem = trong so nho.
     */
    private function boQua(string $khoa): array
    {
        $pool = $this->mem()->select("SELECT * FROM Web_The_Qua WHERE Khoa=? AND TrongSo>0", [$khoa]);
        return $pool ?: $this->mem()->select("SELECT * FROM Web_The_Qua WHERE Khoa IS NULL AND TrongSo>0");
    }

    private function quayLa(array $pool): array
    {
        $tong = array_sum(array_map(function ($x) { return (int)$x->TrongSo; }, $pool));
        $x = null;
        if ($tong > 0) {
            $r = random_int(1, $tong);
            foreach ($pool as $p) { $r -= (int)$p->TrongSo; if ($r <= 0) { $x = $p; break; } }
        }
        // bo qua rong (admin xoa het): 100 xu web cho khoi trang tay
        return $x ? ['t' => (int)$x->TemplateID, 'c' => (int)$x->Count, 'v' => (int)$x->ValidDate, 's' => (int)$x->StrengthenLevel, 'b' => (int)$x->IsBind, 'x' => (int)$x->XuWeb]
                  : ['t' => 0, 'c' => 1, 'v' => 0, 's' => 0, 'b' => 1, 'x' => 100];
    }

    /* ---- quay qua Y HET GAME (PVEGame.TakeCard -> DropInventory.CopyDrop) ----
     * Drop_Condiction CondictionType=5 (Copy), Para1 chua ",<ma man>,", Para2 chua ",1," -> DropId (lay dong dau tien nhu DropMgr.FindCondiction).
     * Drop_Item cua DropId: nguong = rand[0, Random lon nhat), giu cac mon Random >= nguong, chon deu 1 mon; so luong rand[BeginData, EndData).
     * ItemId -100 = vang, -200 = xu game (ShopMgr.FindSpecialItemInfo) -> gui thu game. Tien te khac web khong gui duoc -> quay lai.
     * Ai boss khong co bang thi lay bang ai khac cung pho ban; khong co nua thi bo qua web (Web_The_Qua). lt_nguon='web' de chi dung bo qua web. */
    private $dropCache = [];

    private function dropIdCua(int $mission, string $khoa): int
    {
        $k = $mission . '|' . $khoa;
        if (isset($this->dropCache[$k])) return $this->dropCache[$k];
        // chi lay bang CO DO (113 khai bao loai 5 nhung 17 bang rong, vd Vong Xoay Thuong/Kho/AH 10180-10188 = 0 mon)
        $coDo = "EXISTS (SELECT 1 FROM Db_Tank.dbo.Drop_Item i WHERE i.DropId=c.DropID)";
        $mem = $this->mem();
        // 1-2. chinh ai boss: bang la bai (Para2 1), roi bang ruong boss (Para2 2)
        $r = $mem->selectOne("SELECT TOP 1 c.DropID FROM Db_Tank.dbo.Drop_Condiction c WHERE c.CondictionType=5 AND c.Para1 LIKE ? AND $coDo
            ORDER BY CASE WHEN c.Para2 LIKE '%,1,%' THEN 0 ELSE 1 END, c.DropID", ['%,' . $mission . ',%']);
        // 3. ai khac cung pho ban (ai cao truoc)
        if (!$r) $r = $mem->selectOne("SELECT TOP 1 c.DropID FROM Web_The_Man m JOIN Db_Tank.dbo.Drop_Condiction c
            ON c.CondictionType=5 AND c.Para1 LIKE '%,'+CAST(m.MissionId AS varchar(12))+',%' WHERE m.Khoa=? AND $coDo
            ORDER BY CASE WHEN c.Para2 LIKE '%,1,%' THEN 0 ELSE 1 END, m.Ai DESC, m.MissionId DESC", [$khoa]);
        // 4. cung pho ban o do kho khac (vd "Vong Xoay Thoi Gian Thuong" -> bang boss "Vong Xoay Thoi Gian" de)
        if (!$r) {
            $goc = preg_replace('/\s+(dễ|thường|khó|anh hùng|ah|ác mộng)(\s+ải)?$/iu', '', trim($khoa));
            if ($goc !== '' && $goc !== $khoa) {
                $r = $mem->selectOne("SELECT TOP 1 c.DropID FROM Web_The_Man m JOIN Db_Tank.dbo.Drop_Condiction c
                    ON c.CondictionType=5 AND c.Para1 LIKE '%,'+CAST(m.MissionId AS varchar(12))+',%' WHERE (m.Khoa=? OR m.Khoa LIKE ?) AND $coDo
                    ORDER BY CASE WHEN c.Para2 LIKE '%,1,%' THEN 0 ELSE 1 END, m.Ai DESC, m.MissionId DESC", [$goc, $goc . ' %']);
            }
        }
        return $this->dropCache[$k] = $r ? (int)$r->DropID : 0;
    }

    private function quayLaGame(int $dropId): ?array
    {
        static $cache = [];
        if (!isset($cache[$dropId])) $cache[$dropId] = DB::connection('sqlsrv_tank41')->select("SELECT ItemId,Random,BeginData,EndData,ValueDate,IsBind,IsTips FROM Db_Tank.dbo.Drop_Item WHERE DropId=?", [$dropId]);
        $ds = $cache[$dropId];
        if (!$ds) return null;
        $max = max(array_map(function ($x) { return (int)$x->Random; }, $ds));
        if ($max <= 0) return null;
        for ($thu = 0; $thu < 8; $thu++) {
            $nguong = random_int(0, $max - 1);
            $loc = array_values(array_filter($ds, function ($x) use ($nguong) { return (int)$x->Random >= $nguong; }));
            if (!$loc) continue;
            $x = $loc[random_int(0, count($loc) - 1)];
            $a = (int)$x->BeginData; $b = (int)$x->EndData;
            $sl = max(1, $b > $a ? random_int($a, $b - 1) : $a);
            $id = (int)$x->ItemId;
            // vang (-100) / xu game (-200) trong bang game: quy thanh XU WEB cong vao vi (tien cua shop web), ty le lt_vang_xuweb / 1:1
            if ($id === -100) return ['t' => 0, 'c' => 1, 'v' => 0, 's' => 0, 'b' => 1, 'x' => (int)round($sl * CauHinh::float('lt_vang_xuweb', 1)), 'g' => 0, 'm' => 0, 'tip' => (int)$x->IsTips];
            if ($id === -200) return ['t' => 0, 'c' => 1, 'v' => 0, 's' => 0, 'b' => 1, 'x' => $sl, 'g' => 0, 'm' => 0, 'tip' => (int)$x->IsTips];
            if ($id <= 0) continue;
            $i = VatPham::thongTin([$id])[$id] ?? null;
            if (!VatPham::dungDuoc($i)) continue;   // client khong biet / khong co anh -> quay lai
            return ['t' => $id, 'c' => $sl, 'v' => (int)$x->ValueDate, 's' => 0, 'b' => (int)$x->IsBind, 'x' => 0, 'g' => 0, 'm' => 0, 'tip' => (int)$x->IsTips];
        }
        return null;
    }

    /** 1 la: bang roi do cua game (mac dinh), khong co thi bo qua web */
    private function quay($v, array &$pool = null): array
    {
        if (CauHinh::get('lt_nguon', 'game') !== 'web') {
            $d = $this->dropIdCua((int)$v->MissionId, (string)$v->Khoa);
            if ($d) { $b = $this->quayLaGame($d); if ($b) return $b; }
        }
        if ($pool === null) $pool = $this->boQua($v->Khoa);
        return $this->quayLa($pool);
    }

    private function soLat(): int
    {
        return max(1, min(self::SO_LA, CauHinh::int('lt_solat', self::SO_LAT)));
    }

    private function moTaBai(array $bai): array
    {
        $tt = VatPham::thongTin(array_column(array_filter($bai), 't'));
        return array_map(function ($b) use ($tt) {
            if (!$b) return null;
            $i = $tt[$b['t']] ?? null;
            $g = (int)($b['g'] ?? 0); $m = (int)($b['m'] ?? 0);
            $ten = $b['t'] ? (($i->Name ?? ('Vật phẩm ' . $b['t'])) . ($b['c'] > 1 ? ' x' . $b['c'] : '') . ($b['s'] ? ' +' . $b['s'] : '')) : '';
            foreach ([[$b['x'], ' xu web'], [$g, ' vàng'], [$m, ' xu game']] as [$n, $dv]) if ($n) $ten = trim($ten . ($ten ? ' + ' : '') . number_format($n, 0, ',', '.') . $dv);
            return ['ten' => $ten, 'hinh' => $b['t'] ? '/hinh/' . $b['t'] : null, 'mau' => $b['t'] ? VatPham::mau((int)($i->Quality ?? 0)) : '#ffcf5c',
                    'han' => $b['v'] ? $b['v'] . ' ngày' : '', 'xu' => $b['x'], 'vang' => $g > 0,
                    // hiem: pham chat tim tro len, game danh dau IsTips (thong bao toan server), hoac tu 10.000 xu web -> mat bai VIP vang
                    'hiem' => ($b['t'] && ((int)($i->Quality ?? 0) >= 4 || !empty($b['tip']))) || $b['x'] >= 10000];
        }, $bai);
    }

    public function latThe()
    {
        $mid = $this->mid();
        $nv = $this->nhanVat();
        if (!$nv) return $this->error('Tài khoản chưa có nhân vật.');
        $this->quetPhoBan($mid, (int)$nv->UserID);
        $rows = $this->mem()->select("SELECT TOP 100 ID,Khoa,ThoiGian,DaLat,Bai FROM Web_The_Luot WHERE MemberID=? AND Xong=0 ORDER BY ID", [$mid]);
        $ds = array_map(function ($x) {
            $lat = $x->DaLat === '' ? [] : array_map('intval', explode(',', $x->DaLat));
            $bai = $this->moTaBai(array_replace(array_fill(0, self::SO_LA, null), json_decode($x->Bai, true) ?: []));
            $mo = [];
            foreach ($lat as $i) $mo[$i] = $bai[$i];
            return ['id' => (int)$x->ID, 'phoBan' => $x->Khoa, 'tg' => substr((string)$x->ThoiGian, 0, 16), 'daLat' => $mo];
        }, $rows);
        $homNay = $this->mem()->select("SELECT Khoa, COUNT(*) n FROM Web_The_Luot WHERE GameUserID=? AND Ngay=CAST(GETDATE() AS date) GROUP BY Khoa", [(int)$nv->UserID]);
        return $this->success('ok', ['ds' => $ds, 'homNay' => $homNay, 'soLan' => CauHinh::int('lt_solan', 3), 'mo' => CauHinh::int('lt_mo', 1), 'soLa' => self::SO_LA, 'soLat' => $this->soLat()]);
    }

    public function latTheLat(Request $r)
    {
        $mid = $this->mid();
        $id = (int)$r->input('id');
        $o = (int)$r->input('o');
        if ($o < 0 || $o >= self::SO_LA) return $this->error('Lá bài không hợp lệ.');
        $nv = $this->nhanVat();
        $out = null;
        try {
        $this->mem()->transaction(function () use ($mid, $id, $o, $nv, &$out) {
            $v = $this->mem()->selectOne("SELECT * FROM Web_The_Luot WITH (UPDLOCK,ROWLOCK) WHERE ID=? AND MemberID=? AND Xong=0", [$id, $mid]);
            if (!$v) { $out = 'het'; return; }
            $lat = $v->DaLat === '' ? [] : array_map('intval', explode(',', $v->DaLat));
            if (in_array($o, $lat, true) || count($lat) >= $this->soLat()) { $out = 'roi'; return; }
            $bai = array_replace(array_fill(0, self::SO_LA, null), json_decode($v->Bai, true) ?: []);
            $pool = null;
            $b = $bai[$o] = $this->quay($v, $pool);
            $nguon = 'Lật thẻ ' . $v->Khoa;
            if ($b['x'] > 0) XuWeb::doi($mid, $b['x'], 'latthe', $nguon);
            // vang / xu game (ItemId -100 / -200 cua bang roi do game) gui thang vao thu game; loi thi huy ca lan lat
            if ((int)($b['g'] ?? 0) > 0 || (int)($b['m'] ?? 0) > 0) {
                if (!$nv) throw new \RuntimeException('khong co nhan vat');
                $kq = GameMail::send((int)$nv->UserID, 'Quà lật thẻ ' . $v->Khoa, [], (int)($b['g'] ?? 0), (int)($b['m'] ?? 0));
                if ($kq !== '1') throw new \RuntimeException('mail ' . $kq);
            }
            if ($b['t'] > 0) $this->vaoRuong($mid, $b['t'], max(1, $b['c']), $b['v'], $b['s'], (bool)$b['b'], $nguon);
            $lat[] = $o;
            $xong = count($lat) >= $this->soLat();
            // lat du: quay not cac la con lai (cung ty le game) chi de hien cho nguoi choi biet da bo lo gi
            if ($xong) for ($i = 0; $i < self::SO_LA; $i++) if (!$bai[$i]) $bai[$i] = $this->quay($v, $pool);
            $this->mem()->update("UPDATE Web_The_Luot SET DaLat=?, Xong=?, Bai=? WHERE ID=?", [implode(',', $lat), $xong ? 1 : 0, json_encode($bai), $id]);
            $mt = $this->moTaBai($bai);
            $out = ['o' => $o, 'bai' => $mt[$o], 'conLai' => $this->soLat() - count($lat), 'xong' => $xong, 'tatCa' => $xong ? $mt : null];
        });
        } catch (\Throwable $e) {
            return $this->error('Máy chủ game đang bận, lá này chưa lật. Thử lại sau ít phút.');
        }
        if ($out === 'het') return $this->error('Lượt lật này đã xong.');
        if ($out === 'roi') return $this->error('Lá này đã lật hoặc đã hết lượt lật.');
        return $this->success('ok', $out + ['soDu' => XuWeb::soDu($mid)]);
    }

    /* ======================= RUONG WEB ======================= */

    /**
     * Cho do vao ruong, CONG DON nhu trong game: cung mon + cung han + cung cuong hoa + cung khoa thi gop vao o cu,
     * moi o toi da Shop_Goods.MaxCount (game: 1 = khong chong, vd chau bau / trang bi; da 99999; ruong 999). Day thi mo o moi.
     * Moi o ruong = 1 dinh kem khi rut ra thu nen khong bao gio vuot MaxCount cua game. Ben goi da mo transaction.
     */
    private function vaoRuong(int $mid, int $tid, int $sl, int $han, int $cuong, bool $khoa, string $nguon): void
    {
        // 22/10: do vao game la mon goc tron (GameMail::send) nen ruong cung luu tron, hien dung va cong don duoc voi nhau
        $han = 0; $cuong = 0; $khoa = false;
        $mx =(int)(DB::connection('sqlsrv_tank41')->selectOne("SELECT MaxCount m FROM Db_Tank.dbo.Shop_Goods WHERE TemplateID=?", [$tid])->m ?? 1);
        $mx = max(1, $mx);
        $nguon = mb_substr($nguon, 0, 100);
        if ($mx > 1) {
            $o = $this->mem()->select("SELECT ID,[Count] c FROM Web_Ruong WITH (UPDLOCK,ROWLOCK) WHERE MemberID=? AND TemplateID=? AND ValidDate=? AND StrengthenLevel=? AND IsBind=? AND [Count]<? ORDER BY ID",
                [$mid, $tid, $han, $cuong, $khoa ? 1 : 0, $mx]);
            foreach ($o as $x) {
                if ($sl <= 0) break;
                $them = min($sl, $mx - (int)$x->c);
                $this->mem()->update("UPDATE Web_Ruong SET [Count]=[Count]+?, Nguon=?, ThoiGian=GETDATE() WHERE ID=?", [$them, $nguon, (int)$x->ID]);
                $sl -= $them;
            }
        }
        while ($sl > 0) {
            $n = min($sl, $mx);
            $this->mem()->insert("INSERT INTO Web_Ruong(MemberID,TemplateID,[Count],ValidDate,StrengthenLevel,IsBind,Nguon) VALUES(?,?,?,?,?,?,?)",
                [$mid, $tid, $n, $han, $cuong, $khoa ? 1 : 0, $nguon]);
            $sl -= $n;
        }
    }

    public function ruong()
    {
        $rows = $this->mem()->select("SELECT ID,TemplateID,[Count] Cnt,ValidDate,StrengthenLevel,IsBind,Nguon,ThoiGian FROM Web_Ruong WHERE MemberID=? ORDER BY ID DESC", [$this->mid()]);
        $tt = VatPham::thongTin(array_map(function ($x) { return (int)$x->TemplateID; }, $rows));
        return $this->success('ok', ['ds' => array_map(function ($x) use ($tt) {
            $i = $tt[(int)$x->TemplateID] ?? null;
            return ['id' => (int)$x->ID, 'ten' => $i->Name ?? ('Vật phẩm ' . $x->TemplateID), 'sl' => (int)$x->Cnt, 'han' => (int)$x->ValidDate, 'cuong' => (int)$x->StrengthenLevel,
                    'khoa' => (bool)$x->IsBind, 'nguon' => $x->Nguon, 'tg' => substr((string)$x->ThoiGian, 0, 16), 'hinh' => '/hinh/' . (int)$x->TemplateID, 'mau' => VatPham::mau((int)($i->Quality ?? 0))];
        }, $rows)]);
    }

    const RUT_TOI_DA = 50;   // so o toi da moi lan bam Rut
    const MON_MOI_THU = 5;   // SendMailAndItem: toi da 5 dinh kem moi thu

    /**
     * Rut nhieu o vao hop thu game, TU CHIA THU 5 mon/thu (11 mon -> 5 + 5 + 1 = 3 thu).
     * Moi thu 1 transaction rieng: xoa o khoi ruong -> gui thu -> loi thi rollback rieng thu do va dung lai.
     * => thu da gui thi do da ra khoi ruong, thu loi thi do van con nguyen trong ruong (khong mat, khong nhan doi).
     */
    public function ruongRut(Request $r)
    {
        $ids = array_slice(array_values(array_unique(array_filter(array_map('intval', (array)$r->input('ids', []))))), 0, self::RUT_TOI_DA);
        if (!$ids) return $this->error('Chọn món cần rút.');
        $nv = $this->nhanVat();
        if (!$nv) return $this->error('Tài khoản chưa có nhân vật để nhận đồ.');
        $mid = $this->mid();
        // chi lay o that su cua minh, giu thu tu chon
        $co = array_map(function ($x) { return (int)$x->ID; }, $this->mem()->select("SELECT ID FROM Web_Ruong WHERE MemberID=? AND ID IN (" . implode(',', $ids) . ")", [$mid]));
        $ids = array_values(array_filter($ids, function ($i) use ($co) { return in_array($i, $co, true); }));
        if (!$ids) return $this->error('Không thấy món đã chọn trong rương.');
        $nhom = array_chunk($ids, self::MON_MOI_THU);
        $tong = count($nhom);
        $guiThu = 0; $guiMon = 0; $loi = false;
        foreach ($nhom as $k => $nIds) {
            try {
                $this->mem()->transaction(function () use ($mid, $nIds, $nv, $k, $tong, &$guiMon) {
                    $rows = $this->mem()->select("SELECT * FROM Web_Ruong WITH (UPDLOCK,ROWLOCK) WHERE MemberID=? AND ID IN (" . implode(',', $nIds) . ")", [$mid]);
                    if (!$rows) return;
                    $this->mem()->delete("DELETE FROM Web_Ruong WHERE MemberID=? AND ID IN (" . implode(',', array_map(function ($x) { return (int)$x->ID; }, $rows)) . ")", [$mid]);
                    $items = array_map(function ($x) { return [(int)$x->TemplateID, (int)$x->Count, (int)$x->ValidDate, (int)$x->StrengthenLevel, (bool)$x->IsBind]; }, $rows);
                    $title = 'Đồ rút từ rương web' . ($tong > 1 ? ' (' . ($k + 1) . '/' . $tong . ')' : '');
                    $kq = GameMail::send((int)$nv->UserID, $title, $items);
                    if ($kq !== '1') throw new \RuntimeException('mail ' . $kq);
                    $guiMon += count($rows);
                });
                $guiThu++;
            } catch (\Throwable $e) {
                $loi = true;
                break;
            }
        }
        if (!$guiThu) return $this->error('Máy chủ game đang bận, chưa gửi được. Đồ vẫn còn trong rương, thử lại sau.');
        $msg = 'Đã gửi ' . $guiMon . ' món thành ' . $guiThu . ' thư vào hộp thư trong game.';
        if ($loi) $msg .= ' Thư thứ ' . ($guiThu + 1) . ' bị lỗi, các món còn lại vẫn ở trong rương, bấm rút lại sau.';
        return $this->success($msg, ['thu' => $guiThu, 'mon' => $guiMon, 'loi' => $loi]);
    }

    /* ======================= GUI QUA TEST ======================= */
    // Nguoi choi tu tim vat pham va gui vao HOP THU GAME cua chinh nhan vat cua tai khoan dang dang nhap.
    // Chi cho giai doan test: tat bang quatest_mo = 0 (admin > Mini game). Nhat ky Web_QuaTest. Bang: _setup/sql/qua-test-web.sql

    public function quaTestTim(Request $r)
    {
        if (CauHinh::int('quatest_mo', 0) !== 1) return $this->error('Gửi quà test đang tắt.');
        $q = trim((string)$r->input('q', ''));
        $cat = (int)$r->input('cat', 0);
        $trang = max(0, (int)$r->input('trang', 0));
        $moiTrang = 60;
        // loc tren danh sach mon dua vao game duoc (client biet ID + co anh, VatPham::tatCaDungDuoc), khong phai TOP n cua DB
        // (truoc 21/10: TOP 300 roi moi loc -> loai nhieu do la nhu Dao cu gan nhu khong ra mon nao)
        $gt = $this->gioiTinh();   // chi do dung gioi tinh nhan vat (15/10: hoang nu tu gui ao nam, khong mac duoc)
        $so = ctype_digit($q);
        $khop = [];
        foreach (VatPham::tatCaDungDuoc() as $x) {
            if ($cat > 0 && $x[2] !== $cat) continue;
            if ($gt && $x[3] !== 0 && $x[3] !== $gt) continue;
            if ($q !== '') {
                // tim ca ten trong game (client) lan ten DB: 7024 game "SUPER-Boomerang", DB "VIP-Boomerang"
                if ($so ? strpos((string)$x[0], $q) !== 0 : mb_stripos($x[12], $q) === false) continue;
            }
            $khop[] = $x;
        }
        if ($so) usort($khop, function ($a, $b) use ($q) { return ((string)$b[0] === $q) <=> ((string)$a[0] === $q) ?: $a[0] <=> $b[0]; });
        $ds = [];
        foreach (array_slice($khop, $trang * $moiTrang, $moiTrang) as $x) {
            $ds[] = ['id' => $x[0], 'ten' => $x[1], 'cat' => $x[2], 'mau' => VatPham::mau($x[4]), 'hinh' => '/hinh/' . $x[0],
                'cs' => $x[10], 'gt' => $x[3], 'chiSo' => [$x[6], $x[7], $x[8], $x[9]], 'lv' => $x[5], 'q' => $x[4], 'moTa' => $x[11],
                'mx' => min($x[13], CauHinh::int('quatest_sl_max', 999))];   // so luong toi da (1 = khong chong duoc, khong hien o so luong)
        }
        return $this->success('ok', ['ds' => $ds, 'tong' => count($khop), 'trang' => $trang, 'con' => ($trang + 1) * $moiTrang < count($khop)]);
    }

    /** cac loai co mon dua vao game duoc (dung gioi tinh nhan vat), kem so mon: cho o chon loai cua Gui qua test */
    public function quaTestLoai(Request $r)
    {
        if (CauHinh::int('quatest_mo', 0) !== 1) return $this->error('Gửi quà test đang tắt.');
        $gt = $this->gioiTinh();
        $dem = []; $mau = [];
        foreach (VatPham::tatCaDungDuoc() as $x) {
            if ($gt && $x[3] !== 0 && $x[3] !== $gt) continue;
            $dem[$x[2]] = ($dem[$x[2]] ?? 0) + 1;
            if (!isset($mau[$x[2]])) $mau[$x[2]] = $x[1];
        }
        // trang bi truoc, roi den do khac theo so loai
        $uuTien = [7, 17, 1, 5, 2, 3, 4, 6, 13, 15, 14, 9, 8, 27, 31, 28, 29, 19, 16, 50, 51, 52];
        uksort($dem, function ($a, $b) use ($uuTien) {
            $ia = array_search($a, $uuTien, true); $ib = array_search($b, $uuTien, true);
            return [$ia === false ? 99 : $ia, $a] <=> [$ib === false ? 99 : $ib, $b];
        });
        $ds = [];
        foreach ($dem as $c => $n) {
            $ds[] = ['cat' => $c, 'ten' => VatPham::tenLoai($c) ?? ('Loại ' . $c . ' (vd: ' . trim($mau[$c]) . ')'), 'n' => $n];
        }
        return $this->success('ok', ['ds' => $ds, 'tong' => array_sum($dem)]);
    }

    public function quaTestGui(Request $r)
    {
        if (CauHinh::int('quatest_mo', 0) !== 1) return $this->error('Gửi quà test đang tắt.');
        $mid = $this->mid();
        $nv = $this->nhanVat();
        if (!$nv) return $this->error('Tài khoản chưa có nhân vật để nhận quà.');
        $luot = (int)$this->mem()->selectOne("SELECT COUNT(*) n FROM Web_QuaTest WHERE MemberID=? AND ThoiGian>=CAST(GETDATE() AS date)", [$mid])->n;
        $gh = CauHinh::int('quatest_luot_ngay', 50);   // 0 = khong gioi han (chu server tat 22/10)
        if ($gh > 0 && $luot >= $gh) return $this->error('Hôm nay đã gửi đủ ' . $luot . ' lần, mai gửi tiếp.');
        $ds = json_decode((string)$r->input('ds', '[]'), true);
        if (!is_array($ds) || !$ds) return $this->error('Chọn ít nhất 1 món.');
        $ds = array_slice($ds, 0, 5);
        $tt = VatPham::thongTin(array_map(function ($x) { return (int)($x['id'] ?? 0); }, $ds));
        $items = []; $nk = [];
        foreach ($ds as $x) {
            $tid = (int)($x['id'] ?? 0);
            $i = $tt[$tid] ?? null;
            if (!VatPham::dungDuoc($i)) return $this->error('Món ID ' . $tid . ' không có trong client, không gửi được.');
            if (isset(VatPham::banBac()[$tid])) return $this->error('Món ID ' . $tid . ' là bản nâng bậc của vũ khí. Gửi bản gốc rồi cường hóa trong game để lên bậc.');
            if (in_array((int)$i->NeedSex, [1, 2], true) && (int)$i->NeedSex !== $this->gioiTinh($nv))
                return $this->error('Món ' . $i->Name . ' dành cho nhân vật ' . ((int)$i->NeedSex === 1 ? 'nam' : 'nữ') . ', ' . $nv->NickName . ' không mặc được.');
            // 22/10: mon goc tron (khong cuong hoa / han / khoa). So luong chon duoc, kep quatest_sl_max;
            // GameMail::send kep tiep theo MaxCount nen do khong chong duoc luon la 1.
            $cnt = max(1, min(CauHinh::int('quatest_sl_max', 999), (int)($x['sl'] ?? 1)));
            $items[] = [$tid, $cnt];
            $nk[] = $tid . ' x' . $cnt;
        }
        $kq = GameMail::send((int)$nv->UserID, 'Quà test từ GunnyNetco4', $items);
        if ($kq !== '1') return $this->error('Máy chủ game đang bận, chưa gửi được (mã ' . $kq . '). Thử lại sau.');
        $this->mem()->insert("INSERT INTO Web_QuaTest(MemberID,GameUserID,VatPham) VALUES(?,?,?)", [$mid, (int)$nv->UserID, mb_substr(implode('; ', $nk), 0, 1000)]);
        return $this->success('Đã gửi ' . count($items) . ' món vào hộp thư của ' . $nv->NickName . ' trong game.', ['conLuot' => $gh > 0 ? $gh - $luot - 1 : null]);
    }

    /* ======================= ANH VAT PHAM (cong khai) ======================= */

    public function hinh($tid)
    {
        $i = VatPham::thongTin([(int)$tid])[(int)$tid] ?? null;
        $f = $i ? VatPham::file($i->CategoryID, $i->Pic, $i->NeedSex) : null;
        if (!$f) {
            $svg = '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64"><rect width="64" height="64" rx="10" fill="#232735"/><text x="32" y="42" font-size="30" text-anchor="middle" fill="#8a90a3" font-family="Arial">?</text></svg>';
            return response($svg, 200, ['Content-Type' => 'image/svg+xml', 'Cache-Control' => 'public, max-age=86400']);
        }
        return response()->file($f, ['Content-Type' => substr($f, -4) === '.jpg' ? 'image/jpeg' : 'image/png', 'Cache-Control' => 'public, max-age=604800']);
    }
}
