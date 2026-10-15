<!doctype html>
<html lang="vi">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>GunnyNetco4 | Chơi miễn phí</title>
<style>
  :root{
    --bg:#0b1120; --bg2:#111a2e; --card:#161f33; --line:#273450;
    --accent:#ffb020; --accent2:#ff6a00; --text:#eaf1fb; --muted:#8ea2bf;
    --ok:#36d07f; --err:#ff5d6c;
  }
  *{box-sizing:border-box}
  html,body{margin:0}
  body{
    font-family:"Segoe UI",system-ui,Arial,sans-serif; color:var(--text);
    background:radial-gradient(1000px 560px at 50% -12%, #22345a, var(--bg)) fixed;
    min-height:100vh; line-height:1.55;
  }
  .wrap{max-width:960px; margin:0 auto; padding:34px 20px 70px}
  header{display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap}
  .brand{font-size:30px; font-weight:900; letter-spacing:.5px;
    background:linear-gradient(90deg,var(--accent),var(--accent2));
    -webkit-background-clip:text; background-clip:text; color:transparent}
  .badge{font-size:12px; color:var(--muted); border:1px solid var(--line); padding:5px 10px; border-radius:999px}
  .dot{display:inline-block; width:8px; height:8px; border-radius:50%; background:var(--ok); margin-right:6px; box-shadow:0 0 8px var(--ok)}
  .hero{text-align:center; margin:44px 0 6px}
  .hero h1{font-size:42px; margin:0 0 10px; line-height:1.14}
  .hero h1 span{background:linear-gradient(90deg,var(--accent),var(--accent2)); -webkit-background-clip:text; background-clip:text; color:transparent}
  .hero p{color:var(--muted); font-size:17px; margin:0}
  .grid{display:grid; grid-template-columns:1fr 1fr; gap:22px; margin-top:36px; align-items:start}
  .card{background:linear-gradient(180deg,var(--card),var(--bg2)); border:1px solid var(--line); border-radius:18px; padding:26px; box-shadow:0 16px 50px rgba(0,0,0,.45)}
  .card h2{margin:0 0 6px; font-size:20px}
  .card h2 .ico{color:var(--accent)}
  .muted{color:var(--muted); font-size:14px}
  .btn{display:block; width:100%; text-align:center; text-decoration:none; cursor:pointer; border:0;
    color:#1a1200; font-weight:800; font-size:17px; padding:15px; border-radius:12px; margin-top:16px;
    background:linear-gradient(90deg,var(--accent),var(--accent2)); box-shadow:0 8px 22px rgba(255,120,0,.35);
    transition:transform .08s ease, box-shadow .2s ease}
  .btn:hover{transform:translateY(-2px); box-shadow:0 12px 30px rgba(255,120,0,.5)}
  .btn[disabled]{opacity:.55; cursor:not-allowed; transform:none}
  .tabs{display:flex; gap:8px; background:#0d1626; border:1px solid var(--line); border-radius:12px; padding:5px; margin-bottom:6px}
  .tab{flex:1; text-align:center; padding:10px; border-radius:9px; cursor:pointer; font-weight:700; color:var(--muted); user-select:none}
  .tab.active{background:linear-gradient(90deg,var(--accent),var(--accent2)); color:#1a1200}
  .pane{display:none} .pane.active{display:block}
  .field{margin-top:12px}
  .field label{display:block; font-size:13px; color:var(--muted); margin-bottom:5px}
  .field input{width:100%; padding:12px 13px; border-radius:10px; border:1px solid var(--line);
    background:#0d1626; color:var(--text); font-size:15px; outline:none}
  .field input:focus{border-color:var(--accent)}
  .msg{margin-top:14px; padding:11px 13px; border-radius:10px; font-size:14px; display:none}
  .msg.ok{display:block; background:rgba(54,208,127,.12); border:1px solid var(--ok); color:var(--ok)}
  .msg.err{display:block; background:rgba(255,93,108,.12); border:1px solid var(--err); color:var(--err)}
  #panel{display:none}
  .acct{display:flex; align-items:center; gap:14px; padding:14px; background:#0d1626; border:1px solid var(--line); border-radius:12px}
  .av{width:48px; height:48px; border-radius:12px; flex:none; display:flex; align-items:center; justify-content:center; font-weight:900; font-size:22px; color:#1a1200; background:linear-gradient(135deg,var(--accent),var(--accent2))}
  .acct .nm{font-weight:800; font-size:17px}
  .acct .xu{color:var(--accent); font-size:13px; margin-top:2px}
  .feat{display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-top:14px}
  .feat .f{background:#121c30; border:1px dashed var(--line); border-radius:11px; padding:13px; text-align:center; color:var(--muted); font-size:13px}
  .feat .f b{display:block; color:var(--text); font-size:14px; margin-bottom:2px}
  .soon{font-size:11px; color:var(--accent); border:1px solid var(--accent); border-radius:999px; padding:1px 7px; margin-top:6px; display:inline-block}
  .link{color:var(--muted); font-size:13px; text-align:center; margin-top:14px; cursor:pointer}
  .link:hover{color:var(--text)}
  .steps{margin-top:32px}
  .steps h2{text-align:center; font-size:22px}
  .stepgrid{display:grid; grid-template-columns:repeat(3,1fr); gap:16px; margin-top:16px}
  .step{background:var(--card); border:1px solid var(--line); border-radius:14px; padding:18px; text-align:center}
  .step .n{width:34px; height:34px; border-radius:50%; margin:0 auto 10px; display:flex; align-items:center; justify-content:center;
    font-weight:800; color:#1a1200; background:linear-gradient(90deg,var(--accent),var(--accent2))}
  .step b{display:block; margin-bottom:4px}
  .note{background:#0e1829; border-left:3px solid var(--accent); padding:12px 14px; border-radius:8px; color:var(--muted); font-size:13px; margin-top:16px}
  code{background:#0a1120; padding:2px 7px; border-radius:6px; color:#ffd479; font-size:13px}
  .foot{text-align:center; color:#56688a; font-size:12px; margin-top:38px}
  @@media (max-width:760px){
    .grid{grid-template-columns:1fr} .stepgrid{grid-template-columns:1fr}
    .hero h1{font-size:30px} .wrap{padding:24px 16px 60px} .brand{font-size:26px}
  }
</style>
</head>
<body>
<div class="wrap">
  <header>
    <div class="brand">GUNNYNETCO4</div>
    <div class="badge"><span class="dot"></span>Server đang mở</div>
  </header>

  <div class="hero">
    <h1>Bắn Gà huyền thoại, <span>chơi miễn phí</span></h1>
    <p>Tải client, tạo tài khoản và vào game trong 2 phút.</p>
  </div>

  <div class="grid">
    <div class="card">
      <h2><span class="ico">⬇</span> Tải Client</h2>
      <div class="muted">Bản Windows &middot; ~145 MB &middot; đã kèm sẵn Flash, không cần cài gì thêm.</div>
      <a class="btn" href="/downloads/GunnyNetco4-Launcher.zip">TẢI LAUNCHER (Windows)</a>
      <div class="note">
        Giải nén rồi chạy <code>netco4gunny.exe</code>. Nếu SmartScreen chặn, bấm <b>More info</b> rồi <b>Run anyway</b>.
      </div>
    </div>

    <div class="card">
      <div id="auth">
        <div class="tabs">
          <div class="tab active" data-tab="reg">Đăng ký</div>
          <div class="tab" data-tab="log">Đăng nhập</div>
        </div>

        <div class="pane active" id="pane-reg">
          <form id="regForm" autocomplete="off">
            <div class="field"><label>Tên tài khoản (5 đến 15 ký tự, không dấu, không khoảng trắng)</label>
              <input id="r_user" maxlength="15" placeholder="vd: thanhgun"></div>
            <div class="field"><label>Mật khẩu (tối thiểu 6 ký tự)</label>
              <input id="r_pass" type="password" placeholder="••••••"></div>
            <div class="field"><label>Nhập lại mật khẩu</label>
              <input id="r_pass2" type="password" placeholder="••••••"></div>
            <button class="btn" type="submit" id="regBtn">TẠO TÀI KHOẢN</button>
          </form>
        </div>

        <div class="pane" id="pane-log">
          <form id="logForm" autocomplete="off">
            <div class="field"><label>Tên tài khoản</label>
              <input id="l_user" placeholder="tài khoản của bạn"></div>
            <div class="field"><label>Mật khẩu</label>
              <input id="l_pass" type="password" placeholder="••••••"></div>
            <button class="btn" type="submit" id="logBtn">ĐĂNG NHẬP</button>
          </form>
        </div>
        <div class="msg" id="authMsg"></div>
      </div>

      <div id="panel">
        <div class="acct">
          <div class="av" id="p_av">G</div>
          <div><div class="nm" id="p_name">Người chơi</div><div class="xu" id="p_xu">Xu: 0</div></div>
        </div>
        <div class="feat">
          <div class="f"><b>Điểm danh</b>nhận xu mỗi ngày<br><span class="soon">sắp có</span></div>
          <div class="f"><b>Đổi mật khẩu</b>bảo mật tài khoản<br><span class="soon">sắp có</span></div>
          <div class="f"><b>Lịch sử</b>giao dịch của bạn<br><span class="soon">sắp có</span></div>
          <div class="f"><b>Sự kiện</b>quà và giftcode<br><span class="soon">sắp có</span></div>
        </div>
        <a class="btn" href="/downloads/GunnyNetco4-Launcher.zip" style="margin-top:14px">TẢI LAUNCHER VÀ VÀO CHƠI</a>
        <div class="link" id="logout">Đăng xuất</div>
      </div>
    </div>
  </div>

  <div class="steps">
    <h2>Chơi trong 3 bước</h2>
    <div class="stepgrid">
      <div class="step"><div class="n">1</div><b>Đăng ký</b><span class="muted">Tạo tài khoản ở ô bên trên.</span></div>
      <div class="step"><div class="n">2</div><b>Tải và mở launcher</b><span class="muted">Giải nén, chạy netco4gunny.exe.</span></div>
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

  var tabs=document.querySelectorAll('.tab');
  tabs.forEach(function(t){
    t.addEventListener('click',function(){
      tabs.forEach(function(x){x.classList.remove('active')}); t.classList.add('active');
      document.getElementById('pane-reg').classList.toggle('active', t.dataset.tab==='reg');
      document.getElementById('pane-log').classList.toggle('active', t.dataset.tab==='log');
      clearMsg();
    });
  });

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
      if(d&&d.success){ show('ok',(d.message||'Đăng ký thành công!')+' Chuyển qua tab Đăng nhập để vào.'); document.getElementById('regForm').reset(); }
      else show('err',firstError(d));
    }).catch(function(){ show('err','Không kết nối được máy chủ.'); })
    .finally(function(){ b.disabled=false; b.textContent='TẠO TÀI KHOẢN'; });
  });

  function openPanel(info){
    document.getElementById('auth').style.display='none';
    document.getElementById('panel').style.display='block';
    var name=(info&&info.UserName)||'Người chơi';
    document.getElementById('p_name').textContent=name;
    document.getElementById('p_av').textContent=(name[0]||'G').toUpperCase();
    document.getElementById('p_xu').textContent='Xu: '+((info&&info.Money)||0);
  }
  document.getElementById('logForm').addEventListener('submit',function(e){
    e.preventDefault();
    var u=document.getElementById('l_user').value.trim(), p=document.getElementById('l_pass').value;
    if(!u||!p){ show('err','Nhập tài khoản và mật khẩu.'); return; }
    var b=document.getElementById('logBtn'); b.disabled=true; b.textContent='Đang đăng nhập...';
    post('/api/login131',{username:u,password:p}).then(function(d){
      if(d&&d.success){
        try{ localStorage.setItem('gn_token',(d.data&&d.data.token)||''); localStorage.setItem('gn_user',JSON.stringify((d.data&&d.data.userInfo)||{})); }catch(e){}
        clearMsg(); openPanel(d.data&&d.data.userInfo);
      } else show('err',firstError(d));
    }).catch(function(){ show('err','Không kết nối được máy chủ.'); })
    .finally(function(){ b.disabled=false; b.textContent='ĐĂNG NHẬP'; });
  });

  document.getElementById('logout').addEventListener('click',function(){
    try{ localStorage.removeItem('gn_token'); localStorage.removeItem('gn_user'); }catch(e){}
    document.getElementById('panel').style.display='none';
    document.getElementById('auth').style.display='block';
    document.getElementById('logForm').reset();
  });

  try{
    var t=localStorage.getItem('gn_token');
    if(t){ openPanel(JSON.parse(localStorage.getItem('gn_user')||'{}')); }
  }catch(e){}
})();
</script>
</body>
</html>
