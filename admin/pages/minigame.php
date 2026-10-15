<?php if (!defined('GN_ADMIN')) exit;
// Mini game tren web (website_backend MiniGameController). Bang: _setup/sql/minigame-web.sql (Db_Member).
$has = (int)scalar($conn,"SELECT CASE WHEN OBJECT_ID('Db_Member.dbo.Web_CauHinh') IS NULL THEN 0 ELSE 1 END");
if (!$has) { echo '<h2>Mini game</h2><div class="box">Chưa có bảng. Chạy trên VPS: <code>sqlcmd -S localhost -E -C -b -f 65001 -i C:\Gunny92\_setup\sql\minigame-web.sql</code></div>'; return; }
$cfg = q($conn,"SELECT Khoa,GiaTri,ISNULL(MoTa,'') MoTa FROM Db_Member.dbo.Web_CauHinh ORDER BY Khoa");
$tk = q($conn,"SELECT
  (SELECT ISNULL(SUM(CAST(Cuoc AS bigint)),0) FROM Db_Member.dbo.Web_TaiXiu WHERE ThoiGian>=CAST(GETDATE() AS date)) txCuoc,
  (SELECT ISNULL(SUM(CAST(Nhan AS bigint)),0) FROM Db_Member.dbo.Web_TaiXiu WHERE ThoiGian>=CAST(GETDATE() AS date)) txTra,
  (SELECT COUNT(*) FROM Db_Member.dbo.Web_TaiXiu WHERE ThoiGian>=CAST(GETDATE() AS date)) txVan,
  (SELECT ISNULL(SUM(CAST(Cuoc AS bigint)),0) FROM Db_Member.dbo.Web_DoMin WHERE ThoiGian>=CAST(GETDATE() AS date) AND TrangThai<>0) dmCuoc,
  (SELECT ISNULL(SUM(CAST(Nhan AS bigint)),0) FROM Db_Member.dbo.Web_DoMin WHERE ThoiGian>=CAST(GETDATE() AS date) AND TrangThai<>0) dmTra,
  (SELECT COUNT(*) FROM Db_Member.dbo.Web_DoMin WHERE ThoiGian>=CAST(GETDATE() AS date)) dmVan,
  (SELECT COUNT(*) FROM Db_Member.dbo.Web_The_Luot WHERE Ngay=CAST(GETDATE() AS date)) ltLuot,
  (SELECT COUNT(*) FROM Db_Member.dbo.Web_Ruong) rgMon")[0];
$top = q($conn,"SELECT TOP 10 Email,Money FROM Db_Member.dbo.Mem_Account WHERE Money>0 ORDER BY Money DESC");
$pbs = q($conn,"SELECT p.Khoa,p.ManCuoi,p.SoLanNgay,p.BatTat,(SELECT COUNT(*) FROM Db_Member.dbo.Web_The_Qua q WHERE q.Khoa=p.Khoa) soQua FROM Db_Member.dbo.Web_The_PhoBan p ORDER BY p.BatTat DESC,p.ManCuoi");
$selPb = (string)($_GET['pb'] ?? '');
$pool = q($conn,"SELECT w.ID,w.TemplateID,w.[Count] Cnt,w.ValidDate,w.StrengthenLevel,w.IsBind,w.XuWeb,w.TrongSo,ISNULL(g.Name,'') Name,ISNULL(g.CategoryID,0) Cat,ISNULL(g.Pic,'') Pic,ISNULL(g.NeedSex,0) Sex,ISNULL(g.Quality,0) Q
  FROM Db_Member.dbo.Web_The_Qua w LEFT JOIN Db_Tank.dbo.Shop_Goods g ON g.TemplateID=w.TemplateID WHERE ".($selPb===''?'w.Khoa IS NULL':'w.Khoa=?')." ORDER BY w.TrongSo DESC,w.ID", $selPb===''?[]:[$selPb]);
$tong = array_sum(array_map(fn($x)=>(int)$x['TrongSo'], $pool));
$maxStr = max_strength($conn);
$soLan = (int)scalar($conn,"SELECT GiaTri FROM Db_Member.dbo.Web_CauHinh WHERE Khoa='lt_solan'");
?>
<style>.lbl{display:flex;flex-direction:column;gap:4px;flex:1;min-width:0;font-size:12px;color:var(--muted)} .lbl > span{white-space:nowrap} td form{margin:0}</style>
<h2>Mini game (trang cá nhân người chơi)</h2>
<div class="note">Người chơi chơi ở <b>gunny.netco4.click/dashboard</b> bằng <b>xu web</b> (<code>Mem_Account.Money</code>), đổi sang xu game ở mục Ví xu. Kết quả ngẫu nhiên sinh ở server, <b>không có công cụ ép kết quả</b>. Lật thẻ: đánh xong boss ải cuối của phó bản trong game thì có lượt (đọc <code>Sys_Users_Log</code> WinMission), quà quay theo trọng số lúc lật.</div>

<div class="grid2">
  <div class="box"><h3>Hôm nay</h3>
    <table><tr><th></th><th>Ván</th><th>Cược</th><th>Trả</th><th>Nhà cái</th></tr>
      <tr><td>Tài xỉu</td><td><?= n($tk['txVan']) ?></td><td><?= n($tk['txCuoc']) ?></td><td><?= n($tk['txTra']) ?></td><td><?= n($tk['txCuoc']-$tk['txTra']) ?></td></tr>
      <tr><td>Dò mìn</td><td><?= n($tk['dmVan']) ?></td><td><?= n($tk['dmCuoc']) ?></td><td><?= n($tk['dmTra']) ?></td><td><?= n($tk['dmCuoc']-$tk['dmTra']) ?></td></tr></table>
    <div class="mt">Lượt lật thẻ hôm nay: <b><?= n($tk['ltLuot']) ?></b> · Món đang nằm trong rương web: <b><?= n($tk['rgMon']) ?></b></div>
    <h3 class="mt">Nhiều xu web nhất</h3>
    <table><?php foreach($top as $t): ?><tr><td><?= h($t['Email']) ?></td><td><?= n($t['Money']) ?></td></tr><?php endforeach; if(!$top) echo '<tr><td class="muted">Chưa ai có xu web.</td></tr>'; ?></table>
  </div>
  <div>
    <form class="box" method="post"><?= csrf() ?><input type="hidden" name="act" value="mg_xu"><h3>Cộng / trừ xu web</h3>
      <div class="row"><label class="lbl"><span>Tài khoản</span><input name="user" placeholder="vd: bialk"></label>
        <label class="lbl"><span>Số xu (âm để trừ)</span><input name="xu" type="number" placeholder="vd: 100000"></label></div>
      <input name="note" placeholder="Ghi chú (hiện trong lịch sử ví của người chơi)" class="mt">
      <button class="btn sm mt">Thực hiện</button></form>
    <form class="box mt" method="post"><?= csrf() ?><input type="hidden" name="act" value="mg_cfg"><h3>Cấu hình</h3>
      <table><?php foreach($cfg as $c): ?><tr><td style="width:46%"><b><?= h($c['Khoa']) ?></b><div class="muted"><?= h($c['MoTa']) ?></div></td>
        <td><input name="cfg[<?= h($c['Khoa']) ?>]" value="<?= h($c['GiaTri']) ?>"></td></tr><?php endforeach; ?></table>
      <button class="btn sm mt">Lưu cấu hình</button></form>
  </div>
</div>

<h2>Quà lật thẻ: <?= $selPb==='' ? 'bộ chung (phó bản chưa có bộ riêng)' : h($selPb) ?></h2>
<div class="note">Mỗi lần lật, server quay 1 món theo <b>trọng số</b>: tỉ lệ = trọng số / tổng trọng số. Món hiếm thì để trọng số nhỏ (vd 1 trên tổng 100 = 1%). Phó bản có bộ quà riêng thì dùng bộ riêng, không thì dùng bộ chung. Món phẩm chất tím trở lên hoặc từ 10.000 xu web hiện mặt bài VIP vàng.</div>
<form method="get" class="row" style="max-width:640px"><input type="hidden" name="page" value="minigame">
  <select name="pb" onchange="this.form.submit()"><option value="">Bộ chung</option>
    <?php foreach($pbs as $p): ?><option value="<?= h($p['Khoa']) ?>" <?= $p['Khoa']===$selPb?'selected':'' ?>><?= h($p['Khoa']) ?><?= $p['soQua']?' ('.$p['soQua'].' quà riêng)':'' ?></option><?php endforeach; ?></select></form>
<table class="mt"><tr><th>Quà</th><th>Số lượng</th><th>Hạn</th><th>Cường hóa</th><th>Xu web</th><th>Trọng số</th><th>Tỉ lệ</th><th></th></tr>
<?php foreach($pool as $w): ?>
  <tr><td><div style="display:flex;align-items:center;gap:10px">
    <?php if((int)$w['TemplateID']>0): ?><img src="<?= h(item_icon_url($w['Cat'],$w['Pic'],$w['Sex'])) ?>" alt="" style="width:40px;height:40px;object-fit:contain;background:#0d1626;border:2px solid <?= quality_color($w['Q']) ?>;border-radius:8px"><?php endif; ?>
    <span><?= (int)$w['TemplateID'] ? h($w['Name'] ?: 'ID '.$w['TemplateID']) : 'Chỉ xu web' ?><br><span class="muted">ID <?= (int)$w['TemplateID'] ?><?= $w['IsBind']?' · khóa':'' ?></span></span></div></td>
    <td><?= (int)$w['Cnt'] ?></td><td><?= (int)$w['ValidDate'] ? (int)$w['ValidDate'].' ngày' : 'vĩnh viễn' ?></td><td><?= (int)$w['StrengthenLevel'] ?></td><td><?= n($w['XuWeb']) ?></td>
    <td><form method="post" class="row" style="gap:4px"><?= csrf() ?><input type="hidden" name="act" value="mg_qua_ts"><input type="hidden" name="id" value="<?= (int)$w['ID'] ?>"><input type="hidden" name="pb" value="<?= h($selPb) ?>"><input name="ts" type="number" min="0" value="<?= (int)$w['TrongSo'] ?>" style="width:80px"><button class="btn sm" style="flex:0">Lưu</button></form></td>
    <td><b><?= $tong ? round(100*$w['TrongSo']/$tong,2) : 0 ?>%</b></td>
    <td><form method="post"><?= csrf() ?><input type="hidden" name="act" value="mg_qua_del"><input type="hidden" name="id" value="<?= (int)$w['ID'] ?>"><input type="hidden" name="pb" value="<?= h($selPb) ?>"><button class="btn sm danger">Xóa</button></form></td></tr>
<?php endforeach; if(!$pool) echo '<tr><td colspan="8" class="muted">'.($selPb===''?'Bộ chung trống: lật ra 100 xu web.':'Phó bản này chưa có quà riêng, đang dùng bộ chung.').'</td></tr>'; ?>
</table>
<form class="box mt" method="post"><?= csrf() ?><input type="hidden" name="act" value="mg_qua_add"><input type="hidden" name="pb" value="<?= h($selPb) ?>"><h3>Thêm quà vào <?= $selPb==='' ? 'bộ chung' : h($selPb) ?></h3>
  <div class="row"><label class="lbl"><span>ID vật phẩm · <a href="?page=mail" target="_blank">tìm ID</a></span><input name="tid" type="number" min="0" value="0"></label>
    <label class="lbl"><span>Số lượng</span><input name="cnt" type="number" min="1" value="1"></label>
    <label class="lbl"><span>Hạn ngày (0 = vĩnh viễn)</span><input name="day" type="number" min="0" value="0"></label>
    <label class="lbl"><span>Cường hóa (0 đến <?= $maxStr ?>)</span><input name="str" type="number" min="0" max="<?= $maxStr ?>" value="0"></label></div>
  <div class="row"><label class="lbl"><span>Xu web kèm theo</span><input name="xu" type="number" min="0" value="0"></label>
    <label class="lbl"><span>Trọng số (càng nhỏ càng hiếm)</span><input name="ts" type="number" min="1" value="10"></label>
    <label class="lbl" style="justify-content:flex-end"><span><input type="checkbox" name="bind" value="1" checked> Khóa (không giao dịch)</span></label></div>
  <button class="btn sm mt">Thêm quà</button></form>

<h2>Phó bản có lật thẻ</h2>
<div class="note">Tách tự động từ tên ải trong <code>Mission_Info</code> (bỏ " S4", " ải 4" ở cuối). Đánh xong <b>ải cuối</b> (cột Màn boss) mới có lượt. Số lượt/ngày để trống = dùng mặc định <b><?= $soLan ?></b> (cấu hình <code>lt_solan</code>).</div>
<table><tr><th>Phó bản</th><th>Màn boss</th><th>Lượt/ngày</th><th>Bật</th><th>Quà riêng</th></tr>
<?php foreach($pbs as $p): ?>
  <tr<?= $p['BatTat']?'':' style="opacity:.5"' ?>><td><?= h($p['Khoa']) ?></td><td><?= (int)$p['ManCuoi'] ?></td>
    <td colspan="2"><form method="post" class="row" style="gap:6px;align-items:center"><?= csrf() ?><input type="hidden" name="act" value="mg_pb"><input type="hidden" name="khoa" value="<?= h($p['Khoa']) ?>">
      <input name="solan" type="number" min="0" placeholder="<?= $soLan ?>" value="<?= $p['SoLanNgay']===null?'':(int)$p['SoLanNgay'] ?>" style="width:90px">
      <label style="flex:0;white-space:nowrap"><input type="checkbox" name="bat" value="1" <?= $p['BatTat']?'checked':'' ?>> bật</label>
      <button class="btn sm" style="flex:0">Lưu</button></form></td>
    <td><a href="?page=minigame&pb=<?= rawurlencode($p['Khoa']) ?>"><?= (int)$p['soQua'] ? (int)$p['soQua'].' món' : 'dùng bộ chung' ?></a></td></tr>
<?php endforeach; ?>
</table>
