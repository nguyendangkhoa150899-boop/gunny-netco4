<?php if (!defined('GN_ADMIN')) exit;
$acts = q($conn,"SELECT a.ActiveID,a.Title,a.Type,a.HasKey,a.StartDate,a.EndDate,ISNULL(a.CodePrefix,'') CodePrefix,
  (SELECT COUNT(*) FROM Db_Tank41.dbo.Active_Number n WHERE n.ActiveID=a.ActiveID) codes,
  (SELECT COUNT(*) FROM Db_Tank41.dbo.Active_Number n WHERE n.ActiveID=a.ActiveID AND n.PullDown=1) used
  FROM Db_Tank.dbo.Active a ORDER BY a.ActiveID DESC");
$sel = (int)($_GET['aid'] ?? 0);
$awards = $sel ? q($conn,"SELECT w.ID,w.ItemID,w.Count,w.ValidDate,w.StrengthenLevel,w.Gold,w.Money,ISNULL(g.Name,'') Name,ISNULL(g.CategoryID,0) Cat,ISNULL(g.Pic,'') Pic,ISNULL(g.NeedSex,0) Sex,ISNULL(g.Quality,0) Q FROM Db_Tank.dbo.Active_Award w LEFT JOIN Db_Tank.dbo.Shop_Goods g ON g.TemplateID=w.ItemID WHERE w.ActiveID=? ORDER BY w.ID",[$sel]) : [];
$codes = $_SESSION['gc_codes'] ?? null; unset($_SESSION['gc_codes']);
$now = date('Y-m-d H:i:s');
?>
<h2>Giftcode</h2>
<div class="note">Người chơi nhập code trong game, quà về hộp thư. Mỗi <b>sự kiện</b> (bảng <code>Db_Tank.Active</code>) có danh sách quà (<code>Active_Award</code>) và các code (<code>Db_Tank41.Active_Number</code>). Code chỉ dùng được khi sự kiện còn hạn. Đổi sự kiện hoặc quà xong bấm <b>Xuất bản dữ liệu</b> ở trang Hệ thống để client cập nhật.</div>
<?php if($codes): ?>
  <div class="box" style="margin-bottom:16px"><h3>Code vừa tạo (<?= count($codes) ?>)</h3>
    <textarea rows="6" readonly id="codes"><?= h(implode("\n",$codes)) ?></textarea>
    <button type="button" class="btn sm blue mt" id="copyCodes">Sao chép</button></div>
  <script>document.getElementById('copyCodes').onclick=function(){var t=document.getElementById('codes');t.select();(navigator.clipboard?navigator.clipboard.writeText(t.value):Promise.resolve()).then(()=>{this.textContent='Đã sao chép'});};</script>
<?php endif; ?>
<div class="grid2">
  <form class="box" method="post"><?= csrf() ?><input type="hidden" name="act" value="gc_new"><h3>Tạo sự kiện code mới</h3>
    <div class="muted">Chép cài đặt từ một sự kiện code có sẵn, chỉ đổi tên, hạn và tiền tố.</div>
    <input name="title" placeholder="Tên sự kiện, vd: Code tân thủ" class="mt">
    <input name="desc" placeholder="Mô tả ngắn" class="mt">
    <div class="row"><input name="end" type="date" value="<?= date('Y-m-d',strtotime('+30 days')) ?>"><input name="prefix" placeholder="Tiền tố code, vd: NC4" maxlength="6"></div>
    <button class="btn sm mt">Tạo sự kiện</button></form>
  <?php if($sel): ?>
  <div class="box"><h3>Sự kiện #<?= $sel ?>: thêm quà</h3>
    <form method="post"><?= csrf() ?><input type="hidden" name="act" value="gc_award_add"><input type="hidden" name="aid" value="<?= $sel ?>">
      <div class="row"><input name="tid" type="number" placeholder="TemplateID vật phẩm"><input name="cnt" type="number" min="1" value="1" title="Số lượng"><input name="day" type="number" min="0" value="0" title="Hạn ngày (0 = vĩnh viễn)"></div>
      <div class="row"><input name="str" type="number" min="0" max="<?= max_strength($conn) ?>" value="0" title="Cường hóa (0 đến <?= max_strength($conn) ?>)"><input name="gold" type="number" min="0" placeholder="Vàng"><input name="money" type="number" min="0" placeholder="Xu"></div>
      <button class="btn sm mt">Thêm quà</button> <a class="muted" href="?page=mail" target="_blank">Tìm TemplateID</a></form>
    <form method="post" class="row"><?= csrf() ?><input type="hidden" name="act" value="gc_codes"><input type="hidden" name="aid" value="<?= $sel ?>">
      <input name="num" type="number" min="1" max="500" value="10" title="Số code"><button class="btn sm blue" style="flex:0;white-space:nowrap">Tạo code</button></form>
    <form method="post" class="row"><?= csrf() ?><input type="hidden" name="act" value="gc_end"><input type="hidden" name="aid" value="<?= $sel ?>">
      <input name="end" type="date" value="<?= date('Y-m-d',strtotime('+30 days')) ?>"><button class="btn sm" style="flex:0;white-space:nowrap">Đổi hạn</button></form>
  </div>
  <?php else: ?><div class="box muted">Chọn một sự kiện ở bảng dưới để thêm quà, tạo code, đổi hạn.</div><?php endif; ?>
</div>
<?php if($sel): ?>
<h2>Quà của sự kiện #<?= $sel ?></h2>
<table><tr><th>Vật phẩm</th><th>Số lượng</th><th>Hạn</th><th>Cường hóa</th><th>Vàng</th><th>Xu</th><th></th></tr>
<?php foreach($awards as $w): ?>
  <tr><td><div style="display:flex;align-items:center;gap:10px">
    <?php if((int)$w['ItemID']>0): ?><img src="<?= h(item_icon_url($w['Cat'],$w['Pic'],$w['Sex'])) ?>" alt="" style="width:40px;height:40px;object-fit:contain;background:#0d1626;border:2px solid <?= quality_color($w['Q']) ?>;border-radius:8px"><?php endif; ?>
    <span><?= h($w['Name'] ?: 'vàng / xu') ?><br><span class="muted">ID <?= (int)$w['ItemID'] ?></span></span></div></td><td><?= (int)$w['Count'] ?></td><td><?= (int)$w['ValidDate'] ?: 'vĩnh viễn' ?></td><td><?= (int)$w['StrengthenLevel'] ?></td><td><?= n($w['Gold']) ?></td><td><?= n($w['Money']) ?></td>
    <td><form method="post" style="margin:0"><?= csrf() ?><input type="hidden" name="act" value="gc_award_del"><input type="hidden" name="id" value="<?= (int)$w['ID'] ?>"><button class="btn sm danger">Xóa</button></form></td></tr>
<?php endforeach; if(!$awards) echo '<tr><td colspan="7" class="muted">Chưa có quà.</td></tr>'; ?>
</table>
<?php endif; ?>
<h2>Các sự kiện</h2>
<table><tr><th>ID</th><th>Tên</th><th>Loại</th><th>Hạn</th><th>Tiền tố</th><th>Code đã tạo / đã dùng</th><th></th></tr>
<?php foreach($acts as $a): $live = $a['EndDate']===null || $a['EndDate'] > $now; ?>
  <tr><td><?= (int)$a['ActiveID'] ?></td><td><?= h($a['Title']) ?></td><td><?= (int)$a['Type'] ?><?= (int)$a['HasKey'] ? ' (cần code)' : '' ?></td>
    <td><?= h(substr((string)$a['EndDate'],0,10)) ?> <?= $live ? '<span class="tag ok">còn hạn</span>' : '<span class="tag ban">hết hạn</span>' ?></td>
    <td><?= h($a['CodePrefix']) ?></td><td><?= (int)$a['codes'] ?> / <?= (int)$a['used'] ?></td>
    <td><a class="btn sm blue" href="?page=giftcode&aid=<?= (int)$a['ActiveID'] ?>">Chọn</a></td></tr>
<?php endforeach; ?>
</table>
