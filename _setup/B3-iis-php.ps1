# B3-iis-php.ps1 — bat IIS + CGI, cai URL Rewrite, cai PHP 7.4 + sqlsrv, tao 2 site. Chay sau B2.
# DAY LA BUOC KHO NHAT, de vuong. Loi cho nao chup gui Claude. PowerShell Admin:
#   powershell -ExecutionPolicy Bypass -File C:\Gunny92\_setup\B3-iis-php.ps1
$ErrorActionPreference = 'Continue'
$G    = 'C:\Gunny92'
$inst = 'C:\inst'
$php  = 'C:\PHP7'

Write-Host "== 1. Bat IIS + CGI + ASP.NET 4.8 ==" -ForegroundColor Cyan
$feat = 'Web-Server','Web-CGI','Web-Asp-Net45','Web-Net-Ext45','Web-ISAPI-Ext','Web-ISAPI-Filter','Web-Static-Content','Web-Default-Doc','Web-Http-Errors','Web-Mgmt-Console'
Install-WindowsFeature -Name $feat | Out-Null
Write-Host "   IIS xong" -ForegroundColor Green

Write-Host "== 2. Cai VC++ redist + ODBC + URL Rewrite ==" -ForegroundColor Cyan
if (Test-Path "$inst\vcredist.exe")  { Start-Process "$inst\vcredist.exe" -ArgumentList '/install','/quiet','/norestart' -Wait }
if (Test-Path "$inst\msodbcsql.msi") { Start-Process msiexec -ArgumentList "/i `"$inst\msodbcsql.msi`" /qn IACCEPTMSODBCSQLLICENSETERMS=YES" -Wait }
if (Test-Path "$inst\urlrewrite.msi"){ Start-Process msiexec -ArgumentList "/i `"$inst\urlrewrite.msi`" /qn" -Wait }
Write-Host "   xong (neu file co trong C:\inst)" -ForegroundColor Green

Write-Host "== 3. Giai nen PHP 7.4 ==" -ForegroundColor Cyan
if (Test-Path "$inst\php.zip") {
  Expand-Archive "$inst\php.zip" -DestinationPath $php -Force
  # php.ini
  Copy-Item "$php\php.ini-production" "$php\php.ini" -Force
  $ini = [IO.File]::ReadAllText("$php\php.ini")
  $ini = $ini.Replace(';extension_dir = "ext"', 'extension_dir = "ext"')
  $ini += "`r`nextension=php_sqlsrv_74_nts_x64`r`nextension=php_pdo_sqlsrv_74_nts_x64`r`nextension=curl`r`nextension=mbstring`r`nextension=openssl`r`nextension=fileinfo`r`nextension=gd2`r`ncgi.force_redirect=0`r`n"
  [IO.File]::WriteAllText("$php\php.ini", $ini)
  Write-Host "   PHP o $php (NHO: tai 2 file php_sqlsrv_74_nts_x64.dll + php_pdo_sqlsrv_74_nts_x64.dll bo vao $php\ext)" -ForegroundColor Yellow
} else { Write-Host "   BO QUA: khong thay $inst\php.zip" -ForegroundColor Yellow }

Write-Host "== 4. Dang ky PHP FastCGI voi IIS ==" -ForegroundColor Cyan
& "$env:windir\system32\inetsrv\appcmd.exe" set config /section:system.webServer/fastCgi /+"[fullPath='$php\php-cgi.exe']" 2>$null
Import-Module WebAdministration
New-WebHandler -Name "PHP74" -Path "*.php" -Verb "*" -Modules FastCgiModule -ScriptProcessor "$php\php-cgi.exe" -ResourceType Either -ErrorAction SilentlyContinue

Write-Host "== 5. Tao 2 site IIS ==" -ForegroundColor Cyan
# Request (.NET) o cong 80 ; website_backend (PHP) o cong 8080
Remove-Website -Name 'Default Web Site' -ErrorAction SilentlyContinue
New-Website -Name 'Request' -Port 80 -PhysicalPath "$G\Request" -Force -ErrorAction SilentlyContinue | Out-Null
New-Website -Name 'backend' -Port 8080 -PhysicalPath "$G\website_backend\public" -Force -ErrorAction SilentlyContinue | Out-Null
Set-ItemProperty 'IIS:\AppPools\Request' managedRuntimeVersion 'v4.0' -ErrorAction SilentlyContinue
Write-Host "   Request :80  |  backend :8080" -ForegroundColor Green
Write-Host ""
Write-Host "XONG B3 (phan tu dong). Con 2 viec tay:" -ForegroundColor Cyan
Write-Host "  - Tai 2 dll sqlsrv cho PHP 7.4 vao $php\ext (tu github.com/microsoft/msphpsql release)." -ForegroundColor Yellow
Write-Host "  - Kiem launcher goi /api/login131 vao dung cong backend (8080). Neu launcher goi cong 80, doi backend sang 80 va Request sang cong khac." -ForegroundColor Yellow
