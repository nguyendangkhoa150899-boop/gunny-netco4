# dong-goi-day-du.ps1 - Dong goi DAY DU (giong het server dang chay: CO nguoi choi + CO bi mat) de dung lai y chang tren may khac.
#   powershell -ExecutionPolicy Bypass -File C:\Gunny92\_setup\dong-goi-day-du.ps1
# Ket qua: C:\GoiGunny\GunnyNetco4-day-du-<ngay>.zip (+ .sha256.txt). Nhat ky: C:\GoiGunny\dong-goi-day-du.log
# Khac dong-goi.ps1 (ban trang): KHONG lam trang DB, KHONG an mat khau sa / .env / appsettings.secret.config.
# => File zip CHUA BI MAT: tai ve may chu server roi XOA tren VPS, khong dua len mang / GitHub.
# - DB: BACKUP COPY_ONLY 5 DB that (khong anh huong server dang chay; nguoi dang online: du lieu trong RAM Road chua luu thi khong co).
# - File: C:\Gunny92 (bo log, session, cache, .bak DB cu), C:\PHP7, Flash goc chua va, cau hinh IIS + task + tuong lua.
$ErrorActionPreference = 'Stop'
(Get-Process -Id $PID).PriorityClass = 'BelowNormal'
$G = 'C:\Gunny92'; $O = 'C:\GoiGunny'; $P = "$O\GunnyNetco4-day-du"; $ngay = Get-Date -Format 'yyyyMMdd'
$zip = "$O\GunnyNetco4-day-du-$ngay.zip"
New-Item -ItemType Directory -Force $O | Out-Null
$log = "$O\dong-goi-day-du.log"
function ghi($m) { $l = (Get-Date -Format 'HH:mm:ss') + '  ' + $m; Add-Content -Path $log -Value $l -Encoding UTF8; Write-Host $l }
function sq($q) {
  $ErrorActionPreference = 'Continue'
  $r = & sqlcmd -S localhost -E -C -b -W -h -1 -Q "SET NOCOUNT ON; $q" 2>&1
  if ($LASTEXITCODE -ne 0) { throw "sqlcmd loi: $q`n$r" }; return $r }
try {
  ghi "=== BAT DAU (goi: $P) ==="
  if (Test-Path $P) { Remove-Item $P -Recurse -Force }
  New-Item -ItemType Directory -Force "$P\DB" | Out-Null
  $bk = (sq "SELECT CAST(SERVERPROPERTY('InstanceDefaultBackupPath') AS nvarchar(400))").Trim()

  # ---- 1. DB that (COPY_ONLY)
  foreach ($d in 'Db_Tank41','Db_Tank','Db_Member','Db_Admin','Db_Gm') {
    sq "BACKUP DATABASE [$d] TO DISK=N'$bk\$d.bak' WITH COPY_ONLY, INIT, NAME=N'$d day du $ngay'" | Out-Null
    Move-Item "$bk\$d.bak" "$P\DB\$d.bak" -Force
    ghi ("DB: $d.bak " + [int]((Get-Item "$P\DB\$d.bak").Length / 1MB) + ' MB')
  }
  $ver = (sq "SELECT CAST(SERVERPROPERTY('ProductVersion') AS varchar) + ' ' + CAST(SERVERPROPERTY('Edition') AS varchar)").Trim()
  Set-Content "$P\DB\PHIEN-BAN-SQL.txt" "Tao tu SQL Server $ver. May moi phai cai SQL Server cung ban hoac MOI HON (17.x = SQL Server 2025). .bak KHONG khoi phuc duoc len ban cu hon." -Encoding UTF8

  # ---- 2. file (giu .env + appsettings.secret.config)
  $xd = @('logs', "$G\website_backend\storage\framework\sessions", "$G\website_backend\storage\framework\cache",
          "$G\website_backend\storage\framework\views", "$G\website_backend\storage\debugbar", "$G\website_backend\storage\backups")
  $xf = @('*.log', '*.bak', '*.data', '*.snapedata')
  & robocopy $G "$P\Gunny92" /E /R:1 /W:1 /NFL /NDL /NP /XD $xd /XF $xf | Out-Null
  if ($LASTEXITCODE -ge 8) { throw "robocopy Gunny92 loi $LASTEXITCODE" }
  foreach ($d in 'website_backend\storage\logs', 'website_backend\storage\framework\sessions', 'website_backend\storage\framework\cache\data', 'website_backend\storage\framework\views', 'Request\logs') {
    New-Item -ItemType Directory -Force "$P\Gunny92\$d" | Out-Null }
  ghi ('Chep C:\Gunny92 xong: ' + [int]((Get-ChildItem "$P\Gunny92" -Recurse -File | Measure-Object Length -Sum).Sum / 1MB) + ' MB')
  & robocopy C:\PHP7 "$P\PHP7" /E /R:1 /W:1 /NFL /NDL /NP /XD logs tmp /XF *.log | Out-Null
  if ($LASTEXITCODE -ge 8) { throw "robocopy PHP7 loi $LASTEXITCODE" }
  if (Test-Path C:\inst2\flash-goc-20261015) { & robocopy C:\inst2\flash-goc-20261015 "$P\Flash-goc-chua-va" /E /NFL /NDL /NP | Out-Null }
  ghi 'Chep PHP7 + Flash goc xong'

  # ---- 3. cau hinh he thong
  New-Item -ItemType Directory -Force "$P\HE-THONG" | Out-Null
  & "$env:windir\system32\inetsrv\appcmd.exe" list site /config /xml > "$P\HE-THONG\iis-sites.xml"
  & "$env:windir\system32\inetsrv\appcmd.exe" list apppool /config /xml > "$P\HE-THONG\iis-apppools.xml"
  foreach ($tk in 'GunnyServers', 'GunnyWatchdog') { & schtasks /query /tn $tk /xml > "$P\HE-THONG\task-$tk.xml" 2>$null }
  Get-NetFirewallRule -Enabled True -Direction Inbound | Where-Object { $_.DisplayName -notmatch '^(Core Networking|@)' } |
    ForEach-Object { $pf = $_ | Get-NetFirewallPortFilter; '{0} | {1} | {2}' -f $_.DisplayName, $pf.Protocol, $pf.LocalPort } | Set-Content "$P\HE-THONG\tuong-lua.txt" -Encoding UTF8
  icacls "$G\Request\*.xml" > "$P\HE-THONG\quyen-Request-xml.txt"
  ghi 'Xuat IIS / task / tuong lua xong'
  if (Test-Path "$G\.deployed-commit") { Copy-Item "$G\.deployed-commit" "$P\GIT-COMMIT.txt" }

  # ---- 4. nen
  if (Test-Path $zip) { Remove-Item $zip -Force }
  & 'C:\Program Files\7-Zip\7z.exe' a -tzip -mx=3 -mmt=2 $zip "$P\*" | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "7z loi $LASTEXITCODE" }
  $h = (Get-FileHash $zip -Algorithm SHA256).Hash
  Set-Content "$zip.sha256.txt" "$h  $(Split-Path $zip -Leaf)" -Encoding ASCII
  ghi ("XONG: $zip " + [Math]::Round((Get-Item $zip).Length / 1GB, 2) + " GB, SHA256 $h")
  Remove-Item $P -Recurse -Force
  ghi 'Da xoa thu muc tam (giu file zip). NHO XOA ZIP SAU KHI TAI VE (co bi mat).'
} catch {
  ghi ("LOI: " + $_.Exception.Message)
  exit 1
}
