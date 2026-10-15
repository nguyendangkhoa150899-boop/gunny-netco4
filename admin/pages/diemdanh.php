<?php if (!defined('GN_ADMIN')) exit;
// diem danh tren web gunny.netco4.click (website_backend DiemDanhController); bang tao boi _setup/sql/diem-danh-web.sql
$has = (int)scalar($conn,"SELECT CASE WHEN OBJECT_ID('Db_Tank41.dbo.Web_DiemDanh_Qua') IS NULL THEN 0 ELSE 1 END");
$rew = $has ? q($conn,"SELECT q.ID,q.Moc,q.TemplateID,q.[Count] Cnt,q.ValidDate,q.StrengthenLevel,q.IsBind,q.Gold,q.[Money] Money,ISNULL(g.Name,'') Name,ISNULL(g.CategoryID,0) Cat,ISNULL(g.Pic,'') Pic,ISNULL(g.NeedSex,0) Sex,ISNULL(g.Quality,0) Q
  FROM Db_Tank41.dbo.Web_DiemDanh_Qua q LEFT JOIN Db_Tank.dbo.Shop_Goods g ON g.TemplateID=q.TemplateID ORDER BY q.Moc,q.ID") : [];
$stat = $has ? q($conn,"SELECT
  (SELECT COUNT(*) FROM Db_Tank41.dbo.Web_DiemDanh WHERE Ngay=CAST(GETDATE() AS date)) homnay,
  (SELECT COUNT(DISTINCT UserID) FROM Db_Tank41.dbo.Web_DiemDanh WHERE Ngay>=DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),1)) thang")[0] : null;
$last = $has ? q($conn,"SELECT TOP 15 d.Ngay,d.ThoiGian,ISNULL(u.NickName,'') NickName,ISNULL(u.UserName,'') UserName FROM Db_Tank41.dbo.Web_DiemDanh d LEFT JOIN Db_Tank41.dbo.Sys_Users_Detail u ON u.UserID=d.UserID ORDER BY d.ThoiGian DESC") : [];
$maxStr = max_strength($conn);
?>
<style>.lbl{display:flex;flex-direction:column;gap:4px;flex:1;min-width:0;font-size:12px;color:var(--muted)} .lbl > span{white-space:nowrap}</style>
<h2>Điểm danh (trên web)</h2>
<div class="note">Người chơi đăng nhập ở <b>gunny.netco4.click</b>, mỗi ngày bấm điểm danh 1 lần, quà về <b>hộp thư trong game</b> (đang online cũng nhận được). <b>Mốc 0</b> = quà mỗi ngày. <b>Mốc N</b> = quà thêm vào đúng ngày người chơi đủ N ngày điểm danh trong tháng. Sang tháng mới đếm lại từ 0. Sửa quà có hiệu lực ngay. Điểm danh trong game bị khóa sẵn trong server gốc nên chuyển ra web.</div>
<?php if(!$has): ?>
  <div class="box">Chưa có bảng điểm danh. Chạy trên VPS: <code>sqlcmd -S localhost -E -C -b -f 65001 -i C:\Gunny92\_setup\sql\diem-danh-web.sql</code></div>
<?php else: ?>
<div class="grid2">
  <div class="box"><h3>Thống kê</h3>
    <div>Hôm nay: <b><?= (int)$stat['homnay'] ?></b> người đã điểm danh</div>
    <div>Tháng này: <b><?= (int)$stat['thang'] ?></b> người</div></div>
  <form class="box" method="post"><?= csrf() ?><input type="hidden" name="act" value="dd_add"><h3>Thêm quà</h3>
    <div class="row"><label class="lbl"><span>Mốc (0 = mỗi ngày)</span><input name="moc" type="number" min="0" max="31" value="0"></label>
      <label class="lbl"><span>ID vật phẩm · <a href="?page=mail" target="_blank">tìm ID</a></span><input name="tid" type="number" min="0" placeholder="0 = chỉ vàng/xu"></label>
      <label class="lbl"><span>Số lượng</span><input name="cnt" type="number" min="1" value="1"></label></div>
    <div class="row"><label class="lbl"><span>Hạn ngày (0 = vĩnh viễn)</span><input name="day" type="number" min="0" value="0"></label>
      <label class="lbl"><span>Cường hóa (0 đến <?= $maxStr ?>)</span><input name="str" type="number" min="0" max="<?= $maxStr ?>" value="0"></label>
      <label class="lbl"><span>Vàng</span><input name="gold" type="number" min="0" value="0"></label>
      <label class="lbl"><span>Xu</span><input name="money" type="number" min="0" value="0"></label></div>
    <label style="font-size:13px;display:block;margin-top:8px"><input type="checkbox" name="bind" value="1" checked> Khóa (không giao dịch được)</label>
    <button class="btn sm mt">Thêm quà</button></form>
</div>
<h2>Quà điểm danh</h2>
<table><tr><th>Mốc</th><th>Quà</th><th>Số lượng</th><th>Hạn</th><th>Cường hóa</th><th>Vàng</th><th>Xu</th><th></th></tr>
<?php foreach($rew as $w): ?>
  <tr><td><b><?= (int)$w['Moc'] ? 'Đủ '.(int)$w['Moc'].' ngày' : 'Mỗi ngày' ?></b></td>
    <td><div style="display:flex;align-items:center;gap:10px">
      <?php if((int)$w['TemplateID']>0): ?><img src="<?= h(item_icon_url($w['Cat'],$w['Pic'],$w['Sex'])) ?>" alt="" style="width:40px;height:40px;object-fit:contain;background:#0d1626;border:2px solid <?= quality_color($w['Q']) ?>;border-radius:8px"><?php endif; ?>
      <span><?= h($w['Name'] ?: ((int)$w['TemplateID'] ? 'ID '.(int)$w['TemplateID'] : 'vàng / xu')) ?><br><span class="muted">ID <?= (int)$w['TemplateID'] ?><?= $w['IsBind'] ? ' · khóa' : '' ?></span></span></div></td>
    <td><?= (int)$w['Cnt'] ?></td><td><?= (int)$w['ValidDate'] ? (int)$w['ValidDate'].' ngày' : 'vĩnh viễn' ?></td><td><?= (int)$w['StrengthenLevel'] ?></td><td><?= n($w['Gold']) ?></td><td><?= n($w['Money']) ?></td>
    <td><form method="post" style="margin:0"><?= csrf() ?><input type="hidden" name="act" value="dd_del"><input type="hidden" name="id" value="<?= (int)$w['ID'] ?>"><button class="btn sm danger">Xóa</button></form></td></tr>
<?php endforeach; if(!$rew) echo '<tr><td colspan="8" class="muted">Chưa có quà, điểm danh sẽ không gửi gì.</td></tr>'; ?>
</table>
<h2>Điểm danh gần đây</h2>
<table><tr><th>Thời gian</th><th>Nhân vật</th><th>Tài khoản</th></tr>
<?php foreach($last as $l): ?>
  <tr><td><?= h(substr((string)$l['ThoiGian'],0,19)) ?></td><td><?= h($l['NickName']) ?></td><td><?= h($l['UserName']) ?></td></tr>
<?php endforeach; if(!$last) echo '<tr><td colspan="3" class="muted">Chưa ai điểm danh.</td></tr>'; ?>
</table>
<?php endif; ?>
