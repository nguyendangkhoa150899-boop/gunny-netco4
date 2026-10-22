<?php

namespace App\Http\Controllers;

use App\Models\Player;
use App\Support\DoiGioiTinh;
use App\Support\VatPham;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

/**
 * Doi do theo gioi tinh (/dashboard > Ho so > Doi do gioi tinh). Sau khi dung The Bien Tinh, do khac gioi doi TemplateID
 * sang ban dung gioi tinh (App\Support\DoiGioiTinh), GIU NGUYEN cuong hoa, kham, hop thanh, han dung.
 * Chi chay khi nhan vat OFFLINE: do cua nguoi online nam trong RAM Road, sua DB se bi ghi de.
 * Road ghi State=1 ngay luc dang nhap (GamePlayer.LoadFromDatabase -> UpdatePlayer), State=0 luc thoat.
 * Do dang mac doi duoc: lan dang nhap sau Road dung lai Style tu tui trang bi (Login -> UpdatePlayerProperties).
 */
class DoiDoController extends \App\Http\BaseController
{
    /** nhan vat cua tai khoan (server nay moi tai khoan 1 nhan vat) */
    private function nhanVat()
    {
        return Player::select(['UserID', 'NickName', 'Sex', 'State'])->where('UserName', auth()->user()->Email)
            ->where('NickName', '<>', '')->orderBy('UserID')->first();
    }

    private function db()
    {
        return DB::connection('sqlsrv_tank41');
    }

    /** do khac gioi trong tui: [{ItemID, tu, sang|null, ...}] */
    private function quet(int $uid, int $gt, bool $khoa = false): array
    {
        $rows = $this->db()->select("SELECT ItemID,TemplateID,BagType,Place,StrengthenLevel,isGold FROM Sys_Users_Goods" . ($khoa ? " WITH (UPDLOCK)" : "")
            . " WHERE UserID=? AND IsExist=1 ORDER BY BagType,Place", [$uid]);
        $out = []; $nho = [];
        foreach ($rows as $r) {
            $tid = (int)$r->TemplateID;
            $sx = DoiGioiTinh::gioiTinh($tid);
            if ($sx === 0 || $sx === $gt) continue;
            if (!array_key_exists($tid, $nho)) $nho[$tid] = DoiGioiTinh::thayThe($tid, $gt);
            $out[] = ['item' => (int)$r->ItemID, 'tu' => $tid, 'sang' => $nho[$tid], 'cuong' => (int)$r->StrengthenLevel,
                'mac' => (int)$r->BagType === 0 && (int)$r->Place < 31, 'vang' => (bool)$r->isGold];
        }
        // do da dat vang: Road cong chi so vang theo GoldEquipMgr.FindGoldEquipByTemplate(TemplateID, CategoryID) = dong rieng
        // OldTemplateId = ID, khong co thi dong chung cua loai (OldTemplateId -1). Mon nam/nu cung loai nen dong chung y nhau;
        // chi chan khi 1 trong 2 mon co dong RIENG (doi ID se doi/mat chi so vang).
        $ids = [];
        foreach ($out as $x) if ($x['vang'] && $x['sang']) { $ids[] = $x['tu']; $ids[] = $x['sang']; }
        $rieng = !$ids ? [] : array_flip(array_map(function ($r) { return (int)$r->OldTemplateId; },
            $this->db()->select("SELECT DISTINCT OldTemplateId FROM Db_Tank.dbo.GoldEquipTemplateLoad WHERE OldTemplateId IN (" . implode(',', array_map('intval', $ids)) . ")")));
        foreach ($out as &$x) $x['vang'] = $x['vang'] && $x['sang'] && (isset($rieng[$x['tu']]) || isset($rieng[$x['sang']]));
        unset($x);
        return $out;
    }

