<?php
/* GunnyNetco4 Admin: ham dung chung. Moi bi mat doc tu .env cua website_backend (khong hardcode). */
if (!defined('GN_ADMIN')) exit;

$__env = @file_get_contents('C:\\Gunny92\\website_backend\\.env');
function envv($env,$k,$def=''){ if($env && preg_match('/^'.preg_quote($k,'/').'=(.*)$/m',$env,$m)) return trim($m[1]); return $def; }

define('ADMIN_USER', 'admin');
define('ADMIN_PASS', envv($__env,'ADMIN_PANEL_PASS',''));
define('SERVER_ID', 4);   // Road.Service.exe.config ServerID, Db_Tank41.Server_List.ID
$DB_HOST    = envv($__env,'DB_HOST','localhost');
$DB_UID     = envv($__env,'DB_USERNAME','sa');
$DB_PWD     = envv($__env,'DB_PASSWORD','');
$CHARGE_KEY = envv($__env,'CHARGE_KEY','');   // phai trung ChargeKey cua Request (appsettings.secret.config)
date_default_timezone_set('Asia/Ho_Chi_Minh');

function h($s){ return htmlspecialchars((string)$s, ENT_QUOTES, 'UTF-8'); }
function n($v){ return number_format((int)$v); }
function ts($t){ return is_numeric($t) && $t>0 ? date('Y-m-d H:i',(int)$t) : (string)$t; }   // Mem_Account.TimeCreate la Unix time
function csrf(){ return '<input type="hidden" name="csrf" value="'.h($_SESSION['csrf'] ?? '').'">'; }

function db($host,$uid,$pwd){
  return sqlsrv_connect($host, ['UID'=>$uid,'PWD'=>$pwd,'Database'=>'master','CharacterSet'=>'UTF-8','TrustServerCertificate'=>true,'ReturnDatesAsStrings'=>true]);
}
function q($conn,$sql,$params=[]){
  $st = sqlsrv_query($conn,$sql,$params);
  if ($st===false) return [];
  $rows=[]; while($r=sqlsrv_fetch_array($st,SQLSRV_FETCH_ASSOC)){ $rows[]=$r; }
  return $rows;
}
function scalar($conn,$sql,$params=[]){ $r=q($conn,$sql,$params); return $r ? array_values($r[0])[0] : 0; }
function exec_sql($conn,$sql,$params=[]){ $st=sqlsrv_query($conn,$sql,$params); if($st===false){ $e=sqlsrv_errors(); return $e ? $e[0]['message'] : 'SQL loi'; } return true; }

// UserID nhan vat theo ten tai khoan (Sys_Users_Detail.UserName = ten dang nhap, chu thuong)
function user_id($conn,$user){ return (int)scalar($conn,"SELECT UserID FROM Db_Tank41.dbo.Sys_Users_Detail WHERE UserName=?",[strtolower(trim($user))]); }
/* XML client duoc phep dung lai tu admin: ten .ashx => [mo ta, muc canh bao 0 an toan / 1 can than / 2 nguy hiem].
   So lieu 15/10/2026: XML goc vs dung tu DB hien tai. Ban goc nam trong git (Request/*.xml) va C:\inst2\xml-backup-20261015. */
function publish_files(){ return [
  'ActiveList'         => ['Sự kiện / giftcode', 0],
  'eventrewarditemlist'=> ['Quà sự kiện', 0],
  'LoadItemsCategory'  => ['Danh mục vật phẩm', 0],
  'ShopItemList'       => ['Giá shop', 1],
  'TemplateAllList'    => ['Vật phẩm (tên, chỉ số tooltip): DB có 19.122, client gốc 13.080', 1],
  'ShopGoodsShowList'  => ['Hàng hiển thị shop: DB 1.258, client gốc 1.372', 2],
  'NPCInfoList'        => ['NPC: DB 1.033, client gốc 1.274', 2],
  'QuestList'          => ['Nhiệm vụ: DB chỉ 179, client gốc 1.115, ĐỪNG dựng lại', 2],
]; }
/* Duong dan file icon vat pham trong Resource.Server, theo dung cong thuc client (flashbaseSrc PathManager.solveGoodsPath,
   EquipType). Loai client 3.0 khong biet (DB moi hon) thi thu cac thu muc du phong. Tra ve null neu khong co anh. */
