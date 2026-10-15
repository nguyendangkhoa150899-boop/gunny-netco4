<?php
/* GunnyNetco4 Admin: tra anh icon vat pham tu C:\Gunny92\Resource.Server (chi admin da dang nhap).
   Phuc vu qua admin vi res.netco4.click khong co HTTPS, trang admin HTTPS nhung anh HTTP se bi trinh duyet chan. */
define('GN_ADMIN', 1);
session_start();
require __DIR__.'/lib.php';
if (empty($_SESSION['admin'])) { http_response_code(403); exit; }
session_write_close();   // khong giu khoa session khi tai nhieu anh cung luc

$f = item_icon_file($_GET['c'] ?? 0, $_GET['p'] ?? '', $_GET['s'] ?? 1);
header('Cache-Control: private, max-age=86400');
if ($f === null) {
  // o trong: khung nhat co dau ?
  header('Content-Type: image/svg+xml');
  echo '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64"><rect width="64" height="64" rx="8" fill="#1b2539"/><text x="32" y="42" font-size="30" text-anchor="middle" fill="#56688a" font-family="Arial">?</text></svg>';
  exit;
}
header('Content-Type: '.(substr($f,-4)==='.jpg' ? 'image/jpeg' : 'image/png'));
header('Content-Length: '.filesize($f));
readfile($f);
