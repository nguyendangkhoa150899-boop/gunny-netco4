<!doctype html>
<html lang="vi">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>GunnyNetco4 | Chơi miễn phí</title>
<link rel="stylesheet" href="/css/portal.css?v=1">
<style>
  .hero{text-align:center; margin:44px 0 6px}
  .hero h1{font-size:42px; margin:0 0 10px; line-height:1.14}
  .hero h1 span{background:linear-gradient(90deg,var(--accent),var(--accent2)); -webkit-background-clip:text; background-clip:text; color:transparent}
  .hero p{color:var(--muted); font-size:17px; margin:0}
  .grid{display:grid; grid-template-columns:1fr 1fr; gap:22px; margin-top:36px; align-items:start}
  .dl2{display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-top:16px}
  .dl2 .btn{margin-top:0}
  pre.cmd{background:#0a1120; color:#ffd479; border-radius:8px; padding:10px 12px; font-size:12px; margin:10px 0 8px; white-space:pre-wrap; word-break:break-all}
  .copy{background:#1d2740; color:var(--text); border:1px solid var(--line); border-radius:8px; padding:6px 12px; font-size:12px; cursor:pointer}
  .copy:hover{border-color:var(--accent)}
  .pane{display:none} .pane.active{display:block}
  .who{display:flex; align-items:center; gap:14px; padding:14px; background:#0d1626; border:1px solid var(--line); border-radius:12px; margin-top:12px}
  .who .nm{font-weight:800; font-size:17px}
  .steps{margin-top:32px}
  .steps h2{text-align:center; font-size:22px}
  .stepgrid{display:grid; grid-template-columns:repeat(3,1fr); gap:16px; margin-top:16px}
  .step{background:var(--card); border:1px solid var(--line); border-radius:14px; padding:18px; text-align:center}
  .step .n{width:34px; height:34px; border-radius:50%; margin:0 auto 10px; display:flex; align-items:center; justify-content:center;
    font-weight:800; color:#1a1200; background:linear-gradient(90deg,var(--accent),var(--accent2))}
  .step b{display:block; margin-bottom:4px}
  @@media (max-width:760px){
    .grid{grid-template-columns:1fr} .stepgrid{grid-template-columns:1fr} .dl2{grid-template-columns:1fr}
    .hero h1{font-size:30px}
  }
</style>
</head>
<body>
<div class="wrap">
  <header>
    <a class="brand" href="/">GUNNYNETCO4</a>
    <div class="badge"><span class="dot"></span>Server đang mở</div>
  </header>

  <div class="hero">
    <h1>Bắn Gà huyền thoại, <span>chơi miễn phí</span></h1>
    <p>Tải client, tạo tài khoản và vào game trong 2 phút.</p>
  </div>

  <div class="grid">
    <div class="card">
      <h2><span class="ico">⬇</span> Tải Client</h2>
      <div class="muted">Đã kèm sẵn Flash, không cần cài gì thêm.</div>
      <div class="dl2" id="dl2">
        <a class="btn" id="dlWin" href="/downloads/GunnyNetco4-Launcher.zip">WINDOWS<small>~145 MB</small></a>
        <a class="btn mac" id="dlMac" href="/downloads/GunnyNetco4-Mac.zip">MACBOOK<small>~144 MB</small></a>
      </div>
      <div class="note">
        <b>Windows:</b> giải nén rồi chạy <code>netco4gunny.exe</code>. Nếu SmartScreen chặn, bấm <b>More info</b> rồi <b>Run anyway</b>.
      </div>
      <div class="note">
        <b>MacBook:</b> mở file zip, kéo <code>GunnyNetco4.app</code> vào Applications. Mở Terminal, dán 2 lệnh dưới rồi mở app.
        Máy chip Apple (M1 trở lên) sẽ hỏi cài Rosetta, bấm Cài đặt.
        <pre class="cmd" id="macCmd">xattr -cr /Applications/GunnyNetco4.app
codesign --force --deep --sign - /Applications/GunnyNetco4.app</pre>
        <button type="button" class="copy" id="copyMac">Sao chép lệnh</button>
      </div>
    </div>

    <div class="card">
      <!-- dang nhap hien truoc; bam "Dang ky ngay" moi hien form dang ky -->
      <div class="pane active" id="pane-log">
        <h2><span class="ico">🔑</span> Đăng nhập</h2>
        <div class="muted">Dùng tài khoản game để vào trang cá nhân.</div>
        <form id="logForm" autocomplete="off">
          <div class="field"><label>Tên tài khoản</label>
            <input id="l_user" placeholder="tài khoản của bạn" autocomplete="username"></div>
          <div class="field"><label>Mật khẩu</label>
            <input id="l_pass" type="password" placeholder="••••••" autocomplete="current-password"></div>
          <button class="btn" type="submit" id="logBtn">ĐĂNG NHẬP</button>
        </form>
        <div class="switch">Chưa có tài khoản? <a data-go="reg">Đăng ký ngay</a></div>
      </div>

      <div class="pane" id="pane-reg">
        <h2><span class="ico">✚</span> Đăng ký</h2>
        <div class="muted">Tạo tài khoản mới, dùng chung cho game và trang cá nhân.</div>
        <form id="regForm" autocomplete="off">
          <div class="field"><label>Tên tài khoản (5 đến 15 ký tự, không dấu, không khoảng trắng)</label>
            <input id="r_user" maxlength="15" placeholder="vd: biabia"></div>
          <div class="field"><label>Mật khẩu (tối thiểu 6 ký tự)</label>
            <input id="r_pass" type="password" placeholder="••••••" autocomplete="new-password"></div>
          <div class="field"><label>Nhập lại mật khẩu</label>
            <input id="r_pass2" type="password" placeholder="••••••" autocomplete="new-password"></div>
          <button class="btn" type="submit" id="regBtn">TẠO TÀI KHOẢN</button>
        </form>
        <div class="switch">Đã có tài khoản? <a data-go="log">Đăng nhập</a></div>
      </div>

      <div class="pane" id="pane-in">
        <h2><span class="ico">✔</span> Đã đăng nhập</h2>
        <div class="who"><div class="av" id="w_av">G</div><div><div class="nm" id="w_name">Người chơi</div><div class="muted">Điểm danh, hồ sơ nhân vật và các tính năng khác ở trang cá nhân.</div></div></div>
        <a class="btn" href="/dashboard">VÀO TRANG CÁ NHÂN</a>
        <div class="switch"><a id="logout">Đăng xuất</a></div>
      </div>

      <div class="msg" id="authMsg"></div>
    </div>
  </div>

  <div class="steps">
    <h2>Chơi trong 3 bước</h2>
    <div class="stepgrid">
      <div class="step"><div class="n">1</div><b>Đăng ký</b><span class="muted">Bấm "Đăng ký ngay" ở khung đăng nhập.</span></div>
      <div class="step"><div class="n">2</div><b>Tải và mở launcher</b><span class="muted">Windows chạy netco4gunny.exe, MacBook mở GunnyNetco4.app.</span></div>
      <div class="step"><div class="n">3</div><b>Đăng nhập và chơi</b><span class="muted">Nhập tài khoản vừa tạo rồi bấm Chơi.</span></div>
    </div>
  </div>

  <div class="foot">gunny.netco4.click &middot; server test</div>
</div>

<script>
(function(){
  var authMsg=document.getElementById('authMsg');
  function show(type,text){ authMsg.className='msg '+type; authMsg.textContent=text; }
  function clearMsg(){ authMsg.className='msg'; authMsg.textContent=''; }
  function pane(name){
    ['log','reg','in'].forEach(function(n){ document.getElementById('pane-'+n).classList.toggle('active', n===name); });
    clearMsg();
    var f=document.querySelector('#pane-'+name+' input'); if(f) f.focus();
  }
  document.querySelectorAll('[data-go]').forEach(function(a){ a.addEventListener('click',function(){ pane(a.dataset.go); }); });

  function post(url,data){
    var body=new URLSearchParams(); Object.keys(data).forEach(function(k){ body.append(k,data[k]); });
    return fetch(url,{method:'POST',headers:{'Accept':'application/json'},body:body})
      .then(function(r){ return r.json().catch(function(){return {success:false,message:'Lỗi máy chủ, thử lại sau.'};}); });
  }
  function firstError(d){ if(d&&d.errors){ var k=Object.keys(d.errors); if(k.length) return d.errors[k[0]][0]; } return (d&&d.message)||'Có lỗi xảy ra.'; }

  document.getElementById('regForm').addEventListener('submit',function(e){
    e.preventDefault();
    var u=document.getElementById('r_user').value.trim();
    var p=document.getElementById('r_pass').value, rp=document.getElementById('r_pass2').value;
    if(u.length<5||u.length>15){ show('err','Tên tài khoản phải từ 5 đến 15 ký tự.'); return; }
    if(/[^a-zA-Z0-9]/.test(u)){ show('err','Tên tài khoản chỉ gồm chữ và số, không dấu, không khoảng trắng.'); return; }
    if(p.length<6){ show('err','Mật khẩu tối thiểu 6 ký tự.'); return; }
    if(p!==rp){ show('err','Nhập lại mật khẩu không khớp.'); return; }
    var b=document.getElementById('regBtn'); b.disabled=true; b.textContent='Đang tạo...';
    post('/api/register',{username:u,password:p,repassword:rp,email:''}).then(function(d){
      if(d&&d.success){
        document.getElementById('regForm').reset(); pane('log');
        document.getElementById('l_user').value=u; document.getElementById('l_pass').focus();
        show('ok',(d.message||'Đăng ký thành công!')+' Nhập mật khẩu để đăng nhập.');
      } else show('err',firstError(d));
    }).catch(function(){ show('err','Không kết nối được máy chủ.'); })
    .finally(function(){ b.disabled=false; b.textContent='TẠO TÀI KHOẢN'; });
  });

  document.getElementById('logForm').addEventListener('submit',function(e){
    e.preventDefault();
    var u=document.getElementById('l_user').value.trim(), p=document.getElementById('l_pass').value;
    if(!u||!p){ show('err','Nhập tài khoản và mật khẩu.'); return; }
    var b=document.getElementById('logBtn'); b.disabled=true; b.textContent='Đang đăng nhập...';
    post('/api/login131',{username:u,password:p}).then(function(d){
      if(d&&d.success){
        try{ localStorage.setItem('gn_token',(d.data&&d.data.token)||''); localStorage.setItem('gn_user',JSON.stringify((d.data&&d.data.userInfo)||{})); }catch(e){}
        location.href='/dashboard';
      } else { show('err',firstError(d)); b.disabled=false; b.textContent='ĐĂNG NHẬP'; }
    }).catch(function(){ show('err','Không kết nối được máy chủ.'); b.disabled=false; b.textContent='ĐĂNG NHẬP'; });
  });

  document.getElementById('logout').addEventListener('click',function(){
    try{ localStorage.removeItem('gn_token'); localStorage.removeItem('gn_user'); }catch(e){}
    document.getElementById('logForm').reset(); pane('log');
  });

  // Nguoi dung Mac: dua nut MacBook len truoc (moi nut giu mau rieng)
  if(/Mac/i.test(navigator.platform||navigator.userAgent)){
    var w=document.getElementById('dlWin'), m=document.getElementById('dlMac');
    m.parentNode.insertBefore(m,w);
  }
  document.getElementById('copyMac').addEventListener('click',function(){
    var b=this, txt=document.getElementById('macCmd').textContent;
    var done=function(){ b.textContent='Đã sao chép'; setTimeout(function(){ b.textContent='Sao chép lệnh'; },1800); };
    if(navigator.clipboard&&navigator.clipboard.writeText){ navigator.clipboard.writeText(txt).then(done,function(){}); }
    else { var r=document.createRange(); r.selectNodeContents(document.getElementById('macCmd')); var s=window.getSelection(); s.removeAllRanges(); s.addRange(r); }
  });

  // da dang nhap: hien loi chao + nut vao trang ca nhan (trang chu van la trang tai game)
  try{
    if(localStorage.getItem('gn_token')){
      var u=JSON.parse(localStorage.getItem('gn_user')||'{}'), n=u.UserName||'Người chơi';
      document.getElementById('w_name').textContent=n; document.getElementById('w_av').textContent=(n[0]||'G').toUpperCase();
      pane('in');
    }
  }catch(e){}
})();
</script>
</body>
</html>
