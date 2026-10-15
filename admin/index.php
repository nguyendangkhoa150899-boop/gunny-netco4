<?php
/* GunnyNetco4 Admin Panel, scaffold v1. Mật khẩu admin đặt ở ADMIN_PANEL_PASS trong .env. */
session_start();

// Đọc toàn bộ bí mật từ .env của website_backend (không hardcode trong file này).
$__env = @file_get_contents('C:\\Gunny92\\website_backend\\.env');
function envv($env,$k,$def=''){ if($env && preg_match('/^'.preg_quote($k,'/').'=(.*)$/m',$env,$m)) return trim($m[1]); return $def; }
define('ADMIN_USER', 'admin');
define('ADMIN_PASS', envv($__env,'ADMIN_PANEL_PASS',''));   // đặt ADMIN_PANEL_PASS trong .env

$DB_HOST = envv($__env,'DB_HOST','localhost');
$DB_UID  = envv($__env,'DB_USERNAME','sa');
$DB_PWD  = envv($__env,'DB_PASSWORD','');
$CHARGE_KEY = envv($__env,'CHARGE_KEY','');   // phải trùng ChargeKey của Request (appsettings.secret.config)
date_default_timezone_set('Asia/Ho_Chi_Minh');

function h($s){ return htmlspecialchars((string)$s, ENT_QUOTES, 'UTF-8'); }

// ---- auth ----
if (isset($_GET['logout'])) { session_destroy(); header('Location: ?'); exit; }
if (isset($_POST['login_user'])) {
  if ($_POST['login_user'] === ADMIN_USER && $_POST['login_pass'] === ADMIN_PASS) {
    $_SESSION['admin'] = true;
    $_SESSION['csrf']  = bin2hex(random_bytes(16));
    header('Location: ?'); exit;
  } else { $login_err = 'Sai tài khoản hoặc mật khẩu.'; }
}
$authed = !empty($_SESSION['admin']);

// ---- db ----
function db($host,$uid,$pwd){
  $c = sqlsrv_connect($host, ['UID'=>$uid,'PWD'=>$pwd,'Database'=>'master','CharacterSet'=>'UTF-8','TrustServerCertificate'=>true,'ReturnDatesAsStrings'=>true]);
  return $c;
}
function q($conn,$sql,$params=[]){
  $st = sqlsrv_query($conn,$sql,$params);
  if ($st===false) return [];
  $rows=[]; while($r=sqlsrv_fetch_array($st,SQLSRV_FETCH_ASSOC)){ $rows[]=$r; }
  return $rows;
}
function scalar($conn,$sql,$params=[]){ $r=q($conn,$sql,$params); return $r ? array_values($r[0])[0] : 0; }
function ts($t){ return is_numeric($t) && $t>0 ? date('Y-m-d H:i',(int)$t) : (string)$t; }   // TimeCreate luu dang Unix time

