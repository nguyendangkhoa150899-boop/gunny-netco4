<!doctype html>
<html lang="vi">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Trang cá nhân | GunnyNetco4</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap">
<link rel="stylesheet" href="/css/portal.css?v=3">
<style>
  /* Giao dien theo bo TLBB (play.netco4.click): nen toi trung tinh, the #1b1e27, diem nhan vang.
     Menu trai = NHOM (data-grp), moi nhom co tab con (NHOM trong JS). Them muc moi: them 1 <section id="sec-x">
     + ten vao NHOM/TEN trong JS. */
  :root{--bg:#12141a;--bg2:#161922;--card:#1b1e27;--line:#2a2e3b;--text:#e8eaf0;--muted:#8a90a3;--ok:#3ddc84;--err:#ff5d5d;--blue:#4da3ff;--gold:#ffcf5c;--accent:#ffcf5c;--accent2:#ffa53a}
  body{background:var(--bg)}
  .wrap{max-width:1180px;padding:18px 16px 60px}
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
  /* menu trai (nhom) + tab con (kieu #navGrp TLBB) */
  .layout{display:grid;grid-template-columns:210px 1fr;gap:16px;align-items:start}
  #side{display:flex;flex-direction:column;gap:6px;background:var(--card);border:1px solid var(--line);border-radius:14px;padding:10px;position:sticky;top:14px}
  #side button{position:relative;display:flex;align-items:center;gap:10px;background:transparent;border:1px solid transparent;color:var(--muted);font-size:15px;font-weight:700;padding:12px 12px;border-radius:10px;cursor:pointer;text-align:left}
  #side button .ic{width:22px;text-align:center;font-size:17px}
  #side button:hover{color:var(--text);background:#232735}
  #side button.on{background:linear-gradient(180deg,#2b3346,#222839);color:var(--text);border-color:var(--gold);box-shadow:0 0 0 1px #ffcf5c55}
  #side .n{margin-left:auto;background:var(--err);color:#fff;border-radius:9px;font-size:11px;font-weight:800;padding:0 7px;line-height:1.7}
  #subnav{display:flex;gap:6px;margin-bottom:12px}
  #subnav:empty{display:none}
  #subnav button{flex:1;background:#1a1f2d;border:1px solid var(--line);color:var(--muted);font-size:14px;font-weight:700;padding:11px 4px;border-radius:10px;cursor:pointer}
  #subnav button:hover{color:var(--text)}
  #subnav button.on{background:linear-gradient(180deg,#33405c,#252c40);color:var(--text);border-color:var(--gold);box-shadow:0 0 0 1px #ffcf5c55}
  #subnav button small{font-size:11px;color:var(--gold);font-weight:600;margin-left:4px}
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
  /* ho so: the nhan vat */
  .hero{background:linear-gradient(135deg,#232838 0%,#1b1e27 55%,#211d12 100%);border-color:#3a3420}
  .hv{display:flex;align-items:center;gap:18px;flex-wrap:wrap}
  .hav{position:relative;width:78px;height:78px;border-radius:20px;flex:none;display:flex;align-items:center;justify-content:center;font-size:36px;font-weight:900;color:#2a1c00;background:linear-gradient(135deg,#ffe08a,#ffa53a);box-shadow:0 6px 20px #ffa53a33}
  .hav i{position:absolute;right:-4px;bottom:-4px;width:18px;height:18px;border-radius:50%;background:#56688a;border:3px solid var(--card)}
  .hav i.on{background:var(--ok);box-shadow:0 0 8px var(--ok)}
  .hinfo{flex:1;min-width:220px}
  .hnm{font-size:26px;font-weight:900;line-height:1.15}
  .tags{display:flex;gap:6px;flex-wrap:wrap;margin-top:8px}
  .tg{font-size:12px;font-weight:700;color:#c9cede;background:#12141a;border:1px solid var(--line);border-radius:999px;padding:3px 10px}
  .tg.lvl{color:#2a1c00;background:linear-gradient(180deg,#ffe08a,#f2c14e);border-color:#a8842f}
  .tg.live{color:var(--ok);border-color:#2f7a52}
  .hsub{color:var(--muted);font-size:13px;margin-top:8px} .hsub b{color:var(--text)}
  .hlc{text-align:right;background:#12141a;border:1px solid #4a3c18;border-radius:14px;padding:10px 18px}
  .hlc span{display:block;color:var(--muted);font-size:12px} .hlc b{font-size:28px;color:var(--gold);font-variant-numeric:tabular-nums}
  /* o viec can lam */
  .quick{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;margin:14px 0}
  .q{position:relative;display:flex;align-items:center;gap:12px;background:var(--card);border:1px solid var(--line);border-radius:14px;padding:14px;cursor:pointer;color:var(--text);text-align:left}
  .q:hover{border-color:#4a5168;transform:translateY(-1px)}
  .q .qi{width:42px;height:42px;border-radius:12px;background:#12141a;display:flex;align-items:center;justify-content:center;font-size:21px;flex:none}
  .q .qt b{display:block;font-size:15px} .q .qt span{color:var(--muted);font-size:12.5px}
  .q.hot{border-color:var(--gold);box-shadow:0 0 0 1px #ffcf5c55,0 0 18px #ffcf5c22}
  .q.hot .qt span{color:var(--gold);font-weight:700}
  .q.hot::after{content:"";position:absolute;top:10px;right:10px;width:9px;height:9px;border-radius:50%;background:var(--err);box-shadow:0 0 0 0 #ff5d5d88;animation:pulse 1.6s infinite}
  @@keyframes pulse{0%{box-shadow:0 0 0 0 #ff5d5d88}70%{box-shadow:0 0 0 8px #ff5d5d00}100%{box-shadow:0 0 0 0 #ff5d5d00}}
  /* tai san / chien dau */
  .money{display:flex;align-items:center;gap:12px;padding:10px 12px;border-radius:12px;background:#12141a;border:1px solid var(--line);margin-bottom:8px}
  .money .coin{width:26px;height:26px}
  .money .coin.lock{filter:grayscale(.6) brightness(.85)} .money .coin.gold2{background:radial-gradient(circle at 35% 30%,#fffbe0,#f5d76e 45%,#c49a1c)}
  .money div{flex:1} .money div span{display:block;color:var(--muted);font-size:12px} .money div b{font-size:19px;font-variant-numeric:tabular-nums}
  .money.hi{border-color:#6b5520;background:#1d1a10} .money.hi b{color:var(--gold)}
  .b.sm2{padding:8px 12px;font-size:13px;border-radius:9px}
  .fr2{display:flex;justify-content:space-between;align-items:baseline;padding:9px 0;border-bottom:1px dashed var(--line);font-size:14px}
  .fr2 span{color:var(--muted)} .fr2 b{font-size:16px;font-variant-numeric:tabular-nums}
  /* diem hoat dong + shop */
  .gem{display:inline-block;width:18px;height:18px;flex:none;transform:rotate(45deg);border-radius:4px;background:linear-gradient(135deg,#d9b8ff,#8b5cf6 55%,#5b21b6);box-shadow:0 0 0 1px #4c1d95,0 0 8px #8b5cf655;vertical-align:-3px;margin:0 2px}
  .gem.s{width:12px;height:12px;border-radius:3px;vertical-align:-1px}
  .bal.diem{background:#1b1430;border-color:#5b3a9a;color:#cdb4ff}
  .bal.diem.big{font-size:20px;padding:8px 16px 8px 10px}
  .shd{display:flex;justify-content:space-between;align-items:flex-start;gap:14px;flex-wrap:wrap;margin-bottom:14px}
  .shd .muted{margin-top:4px;max-width:720px}
  .kehd{font-size:14px;font-weight:800;color:var(--gold);margin:16px 0 8px;letter-spacing:.3px}
  .shopgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:10px}
  .si{display:flex;flex-direction:column;background:#12141a;border:1px solid var(--line);border-radius:14px;padding:12px;gap:10px}
  .si.q5,.si.q6,.si.q7{border-color:#5a4520;background:linear-gradient(180deg,#1d1a12,#12141a)}
  .si .top2{display:flex;gap:12px;align-items:flex-start}
  .si .sic{width:62px;height:62px;flex:none;border-radius:12px;border:2px solid;background:#0d1220;display:flex;align-items:center;justify-content:center}
  .si .sic img{width:90%;height:90%;object-fit:contain}
  .si .sit{display:block;font-size:14.5px;line-height:1.3}
  .si .sim{font-size:12px;color:var(--muted);margin-top:3px;line-height:1.4}
  .si .sil{display:flex;flex-wrap:wrap;gap:4px}
  .si .sil span{font-size:11px;color:#c9cede;background:#1b1e27;border:1px solid var(--line);border-radius:999px;padding:2px 8px}
  .si .sil span.het{color:#ff8a8a;border-color:#6b2a2a}
  .si .sif{display:flex;align-items:center;gap:8px;margin-top:auto}
  .si .price{flex:1;font-size:17px;font-weight:900;font-variant-numeric:tabular-nums;display:flex;align-items:center;gap:6px}
  .si .price.xu{color:var(--gold)} .si .price.diem{color:#cdb4ff}
  .si .sif input{width:58px;background:#0d1220;border:1px solid var(--line);border-radius:8px;color:var(--text);padding:7px;font-size:14px;text-align:center}
  .si .sif .b{padding:9px 16px;font-size:14px;margin:0;width:auto}
  /* gui qua test */
  .qtrow{display:flex;align-items:center;gap:10px;background:#12141a;border:1px solid var(--line);border-radius:12px;padding:9px 10px;margin-bottom:8px}
  .qtrow .ic{width:48px;height:48px;flex:none;border-radius:10px;border:2px solid;background:#0d1220;display:flex;align-items:center;justify-content:center}
  .qtrow .ic img{width:90%;height:90%;object-fit:contain}
  .qtrow .nm{flex:1;min-width:0} .qtrow .nm b{display:block;font-size:13.5px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis} .qtrow .nm span{font-size:11.5px;color:var(--muted)}
  .qtrow label{display:flex;flex-direction:column;font-size:10.5px;color:var(--muted);gap:2px}
  .qtrow input[type=number]{width:62px;background:#0d1220;border:1px solid var(--line);border-radius:7px;color:var(--text);padding:6px;font-size:13px;text-align:center}
  .qtrow .x{background:#3a1d22;color:#ff9a9a;border:1px solid #6b2a2a;border-radius:8px;width:30px;height:30px;cursor:pointer;font-weight:900}
  .qtempty{border:1px dashed var(--line);border-radius:12px;padding:16px;text-align:center;color:var(--muted);font-size:13px;margin-bottom:8px}
  .qtto{display:flex;align-items:center;gap:8px;background:#1d1a10;border:1px solid #6b5520;border-radius:10px;padding:9px 12px;font-size:14px;margin-bottom:10px}
  .qtsearch{display:flex;gap:8px} .qtsearch .in{flex:1 1 auto;min-width:0}
  .qtsearch select{flex:0 0 210px;width:210px;min-width:0;text-overflow:ellipsis;background:#12141a;border:1px solid var(--line);border-radius:10px;color:var(--text);padding:0 10px;font-size:14px}
  .qtsearch .b{flex:0 0 auto;padding:0 18px;background:linear-gradient(180deg,#ffb347,#f08a1c);color:#2b1600}
  .b.more{background:#2563eb;color:#fff}
  @@media (max-width:640px){ .qtsearch{flex-wrap:wrap} .qtsearch .in{flex-basis:100%} .qtsearch select{flex:1 1 auto;width:auto} }
  .qtgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(84px,1fr));gap:8px;margin-top:12px;max-height:560px;overflow-y:auto;padding-right:4px}
  .qtc{display:flex;flex-direction:column;align-items:center;gap:5px;cursor:pointer;text-align:center;padding:2px}
  .qtc .ic{width:64px;height:64px;border-radius:10px;border:2px solid;background:radial-gradient(circle at 50% 35%,#1f2a44,#0d1220 70%);position:relative;transition:transform .1s,box-shadow .1s}
  .qtc:hover .ic{transform:translateY(-2px);box-shadow:0 0 0 2px var(--gold),0 6px 16px #0008}
  .qtc .ic img{width:100%;height:100%;object-fit:contain;padding:4px}
  .qtc .ic small{position:absolute;left:3px;right:3px;bottom:2px;font-size:9.5px;font-weight:700;background:#000c;color:#fff;border-radius:5px;line-height:1.4}
  .qtc span{font-size:11px;line-height:1.25;color:#c9cede;max-height:2.5em;overflow:hidden}
  /* tooltip thong so (giong admin > Gui qua) */
  #qtTip{position:fixed;z-index:150;pointer-events:none;width:270px;background:#0f1828;border:1px solid #3a4a6e;border-radius:10px;padding:11px 12px;font-size:12.5px;box-shadow:0 10px 30px rgba(0,0,0,.6);display:none}
  #qtTip b.tn{font-size:14px;display:block;margin-bottom:5px}
  #qtTip .r{display:flex;justify-content:space-between;color:var(--muted);padding:1px 0} #qtTip .r span:last-child{color:var(--text);font-weight:600}
  #qtTip .r.cs span:last-child{color:#7dffb0}
  #qtTip .d{margin-top:6px;color:#9fb1cc;line-height:1.45;border-top:1px solid #24304a;padding-top:6px}
  /* rut xu tu game */
  .steps2{margin:0 0 12px;padding-left:20px;line-height:1.9;font-size:14px;color:#c9cede}
  .steps2 b{color:var(--text)}
  .code2{font-family:Consolas,monospace;color:var(--gold);background:#12141a;border:1px solid #6b5520;border-radius:6px;padding:1px 8px}
  .rutInfo{display:grid;grid-template-columns:1fr 1fr;gap:8px}
  .rutInfo div{background:#12141a;border:1px solid var(--line);border-radius:10px;padding:9px 12px}
  .rutInfo span{display:block;color:var(--muted);font-size:12px} .rutInfo b{font-size:15px}
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
  /* ban min: thanh so lieu tren + luoi 5x5 vuong. KHONG dat class "coin" cho o (trung class dong xu tron 20px). */
  #mboard{background:radial-gradient(ellipse at center,#16204a 0%,#0b1024 80%);border:1px solid #2b3557;border-radius:14px;padding:14px}
  .mbar{display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-bottom:12px}
  .mbar div{background:#0b1024cc;border:1px solid #2b3557;border-radius:10px;padding:7px 10px;text-align:center}
  .mbar span{display:block;font-size:11.5px;color:#8fa0c8}
  .mbar b{font-size:18px;font-variant-numeric:tabular-nums} .mbar .g b{color:var(--gold)} .mbar .r b{color:#ff8a8a} .mbar .h b{color:#7dffb0}
  .mbar .h small{font-size:12px;color:#8fa0c8;font-weight:600}
  .mgrid{display:grid;grid-template-columns:repeat(5,1fr);gap:8px;max-width:440px;margin:0 auto}
  .mtile{aspect-ratio:1;border-radius:11px;display:flex;align-items:center;justify-content:center;font-size:26px;font-weight:800;user-select:none;
    background:linear-gradient(180deg,#2f7fd6,#215aa8);border:1px solid #4b9ae8;border-bottom:4px solid #14346a;color:#bcdcff;transition:transform .08s,filter .12s}
  .mtile.idle{opacity:.38;cursor:default}
  .mtile.can{cursor:pointer} .mtile.can:hover{filter:brightness(1.18);transform:translateY(-1px)}
  .mtile.can:active{transform:translateY(2px);border-bottom-width:2px}
  .mtile.dead{background:linear-gradient(180deg,#232a3d,#1a2030);border-color:#2c3450;border-bottom-color:#141824;color:#4a5372;cursor:default}
  .mtile.safe{background:linear-gradient(180deg,#ffe9a8,#e8bf58);border-color:#a8842f;border-bottom-color:#7d5f1e;cursor:default;animation:coinPop .28s ease-out}
  .mtile.safe .coin{width:46%;height:46%}
  .mkq{margin-top:12px;text-align:center;font-weight:800;font-size:15px;min-height:22px}
  .mkq.w{color:var(--ok)} .mkq.l{color:var(--err)} .mkq.i{color:#8fa0c8;font-weight:600;font-size:13.5px}
  .mtile.boom{background:linear-gradient(180deg,#e05555,#8e2020);border-color:#ff9a9a;border-bottom-color:#5d1414;color:#fff;cursor:default;animation:boomPop .32s ease-out}
  .mtile.shown{background:linear-gradient(180deg,#3a2030,#2a1622);border-color:#6b3a4a;border-bottom-color:#1e1017;color:#c46b7b;cursor:default}
  @@keyframes coinPop{0%{transform:scale(.55)}60%{transform:scale(1.14)}100%{transform:scale(1)}}
  @@keyframes boomPop{0%{transform:scale(.5) rotate(-20deg)}70%{transform:scale(1.28) rotate(8deg)}100%{transform:scale(1)}}
  .mins{display:flex;gap:6px;flex-wrap:wrap;margin-top:8px}
  .mins button{flex:1;min-width:46px;background:#232735;border:1px solid var(--line);color:#fff;font-weight:800;padding:8px 0;border-radius:9px;cursor:pointer}
  .mins button.on{border-color:#ff8a8a;color:#ff8a8a}
  /* lat the: 21 la Gunny (3 hang x 7), anh tach tu gameover.swf */
  /* danh sach luot (trai, cuon rieng) + ban bai (phai) */
  .ltwrap{display:grid;grid-template-columns:270px minmax(0,1fr);gap:14px;align-items:start}
  .ltside{background:#12141a;border:1px solid var(--line);border-radius:14px;padding:10px;position:sticky;top:14px}
  .ltside .in{font-size:14px;padding:9px 11px}
  .ltcount{display:flex;justify-content:space-between;align-items:center;font-size:12.5px;color:var(--muted);margin:9px 2px 6px}
  .ltcount b{color:var(--gold)}
  .ltcount button{background:none;border:0;color:#7db4ff;font-size:12px;cursor:pointer;padding:0}
  .ltList{display:flex;flex-direction:column;gap:4px;max-height:560px;overflow-y:auto;padding-right:3px}
  .ltList::-webkit-scrollbar{width:6px} .ltList::-webkit-scrollbar-thumb{background:#2f3547;border-radius:3px}
  .ltList button{display:flex;align-items:center;gap:8px;width:100%;background:transparent;border:1px solid transparent;color:var(--text);border-radius:9px;padding:7px 8px;cursor:pointer;text-align:left}
  .ltList button:hover{background:#1b1f2b}
  .ltList button.on{background:linear-gradient(180deg,#2b3346,#222839);border-color:var(--gold)}
  .ltList .nm{flex:1;min-width:0} .ltList .nm b{display:block;font-size:13px;font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  .ltList .nm span{font-size:11px;color:var(--muted)}
  .dk{flex:none;font-size:10.5px;font-weight:800;border-radius:6px;padding:2px 7px;border:1px solid}
  .dk.de{color:#7dffb0;border-color:#2f7a52;background:#123122} .dk.th{color:#7db4ff;border-color:#2c4f80;background:#12233d}
  .dk.kh{color:#ffb35c;border-color:#7a5122;background:#33230f} .dk.ah{color:#ff8a8a;border-color:#7a2a2a;background:#341414}
  .dk.am{color:#d6b4ff;border-color:#5b3a9a;background:#22163a}
  .ltempty2{color:var(--muted);font-size:13px;text-align:center;padding:16px 4px}
  @@media (max-width:900px){ .ltwrap{grid-template-columns:1fr} .ltside{position:static} .ltList{max-height:230px} }
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
  .ri .ic b{position:absolute;right:-5px;bottom:-5px;background:linear-gradient(180deg,#ffe08a,#f2c14e);color:#2a1c00;font-size:11px;font-weight:900;border-radius:6px;padding:0 5px;border:1px solid #a8842f;line-height:1.5}
  .ri > div:nth-child(2){min-width:0;padding-right:18px}   /* chua cho o tick goc phai, khong de len ten */
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
    .layout{grid-template-columns:1fr} #side{position:static;flex-direction:row;overflow-x:auto} #side button{white-space:nowrap;padding:10px 12px} .row2{grid-template-columns:1fr} .stats{grid-template-columns:repeat(2,1fr)} .kv{grid-template-columns:1fr}
    .tiles{grid-template-columns:1fr 1fr} .quick{grid-template-columns:1fr 1fr} .hlc{text-align:left} .cards{gap:6px} .cd .fr .t{font-size:9px}
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
      <div class="bal diem" title="Điểm hoạt động: mua kệ hiếm ở Shop. Kiếm từ điểm danh và đánh xong boss phó bản, không đổi từ xu được"><span class="gem"></span><span id="diemTop">0</span></div>
      <div class="chip2"><div class="av" id="c_av">G</div><span id="c_name">...</span></div>
      <a class="lk" href="/">Trang chủ</a>
      <a class="lk" id="logout">Đăng xuất</a>
    </div>
  </div>

  <div class="layout">
  <div id="side">
    <button data-grp="hoso" class="on"><span class="ic">👤</span>Hồ sơ</button>
    <button data-grp="latthe"><span class="ic">🃏</span>Lật thẻ<span class="n" id="ltN" style="display:none"></span></button>
    <button data-grp="minigame"><span class="ic">🎲</span>Mini game</button>
    <button data-grp="shop"><span class="ic">🛒</span>Shop</button>
    <button data-grp="quatest" id="qtNav" style="display:none"><span class="ic">📮</span>Gửi quà test</button>
    <button data-grp="ruong"><span class="ic">🎁</span>Rương<span class="n" id="rgN" style="display:none"></span></button>
  </div>
  <div>
  <div id="subnav"></div>

  <!-- ================= HO SO ================= -->
  <section id="sec-hoso" class="on">
    <!-- the nhan vat: ten, cap, trang thai, luc chien -->
    <div class="card hero" id="profCard"><div class="muted">Đang tải hồ sơ...</div></div>
    <!-- viec can lam hom nay: o nao co viec dang cho thi sang vien vang (.hot) -->
    <div class="quick">
      <button class="q" id="qDd" data-go="diemdanh"><span class="qi">📅</span><span class="qt"><b>Điểm danh</b><span id="tDd">Nhận quà mỗi ngày</span></span></button>
      <button class="q" id="qLt" data-go="latthe"><span class="qi">🃏</span><span class="qt"><b>Lật thẻ</b><span id="tLt">Đánh boss là có lượt</span></span></button>
      <button class="q" id="qRg" data-go="ruong"><span class="qi">🎁</span><span class="qt"><b>Rương web</b><span id="tRg">Đồ chờ rút vào game</span></span></button>
      <button class="q" data-go="taixiu"><span class="qi">🎲</span><span class="qt"><b>Mini game</b><span>Tài xỉu x<span id="tHs">1,95</span> · Dò mìn</span></span></button>
    </div>
    <div class="row2">
      <div class="card" id="cTaiSan"><h2>Tài sản</h2><div class="muted">...</div></div>
      <div class="card" id="cChienDau"><h2>Chiến đấu</h2><div class="muted">...</div></div>
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
      <!-- rut xu game ra web: gui thu kem xu cho nhan vat NganHang trong game (MiniGameController::nhanXuNganHang) -->
      <div class="card" id="rutCard">
        <h2>Rút xu từ game ra web</h2>
        <ol class="steps2">
          <li>Trong game mở <b>Thư</b> → <b>Gửi thư</b>.</li>
          <li>Người nhận: <b class="code2" id="rutTen">NganHang</b> <button class="b gray sm2" id="rutCopy">Chép tên</button></li>
          <li>Nhập <b>số xu</b> muốn rút, <b>không kèm đồ</b>, bấm Gửi (phí gửi thư 100 vàng).</li>
          <li>Mở lại trang này: xu web tự cộng, đang online vẫn rút được.</li>
        </ol>
        <div class="rutInfo"><div><span>Tỉ lệ</span><b id="rutTile">1 xu game = 1 xu web</b></div><div><span>Hôm nay còn rút được</span><b id="rutCon">-</b></div></div>
        <div class="msg" id="rutMsg"></div>
        <div class="muted" style="margin-top:8px">Trang tự kiểm tra thư mới mỗi 10 giây khi đang mở mục Ví.</div>
      </div>
    </div>
    <div class="row2" style="margin-top:14px">
      <div class="card"><h2>Lịch sử xu web</h2><table class="ls" id="viLs"></table></div>
      <div class="card"><h2>Điểm hoạt động <span class="gem s"></span> <b id="viDiem" style="color:#cdb4ff">0</b></h2><table class="ls" id="diemLs"></table></div>
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
      <div class="ltwrap">
        <div class="ltside">
          <input class="in" id="ltFind" placeholder="Tìm phó bản..." autocomplete="off">
          <div class="ltcount"><span>Đang chờ: <b id="ltCnt">0</b> lượt</span><button type="button" id="ltNext">Lượt kế tiếp →</button></div>
          <div class="ltList" id="ltList"></div>
        </div>
        <div id="ltBoard"></div>
      </div>
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
        <div id="mboard">
          <div class="mbar">
            <div class="g"><span>Ô an toàn</span><b id="mSafe">0</b></div>
            <div class="r"><span>Số mìn</span><b id="mBomb">3</b></div>
            <div class="h"><span>Hệ số</span><b id="mHs">x0</b> <small id="mHsN"></small></div>
          </div>
          <div class="mgrid" id="mGrid"></div>
          <div class="mkq i" id="mKq">Chọn số mìn, tiền cược rồi bấm Bắt đầu</div>
        </div>
        <button class="b gold" id="mRut" style="width:100%;margin-top:12px;display:none"></button>
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
        <div style="display:flex;gap:8px"><button class="b gray" id="rgAll" type="button">Chọn tất cả</button><button class="b blue" id="rgBtn" disabled>Rút vào game</button></div>
      </div>
      <div class="muted" style="margin-bottom:12px">Chọn bao nhiêu món cũng được (tối đa 50 ô mỗi lần), web <b>tự chia thư 5 món/thư</b> vào <b>hộp thư trong game</b> (đang online cũng nhận). Ví dụ 11 món thành 3 thư: 5 + 5 + 1.</div>
      <div class="rgrid" id="rgGrid"></div>
    </div>
  </section>

  <!-- ================= SHOP (A xu web / B diem hoat dong) ================= -->
  <section id="sec-shopdiem"><div class="card">
    <div class="shd"><div><h2 style="margin:0">Kệ điểm hoạt động</h2>
      <div class="muted">Đồ hiếm, chỉ mua bằng <b>điểm hoạt động</b> (không đổi từ xu được). Kiếm điểm: <b>điểm danh</b> +10/ngày (đủ 7/14/21/28 ngày thêm +20), mỗi lần <b>đánh xong boss phó bản</b> +5 (tối đa 50/ngày). Đồ mua xong vào <b>Rương web</b>.</div></div>
      <div class="bal diem big"><span class="gem"></span><span class="diemNow">0</span></div></div>
    <div id="shopDiem"></div></div></section>
  <section id="sec-shopxu"><div class="card">
    <div class="shd"><div><h2 style="margin:0">Kệ xu web</h2>
      <div class="muted">Mua bằng <b>xu web</b> (đổi 1:1 với xu game; rút xu từ game ở mục Hồ sơ → Ví xu). Đồ mua xong vào <b>Rương web</b>, rút vào game khi cần.</div></div>
      <div class="bal big" style="font-size:20px;padding:8px 16px 8px 8px"><span class="coin"></span><span class="xuNow">0</span></div></div>
    <div id="shopXu"></div></div></section>

  <!-- ================= GUI QUA TEST (vao thu game cua chinh minh; tat bang quatest_mo=0) ================= -->
  <section id="sec-quatest"><div class="row2">
    <div class="card">
      <h2>Gửi quà test vào game</h2>
      <div class="qtto">📮 Người nhận: <b id="qtTo">nhân vật của bạn</b> <span class="muted">(tài khoản đang đăng nhập)</span></div>
      <div id="qtSlots"></div>
      <button class="b go" id="qtBtn" disabled>GỬI VÀO THƯ GAME</button>
      <div class="msg" id="qtMsg"></div>
      <div class="muted" style="margin-top:8px">Tối đa 5 món mỗi lần, đồ vào <b>hộp thư trong game</b> (đang online cũng nhận). Chỉ hiện món client có ảnh. Tính năng cho giai đoạn test, mở server thật sẽ tắt.</div>
    </div>
    <div class="card">
      <h2>Tìm vật phẩm</h2>
      <div class="qtsearch"><input class="in" id="qtQ" placeholder="Nhập ID hoặc tên, vd: 7194 hoặc Thương Cổ" autocomplete="off">
        <select id="qtCat"><option value="0">Tất cả loại</option></select><button class="b" id="qtFind">Tìm</button></div>
      <div class="muted" id="qtInfo" style="margin-top:8px">Chọn loại hoặc gõ ID / tên để tìm, bấm vào ô để thêm.</div>
      <div class="qtgrid" id="qtRes"></div>
      <button class="b more" id="qtMore" style="display:none;margin-top:12px;width:100%">Xem thêm</button>
    </div>
  </div></section>

  <section id="sec-ghep"><div class="card empty"><b>Ghép đồ</b>Ghép nhiều món trong rương thành món xịn hơn. Tính năng đang phát triển.</div></section>
  </div>
  </div>

  <div class="foot">gunny.netco4.click &middot; server test</div>
</div>

<div id="winpop"></div>
<div id="qtTip"></div>
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
  function setBal(v){ if(v==null) return; $('balTop').textContent=fmt(v); $('viBal').textContent=fmt(v); document.querySelectorAll('.xuNow').forEach(function(e){ e.textContent=fmt(v); }); }
  function setDiem(v){ if(v==null) return; $('diemTop').textContent=fmt(v); $('viDiem').textContent=fmt(v); document.querySelectorAll('.diemNow').forEach(function(e){ e.textContent=fmt(v); }); var p=$('pfDiem'); if(p) p.textContent=fmt(v); }
  function winpop(n){ var e=$('winpop'); e.textContent=(n>=0?'+':'')+fmt(n); e.style.color=n>0?'#3ddc84':'#ff5d5d'; e.className=''; void e.offsetWidth; e.className='show'; }

  // ---------- dieu huong ----------
  // menu trai = nhom, moi nhom gom cac muc (tab con). Hash: #vi, #taixiu, ... (ten muc)
  var NHOM={hoso:['hoso','vi','diemdanh'],latthe:['latthe'],minigame:['taixiu','domin'],shop:['shopdiem','shopxu'],quatest:['quatest'],ruong:['ruong','ghep']};
  var TEN={hoso:'Thông tin',vi:'Ví xu',diemdanh:'Điểm danh',latthe:'Lật thẻ',taixiu:'Tài xỉu',domin:'Dò mìn',quatest:'Gửi quà test',shopdiem:'Kệ điểm hoạt động',shopxu:'Kệ xu web',ruong:'Rương đồ',ghep:'Ghép đồ<small>sắp có</small>'};
  function nhomCua(sec){ for(var g in NHOM) if(NHOM[g].indexOf(sec)>=0) return g; return 'hoso'; }
  var loaded={};
  function go(sec){
    if(NHOM[sec] && !$('sec-'+sec)) sec=NHOM[sec][0];
    if(sec==='minigame') sec='taixiu';
    if(!$('sec-'+sec)) sec='hoso';
    var g=nhomCua(sec);
    document.querySelectorAll('section').forEach(function(s){ s.classList.toggle('on', s.id==='sec-'+sec); });
    document.querySelectorAll('#side button').forEach(function(a){ a.classList.toggle('on', a.dataset.grp===g); });
    var sn=$('subnav');
    sn.innerHTML=NHOM[g].length>1?NHOM[g].map(function(x){ return '<button data-sub="'+x+'" class="'+(x===sec?'on':'')+'">'+TEN[x]+'</button>'; }).join(''):'';
    sn.querySelectorAll('button').forEach(function(b){ b.onclick=function(){ go(b.dataset.sub); }; });
    if(location.hash!=='#'+sec) history.replaceState(null,'','#'+sec);
    var f={vi:loadVi,diemdanh:ddLoad,latthe:ltLoad,taixiu:txLoad,domin:mLoad,ruong:rgLoad,shopdiem:shopLoad,shopxu:shopLoad,quatest:qtLoaiLoad}[sec];
    if(f && (sec==='latthe'||sec==='ruong'||sec==='vi'||sec.indexOf('shop')===0||!loaded[sec])){ loaded[sec]=1; f(); }
    window.scrollTo(0,0);
    // dang mo Vi: 10 giay kiem tra thu rut xu 1 lan
    clearInterval(window._viPoll);
    if(sec==='vi') window._viPoll=setInterval(function(){ if(!document.hidden) loadVi(); },10000);
  }
  document.querySelectorAll('[data-grp]').forEach(function(a){ a.addEventListener('click',function(){ go(NHOM[a.dataset.grp][0]); }); });
  document.querySelectorAll('[data-go]').forEach(function(a){ a.addEventListener('click',function(){ go(a.dataset.go); }); });

  // ---------- ho so ----------
  api('/api/hoso').then(function(d){
    var box=$('profCard');
    if(!d||!d.success){ box.innerHTML='<div class="msg err">'+esc((d&&d.message)||'Không tải được hồ sơ.')+'</div>'; return; }
    setBal(d.data.xuWeb);
    var c=d.data.nhanVat, acc=d.data.taiKhoan;
    if(!c){ box.innerHTML='<div class="empty"><b>Chưa có nhân vật</b>Tài khoản '+esc(acc)+' chưa tạo nhân vật. Tải game ở trang chủ, đăng nhập và tạo nhân vật rồi quay lại.</div>'; return; }
    var rate=c.tran?Math.round(100*c.thang/c.tran):0, max=c.cap>=c.capToiDa;
    $('qtTo').textContent=c.ten;
    // the nhan vat
    box.innerHTML='<div class="hv"><div class="hav">'+esc((c.ten[0]||'G').toUpperCase())+'<i class="'+(c.online?'on':'')+'"></i></div>'
      +'<div class="hinfo"><div class="hnm">'+esc(c.ten)+'</div>'
      +'<div class="tags"><span class="tg lvl">Cấp '+c.cap+(max?' · MAX':'')+'</span><span class="tg">'+esc(c.gioiTinh)+'</span>'
      +'<span class="tg">'+esc(c.bang||'Chưa vào bang')+'</span><span class="tg '+(c.online?'live':'')+'">'+(c.online?'● Đang trong game':'Ngoại tuyến')+'</span></div>'
      +'<div class="hsub">Tài khoản <b>'+esc(acc)+'</b> · tạo ngày '+esc(c.ngayTao)+' · vào game lần cuối '+esc(c.lanCuoi)+'</div></div>'
      +'<div class="hlc"><span>Lực chiến</span><b>'+fmt(c.lucChien)+'</b></div></div>'
      +'<div class="lv"><div class="r"><span>Kinh nghiệm cấp '+c.cap+'</span><span>'+(max?'Đã đạt cấp tối đa '+c.capToiDa:c.phanTramCap+'% lên cấp '+(c.cap+1))+'</span></div><div class="bar"><i style="width:'+(max?100:c.phanTramCap)+'%"></i></div></div>';
    // tai san
    $('cTaiSan').innerHTML='<h2>Tài sản</h2>'
      +'<div class="money hi"><span class="coin"></span><div><span>Xu web</span><b>'+fmt(d.data.xuWeb)+'</b></div><button class="b gold sm2" data-go="vi">Đổi sang game</button></div>'
      +'<div class="money"><span class="gem" style="width:22px;height:22px;margin:0 4px"></span><div><span>Điểm hoạt động</span><b id="pfDiem" style="color:#cdb4ff">'+fmt(VI.diem||0)+'</b></div><button class="b gray sm2" data-go="shopdiem">Vào shop</button></div>'
      +'<div class="money"><span class="coin"></span><div><span>Xu game</span><b>'+fmt(c.xu)+'</b></div></div>'
      +'<div class="money"><span class="coin lock"></span><div><span>Xu khóa</span><b>'+fmt(c.xuKhoa)+'</b></div></div>'
      +'<div class="money"><span class="coin gold2"></span><div><span>Vàng</span><b>'+fmt(c.vang)+'</b></div></div>'
      +(c.online?'<div class="muted" style="margin-top:8px">Bạn đang trong game: xu game và vàng ở đây có thể chậm vài phút.</div>':'');
    // chien dau
    $('cChienDau').innerHTML='<h2>Chiến đấu</h2>'
      +'<div class="fr2"><span>Trận thắng / tổng trận</span><b>'+fmt(c.thang)+' / '+fmt(c.tran)+'</b></div>'
      +'<div class="fr2"><span>Tỉ lệ thắng</span><b>'+rate+'%</b></div><div class="bar" style="margin:2px 0 10px"><i style="width:'+rate+'%;background:linear-gradient(90deg,#3ddc84,#2fbf71)"></i></div>'
      +'<div class="fr2"><span>Công hiến</span><b>'+fmt(c.congHien)+'</b></div>'
      +'<div class="fr2"><span>Điểm thành tích</span><b>'+fmt(c.thanhTich)+'</b></div>'
      +'<div class="fr2"><span>Số lần vào game</span><b>'+fmt(c.soLanDangNhap)+'</b></div>';
    document.querySelectorAll('#cTaiSan [data-go]').forEach(function(a){ a.onclick=function(){ go(a.dataset.go); }; });
  });
  function hot(id,on){ var e=$(id); if(e) e.classList.toggle('hot',!!on); }

  // ---------- vi ----------
  var VI={};
  var LOAI={shop:'Shop web',phoban:'Phó bản',taixiu:'Tài xỉu',domin:'Dò mìn',latthe:'Lật thẻ',diemdanh:'Điểm danh',admin:'Admin',doixu:'Đổi sang game',rutxu:'Rút từ game'};
  function loadVi(){
    api('/api/vi').then(function(d){
      if(!d||!d.success) return;
      VI=d.data; setBal(d.data.soDu); setDiem(d.data.diem); $('qtNav').style.display=d.data.quaTest?'':'none';
      var ld=d.data.lichSuDiem||[];
      $('diemLs').innerHTML=ld.length?ld.map(function(x){ return '<tr><td class="t">'+esc(x.tg.slice(5))+'</td><td>'+esc(LOAI[x.loai]||x.loai)+'<div class="muted">'+esc(x.gc||'')+'</div></td><td class="'+(x.d>=0?'p':'m')+'">'+(x.d>=0?'+':'')+fmt(x.d)+'</td></tr>'; }).join('')
        :'<tr><td class="empty">Chưa có điểm. Điểm danh hoặc đánh xong boss phó bản để nhận.</td></tr>';
      var r=d.data.rut||{};
      if(r.ten) $('rutTen').textContent=r.ten;
      $('rutTile').textContent=(r.tile>1?String(r.tile).replace('.',',')+' xu game':'1 xu game')+' = 1 xu web';
      $('rutCon').textContent=fmt(Math.max(0,(r.tran||0)-(r.daRutHomNay||0)))+' xu game';
      $('rutCard').style.opacity=r.mo?1:.5;
      var m=$('rutMsg');
      if(r.nhan&&r.nhan.length){ var tong=r.nhan.reduce(function(s,x){ return s+x.xuWeb; },0);
        m.className='msg ok'; m.textContent='Đã nhận '+r.nhan.length+' thư rút xu: +'+fmt(tong)+' xu web!'; winpop(tong); toast('+'+fmt(tong)+' xu web từ game'); }
      else if(r.cho){ m.className='msg err'; m.textContent=r.cho+' thư ('+fmt(r.choXu)+' xu game) vượt hạn mức hôm nay, sẽ tự cộng vào ngày mai.'; }
      else if(!r.mo){ m.className='msg err'; m.textContent='Rút xu đang tạm tắt.'; }
      var ls=d.data.lichSu||[];
      $('viLs').innerHTML=ls.length?ls.map(function(x){ return '<tr><td class="t">'+esc(x.tg.slice(5))+'</td><td>'+esc(LOAI[x.loai]||x.loai)+'<div class="muted">'+esc(x.gc||'')+'</div></td><td class="'+(x.d>=0?'p':'m')+'">'+(x.d>=0?'+':'')+fmt(x.d)+'</td></tr>'; }).join('')
        :'<tr><td class="empty">Chưa có giao dịch.</td></tr>';
    });
  }
  $('rutCopy').addEventListener('click',function(){
    var t=$('rutTen').textContent, b=this, done=function(){ b.textContent='Đã chép'; setTimeout(function(){ b.textContent='Chép tên'; },1500); };
    if(navigator.clipboard&&window.isSecureContext) navigator.clipboard.writeText(t).then(done); else done();
  });
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
      $('tDd').textContent=d.dadiemdanh?('✓ Đã điểm danh · tháng này '+d.ngay.length+' ngày'):'Chưa điểm danh hôm nay!'; hot('qDd',!d.dadiemdanh);
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
  function refreshBal(){ api('/api/vi').then(function(d){ if(d&&d.success){ VI=d.data; setBal(d.data.soDu); setDiem(d.data.diem); $('qtNav').style.display=d.data.quaTest?'':'none'; } }); }

  // ---------- lat the ----------
  var LT={ds:[],cur:null,busy:false};
  function ltLoad(){
    api('/api/latthe').then(function(r){
      if(!r||!r.success){ $('ltList').innerHTML=''; $('ltBoard').innerHTML='<div class="empty">'+esc((r&&r.message)||'Không tải được.')+'</div>'; return; }
      LT.ds=r.data.ds; LT.soLa=r.data.soLa||21; LT.soLat=r.data.soLat||3;
      var n=LT.ds.length; $('ltN').style.display=n?'':'none'; $('ltN').textContent=n;
      $('tLt').textContent=n?('Có '+n+' lượt lật đang chờ!'):'Đánh boss là có lượt'; hot('qLt',n);
      $('ltInfo').innerHTML='Đánh xong <b>boss ải cuối</b> của phó bản trong game là có 1 lượt lật (mỗi phó bản <b>'+r.data.soLan+' lượt/ngày</b>). Mỗi lượt lật <b>'+LT.soLat+' lá</b>, đồ vào <b>Rương web</b>, xu vào ví.'+(r.data.mo?'':' <b style="color:#ff8a8a">Lật thẻ đang tạm tắt.</b>');
      if(!LT.cur || !LT.ds.some(function(x){ return x.id===LT.cur; })) LT.cur=n?LT.ds[0].id:null;
      ltRenderList(); ltRenderBoard();
    });
  }
  // tach do kho o cuoi ten pho ban -> nhan mau; sap xep theo ten goc roi do kho
  var DK=[['ác mộng','am','Ác mộng',5],['anh hùng','ah','Anh hùng',4],['ah','ah','Anh hùng',4],['khó','kh','Khó',3],['thường','th','Thường',2],['dễ','de','Dễ',1]];
  function tachDk(ten){
    var t=String(ten).trim().replace(/\s+ải$/i,''), lo=t.toLowerCase();
    for(var i=0;i<DK.length;i++){ var k=DK[i][0]; if(lo===k||lo.slice(-(k.length+1))===' '+k) return {goc:t.slice(0,t.length-k.length).trim(),dk:DK[i]}; }
    return {goc:t,dk:null};
  }
  function ltRenderList(){
    var q=($('ltFind').value||'').trim().toLowerCase();
    var ds=LT.ds.map(function(x){ var d=tachDk(x.phoBan); return {x:x,goc:d.goc,dk:d.dk}; })
      .filter(function(r){ return !q||r.x.phoBan.toLowerCase().indexOf(q)>=0; })
      .sort(function(a,b){ return a.goc.localeCompare(b.goc,'vi')||((a.dk?a.dk[3]:0)-(b.dk?b.dk[3]:0))||(a.x.id-b.x.id); });
    LT.thuTu=ds.map(function(r){ return r.x.id; });
    $('ltCnt').textContent=LT.ds.length;
    $('ltList').innerHTML=ds.length?ds.map(function(r){ var x=r.x, n=Object.keys(x.daLat).length;
      return '<button data-id="'+x.id+'" class="'+(x.id===LT.cur?'on':'')+'"><span class="nm"><b>'+esc(r.goc)+'</b><span>'+esc(x.tg.slice(11))+' · đã lật '+n+'/'+LT.soLat+'</span></span>'
        +(r.dk?'<span class="dk '+r.dk[1]+'">'+r.dk[2]+'</span>':'')+'</button>'; }).join('')
      :'<div class="ltempty2">'+(LT.ds.length?'Không thấy phó bản nào.':'Chưa có lượt nào.')+'</div>';
    $('ltList').querySelectorAll('button').forEach(function(b){ b.onclick=function(){ LT.cur=+b.dataset.id; ltRenderList(); ltRenderBoard(); }; });
    var on=$('ltList').querySelector('button.on'); if(on&&on.scrollIntoView) on.scrollIntoView({block:'nearest'});
  }
  $('ltFind').addEventListener('input',ltRenderList);
  $('ltNext').addEventListener('click',function(){
    var t=LT.thuTu||[]; if(!t.length) return; var i=t.indexOf(LT.cur); LT.cur=t[(i+1)%t.length]; ltRenderList(); ltRenderBoard();
  });
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
    if(xongData){ $('ltDone').onclick=function(){ var t=LT.thuTu||[], i=t.indexOf(LT.cur); LT.cur=t.length>1?t[(i+1)%t.length]:null; ltLoad(); }; return; }
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
        if(mo){ cls+=' safe'; t='<span class="coin"></span>'; }
        else if(no===i){ cls+=' boom'; t='💥'; }
        else if(min){ cls+=' shown'; t='💣'; }
        else if(v.trangThai===0) cls+=' can'; else cls+=' dead'; }
      else cls+=' idle';
      h+='<div class="'+cls+'" data-o="'+i+'">'+t+'</div>';
    }
    g.innerHTML=h;
    g.querySelectorAll('.mtile.can').forEach(function(el){ el.onclick=function(){ mOpen(+el.dataset.o); }; });
    $('mSafe').textContent=v?v.mo.length:0; $('mBomb').textContent=v?v.soMin:MG.soMin;
    $('mHs').textContent='x'+(v?String(v.heSo).replace('.',','):'0');
    $('mHsN').textContent=v&&v.trangThai===0&&v.heSoTiep?('→ x'+String(v.heSoTiep).replace('.',',')):'';
    var kq=$('mKq');
    if(!v){ kq.className='mkq i'; kq.textContent='Chọn số mìn, tiền cược rồi bấm Bắt đầu'; }
    else if(v.trangThai===0){ kq.className='mkq i'; kq.textContent=v.mo.length?(v.heSo<1?'Hệ số dưới x1: rút lúc này sẽ lỗ, mở thêm ô để lên lời':'Mở tiếp hoặc bấm Nhận để rút tiền'):'Chọn 1 ô bất kỳ để mở'; }
    else if(v.trangThai===2){ kq.className='mkq l'; kq.textContent='💥 Trúng mìn! Mất '+fmt(v.cuoc)+' xu web'; }
    else { var net=v.nhan-v.cuoc; kq.className='mkq '+(net>=0?'w':'l'); kq.textContent='Đã rút '+fmt(v.nhan)+' xu web ('+(net>=0?'+':'')+fmt(net)+')'; }
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

  // ---------- shop (A xu web / B diem hoat dong) ----------
  var SHOP={ds:[]};
  function giaHtml(x,sl){ return (x.tien==='diem'?'<span class="gem s"></span>':'<span class="coin s"></span>')+fmt(x.gia*(sl||1)); }
  function shopCard(x){
    var tags=[];
    if(x.gh.tong!=null) tags.push('Mỗi tài khoản '+x.gh.tong+' (đã mua '+x.da.tong+')');
    if(x.gh.tuan!=null) tags.push('Mỗi tuần '+x.gh.tuan+' (đã mua '+x.da.tuan+')');
    if(x.gh.ngay!=null) tags.push('Mỗi ngày '+x.gh.ngay+' (hôm nay '+x.da.ngay+')');
    if(x.kho!=null) tags.push('Còn '+fmt(x.kho)+' món toàn server');
    tags.push(x.han?('Hạn '+x.han+' ngày'):'Vĩnh viễn'); if(x.khoa) tags.push('Khóa');
    if(x.ketThuc) tags.push('Bán đến '+esc(x.ketThuc));
    var het=x.con===0, nhieu=x.con===null||x.con>1;
    return '<div class="si q'+x.q+'"><div class="top2"><div class="sic" style="border-color:'+esc(x.mau)+'"><img src="'+esc(x.hinh)+'" alt=""></div>'
      +'<div><b class="sit">'+esc(x.ten)+'</b><div class="sim">'+esc(x.moTa||'')+'</div></div></div>'
      +'<div class="sil">'+tags.map(function(t,i){ return '<span'+(het&&i===0?' class="het"':'')+'>'+esc(t)+'</span>'; }).join('')+'</div>'
      +'<div class="sif"><div class="price '+x.tien+'" data-p="'+x.id+'">'+giaHtml(x)+'</div>'
      +(nhieu&&!het?'<input type="number" min="1" max="'+(x.con||99)+'" value="1" data-sl="'+x.id+'">':'')
      +'<button class="b '+(x.tien==='diem'?'blue':'go')+'" data-mua="'+x.id+'"'+(het?' disabled':'')+'>'+(het?'HẾT':'MUA')+'</button></div></div>';
  }
  function shopRender(el,list){
    if(!list.length){ el.innerHTML='<div class="empty">Kệ này chưa có hàng.</div>'; return; }
    var ke={}, thuTu=[]; list.forEach(function(x){ if(!ke[x.ke]){ ke[x.ke]=[]; thuTu.push(x.ke); } ke[x.ke].push(x); });
    el.innerHTML=thuTu.map(function(k){ return '<div class="kehd">'+esc(k)+'</div><div class="shopgrid">'+ke[k].map(shopCard).join('')+'</div>'; }).join('');
    el.querySelectorAll('[data-sl]').forEach(function(i){ i.oninput=function(){ var x=SHOP.ds.filter(function(y){ return y.id===+i.dataset.sl; })[0]; var sl=Math.max(1,parseInt(i.value,10)||1); el.querySelector('[data-p="'+x.id+'"]').innerHTML=giaHtml(x,sl); }; });
    el.querySelectorAll('[data-mua]').forEach(function(b){ b.onclick=function(){ shopBuy(+b.dataset.mua); }; });
  }
  function shopLoad(){
    api('/api/shop').then(function(r){
      if(!r||!r.success){ $('shopDiem').innerHTML=$('shopXu').innerHTML='<div class="empty">'+esc((r&&r.message)||'Không tải được shop.')+'</div>'; return; }
      SHOP.ds=r.data.ds; setBal(r.data.xu); setDiem(r.data.diem);
      if(!r.data.mo){ $('shopDiem').innerHTML=$('shopXu').innerHTML='<div class="empty"><b>Shop đang tạm đóng</b></div>'; return; }
      shopRender($('shopDiem'),SHOP.ds.filter(function(x){ return x.tien==='diem'; }));
      shopRender($('shopXu'),SHOP.ds.filter(function(x){ return x.tien==='xu'; }));
    });
  }
  function shopBuy(id){
    var x=SHOP.ds.filter(function(y){ return y.id===id; })[0]; if(!x) return;
    var inp=document.querySelector('[data-sl="'+id+'"]'), sl=inp?Math.max(1,parseInt(inp.value,10)||1):1;
    gConfirm('Mua <b>'+esc(x.ten)+'</b> x'+sl+' với giá <b>'+fmt(x.gia*sl)+' '+(x.tien==='diem'?'điểm hoạt động':'xu web')+'</b>?<br><span class="muted">Đồ vào Rương web, rút vào game khi cần.</span>').then(function(ok){
      if(!ok) return;
      api('/api/shop/mua',{id:id,sl:sl}).then(function(r){
        toast((r&&r.message)||'Có lỗi xảy ra.',!(r&&r.success));
        if(r&&r.success){ setBal(r.data.xu); setDiem(r.data.diem); rgCount(); }
        shopLoad();
      });
    });
  }

  // ---------- gui qua test ----------
  var QT={slots:[],res:[],seq:0,t:0,trang:0};
  var QT_LOAI={1:'Nón',2:'Kính',3:'Tóc',4:'Hiệu ứng mắt',5:'Áo',6:'Mặt',7:'Vũ khí',8:'Vòng tay',9:'Nhẫn',11:'Đạo cụ',13:'Bộ',14:'Dây chuyền',15:'Cánh',16:'Bóng chat',17:'Vũ khí phụ',27:'Vũ khí',31:'Vũ khí phụ',50:'Vũ khí thú',51:'Mũ thú',52:'Áo thú'};
  var QT_PC=['Thường','Thường','Tốt','Hiếm','Sử thi','Huyền thoại','Thần thoại','Tối thượng'];
  function qtTipShow(x,e){
    var cs=x.chiSo||[0,0,0,0], t=$('qtTip');
    t.innerHTML='<b class="tn" style="color:'+esc(x.mau)+'">'+esc(x.ten)+'</b>'
      +'<div class="r"><span>ID</span><span>'+x.id+'</span></div>'
      +'<div class="r"><span>Loại</span><span>'+esc(QT_LOAI[x.cat]||('loại '+x.cat))+'</span></div>'
      +(x.q!=null?'<div class="r"><span>Phẩm chất</span><span style="color:'+esc(x.mau)+'">'+esc(QT_PC[x.q]||x.q)+'</span></div>':'')
      +(x.lv?'<div class="r"><span>Cấp yêu cầu</span><span>'+x.lv+'</span></div>':'')
      +(x.gt===1?'<div class="r"><span>Giới tính</span><span>Nam</span></div>':x.gt===2?'<div class="r"><span>Giới tính</span><span>Nữ</span></div>':'')
      +(cs[0]?'<div class="r"><span>Tấn công</span><span>'+cs[0]+'</span></div>':'')
      +(cs[1]?'<div class="r"><span>Phòng thủ</span><span>'+cs[1]+'</span></div>':'')
      +(cs[2]?'<div class="r"><span>Nhanh nhẹn</span><span>'+cs[2]+'</span></div>':'')
      +(cs[3]?'<div class="r"><span>May mắn</span><span>'+cs[3]+'</span></div>':'')
      +(x.cs?'<div class="r cs"><span>Cường hóa</span><span>được (tối đa +12)</span></div>':'')
      +(x.moTa?'<div class="d">'+esc(x.moTa)+'</div>':'');
    t.style.display='block'; qtTipMove(e);
  }
  function qtTipMove(e){ var t=$('qtTip'), x=e.clientX+16, y=e.clientY+16; if(x+285>window.innerWidth) x=e.clientX-286; if(y+t.offsetHeight>window.innerHeight) y=window.innerHeight-t.offsetHeight-8; t.style.left=x+'px'; t.style.top=y+'px'; }
  function qtTipHide(){ $('qtTip').style.display='none'; }
  function qtRender(){
    var h=QT.slots.map(function(x,i){ return '<div class="qtrow"><div class="ic" style="border-color:'+esc(x.mau)+'"><img src="'+esc(x.hinh)+'" alt=""></div>'
      +'<div class="nm"><b>'+esc(x.ten)+'</b><span>ID '+x.id+(x.gt===1?' · nam':x.gt===2?' · nữ':'')+'</span></div>'
      +'<label>Số lượng<input type="number" min="1" max="999" value="'+x.sl+'" data-k="sl" data-i="'+i+'"></label>'
      +(x.cs?'<label>Cường hóa<input type="number" min="0" max="12" value="'+x.cuong+'" data-k="cuong" data-i="'+i+'"></label>':'')
      +'<label>Hạn (ngày)<input type="number" min="0" value="'+x.han+'" data-k="han" data-i="'+i+'" title="0 = vĩnh viễn"></label>'
      +'<button class="x" data-del="'+i+'" title="Bỏ">×</button></div>'; }).join('');
    for(var k=QT.slots.length;k<5;k++) h+='<div class="qtempty">Ô '+(k+1)+': bấm vào vật phẩm bên phải để thêm</div>';
    $('qtSlots').innerHTML=h; $('qtBtn').disabled=!QT.slots.length;
    $('qtSlots').querySelectorAll('input[data-k]').forEach(function(inp){ inp.oninput=function(){ QT.slots[+inp.dataset.i][inp.dataset.k]=Math.max(0,parseInt(inp.value,10)||0); }; });
    $('qtSlots').querySelectorAll('[data-del]').forEach(function(b){ b.onclick=function(){ QT.slots.splice(+b.dataset.del,1); qtTipHide(); qtRender(); }; });
    $('qtSlots').querySelectorAll('.qtrow .ic').forEach(function(ic,i){ ic.onmouseenter=function(e){ qtTipShow(QT.slots[i],e); }; ic.onmousemove=qtTipMove; ic.onmouseleave=qtTipHide; });
  }
  // o chon loai: chi cac loai co mon dua vao game duoc, dung gioi tinh nhan vat, kem so mon (/api/quatest/loai)
  function qtLoaiLoad(){
    api('/api/quatest/loai',{}).then(function(r){
      if(!r||!r.success) return;
      var s=$('qtCat'), cu=s.value;
      s.innerHTML='<option value="0">Tất cả loại ('+fmt(r.data.tong)+')</option>'+r.data.ds.map(function(x){ QT_LOAI[x.cat]=x.ten; return '<option value="'+x.cat+'">'+esc(x.ten)+' ('+fmt(x.n)+')</option>'; }).join('');
      s.value=cu; if(s.value!==cu) s.value='0';
      qtSearch();
    });
  }
  function qtSearch(them){
    var q=$('qtQ').value.trim(), cat=$('qtCat').value, my=++QT.seq, trang=them?QT.trang+1:0;
    if(!them) $('qtInfo').textContent='Đang tìm...';
    $('qtMore').disabled=true;
    api('/api/quatest/tim',{q:q,cat:cat,trang:trang}).then(function(r){
      if(my!==QT.seq) return;
      $('qtMore').disabled=false;
      if(!r||!r.success){ $('qtInfo').textContent=(r&&r.message)||'Lỗi khi tìm.'; return; }
      var d=r.data, tu=them?QT.res.length:0;
      QT.trang=d.trang; QT.res=them?QT.res.concat(d.ds):d.ds;
      $('qtInfo').textContent=d.tong?('Tìm thấy '+fmt(d.tong)+' món, đang hiện '+fmt(QT.res.length)+'. Bấm vào ô để thêm.'):'Không thấy vật phẩm nào.';
      $('qtMore').style.display=d.con?'block':'none';
      var h=d.ds.map(function(x,k){ return '<div class="qtc" data-i="'+(tu+k)+'"><div class="ic" style="border-color:'+esc(x.mau)+'"><img src="'+esc(x.hinh)+'" alt="" loading="lazy"><small>'+x.id+'</small></div><span>'+esc(x.ten)+'</span></div>'; }).join('');
      if(them) $('qtRes').insertAdjacentHTML('beforeend',h); else $('qtRes').innerHTML=h;
      $('qtRes').querySelectorAll('.qtc:not([data-on])').forEach(function(el){ el.dataset.on=1; el.onclick=function(){
        if(QT.slots.length>=5){ toast('Đã đủ 5 ô, bỏ bớt một món trước.',true); return; }
        var x=QT.res[+el.dataset.i]; QT.slots.push({id:x.id,ten:x.ten,mau:x.mau,hinh:x.hinh,cs:x.cs,gt:x.gt,cat:x.cat,q:x.q,lv:x.lv,chiSo:x.chiSo,moTa:x.moTa,sl:1,cuong:x.cs?12:0,han:0}); qtTipHide(); qtRender(); };
        el.onmouseenter=function(e){ qtTipShow(QT.res[+el.dataset.i],e); }; el.onmousemove=qtTipMove; el.onmouseleave=qtTipHide; });
    });
  }
  $('qtQ').addEventListener('input',function(){ clearTimeout(QT.t); QT.t=setTimeout(function(){ qtSearch(); },300); });
  $('qtCat').addEventListener('change',function(){ qtSearch(); });
  $('qtMore').addEventListener('click',function(){ qtSearch(true); });
  $('qtFind').addEventListener('click',function(){ clearTimeout(QT.t); qtSearch(); });
  $('qtQ').addEventListener('keydown',function(e){ if(e.key==='Enter'){ clearTimeout(QT.t); qtSearch(); } });
  $('qtBtn').addEventListener('click',function(){
    if(!QT.slots.length) return;
    $('qtBtn').disabled=true;
    api('/api/quatest/gui',{ds:JSON.stringify(QT.slots.map(function(x){ return {id:x.id,sl:x.sl,cuong:x.cuong,han:x.han}; }))}).then(function(r){
      var m=$('qtMsg'); m.className='msg '+(r&&r.success?'ok':'err'); m.textContent=(r&&r.message)||'Có lỗi xảy ra.';
      if(r&&r.success){ toast(r.message); QT.slots=[]; qtRender(); } else $('qtBtn').disabled=false;
    });
  });
  qtRender();

  // ---------- ruong ----------
  var RG={ds:[],sel:[]};
  function rgCount(){ api('/api/ruong').then(function(r){ if(r&&r.success){ var n=r.data.ds.length; $('rgN').style.display=n?'':'none'; $('rgN').textContent=n; $('tRg').textContent=n?(n+' món chờ rút vào game'):'Rương trống'; hot('qRg',n); } }); }
  function rgLoad(){
    api('/api/ruong').then(function(r){
      if(!r||!r.success) return;
      RG.ds=r.data.ds; RG.sel=RG.sel.filter(function(id){ return RG.ds.some(function(x){ return x.id===id; }); });
      var n=RG.ds.length; $('rgN').style.display=n?'':'none'; $('rgN').textContent=n; $('tRg').textContent=n?(n+' món chờ rút vào game'):'Rương trống'; hot('qRg',n);
      $('rgGrid').innerHTML=n?RG.ds.map(function(x){
        return '<div class="ri'+(RG.sel.indexOf(x.id)>=0?' on':'')+'" data-id="'+x.id+'"><div class="ic" style="border-color:'+esc(x.mau)+'"><img src="'+esc(x.hinh)+'" alt="">'+(x.sl>1?'<b>x'+fmt(x.sl)+'</b>':'')+'</div>'
          +'<div><div class="tn">'+esc(x.ten)+(x.cuong?' +'+x.cuong:'')+'</div><div class="sn">'+(x.han?x.han+' ngày':'Vĩnh viễn')+(x.khoa?' · khóa':'')+'</div><div class="sn">'+esc(x.nguon||'')+'</div></div><span class="ck"></span></div>'; }).join('')
        :'<div class="empty" style="grid-column:1/-1"><b>Rương trống</b>Lật thẻ sau phó bản để nhận đồ vào đây.</div>';
      $('rgGrid').querySelectorAll('.ri').forEach(function(el){ el.onclick=function(){ var id=+el.dataset.id, i=RG.sel.indexOf(id);
        if(i>=0) RG.sel.splice(i,1); else { if(RG.sel.length>=50){ toast('Tối đa 50 ô mỗi lần rút.',true); return; } RG.sel.push(id); }
        el.classList.toggle('on',RG.sel.indexOf(id)>=0); rgBtn(); }; });
      rgBtn();
    });
  }
  function rgBtn(){ var n=RG.sel.length, t=Math.ceil(n/5); $('rgBtn').disabled=!n; $('rgBtn').textContent=n?('Rút '+n+' món ('+t+' thư)'):'Rút vào game';
    $('rgAll').textContent=(RG.ds.length&&n>=Math.min(50,RG.ds.length))?'Bỏ chọn':'Chọn tất cả'; }
  $('rgAll').addEventListener('click',function(){
    if(RG.ds.length&&RG.sel.length>=Math.min(50,RG.ds.length)) RG.sel=[]; else RG.sel=RG.ds.slice(0,50).map(function(x){ return x.id; });
    document.querySelectorAll('#rgGrid .ri').forEach(function(el){ el.classList.toggle('on',RG.sel.indexOf(+el.dataset.id)>=0); }); rgBtn();
  });
  $('rgBtn').addEventListener('click',function(){
    if(!RG.sel.length) return;
    gConfirm('Gửi <b>'+RG.sel.length+' món</b> vào hộp thư trong game, chia thành <b>'+Math.ceil(RG.sel.length/5)+' thư</b> (5 món/thư)?').then(function(ok){
      if(!ok) return; $('rgBtn').disabled=true;
      api('/api/ruong/rut',{ids:RG.sel}).then(function(r){ toast((r&&r.message)||'Có lỗi xảy ra.',!(r&&r.success)); if(r&&r.success) RG.sel=[]; rgLoad(); });
    });
  });

  // nap so lieu nho cho trang chu ho so + nhan so tren menu
  refreshBal(); rgCount(); ddLoad(); loaded.diemdanh=1;
  api('/api/latthe').then(function(r){ if(r&&r.success){ var n=r.data.ds.length; $('ltN').style.display=n?'':'none'; $('ltN').textContent=n; $('tLt').textContent=n?('Có '+n+' lượt lật đang chờ!'):'Đánh boss là có lượt'; hot('qLt',n); } });
  go((location.hash||'#hoso').slice(1));
})();
</script>
</body>
</html>