define('RES_DIR', 'C:\\Gunny92\\Resource.Server\\');
function item_icon_rel($cat,$pic,$sex){
  $T=['','head','glass','hair','eff','cloth','face','arm','armlet','ring','','','','suits','necklace','wing','chatBall','','','','','','','','','','','','armlet','ring'];
  $c=(int)$cat; $p=$pic;
  if($c==7||$c==27) return "image/arm/$p/1/icon.png";
  if(in_array($c,[11,24,65,68,69,72],true)) return "image/unfrightprop/$p/icon.png";
  if($c==12) return "image/task/$p/icon.png";
  if($c==16) return "image/specialprop/chatBall/$p/icon.png";
  if($c<10 || in_array($c,[13,14,28,29],true)){
    $t=$T[$c] ?? '';
    if(in_array($c,[8,9,14,28,29],true)) return "image/equip/$t/$p/icon.png";   // vong tay, nhan, day chuyen: khong chia nam nu
    return 'image/equip/'.((int)$sex===2?'f':'m')."/$t/$p/icon_1.png";
  }
  if($c==15) return "image/equip/wing/$p/icon.png";
  if($c==17||$c==31) return "image/equip/offhand/$p/icon.png";
  if($c==25) return "image/gift/$p/icon.png";
  if($c==26) return "image/card/$p/icon.jpg";
  if($c==18) return "image/cardbox/$p/icon.png";
  if($c==19) return "image/equip/recover/$p/icon.png";
  if(in_array($c,[20,23,30,40,34,35],true)) return "image/unfrightprop/$p/icon.png";
  if($c==32||$c==36) return "image/farm/Crops/$p/seed.png";
  if($c==33) return "image/farm/Fertilizer/$p/icon.png";
  if($c==52) return "image/petequip/cloth/$p/icon.png";
  if($c==50) return "image/petequip/arm/$p/icon.png";
  if($c==51) return "image/petequip/hat/$p/icon.png";
  return "image/prop/$p/icon.png";
}
function item_icon_file($cat,$pic,$sex){
  $pic=(string)$pic;
  // co dau cach: anh client "Legend Na Than-8bit" (200270)
  if($pic==='' || strpos($pic,'..')!==false || !preg_match('#^[A-Za-z0-9_\-/ ]+$#',$pic)) return null;
  $try=[item_icon_rel($cat,$pic,$sex),"image/unfrightprop/$pic/icon.png","image/prop/$pic/icon.png","image/error/$pic/icon.png"];
  if((int)$sex!==2) $try[]=str_replace('/m/','/f/',$try[0]); else $try[]=str_replace('/f/','/m/',$try[0]);
  foreach($try as $r){ $f=RES_DIR.str_replace('/','\\',$r); if(is_file($f)) return $f; }
  return null;
}
/* Mon co trong TemplateAlllist.xml cua client (nen zlib) khong. Co anh chua du: do admin cu tu che (352xxxxx...) dung lai anh do that
   nhung client khong biet ID -> nguoi nhan ket man hinh giay khi vao game (15/10: hoang). Cache theo mtime trong thu muc tam. */
