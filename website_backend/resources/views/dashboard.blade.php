<!doctype html>
<html lang="vi">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Trang cá nhân | GunnyNetco4</title>
<link rel="stylesheet" href="/css/portal.css?v=2">
<style>
  /* Giao dien theo bo TLBB (play.netco4.click): nen toi trung tinh, the #1b1e27, diem nhan vang.
     Them muc moi = them 1 nut <button data-sec="x"> o #nav va 1 <section id="sec-x">. */
  :root{--bg:#12141a;--bg2:#161922;--card:#1b1e27;--line:#2a2e3b;--text:#e8eaf0;--muted:#8a90a3;--ok:#3ddc84;--err:#ff5d5d;--blue:#4da3ff;--gold:#ffcf5c;--accent:#ffcf5c;--accent2:#ffa53a}
  body{background:var(--bg)}
  .wrap{max-width:1040px;padding:18px 16px 60px}
  .card{background:var(--card);border-radius:14px;padding:18px;box-shadow:none}
  .card + .card{margin-top:14px}
  .card h2{font-size:17px;margin:0 0 10px}
  .top{display:flex;align-items:center;justify-content:space-between;gap:10px;flex-wrap:wrap;margin-bottom:14px}
  .top .brand{font-size:24px}
  .tr{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
  .bal{display:flex;align-items:center;gap:7px;background:#211d12;border:1px solid #6b5520;border-radius:999px;padding:5px 14px 5px 6px;font-weight:900;color:var(--gold);font-size:15px;font-variant-numeric:tabular-nums}
  .coin{display:inline-block;width:20px;height:20px;border-radius:50%;flex:none;background:radial-gradient(circle at 35% 30%,#fff3c4,#ffcf5c 45%,#b9821c);box-shadow:0 0 0 1px #7d5f1e,inset 0 -2px 2px #0003;vertical-align:-4px}
  .coin.s{width:15px;height:15px;vertical-align:-2px}
  .chip2{display:flex;align-items:center;gap:7px;background:var(--card);border:1px solid var(--line);border-radius:999px;padding:4px 12px 4px 4px;font-weight:700;font-size:14px}
  .chip2 .av{width:26px;height:26px;border-radius:50%;font-size:13px}
  .lk{color:var(--muted);text-decoration:none;font-size:14px;font-weight:600;padding:6px 10px;border-radius:8px;cursor:pointer}
  .lk:hover{color:var(--text);background:var(--card)}
  #nav{display:grid;grid-template-columns:repeat(8,1fr);gap:6px;margin-bottom:14px}
  #nav button{position:relative;background:var(--card);border:1px solid var(--line);color:var(--muted);font-size:13.5px;font-weight:800;padding:11px 2px;border-radius:10px;cursor:pointer}
  #nav button:hover{color:var(--text)}
  #nav button.on{background:linear-gradient(180deg,#2b3346,#222839);color:var(--text);border-color:var(--gold);box-shadow:0 0 0 1px #ffcf5c55}
  #nav button .n{position:absolute;top:-6px;right:-4px;background:var(--err);color:#fff;border-radius:9px;font-size:11px;font-weight:900;padding:0 6px;line-height:1.6}
  #nav button .s2{display:block;font-size:10px;color:var(--gold);font-weight:700;margin-top:1px}
  section{display:none} section.on{display:block}
  .row2{display:grid;grid-template-columns:1fr 1fr;gap:14px;align-items:start}
  .muted{color:var(--muted);font-size:13px}
  .in{width:100%;background:#12141a;border:1px solid var(--line);border-radius:10px;color:var(--text);padding:11px 12px;font-size:16px;outline:none}
  .in:focus{border-color:var(--gold)}
  .b{border:0;border-radius:10px;padding:12px 16px;font-size:15px;font-weight:800;cursor:pointer;color:#fff}
  .b:disabled{opacity:.45;cursor:not-allowed}
  .b.go{width:100%;margin-top:10px;background:var(--ok);color:#0c2417;font-size:17px}
  .b.blue{background:var(--blue);color:#06203d}
  .b.gray{background:#3a4155;color:#fff}
  .b.gold{background:linear-gradient(180deg,#ffe9a8,#e8bf58);color:#3d2c05;border-bottom:3px solid #a8842f}
  .chips{display:flex;gap:6px;margin-top:8px;flex-wrap:wrap}
  .chips button{flex:1;min-width:60px;background:#232735;border:1px solid var(--line);color:#fff;font-size:13px;font-weight:700;padding:9px 0;border-radius:9px;cursor:pointer}
  .chips button.on{border-color:var(--gold);color:var(--gold);box-shadow:0 0 0 1px #ffcf5c66}
  /* ho so */
  .prof{display:flex;align-items:center;gap:16px;flex-wrap:wrap}
  .prof .av{width:66px;height:66px;border-radius:16px;font-size:30px}
  .prof .nm{font-size:22px;font-weight:900;line-height:1.2}
  .sub{color:var(--muted);font-size:13.5px;margin-top:2px}
  .lv{margin-top:16px}
  .lv .r{display:flex;justify-content:space-between;font-size:13px;color:var(--muted);margin-bottom:6px} .lv .r b{color:var(--text)}
  .bar{height:9px;border-radius:999px;background:#12141a;border:1px solid var(--line);overflow:hidden}
  .bar i{display:block;height:100%;background:linear-gradient(90deg,#ffcf5c,#ffa53a)}
  .stats{display:grid;grid-template-columns:repeat(5,1fr);gap:10px;margin-top:16px}
  .stat{background:#12141a;border:1px solid var(--line);border-radius:12px;padding:11px 12px}
  .stat span{display:block;color:var(--muted);font-size:12px}
  .stat b{display:block;font-size:18px;margin-top:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;font-variant-numeric:tabular-nums}
  .stat b.g{color:var(--gold)}
  .kv{display:grid;grid-template-columns:1fr 1fr;gap:4px 22px;margin-top:14px;font-size:14px}
  .kv div{display:flex;justify-content:space-between;gap:12px;padding:7px 0;border-bottom:1px dashed var(--line)}
  .kv span{color:var(--muted)}
  .dot{display:inline-block;width:8px;height:8px;border-radius:50%;background:var(--ok);margin-right:5px}
  .dot.off{background:#56688a}
  .tiles{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-top:14px}
  .tile{background:#12141a;border:1px solid var(--line);border-radius:12px;padding:14px;cursor:pointer;text-align:left;color:var(--text)}
  .tile:hover{border-color:var(--gold)}
  .tile b{display:block;font-size:15px} .tile span{color:var(--muted);font-size:12.5px}
  /* bang lich su */
  .ls{width:100%;border-collapse:collapse;font-size:13.5px}
  .ls td{padding:8px 4px;border-bottom:1px solid var(--line)}
  .ls .p{color:var(--ok);font-weight:800;text-align:right;font-variant-numeric:tabular-nums}
  .ls .m{color:var(--err);font-weight:800;text-align:right;font-variant-numeric:tabular-nums}
  .ls .t{color:var(--muted);white-space:nowrap}
  .empty{text-align:center;padding:28px 10px;color:var(--muted)}
  .empty b{display:block;color:var(--text);font-size:17px;margin-bottom:6px}
  /* tai xiu (theo TLBB) */
  #stage{position:relative;height:230px;border-radius:12px;background:radial-gradient(ellipse at center,#242424 0%,#080808 100%);border:1px solid #3a3a3a;overflow:hidden;touch-action:none;user-select:none}
  #diceRow{position:absolute;inset:0;display:grid;grid-template-columns:repeat(2,58px);grid-auto-rows:58px;gap:7px;align-content:center;justify-content:center}
  #diceRow .die:first-child{grid-column:1 / span 2}
  #diceRow .die{justify-self:center;align-self:center}
  .die{width:58px;height:58px;background:linear-gradient(160deg,#e0463a 0%,#c0271c 55%,#9c1b13 100%);border:1px solid #ff8b7a44;border-radius:12px;position:relative;box-shadow:0 3px 10px #000a,inset 0 1px 2px #ffffff33}
  .pip{position:absolute;width:12px;height:12px;border-radius:50%;background:#fff;box-shadow:0 1px 2px #0006;transform:translate(-50%,-50%)}
  #paper{position:absolute;left:50%;top:50%;width:190px;height:190px;margin:-95px 0 0 -95px;user-select:none;touch-action:none;will-change:transform;z-index:2}
  #paper img{width:100%;height:100%;object-fit:contain;pointer-events:none;-webkit-user-drag:none;filter:drop-shadow(0 8px 18px #000b)}
  #paper.locked img{filter:grayscale(.7) brightness(.55)}
  #paper.open{cursor:grab} #paper.open:active{cursor:grabbing}
  #paper.open img{animation:chenIdle 1.8s ease-in-out infinite}
  @@keyframes chenIdle{0%,100%{transform:translateY(0) rotate(0)}50%{transform:translateY(-3px) rotate(-1.5deg)}}
  #sumBadge{position:absolute;left:50%;bottom:8px;transform:translateX(-50%);background:#000a;border-radius:8px;padding:3px 12px;font-weight:800;font-size:15px;white-space:nowrap;display:none;z-index:3}
  #stageCap{margin-top:8px;font-size:13px;color:var(--muted);text-align:center}
  .cuas{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:12px}
  .cbtn{padding:12px 0 10px;font-size:22px;font-weight:900;letter-spacing:.5px;color:#221c10;text-shadow:0 1px 0 #fff9;cursor:pointer;
    background:linear-gradient(180deg,#fbf7ea 0%,#f0e9d2 55%,#ddd2b0 100%);border:1px solid #b3a67f;border-bottom:5px solid #94865e;border-radius:10px}
  .cbtn small{display:block;font-size:13px;font-weight:800;letter-spacing:0;margin-top:1px}
  .cbtn.tai,.cbtn.tai small{color:#a32626} .cbtn.xiu,.cbtn.xiu small{color:#1d4f8f}
  .cbtn.sel{border-color:var(--gold);border-bottom-width:2px;transform:translateY(3px);box-shadow:0 0 0 3px var(--gold),0 0 16px #ffcf5c88}
  .hrow{display:flex;align-items:center;gap:8px;padding:6px 0;border-bottom:1px solid var(--line);font-size:13px}
  .hrow .dd{display:flex;gap:3px}
  .mdie{display:inline-block;width:17px;height:17px;background:#f4f1e8;border-radius:4px;position:relative}
  .mdie .p{position:absolute;width:3.4px;height:3.4px;border-radius:50%;background:#c0392b;transform:translate(-50%,-50%)}
  .hrow .k{font-weight:800;flex:1} .hrow .k.t{color:#ff7b86} .hrow .k.x{color:#7db4ff} .hrow .k.b{color:var(--gold)}
  .hrow .net{font-weight:800;font-variant-numeric:tabular-nums} .net.w{color:var(--ok)} .net.l{color:var(--err)}
  #winpop{position:fixed;left:50%;top:38%;transform:translate(-50%,-50%);font-size:46px;font-weight:900;pointer-events:none;opacity:0;z-index:98;text-shadow:0 2px 14px #000c}
  #winpop.show{animation:winfloat 2.8s ease-out forwards}
  @@keyframes winfloat{0%{opacity:0;transform:translate(-50%,-30%) scale(.5)}12%{opacity:1;transform:translate(-50%,-50%) scale(1.18)}25%{transform:translate(-50%,-52%) scale(1)}70%{opacity:1}100%{opacity:0;transform:translate(-50%,-100%) scale(.9)}}
  /* do min (theo TLBB) */
  #mstage{display:grid;grid-template-columns:54px 1fr 54px;gap:8px;margin-top:6px}
  .mside{display:flex;flex-direction:column;align-items:center;justify-content:center;gap:3px;border-radius:12px;background:#0d1226;border:1px solid #2b3557;padding:8px 0}
  .mside .ic{font-size:19px;line-height:1}.mside .n{font-size:20px;font-weight:900}
  .mside.coinS .n{color:var(--gold)}.mside.bomb .n{color:#ff8a8a}
  .mgrid{display:grid;grid-template-columns:repeat(5,1fr);gap:7px;max-width:420px;margin:0 auto;width:100%}
  .mtile{aspect-ratio:1;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:24px;font-weight:800;user-select:none;
    background:linear-gradient(180deg,#2f7fd6,#215aa8);border:1px solid #4b9ae8;border-bottom:4px solid #14346a;color:#bcdcff;cursor:pointer;transition:transform .08s}
  .mtile.can:active{transform:translateY(2px);border-bottom-width:2px}
  .mtile.dead{background:linear-gradient(180deg,#232a3d,#1a2030);border-color:#2c3450;border-bottom-color:#141824;color:#4a5372;cursor:default}
  .mtile.coin{background:linear-gradient(180deg,#ffe9a8,#e8bf58);border-color:#a8842f;border-bottom-color:#7d5f1e;cursor:default;animation:coinPop .28s ease-out}
  .mtile.boom{background:linear-gradient(180deg,#e05555,#8e2020);border-color:#ff9a9a;border-bottom-color:#5d1414;color:#fff;cursor:default;animation:boomPop .32s ease-out}
  .mtile.shown{background:linear-gradient(180deg,#3a2030,#2a1622);border-color:#6b3a4a;border-bottom-color:#1e1017;color:#c46b7b;cursor:default}
  @@keyframes coinPop{0%{transform:scale(.55)}60%{transform:scale(1.14)}100%{transform:scale(1)}}
  @@keyframes boomPop{0%{transform:scale(.5) rotate(-20deg)}70%{transform:scale(1.28) rotate(8deg)}100%{transform:scale(1)}}
  .mins{display:flex;gap:6px;flex-wrap:wrap;margin-top:8px}
  .mins button{flex:1;min-width:46px;background:#232735;border:1px solid var(--line);color:#fff;font-weight:800;padding:8px 0;border-radius:9px;cursor:pointer}
  .mins button.on{border-color:#ff8a8a;color:#ff8a8a}
  .hsline{display:flex;justify-content:space-between;margin-top:10px;font-size:14px;color:var(--muted)} .hsline b{color:var(--gold)}
  /* lat the: 21 la Gunny (3 hang x 7), anh tach tu gameover.swf */
  .ltList{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px}
  .ltList button{background:#12141a;border:1px solid var(--line);color:var(--text);border-radius:10px;padding:9px 12px;cursor:pointer;text-align:left;font-size:13px}
  .ltList button b{display:block;font-size:14px} .ltList button span{color:var(--muted);font-size:12px}
  .ltList button.on{border-color:var(--gold);box-shadow:0 0 0 1px #ffcf5c66}
  .board{position:relative;border-radius:14px;padding:16px;background:radial-gradient(ellipse at center,#3a2a14 0%,#1a120a 75%);border:2px solid #6b4a1e;box-shadow:inset 0 0 40px #000a}
  .bhd{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;gap:10px;flex-wrap:wrap}
  .bhd b{font-size:18px;color:#ffe2a0} .bhd .luot{background:#2a1d0c;border:1px solid #a8842f;color:var(--gold);border-radius:999px;padding:4px 14px;font-weight:900}
  .cards{display:grid;grid-template-columns:repeat(7,1fr);gap:10px}
  .cd{aspect-ratio:106/153;perspective:700px;cursor:pointer}
  .cd .in2{position:relative;width:100%;height:100%;transition:transform .55s cubic-bezier(.3,1.3,.5,1);transform-style:preserve-3d}
  .cd.up .in2{transform:rotateY(180deg)}
  .cd .f{position:absolute;inset:0;backface-visibility:hidden;-webkit-backface-visibility:hidden;border-radius:8px;background-size:100% 100%}
  .cd .bk{background-image:url(/img/the-up.png)}
  .cd:not(.up):not(.lock):hover .bk{filter:brightness(1.18);box-shadow:0 0 0 2px #ffe08a,0 0 18px #ffcf5c99}
  .cd .fr{transform:rotateY(180deg);background-image:url(/img/the-ngua.png);display:flex;flex-direction:column;align-items:center;justify-content:center;padding:14% 8% 20%;text-align:center}
  .cd .fr.vip{background-image:url(/img/the-vip.png)}
  .cd .fr img{width:52%;aspect-ratio:1;object-fit:contain;border-radius:6px;background:#0003}
  .cd .fr .xu{width:46%;aspect-ratio:1;border-radius:50%;background:radial-gradient(circle at 35% 30%,#fff3c4,#ffcf5c 45%,#b9821c);box-shadow:0 0 0 2px #7d5f1e}
  .cd .fr .t{position:absolute;left:6%;right:6%;bottom:5%;font-size:10.5px;font-weight:800;color:#fff;line-height:1.15;text-shadow:0 1px 2px #000;max-height:2.4em;overflow:hidden}
  .cd .fr .h{font-size:9.5px;color:#5a3a12;font-weight:700;margin-top:3px}
  .cd.mine .fr{box-shadow:0 0 0 3px #ffe08a,0 0 22px #ffcf5ccc}
  .cd.miss{cursor:default} .cd.miss .fr{filter:grayscale(.55) brightness(.7)}
  .cd.lock{cursor:default}
  .ltNote{margin-top:12px;color:#d9c49a;font-size:13px;text-align:center}
  /* ruong */
  .rgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(150px,1fr));gap:10px}
  .ri{display:flex;gap:10px;align-items:center;background:#12141a;border:1px solid var(--line);border-radius:12px;padding:10px;cursor:pointer;position:relative}
  .ri.on{border-color:var(--gold);box-shadow:0 0 0 1px #ffcf5c66}
  .ri .ic{width:48px;height:48px;border-radius:9px;border:2px solid;background:#0d1220;flex:none;position:relative}
  .ri .ic img{width:100%;height:100%;object-fit:contain}
  .ri .ic b{position:absolute;right:-2px;bottom:-2px;background:#000c;color:#fff;font-size:11px;border-radius:5px;padding:0 4px}
  .ri .tn{font-size:13px;font-weight:700;line-height:1.25}
  .ri .sn{font-size:11.5px;color:var(--muted)}
  .ri .ck{position:absolute;top:6px;right:8px;width:16px;height:16px;border-radius:4px;border:1px solid var(--line)}
  .ri.on .ck{background:var(--gold);border-color:var(--gold)}
  /* popup xac nhan (gConfirm theo TLBB) + toast */
  #gmodal{position:fixed;inset:0;background:rgba(0,0,0,.65);display:flex;align-items:center;justify-content:center;z-index:120;padding:16px}
  #gmodal.hidden{display:none}
  #gmBox{background:var(--card);border:1px solid var(--line);border-radius:14px;padding:22px;width:380px;max-width:100%;box-shadow:0 12px 48px rgba(0,0,0,.6);animation:gmpop .15s ease}
  @@keyframes gmpop{from{transform:scale(.92);opacity:0}to{transform:scale(1);opacity:1}}
  #gmMsg{font-size:15px;line-height:1.55;margin-bottom:20px}
  #gmActs{display:flex;gap:10px;justify-content:flex-end}
  #toast{position:fixed;left:50%;bottom:24px;transform:translateX(-50%);background:#000d;color:#fff;border:1px solid #2a3146;padding:10px 18px;border-radius:10px;font-size:14px;opacity:0;transition:opacity .25s;pointer-events:none;max-width:90%;z-index:200}
  #toast.show{opacity:1} #toast.err{background:#3a0f14;border-color:#e5484d;color:#ffd6d9;font-weight:700}
  .msg{margin-top:12px}
  @@media (max-width:900px){
    #nav{grid-template-columns:repeat(4,1fr)} .row2{grid-template-columns:1fr} .stats{grid-template-columns:repeat(2,1fr)} .kv{grid-template-columns:1fr}
    .tiles{grid-template-columns:1fr 1fr} .cards{gap:6px} .cd .fr .t{font-size:9px}
  }
  @@media (max-width:560px){ .cards{grid-template-columns:repeat(4,1fr)} }
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <a class="brand" href="/">GUNNYNETCO4</a>
    <div class="tr">
      <div class="bal" title="Xu web: dùng chơi mini game, đổi sang xu game ở mục Ví xu"><span class="coin"></span><span id="balTop">0</span></div>
      <div class="chip2"><div class="av" id="c_av">G</div><span id="c_name">...</span></div>
      <a class="lk" href="/">Trang chủ</a>
      <a class="lk" id="logout">Đăng xuất</a>
    </div>
  </div>

  <div id="nav">
    <button data-sec="hoso" class="on">Hồ sơ</button>
    <button data-sec="vi">Ví xu</button>
    <button data-sec="diemdanh">Điểm danh</button>
    <button data-sec="latthe">Lật thẻ<span class="n" id="ltN" style="display:none"></span></button>
    <button data-sec="taixiu">Tài xỉu</button>
    <button data-sec="domin">Dò mìn</button>
    <button data-sec="ruong">Rương<span class="n" id="rgN" style="display:none"></span></button>
    <button data-sec="ghep">Ghép đồ<span class="s2">sắp có</span></button>
  </div>

  <!-- ================= HO SO ================= -->
  <section id="sec-hoso" class="on">
    <div class="card" id="profCard"><div class="muted">Đang tải hồ sơ...</div></div>
    <div class="card">
      <h2>Hôm nay chơi gì?</h2>
      <div class="tiles">
        <button class="tile" data-go="diemdanh"><b>Điểm danh</b><span id="tDd">Nhận quà mỗi ngày</span></button>
        <button class="tile" data-go="latthe"><b>Lật thẻ phó bản</b><span id="tLt">Đánh xong boss trong game là có lượt</span></button>
        <button class="tile" data-go="ruong"><b>Rương web</b><span id="tRg">Đồ lật thẻ, rút vào game</span></button>
        <button class="tile" data-go="taixiu"><b>Tài xỉu</b><span>Cược xu web, thắng x<span id="tHs">1,95</span></span></button>
        <button class="tile" data-go="domin"><b>Dò mìn</b><span>Mở ô an toàn, rút tiền bất cứ lúc nào</span></button>
        <button class="tile" data-go="vi"><b>Ví xu</b><span>Đổi xu web sang xu game</span></button>
      </div>
    </div>
  </section>

  <!-- ================= VI XU ================= -->
  <section id="sec-vi">
    <div class="row2">
      <div class="card">
        <h2>Ví xu web</h2>
        <div style="font-size:34px;font-weight:900;color:var(--gold);display:flex;align-items:center;gap:10px"><span class="coin" style="width:30px;height:30px"></span><span id="viBal">0</span></div>
        <div class="muted" style="margin-top:6px">Xu web kiếm từ điểm danh, lật thẻ phó bản, mini game. Đổi sang xu trong game bất cứ lúc nào (đang online cũng nhận).</div>
        <div style="margin-top:14px"><label class="muted">Số xu đổi sang game (600 đến 1.000.000)</label>
          <input class="in" id="viCoin" type="number" min="600" max="1000000" step="100" placeholder="vd: 10000" style="margin-top:6px"></div>
        <button class="b go" id="viBtn">ĐỔI SANG XU GAME</button>
        <div class="msg" id="viMsg"></div>
      </div>
      <div class="card"><h2>Lịch sử xu web</h2><table class="ls" id="viLs"></table></div>
    </div>
  </section>

  <!-- ================= DIEM DANH ================= -->
  <section id="sec-diemdanh">
    <div class="card">
      <div style="display:flex;justify-content:space-between;align-items:baseline;margin-bottom:12px"><h2 id="dd_title" style="margin:0">Điểm danh</h2><b id="dd_cnt" style="color:var(--gold)"></b></div>
      <div class="ddgrid" id="dd_grid"></div>
      <div class="ddq" id="dd_daily"></div>
      <div class="ddmoc" id="dd_moc"></div>
      <button class="b go" id="dd_btn" disabled>ĐIỂM DANH HÔM NAY</button>
      <div class="msg" id="dd_msg"></div>
      <div class="note">Đồ gửi vào <b>hộp thư trong game</b>, xu web cộng thẳng vào ví. Mỗi ngày 1 lần, sang tháng mới đếm lại.</div>
    </div>
  </section>

  <!-- ================= LAT THE ================= -->
  <section id="sec-latthe">
    <div class="card">
      <h2>Lật thẻ sau phó bản</h2>
      <div class="muted" id="ltInfo" style="margin-bottom:12px">Đánh xong <b>boss ải cuối</b> của phó bản trong game là có 1 lượt lật ở đây. Mỗi lượt lật <b>3 lá</b>, quà vào <b>Rương web</b> hoặc ví xu.</div>
      <div class="ltList" id="ltList"></div>
      <div id="ltBoard"></div>
    </div>
  </section>

  <!-- ================= TAI XIU ================= -->
  <section id="sec-taixiu">
    <div class="row2">
      <div class="card">
        <h2>Tài xỉu</h2>
        <div id="stage">
          <div id="diceRow"></div>
          <div id="paper" class="locked"><img src="/img/chen.png?v=1" alt="" draggable="false"></div>
          <div id="sumBadge"></div>
        </div>
        <div id="stageCap">Chọn cửa, chọn tiền rồi đặt cược</div>
        <div class="cuas">
          <button class="cbtn tai" data-cua="tai">TÀI<small>11 đến 17</small></button>
          <button class="cbtn xiu" data-cua="xiu">XỈU<small>4 đến 10</small></button>
        </div>
        <div class="chips" id="txChips"></div>
        <input class="in" id="txCuoc" type="number" min="100" placeholder="Số xu cược" style="margin-top:8px">
        <button class="b go" id="txBtn">ĐẶT CƯỢC</button>
        <div class="muted" style="margin-top:8px" id="txLuat"></div>
      </div>
      <div class="card"><h2>20 ván gần nhất</h2><div id="txLs"></div></div>
    </div>
  </section>

  <!-- ================= DO MIN ================= -->
  <section id="sec-domin">
    <div class="row2">
      <div class="card">
        <h2>Dò mìn</h2>
        <div id="mstage">
          <div class="mside coinS"><div class="ic"><span class="coin s"></span></div><div class="n" id="mSafe">0</div></div>
          <div class="mgrid" id="mGrid"></div>
          <div class="mside bomb"><div class="ic">💣</div><div class="n" id="mBomb">3</div></div>
        </div>
        <div class="hsline"><span>Hệ số: <b id="mHs">x0</b></span><span>Ô tiếp: <b id="mHsN">-</b></span></div>
        <button class="b gold" id="mRut" style="width:100%;margin-top:10px;display:none"></button>
      </div>
      <div class="card" id="mSetup">
        <h2>Bắt đầu ván</h2>
        <label class="muted">Số mìn (càng nhiều mìn hệ số càng cao)</label>
        <div class="mins" id="mMins"></div>
        <label class="muted" style="display:block;margin-top:12px">Tiền cược</label>
        <div class="chips" id="mChips"></div>
        <input class="in" id="mCuoc" type="number" min="100" placeholder="Số xu cược" style="margin-top:8px">
        <button class="b go" id="mBtn">BẮT ĐẦU</button>
        <div class="muted" style="margin-top:10px">25 ô, mỗi ô an toàn mở ra nhân hệ số. Bấm <b>Nhận</b> để rút tiền bất cứ lúc nào, trúng mìn mất cược.</div>
      </div>
    </div>
  </section>

  <!-- ================= RUONG ================= -->
  <section id="sec-ruong">
    <div class="card">
      <div style="display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap;margin-bottom:12px">
        <h2 style="margin:0">Rương web</h2>
        <button class="b blue" id="rgBtn" disabled>Rút vào game (0/5)</button>
      </div>
      <div class="muted" style="margin-bottom:12px">Chọn tối đa <b>5 món</b> mỗi lần, đồ gửi vào <b>hộp thư trong game</b> (đang online cũng nhận).</div>
      <div class="rgrid" id="rgGrid"></div>
    </div>
  </section>

  <section id="sec-ghep"><div class="card empty"><b>Ghép đồ</b>Ghép nhiều món trong rương thành món xịn hơn. Tính năng đang phát triển.</div></section>

  <div class="foot">gunny.netco4.click &middot; server test</div>
</div>

<div id="winpop"></div>
<div id="toast"></div>
<div id="gmodal" class="hidden"><div id="gmBox"><div id="gmMsg"></div><div id="gmActs"><button class="b gray" id="gmCancel">Hủy</button><button class="b blue" id="gmOk">Đồng ý</button></div></div></div>

<script>
(function(){
  var token=''; try{ token=localStorage.getItem('gn_token')||''; }catch(e){}
  if(!token){ location.replace('/'); return; }
  function logout(){ try{ localStorage.removeItem('gn_token'); localStorage.removeItem('gn_user'); }catch(e){} location.href='/'; }
  document.getElementById('logout').addEventListener('click',logout);
  try{ var u=JSON.parse(localStorage.getItem('gn_user')||'{}'), nm=u.UserName||'Người chơi';
    document.getElementById('c_name').textContent=nm; document.getElementById('c_av').textContent=(nm[0]||'G').toUpperCase(); }catch(e){}

  function $(id){ return document.getElementById(id); }
  function api(url,data){
    var body=new URLSearchParams(); Object.keys(data||{}).forEach(function(k){ var v=data[k]; if(Array.isArray(v)) v.forEach(function(x){ body.append(k+'[]',x); }); else body.append(k,v); });
    if(!body.toString()) body.append('z','0');
    return fetch(url,{method:'POST',headers:{'Accept':'application/json','Authorization':'Bearer '+token},body:body})
      .then(function(r){ if(r.status===403){ logout(); return {success:false,message:'Phiên đăng nhập đã hết.'}; }
        return r.json().catch(function(){ return {success:false,message:'Lỗi máy chủ, thử lại sau.'}; }); });
  }
  function fmt(x){ return (Number(x)||0).toLocaleString('vi-VN'); }
  function esc(s){ return String(s==null?'':s).replace(/[&<>"]/g,function(c){ return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]; }); }
  var tt; function toast(t,err){ var e=$('toast'); e.textContent=t; e.className='show'+(err?' err':''); clearTimeout(tt); tt=setTimeout(function(){ e.className=err?'err':''; },2800); }
  function gConfirm(msg){ return new Promise(function(res){ $('gmMsg').innerHTML=msg; $('gmodal').classList.remove('hidden');
    function done(v){ $('gmodal').classList.add('hidden'); $('gmOk').onclick=$('gmCancel').onclick=null; res(v); }
    $('gmOk').onclick=function(){ done(true); }; $('gmCancel').onclick=function(){ done(false); }; }); }
  function setBal(v){ if(v==null) return; $('balTop').textContent=fmt(v); $('viBal').textContent=fmt(v); }
  function winpop(n){ var e=$('winpop'); e.textContent=(n>=0?'+':'')+fmt(n); e.style.color=n>0?'#3ddc84':'#ff5d5d'; e.className=''; void e.offsetWidth; e.className='show'; }

  // ---------- dieu huong ----------
  var loaded={};
  function go(sec){
    if(!$('sec-'+sec)) sec='hoso';
    document.querySelectorAll('section').forEach(function(s){ s.classList.toggle('on', s.id==='sec-'+sec); });
    document.querySelectorAll('#nav button').forEach(function(a){ a.classList.toggle('on', a.dataset.sec===sec); });
    if(location.hash!=='#'+sec) history.replaceState(null,'','#'+sec);
    var f={vi:loadVi,diemdanh:ddLoad,latthe:ltLoad,taixiu:txLoad,domin:mLoad,ruong:rgLoad}[sec];
    if(f && (sec==='latthe'||sec==='ruong'||sec==='vi'||!loaded[sec])){ loaded[sec]=1; f(); }
    window.scrollTo(0,0);
  }
  document.querySelectorAll('[data-sec],[data-go]').forEach(function(a){ a.addEventListener('click',function(){ go(a.dataset.sec||a.dataset.go); }); });

  // ---------- ho so ----------
  api('/api/hoso').then(function(d){
    var box=$('profCard');
    if(!d||!d.success){ box.innerHTML='<div class="msg err">'+esc((d&&d.message)||'Không tải được hồ sơ.')+'</div>'; return; }
    setBal(d.data.xuWeb);
    var c=d.data.nhanVat, acc=d.data.taiKhoan;
    if(!c){ box.innerHTML='<div class="empty"><b>Chưa có nhân vật</b>Tài khoản '+esc(acc)+' chưa tạo nhân vật. Tải game ở trang chủ, đăng nhập và tạo nhân vật rồi quay lại.</div>'; return; }
    var rate=c.tran?Math.round(100*c.thang/c.tran):0, max=c.cap>=c.capToiDa;
    box.innerHTML='<div class="prof"><div class="av">'+esc((c.ten[0]||'G').toUpperCase())+'</div><div><div class="nm">'+esc(c.ten)+'</div>'
      +'<div class="sub">Tài khoản '+esc(acc)+' · '+esc(c.gioiTinh)+' · <span class="dot'+(c.online?'':' off')+'"></span>'+(c.online?'Đang trong game':'Ngoại tuyến')+'</div></div></div>'
      +'<div class="lv"><div class="r"><span>Cấp <b>'+c.cap+'</b> / '+c.capToiDa+'</span><span>'+(max?'Đã max cấp':c.phanTramCap+'% lên cấp '+(c.cap+1))+'</span></div><div class="bar"><i style="width:'+(max?100:c.phanTramCap)+'%"></i></div></div>'
      +'<div class="stats"><div class="stat"><span>Lực chiến</span><b class="g">'+fmt(c.lucChien)+'</b></div><div class="stat"><span>Vàng</span><b>'+fmt(c.vang)+'</b></div>'
      +'<div class="stat"><span>Xu game</span><b>'+fmt(c.xu)+'</b></div><div class="stat"><span>Xu khóa</span><b>'+fmt(c.xuKhoa)+'</b></div><div class="stat"><span>Xu web</span><b class="g">'+fmt(d.data.xuWeb)+'</b></div></div>'
      +'<div class="kv"><div><span>Trận thắng</span><b>'+fmt(c.thang)+' / '+fmt(c.tran)+' ('+rate+'%)</b></div><div><span>Bang hội</span><b>'+esc(c.bang||'Chưa vào bang')+'</b></div>'
      +'<div><span>Công hiến</span><b>'+fmt(c.congHien)+'</b></div><div><span>Điểm thành tích</span><b>'+fmt(c.thanhTich)+'</b></div>'
      +'<div><span>Ngày tạo nhân vật</span><b>'+esc(c.ngayTao)+'</b></div><div><span>Vào game lần cuối</span><b>'+esc(c.lanCuoi)+'</b></div></div>'
      +(c.online?'<div class="note">Đang trong game: vàng, xu game ở đây có thể chậm vài phút so với trong game.</div>':'');
  });

  // ---------- vi ----------
  var VI={};
  var LOAI={taixiu:'Tài xỉu',domin:'Dò mìn',latthe:'Lật thẻ',diemdanh:'Điểm danh',admin:'Admin',doixu:'Đổi sang game'};
  function loadVi(){
    api('/api/vi').then(function(d){
      if(!d||!d.success) return;
      VI=d.data; setBal(d.data.soDu);
      var ls=d.data.lichSu||[];
      $('viLs').innerHTML=ls.length?ls.map(function(x){ return '<tr><td class="t">'+esc(x.tg.slice(5))+'</td><td>'+esc(LOAI[x.loai]||x.loai)+'<div class="muted">'+esc(x.gc||'')+'</div></td><td class="'+(x.d>=0?'p':'m')+'">'+(x.d>=0?'+':'')+fmt(x.d)+'</td></tr>'; }).join('')
        :'<tr><td class="empty">Chưa có giao dịch.</td></tr>';
    });
  }
  $('viBtn').addEventListener('click',function(){
    var n=parseInt($('viCoin').value,10)||0, m=$('viMsg');
    if(n<600||n>1000000){ m.className='msg err'; m.textContent='Đổi từ 600 đến 1.000.000 xu.'; return; }
    if(!VI.playerId){ m.className='msg err'; m.textContent='Tài khoản chưa có nhân vật để nhận xu.'; return; }
    gConfirm('Đổi <b>'+fmt(n)+'</b> xu web sang xu trong game?').then(function(ok){
      if(!ok) return;
      $('viBtn').disabled=true;
      api('/api/convertCoin',{server_id:VI.serverId,player_id:VI.playerId,coin:n}).then(function(d){
        m.className='msg '+(d&&d.success?'ok':'err'); m.textContent=(d&&d.message)||'Có lỗi xảy ra.'; loadVi();
      }).finally(function(){ $('viBtn').disabled=false; });
    });
  });

  // ---------- diem danh ----------
  var ddMsg=$('dd_msg'), ddBtn=$('dd_btn');
  function ddLoad(){
    api('/api/diemdanh/info').then(function(r){
      if(!r||!r.success){ ddBtn.disabled=true; ddMsg.className='msg err'; ddMsg.textContent=(r&&r.message)||'Không tải được điểm danh.'; return; }
      var d=r.data;
      $('dd_title').textContent='Điểm danh tháng '+d.thang; $('dd_cnt').textContent=d.ngay.length+' / '+d.songay+' ngày';
      var g=$('dd_grid'); g.innerHTML='';
      for(var i=1;i<=d.songay;i++){ var c=document.createElement('div'); c.textContent=i;
        if(d.ngay.indexOf(i)>=0) c.className='done'; else if(i===d.homnay) c.className='today'; else if(i<d.homnay) c.className='miss'; g.appendChild(c); }
      $('dd_daily').innerHTML=d.quangay?'Mỗi ngày: <b>'+esc(d.quangay)+'</b>':'';
      $('dd_moc').innerHTML=(d.moc||[]).map(function(x){ return '<div class="'+(x.dat?'ok':'')+'"><span>'+(x.dat?'✓ ':'')+'Đủ '+x.moc+' ngày</span><span>'+esc(x.qua)+'</span></div>'; }).join('');
      ddBtn.disabled=!!d.dadiemdanh; ddBtn.textContent=d.dadiemdanh?'HÔM NAY ĐÃ ĐIỂM DANH':'ĐIỂM DANH HÔM NAY';
      $('tDd').textContent=d.dadiemdanh?('Đã điểm danh, tháng này '+d.ngay.length+' ngày'):'Chưa điểm danh hôm nay';
    });
  }
  ddBtn.addEventListener('click',function(){
    ddBtn.disabled=true; ddBtn.textContent='Đang gửi quà...';
    api('/api/diemdanh').then(function(d){
      ddMsg.className='msg '+(d&&d.success?'ok':'err');
      ddMsg.textContent=(d&&d.message||'Có lỗi xảy ra.')+((d&&d.data&&d.data.qua&&d.data.qua.length)?' Nhận: '+d.data.qua.join('; ')+'.':'');
      ddLoad(); refreshBal();
    });
  });
  function refreshBal(){ api('/api/vi').then(function(d){ if(d&&d.success){ VI=d.data; setBal(d.data.soDu); } }); }

  // ---------- lat the ----------
  var LT={ds:[],cur:null,busy:false};
  function ltLoad(){
    api('/api/latthe').then(function(r){
      if(!r||!r.success){ $('ltList').innerHTML=''; $('ltBoard').innerHTML='<div class="empty">'+esc((r&&r.message)||'Không tải được.')+'</div>'; return; }
      LT.ds=r.data.ds; LT.soLa=r.data.soLa||21; LT.soLat=r.data.soLat||3;
      var n=LT.ds.length; $('ltN').style.display=n?'':'none'; $('ltN').textContent=n;
      $('tLt').textContent=n?('Có '+n+' lượt lật đang chờ!'):'Đánh xong boss trong game là có lượt';
      $('ltInfo').innerHTML='Đánh xong <b>boss ải cuối</b> của phó bản trong game là có 1 lượt lật (mỗi phó bản <b>'+r.data.soLan+' lượt/ngày</b>). Mỗi lượt lật <b>'+LT.soLat+' lá</b>, đồ vào <b>Rương web</b>, xu vào ví.'+(r.data.mo?'':' <b style="color:#ff8a8a">Lật thẻ đang tạm tắt.</b>');
      if(!LT.cur || !LT.ds.some(function(x){ return x.id===LT.cur; })) LT.cur=n?LT.ds[0].id:null;
      ltRenderList(); ltRenderBoard();
    });
  }
  function ltRenderList(){
    $('ltList').innerHTML=LT.ds.map(function(x){ return '<button data-id="'+x.id+'" class="'+(x.id===LT.cur?'on':'')+'"><b>'+esc(x.phoBan)+'</b><span>Thắng lúc '+esc(x.tg.slice(11))+' · đã lật '+Object.keys(x.daLat).length+'/'+LT.soLat+'</span></button>'; }).join('');
    $('ltList').querySelectorAll('button').forEach(function(b){ b.onclick=function(){ LT.cur=+b.dataset.id; ltRenderList(); ltRenderBoard(); }; });
  }
  function faceHtml(c){
    var ic=c.hinh?'<img src="'+esc(c.hinh)+'" alt="" style="border:2px solid '+esc(c.mau)+'">':'<div class="xu"></div>';
    return '<div class="f fr'+(c.hiem?' vip':'')+'">'+ic+(c.han?'<div class="h">'+esc(c.han)+'</div>':'')+'<div class="t">'+esc(c.ten)+'</div></div>';
  }
  function ltRenderBoard(xongData){
    var b=$('ltBoard'), s=LT.ds.filter(function(x){ return x.id===LT.cur; })[0];
    if(!s && !xongData){ b.innerHTML='<div class="empty"><b>Chưa có lượt lật</b>Vào game đánh xong boss ải cuối của một phó bản, rồi quay lại đây.</div>'; return; }
    var sess=xongData||s, lat=sess.daLat||{}, daLat=Object.keys(lat).length, con=LT.soLat-daLat;
    var h='<div class="board"><div class="bhd"><b>'+esc(sess.phoBan)+'</b><span class="luot">Lượt lật: '+Math.max(0,con)+'</span></div><div class="cards">';
    for(var i=0;i<LT.soLa;i++){
      var c=lat[i], all=xongData&&xongData.tatCa?xongData.tatCa[i]:null;
      if(c) h+='<div class="cd up mine" data-o="'+i+'"><div class="in2"><div class="f bk"></div>'+faceHtml(c)+'</div></div>';
      else if(all) h+='<div class="cd up miss" data-o="'+i+'"><div class="in2"><div class="f bk"></div>'+faceHtml(all)+'</div></div>';
      else h+='<div class="cd'+(con<=0?' lock':'')+'" data-o="'+i+'"><div class="in2"><div class="f bk"></div><div class="f fr"></div></div></div>';
    }
    h+='</div><div class="ltNote">'+(xongData?'Đã lật đủ '+LT.soLat+' lá. Các lá mờ là quà bạn đã bỏ lỡ. <button class="b gold" id="ltDone" style="margin-left:8px;padding:7px 14px">Xong</button>':'Chọn '+con+' lá bất kỳ để lật')+'</div></div>';
    b.innerHTML=h;
    if(xongData){ $('ltDone').onclick=function(){ ltLoad(); }; return; }
    b.querySelectorAll('.cd:not(.up):not(.lock)').forEach(function(el){ el.onclick=function(){ ltFlip(sess,+el.dataset.o,el); }; });
  }
  function ltFlip(sess,o,el){
    if(LT.busy) return; LT.busy=true; el.classList.add('lock');
    api('/api/latthe/lat',{id:sess.id,o:o}).then(function(r){
      LT.busy=false;
      if(!r||!r.success){ toast((r&&r.message)||'Có lỗi xảy ra.',true); ltLoad(); return; }
      var d=r.data; setBal(d.soDu);
      el.querySelector('.fr').outerHTML=faceHtml(d.bai); el.classList.add('up','mine');
      sess.daLat[o]=d.bai;
      document.querySelector('#ltBoard .luot').textContent='Lượt lật: '+d.conLai;
      toast('Nhận: '+d.bai.ten);
      if(d.xong){
        // lat du: lat ngua het bai cho biet da bo lo gi
        setTimeout(function(){ ltRenderBoard({phoBan:sess.phoBan,daLat:sess.daLat,tatCa:d.tatCa}); rgCount(); },700);
      }
    });
  }

  // ---------- tai xiu ----------
  var PIPS={1:[[50,50]],2:[[28,28],[72,72]],3:[[26,26],[50,50],[74,74]],4:[[28,28],[72,28],[28,72],[72,72]],5:[[27,27],[73,27],[50,50],[27,73],[73,73]],6:[[28,24],[72,24],[28,50],[72,50],[28,76],[72,76]]};
  function dieHtml(n,mini){ return '<div class="'+(mini?'mdie':'die')+'">'+PIPS[n].map(function(p){ return '<span class="'+(mini?'p':'pip')+'" style="left:'+p[0]+'%;top:'+p[1]+'%"></span>'; }).join('')+'</div>'; }
  var TX={cua:null,chip:1000,busy:false,kq:null};
  var CHIPS=[1000,5000,10000,50000,100000];
  function chipRow(el,inp,st){ el.innerHTML=CHIPS.map(function(v){ return '<button data-v="'+v+'">'+(v>=1000?(v/1000)+'K':v)+'</button>'; }).join('')+'<button data-v="x2">x2</button>';
    el.querySelectorAll('button').forEach(function(b){ b.onclick=function(){ var cur=parseInt(inp.value,10)||0;
      if(b.dataset.v==='x2') inp.value=Math.max(100,cur*2); else { inp.value=b.dataset.v; el.querySelectorAll('button').forEach(function(x){ x.classList.toggle('on',x===b); }); } }; }); }
  chipRow($('txChips'),$('txCuoc')); chipRow($('mChips'),$('mCuoc'));
  $('txCuoc').value=1000; $('mCuoc').value=1000;
  function txDiceIdle(){ $('diceRow').innerHTML=dieHtml(1)+dieHtml(2)+dieHtml(3); }
  txDiceIdle();
  function txLoad(){
    api('/api/taixiu/lichsu').then(function(r){
      if(!r||!r.success) return;
      var hs=String(r.data.heso).replace('.',','); $('tHs').textContent=hs;
      $('txLuat').innerHTML='Thắng nhận <b>x'+hs+'</b> tiền cược. <b>Bão</b> (3 viên giống nhau) thì cả Tài và Xỉu đều thua. Cược '+fmt(r.data.min)+' đến '+fmt(r.data.max)+' xu web.';
      $('txLs').innerHTML=(r.data.ds||[]).map(function(x){ var t=x.xx[0]+x.xx[1]+x.xx[2], bao=x.xx[0]===x.xx[1]&&x.xx[1]===x.xx[2];
        var k=bao?'<span class="k b">BÃO '+t+'</span>':(t>=11?'<span class="k t">TÀI '+t+'</span>':'<span class="k x">XỈU '+t+'</span>');
        var net=x.nhan-x.cuoc;
        return '<div class="hrow"><span class="muted">'+esc(x.tg)+'</span><span class="dd">'+x.xx.map(function(n){ return dieHtml(n,1); }).join('')+'</span>'+k+'<span class="muted">'+(x.cua==='tai'?'Tài':'Xỉu')+'</span><span class="net '+(net>0?'w':'l')+'">'+(net>0?'+':'')+fmt(net)+'</span></div>'; }).join('')||'<div class="empty">Chưa chơi ván nào.</div>';
    });
  }
  document.querySelectorAll('.cbtn').forEach(function(b){ b.onclick=function(){ if(TX.busy) return; TX.cua=b.dataset.cua; document.querySelectorAll('.cbtn').forEach(function(x){ x.classList.toggle('sel',x===b); }); }; });
  // chen: keo ra xa de mo (giong TLBB), hoac bam 2 lan
  (function(){
    var p=$('paper'), sx=0, sy=0, dx=0, dy=0, drag=false;
    function pos(e){ return e.touches?e.touches[0]:e; }
    p.addEventListener('pointerdown',function(e){ if(!p.classList.contains('open')) return; drag=true; sx=e.clientX-dx; sy=e.clientY-dy; p.setPointerCapture(e.pointerId); });
    p.addEventListener('pointermove',function(e){ if(!drag) return; dx=e.clientX-sx; dy=e.clientY-sy; p.style.transform='translate('+dx+'px,'+dy+'px)';
      if(Math.hypot(dx,dy)>110){ drag=false; txReveal(); } });
    p.addEventListener('pointerup',function(){ drag=false; });
    p.addEventListener('dblclick',function(){ if(p.classList.contains('open')) txReveal(); });
    window.txResetPaper=function(){ dx=dy=0; p.style.transition='transform .35s'; p.style.transform=''; setTimeout(function(){ p.style.transition=''; },380); };
  })();
  function txReveal(){
    var p=$('paper'), k=TX.kq; if(!k) return;
    p.classList.remove('open'); p.classList.add('locked'); p.style.transition='transform .4s, opacity .4s'; p.style.opacity='0';
    var t=k.tong, s=$('sumBadge');
    s.innerHTML=k.kq==='bao'?'<span style="color:#ffcf5c">BÃO '+t+'</span>':(k.kq==='tai'?'<span style="color:#ff7b86">TÀI '+t+'</span>':'<span style="color:#7db4ff">XỈU '+t+'</span>');
    s.style.display='block';
    var net=k.nhan-k.cuoc; winpop(net); setBal(k.soDu);
    $('stageCap').textContent=k.nhan>0?('Thắng '+fmt(k.nhan)+' xu web!'):('Thua '+fmt(k.cuoc)+' xu web'+(k.kq==='bao'?' (bão)':''));
    TX.kq=null; TX.busy=false; $('txBtn').disabled=false; txLoad();
  }
  $('txBtn').addEventListener('click',function(){
    if(TX.busy) return;
    if(!TX.cua){ toast('Chọn Tài hoặc Xỉu trước.',true); return; }
    var c=parseInt($('txCuoc').value,10)||0; if(c<=0){ toast('Nhập tiền cược.',true); return; }
    TX.busy=true; $('txBtn').disabled=true; $('sumBadge').style.display='none';
    var p=$('paper'); p.style.transition=''; p.style.opacity='1'; window.txResetPaper();
    api('/api/taixiu',{cua:TX.cua,cuoc:c}).then(function(r){
      if(!r||!r.success){ toast((r&&r.message)||'Có lỗi xảy ra.',true); TX.busy=false; $('txBtn').disabled=false; return; }
      TX.kq=r.data; setBal(r.data.soDu+(r.data.nhan>0?-r.data.nhan:0));
      $('diceRow').innerHTML=r.data.xx.map(function(n){ return dieHtml(n); }).join('');
      p.classList.remove('locked'); p.classList.add('open');
      $('stageCap').textContent='Kéo chén ra để xem kết quả (hoặc bấm đúp vào chén)';
    }).catch(function(){ TX.busy=false; $('txBtn').disabled=false; });
  });

  // ---------- do min ----------
  var MG={van:null,soMin:3,busy:false};
  $('mMins').innerHTML=[1,3,5,10,15,20,24].map(function(n){ return '<button data-n="'+n+'" class="'+(n===3?'on':'')+'">'+n+'</button>'; }).join('');
  $('mMins').querySelectorAll('button').forEach(function(b){ b.onclick=function(){ MG.soMin=+b.dataset.n; $('mBomb').textContent=MG.soMin; $('mMins').querySelectorAll('button').forEach(function(x){ x.classList.toggle('on',x===b); }); }; });
  function mRender(no){
    var v=MG.van, g=$('mGrid'), h='';
    for(var i=0;i<25;i++){
      var cls='mtile', t='';
      if(v){ var mo=v.mo.indexOf(i)>=0, min=v.min&&v.min.indexOf(i)>=0;
        if(mo){ cls+=' coin'; t='<span class="coin"></span>'; }
        else if(no===i){ cls+=' boom'; t='💥'; }
        else if(min){ cls+=' shown'; t='💣'; }
        else if(v.trangThai===0) cls+=' can'; else cls+=' dead'; }
      else cls+=' dead';
      h+='<div class="'+cls+'" data-o="'+i+'">'+t+'</div>';
    }
    g.innerHTML=h;
    g.querySelectorAll('.mtile.can').forEach(function(el){ el.onclick=function(){ mOpen(+el.dataset.o); }; });
    $('mSafe').textContent=v?v.mo.length:0; $('mBomb').textContent=v?v.soMin:MG.soMin;
    $('mHs').textContent='x'+(v?String(v.heSo).replace('.',','):'0');
    $('mHsN').textContent=v&&v.trangThai===0&&v.heSoTiep?('x'+String(v.heSoTiep).replace('.',',')):'-';
    var rb=$('mRut'), playing=v&&v.trangThai===0;
    rb.style.display=playing?'':'none';
    if(playing){ rb.disabled=!v.mo.length; rb.innerHTML=v.mo.length?('NHẬN '+fmt(v.rut)+' <span class="coin s"></span>'):'MỞ 1 Ô ĐỂ BẮT ĐẦU ĂN'; }
    $('mBtn').disabled=!!playing; $('mSetup').style.opacity=playing?.55:1;
  }
  function mLoad(){ api('/api/domin').then(function(r){ if(r&&r.success){ MG.van=r.data.van; setBal(r.data.soDu); mRender(); } }); }
  $('mBtn').addEventListener('click',function(){
    var c=parseInt($('mCuoc').value,10)||0; if(c<=0){ toast('Nhập tiền cược.',true); return; }
    $('mBtn').disabled=true;
    api('/api/domin/batdau',{cuoc:c,soMin:MG.soMin}).then(function(r){
      if(!r||!r.success){ toast((r&&r.message)||'Có lỗi xảy ra.',true); $('mBtn').disabled=false; return; }
      MG.van=r.data.van; setBal(r.data.soDu); mRender();
    });
  });
  function mOpen(o){
    if(MG.busy||!MG.van) return; MG.busy=true;
    api('/api/domin/mo',{id:MG.van.id,o:o}).then(function(r){
      MG.busy=false;
      if(!r||!r.success){ toast((r&&r.message)||'Có lỗi xảy ra.',true); mLoad(); return; }
      MG.van=r.data.van; setBal(r.data.soDu);
      if(MG.van.trangThai===2){ mRender(o); winpop(-MG.van.cuoc); toast('Trúng mìn! Mất '+fmt(MG.van.cuoc)+' xu web.',true); }
      else if(MG.van.trangThai===1){ mRender(); winpop(MG.van.nhan-MG.van.cuoc); toast('Mở hết ô an toàn! Nhận '+fmt(MG.van.nhan)+' xu web.'); }
      else mRender();
    });
  }
  $('mRut').addEventListener('click',function(){
    if(!MG.van||MG.busy) return; MG.busy=true;
    api('/api/domin/rut',{id:MG.van.id}).then(function(r){
      MG.busy=false;
      if(!r||!r.success){ toast((r&&r.message)||'Có lỗi xảy ra.',true); mLoad(); return; }
      MG.van=r.data.van; setBal(r.data.soDu); mRender(); winpop(MG.van.nhan-MG.van.cuoc); toast('Đã nhận '+fmt(MG.van.nhan)+' xu web.');
    });
  });
  mRender();

  // ---------- ruong ----------
  var RG={ds:[],sel:[]};
  function rgCount(){ api('/api/ruong').then(function(r){ if(r&&r.success){ var n=r.data.ds.length; $('rgN').style.display=n?'':'none'; $('rgN').textContent=n; $('tRg').textContent=n?('Đang có '+n+' món chờ rút'):'Đồ lật thẻ, rút vào game'; } }); }
  function rgLoad(){
    api('/api/ruong').then(function(r){
      if(!r||!r.success) return;
      RG.ds=r.data.ds; RG.sel=RG.sel.filter(function(id){ return RG.ds.some(function(x){ return x.id===id; }); });
      var n=RG.ds.length; $('rgN').style.display=n?'':'none'; $('rgN').textContent=n;
      $('rgGrid').innerHTML=n?RG.ds.map(function(x){
        return '<div class="ri'+(RG.sel.indexOf(x.id)>=0?' on':'')+'" data-id="'+x.id+'"><div class="ic" style="border-color:'+esc(x.mau)+'"><img src="'+esc(x.hinh)+'" alt="">'+(x.sl>1?'<b>'+x.sl+'</b>':'')+'</div>'
          +'<div><div class="tn">'+esc(x.ten)+(x.cuong?' +'+x.cuong:'')+'</div><div class="sn">'+(x.han?x.han+' ngày':'Vĩnh viễn')+(x.khoa?' · khóa':'')+'</div><div class="sn">'+esc(x.nguon||'')+'</div></div><span class="ck"></span></div>'; }).join('')
        :'<div class="empty" style="grid-column:1/-1"><b>Rương trống</b>Lật thẻ sau phó bản để nhận đồ vào đây.</div>';
      $('rgGrid').querySelectorAll('.ri').forEach(function(el){ el.onclick=function(){ var id=+el.dataset.id, i=RG.sel.indexOf(id);
        if(i>=0) RG.sel.splice(i,1); else { if(RG.sel.length>=5){ toast('Tối đa 5 món mỗi lần rút.',true); return; } RG.sel.push(id); }
        el.classList.toggle('on',RG.sel.indexOf(id)>=0); rgBtn(); }; });
      rgBtn();
    });
  }
  function rgBtn(){ $('rgBtn').disabled=!RG.sel.length; $('rgBtn').textContent='Rút vào game ('+RG.sel.length+'/5)'; }
  $('rgBtn').addEventListener('click',function(){
    if(!RG.sel.length) return;
    gConfirm('Gửi <b>'+RG.sel.length+' món</b> vào hộp thư trong game?').then(function(ok){
      if(!ok) return; $('rgBtn').disabled=true;
      api('/api/ruong/rut',{ids:RG.sel}).then(function(r){ toast((r&&r.message)||'Có lỗi xảy ra.',!(r&&r.success)); if(r&&r.success) RG.sel=[]; rgLoad(); });
    });
  });

  // nap so lieu nho cho trang chu ho so + nhan so tren menu
  refreshBal(); rgCount(); ddLoad(); loaded.diemdanh=1;
  api('/api/latthe').then(function(r){ if(r&&r.success){ var n=r.data.ds.length; $('ltN').style.display=n?'':'none'; $('ltN').textContent=n; $('tLt').textContent=n?('Có '+n+' lượt lật đang chờ!'):'Đánh xong boss trong game là có lượt'; } });
  go((location.hash||'#hoso').slice(1));
})();
</script>
</body>
</html>
