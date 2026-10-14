# 2-go-backdoor-nap.ps1 — go 3 cua sau + route nap tien + file nguy hiem (chay TREN VPS).
# Chay TRUOC khi cho ban be vao / truoc khi mo ra internet. Test localhost mot minh thi chua bat buoc.
# Chi sua/xoa file text + file php, khong chay gi cua bo. powershell -ExecutionPolicy Bypass -File 2-go-backdoor-nap.ps1
$G = "C:\Gunny92"

function XoaDong($f, $mau) {
  if (!(Test-Path $f)) { Write-Host "BO QUA (khong thay): $f" -ForegroundColor Yellow; return }
  $lines = [IO.File]::ReadAllText($f) -split "`r?`n"
  $giu = $lines | Where-Object { $m = $_; -not ($mau | Where-Object { $m -match $_ }) }
  [IO.File]::WriteAllText($f, ($giu -join "`r`n"))
  Write-Host ("da bo {0} dong trong {1}" -f ($lines.Count - $giu.Count), $f) -ForegroundColor Green
}

# website_backend: backdoor nap xu (/chargeTo), dang nhap tai khoan bat ky (/playdebug), job momo
XoaDong "$G\website_backend\routes\web.php" @('/chargeTo/','/playdebug/','/momopaymentJob')
# website_backend api: route nap the / QR ngan hang / momo
XoaDong "$G\website_backend\routes\api.php" @('cardCallback','cardCharge','getBankQrCode','getMomoChargeQr')

# File nguy hiem / khong dung
$xoa = @(
  "$G\Resource.Server\index.php",                 # doc trom bat ky file tren may
  "$G\website_backend\public\klsaflf.php",        # script debug
  "$G\Request\KeyGenerator.ashx",
  "$G\Request\AccountRegister.ashx",
  "$G\Request\SendItemTest.aspx",
  "$G\Request\SentRewardTest.aspx",
  "$G\Request\SubmitTest.aspx",
  "$G\Request\ChargeTest.ashx"
)
foreach ($f in $xoa) { if (Test-Path $f) { Remove-Item $f -Force; Write-Host "da xoa: $f" -ForegroundColor Green } }

# Don log + phien cu cua admin cu (co email / IP / token nguoi choi cu)
foreach ($d in @("$G\website_backend\storage\framework\sessions","$G\website_backend\storage\logs")) {
  if (Test-Path $d) { Get-ChildItem $d -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue; Write-Host "da don: $d" -ForegroundColor Green }
}
Write-Host ""
Write-Host "Da go backdoor + route nap + file nguy hiem. Con lai: doi APP_KEY / KEY_REQUEST / CHARGE_KEY va xoa account cu trong DB (lam o buoc SQL)." -ForegroundColor Cyan
