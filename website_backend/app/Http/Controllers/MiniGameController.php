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
        return Player::select(['UserID', 'NickName'])->where('UserName', auth()->user()->Email)
            ->where('NickName', '<>', '')->orderBy('UserID')->first();
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
                for ($i = 0; $i < $sl; $i++) {
                    $this->mem()->insert("INSERT INTO Web_Ruong(MemberID,TemplateID,[Count],ValidDate,StrengthenLevel,IsBind,Nguon) VALUES(?,?,?,?,?,?,?)",
                        [$mid, (int)$h->TemplateID, max(1, (int)$h->Count), (int)$h->ValidDate, (int)$h->StrengthenLevel, $h->IsBind ? 1 : 0, 'Shop web']);
                }
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

    private function moTaBai(array $bai): array
    {
        $tt = VatPham::thongTin(array_column(array_filter($bai), 't'));
        return array_map(function ($b) use ($tt) {
            if (!$b) return null;
            $i = $tt[$b['t']] ?? null;
            $ten = $b['t'] ? (($i->Name ?? ('Vật phẩm ' . $b['t'])) . ($b['c'] > 1 ? ' x' . $b['c'] : '') . ($b['s'] ? ' +' . $b['s'] : '')) : '';
            if ($b['x']) $ten = trim($ten . ($ten ? ' + ' : '') . number_format($b['x'], 0, ',', '.') . ' xu web');
            return ['ten' => $ten, 'hinh' => $b['t'] ? '/hinh/' . $b['t'] : null, 'mau' => $b['t'] ? VatPham::mau((int)($i->Quality ?? 0)) : '#ffcf5c',
                    'han' => $b['v'] ? $b['v'] . ' ngày' : '', 'xu' => $b['x'],
                    // hiem: pham chat tim tro len hoac tu 10.000 xu web -> mat bai VIP vang
                    'hiem' => ($b['t'] && (int)($i->Quality ?? 0) >= 4) || $b['x'] >= 10000];
        }, $bai);
    }

    public function latThe()
    {
        $mid = $this->mid();
        $nv = $this->nhanVat();
        if (!$nv) return $this->error('Tài khoản chưa có nhân vật.');
        $this->quetPhoBan($mid, (int)$nv->UserID);
        $rows = $this->mem()->select("SELECT TOP 20 ID,Khoa,ThoiGian,DaLat,Bai FROM Web_The_Luot WHERE MemberID=? AND Xong=0 ORDER BY ID", [$mid]);
        $ds = array_map(function ($x) {
            $lat = $x->DaLat === '' ? [] : array_map('intval', explode(',', $x->DaLat));
            $bai = $this->moTaBai(array_replace(array_fill(0, self::SO_LA, null), json_decode($x->Bai, true) ?: []));
            $mo = [];
            foreach ($lat as $i) $mo[$i] = $bai[$i];
            return ['id' => (int)$x->ID, 'phoBan' => $x->Khoa, 'tg' => substr((string)$x->ThoiGian, 0, 16), 'daLat' => $mo];
        }, $rows);
        $homNay = $this->mem()->select("SELECT Khoa, COUNT(*) n FROM Web_The_Luot WHERE GameUserID=? AND Ngay=CAST(GETDATE() AS date) GROUP BY Khoa", [(int)$nv->UserID]);
        return $this->success('ok', ['ds' => $ds, 'homNay' => $homNay, 'soLan' => CauHinh::int('lt_solan', 3), 'mo' => CauHinh::int('lt_mo', 1), 'soLa' => self::SO_LA, 'soLat' => self::SO_LAT]);
    }

    public function latTheLat(Request $r)
    {
        $mid = $this->mid();
        $id = (int)$r->input('id');
        $o = (int)$r->input('o');
        if ($o < 0 || $o >= self::SO_LA) return $this->error('Lá bài không hợp lệ.');
        $nv = $this->nhanVat();
        $out = null;
        $this->mem()->transaction(function () use ($mid, $id, $o, $nv, &$out) {
            $v = $this->mem()->selectOne("SELECT * FROM Web_The_Luot WITH (UPDLOCK,ROWLOCK) WHERE ID=? AND MemberID=? AND Xong=0", [$id, $mid]);
            if (!$v) { $out = 'het'; return; }
            $lat = $v->DaLat === '' ? [] : array_map('intval', explode(',', $v->DaLat));
            if (in_array($o, $lat, true) || count($lat) >= self::SO_LAT) { $out = 'roi'; return; }
            $bai = array_replace(array_fill(0, self::SO_LA, null), json_decode($v->Bai, true) ?: []);
            $pool = $this->boQua($v->Khoa);
            $b = $bai[$o] = $this->quayLa($pool);
            $nguon = 'Lật thẻ ' . $v->Khoa;
            if ($b['x'] > 0) XuWeb::doi($mid, $b['x'], 'latthe', $nguon);
            if ($b['t'] > 0) {
                $this->mem()->insert("INSERT INTO Web_Ruong(MemberID,TemplateID,[Count],ValidDate,StrengthenLevel,IsBind,Nguon) VALUES(?,?,?,?,?,?,?)",
                    [$mid, $b['t'], max(1, $b['c']), $b['v'], $b['s'], $b['b'] ? 1 : 0, mb_substr($nguon, 0, 100)]);
            }
            $lat[] = $o;
            $xong = count($lat) >= self::SO_LAT;
            // lat du 3 la: quay not 6 la con lai (cung ty le) chi de hien cho nguoi choi biet da bo lo gi
            if ($xong) for ($i = 0; $i < self::SO_LA; $i++) if (!$bai[$i]) $bai[$i] = $this->quayLa($pool);
            $this->mem()->update("UPDATE Web_The_Luot SET DaLat=?, Xong=?, Bai=? WHERE ID=?", [implode(',', $lat), $xong ? 1 : 0, json_encode($bai), $id]);
            $mt = $this->moTaBai($bai);
            $out = ['o' => $o, 'bai' => $mt[$o], 'conLai' => self::SO_LAT - count($lat), 'xong' => $xong, 'tatCa' => $xong ? $mt : null];
        });
        if ($out === 'het') return $this->error('Lượt lật này đã xong.');
        if ($out === 'roi') return $this->error('Lá này đã lật hoặc đã hết 3 lần lật.');
        return $this->success('ok', $out + ['soDu' => XuWeb::soDu($mid)]);
    }

    /* ======================= RUONG WEB ======================= */

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

    /** rut toi da 5 mon vao hop thu game (1 thu). Xoa khoi ruong truoc, gui thu loi thi hoan lai (rollback). */
    public function ruongRut(Request $r)
    {
        $ids = array_slice(array_values(array_unique(array_filter(array_map('intval', (array)$r->input('ids', []))))), 0, 5);
        if (!$ids) return $this->error('Chọn món cần rút (tối đa 5 món mỗi lần).');
        $nv = $this->nhanVat();
        if (!$nv) return $this->error('Tài khoản chưa có nhân vật để nhận đồ.');
        $mid = $this->mid();
        $out = null;
        try {
            $this->mem()->transaction(function () use ($mid, $ids, $nv, &$out) {
                $rows = $this->mem()->select("SELECT * FROM Web_Ruong WITH (UPDLOCK,ROWLOCK) WHERE MemberID=? AND ID IN (" . implode(',', $ids) . ")", [$mid]);
                if (!$rows) { $out = 'khong'; return; }
                $this->mem()->delete("DELETE FROM Web_Ruong WHERE MemberID=? AND ID IN (" . implode(',', array_map(function ($x) { return (int)$x->ID; }, $rows)) . ")", [$mid]);
                $items = array_map(function ($x) { return [(int)$x->TemplateID, (int)$x->Count, (int)$x->ValidDate, (int)$x->StrengthenLevel, (bool)$x->IsBind]; }, $rows);
                $kq = GameMail::send((int)$nv->UserID, 'Đồ rút từ rương web', $items);
                if ($kq !== '1') throw new \RuntimeException('mail ' . $kq);
                $out = count($rows);
            });
        } catch (\Throwable $e) {
            return $this->error('Máy chủ game đang bận, chưa gửi được. Đồ vẫn còn trong rương, thử lại sau.');
        }
        if ($out === 'khong') return $this->error('Không thấy món đã chọn trong rương.');
        return $this->success('Đã gửi ' . $out . ' món vào hộp thư trong game.');
    }

    /* ======================= GUI QUA TEST ======================= */
    // Nguoi choi tu tim vat pham va gui vao HOP THU GAME cua chinh nhan vat cua tai khoan dang dang nhap.
    // Chi cho giai doan test: tat bang quatest_mo = 0 (admin > Mini game). Nhat ky Web_QuaTest. Bang: _setup/sql/qua-test-web.sql

    public function quaTestTim(Request $r)
    {
        if (CauHinh::int('quatest_mo', 0) !== 1) return $this->error('Gửi quà test đang tắt.');
        $q = trim((string)$r->input('q', ''));
        $cat = (int)$r->input('cat', 0);
        $where = []; $par = [];
        if ($q !== '') {
            if (ctype_digit($q)) { $where[] = "(TemplateID=? OR CAST(TemplateID AS varchar(12)) LIKE ?)"; $par[] = (int)$q; $par[] = $q . '%'; }
            else { $where[] = "Name LIKE ?"; $par[] = '%' . $q . '%'; }
        }
        if ($cat > 0) { $where[] = "CategoryID=?"; $par[] = $cat; }
        if (!$where) return $this->success('ok', ['ds' => []]);
        $rows = DB::connection('sqlsrv_tank41')->select("SELECT TOP 300 TemplateID,Name,CategoryID,Pic,NeedSex,Quality,NeedLevel,Attack,Defence,Agility,Luck,CanStrengthen,Description
            FROM Db_Tank.dbo.Shop_Goods WHERE " . implode(' AND ', $where) . " ORDER BY CASE WHEN TemplateID=? THEN 0 ELSE 1 END, TemplateID",
            array_merge($par, [ctype_digit($q) ? (int)$q : -1]));
        $ds = [];
        foreach ($rows as $x) {
            // chi tra mon client co anh (mon khong anh vao game thanh o vo hinh)
            if (!VatPham::file($x->CategoryID, $x->Pic, $x->NeedSex)) continue;
            $ds[] = ['id' => (int)$x->TemplateID, 'ten' => $x->Name, 'cat' => (int)$x->CategoryID, 'mau' => VatPham::mau((int)$x->Quality), 'hinh' => '/hinh/' . (int)$x->TemplateID,
                'cs' => (bool)$x->CanStrengthen, 'gt' => (int)$x->NeedSex, 'chiSo' => [(int)$x->Attack, (int)$x->Defence, (int)$x->Agility, (int)$x->Luck],
                'moTa' => mb_substr((string)$x->Description, 0, 120)];
            if (count($ds) >= 60) break;
        }
        return $this->success('ok', ['ds' => $ds]);
    }

    public function quaTestGui(Request $r)
    {
        if (CauHinh::int('quatest_mo', 0) !== 1) return $this->error('Gửi quà test đang tắt.');
        $mid = $this->mid();
        $nv = $this->nhanVat();
        if (!$nv) return $this->error('Tài khoản chưa có nhân vật để nhận quà.');
        $luot = (int)$this->mem()->selectOne("SELECT COUNT(*) n FROM Web_QuaTest WHERE MemberID=? AND ThoiGian>=CAST(GETDATE() AS date)", [$mid])->n;
        if ($luot >= CauHinh::int('quatest_luot_ngay', 50)) return $this->error('Hôm nay đã gửi đủ ' . $luot . ' lần, mai gửi tiếp.');
        $ds = json_decode((string)$r->input('ds', '[]'), true);
        if (!is_array($ds) || !$ds) return $this->error('Chọn ít nhất 1 món.');
        $ds = array_slice($ds, 0, 5);
        $slMax = CauHinh::int('quatest_sl_max', 999);
        $maxStr = (int)(DB::connection('sqlsrv_tank41')->selectOne("SELECT TOP 1 CAST(Value AS nvarchar(20)) v FROM Server_Config WHERE Name='MaxStrengthLevel'")->v ?? 12) ?: 12;
        $tt = VatPham::thongTin(array_map(function ($x) { return (int)($x['id'] ?? 0); }, $ds));
        $items = []; $nk = [];
        foreach ($ds as $x) {
            $tid = (int)($x['id'] ?? 0);
            $i = $tt[$tid] ?? null;
            if (!$i || !VatPham::file($i->CategoryID, $i->Pic, $i->NeedSex)) return $this->error('Món ID ' . $tid . ' không có trong client, không gửi được.');
            $cnt = max(1, min($slMax, (int)($x['sl'] ?? 1)));
            $str = max(0, min($maxStr, (int)($x['cuong'] ?? 0)));
            $han = max(0, min(3650, (int)($x['han'] ?? 0)));
            $items[] = [$tid, $cnt, $han, $str, !empty($x['khoa'])];
            $nk[] = $tid . ' x' . $cnt . ($str ? ' +' . $str : '') . ($han ? ' (' . $han . 'n)' : '');
        }
        $kq = GameMail::send((int)$nv->UserID, 'Quà test từ GunnyNetco4', $items);
        if ($kq !== '1') return $this->error('Máy chủ game đang bận, chưa gửi được (mã ' . $kq . '). Thử lại sau.');
        $this->mem()->insert("INSERT INTO Web_QuaTest(MemberID,GameUserID,VatPham) VALUES(?,?,?)", [$mid, (int)$nv->UserID, mb_substr(implode('; ', $nk), 0, 1000)]);
        return $this->success('Đã gửi ' . count($items) . ' món vào hộp thư của ' . $nv->NickName . ' trong game.', ['conLuot' => CauHinh::int('quatest_luot_ngay', 50) - $luot - 1]);
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
