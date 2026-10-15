<?php
/* GunnyNetco4 Admin Panel (admingunny.netco4.click).
   Cau truc: lib.php (ham chung, doc .env), actions.php (xu ly POST), pages/*.php (tung trang).
   Mat khau admin: ADMIN_PANEL_PASS trong C:\Gunny92\website_backend\.env */
define('GN_ADMIN', 1);
session_start();
require __DIR__.'/lib.php';
require __DIR__.'/actions.php';

// ---- dang nhap ----
if (isset($_GET['logout'])) { session_destroy(); header('Location: ./'); exit; }
if (isset($_POST['login_user'])) {
  if (ADMIN_PASS !== '' && hash_equals(ADMIN_USER, (string)$_POST['login_user']) && hash_equals(ADMIN_PASS, (string)$_POST['login_pass'])) {
    session_regenerate_id(true);
    $_SESSION['admin'] = true;
    $_SESSION['csrf']  = bin2hex(random_bytes(16));
    header('Location: ./'); exit;
  }
  $login_err = 'Sai tài khoản hoặc mật khẩu.';
}
$authed = !empty($_SESSION['admin']);

$PAGES = ['dash'=>'Dashboard','accounts'=>'Tài khoản','chars'=>'Nhân vật','mail'=>'Gửi quà','giftcode'=>'Giftcode','diemdanh'=>'Điểm danh','minigame'=>'Mini game','shop'=>'Shop web','system'=>'Hệ thống'];
$page = $_GET['page'] ?? 'dash';
if (!isset($PAGES[$page])) $page = 'dash';

// ---- JSON cho trang (tim vat pham...) ----
if ($authed && isset($_GET['ajax'])) { require __DIR__.'/ajax.php'; exit; }

