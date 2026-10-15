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
function max_level($conn){ return (int)scalar($conn,"SELECT TOP 1 Grade FROM Db_Tank.dbo.LevelInfo ORDER BY Grade DESC"); }

/* Goi endpoint quan tri cua Request (chi nhan tu 127.0.0.1: AdminIP/ChargeIP). Tra ve chuoi ket qua da trim.
   Ma ket qua:
     SendMailAndItem.aspx  1=ok 5=sai IP 999=loi
     ChargeMoney.aspx      0=ok 2=khong thay user 3=xu<=0 5=sai IP 7=sai chu ky
     SystemNotice.aspx     0=ok 2=sai IP
     ExperienceRate.aspx / NoticeServerUpdate.aspx  0=ok (gia tri Center tra ve) 4/5=loi
     KitoffUser.aspx       1=bat dau dem nguoc 6 phut roi kick moi nguoi */
function req($path,$params=[]){
  $url = 'http://127.0.0.1/'.$path.($params ? '?'.http_build_query($params,'','&',PHP_QUERY_RFC3986) : '');
  $ctx = stream_context_create(['http'=>['timeout'=>40,'ignore_errors'=>true]]);
  $r = @file_get_contents($url,false,$ctx);
  return $r===false ? 'khong goi duoc' : trim($r);
}
