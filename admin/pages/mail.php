<?php if (!defined('GN_ADMIN')) exit;
$find = trim($_GET['find'] ?? '');
$found = [];
if ($find !== '') {
  $found = ctype_digit($find)
    ? q($conn,"SELECT TOP 40 TemplateID,Name,CategoryID,NeedLevel,Quality FROM Db_Tank.dbo.Shop_Goods WHERE TemplateID=?",[(int)$find])
    : q($conn,"SELECT TOP 40 TemplateID,Name,CategoryID,NeedLevel,Quality FROM Db_Tank.dbo.Shop_Goods WHERE Name LIKE ? ORDER BY TemplateID",['%'.$find.'%']);
}
?>
<h2>Gửi quà qua thư</h2>
<div class="note">Gửi qua <code>SendMailAndItem.aspx</code>: quà nằm trong <b>hộp thư</b> nên an toàn cả khi người chơi đang online. Tối đa 5 vật phẩm mỗi thư. Hạn = số ngày, 0 là vĩnh viễn.</div>
<div class="grid2">
  <form class="box" method="post" id="mailForm"><?= csrf() ?><input type="hidden" name="act" value="mail">
    <h3>Người nhận</h3>
    <div class="row" style="flex-wrap:wrap">
      <label style="flex:0 0 auto"><input type="radio" name="to" value="one" checked> Một tài khoản</label>
      <label style="flex:0 0 auto"><input type="radio" name="to" value="online"> Đang online</label>
      <label style="flex:0 0 auto"><input type="radio" name="to" value="all"> Tất cả</label>
    </div>
    <input name="user" placeholder="Tài khoản (khi chọn Một tài khoản)" class="mt">
    <input name="title" placeholder="Tiêu đề thư" class="mt" value="Quà từ GunnyNetco4">
    <textarea name="content" rows="2" placeholder="Nội dung thư" class="mt"></textarea>
    <div class="row"><input name="gold" type="number" min="0" placeholder="Vàng"><input name="money" type="number" min="0" placeholder="Xu"></div>
    <table style="margin:10px 0 0">
      <tr><th>TemplateID</th><th>Số lượng</th><th>Hạn (ngày)</th><th>Cường hóa</th><th>Khóa</th></tr>
      <?php for($i=0;$i<5;$i++): ?>
      <tr><td><input name="tid[]" type="number" min="0" class="tid"></td><td><input name="cnt[]" type="number" min="1" value="1"></td>
          <td><input name="day[]" type="number" min="0" value="0"></td><td><input name="str[]" type="number" min="0" max="15" value="0"></td>
          <td><input name="bind[<?= $i ?>]" type="checkbox" value="1"></td></tr>
      <?php endfor; ?>
    </table>
    <button class="btn mt">Gửi thư</button>
  </form>
  <div class="box">
    <h3>Tìm vật phẩm</h3>
    <form class="row" method="get"><input type="hidden" name="page" value="mail"><input name="find" value="<?= h($find) ?>" placeholder="Tên vật phẩm hoặc TemplateID"><button class="btn sm" style="flex:0">Tìm</button></form>
    <?php if($find!==''): ?>
      <table style="margin-top:10px">
        <tr><th>ID</th><th>Tên</th><th>Loại</th><th>Cấp</th><th></th></tr>
        <?php foreach($found as $f): ?>
          <tr><td><?= (int)$f['TemplateID'] ?></td><td><?= h($f['Name']) ?></td><td><?= (int)$f['CategoryID'] ?></td><td><?= (int)$f['NeedLevel'] ?></td>
              <td><button type="button" class="btn sm blue pick" data-id="<?= (int)$f['TemplateID'] ?>">Chọn</button></td></tr>
        <?php endforeach; if(!$found) echo '<tr><td colspan="5" class="muted">Không thấy.</td></tr>'; ?>
      </table>
    <?php endif; ?>
    <div class="muted mt">Mẹo: loại 7 = vũ khí. Bấm Chọn sẽ điền vào dòng trống đầu tiên bên trái.</div>
  </div>
</div>
<script>
document.querySelectorAll('.pick').forEach(function(b){
  b.addEventListener('click',function(){
    var cells=document.querySelectorAll('#mailForm .tid');
    for(var i=0;i<cells.length;i++){ if(!cells[i].value){ cells[i].value=b.dataset.id; b.textContent='Đã chọn'; return; } }
    b.textContent='Hết chỗ (tối đa 5)';
  });
});
</script>
