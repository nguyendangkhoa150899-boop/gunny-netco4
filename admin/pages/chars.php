<?php if (!defined('GN_ADMIN')) exit;
$kw = trim($_GET['q'] ?? '');
$sql = "SELECT TOP 100 UserID,UserName,NickName,Grade,Gold,Money,MoneyLock,Win,Total,State,LastDate FROM Db_Tank41.dbo.Sys_Users_Detail ";
$rows = $kw==='' ? q($conn,$sql."ORDER BY State DESC, LastDate DESC") : q($conn,$sql."WHERE UserName LIKE ? OR NickName LIKE ? ORDER BY State DESC, LastDate DESC",['%'.$kw.'%','%'.$kw.'%']);
$maxLv = max_level($conn);
?>
<h2>Nhân vật</h2>
<form class="row" method="get" style="max-width:420px;margin-bottom:12px"><input type="hidden" name="page" value="chars"><input name="q" value="<?= h($kw) ?>" placeholder="Tìm tài khoản hoặc tên nhân vật"><button class="btn sm" style="flex:0">Tìm</button></form>
<div class="note"><b>Cộng xu</b> đi qua kênh nạp nội bộ, người đang online nhận ngay. <b>Lên cấp / Buff</b> ghi thẳng DB nên chỉ áp dụng cho nhân vật <b>offline</b> (đang online thì lúc thoát server ghi đè lại). Muốn tặng vàng, vật phẩm an toàn khi đang online: dùng trang <a href="?page=mail">Gửi quà</a>.</div>
<div class="grid3">
  <form class="box" method="post"><?= csrf() ?><input type="hidden" name="act" value="addxu"><h3>Cộng xu</h3><div class="muted">Online nhận ngay</div>
    <input name="user" placeholder="Tài khoản" class="mt"><input name="amount" type="number" min="1" value="1000000" class="mt"><button class="btn sm mt">Cộng xu</button></form>
  <form class="box" method="post"><?= csrf() ?><input type="hidden" name="act" value="maxlv"><h3>Lên cấp <?= $maxLv ?></h3><div class="muted">Nhân vật phải offline</div>
    <input name="user" placeholder="Tài khoản" class="mt"><button class="btn sm mt">Lên cấp tối đa</button></form>
  <form class="box" method="post"><?= csrf() ?><input type="hidden" name="act" value="buffall"><h3>Buff mọi nhân vật offline</h3><div class="muted">Cấp tối đa + vàng / xu và xu khóa tối thiểu</div>
    <div class="row"><input name="gold" type="number" min="0" value="50000000" title="Vàng tối thiểu"><input name="xu" type="number" min="0" value="10000000" title="Xu tối thiểu"></div><button class="btn sm danger mt">Buff tất cả</button></form>
</div>
<table>
  <tr><th>ID</th><th>Tài khoản</th><th>Nhân vật</th><th>Cấp</th><th>Vàng</th><th>Xu</th><th>Xu khóa</th><th>Thắng/Tổng</th><th>Trạng thái</th><th>Lần cuối</th></tr>
  <?php foreach($rows as $r): ?>
  <tr>
    <td><?= (int)$r['UserID'] ?></td><td><?= h($r['UserName']) ?></td><td><?= h($r['NickName']) ?></td><td><?= (int)$r['Grade'] ?></td>
    <td><?= n($r['Gold']) ?></td><td><?= n($r['Money']) ?></td><td><?= n($r['MoneyLock']) ?></td><td><?= (int)$r['Win'] ?>/<?= (int)$r['Total'] ?></td>
    <td><?= (int)$r['State']===1 ? '<span class="tag on">Online</span>' : '<span class="tag ok">Offline</span>' ?></td>
    <td><?= h(substr((string)$r['LastDate'],0,16)) ?></td>
  </tr>
  <?php endforeach; ?>
</table>
