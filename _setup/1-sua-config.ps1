# 1-sua-config.ps1 — doi ten may DB, IP cu, mat khau sa trong cac file config Gunny (chay TREN VPS).
# Chi sua file text, khong chay gi cua bo Gunny. Chay trong PowerShell: powershell -ExecutionPolicy Bypass -File 1-sua-config.ps1
# Sua $G cho dung noi ban giai nen bo Gunny tren VPS.
$G  = "C:\Gunny92"
$sa = 'Gunny$Sa2026Kx'          # mat khau sa (dat giong luc cai SQL Server)

$files = @(
  "$G\Server\center\Center.Service.exe.config",
  "$G\Server\fight\Fighting.Service.exe.config",
  "$G\Server\road\Road.Service.exe.config",
  "$G\Server\road\battle.xml",
  "$G\Request\Web.config",
  "$G\website_backend\.env"
)
foreach ($f in $files) {
  if (!(Test-Path $f)) { Write-Host "BO QUA (khong thay): $f" -ForegroundColor Yellow; continue }
  $t = [IO.File]::ReadAllText($f)
  $t = $t.Replace('WIN-DME2N9KU5B0','localhost')   # ten may SQL cu -> localhost (cai SQL ban DEFAULT instance)
  $t = $t.Replace('15.235.163.5','127.0.0.1')      # IP VPS cu -> may hien tai
  $t = $t.Replace('abcd@12344',$sa)                # mat khau sa cu -> moi
  [IO.File]::WriteAllText($f, $t)
  Write-Host "da sua: $f" -ForegroundColor Green
}
Write-Host ""
Write-Host "Xong. Neu ban cai SQL Express (instance SQLEXPRESS) thay vi Default, mo lai cac file tren va doi localhost -> localhost\SQLEXPRESS." -ForegroundColor Cyan
