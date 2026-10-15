# B1-sql.ps1 — bat Mixed Mode, dat mat khau sa, khoi phuc 5 database. Chay SAU khi da cai SQL Server (Basic).
# Chay trong PowerShell Admin:  powershell -ExecutionPolicy Bypass -File C:\Gunny92\_setup\B1-sql.ps1
$ErrorActionPreference = 'Stop'
$sa      = $env:GUNNY_SA_PASSWORD; if (-not $sa) { throw "Dat bien moi truong GUNNY_SA_PASSWORD truoc (gia tri o file mat khau tren Desktop)" }
$bakDir  = 'C:\Gunny92'          # noi chua cac file .bak
$dataDir = 'C:\SQLDATA'          # noi dat file .mdf/.ldf sau khi restore
New-Item -ItemType Directory -Force $dataDir | Out-Null

Write-Host "== 1. Bat Mixed Mode (login SQL) ==" -ForegroundColor Cyan
$reg = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server' |
       Where-Object { $_.PSChildName -match '^MSSQL\d+\.MSSQLSERVER$' } | Select-Object -First 1
if (!$reg) { throw "Khong thay instance MSSQLSERVER. Ban cai SQL co dung Default instance khong?" }
Set-ItemProperty -Path "$($reg.PSPath)\MSSQLServer" -Name LoginMode -Value 2
Write-Host "   LoginMode=2 ($($reg.PSChildName))" -ForegroundColor Green

Write-Host "== 2. Khoi dong lai dich vu SQL ==" -ForegroundColor Cyan
Restart-Service 'MSSQLSERVER' -Force
Start-Sleep 5

Write-Host "== 3. Bat + doi mat khau sa ==" -ForegroundColor Cyan
sqlcmd -S localhost -E -b -Q "ALTER LOGIN [sa] ENABLE; ALTER LOGIN [sa] WITH PASSWORD = '$sa';"
if ($LASTEXITCODE -ne 0) { throw "Doi mat khau sa that bai" }
Write-Host "   sa OK" -ForegroundColor Green

Write-Host "== 4. Khoi phuc 5 database ==" -ForegroundColor Cyan
$dbs = @(
  @{ bak='tank41.bak'; name='Db_Tank41' },
  @{ bak='tank.bak';   name='Db_Tank'   },
  @{ bak='member.bak'; name='Db_Member' },
  @{ bak='admin.bak';  name='Db_Admin'  },
  @{ bak='gm.bak';     name='Db_Gm'     }
)
foreach ($d in $dbs) {
  $bak = Join-Path $bakDir $d.bak
  if (!(Test-Path $bak)) { Write-Host "   BO QUA (khong thay $($d.bak))" -ForegroundColor Yellow; continue }
  Write-Host "   -> $($d.name) ..." -ForegroundColor Gray
  $q = "RESTORE DATABASE [$($d.name)] FROM DISK = N'$bak' WITH " +
       "MOVE N'$($d.name)' TO N'$dataDir\$($d.name).mdf', " +
       "MOVE N'$($d.name)_log' TO N'$dataDir\$($d.name)_log.ldf', REPLACE, STATS = 20;"
  sqlcmd -S localhost -E -b -Q $q
  if ($LASTEXITCODE -ne 0) {
    Write-Host "   LOI restore $($d.name). Chay lenh nay de xem ten logic that roi bao Claude:" -ForegroundColor Red
    Write-Host "   sqlcmd -S localhost -E -Q `"RESTORE FILELISTONLY FROM DISK=N'$bak'`"" -ForegroundColor Yellow
  } else { Write-Host "   $($d.name) OK" -ForegroundColor Green }
}

Write-Host "== 5. Sua IP trong bang Server_List ==" -ForegroundColor Cyan
sqlcmd -S localhost -E -b -Q "USE Db_Tank41; UPDATE Server_List SET IP='127.0.0.1', Port=9200; SELECT ID,Name,IP,Port FROM Server_List;"
Write-Host ""
Write-Host "XONG B1. Neu co dong do (LOI), chup gui Claude. Tiep theo: B2-config.ps1" -ForegroundColor Cyan
