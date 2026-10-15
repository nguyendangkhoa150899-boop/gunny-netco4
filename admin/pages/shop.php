<?php if (!defined('GN_ADMIN')) exit;
// Shop web (gunny.netco4.click/dashboard > Shop). Bang: _setup/sql/shop-web.sql (Db_Member.Web_Shop, Web_ShopMua, Web_Diem).
$has = (int)scalar($conn,"SELECT CASE WHEN OBJECT_ID('Db_Member.dbo.Web_Shop') IS NULL THEN 0 ELSE 1 END");
if (!$has) { echo '<h2>Shop web</h2><div class="box">Chưa có bảng. Chạy trên VPS: <code>sqlcmd -S localhost -E -C -b -f 65001 -i C:\Gunny92\_setup\sql\shop-web.sql</code></div>'; return; }
$hang = q($conn,"SELECT s.*, ISNULL(g.Name,'') Name, ISNULL(g.CategoryID,0) Cat, ISNULL(g.Pic,'') Pic, ISNULL(g.NeedSex,0) Sex, ISNULL(g.Quality,0) Q,
  (SELECT ISNULL(SUM(m.SoLuong),0) FROM Db_Member.dbo.Web_ShopMua m WHERE m.ShopID=s.ID) daBan,
  (SELECT ISNULL(SUM(m.SoLuong),0) FROM Db_Member.dbo.Web_ShopMua m WHERE m.ShopID=s.ID AND m.ThoiGian>=CAST(GETDATE() AS date)) banHomNay
  FROM Db_Member.dbo.Web_Shop s LEFT JOIN Db_Tank.dbo.Shop_Goods g ON g.TemplateID=s.TemplateID ORDER BY s.Tien DESC, s.ThuTu, s.ID");
$tk = q($conn,"SELECT
  (SELECT ISNULL(SUM(CAST(Gia AS bigint)*SoLuong),0) FROM Db_Member.dbo.Web_ShopMua WHERE Tien='xu' AND ThoiGian>=CAST(GETDATE() AS date)) xu,
  (SELECT ISNULL(SUM(CAST(Gia AS bigint)*SoLuong),0) FROM Db_Member.dbo.Web_ShopMua WHERE Tien='diem' AND ThoiGian>=CAST(GETDATE() AS date)) diem,
  (SELECT ISNULL(SUM(CAST(Diem AS bigint)),0) FROM Db_Member.dbo.Web_Diem) diemLuuHanh")[0];
$topD = q($conn,"SELECT TOP 10 a.Email, d.Diem FROM Db_Member.dbo.Web_Diem d JOIN Db_Member.dbo.Mem_Account a ON a.UserID=d.MemberID WHERE d.Diem>0 ORDER BY d.Diem DESC");
$maxStr = max_strength($conn);
$gh = fn($v)=>$v===null?'':(int)$v;
?>
<style>.lbl{display:flex;flex-direction:column;gap:4px;flex:1;min-width:0;font-size:12px;color:var(--muted)} .lbl > span{white-space:nowrap} td form{margin:0} .sm{width:74px} .tag.diem{background:rgba(139,92,246,.2);color:#cdb4ff} .tag.xu{background:rgba(255,207,92,.15);color:#ffcf5c}</style>
<h2>Shop web</h2>
<div class="note">2 loại tiền: <b>xu web</b> (đổi 1:1 với xu game, ai cũng có nhiều) và <b>điểm hoạt động</b> (chỉ kiếm từ điểm danh +10/ngày, mốc 7/14/21/28 ngày +20, đánh xong boss phó bản +5 tối đa 50/ngày; <b>không đổi từ xu được</b> nên acc phụ không dồn được). Đồ hiếm nên bán bằng điểm. Đồ mua vào Rương web rồi rút vào game. Chỉ bán đồ <b>client có</b> (tìm ở Gửi quà chế độ "Chỉ món có ảnh"). Giới hạn để trống = không giới hạn.</div>
<div class="grid2">
  <div class="box"><h3>Hôm nay</h3>
    <div>Bán được: <b><?= n($tk['xu']) ?></b> xu web · <b><?= n($tk['diem']) ?></b> điểm</div>
    <div class="mt">Tổng điểm hoạt động đang lưu hành: <b><?= n($tk['diemLuuHanh']) ?></b></div>
    <h3 class="mt">Nhiều điểm nhất</h3>
    <table><?php foreach($topD as $t): ?><tr><td><?= h($t['Email']) ?></td><td><?= n($t['Diem']) ?></td></tr><?php endforeach; if(!$topD) echo '<tr><td class="muted">Chưa ai có điểm.</td></tr>'; ?></table>
  </div>
  <form class="box" method="post"><?= csrf() ?><input type="hidden" name="act" value="diem_give"><h3>Cộng / trừ điểm hoạt động</h3>
    <div class="row"><label class="lbl"><span>Tài khoản</span><input name="user" placeholder="vd: bialk"></label>
      <label class="lbl"><span>Số điểm (âm để trừ)</span><input name="diem" type="number" placeholder="vd: 500"></label></div>
    <input name="note" placeholder="Ghi chú (người chơi thấy trong lịch sử điểm)" class="mt">
    <button class="btn sm mt">Thực hiện</button></form>
</div>

<h2>Hàng đang có</h2>
<table><tr><th>Vật phẩm</th><th>Kệ</th><th>Tiền / giá</th><th>Giới hạn ngày / tuần / tổng (mỗi tài khoản)</th><th>Kho server</th><th>Đã bán</th><th></th></tr>
<?php foreach($hang as $x): ?>
  <tr<?= $x['BatTat']?'':' style="opacity:.5"' ?>><td><div style="display:flex;align-items:center;gap:10px">
    <img src="<?= h(item_icon_url($x['Cat'],$x['Pic'],$x['Sex'])) ?>" alt="" style="width:40px;height:40px;object-fit:contain;background:#0d1626;border:2px solid <?= quality_color($x['Q']) ?>;border-radius:8px">
    <span><?= h($x['Name'] ?: 'ID '.$x['TemplateID']) ?><?= (int)$x['Count']>1?' x'.(int)$x['Count']:'' ?><br><span class="muted">ID <?= (int)$x['TemplateID'] ?> · <?= (int)$x['ValidDate'] ? (int)$x['ValidDate'].' ngày' : 'vĩnh viễn' ?><?= $x['IsBind']?' · khóa':'' ?></span></span></div></td>
    <td><?= h($x['Ke']) ?></td>
    <td colspan="3"><form method="post" class="row" style="gap:4px;align-items:center;flex-wrap:nowrap"><?= csrf() ?><input type="hidden" name="act" value="shop_upd"><input type="hidden" name="id" value="<?= (int)$x['ID'] ?>">
      <span class="tag <?= h($x['Tien']) ?>"><?= $x['Tien']==='diem'?'điểm':'xu web' ?></span>
      <input name="gia" type="number" min="1" value="<?= (int)$x['Gia'] ?>" style="width:110px" title="Giá">
      <input name="ngay" type="number" min="0" value="<?= $gh($x['GioiHanNgay']) ?>" class="sm" placeholder="ngày" title="Mỗi ngày">
      <input name="tuan" type="number" min="0" value="<?= $gh($x['GioiHanTuan']) ?>" class="sm" placeholder="tuần" title="Mỗi 7 ngày">
      <input name="tong" type="number" min="0" value="<?= $gh($x['GioiHanTong']) ?>" class="sm" placeholder="tổng" title="Trọn đời">
      <input name="kho" type="number" min="0" value="<?= $gh($x['Kho']) ?>" class="sm" placeholder="kho" title="Còn lại toàn server">
      <label style="flex:0;white-space:nowrap"><input type="checkbox" name="bat" value="1" <?= $x['BatTat']?'checked':'' ?>> bán</label>
      <button class="btn sm" style="flex:0">Lưu</button></form></td>
    <td><?= n($x['daBan']) ?><div class="muted">hôm nay <?= n($x['banHomNay']) ?></div></td>
    <td><form method="post"><?= csrf() ?><input type="hidden" name="act" value="shop_del"><input type="hidden" name="id" value="<?= (int)$x['ID'] ?>"><button class="btn sm danger">Xóa</button></form></td></tr>
<?php endforeach; if(!$hang) echo '<tr><td colspan="7" class="muted">Chưa có hàng.</td></tr>'; ?>
</table>

<form class="box mt" method="post"><?= csrf() ?><input type="hidden" name="act" value="shop_add"><h3>Thêm hàng</h3>
  <div class="row"><label class="lbl"><span>ID vật phẩm · <a href="?page=mail" target="_blank">tìm ID</a></span><input name="tid" type="number" min="1" placeholder="vd: 7194"></label>
    <label class="lbl"><span>Kệ (nhóm hiển thị)</span><input name="ke" placeholder="vd: Vũ khí huyền thoại"></label>
    <label class="lbl"><span>Tiền</span><select name="tien"><option value="diem">Điểm hoạt động</option><option value="xu">Xu web</option></select></label>
    <label class="lbl"><span>Giá</span><input name="gia" type="number" min="1" placeholder="vd: 900"></label></div>
  <div class="row"><label class="lbl"><span>Số lượng mỗi lần mua</span><input name="cnt" type="number" min="1" value="1"></label>
    <label class="lbl"><span>Hạn ngày (0 = vĩnh viễn)</span><input name="day" type="number" min="0" value="0"></label>
    <label class="lbl"><span>Cường hóa (0 đến <?= $maxStr ?>)</span><input name="str" type="number" min="0" max="<?= $maxStr ?>" value="0"></label>
    <label class="lbl"><span>Thứ tự (nhỏ lên trước)</span><input name="thutu" type="number" value="100"></label></div>
  <div class="row"><label class="lbl"><span>Giới hạn / ngày</span><input name="ngay" type="number" min="0" placeholder="trống = không"></label>
    <label class="lbl"><span>Giới hạn / tuần</span><input name="tuan" type="number" min="0"></label>
    <label class="lbl"><span>Giới hạn / tài khoản</span><input name="tong" type="number" min="0"></label>
    <label class="lbl"><span>Kho toàn server</span><input name="kho" type="number" min="0"></label></div>
  <div class="row"><label class="lbl"><span>Bắt đầu bán (trống = ngay)</span><input name="bd" type="datetime-local"></label>
    <label class="lbl"><span>Hết bán (trống = mãi)</span><input name="kt" type="datetime-local"></label>
    <label class="lbl" style="justify-content:flex-end"><span><input type="checkbox" name="bind" value="1" checked> Khóa (không giao dịch)</span></label></div>
  <input name="mota" placeholder="Mô tả ngắn hiện cho người chơi, vd: Bản gốc, cường hóa +12 để tiến hóa" class="mt">
  <button class="btn sm mt">Thêm hàng</button></form>
