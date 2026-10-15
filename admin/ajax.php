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
    else { $where[] = "(Name LIKE ? OR Description LIKE ?)"; $par[] = '%'.$q.'%'; $par[] = '%'.$q.'%'; }
  }
  if ($cat > 0) { $where[] = "CategoryID=?"; $par[] = $cat; }
  // img: 'co' (mac dinh, an mon khong anh) | 'all' | 'khong' (chi mon client khong co anh, de test)
  $img = $_GET['img'] ?? (!empty($_GET['all']) ? 'all' : 'co');
  if (!$where && $img === 'khong') $where[] = '1=1';
  if (!$where) { echo json_encode(['items'=>[]]); exit; }
  $rows = q($conn, "SELECT TOP ".($img==='khong' ? 4000 : 400)." TemplateID,Name,CategoryID,Quality,NeedLevel,NeedSex,Pic,Attack,Defence,Agility,Luck,Description FROM Db_Tank.dbo.Shop_Goods WHERE ".implode(' AND ',$where)." ORDER BY CASE WHEN TemplateID=? THEN 0 WHEN Name LIKE ? THEN 1 ELSE 2 END, TemplateID", array_merge($par, [ctype_digit($q)?(int)$q:-1, '%'.$q.'%']));
  // mon ma client khong co file anh (vd do thu cung hat28/cloth28+ cua ban game moi hon) vao game cung vo hinh: mac dinh an
  $hidden = 0; $kept = [];
  foreach ($rows as $r) {
    $r['img'] = item_icon_file($r['CategoryID'],$r['Pic'],$r['NeedSex']) !== null;
    if ($img === 'co' && !$r['img']) { $hidden++; continue; }
    if ($img === 'khong' && $r['img']) continue;
    if (count($kept) < 90) $kept[] = $r;
  }
  $rows = $kept;
  // ruong: do ben trong (Shop_Goods_Box); vu khi/ao/non: dat vang duoc khong (GoldEquipTemplateLoad, xem WishBeadEquipHandler)
  $ids = array_map(fn($r)=>(int)$r['TemplateID'], $rows); $box = []; $gold = [];
  if ($ids) {
    $in = implode(',', $ids);
    foreach (q($conn, "SELECT b.ID,b.TemplateId,b.IsSelect,b.ItemCount,b.ItemValid,b.StrengthenLevel,b.Random,ISNULL(g.Name,'') Name,
        SUM(CASE WHEN b.IsSelect=0 THEN b.Random ELSE 0 END) OVER (PARTITION BY b.ID) W
        FROM Db_Tank.dbo.Shop_Goods_Box b LEFT JOIN Db_Tank.dbo.Shop_Goods g ON g.TemplateID=b.TemplateId WHERE b.ID IN ($in) ORDER BY b.ID,b.IsSelect DESC,b.AI_ID") as $b) {
      $k = (int)$b['ID']; if (count($box[$k] ?? []) >= 12) { $box[$k][11]['more'] = true; continue; }
      $box[$k][] = ['id'=>(int)$b['TemplateId'], 'name'=>$b['Name'], 'cnt'=>(int)$b['ItemCount'], 'days'=>(int)$b['ItemValid'], 'str'=>(int)$b['StrengthenLevel'],
        'rate'=>(int)$b['IsSelect'] ? 100 : ((int)$b['W'] > 0 ? round(100*(int)$b['Random']/(int)$b['W'],1) : 0)];
    }
    foreach (q($conn, "SELECT DISTINCT OldTemplateId FROM Db_Tank.dbo.GoldEquipTemplateLoad WHERE OldTemplateId IN ($in)") as $g) $gold[(int)$g['OldTemplateId']] = 1;
  }
  $out = [];
  foreach ($rows as $r) {
    $out[] = ['id'=>(int)$r['TemplateID'], 'name'=>$r['Name'], 'cat'=>(int)$r['CategoryID'], 'q'=>(int)$r['Quality'], 'lv'=>(int)$r['NeedLevel'],
              'sex'=>(int)$r['NeedSex'], 'atk'=>(int)$r['Attack'], 'def'=>(int)$r['Defence'], 'agi'=>(int)$r['Agility'], 'luck'=>(int)$r['Luck'],
              'desc'=>mb_substr((string)$r['Description'],0,140), 'color'=>quality_color($r['Quality']), 'icon'=>item_icon_url($r['CategoryID'],$r['Pic'],$r['NeedSex']),
              'box'=>$box[(int)$r['TemplateID']] ?? null, 'gold'=>isset($gold[(int)$r['TemplateID']]), 'img'=>$r['img']];
  }
  echo json_encode(['items'=>$out, 'hidden'=>$hidden], JSON_UNESCAPED_UNICODE);
  sqlsrv_close($conn); exit;
}
echo json_encode(['error'=>'unknown']);