define('CLIENT_XML', 'C:\\Gunny92\\Request\\TemplateAlllist.xml');
define('PET_XML', 'C:\\Gunny92\\Request\\pettemplateinfo.xml');
// = PathManager.solveGoodsPath(cat, pic, NeedSex == 1, "icon") cua client (giong website_backend VatPham::duongDanClient, _setup/kiem-anh/kiem-anh.js)
function item_client_path($cat,$pic,$needSex){
  $T=['','head','glass','hair','eff','cloth','face','arm','armlet','ring','','','','suits','necklace','wing','chatBall','','','','','','','','','','','','armlet','ring'];
  $c=(int)$cat; $p=$pic;
  if($c==7||$c==27) return "image/arm/$p/1/icon.png";
  if(in_array($c,[11,24,65,68,69,72],true)) return "image/unfrightprop/$p/icon.png";
  if($c==12) return "image/task/$p/icon.png";
  if($c==16) return "image/specialprop/chatBall/$p/icon.png";
  if($c<10||in_array($c,[13,14,28,29],true)){
    $t=$T[$c]??'';
    if(in_array($c,[8,9,14,28,29],true)) return "image/equip/$t/$p/icon.png";
    return 'image/equip/'.((int)$needSex===1?'m':'f')."/$t/$p/icon_1.png";
  }
  if($c==15) return "image/equip/wing/$p/icon.png";
  if($c==17||$c==31) return "image/equip/offhand/$p/icon.png";
  if($c==25) return "image/gift/$p/icon.png";
  if($c==26) return "image/card/$p/icon.jpg";
  if($c==18) return "image/cardbox/$p/icon.png";
  if($c==19) return "image/equip/recover/$p/icon.png";
  if(in_array($c,[20,23,30,40,34,35],true)) return "image/unfrightprop/$p/icon.png";
  if($c==32||$c==36) return "image/farm/Crops/$p/seed.png";
  if($c==33) return "image/farm/Fertilizer/$p/icon.png";
  if($c==52) return "image/petequip/cloth/$p/icon.png";
  if($c==50) return "image/petequip/arm/$p/icon.png";
  if($c==51) return "image/petequip/hat/$p/icon.png";
  return "image/prop/$p/icon.png";
}
// Mon dua vao game duoc, xet DUNG nhu client (22/10): client biet ID (do tu che 352xxxxx -> ket man hinh giay, 15/10 hoang)
// + co anh o dung duong client xin (khong thu duong du phong) + trung: thu cung ben trong co trong pettemplateinfo.xml.
function item_in_client($tid){
  static $ds = null;
  if ($ds === null) {
    $mt = @filemtime(CLIENT_XML); $ds = [];
    if ($mt) {
      $cf = sys_get_temp_dir().'\\gn_client_ok4_'.$mt.'_'.(int)@filemtime(PET_XML).'.json';
      $c = @file_get_contents($cf); $ds = $c !== false ? json_decode($c, true) : null;
      if (!is_array($ds)) {
        $raw = @file_get_contents(CLIENT_XML); $xml = $raw === false ? false : @gzuncompress($raw); $ds = [];
        $pet = [];
        if (preg_match_all('/<item [^>]*>/i', (string)@file_get_contents(PET_XML), $pm))
          foreach ($pm[0] as $t) if (preg_match('/ TemplateID="(\d+)"/',$t,$a) && preg_match('/ Pic="([^"]*)"/',$t,$b)) $pet[$a[1]] = $b[1];
        $co = function($rel){ return is_file(RES_DIR.str_replace('/','\\',$rel)); };
        if ($xml !== false && preg_match_all('/<Item [^>]*>/', $xml, $m)) {
          foreach ($m[0] as $t) {
            $g = function($k) use ($t){ return preg_match('/ '.$k.'="([^"]*)"/',$t,$x) ? $x[1] : ''; };
            $pic = $g('Pic');
            if ($pic === '' || $pic === 'null' || !preg_match('#^[A-Za-z0-9_\- ]+$#', $pic)) continue;
            $cat = (int)$g('CategoryID');
            // 22/10 an mon loi: ID am = diem/tien ao (-200 Xu, -100 vang...), do "Mac dinh" = o trong, anh trong suot ~190 byte
            $ten = trim(html_entity_decode($g('Name'), ENT_QUOTES, 'UTF-8'));
            if ((int)$g('TemplateID') <= 0 || $ten === '' || mb_stripos($ten, 'mặc định') !== false) continue;
            $anh = RES_DIR.str_replace('/','\\',item_client_path($cat,$pic,(int)$g('NeedSex')));
            if (!is_file($anh) || filesize($anh) < 400) continue;
            if ($cat === 35) { $pp = $pet[$g('Property5')] ?? null; if ($pp === null || !$co("image/pet/$pp/icon1.png")) continue; }
            $ds[$g('TemplateID')] = 1;
          }
          @file_put_contents($cf, json_encode($ds));
        }
      }
    }
  }
  return isset($ds[(string)(int)$tid]) && !isset(item_vo_dung()[(int)$tid]);
}
// [TemplateID => 1] mon game khong dung duoc, dung chung voi web (VatPham::voDung): _setup/do-vo-dung.json (hop rong, chien hon gia,
// vat pham nhiem vu, do test...). Ly do tung nhom ghi trong file.
function item_vo_dung(){
  static $ds = null;
  if ($ds === null) {
    $ds = [];
    $j = json_decode((string)@file_get_contents(__DIR__.'\\..\\_setup\\do-vo-dung.json'), true);
    if (is_array($j)) foreach ($j as $nhom) if (is_array($nhom)) foreach ($nhom['ids'] ?? [] as $id) $ds[(int)$id] = 1;
  }
  return $ds;
}
// [TemplateID => ten] theo client = ten trong game. DB co the khac (7024: DB "VIP-Boomerang", game "SUPER-Boomerang"). Cache json theo mtime.
function item_client_names(){
  static $ds = null;
  if ($ds !== null) return $ds;
  $mt = @filemtime(CLIENT_XML); $ds = [];
  if (!$mt) return $ds;
  $cf = sys_get_temp_dir().'\\gn_client_ten_'.$mt.'.json';
  $c = @file_get_contents($cf); $ds = $c !== false ? json_decode($c, true) : null;
  if (is_array($ds)) return $ds;
  $ds = [];
  $raw = @file_get_contents(CLIENT_XML); $xml = $raw === false ? false : @gzuncompress($raw);
  if ($xml !== false && preg_match_all('/<Item [^>]*>/', $xml, $m)) {
    foreach ($m[0] as $t)
      if (preg_match('/ TemplateID="(-?\d+)"/',$t,$a) && preg_match('/ Name="([^"]*)"/',$t,$b) && ($n = trim(html_entity_decode($b[1], ENT_QUOTES, 'UTF-8'))) !== '') $ds[$a[1]] = $n;
    @file_put_contents($cf, json_encode($ds, JSON_UNESCAPED_UNICODE));
  }
  return $ds;
}
function item_khong_client_msg($tid){ return 'Món ID '.(int)$tid.' vào game sẽ lỗi (client không có món này, không có hình, hoặc trứng chứa thú cưng client không có). Không thêm.'; }
function item_icon_url($cat,$pic,$sex){ return 'icon.php?c='.(int)$cat.'&p='.rawurlencode((string)$pic).'&s='.(int)$sex; }
// Mau vien theo pham chat (Shop_Goods.Quality)
function quality_color($q){ return [0=>'#6b7a90',1=>'#9aa7b8',2=>'#3fbf6f',3=>'#3b8cff',4=>'#a35bff',5=>'#ff9a1f',6=>'#ff4d5e'][(int)$q] ?? '#6b7a90'; }
// Cap cuong hoa toi da (Server_Config.MaxStrengthLevel, hien 12)
function max_strength($conn){ $v=(int)scalar($conn,"SELECT TOP 1 CAST(Value AS nvarchar(20)) FROM Db_Tank41.dbo.Server_Config WHERE Name='MaxStrengthLevel'"); return $v>0?$v:12; }
function max_level($conn){ return (int)scalar($conn,"SELECT TOP 1 Grade FROM Db_Tank.dbo.LevelInfo ORDER BY Grade DESC"); }

