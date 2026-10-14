# B2-config.ps1 — sua config (localhost + mat khau sa + IP), mo tuong lua, sua file hosts. Chay sau B1.
# PowerShell Admin:  powershell -ExecutionPolicy Bypass -File C:\Gunny92\_setup\B2-config.ps1
$ErrorActionPreference = 'Continue'
$G  = 'C:\Gunny92'
$sa = 'Gunny$Sa2026Kx'

Write-Host "== 1. Sua cac file config ==" -ForegroundColor Cyan
$files = @(
  "$G\Server\center\Center.Service.exe.config",
  "$G\Server\fight\Fighting.Service.exe.config",
  "$G\Server\road\Road.Service.exe.config",
  "$G\Server\road\battle.xml",
  "$G\Request\Web.config",
  "$G\website_backend\.env"
)
foreach ($f in $files) {
  if (!(Test-Path $f)) { Write-Host "   BO QUA: $f" -ForegroundColor Yellow; continue }
  $t = [IO.File]::ReadAllText($f)
  $t = $t.Replace('WIN-DME2N9KU5B0','localhost').Replace('15.235.163.5','127.0.0.1').Replace('abcd@12344',$sa)
  [IO.File]::WriteAllText($f, $t)
  Write-Host "   da sua: $(Split-Path $f -Leaf)" -ForegroundColor Green
}

Write-Host "== 2. Mo cong tuong lua (9200 game, 80 web) ==" -ForegroundColor Cyan
New-NetFirewallRule -DisplayName 'Gunny Game 9200' -Direction Inbound -Protocol TCP -LocalPort 9200 -Action Allow -ErrorAction SilentlyContinue | Out-Null
New-NetFirewallRule -DisplayName 'Gunny Web 80'    -Direction Inbound -Protocol TCP -LocalPort 80   -Action Allow -ErrorAction SilentlyContinue | Out-Null
Write-Host "   da mo 9200 + 80" -ForegroundColor Green

Write-Host "== 3. Sua file hosts (tro domain ve 127.0.0.1) ==" -ForegroundColor Cyan
$hosts = "$env:windir\System32\drivers\etc\hosts"
$dom = 'gunny92.com','launcher.gunny92.com','quest1.gunny92.com','flash1.gunny92.com','res.gunny92.com'
$cur = Get-Content $hosts -Raw
foreach ($d in $dom) { if ($cur -notmatch [regex]::Escape($d)) { Add-Content $hosts "127.0.0.1`t$d" } }
Write-Host "   da them $($dom.Count) domain vao hosts" -ForegroundColor Green
Write-Host ""
Write-Host "XONG B2. Tiep theo: B3-iis-php.ps1" -ForegroundColor Cyan