// ---- thao tac POST: xu ly xong chuyen huong (F5 khong gui lai) ----
if ($authed && isset($_POST['act'])) {
  if (!hash_equals($_SESSION['csrf'] ?? 'x', (string)($_POST['csrf'] ?? ''))) $_SESSION['flash'] = 'CSRF không hợp lệ, tải lại trang rồi thử lại.';
  else {
    $conn = db($DB_HOST,$DB_UID,$DB_PWD);
    $_SESSION['flash'] = $conn ? run_action($conn,$_POST['act'],$_POST) : 'Không kết nối được SQL.';
    if ($conn) sqlsrv_close($conn);
  }
  $back = $_SERVER['REQUEST_URI'] ?? './';
  header('Location: '.$back); exit;
}
$flash = $_SESSION['flash'] ?? ''; unset($_SESSION['flash']);
?><!doctype html>
<html lang="vi"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>GunnyNetco4 Admin</title>
<style>
  :root{--bg:#0b1120;--card:#161f33;--line:#273450;--accent:#ffb020;--accent2:#ff6a00;--text:#eaf1fb;--muted:#8ea2bf;--ok:#36d07f;--err:#ff5d6c;--blue:#2563eb}
  *{box-sizing:border-box} body{margin:0;font-family:"Segoe UI",system-ui,Arial,sans-serif;background:radial-gradient(1000px 500px at 50% -12%,#22345a,var(--bg)) fixed;color:var(--text);min-height:100vh}
  a{color:var(--accent);text-decoration:none}
  .login{max-width:360px;margin:9vh auto;padding:28px;background:var(--card);border:1px solid var(--line);border-radius:16px;box-shadow:0 16px 50px rgba(0,0,0,.45)}
  .login h1{font-size:22px;margin:0 0 4px;background:linear-gradient(90deg,var(--accent),var(--accent2));-webkit-background-clip:text;background-clip:text;color:transparent}
  .login .sub{color:var(--muted);font-size:13px;margin-bottom:18px}
  input,select,textarea{width:100%;padding:9px 11px;border-radius:9px;border:1px solid var(--line);background:#0d1626;color:var(--text);font-size:14px;outline:none;font-family:inherit}
  input:focus,select:focus,textarea:focus{border-color:var(--accent)}
  input[type=checkbox],input[type=radio]{width:auto;margin:0 6px 0 0;vertical-align:middle}
  label{cursor:pointer}
  .btn{display:inline-block;cursor:pointer;border:0;color:#1a1200;font-weight:800;font-size:14px;padding:10px 16px;border-radius:10px;background:linear-gradient(90deg,var(--accent),var(--accent2))}
  .btn.sm{padding:6px 11px;font-size:12px}
  .btn.blue{background:var(--blue);color:#fff}
  .btn.danger{background:#b4232f;color:#fff}
  .wrap{max-width:1180px;margin:0 auto;padding:22px 18px 60px}
  nav{display:flex;align-items:center;gap:6px;flex-wrap:wrap;border-bottom:1px solid var(--line);padding-bottom:12px;margin-bottom:22px}
  nav .logo{font-weight:900;font-size:20px;margin-right:12px;background:linear-gradient(90deg,var(--accent),var(--accent2));-webkit-background-clip:text;background-clip:text;color:transparent}
  nav a{padding:8px 13px;border-radius:9px;color:var(--muted);font-weight:600}
  nav a.on{background:#1d2740;color:var(--text)} nav a:hover{color:var(--text)}
  nav .sp{flex:1}
  .cards{display:grid;grid-template-columns:repeat(5,1fr);gap:14px;margin-bottom:24px}
  .c{background:var(--card);border:1px solid var(--line);border-radius:14px;padding:18px}
  .c .n{font-size:28px;font-weight:800;color:var(--accent)} .c .l{color:var(--muted);font-size:13px;margin-top:3px}
  table{width:100%;border-collapse:collapse;background:var(--card);border:1px solid var(--line);border-radius:12px;overflow:hidden;margin-bottom:22px}
  th,td{text-align:left;padding:9px 11px;font-size:13px;border-bottom:1px solid var(--line);vertical-align:middle}
  th{color:var(--muted);font-weight:600;background:#0f1828} tr:last-child td{border-bottom:0}
  .tag{font-size:12px;padding:2px 8px;border-radius:999px;white-space:nowrap} .tag.ok{background:rgba(54,208,127,.15);color:var(--ok)} .tag.ban{background:rgba(255,93,108,.15);color:var(--err)} .tag.on{background:rgba(54,208,127,.18);color:#4ade80;font-weight:700} .tag.off{background:rgba(148,163,184,.12);color:#94a3b8}
  .stbar{display:flex;align-items:center;gap:12px;flex-wrap:wrap;background:var(--card,#141c2e);border:1px solid var(--line);border-radius:12px;padding:10px 14px;margin:0 0 14px}
  .stbar b{font-size:18px} .stbar .warn{color:#fbbf24;font-size:13px} .stbar form{margin:0}
  .flash{background:rgba(54,208,127,.12);border:1px solid var(--ok);color:var(--ok);padding:10px 13px;border-radius:10px;margin-bottom:16px;font-size:14px}
  h2{font-size:18px;margin:6px 0 12px} h3{font-size:15px;margin:0 0 6px}
  .note{background:#0e1829;border-left:3px solid var(--accent);padding:11px 14px;border-radius:8px;color:var(--muted);font-size:13px;margin-bottom:16px}
  .grid2{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:22px}
  .grid3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:22px}
  .box{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:16px}
  .box .muted,.muted{color:var(--muted);font-size:12px}
  .row{display:flex;gap:8px;align-items:center;margin-top:8px} .row>*{flex:1}
  .mt{margin-top:10px}
  code{background:#0a1120;padding:2px 6px;border-radius:6px;color:#ffd479;font-size:12px}
  @media(max-width:900px){.cards{grid-template-columns:repeat(2,1fr)}.grid2,.grid3{grid-template-columns:1fr}}
</style></head><body>
<?php if (!$authed): ?>
  <form class="login" method="post">
    <h1>GunnyNetco4 Admin</h1>
    <div class="sub">Khu quản trị, đăng nhập để tiếp tục</div>
    <?php if(!empty($login_err)) echo '<div style="color:var(--err);font-size:13px">'.h($login_err).'</div>'; ?>
    <input name="login_user" placeholder="Tài khoản admin" autocomplete="off" style="margin-top:10px">
    <input name="login_pass" type="password" placeholder="Mật khẩu" style="margin-top:10px">
    <button class="btn" style="width:100%;margin-top:14px">ĐĂNG NHẬP</button>
  </form>
<?php else:
  $conn = db($DB_HOST,$DB_UID,$DB_PWD);
?>
  <div class="wrap">
    <nav>
      <span class="logo">GunnyNetco4</span>
      <?php foreach($PAGES as $k=>$v): ?><a href="?page=<?= $k ?>" class="<?= $page===$k?'on':'' ?>"><?= h($v) ?></a><?php endforeach; ?>
      <span class="sp"></span>
      <a href="?logout=1">Đăng xuất →</a>
    </nav>
    <?php if($flash) echo '<div class="flash">'.$flash.'</div>'; ?>
    <?php if(!$conn): ?>
      <div class="flash" style="border-color:var(--err);color:var(--err);background:rgba(255,93,108,.12)">Không kết nối được SQL.</div>
    <?php else: require __DIR__.'/pages/'.$page.'.php'; sqlsrv_close($conn); endif; ?>
  </div>
<?php endif; ?>
</body></html>
