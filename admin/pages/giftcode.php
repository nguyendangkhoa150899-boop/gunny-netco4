<?php if (!defined('GN_ADMIN')) exit;
$acts = q($conn,"SELECT a.ActiveID,a.Title,a.Type,a.HasKey,a.StartDate,a.EndDate,ISNULL(a.CodePrefix,'') CodePrefix,
  (SELECT COUNT(DISTINCT n.AwardID) FROM Db_Tank41.dbo.Active_Number n WHERE n.ActiveID=a.ActiveID) codes,
  (SELECT COUNT(*) FROM Db_Tank41.dbo.Active_Number n WHERE n.ActiveID=a.ActiveID AND n.UserID<>0) used
  FROM Db_Tank.dbo.Active a ORDER BY a.ActiveID DESC");
$sel = (int)($_GET['aid'] ?? 0);
$awards = $sel ? q($conn,"SELECT w.ID,w.ItemID,w.Count,w.ValidDate,w.StrengthenLevel,w.Gold,w.Money,ISNULL(g.Name,'') Name,ISNULL(g.CategoryID,0) Cat,ISNULL(g.Pic,'') Pic,ISNULL(g.NeedSex,0) Sex,ISNULL(g.Quality,0) Q FROM Db_Tank.dbo.Active_Award w LEFT JOIN Db_Tank.dbo.Shop_Goods g ON g.TemplateID=w.ItemID WHERE w.ActiveID=? ORDER BY w.ID",[$sel]) : [];
// moi code 1 dong: dong goc (UserID=0) cho biet kieu (Creator), cac dong UserID<>0 la luot da nhan
$codeRows = $sel ? q($conn,"SELECT AwardID, MAX(CASE WHEN UserID=0 THEN Creator END) Creator, MAX(CASE WHEN UserID=0 THEN 1 ELSE 0 END) Alive,
  SUM(CASE WHEN UserID<>0 THEN 1 ELSE 0 END) Used, COUNT(DISTINCT CASE WHEN UserID<>0 THEN UserID END) People
  FROM Db_Tank41.dbo.Active_Number WHERE ActiveID=? GROUP BY AwardID ORDER BY MIN(GetDate) DESC",[$sel]) : [];
$newCode = $_SESSION['gc_new_code'] ?? ''; unset($_SESSION['gc_new_code']);
$now = date('Y-m-d H:i:s');
$maxStr = max_strength($conn);
?>
<style>
  .lbl{display:flex;flex-direction:column;gap:4px;flex:1;font-size:12px;color:var(--muted)}
  .opt{display:flex;align-items:flex-start;gap:8px;padding:10px 12px;border:1px solid var(--line);border-radius:10px;margin-top:8px;cursor:pointer;font-size:14px}
  .opt:has(input:checked){border-color:#2563eb;background:rgba(37,99,235,.12)}
  .opt small{display:block;color:var(--muted);font-size:12px;margin-top:2px}
  .opt input[type=number]{width:110px;display:inline-block;padding:4px 8px;margin:0 4px}
  .code{font-family:Consolas,monospace;font-size:15px;font-weight:700;letter-spacing:.5px;color:#ffd76a}
  tr.new td{background:rgba(255,215,106,.08)}
</style>
<h2>Giftcode</h2>
<div class="note">Người chơi vào game, mở bảng <b>Hoạt động</b>, chọn sự kiện rồi nhập code, quà về hộp thư. Mỗi <b>sự kiện</b> có một danh sách quà và có thể có nhiều code. Tạo hay xóa code có hiệu lực ngay. Đổi tên/hạn sự kiện hoặc quà thì bấm <b>Xuất bản dữ liệu</b> (ActiveList) ở trang Hệ thống, người chơi tắt mở lại launcher.</div>
<?php if($newCode): ?>
  <div class="box" style="margin-bottom:16px;display:flex;align-items:center;gap:14px;flex-wrap:wrap">
    <span>Code vừa tạo:</span><span class="code" style="font-size:22px"><?= h($newCode) ?></span>
    <button type="button" class="btn sm blue copy" data-code="<?= h($newCode) ?>" style="flex:0;white-space:nowrap">Sao chép</button></div>
<?php endif; ?>
<div class="grid2">
  <form class="box" method="post"><?= csrf() ?><input type="hidden" name="act" value="gc_new"><h3>Tạo sự kiện code mới</h3>
    <div class="muted">Chép cài đặt từ một sự kiện code có sẵn, chỉ đổi tên, hạn và tiền tố.</div>
    <input name="title" placeholder="Tên sự kiện, vd: Code tân thủ" class="mt">
    <input name="desc" placeholder="Mô tả ngắn" class="mt">
    <div class="row"><input name="end" type="date" value="<?= date('Y-m-d',strtotime('+30 days')) ?>"><input name="prefix" placeholder="Tiền tố code, vd: NC4" maxlength="6"></div>
    <button class="btn sm mt">Tạo sự kiện</button></form>
  <?php if($sel): ?>
  <div class="box">
    <form method="post"><?= csrf() ?><input type="hidden" name="act" value="gc_codes"><input type="hidden" name="aid" value="<?= $sel ?>">
      <h3>Sự kiện #<?= $sel ?>: tạo code</h3>
      <input name="code" placeholder="Tên code, vd: BIABIA2026 (bỏ trống = tự sinh tên)" style="text-transform:uppercase" maxlength="30">
      <label class="opt"><input type="radio" name="mode" value="multi">
        <span>Dùng nhiều lần, tổng <input type="number" name="times" min="1" max="100000" value="100"> lượt
        <small>Ai nhập cũng được, một người nhập lại nhiều lần cũng được. Hết lượt thì code ngừng.</small></span></label>
      <label class="opt"><input type="radio" name="mode" value="once" checked>
        <span>Mỗi người dùng 1 lần
        <small>Không giới hạn số người, mỗi nhân vật chỉ nhận 1 lần.</small></span></label>
      <button class="btn sm blue mt">Tạo code</button></form>
    <form method="post" style="margin-top:14px;border-top:1px solid var(--line);padding-top:10px"><?= csrf() ?><input type="hidden" name="act" value="gc_award_add"><input type="hidden" name="aid" value="<?= $sel ?>">
      <h3>Thêm quà</h3>
      <div class="row"><label class="lbl">ID vật phẩm (<a href="?page=mail" target="_blank">tìm ID</a>)<input name="tid" type="number" placeholder="vd: 71963"></label>
        <label class="lbl">Số lượng<input name="cnt" type="number" min="1" value="1"></label>
        <label class="lbl">Hạn ngày (0 = vĩnh viễn)<input name="day" type="number" min="0" value="0"></label></div>
      <div class="row"><label class="lbl">Cường hóa (0 đến <?= $maxStr ?>)<input name="str" type="number" min="0" max="<?= $maxStr ?>" value="0"></label>
        <label class="lbl">Vàng<input name="gold" type="number" min="0" placeholder="0"></label>
        <label class="lbl">Xu<input name="money" type="number" min="0" placeholder="0"></label></div>
      <button class="btn sm mt">Thêm quà</button></form>
    <form method="post" class="row" style="margin-top:14px;border-top:1px solid var(--line);padding-top:10px;align-items:flex-end"><?= csrf() ?><input type="hidden" name="act" value="gc_end"><input type="hidden" name="aid" value="<?= $sel ?>">
      <label class="lbl">Hạn sự kiện<input name="end" type="date" value="<?= date('Y-m-d',strtotime('+30 days')) ?>"></label><button class="btn sm" style="flex:0;white-space:nowrap">Đổi hạn</button></form>
  </div>
  <?php else: ?><div class="box muted">Chọn một sự kiện ở bảng dưới (nút <b>Chọn</b>) để tạo code, thêm quà, đổi hạn.</div><?php endif; ?>
</div>
<?php if($sel): ?>
<h2>Code của sự kiện #<?= $sel ?></h2>
<table><tr><th>Code</th><th>Kiểu</th><th>Đã dùng</th><th>Trạng thái</th><th></th></tr>
<?php foreach($codeRows as $c):
  $cr = $c['Creator']; $alive = (int)$c['Alive']; $used = (int)$c['Used']; $lim = 0;
  if($cr === null)        { $kind = '1 lần (code cũ)'; $use = $used ? 'đã dùng' : '0'; }
  elseif((int)$cr < -1)   { $lim = -(int)$cr - 1; $kind = 'Nhiều lần, '.n($lim).' lượt'; $use = n($used).' / '.n($lim).' lượt ('.(int)$c['People'].' người)'; }
  elseif((int)$cr === -1) { $kind = 'Mỗi người 1 lần'; $use = n($used).' người'; }
  else                    { $kind = '1 lần (1 người)'; $use = $used ? 'đã dùng' : '0 / 1'; }
  $state = !$alive ? '<span class="tag ban">'.($cr===null && $used ? 'đã dùng' : 'đã xóa').'</span>'
         : (($lim > 0 && $used >= $lim) ? '<span class="tag ban">hết lượt</span>' : '<span class="tag ok">dùng được</span>'); ?>
  <tr class="<?= $c['AwardID']===$newCode ? 'new' : '' ?>"><td><span class="code"><?= h($c['AwardID']) ?></span></td><td><?= $kind ?></td><td><?= $use ?></td><td><?= $state ?></td>
    <td style="white-space:nowrap"><button type="button" class="btn sm blue copy" data-code="<?= h($c['AwardID']) ?>">Sao chép</button>
      <?php if($alive): ?><form method="post" style="margin:0;display:inline"><?= csrf() ?><input type="hidden" name="act" value="gc_code_del"><input type="hidden" name="aid" value="<?= $sel ?>"><input type="hidden" name="code" value="<?= h($c['AwardID']) ?>"><button class="btn sm danger">Xóa</button></form><?php endif; ?></td></tr>
<?php endforeach; if(!$codeRows) echo '<tr><td colspan="5" class="muted">Chưa có code. Tạo ở khung bên trên.</td></tr>'; ?>
</table>
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
<table><tr><th>ID</th><th>Tên</th><th>Loại</th><th>Hạn</th><th>Tiền tố</th><th>Số code / lượt đã nhận</th><th></th></tr>
<?php foreach($acts as $a): $live = $a['EndDate']===null || $a['EndDate'] > $now; ?>
  <tr<?= (int)$a['ActiveID']===$sel ? ' class="new"' : '' ?>><td><?= (int)$a['ActiveID'] ?></td><td><?= h($a['Title']) ?></td><td><?= (int)$a['Type'] ?><?= (int)$a['HasKey'] ? ' (cần code)' : '' ?></td>
    <td><?= h(substr((string)$a['EndDate'],0,10)) ?> <?= $live ? '<span class="tag ok">còn hạn</span>' : '<span class="tag ban">hết hạn</span>' ?></td>
    <td><?= h($a['CodePrefix']) ?></td><td><?= (int)$a['codes'] ?> / <?= (int)$a['used'] ?></td>
    <td><a class="btn sm blue" href="?page=giftcode&aid=<?= (int)$a['ActiveID'] ?>">Chọn</a></td></tr>
<?php endforeach; ?>
</table>
<script>
document.querySelectorAll('.copy').forEach(function(b){ b.addEventListener('click',function(){
  var t=b.dataset.code, done=function(){ var o=b.textContent; b.textContent='Đã chép'; setTimeout(function(){ b.textContent=o; },1500); };
  if(navigator.clipboard && window.isSecureContext){ navigator.clipboard.writeText(t).then(done); return; }
  var a=document.createElement('textarea'); a.value=t; document.body.appendChild(a); a.select(); try{ document.execCommand('copy'); done(); }catch(e){} a.remove();
});});
document.querySelectorAll('.opt input[type=number]').forEach(function(i){ i.addEventListener('focus',function(){ i.closest('.opt').querySelector('input[type=radio]').checked=true; }); });
</script>
