<!doctype html>
<html lang="vi">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Trang cá nhân | GunnyNetco4</title>
<link rel="stylesheet" href="/css/portal.css?v=1">
<style>
  /* trang ca nhan: menu trai + noi dung; them muc moi = them 1 <a data-sec> o .side va 1 <section id="sec-..."> */
  .wrap{max-width:1120px}
  .top{display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap; padding-bottom:18px; border-bottom:1px solid var(--line)}
  .top nav{display:flex; align-items:center; gap:6px; flex-wrap:wrap}
  .top nav a{color:var(--muted); text-decoration:none; font-weight:600; font-size:14px; padding:7px 12px; border-radius:9px}
  .top nav a:hover{color:var(--text); background:#16213a}
  .chip{display:flex; align-items:center; gap:8px; background:#0d1626; border:1px solid var(--line); border-radius:999px; padding:4px 12px 4px 4px; font-weight:700; font-size:14px}
  .chip .av{width:28px; height:28px; border-radius:50%; font-size:14px}
  .layout{display:grid; grid-template-columns:230px 1fr; gap:22px; margin-top:24px; align-items:start}
  .side{display:flex; flex-direction:column; gap:4px; background:linear-gradient(180deg,var(--card),var(--bg2)); border:1px solid var(--line); border-radius:16px; padding:10px; position:sticky; top:16px}
  .side a{display:flex; align-items:center; justify-content:space-between; gap:8px; padding:11px 12px; border-radius:10px; color:var(--muted); text-decoration:none; font-weight:700; font-size:14px; cursor:pointer}
  .side a:hover{background:#16213a; color:var(--text)}
  .side a.on{background:linear-gradient(90deg,var(--accent),var(--accent2)); color:#1a1200}
  .side a .soon{font-weight:600; margin:0}
  .side a.on .soon{color:#1a1200; border-color:#1a1200}
  section{display:none} section.on{display:block}
  section > .card + .card{margin-top:18px}
  .prof{display:flex; align-items:center; gap:18px; flex-wrap:wrap}
  .prof .av{width:72px; height:72px; border-radius:18px; font-size:32px}
  .prof .nm{font-size:24px; font-weight:900; line-height:1.2}
  .prof .sub{color:var(--muted); font-size:14px; margin-top:2px}
  .lv{margin-top:18px}
  .lv .row{display:flex; justify-content:space-between; font-size:13px; color:var(--muted); margin-bottom:6px} .lv .row b{color:var(--text)}
  .bar{height:10px; border-radius:999px; background:#0d1626; border:1px solid var(--line); overflow:hidden}
  .bar i{display:block; height:100%; background:linear-gradient(90deg,var(--accent),var(--accent2))}
  .stats{display:grid; grid-template-columns:repeat(4,1fr); gap:12px; margin-top:18px}
  .stat{background:#0d1626; border:1px solid var(--line); border-radius:12px; padding:13px 14px}
  .stat span{display:block; color:var(--muted); font-size:12px}
  .stat b{display:block; font-size:19px; margin-top:2px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis}
  .stat b.gold{color:var(--accent)}
  .kv{display:grid; grid-template-columns:repeat(2,1fr); gap:8px 24px; margin-top:16px; font-size:14px}
  .kv div{display:flex; justify-content:space-between; gap:12px; padding:8px 0; border-bottom:1px dashed var(--line)}
  .kv span{color:var(--muted)}
  .teaser{display:flex; align-items:center; justify-content:space-between; gap:14px; flex-wrap:wrap}
  .teaser .btn{width:auto; margin:0; padding:12px 22px; font-size:15px}
  .ddhd{display:flex; justify-content:space-between; align-items:baseline; gap:8px; margin-bottom:14px}
  .ddhd span{color:var(--accent); font-weight:800}
  .empty{text-align:center; padding:30px 10px}
  .empty b{display:block; font-size:18px; margin-bottom:6px}
  @@media (max-width:860px){
    .layout{grid-template-columns:1fr} .side{position:static; flex-direction:row; overflow-x:auto} .side a{white-space:nowrap}
    .stats{grid-template-columns:repeat(2,1fr)} .kv{grid-template-columns:1fr}
  }
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <a class="brand" href="/">GUNNYNETCO4</a>
    <nav>
      <a href="/">Trang chủ</a>
      <a href="/#dl2">Tải game</a>
      <div class="chip"><div class="av" id="c_av">G</div><span id="c_name">...</span></div>
      <a id="logout" style="cursor:pointer">Đăng xuất</a>
    </nav>
  </div>

  <div class="layout">
    <div class="side" id="side">
      <a data-sec="hoso" class="on">Hồ sơ</a>
      <a data-sec="diemdanh">Điểm danh</a>
      <a data-sec="ruong">Rương đồ <span class="soon">sắp có</span></a>
      <a data-sec="matkhau">Đổi mật khẩu <span class="soon">sắp có</span></a>
      <a data-sec="lichsu">Lịch sử <span class="soon">sắp có</span></a>
    </div>

    <div>
      <section id="sec-hoso" class="on">
        <div class="card" id="profCard"><div class="muted">Đang tải hồ sơ...</div></div>
        <div class="card teaser" id="ddTeaser" style="display:none">
          <div><b style="font-size:17px">Điểm danh hôm nay</b><div class="muted" id="ddTeaserTxt"></div></div>
          <a class="btn" data-go="diemdanh">Đi điểm danh</a>
        </div>
      </section>

      <section id="sec-diemdanh">
        <div class="card">
          <div class="ddhd"><h2 id="dd_title" style="margin:0">Điểm danh</h2><span id="dd_cnt"></span></div>
          <div class="ddgrid" id="dd_grid"></div>
          <div class="ddq" id="dd_daily"></div>
          <div class="ddmoc" id="dd_moc"></div>
          <button class="btn" id="dd_btn" disabled>ĐIỂM DANH HÔM NAY</button>
          <div class="msg" id="dd_msg"></div>
          <div class="note">Quà gửi vào <b>hộp thư trong game</b>, đang online cũng nhận được. Mỗi ngày 1 lần, sang tháng mới đếm lại từ đầu.</div>
        </div>
      </section>

      <section id="sec-ruong"><div class="card empty"><b>Rương đồ</b><div class="muted">Cất đồ ra web và lấy lại vào game. Tính năng đang phát triển.</div></div></section>
      <section id="sec-matkhau"><div class="card empty"><b>Đổi mật khẩu</b><div class="muted">Tính năng đang phát triển.</div></div></section>
      <section id="sec-lichsu"><div class="card empty"><b>Lịch sử</b><div class="muted">Lịch sử điểm danh, nhận quà và giao dịch. Tính năng đang phát triển.</div></div></section>
    </div>
  </div>

  <div class="foot">gunny.netco4.click &middot; server test</div>
</div>

<script>
(function(){
  var token=''; try{ token=localStorage.getItem('gn_token')||''; }catch(e){}
  if(!token){ location.replace('/'); return; }
  function logout(){ try{ localStorage.removeItem('gn_token'); localStorage.removeItem('gn_user'); }catch(e){} location.href='/'; }
  document.getElementById('logout').addEventListener('click',logout);
  try{ var u=JSON.parse(localStorage.getItem('gn_user')||'{}'), n=u.UserName||'Người chơi';
    document.getElementById('c_name').textContent=n; document.getElementById('c_av').textContent=(n[0]||'G').toUpperCase(); }catch(e){}

  function api(url){
    return fetch(url,{method:'POST',headers:{'Accept':'application/json','Authorization':'Bearer '+token}})
      .then(function(r){ if(r.status===403){ logout(); return {success:false,message:'Phiên đăng nhập đã hết.'}; }
        return r.json().catch(function(){ return {success:false,message:'Lỗi máy chủ, thử lại sau.'}; }); });
  }
  function fmt(x){ return (Number(x)||0).toLocaleString('vi-VN'); }
  function esc(s){ return String(s==null?'':s).replace(/[&<>"]/g,function(c){ return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]; }); }

  // menu trai: #hoso, #diemdanh, ...
  function go(sec){
    if(!document.getElementById('sec-'+sec)) sec='hoso';
    document.querySelectorAll('section').forEach(function(s){ s.classList.toggle('on', s.id==='sec-'+sec); });
    document.querySelectorAll('#side a').forEach(function(a){ a.classList.toggle('on', a.dataset.sec===sec); });
    if(location.hash!=='#'+sec) history.replaceState(null,'','#'+sec);
  }
  document.querySelectorAll('[data-sec],[data-go]').forEach(function(a){ a.addEventListener('click',function(){ go(a.dataset.sec||a.dataset.go); }); });
  go((location.hash||'#hoso').slice(1));

  // ho so
  api('/api/hoso').then(function(d){
    var box=document.getElementById('profCard');
    if(!d||!d.success){ box.innerHTML='<div class="msg err" style="display:block">'+esc((d&&d.message)||'Không tải được hồ sơ.')+'</div>'; return; }
    var c=d.data.nhanVat, acc=d.data.taiKhoan;
    if(!c){ box.innerHTML='<div class="empty"><b>Chưa có nhân vật</b><div class="muted">Tài khoản <b>'+esc(acc)+'</b> chưa tạo nhân vật. Tải game ở trang chủ, đăng nhập và tạo nhân vật, sau đó quay lại đây.</div><a class="btn" href="/#dl2" style="max-width:260px;margin:16px auto 0">TẢI GAME</a></div>'; return; }
    var rate=c.tran?Math.round(100*c.thang/c.tran):0;
    box.innerHTML=
      '<div class="prof"><div class="av">'+esc((c.ten[0]||'G').toUpperCase())+'</div><div>'
        +'<div class="nm">'+esc(c.ten)+'</div>'
        +'<div class="sub">Tài khoản '+esc(acc)+' · '+esc(c.gioiTinh)+' · <span class="dot'+(c.online?'':' off')+'"></span>'+(c.online?'Đang trong game':'Ngoại tuyến')+'</div></div></div>'
      +'<div class="lv"><div class="row"><span>Cấp <b>'+c.cap+'</b> / '+c.capToiDa+'</span><span>'+(c.cap>=c.capToiDa?'Đã max cấp':c.phanTramCap+'% lên cấp '+(c.cap+1))+'</span></div><div class="bar"><i style="width:'+(c.cap>=c.capToiDa?100:c.phanTramCap)+'%"></i></div></div>'
      +'<div class="stats">'
        +'<div class="stat"><span>Lực chiến</span><b class="gold">'+fmt(c.lucChien)+'</b></div>'
        +'<div class="stat"><span>Vàng</span><b>'+fmt(c.vang)+'</b></div>'
        +'<div class="stat"><span>Xu</span><b>'+fmt(c.xu)+'</b></div>'
        +'<div class="stat"><span>Xu khóa</span><b>'+fmt(c.xuKhoa)+'</b></div>'
      +'</div>'
      +'<div class="kv">'
        +'<div><span>Trận thắng</span><b>'+fmt(c.thang)+' / '+fmt(c.tran)+' ('+rate+'%)</b></div>'
        +'<div><span>Bang hội</span><b>'+esc(c.bang||'Chưa vào bang')+'</b></div>'
        +'<div><span>Công hiến</span><b>'+fmt(c.congHien)+'</b></div>'
        +'<div><span>Điểm thành tích</span><b>'+fmt(c.thanhTich)+'</b></div>'
        +'<div><span>Ngày tạo nhân vật</span><b>'+esc(c.ngayTao)+'</b></div>'
        +'<div><span>Vào game lần cuối</span><b>'+esc(c.lanCuoi)+'</b></div>'
      +'</div>'
      +(c.online?'<div class="note">Bạn đang trong game: vàng, xu có thể chậm vài phút so với trong game.</div>':'');
  }).catch(function(){ document.getElementById('profCard').innerHTML='<div class="msg err" style="display:block">Không kết nối được máy chủ.</div>'; });

  // diem danh: /api/diemdanh/info va /api/diemdanh (DiemDanhController)
  var ddMsg=document.getElementById('dd_msg'), ddBtn=document.getElementById('dd_btn');
  function ddShow(type,text){ ddMsg.className='msg '+type; ddMsg.textContent=text; }
  function ddRender(d){
    document.getElementById('dd_title').textContent='Điểm danh tháng '+d.thang;
    document.getElementById('dd_cnt').textContent=d.ngay.length+' / '+d.songay+' ngày';
    var g=document.getElementById('dd_grid'); g.innerHTML='';
    for(var i=1;i<=d.songay;i++){
      var c=document.createElement('div'); c.textContent=i;
      if(d.ngay.indexOf(i)>=0) c.className='done'; else if(i===d.homnay) c.className='today'; else if(i<d.homnay) c.className='miss';
      g.appendChild(c);
    }
    var dl=document.getElementById('dd_daily'); dl.innerHTML='';
    if(d.quangay){ var b=document.createElement('b'); b.textContent=d.quangay; dl.appendChild(document.createTextNode('Mỗi ngày: ')); dl.appendChild(b); }
    var m=document.getElementById('dd_moc'); m.innerHTML='';
    (d.moc||[]).forEach(function(x){
      var r=document.createElement('div'); if(x.dat) r.className='ok';
      var a=document.createElement('span'); a.textContent=(x.dat?'✓ ':'')+'Đủ '+x.moc+' ngày';
      var q=document.createElement('span'); q.textContent=x.qua;
      r.appendChild(a); r.appendChild(q); m.appendChild(r);
    });
    ddBtn.disabled=!!d.dadiemdanh; ddBtn.textContent=d.dadiemdanh?'HÔM NAY ĐÃ ĐIỂM DANH':'ĐIỂM DANH HÔM NAY';
    var t=document.getElementById('ddTeaser'); t.style.display='flex';
    document.getElementById('ddTeaserTxt').textContent=d.dadiemdanh?('Đã điểm danh. Tháng này: '+d.ngay.length+' ngày.'):('Chưa điểm danh. Quà hôm nay: '+(d.quangay||'không có')+'.');
  }
  function ddLoad(){
    api('/api/diemdanh/info').then(function(d){
      if(d&&d.success&&d.data) ddRender(d.data); else { ddBtn.disabled=true; ddShow('err',(d&&d.message)||'Không tải được điểm danh.'); }
    }).catch(function(){ ddShow('err','Không kết nối được máy chủ.'); });
  }
  ddBtn.addEventListener('click',function(){
    ddBtn.disabled=true; ddBtn.textContent='Đang gửi quà...';
    api('/api/diemdanh').then(function(d){
      if(d&&d.success) ddShow('ok',d.message+((d.data&&d.data.qua&&d.data.qua.length)?' Nhận: '+d.data.qua.join('; ')+'.':''));
      else ddShow('err',(d&&d.message)||'Có lỗi xảy ra.');
      ddLoad();
    }).catch(function(){ ddShow('err','Không kết nối được máy chủ.'); ddBtn.disabled=false; ddBtn.textContent='ĐIỂM DANH HÔM NAY'; });
  });
  ddLoad();
})();
</script>
</body>
</html>
