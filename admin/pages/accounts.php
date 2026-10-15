<?php if (!defined('GN_ADMIN')) exit;
$kw = trim($_GET['q'] ?? '');
$rows = $kw==='' ? q($conn,"SELECT TOP 80 UserID,Email,Money,Point,VIPLevel,IsBan,TimeCreate FROM Db_Member.dbo.Mem_Account ORDER BY UserID DESC")
                 : q($conn,"SELECT TOP 80 UserID,Email,Money,Point,VIPLevel,IsBan,TimeCreate FROM Db_Member.dbo.Mem_Account WHERE Email LIKE ? ORDER BY UserID DESC",['%'.$kw.'%']);
?>
<h2>Tài khoản web <?= $kw!=='' ? '(tìm: '.h($kw).')' : '(80 mới nhất)' ?></h2>
<form class="row" method="get" style="max-width:420px;margin-bottom:12px"><input type="hidden" name="page" value="accounts"><input name="q" value="<?= h($kw) ?>" placeholder="Tìm tài khoản"><button class="btn sm" style="flex:0">Tìm</button></form>
<div class="note">Khóa ở đây chặn đăng nhập launcher/web (<code>Mem_Account.IsBan</code>). Xu web (Money) khác xu trong game.</div>
<table>
  <tr><th>ID</th><th>Tài khoản</th><th>Xu web</th><th>Point</th><th>VIP</th><th>Trạng thái</th><th>Tạo lúc</th><th></th></tr>
  <?php foreach($rows as $r): ?>
  <tr>
    <td><?= (int)$r['UserID'] ?></td><td><?= h($r['Email']) ?></td><td><?= n($r['Money']) ?></td><td><?= (int)$r['Point'] ?></td><td><?= (int)$r['VIPLevel'] ?></td>
    <td><?= $r['IsBan'] ? '<span class="tag ban">Khóa</span>' : '<span class="tag ok">OK</span>' ?></td>
    <td><?= h(ts($r['TimeCreate'])) ?></td>
    <td><form method="post" style="margin:0"><?= csrf() ?><input type="hidden" name="email" value="<?= h($r['Email']) ?>"><input type="hidden" name="act" value="<?= $r['IsBan']?'unban':'ban' ?>">
      <button class="btn sm <?= $r['IsBan']?'blue':'danger' ?>"><?= $r['IsBan']?'Mở khóa':'Khóa' ?></button></form></td>
  </tr>
  <?php endforeach; ?>
</table>
