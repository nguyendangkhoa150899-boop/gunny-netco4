<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;

/**
 * Ho so nguoi choi cho trang /dashboard: tai khoan (Db_Member.Mem_Account) + nhan vat (Db_Tank41.Sys_Users_Detail).
 * Luu y: nhan vat dang online thi vang/xu trong DB co the cham hon trong game vai phut (Road giu so lieu trong RAM).
 */
class HoSoController extends \App\Http\BaseController
{
    public function index()
    {
        $member = auth()->user();
        $db = DB::connection('sqlsrv_tank41');
        $c = $db->selectOne("SELECT TOP 1 d.UserID,d.NickName,d.Grade,d.GP,d.Sex,d.State,d.Gold,d.Money,d.MoneyLock,d.GiftToken,d.Win,d.Total,
              d.FightPower,d.ConsortiaID,ISNULL(c.ConsortiaName,'') Consortia,d.OnlineTime,d.LoginCount,d.Date,d.LastDate,d.Offer,d.AchievementPoint
            FROM Sys_Users_Detail d LEFT JOIN Consortia c ON c.ConsortiaID=d.ConsortiaID AND d.ConsortiaID>0
            WHERE d.UserName=? AND d.NickName<>'' ORDER BY d.UserID", [$member->Email]);
        $char = null;
        if ($c) {
            $lv = (int)$c->Grade;
            $cur = (int)($db->selectOne("SELECT ISNULL(MAX(GP),0) g FROM Db_Tank.dbo.LevelInfo WHERE Grade=?", [$lv])->g ?? 0);
            $next = $db->selectOne("SELECT TOP 1 GP g FROM Db_Tank.dbo.LevelInfo WHERE Grade=?", [$lv + 1]);
            $maxLv = (int)($db->selectOne("SELECT MAX(Grade) g FROM Db_Tank.dbo.LevelInfo")->g ?? $lv);
            $pct = $next ? max(0, min(100, round(100 * ((int)$c->GP - $cur) / max(1, (int)$next->g - $cur)))) : 100;
            $char = [
                'ten' => $c->NickName,
                'cap' => $lv,
                'capToiDa' => $maxLv,
                'kinhNghiem' => (int)$c->GP,
                'phanTramCap' => $pct,
                'gioiTinh' => (int)$c->Sex ? 'Nam' : 'Nữ',
                'online' => (int)$c->State === 1,
                'vang' => (int)$c->Gold,
                'xu' => (int)$c->Money,
                'xuKhoa' => (int)$c->MoneyLock,
                'leTien' => (int)$c->GiftToken,
                'lucChien' => (int)$c->FightPower,
                'thang' => (int)$c->Win,
                'tran' => (int)$c->Total,
                'congHien' => (int)$c->Offer,
                'thanhTich' => (int)$c->AchievementPoint,
                'bang' => $c->Consortia,
                'soLanDangNhap' => (int)$c->LoginCount,
                'ngayTao' => substr((string)$c->Date, 0, 10),
                'lanCuoi' => substr((string)$c->LastDate, 0, 16),
            ];
        }
        return $this->success('ok', [
            'taiKhoan' => $member->Email,
            'nhanVat' => $char,
        ]);
    }
}
