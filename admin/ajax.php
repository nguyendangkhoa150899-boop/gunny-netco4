<?php
/* GunnyNetco4 Admin: endpoint JSON (goi tu index.php khi ?ajax=..., da dang nhap). */
if (!defined('GN_ADMIN')) exit;
header('Content-Type: application/json; charset=utf-8');
$conn = db($DB_HOST,$DB_UID,$DB_PWD);
if (!$conn) { echo json_encode(['error'=>'sql']); exit; }

if ($_GET['ajax'] === 'items') {
  // tim vat pham theo TemplateID (so) hoac ten; loc theo loai neu co
  $q = trim($_GET['q'] ?? ''); $cat = (int)($_GET['cat'] ?? 0);
  $where = []; $par = [];
  if ($q !== '') {
    if (ctype_digit($q)) { $where[] = "(TemplateID=? OR CAST(TemplateID AS varchar(12)) LIKE ?)"; $par[] = (int)$q; $par[] = $q.'%'; }
    else { $where[] = "Name LIKE ?"; $par[] = '%'.$q.'%'; }
  }
  if ($cat > 0) { $where[] = "CategoryID=?"; $par[] = $cat; }
  if (!$where) { echo json_encode(['items'=>[]]); exit; }
  $rows = q($conn, "SELECT TOP 90 TemplateID,Name,CategoryID,Quality,NeedLevel,NeedSex,Pic,Attack,Defence,Agility,Luck,Description FROM Db_Tank.dbo.Shop_Goods WHERE ".implode(' AND ',$where)." ORDER BY CASE WHEN TemplateID=? THEN 0 ELSE 1 END, TemplateID", array_merge($par, [ctype_digit($q)?(int)$q:-1]));
  $out = [];
  foreach ($rows as $r) {
    $out[] = ['id'=>(int)$r['TemplateID'], 'name'=>$r['Name'], 'cat'=>(int)$r['CategoryID'], 'q'=>(int)$r['Quality'], 'lv'=>(int)$r['NeedLevel'],
              'sex'=>(int)$r['NeedSex'], 'atk'=>(int)$r['Attack'], 'def'=>(int)$r['Defence'], 'agi'=>(int)$r['Agility'], 'luck'=>(int)$r['Luck'],
              'desc'=>mb_substr((string)$r['Description'],0,140), 'color'=>quality_color($r['Quality']), 'icon'=>item_icon_url($r['CategoryID'],$r['Pic'],$r['NeedSex'])];
  }
  echo json_encode(['items'=>$out], JSON_UNESCAPED_UNICODE);
  sqlsrv_close($conn); exit;
}
echo json_encode(['error'=>'unknown']);
