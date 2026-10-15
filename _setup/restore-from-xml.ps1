# restore-from-xml.ps1: nap nguoc du lieu con thieu trong Db_Tank tu bo XML client goc (Request/*.xml).
#
# Ly do: tank.bak thieu so voi XML ma server goc da sinh (13/12/2023): QuestList 1115 vs DB 179,
# NPCInfoList 1274 vs 1033, ShopGoodsShowList 1372 vs 1258. Client dung XML, server dung DB -> lech.
#
# Chi THEM dong con thieu (khong sua dong dang co). Chay trong 1 transaction.
# Truoc khi chay: sao luu bang thanh Db_Tank.dbo.bak20261015_<bang> (neu chua co).
#
# Dung (tren VPS, PowerShell admin):
#   powershell -ExecutionPolicy Bypass -File C:\Gunny92\_setup\restore-from-xml.ps1 -DryRun   # chi dem
#   powershell -ExecutionPolicy Bypass -File C:\Gunny92\_setup\restore-from-xml.ps1           # ghi that
# Sau do khoi dong lai Center, Fighting, Road.
# Hoan tac: xoa bang hien tai roi SELECT * INTO <bang> FROM bak20261015_<bang> (xem README).
param([string]$XmlDir = 'C:\Gunny92\Request', [switch]$DryRun)
$ErrorActionPreference = 'Stop'

function Dec($p){ $b=[IO.File]::ReadAllBytes($p); if($b[0] -ne 0x78){ return [Text.Encoding]::UTF8.GetString($b) }
  $ms=New-Object IO.MemoryStream(,$b[2..($b.Length-1)]); $ds=New-Object IO.Compression.DeflateStream($ms,[IO.Compression.CompressionMode]::Decompress)
  (New-Object IO.StreamReader($ds,[Text.Encoding]::UTF8)).ReadToEnd() }

$cn = New-Object System.Data.SqlClient.SqlConnection('Server=localhost;Database=Db_Tank;Integrated Security=SSPI;TrustServerCertificate=True')
$cn.Open()
$tx = $null
function Q($sql){ $c=$cn.CreateCommand(); $c.Transaction=$tx; $c.CommandText=$sql; $c.CommandTimeout=300; $r=$c.ExecuteReader(); $t=New-Object Data.DataTable; $t.Load($r); ,$t }
function X($sql,$p){ $c=$cn.CreateCommand(); $c.Transaction=$tx; $c.CommandText=$sql
  foreach($k in $p.Keys){ $v=$p[$k]; [void]$c.Parameters.AddWithValue('@'+$k, $(if($null -eq $v){[DBNull]::Value}else{$v})) }
  [void]$c.ExecuteNonQuery() }
function Cols($t){ @((Q "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='$t'").Rows | ForEach-Object { $_.COLUMN_NAME }) }
# INSERT tu thuoc tinh XML trung ten cot (bo cot tu tang), cong them $extra
function InsertFromXml($table,$node,$cols,$skip,$extra){
  $p=@{}; foreach($a in $node.Attributes){ if(($cols -contains $a.Name) -and -not ($skip -contains $a.Name)){ $p[$a.Name]=$a.Value } }
  foreach($k in $extra.Keys){ $p[$k]=$extra[$k] }
  $names=@($p.Keys); X ("INSERT INTO [$table](" + (($names | ForEach-Object { "[$_]" }) -join ',') + ") VALUES(" + (($names | ForEach-Object { "@$_" }) -join ',') + ")") $p }

# ---- sao luu ----
foreach($t in 'NPC_Info','Quest','Quest_Condiction','Quest_Goods','ShopGoodsShowList'){
  if((Q "SELECT OBJECT_ID('bak20261015_$t') id").Rows[0].id -is [DBNull]){ [void](Q "SELECT * INTO bak20261015_$t FROM [$t]; SELECT 1 x"); "sao luu: bak20261015_$t" }
}