// ---- actions (POST, require csrf) ----
$flash = '';
if ($authed && isset($_POST['act'])) {
  if (($_POST['csrf']??'') !== ($_SESSION['csrf']??'x')) { $flash='CSRF không hợp lệ.'; }
  else {
    $conn = db($DB_HOST,$DB_UID,$DB_PWD);
    if ($conn){
      $act  = $_POST['act'];
      $user = strtolower(trim($_POST['user'] ?? ''));
      $amt  = (int)($_POST['amount'] ?? 0);
      $hasChar = function($u) use ($conn){ return $u!=='' && scalar($conn,"SELECT COUNT(*) FROM Db_Tank41.dbo.Sys_Users_Detail WHERE UserName=?",[$u]) > 0; };
      $MAXLV = "CROSS JOIN (SELECT TOP 1 Grade,GP FROM Db_Tank.dbo.LevelInfo ORDER BY Grade DESC) l";
      if ($act==='ban' || $act==='unban') {
        $val = $act==='ban' ? 1 : 0;
        sqlsrv_query($conn,"UPDATE Db_Member.dbo.Mem_Account SET IsBan=? WHERE Email=?",[$val,$_POST['email']]);
        $flash = ($val? 'Đã khóa ':'Đã mở khóa ').h($_POST['email']);
      }
      elseif ($act==='addxu') {
        // Qua ChargeMoney.aspx của Request (chỉ nhận từ 127.0.0.1): ghi Charge_Money + báo Center, người đang online nhận ngay.
        if (!$hasChar($user)) $flash = 'Không thấy nhân vật của tài khoản '.h($user).' (phải vào game tạo nhân vật trước).';
        elseif ($amt<=0 || $amt>100000000) $flash = 'Số xu không hợp lệ (1 đến 100.000.000).';
        elseif ($CHARGE_KEY==='') $flash = 'Thiếu CHARGE_KEY trong .env.';
        else {
          $cid = 'adm'.date('YmdHis').mt_rand(100,999);
          $sig = md5($cid.$user.$amt.'admin'.'0'.$CHARGE_KEY);
          // Ban that (gameSrc/Tank.Request/ChargeMoney.cs) doc tham so "nickname" la UserID (so) cua nhan vat.
          $uid = (int)scalar($conn,"SELECT UserID FROM Db_Tank41.dbo.Sys_Users_Detail WHERE UserName=?",[$user]);
          $res = trim((string)@file_get_contents('http://127.0.0.1/ChargeMoney.aspx?content='.rawurlencode("$cid|$user|$amt|admin|0|$sig").'&nickname='.$uid));
          $flash = $res==='0' ? 'Đã cộng '.number_format($amt).' xu cho '.h($user).'.' : 'Cộng xu lỗi (mã '.h($res).').';
        }
      }
      elseif ($act==='addgold') {
        if (!$hasChar($user)) $flash = 'Không thấy nhân vật của tài khoản '.h($user).'.';
        else {
          sqlsrv_query($conn,"UPDATE Db_Tank41.dbo.Sys_Users_Detail SET Gold=CASE WHEN CAST(Gold AS bigint)+?>2000000000 THEN 2000000000 ELSE Gold+? END WHERE UserName=?",[$amt,$amt,$user]);
          $flash = 'Đã cộng '.number_format($amt).' vàng cho '.h($user).' (nhân vật phải đang offline; nếu đang online, lúc thoát server sẽ ghi đè lại).';
        }
      }
      elseif ($act==='maxlv') {
        if (!$hasChar($user)) $flash = 'Không thấy nhân vật của tài khoản '.h($user).'.';
        else {
          sqlsrv_query($conn,"UPDATE d SET GP=l.GP, Grade=l.Grade FROM Db_Tank41.dbo.Sys_Users_Detail d $MAXLV WHERE d.UserName=?",[$user]);
          $flash = 'Đã đưa '.h($user).' lên cấp tối đa (nhân vật phải đang offline; nếu đang online, lúc thoát server sẽ ghi đè lại).';
        }
      }
      elseif ($act==='buffall') {
        $g=(int)($_POST['gold']??0); $x=(int)($_POST['xu']??0);
        sqlsrv_query($conn,"UPDATE d SET GP=l.GP, Grade=l.Grade, Gold=CASE WHEN Gold<? THEN ? ELSE Gold END, Money=CASE WHEN Money<? THEN ? ELSE Money END, MoneyLock=CASE WHEN MoneyLock<? THEN ? ELSE MoneyLock END FROM Db_Tank41.dbo.Sys_Users_Detail d $MAXLV",[$g,$g,$x,$x,$x,$x]);
        $flash = 'Đã buff toàn server: cấp tối đa, vàng ít nhất '.number_format($g).', xu và xu khóa ít nhất '.number_format($x).'. Người đang online không được áp dụng (lúc thoát server ghi đè lại), cho họ thoát rồi bấm lại.';
      }
      sqlsrv_close($conn);
    }
  }
}

