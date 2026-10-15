# dong-goi.ps1 - Dong goi BAN TRANG de mo lai server tren may khac (chay TREN VPS, PowerShell Admin).
#   powershell -ExecutionPolicy Bypass -File C:\Gunny92\_setup\dong-goi.ps1
# Ket qua: C:\GoiGunny\GunnyNetco4-ban-trang-<ngay>.zip (+ .sha256.txt). Nhat ky: C:\GoiGunny\dong-goi.log
# - DB: BACKUP (COPY_ONLY, khong anh huong server dang chay) -> RESTORE thanh *_TRANG -> lam-trang.sql -> BACKUP lai -> xoa ban tam.
#   DB that KHONG bi dong vao.
# - File: C:\Gunny92 (bo log, session, cache, .env, appsettings.secret.config, .bak cu, du lieu runtime), C:\PHP7,
#   Flash goc chua va, cau hinh IIS + task + tuong lua (xuat ra xml/txt).
# - Mat khau sa trong moi file text cua goi duoc thay bang __SA_PASSWORD__ (dat lai bang dat-mat-khau.ps1 trong goi).
# - Chay o muc uu tien thap de khong lam giat game.
$ErrorActionPreference = 'Stop'
(Get-Process -Id $PID).PriorityClass = 'BelowNormal'
$G = 'C:\Gunny92'; $O = 'C:\GoiGunny'; $P = "$O\GunnyNetco4"; $ngay = Get-Date -Format 'yyyyMMdd'
$zip = "$O\GunnyNetco4-ban-trang-$ngay.zip"
New-Item -ItemType Directory -Force $O | Out-Null
$log = "$O\dong-goi.log"
function ghi($m) { $l = (Get-Date -Format 'HH:mm:ss') + '  ' + $m; Add-Content -Path $log -Value $l -Encoding UTF8; Write-Host $l }
function sq($q) {
  $ErrorActionPreference = 'Continue'   # PS 5.1: stderr cua lenh ngoai + 2>&1 + Stop = loi gia
  $r = & sqlcmd -S localhost -E -C -b -W -h -1 -Q "SET NOCOUNT ON; $q" 2>&1
  if ($LASTEXITCODE -ne 0) { throw "sqlcmd loi: $q`n$r" }; return $r }
