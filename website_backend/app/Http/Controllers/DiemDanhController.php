<?php

namespace App\Http\Controllers;

use App\Models\Player;
use App\Support\CauHinh;
use App\Support\Diem;
use App\Support\XuWeb;
use Illuminate\Support\Facades\DB;

/**
 * Diem danh tren web (thay diem danh trong game, ban goc khoa cung trong Game.Server.dll).
 * Bang: Db_Tank41.dbo.Web_DiemDanh (UserID, Ngay) + Web_DiemDanh_Qua (_setup/sql/diem-danh-web.sql).
 * Qua gui vao hop thu game qua Request/SendMailAndItem.aspx (chi nhan tu 127.0.0.1).
 */
class DiemDanhController extends \App\Http\BaseController
{
    private function db()
    {
        return DB::connection('sqlsrv_tank41');
    }

    /** nhan vat cua tai khoan dang dang nhap (moi tai khoan 1 nhan vat tren server nay) */
    private function player()
    {
        $member = auth()->user();
        return Player::select(['UserID', 'NickName'])->where('UserName', $member->Email)
            ->where('NickName', '<>', '')->orderBy('UserID')->first();
    }

    private function rewards()
    {
        return $this->db()->select("SELECT q.Moc,q.TemplateID,q.[Count] Cnt,q.ValidDate,q.StrengthenLevel,q.IsBind,q.Gold,q.[Money] Money,q.XuWeb,
            ISNULL(g.Name,'') Name FROM Web_DiemDanh_Qua q LEFT JOIN Db_Tank.dbo.Shop_Goods g ON g.TemplateID=q.TemplateID ORDER BY q.Moc,q.ID");
    }

    private static function label($r)
    {
        $parts = [];
        if ($r->TemplateID > 0) {
            $parts[] = ($r->Name ?: ('ID ' . $r->TemplateID)) . ($r->Cnt > 1 ? ' x' . $r->Cnt : '')
                . ($r->StrengthenLevel ? ' +' . $r->StrengthenLevel : '') . ($r->ValidDate ? ' (' . $r->ValidDate . ' ngày)' : '');
        }
        if ($r->Gold) $parts[] = number_format($r->Gold, 0, ',', '.') . ' vàng';
        if ($r->Money) $parts[] = number_format($r->Money, 0, ',', '.') . ' xu';
        if (!empty($r->XuWeb)) $parts[] = number_format($r->XuWeb, 0, ',', '.') . ' xu web';
        return implode(', ', $parts);
    }

    private function monthDays($uid)
    {
        $rows = $this->db()->select("SELECT DAY(Ngay) d FROM Web_DiemDanh WHERE UserID=? AND Ngay>=DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),1) AND Ngay<=CAST(GETDATE() AS date) ORDER BY Ngay", [$uid]);
        return array_map(function ($r) { return (int)$r->d; }, $rows);
    }

    /** ngay hom nay theo gio SQL Server (VPS dat gio Viet Nam), khong phu thuoc timezone cua Laravel */
    private function now()
    {
        return $this->db()->selectOne("SELECT DAY(GETDATE()) d, DAY(EOMONTH(GETDATE())) t, MONTH(GETDATE()) m, YEAR(GETDATE()) y");
    }

    public function info()
    {
        $p = $this->player();
        if (!$p) return $this->error('Tài khoản chưa có nhân vật. Vào game tạo nhân vật trước rồi quay lại điểm danh.');
        $days = $this->monthDays($p->UserID);
        $now = $this->now();
        $today = (int)$now->d;
        $daily = [];
        $moc = [];
        foreach ($this->rewards() as $r) {
            if ((int)$r->Moc === 0) $daily[] = self::label($r);
            else $moc[(int)$r->Moc][] = self::label($r);
        }
        $milestones = [];
        foreach ($moc as $n => $labels) $milestones[] = ['moc' => $n, 'qua' => implode(', ', $labels), 'dat' => count($days) >= $n];
        return $this->success('ok', [
            'nhanvat' => $p->NickName,
            'homnay' => $today,
            'songay' => (int)$now->t,
            'thang' => (int)$now->m,
            'nam' => (int)$now->y,
            'dadiemdanh' => in_array($today, $days, true),
            'ngay' => $days,
            'quangay' => implode(', ', $daily),
            'moc' => $milestones,
        ]);
    }

    public function checkin()
    {
        $p = $this->player();
        if (!$p) return $this->error('Tài khoản chưa có nhân vật. Vào game tạo nhân vật trước rồi quay lại điểm danh.');
        $db = $this->db();
        try {
            // khoa chinh (UserID, Ngay): lan 2 trong ngay se loi trung khoa
            $db->insert("INSERT INTO Web_DiemDanh(UserID,Ngay) VALUES(?,CAST(GETDATE() AS date))", [$p->UserID]);
        } catch (\Throwable $e) {
            return $this->error('Hôm nay bạn đã điểm danh rồi, mai quay lại nhé!');
        }
        $count = count($this->monthDays($p->UserID));
        $now = $this->now();
        $items = [];
        $gold = 0;
        $money = 0;
        $xuWeb = 0;
        $got = [];
        foreach ($this->rewards() as $r) {
            if ((int)$r->Moc !== 0 && (int)$r->Moc !== $count) continue;
            if ($r->TemplateID > 0) {
                // TemplateID,Count,ValidDate,StrengthenLevel,AttackCompose,DefendCompose,AgilityCompose,LuckCompose,IsBind
                $items[] = implode(',', [(int)$r->TemplateID, max(1, (int)$r->Cnt), (int)$r->ValidDate, (int)$r->StrengthenLevel, 0, 0, 0, 0, $r->IsBind ? 'true' : 'false']);
            }
            $gold += (int)$r->Gold;
            $money += (int)$r->Money;
            $xuWeb += (int)$r->XuWeb;
            $got[] = self::label($r);
        }
        // SendMailAndItem nhan toi da 5 mon moi thu
        $ok = true;
        $chunks = $items ? array_chunk($items, 5) : [[]];
        foreach ($chunks as $i => $chunk) {
            if (!$chunk && !$gold && !$money) continue;
            $title = 'Quà điểm danh ngày ' . $now->d . '/' . $now->m . ' (ngày thứ ' . $count . ' trong tháng)';
            $r = $this->sendMail($p->UserID, $title, $chunk, $i === 0 ? $gold : 0, $i === 0 ? $money : 0);
            if ($r !== '1') { $ok = false; break; }
        }
        if (!$ok) {
            $db->delete("DELETE FROM Web_DiemDanh WHERE UserID=? AND Ngay=CAST(GETDATE() AS date)", [$p->UserID]);
            return $this->error('Máy chủ game đang bận, chưa gửi được quà. Thử lại sau ít phút.');
        }
        // xu web cong thang vao vi (khong qua thu)
        if ($xuWeb > 0) XuWeb::doi((int)auth()->user()->UserID, $xuWeb, 'diemdanh', 'Điểm danh ngày ' . $now->d . '/' . $now->m);
        // diem hoat dong (tien ke hiem shop web): moi ngay + diem_diemdanh, du 7/14/21/28 ngay them diem_moc
        $diem = CauHinh::int('diem_diemdanh', 10) + (in_array($count, [7, 14, 21, 28], true) ? CauHinh::int('diem_moc', 20) : 0);
        if ($diem > 0) {
            Diem::doi((int)auth()->user()->UserID, $diem, 'diemdanh', 'Điểm danh ngày thứ ' . $count . ' trong tháng');
            $got[] = $diem . ' điểm hoạt động';
        }
        return $this->success('Điểm danh thành công! Quà đã gửi vào hộp thư trong game' . ($xuWeb ? ', xu web đã cộng vào ví' : '') . '.', ['songay' => $count, 'qua' => $got]);
    }

    private function sendMail($uid, $title, $items, $gold, $money)
    {
        $q = http_build_query(['title' => $title, 'content' => $title, 'user_id' => $uid, 'gold' => $gold, 'money' => $money,
            'str' => implode('|', $items)], '', '&', PHP_QUERY_RFC3986);
        $ctx = stream_context_create(['http' => ['timeout' => 30, 'ignore_errors' => true]]);
        $r = @file_get_contents('http://127.0.0.1/SendMailAndItem.aspx?' . $q, false, $ctx);
        if ($r === false) return 'khong goi duoc';
        return preg_match('/^\s*(-?\d+)/', $r, $m) ? $m[1] : trim($r);
    }
}