$tx = $cn.BeginTransaction()
try {
  # ---- NPC ----
  $npcXml=[xml](Dec "$XmlDir\NPCInfoList.xml"); $npcCols=Cols 'NPC_Info'
  $have=@{}; (Q "SELECT ID FROM NPC_Info").Rows | ForEach-Object { $have[[int]$_.ID]=1 }
  # khung va cham (X,Y,Width,Height,speed) lay tu quai co san cung ModelID; khong co thi gia tri pho bien
  $box=@{}; (Q "SELECT ModelID,X,Y,Width,Height,speed FROM NPC_Info").Rows | ForEach-Object { if(-not $box.ContainsKey([string]$_.ModelID)){ $box[[string]$_.ModelID]=$_ } }
  $nNpc=0; $nBoxModel=0
  foreach($it in $npcXml.Result.Item){ if($have.ContainsKey([int]$it.ID)){ continue }
    $b=$box[[string]$it.ModelID]
    if($b){ $nBoxModel++; $e=@{X=$b.X;Y=$b.Y;Width=$b.Width;Height=$b.Height;speed=$b.speed} } else { $e=@{X=-39;Y=-70;Width=75;Height=75;speed=3} }
    $e.Attack=0; $e.CurrentBallId=0
    InsertFromXml 'NPC_Info' $it $npcCols @() $e; $nNpc++ }
  "NPC them: $nNpc (khung lay theo ModelID: $nBoxModel)"

  # ---- Quest + dieu kien + phan thuong ----
  $qXml=[xml](Dec "$XmlDir\QuestList.xml"); $qCols=Cols 'Quest'; $cCols=Cols 'Quest_Condiction'; $gCols=Cols 'Quest_Goods'
  $have=@{}; (Q "SELECT ID FROM Quest").Rows | ForEach-Object { $have[[int]$_.ID]=1 }
  $hasC=@{}; (Q "SELECT DISTINCT QuestID FROM Quest_Condiction").Rows | ForEach-Object { $hasC[[int]$_.QuestID]=1 }
  $hasG=@{}; (Q "SELECT DISTINCT QuestID FROM Quest_Goods").Rows | ForEach-Object { $hasG[[int]$_.QuestID]=1 }
  # phan thuong tro toi vat pham khong co trong Shop_Goods thi bo qua (tra nhiem vu se loi neu giu)
  $items=@{}; (Q "SELECT TemplateID FROM Shop_Goods").Rows | ForEach-Object { $items[[int]$_.TemplateID]=1 }
  $nQ=0;$nC=0;$nG=0;$nGskip=0
  foreach($it in $qXml.Result.Item){ $id=[int]$it.ID; if($have.ContainsKey($id)){ continue }
    InsertFromXml 'Quest' $it $qCols @() @{}; $nQ++
    foreach($ch in $it.ChildNodes){
      if($ch.Name -eq 'Item_Condiction' -and -not $hasC.ContainsKey($id)){ InsertFromXml 'Quest_Condiction' $ch $cCols @('ID') @{}; $nC++ }
      elseif($ch.Name -eq 'Item_Good' -and -not $hasG.ContainsKey($id)){
        $rid=[int]$ch.RewardItemID; if($rid -gt 0 -and -not $items.ContainsKey($rid)){ $nGskip++; continue }
        InsertFromXml 'Quest_Goods' $ch $gCols @('ID') @{}; $nG++ } } }
  "Quest them: $nQ, dieu kien: $nC, phan thuong: $nG (bo qua $nGskip phan thuong tro vat pham khong ton tai)"

  # ---- Shop hien thi ----
  $sXml=[xml](Dec "$XmlDir\ShopGoodsShowList.xml")
  $have=@{}; (Q "SELECT Type,ShopId FROM ShopGoodsShowList").Rows | ForEach-Object { $have["$($_.Type)|$($_.ShopId)"]=1 }
  $nS=0; foreach($it in $sXml.Result.Store.Item){ $k="$($it.Type)|$($it.ShopId)"; if($have.ContainsKey($k)){ continue }; $have[$k]=1
    X "INSERT INTO ShopGoodsShowList(Type,ShopId) VALUES(@t,@s)" @{t=[int]$it.Type;s=[int]$it.ShopId}; $nS++ }
  "Shop hien thi them: $nS"

  # ---- kiem tra tham chieu ----
  "Phan thuong quest tro toi vat pham khong co trong Shop_Goods: " + (Q "SELECT COUNT(*) n FROM Quest_Goods g WHERE RewardItemID>0 AND NOT EXISTS(SELECT 1 FROM Shop_Goods s WHERE s.TemplateID=g.RewardItemID)").Rows[0].n
  "Tong sau: Quest=" + (Q "SELECT COUNT(*) n FROM Quest").Rows[0].n + " NPC=" + (Q "SELECT COUNT(*) n FROM NPC_Info").Rows[0].n + " ShopShow=" + (Q "SELECT COUNT(*) n FROM ShopGoodsShowList").Rows[0].n

  if($DryRun){ $tx.Rollback(); "DRY RUN: da hoan tac, khong ghi gi." } else { $tx.Commit(); "DA GHI. Khoi dong lai Center, Fighting, Road." }
} catch { if($tx){ try{ $tx.Rollback() }catch{} }; "LOI, da hoan tac: " + $_.Exception.Message; exit 1 }
finally { $cn.Close() }