try {
  ghi "=== BAT DAU (goi: $P) ==="
  if (Test-Path $P) { Remove-Item $P -Recurse -Force }
  New-Item -ItemType Directory -Force "$P\DB" | Out-Null
  $bk = (sq "SELECT CAST(SERVERPROPERTY('InstanceDefaultBackupPath') AS nvarchar(400))").Trim()
  $dt = (sq "SELECT CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS nvarchar(400))").Trim().TrimEnd('\')
  $dbs = 'Db_Tank41','Db_Tank','Db_Member','Db_Admin','Db_Gm'

  # ---- 1. DB: sao luu -> phuc hoi thanh *_TRANG
  foreach ($d in $dbs) {
    $t = "${d}_TRANG"; $live = "$bk\$d.live-tam.bak"
    sq "IF DB_ID('$t') IS NOT NULL BEGIN ALTER DATABASE [$t] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$t]; END" | Out-Null
    sq "BACKUP DATABASE [$d] TO DISK=N'$live' WITH COPY_ONLY, INIT" | Out-Null
    $files = sq "SELECT name + '|' + CAST(type AS varchar) FROM sys.master_files WHERE database_id = DB_ID('$d')"
    $move = @(); $i = 0
    foreach ($f in $files) { $f = "$f".Trim(); if (-not $f) { continue }; $n, $ty = $f.Split('|'); $ext = if ($ty -eq '1') { 'ldf' } else { 'mdf' }; $move += "MOVE N'$n' TO N'$dt\${t}_$i.$ext'"; $i++ }
    sq ("RESTORE DATABASE [$t] FROM DISK=N'$live' WITH REPLACE, RECOVERY, " + ($move -join ', ')) | Out-Null
    Remove-Item $live -Force
    ghi "DB $d -> $t (ban sao)"
  }
  # ---- 2. lam trang tren ban sao
  $ErrorActionPreference = 'Continue'
  $r = & sqlcmd -S localhost -E -C -b -f 65001 -W -s '|' -i "$G\_setup\sql\lam-trang.sql" -v T41=Db_Tank41_TRANG MEM=Db_Member_TRANG ADM=Db_Admin_TRANG 2>&1
  $ErrorActionPreference = 'Stop'
  if ($LASTEXITCODE -ne 0) { throw "lam-trang.sql loi:`n$r" }
  ghi "lam-trang xong. Con du lieu:"; $r | ForEach-Object { if ("$_".Trim()) { ghi "   $_" } }
  # ---- 3. sao luu ban trang (ten file = ten DB that de khoi phuc dung ten), xoa ban sao
  foreach ($d in $dbs) {
    $t = "${d}_TRANG"
    sq "BACKUP DATABASE [$t] TO DISK=N'$bk\$d.bak' WITH COPY_ONLY, INIT, NAME=N'$d ban trang $ngay'" | Out-Null
    sq "ALTER DATABASE [$t] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$t];" | Out-Null
    Move-Item "$bk\$d.bak" "$P\DB\$d.bak" -Force
    ghi ("DB trang: $d.bak " + [int]((Get-Item "$P\DB\$d.bak").Length / 1MB) + ' MB')
  }
  $ver = (sq "SELECT CAST(SERVERPROPERTY('ProductVersion') AS varchar) + ' ' + CAST(SERVERPROPERTY('Edition') AS varchar)").Trim()
  Set-Content "$P\DB\PHIEN-BAN-SQL.txt" "Tao tu SQL Server $ver. May moi phai cai SQL Server cung ban hoac MOI HON (17.x = SQL Server 2025). .bak KHONG khoi phuc duoc len ban cu hon." -Encoding UTF8

  # ---- 4. file
  $xd = @('logs', "$G\website_backend\storage\framework\sessions", "$G\website_backend\storage\framework\cache",
          "$G\website_backend\storage\framework\views", "$G\website_backend\storage\debugbar", "$G\website_backend\storage\backups")
  $xf = @('*.log', '.env', 'appsettings.secret.config', '*.bak', '*.data', '*.snapedata', '.deployed-commit',
          "$G\website_backend\bootstrap\cache\config.php")   # cache cau hinh Laravel (neu co) chua APP_KEY/khoa
  & robocopy $G "$P\Gunny92" /E /R:1 /W:1 /NFL /NDL /NP /XD $xd /XF $xf | Out-Null
  if ($LASTEXITCODE -ge 8) { throw "robocopy Gunny92 loi $LASTEXITCODE" }
  foreach ($d in 'website_backend\storage\logs', 'website_backend\storage\framework\sessions', 'website_backend\storage\framework\cache\data', 'website_backend\storage\framework\views', 'Request\logs') {
    New-Item -ItemType Directory -Force "$P\Gunny92\$d" | Out-Null }
  ghi 'Chep C:\Gunny92 xong'
  & robocopy C:\PHP7 "$P\PHP7" /E /R:1 /W:1 /NFL /NDL /NP /XD logs tmp /XF *.log | Out-Null
  if ($LASTEXITCODE -ge 8) { throw "robocopy PHP7 loi $LASTEXITCODE" }
  if (Test-Path C:\inst2\flash-goc-20261015) { & robocopy C:\inst2\flash-goc-20261015 "$P\Flash-goc-chua-va" /E /NFL /NDL /NP | Out-Null }
  ghi 'Chep PHP7 + Flash goc xong'

  # ---- 5. cau hinh he thong (de dung lai)
  New-Item -ItemType Directory -Force "$P\HE-THONG" | Out-Null
  & "$env:windir\system32\inetsrv\appcmd.exe" list site /config /xml > "$P\HE-THONG\iis-sites.xml"
  & "$env:windir\system32\inetsrv\appcmd.exe" list apppool /config /xml > "$P\HE-THONG\iis-apppools.xml"
  foreach ($tk in 'GunnyServers', 'GunnyWatchdog') { & schtasks /query /tn $tk /xml > "$P\HE-THONG\task-$tk.xml" 2>$null }
  Get-NetFirewallRule -Enabled True -Direction Inbound | Where-Object { $_.DisplayName -notmatch '^(Core Networking|@)' } |
    ForEach-Object { $pf = $_ | Get-NetFirewallPortFilter; '{0} | {1} | {2}' -f $_.DisplayName, $pf.Protocol, $pf.LocalPort } | Set-Content "$P\HE-THONG\tuong-lua.txt" -Encoding UTF8
  icacls "$G\Request\*.xml" > "$P\HE-THONG\quyen-Request-xml.txt"
  ghi 'Xuat IIS / task / tuong lua xong'

  # ---- 6. bi mat: thay mat khau sa, lam file mau
  $sa = $null
  foreach ($l in Get-Content "$G\website_backend\.env") { if ($l -match '^DB_PASSWORD=(.*)$') { $sa = $Matches[1].Trim().Trim('"') } }
  if (-not $sa) { throw 'Khong doc duoc DB_PASSWORD trong .env' }
  $n = 0
  Get-ChildItem $P -Recurse -File -Include *.config, *.xml, *.json, *.ini, *.txt, *.ps1, *.php, *.env, *.cs, *.yml -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch '\\(node_modules|vendor)\\' -and $_.Length -lt 20MB } | ForEach-Object {
      $raw = [IO.File]::ReadAllText($_.FullName)
      if ($raw.Contains($sa)) { [IO.File]::WriteAllText($_.FullName, $raw.Replace($sa, '__SA_PASSWORD__')); $n++; ghi ('   an mat khau sa: ' + $_.FullName.Substring($P.Length)) } }
  ghi "Thay mat khau sa trong $n file"
  New-Item -ItemType Directory -Force "$P\BI-MAT-MAU" | Out-Null
  (Get-Content "$G\website_backend\.env") | ForEach-Object {
      if ($_ -match '^([A-Z0-9_]*(PASS|KEY|SECRET|TOKEN|PASSWORD)[A-Z0-9_]*)=') { $Matches[1] + '=__DIEN__' } else { $_ } } |
    Set-Content "$P\BI-MAT-MAU\website_backend.env" -Encoding UTF8
  $sc = [IO.File]::ReadAllText("$G\Request\appsettings.secret.config")
  $sc = [regex]::Replace($sc, '(key="(LoginKey|ChargeKey)"\s+value=")[^"]*(")', '$1__DIEN__$3')
  $sc = $sc.Replace($sa, '__SA_PASSWORD__')
  [IO.File]::WriteAllText("$P\BI-MAT-MAU\Request-appsettings.secret.config", $sc)
  Copy-Item "$G\_setup\dat-mat-khau.ps1" "$P\dat-mat-khau.ps1" -ErrorAction SilentlyContinue
  if (Test-Path "$G\.deployed-commit") { Copy-Item "$G\.deployed-commit" "$P\GIT-COMMIT.txt" }
  if (Test-Path "$O\MO-LAI-SERVER.md") { Copy-Item "$O\MO-LAI-SERVER.md" "$P\MO-LAI-SERVER.md" -Force }
  # kiem lan cuoi: con sot mat khau?
  $sot = Get-ChildItem $P -Recurse -File -Include *.config, *.xml, *.json, *.ini, *.txt, *.ps1, *.php, *.env -ErrorAction SilentlyContinue |
    Where-Object { $_.Length -lt 20MB } | Select-String -SimpleMatch -Pattern $sa -List
  if ($sot) { throw ('Con sot mat khau sa trong: ' + (($sot | ForEach-Object Path) -join ', ')) }
  ghi 'Kiem: khong con mat khau sa trong goi'

  # ---- 7. nen
  if (Test-Path $zip) { Remove-Item $zip -Force }
  & 'C:\Program Files\7-Zip\7z.exe' a -tzip -mx=5 -mmt=2 $zip "$P\*" | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "7z loi $LASTEXITCODE" }
  $h = (Get-FileHash $zip -Algorithm SHA256).Hash
  Set-Content "$zip.sha256.txt" "$h  $(Split-Path $zip -Leaf)" -Encoding ASCII
  ghi ("XONG: $zip " + [Math]::Round((Get-Item $zip).Length / 1GB, 2) + " GB, SHA256 $h")
  Remove-Item $P -Recurse -Force
  ghi 'Da xoa thu muc tam (giu file zip)'
} catch {
  ghi ("LOI: " + $_.Exception.Message)
  foreach ($d in 'Db_Tank41','Db_Tank','Db_Member','Db_Admin','Db_Gm') {
    & sqlcmd -S localhost -E -C -Q "IF DB_ID('${d}_TRANG') IS NOT NULL BEGIN ALTER DATABASE [${d}_TRANG] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [${d}_TRANG]; END" | Out-Null }
  ghi 'Da don ban sao DB *_TRANG (neu co). DB that khong bi dong vao.'
  exit 1
}
