<?php if (!defined('GN_ADMIN')) exit;
$MAXSTR = max_strength($conn);
// Loai vat pham (Shop_Goods.CategoryID) hay dung, theo EquipType cua client
$CATS = [0=>'Tất cả loại',7=>'Vũ khí',1=>'Mũ',2=>'Kính',3=>'Tóc',4=>'Hiệu ứng mắt',5=>'Áo',6=>'Mặt',8=>'Vòng tay',9=>'Nhẫn',13=>'Bộ trang phục',
  14=>'Dây chuyền',15=>'Cánh',17=>'Vũ khí phụ',11=>'Đạo cụ',24=>'Đạo cụ khác',25=>'Hộp quà',26=>'Thẻ',18=>'Hộp thẻ',35=>'Trứng thú cưng',34=>'Thức ăn thú',
  50=>'Vũ khí thú',51=>'Mũ thú',52=>'Áo thú',12=>'Vật phẩm nhiệm vụ',20=>'Kinh nghiệm'];
?>
<style>
  .gift{display:grid;grid-template-columns:480px 1fr;gap:16px}
  .slots{display:grid;grid-template-columns:66px repeat(5,1fr);gap:8px;margin-top:10px}
  .slot,.slab{display:flex;flex-direction:column;gap:5px}
  .slab div{font-size:12px;color:var(--muted);display:flex;align-items:center;white-space:nowrap}
  .slab .h64{height:64px} .slab .h28{height:28px} .slab .h30{height:30px} .slab .h20{height:20px}
  .slot input[type=number]{height:30px}
  .slot label{height:20px}
  .cell{position:relative;width:64px;height:64px;border-radius:10px;background:#0d1626;border:2px solid #2a3756;display:flex;align-items:center;justify-content:center;cursor:pointer;transition:transform .08s,box-shadow .15s;margin:0 auto}
  .cell img{width:52px;height:52px;object-fit:contain;image-rendering:auto}
  .cell:hover{transform:translateY(-2px);box-shadow:0 6px 16px rgba(0,0,0,.45)}
  .cell .id{position:absolute;left:0;right:0;bottom:-1px;font-size:10px;line-height:13px;text-align:center;background:rgba(5,10,20,.82);color:#cfe0ff;border-radius:0 0 8px 8px}
  .cell.empty{border-style:dashed;cursor:default;color:#56688a;font-size:26px}
  .cell.empty:hover{transform:none;box-shadow:none}
  .cell .x{position:absolute;top:-8px;right:-8px;width:20px;height:20px;border-radius:50%;background:#b4232f;color:#fff;font-size:13px;line-height:20px;text-align:center;border:0;cursor:pointer;display:none}
  .cell.filled .x{display:block}
  .slot input[type=number]{padding:5px 6px;font-size:12px}
  .slot .nm{font-size:11px;color:var(--muted);text-align:center;height:28px;overflow:hidden;line-height:14px}
  .slot label{font-size:11px;color:var(--muted);display:flex;gap:4px;align-items:center;justify-content:center}
  .res{display:grid;grid-template-columns:repeat(auto-fill,minmax(84px,1fr));gap:12px 8px;margin-top:12px;max-height:560px;overflow:auto;padding:4px}
  .ri{display:flex;flex-direction:column;align-items:center;gap:4px}
  .ri .nm{font-size:11px;color:var(--text);text-align:center;line-height:14px;height:28px;overflow:hidden;width:84px}
  .tip{position:fixed;z-index:50;pointer-events:none;width:300px;background:#0f1828;border:1px solid #3a4a6e;border-radius:10px;padding:11px 12px;font-size:12px;color:var(--text);box-shadow:0 10px 30px rgba(0,0,0,.6);display:none}
  .tip b{font-size:14px;display:block;margin-bottom:4px}
  .tip .r{display:flex;justify-content:space-between;color:var(--muted)} .tip .r span:last-child{color:var(--text)}
  .tip .d{margin-top:6px;color:#9fb1cc;line-height:1.45}
  .msgline{font-size:12px;margin-top:8px;min-height:16px}
  @media(max-width:980px){.gift{grid-template-columns:1fr}}
</style>

<h2>Gửi quà qua thư</h2>
<div class="note">Quà vào <b>hộp thư</b> nên an toàn cả khi người chơi đang online. Tối đa 5 vật phẩm mỗi thư. Hạn tính bằng ngày, 0 là vĩnh viễn. Vật phẩm và vàng/xu về 2 thư riêng.</div>

<div class="gift">
  <form class="box" method="post" id="mailForm"><?= csrf() ?><input type="hidden" name="act" value="mail">
    <h3>Ô quà</h3>
    <div class="slots" id="slots">
      <div class="slab"><div class="h64"></div><div class="h28"></div><div class="h30">Số lượng</div><div class="h30">Hạn (ngày)</div><div class="h30">Cường hóa +</div><div class="h20">Khóa</div></div>
      <?php for($i=0;$i<5;$i++): ?>
      <div class="slot" data-i="<?= $i ?>">
        <div class="cell empty" data-i="<?= $i ?>">+<button type="button" class="x" title="Gỡ">×</button></div>
        <div class="nm">&nbsp;</div>
        <input type="hidden" name="tid[]" value="">
        <input name="cnt[]" type="number" min="1" value="1" title="Số lượng">
        <input name="day[]" type="number" min="0" value="0" title="Hạn (ngày, 0 = vĩnh viễn)">
        <input name="str[]" type="number" min="0" max="<?= $MAXSTR ?>" value="0" title="Cường hóa (0 đến <?= $MAXSTR ?>)">
        <label><input name="bind[<?= $i ?>]" type="checkbox" value="1" title="Khóa (không giao dịch được)"></label>
      </div>
      <?php endfor; ?>
    </div>
    <div class="muted" style="margin-top:6px">Hạn 0 là vĩnh viễn. Cường hóa từ 0 đến <?= $MAXSTR ?> (giới hạn của server). Khóa: vật phẩm không giao dịch được.</div>

    <h3 style="margin-top:16px">Người nhận</h3>
    <div class="row" style="flex-wrap:wrap">
      <label style="flex:0 0 auto"><input type="radio" name="to" value="one" checked> Một tài khoản</label>
      <label style="flex:0 0 auto"><input type="radio" name="to" value="online"> Đang online</label>
      <label style="flex:0 0 auto"><input type="radio" name="to" value="all"> Tất cả</label>
    </div>
    <input name="user" placeholder="Tài khoản (khi chọn Một tài khoản)" class="mt">
    <input name="title" class="mt" value="Quà từ GunnyNetco4">
    <textarea name="content" rows="2" placeholder="Nội dung thư" class="mt"></textarea>
    <div class="row"><input name="gold" type="number" min="0" placeholder="Vàng"><input name="money" type="number" min="0" placeholder="Xu"></div>
    <button class="btn mt" style="width:100%">GỬI THƯ</button>
  </form>

  <div class="box">
    <h3>Tìm vật phẩm</h3>
    <div class="row">
      <input id="q" placeholder="Nhập ID hoặc tên vật phẩm, vd: 7003 hoặc AK" autocomplete="off" style="flex:2">
      <select id="cat"><?php foreach($CATS as $k=>$v) echo '<option value="'.$k.'">'.h($v).'</option>'; ?></select>
    </div>
    <div class="row" style="margin-top:6px"><select id="imgMode" title="Món client không có file ảnh: vào game sẽ không thấy hình">
      <option value="co">Chỉ món có ảnh (mặc định)</option><option value="all">Tất cả món</option><option value="khong">Chỉ món KHÔNG có ảnh (để test)</option></select></div>
    <div class="msgline muted" id="info">Gõ ID hoặc tên để tìm. Bấm vào ô để thêm vào ô quà.</div>
    <div class="res" id="res"></div>
  </div>
</div>
<div class="tip" id="tip"></div>

<script>
(function(){
  var CAT=<?= json_encode($CATS, JSON_UNESCAPED_UNICODE) ?>;
  var qEl=document.getElementById('q'), catEl=document.getElementById('cat'), res=document.getElementById('res'), info=document.getElementById('info'), tip=document.getElementById('tip');
  var timer=null, seq=0;
  function esc(s){ return String(s==null?'':s).replace(/[&<>"]/g,function(c){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c];}); }
  function cellHtml(it){ return '<img src="'+esc(it.icon)+'" alt="" loading="lazy"><span class="id">'+it.id+'</span>'; }

  function search(){
    var q=qEl.value.trim(), cat=catEl.value, my=++seq;
    if(!q && cat==='0' && document.getElementById('imgMode').value!=='khong'){ res.innerHTML=''; info.textContent='Gõ ID hoặc tên để tìm. Bấm vào ô để thêm vào ô quà.'; return; }
    info.textContent='Đang tìm...';
    fetch('?ajax=items&q='+encodeURIComponent(q)+'&cat='+cat+'&img='+document.getElementById('imgMode').value,{credentials:'same-origin'}).then(function(r){return r.json();}).then(function(d){
      if(my!==seq) return;
      var items=(d&&d.items)||[]; info.textContent=items.length?('Tìm thấy '+items.length+(items.length>=90?' (hiện 90 đầu)':'')+'. Bấm vào ô để thêm.'):'Không thấy vật phẩm nào.';
      if(d&&d.hidden) info.textContent+=' Đã ẩn '+d.hidden+' món client không có ảnh.';
      res.innerHTML=items.map(function(it,i){ return '<div class="ri"><div class="cell" data-k="'+i+'" style="border-color:'+it.color+'">'+cellHtml(it)+'</div><div class="nm">'+esc(it.name)+'</div></div>'; }).join('');
      res._items=items;
    }).catch(function(){ info.textContent='Lỗi khi tìm, thử lại.'; });
  }
  document.getElementById('imgMode').addEventListener('change',search);
  qEl.addEventListener('input',function(){ clearTimeout(timer); timer=setTimeout(search,280); });
  catEl.addEventListener('change',search);

  // tooltip kieu the vat pham
  function showTip(it,e){
    var s='<b style="color:'+it.color+'">'+esc(it.name)+'</b>'
      +'<div class="r"><span>ID</span><span>'+it.id+'</span></div>'
      +'<div class="r"><span>Loại</span><span>'+esc(CAT[it.cat]||('loại '+it.cat))+'</span></div>'
      +(it.lv?'<div class="r"><span>Cấp yêu cầu</span><span>'+it.lv+'</span></div>':'')
      +(it.sex===1?'<div class="r"><span>Giới tính</span><span>Nam</span></div>':it.sex===2?'<div class="r"><span>Giới tính</span><span>Nữ</span></div>':'')
      +(it.atk?'<div class="r"><span>Tấn công</span><span>'+it.atk+'</span></div>':'')
      +(it.def?'<div class="r"><span>Phòng thủ</span><span>'+it.def+'</span></div>':'')
      +(it.agi?'<div class="r"><span>Nhanh nhẹn</span><span>'+it.agi+'</span></div>':'')
      +(it.luck?'<div class="r"><span>May mắn</span><span>'+it.luck+'</span></div>':'')
      +(it.desc?'<div class="d">'+esc(it.desc)+'</div>':'')
      +(it.img===false?'<div class="d" style="color:#ff5d6c">Client không có ảnh món này: vào game sẽ không thấy hình, không nên gửi.</div>':'')
      +(it.gold?'<div class="d" style="color:#ffd76a">Vũ khí này dát vàng được: cường hóa +12 rồi dùng Châu báu chúc phúc công kích (11560)</div>':'')
      +(it.box?'<div class="d" style="color:var(--text)"><b style="font-size:12px;margin:2px 0">Mở ra nhận</b>'+it.box.map(function(b){
          return '<div class="r"><span>'+esc(b.name||('ID '+b.id))+(b.cnt>1?' x'+b.cnt:'')+(b.str?' +'+b.str:'')+(b.days?' ('+b.days+' ngày)':'')+' <span style="color:#6f86a8">#'+b.id+'</span></span><span>'+(b.rate>=100?'chắc chắn':b.rate+'%')+'</span></div>';
        }).join('')+(it.box.length&&it.box[it.box.length-1].more?'<div class="r"><span>... còn nữa</span></div>':'')+'</div>':'');
    tip.innerHTML=s; tip.style.display='block'; moveTip(e);
  }
  function moveTip(e){ var x=e.clientX+16, y=e.clientY+16; if(x+310>window.innerWidth) x=e.clientX-316; if(y+tip.offsetHeight>window.innerHeight) y=window.innerHeight-tip.offsetHeight-8; tip.style.left=x+'px'; tip.style.top=y+'px'; }
  res.addEventListener('mouseover',function(e){ var c=e.target.closest('.cell'); if(c&&res._items) showTip(res._items[+c.dataset.k],e); });
  res.addEventListener('mousemove',function(e){ if(tip.style.display==='block') moveTip(e); });
  res.addEventListener('mouseout',function(e){ if(!e.relatedTarget||!e.relatedTarget.closest||!e.relatedTarget.closest('.cell')) tip.style.display='none'; });

  // o qua
  var slotData=[null,null,null,null,null];
  function renderSlot(i){
    var sl=document.querySelector('.slot[data-i="'+i+'"]'), cell=sl.querySelector('.cell'), it=slotData[i];
    sl.querySelector('input[name="tid[]"]').value=it?it.id:'';
    sl.querySelector('.nm').textContent=it?it.name:' ';
    if(it){ cell.className='cell filled'; cell.style.borderColor=it.color; cell.innerHTML=cellHtml(it)+'<button type="button" class="x" title="Gỡ">×</button>'; }
    else { cell.className='cell empty'; cell.style.borderColor=''; cell.innerHTML='+<button type="button" class="x" title="Gỡ">×</button>'; }
  }
  res.addEventListener('click',function(e){
    var c=e.target.closest('.cell'); if(!c||!res._items) return;
    var it=res._items[+c.dataset.k], i=slotData.indexOf(null);
    if(i<0){ info.textContent='Đã đủ 5 ô quà, gỡ bớt một ô trước.'; return; }
    slotData[i]=it; renderSlot(i); info.textContent='Đã thêm '+it.name+' vào ô '+(i+1)+'.';
  });
  document.getElementById('slots').addEventListener('click',function(e){
    if(!e.target.classList.contains('x')) return; var i=+e.target.closest('.slot').dataset.i; slotData[i]=null; renderSlot(i);
  });
  document.getElementById('slots').addEventListener('mouseover',function(e){ var c=e.target.closest('.cell.filled'); if(c){ var it=slotData[+c.dataset.i]; if(it) showTip(it,e);} });
  document.getElementById('slots').addEventListener('mousemove',function(e){ if(tip.style.display==='block') moveTip(e); });
  document.getElementById('slots').addEventListener('mouseout',function(){ tip.style.display='none'; });
})();
</script>
