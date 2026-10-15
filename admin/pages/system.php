<?php if (!defined('GN_ADMIN')) exit;
$RN = [0=>'EXP',1=>'Vàng',2=>'Công hiến'];
$rates = q($conn,"SELECT ROW_NUMBER() OVER(ORDER BY Type,BeginDay,BeginTime,Rate) rn,Type,Rate,BeginDay,EndDay,BeginTime,EndTime FROM Db_Tank41.dbo.Rate WHERE ServerID=? ORDER BY rn",[SERVER_ID]);
$gms   = q($conn,"SELECT c.UserID,CAST(c.Commands AS nvarchar(200)) Commands,d.UserName,d.NickName FROM Db_Tank41.dbo.Game_Commands c LEFT JOIN Db_Tank41.dbo.Sys_Users_Detail d ON d.UserID=c.UserID");
$ck = trim($_GET['cfg'] ?? '');
$cfg = q($conn,"SELECT Name,CAST(Value AS nvarchar(1000)) Value FROM Db_Tank41.dbo.Server_Config ".($ck!==''?"WHERE Name LIKE ? OR CAST(Value AS nvarchar(1000)) LIKE ? ":"")."ORDER BY Name", $ck!=='' ? ['%'.$ck.'%','%'.$ck.'%'] : []);
// loai nap lai server qua NoticeServerUpdate.aspx (cac loai co xu ly that ben Road)
$RELOAD = [8=>'Vật phẩm (template)',14=>'Shop',9=>'Nhiệm vụ',12=>'Tỉ lệ',11=>'Server',16=>'Đấu trận',1=>'Đạn',2=>'Bản đồ',10=>'Dung hợp',13=>'Bang hội',17=>'Quà hằng ngày',60=>'Danh hiệu',65=>'Hoạt động phụ'];
?>
<h2>Hệ thống</h2>
<div class="grid2">
  <div class="box">
    <h3>Tỉ lệ EXP / Vàng / Công hiến</h3>
    <div class="muted">Áp dụng ngay vào server (<code>ExperienceRate.aspx</code>). Không có dòng nào là x1. Nhiều dòng cùng loại thì server lấy dòng khớp ngày giờ hiện tại.</div>
    <table class="mt"><tr><th>Loại</th><th>Hệ số</th><th>Ngày</th><th>Giờ</th><th></th></tr>
      <?php foreach($rates as $r): ?>
      <tr><td><?= h($RN[$r['Type']] ?? $r['Type']) ?></td><td>x<?= (float)$r['Rate'] ?></td><td><?= h(substr($r['BeginDay'],0,10)) ?> → <?= h(substr($r['EndDay'],0,10)) ?></td><td><?= h(substr($r['BeginTime'],11,5)) ?> → <?= h(substr($r['EndTime'],11,5)) ?></td>
        <td><form method="post" style="margin:0"><?= csrf() ?><input type="hidden" name="act" value="rate_del"><input type="hidden" name="rn" value="<?= (int)$r['rn'] ?>"><button class="btn sm danger">Xóa</button></form></td></tr>
      <?php endforeach; if(!$rates) echo '<tr><td colspan="5" class="muted">Chưa có, đang x1.</td></tr>'; ?>
    </table>
    <form method="post"><?= csrf() ?><input type="hidden" name="act" value="rate_add">
      <div class="row"><select name="type"><option value="0">EXP</option><option value="1">Vàng</option><option value="2">Công hiến</option></select><input name="rate" type="number" step="0.1" min="0.1" value="5" title="Hệ số"></div>
      <div class="row"><input name="bday" type="date" title="Từ ngày (trống = luôn)"><input name="eday" type="date" title="Đến ngày"></div>
      <div class="row"><input name="btime" type="time" value="00:00"><input name="etime" type="time" value="23:59"></div>
      <button class="btn sm mt">Thêm tỉ lệ</button></form>
  </div>
  <div class="box">
    <h3>Thông báo toàn server</h3>
    <form method="post"><?= csrf() ?><input type="hidden" name="act" value="notice">
      <textarea name="msg" rows="2" placeholder="Nội dung hiện cho mọi người đang online"></textarea><button class="btn sm mt">Phát thông báo</button></form>
    <h3 class="mt" style="margin-top:18px">Xuất bản dữ liệu</h3>
    <div class="muted">Dựng lại XML cho client từ DB, <b>chỉ chọn file vừa sửa</b>. DB đang thiếu dữ liệu so với client gốc ở các mục đánh dấu đỏ, dựng lại sẽ làm client mất nội dung. Rơi đồ, sự kiện GM, Server_Config không nạp lại từ xa được, phải khởi động lại Road.</div>
    <form method="post"><?= csrf() ?><input type="hidden" name="act" value="publish">
      <div style="margin-top:8px">
        <?php foreach(publish_files() as $k=>[$v,$lv]): $col=[0=>'var(--ok)',1=>'var(--accent)',2=>'var(--err)'][$lv]; ?>
          <label style="display:block;font-size:13px;margin:3px 0"><input type="checkbox" name="files[]" value="<?= h($k) ?>" <?= $k==='ActiveList'?'checked':'' ?>> <b style="color:<?= $col ?>"><?= h($k) ?></b> <span class="muted"><?= h($v) ?></span></label>
        <?php endforeach; ?>
      </div>
      <div class="muted mt">Nạp lại phần server:</div>
      <div class="row" style="flex-wrap:wrap;gap:4px 14px">
        <?php foreach($RELOAD as $k=>$v): ?><label style="flex:0 0 auto;font-size:13px"><input type="checkbox" name="reload[]" value="<?= $k ?>" > <?= h($v) ?></label><?php endforeach; ?>
      </div><button class="btn sm blue mt">Xuất bản</button></form>
    <h3 style="margin-top:18px">Bảo trì</h3>
    <form method="post"><?= csrf() ?><input type="hidden" name="act" value="maintenance">
      <div class="muted">Báo bảo trì mỗi phút trong 6 phút, hết giờ đá mọi người ra (dữ liệu được lưu).</div>
      <label style="font-size:13px;display:block;margin-top:8px"><input type="checkbox" name="sure" value="1"> Tôi chắc chắn muốn bảo trì</label>
      <button class="btn sm danger mt">Bắt đầu bảo trì</button></form>
  </div>