$page = $_GET['page'] ?? 'dash';
?><!doctype html>
<html lang="vi"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>GunnyNetco4 Admin</title>
<style>
  :root{--bg:#0b1120;--card:#161f33;--line:#273450;--accent:#ffb020;--accent2:#ff6a00;--text:#eaf1fb;--muted:#8ea2bf;--ok:#36d07f;--err:#ff5d6c}
  *{box-sizing:border-box} body{margin:0;font-family:"Segoe UI",system-ui,Arial,sans-serif;background:radial-gradient(1000px 500px at 50% -12%,#22345a,var(--bg)) fixed;color:var(--text);min-height:100vh}
  a{color:var(--accent);text-decoration:none}
  .login{max-width:360px;margin:9vh auto;padding:28px;background:var(--card);border:1px solid var(--line);border-radius:16px;box-shadow:0 16px 50px rgba(0,0,0,.45)}
  .login h1{font-size:22px;margin:0 0 4px;background:linear-gradient(90deg,var(--accent),var(--accent2));-webkit-background-clip:text;background-clip:text;color:transparent}
  .login .sub{color:var(--muted);font-size:13px;margin-bottom:18px}
  input{width:100%;padding:11px 12px;border-radius:10px;border:1px solid var(--line);background:#0d1626;color:var(--text);font-size:15px;outline:none;margin-top:10px}
  input:focus{border-color:var(--accent)}
  .btn{display:inline-block;cursor:pointer;border:0;color:#1a1200;font-weight:800;font-size:15px;padding:11px 16px;border-radius:10px;background:linear-gradient(90deg,var(--accent),var(--accent2));margin-top:14px}
  .btn.sm{padding:6px 12px;font-size:13px;margin:0}
  .btn.danger{background:#2a1620;color:#ff8a98;border:1px solid var(--err)}
  .wrap{max-width:1100px;margin:0 auto;padding:22px 18px 60px}
  nav{display:flex;align-items:center;gap:6px;flex-wrap:wrap;border-bottom:1px solid var(--line);padding-bottom:12px;margin-bottom:22px}
  nav .logo{font-weight:900;font-size:20px;margin-right:12px;background:linear-gradient(90deg,var(--accent),var(--accent2));-webkit-background-clip:text;background-clip:text;color:transparent}
  nav a{padding:8px 13px;border-radius:9px;color:var(--muted);font-weight:600}
  nav a.on{background:#1d2740;color:var(--text)} nav a:hover{color:var(--text)}
  nav .sp{flex:1}
  .cards{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:24px}
  .c{background:var(--card);border:1px solid var(--line);border-radius:14px;padding:18px}
  .c .n{font-size:28px;font-weight:800;color:var(--accent)} .c .l{color:var(--muted);font-size:13px;margin-top:3px}
  table{width:100%;border-collapse:collapse;background:var(--card);border:1px solid var(--line);border-radius:12px;overflow:hidden}
  th,td{text-align:left;padding:10px 12px;font-size:14px;border-bottom:1px solid var(--line)}
  th{color:var(--muted);font-weight:600;background:#0f1828} tr:last-child td{border-bottom:0}
  .tag{font-size:12px;padding:2px 8px;border-radius:999px} .tag.ok{background:rgba(54,208,127,.15);color:var(--ok)} .tag.ban{background:rgba(255,93,108,.15);color:var(--err)}
  .flash{background:rgba(54,208,127,.12);border:1px solid var(--ok);color:var(--ok);padding:10px 13px;border-radius:10px;margin-bottom:16px;font-size:14px}
  h2{font-size:18px;margin:0 0 12px} .soon{opacity:.6}
  .note{background:#0e1829;border-left:3px solid var(--accent);padding:11px 14px;border-radius:8px;color:var(--muted);font-size:13px}
  .feat form.f input{margin-top:8px}
  .feat{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
  .feat .f{background:var(--card);border:1px dashed var(--line);border-radius:12px;padding:16px} .feat .f b{display:block;margin-bottom:3px} .feat .f span{color:var(--muted);font-size:13px}
  @media(max-width:820px){.cards{grid-template-columns:repeat(2,1fr)}.feat{grid-template-columns:1fr}}
</style></head><body>
<?php if (!$authed): ?>
  <form class="login" method="post">
    <h1>GunnyNetco4 Admin</h1>
    <div class="sub">Khu quản trị, đăng nhập để tiếp tục</div>
    <?php if(!empty($login_err)) echo '<div style="color:var(--err);font-size:13px">'.h($login_err).'</div>'; ?>
    <input name="login_user" placeholder="Tài khoản admin" autocomplete="off">
    <input name="login_pass" type="password" placeholder="Mật khẩu">
    <button class="btn" style="width:100%">ĐĂNG NHẬP</button>
  </form>
<?php else:
  $conn = db($DB_HOST,$DB_UID,$DB_PWD);
  $csrf = $_SESSION['csrf'];
?>
  <div class="wrap">
    <nav>
      <span class="logo">GunnyNetco4</span>
      <a href="?page=dash" class="<?= $page==='dash'?'on':'' ?>">Dashboard</a>
      <a href="?page=accounts" class="<?= $page==='accounts'?'on':'' ?>">Tài khoản</a>
      <a href="?page=chars" class="<?= $page==='chars'?'on':'' ?>">Nhân vật</a>
      <a href="?page=tools" class="<?= $page==='tools'?'on':'' ?>">Công cụ</a>
      <span class="sp"></span>
      <a href="?logout=1">Đăng xuất →</a>
    </nav>
    <?php if($flash) echo '<div class="flash">'.$flash.'</div>'; ?>
    <?php if(!$conn): ?>
      <div class="flash" style="border-color:var(--err);color:var(--err);background:rgba(255,93,108,.12)">Không kết nối được SQL.</div>
    <?php elseif($page==='dash'):
      $acc = scalar($conn,"SELECT COUNT(*) FROM Db_Member.dbo.Mem_Account");
      $accToday = scalar($conn,"SELECT COUNT(*) FROM Db_Member.dbo.Mem_Account WHERE TimeCreate>=?",[strtotime('today')]);
      $chars = scalar($conn,"SELECT COUNT(*) FROM Db_Tank41.dbo.Sys_Users_Detail");
      $banned = scalar($conn,"SELECT COUNT(*) FROM Db_Member.dbo.Mem_Account WHERE IsBan=1");
      $online = scalar($conn,"SELECT ISNULL(SUM(Online),0) FROM Db_Tank41.dbo.Server_List");
    ?>
      <div class="cards">
        <div class="c"><div class="n"><?= (int)$acc ?></div><div class="l">Tổng tài khoản</div></div>
        <div class="c"><div class="n"><?= (int)$chars ?></div><div class="l">Tổng nhân vật</div></div>
        <div class="c"><div class="n"><?= (int)$accToday ?></div><div class="l">Đăng ký hôm nay</div></div>
        <div class="c"><div class="n"><?= (int)$banned ?></div><div class="l">Tài khoản bị khóa</div></div>
      </div>
      <h2>Trạng thái</h2>
      <table><tr><th>Mục</th><th>Giá trị</th></tr>
        <tr><td>Online (server báo)</td><td><?= (int)$online ?></td></tr>
        <tr><td>Server</td><td>GunnyNetco4 &middot; 171.244.39.225:9200</td></tr>
      </table>
    <?php elseif($page==='accounts'):
      $rows = q($conn,"SELECT TOP 80 UserID,Email,Money,Point,VIPLevel,IsBan,TimeCreate,ActiveIP FROM Db_Member.dbo.Mem_Account ORDER BY UserID DESC");
    ?>
      <h2>Tài khoản (80 mới nhất)</h2>
      <table>
        <tr><th>ID</th><th>Tài khoản</th><th>Money</th><th>Point</th><th>VIP</th><th>Trạng thái</th><th>Tạo lúc</th><th></th></tr>
        <?php foreach($rows as $r): ?>
          <tr>
            <td><?= (int)$r['UserID'] ?></td>
            <td><?= h($r['Email']) ?></td>
            <td><?= (int)$r['Money'] ?></td>
            <td><?= (int)$r['Point'] ?></td>
            <td><?= (int)$r['VIPLevel'] ?></td>
            <td><?= $r['IsBan'] ? '<span class="tag ban">Khóa</span>' : '<span class="tag ok">OK</span>' ?></td>
            <td><?= h(ts($r['TimeCreate'])) ?></td>
            <td>
              <form method="post" style="margin:0">
                <input type="hidden" name="csrf" value="<?= h($csrf) ?>">
                <input type="hidden" name="email" value="<?= h($r['Email']) ?>">
                <input type="hidden" name="act" value="<?= $r['IsBan']?'unban':'ban' ?>">
                <button class="btn sm <?= $r['IsBan']?'':'danger' ?>"><?= $r['IsBan']?'Mở khóa':'Khóa' ?></button>
              </form>
            </td>
          </tr>
        <?php endforeach; ?>
      </table>
    <?php elseif($page==='chars'):
      $rows = q($conn,"SELECT TOP 80 UserName,NickName,Grade,Gold,Money,MoneyLock,Win,Total,LastDate FROM Db_Tank41.dbo.Sys_Users_Detail ORDER BY LastDate DESC");
    ?>
      <h2>Nhân vật (80 hoạt động gần nhất)</h2>
      <table>
        <tr><th>Tài khoản</th><th>Nhân vật</th><th>Cấp</th><th>Vàng</th><th>Xu</th><th>Xu khóa</th><th>Thắng/Tổng</th><th>Lần cuối</th></tr>
        <?php foreach($rows as $r): ?>
          <tr>
            <td><?= h($r['UserName']) ?></td>
            <td><?= h($r['NickName']) ?></td>
            <td><?= (int)$r['Grade'] ?></td>
            <td><?= number_format((int)$r['Gold']) ?></td>
            <td><?= number_format((int)$r['Money']) ?></td>
            <td><?= number_format((int)$r['MoneyLock']) ?></td>
            <td><?= (int)$r['Win'] ?>/<?= (int)$r['Total'] ?></td>
            <td><?= h(substr((string)$r['LastDate'],0,16)) ?></td>
          </tr>
        <?php endforeach; ?>
      </table>
    <?php elseif($page==='tools'): ?>
      <h2>Công cụ quản trị</h2>
      <?php $maxLv = q($conn,"SELECT TOP 1 Grade FROM Db_Tank.dbo.LevelInfo ORDER BY Grade DESC"); $maxLv = $maxLv ? (int)$maxLv[0]['Grade'] : 0; ?>
      <div class="note" style="margin-bottom:14px">Tài khoản = tên đăng nhập (chữ thường). <b>Cộng xu</b> áp dụng ngay kể cả khi đang online. <b>Cộng vàng, lên cấp, buff</b> ghi thẳng DB: người chơi phải <b>thoát game trước</b>, nếu không lúc thoát server sẽ ghi đè lại. Cấp tối đa hiện tại: <b><?= $maxLv ?></b>.</div>
      <div class="feat" style="margin-bottom:22px">
        <form class="f" method="post"><b>Cộng xu</b><span>Qua kênh nạp nội bộ, online nhận ngay</span>
          <input type="hidden" name="csrf" value="<?= h($csrf) ?>"><input type="hidden" name="act" value="addxu">
          <input name="user" placeholder="Tài khoản"><input name="amount" type="number" min="1" value="1000000">
          <button class="btn sm" style="margin-top:10px">Cộng xu</button></form>
        <form class="f" method="post"><b>Cộng vàng</b><span>Nhân vật phải offline</span>
          <input type="hidden" name="csrf" value="<?= h($csrf) ?>"><input type="hidden" name="act" value="addgold">
          <input name="user" placeholder="Tài khoản"><input name="amount" type="number" min="1" value="10000000">
          <button class="btn sm" style="margin-top:10px">Cộng vàng</button></form>
        <form class="f" method="post"><b>Lên cấp tối đa</b><span>Nhân vật phải offline</span>
          <input type="hidden" name="csrf" value="<?= h($csrf) ?>"><input type="hidden" name="act" value="maxlv">
          <input name="user" placeholder="Tài khoản">
          <button class="btn sm" style="margin-top:10px">Lên cấp <?= $maxLv ?></button></form>
        <form class="f" method="post"><b>Buff toàn server</b><span>Mọi nhân vật: cấp tối đa + vàng/xu tối thiểu</span>
          <input type="hidden" name="csrf" value="<?= h($csrf) ?>"><input type="hidden" name="act" value="buffall">
          <input name="gold" type="number" min="0" value="50000000" title="Vàng tối thiểu"><input name="xu" type="number" min="0" value="10000000" title="Xu và xu khóa tối thiểu">
          <button class="btn sm danger" style="margin-top:10px">Buff tất cả</button></form>
      </div>
      <div class="feat">
        <div class="f soon"><b>Giftcode</b><span>Tạo và phát code quà</span><br><span style="color:var(--accent)">sắp custom</span></div>
        <div class="f soon"><b>Gửi thư / vật phẩm</b><span>Gửi item qua hộp thư</span><br><span style="color:var(--accent)">sắp custom</span></div>
        <div class="f soon"><b>Sự kiện</b><span>Bật/tắt event, đua top</span><br><span style="color:var(--accent)">sắp custom</span></div>
        <div class="f soon"><b>Cấu hình tỉ lệ</b><span>Xu điểm danh / boss / túi</span><br><span style="color:var(--accent)">sắp custom</span></div>
        <div class="f"><b>Khóa / mở tài khoản</b><span>Đã có ở tab Tài khoản</span><br><span style="color:var(--ok)">đang chạy</span></div>
      </div>
    <?php endif; if($conn) sqlsrv_close($conn); ?>
  </div>
<?php endif; ?>
</body></html>