/* Goi endpoint quan tri cua Request (chi nhan tu 127.0.0.1: AdminIP/ChargeIP). Tra ve chuoi ket qua da trim.
   Ma ket qua:
     SendMailAndItem.aspx  1=ok 5=sai IP 999=loi
     ChargeMoney.aspx      0=ok 2=khong thay user 3=xu<=0 5=sai IP 7=sai chu ky
     SystemNotice.aspx     0=ok 2=sai IP
     ExperienceRate.aspx / NoticeServerUpdate.aspx  0=ok (gia tri Center tra ve) 4/5=loi
     KitoffUser.aspx       1=bat dau dem nguoc 6 phut roi kick moi nguoi */
/* So nguoi DANG CHOI THAT theo Center (Request ServerList.ashx: total=...). DB Sys_Users_Detail.State co the ket 1 sau khi
   server game sap / tat ngang. null = khong hoi duoc Center. */
function center_online(){
  $ctx = stream_context_create(['http'=>['timeout'=>8,'ignore_errors'=>true]]);
  $r = @file_get_contents('http://127.0.0.1/ServerList.ashx', false, $ctx);
  return ($r !== false && preg_match('/total="(\d+)"/', $r, $m)) ? (int)$m[1] : null;
}
/* thanh trang thai: server game bao X dang choi / DB ghi Y online + nut Lam moi, Reset */
function status_bar($conn){
  $real = center_online();
  $db = (int)scalar($conn,"SELECT COUNT(*) FROM Db_Tank41.dbo.Sys_Users_Detail WHERE State=1");
  $lech = $real !== null && $real !== $db;
  $h = '<div class="stbar"><span>Server game báo đang chơi: <b>'.($real===null?'?':(int)$real).'</b></span>'
     .'<span class="muted">DB ghi online: <b>'.$db.'</b></span>'
     .($lech ? '<span class="warn">Lệch: có nhân vật kẹt trạng thái online (thường do server game tắt ngang). Bấm Reset để sửa.</span>' : '')
     .'<span style="flex:1"></span><a class="btn sm" href="'.h($_SERVER['REQUEST_URI'] ?? '?').'">Làm mới</a>'
     .'<form method="post">'.csrf().'<input type="hidden" name="act" value="state_reset"><button class="btn sm danger" title="Đặt tất cả về Offline. Ai thật sự đang chơi sẽ tự hiện Online lại ở lần server game lưu tự động kế tiếp (vài phút).">Reset trạng thái</button></form></div>';
  return $h;
}
function req($path,$params=[]){
  $url = 'http://127.0.0.1/'.$path.($params ? '?'.http_build_query($params,'','&',PHP_QUERY_RFC3986) : '');
  $ctx = stream_context_create(['http'=>['timeout'=>40,'ignore_errors'=>true]]);
  $r = @file_get_contents($url,false,$ctx);
  if ($r===false) return 'khong goi duoc';
  // vai trang .aspx (vd ExperienceRate) in ma ket qua roi in luon HTML cua trang: chi lay so dau
  if (preg_match('/^\s*(-?\d+)\s*(<|$)/s',$r,$m)) return $m[1];
  return trim($r);
}
