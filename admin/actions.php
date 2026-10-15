<?php
/* GunnyNetco4 Admin: xu ly thao tac POST. Goi tu index.php sau khi da dang nhap + kiem CSRF. */
if (!defined('GN_ADMIN')) exit;

function run_action($conn,$act,$P){
  global $CHARGE_KEY;
  $user = strtolower(trim($P['user'] ?? ''));
  $amt  = (int)($P['amount'] ?? 0);
  $MAXLV = "CROSS JOIN (SELECT TOP 1 Grade,GP FROM Db_Tank.dbo.LevelInfo ORDER BY Grade DESC) l";

  switch ($act) {

  /* ---------- tai khoan / nhan vat ---------- */
  case 'ban': case 'unban':
    $v = $act==='ban' ? 1 : 0;
    exec_sql($conn,"UPDATE Db_Member.dbo.Mem_Account SET IsBan=? WHERE Email=?",[$v,$P['email']]);
    return ($v?'Đã khóa ':'Đã mở khóa ').h($P['email']).'.';

  case 'addxu':   // ChargeMoney.aspx: ghi Charge_Money + bao Center, nguoi dang online nhan ngay
    $uid = user_id($conn,$user);
    if (!$uid) return 'Không thấy nhân vật của tài khoản '.h($user).' (phải vào game tạo nhân vật trước).';
    if ($amt<=0 || $amt>100000000) return 'Số xu không hợp lệ (1 đến 100.000.000).';
    if ($CHARGE_KEY==='') return 'Thiếu CHARGE_KEY trong .env.';
    $cid = 'adm'.date('YmdHis').mt_rand(100,999);
    $sig = md5($cid.$user.$amt.'admin'.'0'.$CHARGE_KEY);
    $r = req('ChargeMoney.aspx',['content'=>"$cid|$user|$amt|admin|0|$sig",'nickname'=>$uid]);   // nickname = UserID so
    return $r==='0' ? 'Đã cộng '.n($amt).' xu cho '.h($user).'.' : 'Cộng xu lỗi (mã '.h($r).').';

  case 'maxlv':
    if (!user_id($conn,$user)) return 'Không thấy nhân vật của tài khoản '.h($user).'.';
    exec_sql($conn,"UPDATE d SET GP=l.GP, Grade=l.Grade FROM Db_Tank41.dbo.Sys_Users_Detail d $MAXLV WHERE d.UserName=?",[$user]);
    return 'Đã đưa '.h($user).' lên cấp tối đa (nhân vật phải offline; đang online thì lúc thoát server sẽ ghi đè lại).';

  case 'buffall':
    $g=(int)($P['gold']??0); $x=(int)($P['xu']??0);
    exec_sql($conn,"UPDATE d SET GP=l.GP, Grade=l.Grade, Gold=CASE WHEN Gold<? THEN ? ELSE Gold END, Money=CASE WHEN Money<? THEN ? ELSE Money END, MoneyLock=CASE WHEN MoneyLock<? THEN ? ELSE MoneyLock END FROM Db_Tank41.dbo.Sys_Users_Detail d $MAXLV WHERE d.State<>1",[$g,$g,$x,$x,$x,$x]);
    return 'Đã buff các nhân vật đang offline: cấp tối đa, vàng ít nhất '.n($g).', xu và xu khóa ít nhất '.n($x).'.';

  /* ---------- gui qua qua thu (SendMailAndItem.aspx, an toan ca khi dang online) ---------- */
  case 'mail':
    $to = $P['to'] ?? 'one';
    if ($to==='all') $uid = -9; elseif ($to==='online') $uid = -10;
    else { $uid = user_id($conn,$user); if(!$uid) return 'Không thấy nhân vật của tài khoản '.h($user).'.'; }
    $items=[];
    for($i=0;$i<5;$i++){
      $tid=(int)($P['tid'][$i]??0); if($tid<=0) continue;
      $cnt=max(1,(int)($P['cnt'][$i]??1)); $day=max(0,(int)($P['day'][$i]??0)); $str=min(max_strength($conn),max(0,(int)($P['str'][$i]??0)));
      $bind=!empty($P['bind'][$i]) ? 'true' : 'false';
      // TemplateID,Count,ValidDate(ngay, 0=vinh vien),StrengthenLevel,AttackCompose,DefendCompose,AgilityCompose,LuckCompose,IsBind
      $items[] = "$tid,$cnt,$day,$str,0,0,0,0,$bind";
    }
    $gold=max(0,(int)($P['gold']??0)); $money=max(0,(int)($P['money']??0));
    if(!$items && !$gold && !$money) return 'Chưa chọn vật phẩm, vàng hay xu nào.';
    $title = trim($P['title'] ?? '') ?: 'Quà từ GunnyNetco4';
    $r = req('SendMailAndItem.aspx',['title'=>$title,'content'=>trim($P['content']??'') ?: $title,'user_id'=>$uid,'gold'=>$gold,'money'=>$money,'str'=>implode('|',$items)]);
    $who = $uid===-9 ? 'tất cả người chơi' : ($uid===-10 ? 'người đang online' : h($user));
    return $r==='1' ? 'Đã gửi thư cho '.$who.' ('.count($items).' vật phẩm, '.n($gold).' vàng, '.n($money).' xu).' : 'Gửi thư lỗi (mã '.h($r).').';

  /* ---------- giftcode ---------- */
  case 'gc_new':    // tao su kien code moi bang cach chep co cua mot su kien code mau (Type=1)
    $title=trim($P['title']??''); $end=$P['end']??''; $prefix=strtoupper(preg_replace('/[^A-Za-z0-9]/','',$P['prefix']??''));
    if($title==='' || !strtotime($end)) return 'Cần tên sự kiện và ngày kết thúc.';
    $tpl=(int)scalar($conn,"SELECT TOP 1 ActiveID FROM Db_Tank.dbo.Active WHERE Type=1 AND HasKey=1 ORDER BY ActiveID DESC");
    if(!$tpl) return 'Không có sự kiện code mẫu (Type=1) để chép.';
    $id=(int)scalar($conn,"SELECT ISNULL(MAX(ActiveID),0)+1 FROM Db_Tank.dbo.Active");
    $ok=exec_sql($conn,"INSERT INTO Db_Tank.dbo.Active(ActiveID,Title,Description,Content,AwardContent,HasKey,StartDate,EndDate,IsOnly,Type,ActionTimeContent,IsAdvance,GoodsExchangeTypes,GoodsExchangeNum,limitType,limitValue,IsShow,ActiveType,IconID,CanGetCode,CodePrefix)
      SELECT ?,?,?,?,?,HasKey,GETDATE(),?,IsOnly,Type,ActionTimeContent,IsAdvance,GoodsExchangeTypes,GoodsExchangeNum,limitType,limitValue,IsShow,ActiveType,IconID,CanGetCode,? FROM Db_Tank.dbo.Active WHERE ActiveID=?",
      [$id,$title,$P['desc']??$title,$P['desc']??$title,$P['desc']??$title,date('Y-m-d H:i:s',strtotime($end)),$prefix,$tpl]);
    return $ok===true ? "Đã tạo sự kiện #$id. Thêm phần thưởng rồi tạo code, sau đó bấm Xuất bản dữ liệu." : 'Lỗi: '.h($ok);

  case 'gc_award_add':
    $aid=(int)($P['aid']??0); $tid=(int)($P['tid']??0);
    if(!$aid || (!$tid && empty($P['gold']) && empty($P['money']))) return 'Thiếu sự kiện hoặc vật phẩm.';
    $ok=exec_sql($conn,"INSERT INTO Db_Tank.dbo.Active_Award(ActiveID,ItemID,Count,ValidDate,StrengthenLevel,AttackCompose,DefendCompose,LuckCompose,AgilityCompose,Gold,Money,Sex,Mark) VALUES(?,?,?,?,?,0,0,0,0,?,?,0,0)",
      [$aid,$tid,max(1,(int)($P['cnt']??1)),max(0,(int)($P['day']??0)),min(max_strength($conn),max(0,(int)($P['str']??0))),max(0,(int)($P['gold']??0)),max(0,(int)($P['money']??0))]);
    return $ok===true ? 'Đã thêm phần thưởng.' : 'Lỗi: '.h($ok);

  case 'gc_award_del':
    exec_sql($conn,"DELETE FROM Db_Tank.dbo.Active_Award WHERE ID=?",[(int)$P['id']]);
    return 'Đã xóa phần thưởng.';

  case 'gc_end':
    if(!strtotime($P['end']??'')) return 'Ngày không hợp lệ.';
    exec_sql($conn,"UPDATE Db_Tank.dbo.Active SET EndDate=? WHERE ActiveID=?",[date('Y-m-d H:i:s',strtotime($P['end'])),(int)$P['aid']]);
    return 'Đã đổi ngày kết thúc. Nhớ Xuất bản dữ liệu.';

  case 'gc_codes':
    // Creator cua dong code goc: -1 = moi nguoi 1 lan; < -1 = nhieu lan, tong -Creator-1 luot (xem _setup/sql/giftcode-nhieu-lan.sql)
    $aid=(int)($P['aid']??0);
    if(!scalar($conn,"SELECT COUNT(*) FROM Db_Tank.dbo.Active WHERE ActiveID=?",[$aid])) return 'Không có sự kiện #'.$aid.'.';
    $mode=($P['mode']??'')==='multi'?'multi':'once';
    $times=(int)($P['times']??0);
    if($mode==='multi' && ($times<1 || $times>100000)) return 'Số lượt phải từ 1 đến 100000.';
    $creator=$mode==='multi'?-($times+1):-1;
    $c=strtoupper(trim($P['code']??''));
    if($c===''){ $abc='ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; $c='NC4'; while(strlen($c)<11) $c.=$abc[random_int(0,strlen($abc)-1)]; }
    if(!preg_match('/^[A-Z0-9_\-]{3,30}$/',$c)) return 'Tên code chỉ gồm chữ không dấu, số, _ -, từ 3 đến 30 ký tự.';
    if(scalar($conn,"SELECT COUNT(*) FROM Db_Tank41.dbo.Active_Number WHERE AwardID=?",[$c])) return 'Code '.h($c).' đã tồn tại, chọn tên khác.';
    $r=exec_sql($conn,"INSERT INTO Db_Tank41.dbo.Active_Number(AwardID,ActiveID,PullDown,GetDate,UserID,Mark,Creator) VALUES(?,?,0,GETDATE(),0,0,?)",[$c,$aid,$creator]);
    if($r!==true) return 'Lỗi tạo code: '.h($r);
    $_SESSION['gc_new_code']=$c;
    return 'Đã tạo code '.h($c).': '.($mode==='multi'?'dùng nhiều lần, tổng '.$times.' lượt':'mỗi người dùng 1 lần').'.';

  case 'gc_code_del':
    // chi xoa dong goc: code ngung dung duoc, lich su nguoi da nhan giu lai
    $aid=(int)($P['aid']??0); $c=(string)($P['code']??'');
    exec_sql($conn,"DELETE FROM Db_Tank41.dbo.Active_Number WHERE ActiveID=? AND AwardID=? AND UserID=0",[$aid,$c]);
    return 'Đã xóa code '.h($c).'.';

  /* ---------- he thong ---------- */
  case 'rate_add':
    $t=(int)($P['type']??0); $rate=(float)($P['rate']??1);
    if($rate<=0 || $rate>1000) return 'Hệ số không hợp lệ.';
    $bd=$P['bday']?:'2020-01-01'; $ed=$P['eday']?:'2099-12-31'; $bt=$P['btime']?:'00:00'; $et=$P['etime']?:'23:59';
    exec_sql($conn,"INSERT INTO Db_Tank41.dbo.Rate(ServerID,Rate,BeginDay,EndDay,BeginTime,EndTime,Type) VALUES(?,?,?,?,?,?,?)",
      [SERVER_ID,$rate,"$bd 00:00:00","$ed 23:59:59","1900-01-01 $bt:00","1900-01-01 $et:59",$t]);
    $r=req('ExperienceRate.aspx',['serverId'=>SERVER_ID]);
    return 'Đã thêm tỉ lệ x'.$rate.'. Áp dụng vào server: mã '.h($r).' (0 là thành công).';

  case 'rate_del':
    // Rate khong co khoa chinh: xoa theo so thu tu dong, cung thu tu voi trang Hệ thống
    exec_sql($conn,";WITH r AS (SELECT ROW_NUMBER() OVER(ORDER BY Type,BeginDay,BeginTime,Rate) rn FROM Db_Tank41.dbo.Rate WHERE ServerID=?) DELETE FROM r WHERE rn=?",[SERVER_ID,(int)$P['rn']]);
    $r=req('ExperienceRate.aspx',['serverId'=>SERVER_ID]);
    return 'Đã xóa tỉ lệ. Áp dụng vào server: mã '.h($r).'.';

  case 'notice':
    $msg=trim($P['msg']??''); if($msg==='') return 'Chưa nhập nội dung.';
    $r=req('SystemNotice.aspx',['content'=>$msg]);
    return $r==='0' ? 'Đã phát thông báo toàn server.' : 'Phát thông báo lỗi (mã '.h($r).').';

  case 'publish':
    // Dung lai TUNG file XML qua <ten>.ashx (moi .ashx tu ghi file cua no). KHONG dung CreateAllXml.ashx:
    // DB (tank.bak) thieu du lieu so voi XML goc (QuestList 179/1115, NPCInfoList 1033/1274...), dung lai het se lam client mat nhiem vu.
    $allow = array_keys(publish_files());
    $files = array_values(array_intersect((array)($P['files']??[]), $allow)); $out=[];
    foreach($files as $f){ $r=req($f.'.ashx'); $out[] = $f.': '.(stripos($r,'Success')!==false ? 'OK' : 'lỗi'); }
    $types=array_map('intval',(array)($P['reload']??[])); $res=[];
    foreach($types as $t){ $res[]=$t.':'.req('NoticeServerUpdate.aspx',['serverID'=>SERVER_ID,'type'=>$t]); }
    if(!$files && !$types) return 'Chưa chọn file hay phần nào.';
    return ($files?'Dựng lại XML: '.h(implode(', ',$out)).'. ':'').($res?'Nạp lại server: '.h(implode(', ',$res)).' (0 là thành công).':'');

  case 'maintenance':
    if(empty($P['sure'])) return 'Phải tích ô xác nhận trước khi bảo trì.';
    $r=req('KitoffUser.aspx');
    return $r==='1' ? 'Đã bắt đầu đếm ngược bảo trì 6 phút (mỗi phút báo 1 lần), hết giờ sẽ đá mọi người ra.' : 'Lỗi (mã '.h($r).').';

  case 'cfg_set':
    $name=$P['name']??''; $val=$P['value']??'';
    $ok=exec_sql($conn,"UPDATE Db_Tank41.dbo.Server_Config SET Value=? WHERE Name=?",[$val,$name]);
    return $ok===true ? 'Đã lưu '.h($name).' = '.h($val).'. Cần khởi động lại Road để có hiệu lực.' : 'Lỗi: '.h($ok);

  case 'gm_add':
    $uid=user_id($conn,$user); if(!$uid) return 'Không thấy nhân vật của tài khoản '.h($user).'.';
    if(scalar($conn,"SELECT COUNT(*) FROM Db_Tank41.dbo.Game_Commands WHERE UserID=?",[$uid])) return h($user).' đã là GM.';
    exec_sql($conn,"INSERT INTO Db_Tank41.dbo.Game_Commands(UserID,Commands) VALUES(?,'AllCommands')",[$uid]);
    return 'Đã cấp GM cho '.h($user).' (UserID '.$uid.'). Cần khởi động lại Road để có hiệu lực.';

  case 'gm_del':
    if(scalar($conn,"SELECT COUNT(*) FROM Db_Tank41.dbo.Game_Commands")<=1) return 'Phải giữ ít nhất 1 GM (bảng trống thì Road tự tắt).';
    exec_sql($conn,"DELETE FROM Db_Tank41.dbo.Game_Commands WHERE UserID=?",[(int)$P['uid']]);
    return 'Đã gỡ GM. Cần khởi động lại Road để có hiệu lực.';
  }
  return 'Thao tác không hợp lệ.';
}
