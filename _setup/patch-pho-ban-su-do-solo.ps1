# patch-pho-ban-su-do-solo.ps1: cho phep danh pho ban dac biet (su do) mot minh.
#
# 4 pho ban dac biet (Gamazon GZS80x, Xatara XDS90x, Daucula DTS70x, Cariga CBS60x) co dieu kien
#   if (base.Game.GetAllLivingPlayers().Count < 2) return true;   // duoi 2 nguoi song -> ket thuc van (thua)
# nen vao 1 nguoi la thua ngay luot dau. Doi thanh "< 1" (het nguoi song moi thua). 2 nguoi tro len van choi nhu cu.
# Script nam trong Server\road\ScriptsPVE (Road tu bien dich luc khoi dong) -> chay xong phai khoi dong lai Road.
# Sao luu file goc thanh <ten>.cs.bak20261015 (chi lan dau). Hoan tac: -Undo.
param([switch]$Undo)
$dir = 'C:\Gunny92\Server\road\ScriptsPVE\AI\Messions'
$files = 'GZS800','GZS801','XDS900','XDS901','DTS700','DTS701','CBS600','CBS601'
foreach ($n in $files) {
  $f = Join-Path $dir "$n.cs"; $b = "$f.bak20261015"
  if (-not (Test-Path $f)) { "khong thay $n.cs"; continue }
  if ($Undo) { if (Test-Path $b) { Copy-Item $b $f -Force; "hoan tac $n" }; continue }
  if (-not (Test-Path $b)) { Copy-Item $f $b }
  # doc/ghi latin1 de giu nguyen tung byte (file co the chua chu tieng Viet ma hoa khac), chi thay doan ASCII
  $L = [Text.Encoding]::GetEncoding(28591)
  $t = $L.GetString([IO.File]::ReadAllBytes($f))
  $new = $t -replace 'GetAllLivingPlayers\(\)\.Count\s*<\s*2', 'GetAllLivingPlayers().Count < 1'
  if ($new -ne $t) { [IO.File]::WriteAllBytes($f, $L.GetBytes($new)); "da sua $n" } else { "$n khong can sua" }
}
"Xong. Khoi dong lai Road de co hieu luc."