</div>

<div class="grid2">
  <div class="box">
    <h3>GM trong game</h3>
    <div class="muted">Nhân vật trong danh sách gõ được lệnh trong khung chat: <code>$kick$tên$lý do</code>, <code>$ban$tên$lý do$số ngày</code>, <code>$unban$tên$lý do</code>, <code>$mute$tên$số phút$lý do</code> (lý do ít nhất 8 ký tự). Phải giữ ít nhất 1 dòng. Đổi xong cần khởi động lại Road.</div>
    <table class="mt"><tr><th>UserID</th><th>Tài khoản</th><th>Nhân vật</th><th></th></tr>
      <?php foreach($gms as $g): ?><tr><td><?= (int)$g['UserID'] ?></td><td><?= h($g['UserName'] ?? '(không còn)') ?></td><td><?= h($g['NickName']) ?></td>
        <td><form method="post" style="margin:0"><?= csrf() ?><input type="hidden" name="act" value="gm_del"><input type="hidden" name="uid" value="<?= (int)$g['UserID'] ?>"><button class="btn sm danger">Gỡ</button></form></td></tr><?php endforeach; ?>
    </table>
    <form method="post" class="row"><?= csrf() ?><input type="hidden" name="act" value="gm_add"><input name="user" placeholder="Tài khoản cần cấp GM"><button class="btn sm" style="flex:0;white-space:nowrap">Cấp GM</button></form>
  </div>
  <div class="box">
    <h3>Server_Config (<?= count($cfg) ?> khóa)</h3>
    <div class="muted">Cấu hình chung của server (giá, giới hạn, sự kiện...). Lưu xong cần khởi động lại Road. Sửa cẩn thận, sai giá trị có thể làm server lỗi.</div>
    <form class="row" method="get"><input type="hidden" name="page" value="system"><input name="cfg" value="<?= h($ck) ?>" placeholder="Tìm khóa, vd: Exp, Gold, Max"><button class="btn sm" style="flex:0">Tìm</button></form>
  </div>
</div>
<table><tr><th style="width:30%">Khóa</th><th>Giá trị</th></tr>
  <?php foreach($cfg as $c): ?><tr><td><?= h($c['Name']) ?></td>
    <td><form method="post" class="row" style="margin:0"><?= csrf() ?><input type="hidden" name="act" value="cfg_set"><input type="hidden" name="name" value="<?= h($c['Name']) ?>">
      <input name="value" value="<?= h($c['Value']) ?>"><button class="btn sm" style="flex:0">Lưu</button></form></td></tr><?php endforeach; ?>
</table>