    private function moTa(array $ds): array
    {
        $ids = [];
        foreach ($ds as $x) { $ids[] = $x['tu']; if ($x['sang']) $ids[] = $x['sang']; }
        $tt = VatPham::thongTin($ids);
        $ten = function ($id) use ($tt) { return isset($tt[$id]) ? trim($tt[$id]->Name) : ('ID ' . $id); };
        $mau = function ($id) use ($tt) { return VatPham::mau(isset($tt[$id]) ? (int)$tt[$id]->Quality : 0); };
        return array_map(function ($x) use ($ten, $mau) {
            $ly = $x['vang'] ? 'Đã dát vàng loại riêng, không đổi được' : (!$x['sang'] ? 'Không có bản cho giới tính này' : '');
            return ['item' => $x['item'], 'tu' => ['id' => $x['tu'], 'ten' => $ten($x['tu']), 'hinh' => '/hinh/' . $x['tu'], 'mau' => $mau($x['tu'])],
                'sang' => $x['sang'] && !$x['vang'] ? ['id' => $x['sang'], 'ten' => $ten($x['sang']), 'hinh' => '/hinh/' . $x['sang'], 'mau' => $mau($x['sang'])] : null,
                'cuong' => $x['cuong'], 'mac' => $x['mac'], 'ly' => $ly];
        }, $ds);
    }

    public function xem()
    {
        $nv = $this->nhanVat();
        if (!$nv) return $this->error('Tài khoản chưa có nhân vật.');
        $gt = (int)$nv->Sex === 1 ? 1 : 2;
        return $this->success('ok', ['ten' => $nv->NickName, 'gioiTinh' => $gt === 1 ? 'Nam' : 'Nữ', 'online' => (int)$nv->State === 1,
            'ds' => $this->moTa($this->quet((int)$nv->UserID, $gt))]);
    }

    public function doi()
    {
        $nv = $this->nhanVat();
        if (!$nv) return $this->error('Tài khoản chưa có nhân vật.');
        $uid = (int)$nv->UserID;
        $gt = (int)$nv->Sex === 1 ? 1 : 2;
        $kq = null;
        $this->db()->transaction(function () use ($uid, &$gt, &$kq) {
            // khoa dong nhan vat: Road dang nhap phai cho giao dich nay xong moi ghi duoc State=1
            $c = $this->db()->selectOne("SELECT Sex,State FROM Sys_Users_Detail WITH (UPDLOCK, HOLDLOCK) WHERE UserID=?", [$uid]);
            if (!$c || (int)$c->State === 1) { $kq = 'online'; return; }
            $gt = (int)$c->Sex === 1 ? 1 : 2;
            $doi = [];
            foreach ($this->quet($uid, $gt, true) as $x) {
                if (!$x['sang'] || $x['vang']) continue;
                $n = $this->db()->update("UPDATE Sys_Users_Goods SET TemplateID=? WHERE ItemID=? AND UserID=? AND TemplateID=? AND IsExist=1",
                    [$x['sang'], $x['item'], $uid, $x['tu']]);
                if ($n) $doi[] = $x['item'] . ':' . $x['tu'] . '>' . $x['sang'];
            }
            $kq = $doi;
        });
        if ($kq === 'online')
            return $this->error('Nhân vật ' . $nv->NickName . ' đang online. Thoát game hẳn (tắt launcher) rồi bấm lại. Đồ của người đang online nằm trong máy chủ game, đổi lúc này sẽ bị ghi đè.', ['online' => true]);
        Log::info('doi-do-gioi-tinh', ['UserID' => $uid, 'gioiTinh' => $gt, 'doi' => $kq]);
        $con = $this->moTa($this->quet($uid, $gt));
        if (!$kq) return $this->error('Không có món nào đổi được.', ['ds' => $con]);
        return $this->success('Đã đổi ' . count($kq) . ' món sang bản ' . ($gt === 1 ? 'nam' : 'nữ') . '. Vào game là mặc được, cường hóa giữ nguyên.', ['ds' => $con, 'so' => count($kq)]);
    }
}
