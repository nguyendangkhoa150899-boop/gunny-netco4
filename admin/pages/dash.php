<?php if (!defined('GN_ADMIN')) exit;
$acc      = scalar($conn,"SELECT COUNT(*) FROM Db_Member.dbo.Mem_Account");
$accToday = scalar($conn,"SELECT COUNT(*) FROM Db_Member.dbo.Mem_Account WHERE TimeCreate>=?",[strtotime('today')]);
$chars    = scalar($conn,"SELECT COUNT(*) FROM Db_Tank41.dbo.Sys_Users_Detail");
$online   = scalar($conn,"SELECT COUNT(*) FROM Db_Tank41.dbo.Sys_Users_Detail WHERE State=1");
$banned   = scalar($conn,"SELECT COUNT(*) FROM Db_Member.dbo.Mem_Account WHERE IsBan=1");
$srv      = q($conn,"SELECT TOP 1 Name,IP,Port FROM Db_Tank41.dbo.Server_List");
$rates    = q($conn,"SELECT Type,Rate FROM Db_Tank41.dbo.Rate WHERE ServerID=? AND GETDATE() BETWEEN BeginDay AND EndDay",[SERVER_ID]);
$RN = [0=>'EXP',1=>'Vàng',2=>'Công hiến'];
?>
<div class="cards">
  <div class="c"><div class="n"><?= (int)$online ?></div><div class="l">Đang online</div></div>
  <div class="c"><div class="n"><?= (int)$acc ?></div><div class="l">Tổng tài khoản</div></div>
  <div class="c"><div class="n"><?= (int)$chars ?></div><div class="l">Tổng nhân vật</div></div>
  <div class="c"><div class="n"><?= (int)$accToday ?></div><div class="l">Đăng ký hôm nay</div></div>
  <div class="c"><div class="n"><?= (int)$banned ?></div><div class="l">Tài khoản bị khóa</div></div>
</div>
<h2>Trạng thái</h2>
<table>
  <tr><th>Mục</th><th>Giá trị</th></tr>
  <tr><td>Server</td><td><?= $srv ? h($srv[0]['Name']).' &middot; '.h($srv[0]['IP']).':'.(int)$srv[0]['Port'] : '?' ?></td></tr>
  <tr><td>Cấp tối đa</td><td><?= max_level($conn) ?></td></tr>
  <tr><td>Tỉ lệ đang chạy</td><td><?php if(!$rates) echo 'mặc định x1'; foreach($rates as $r) echo h($RN[$r['Type']]??$r['Type']).' x'.(float)$r['Rate'].' &nbsp; '; ?></td></tr>
  <tr><td>Nhân vật mới</td><td>cấp tối đa, vàng/xu theo DefaultGold/DefaultMoney trong Request/Web.config</td></tr>
</table>
