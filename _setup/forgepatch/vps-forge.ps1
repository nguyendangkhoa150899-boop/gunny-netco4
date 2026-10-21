# Chay tren VPS (forge.sh goi qua SSH): powershell -ExecutionPolicy Bypass -File C:\inst2\forge\vps-forge.ps1 -Mode bat|tat|go
#   bat : sao luu ban dang chay (1 lan) -> thay Game.Server.dll + ForgeTuning.dll tu C:\inst2\forge, Forge100=1, restart Road
#   tat : Forge100=0 (giu DLL da va, game chay y nhu goc), restart Road
#   go  : tra lai Game.Server.dll.bak-forge + config .bak-forge, xoa ForgeTuning.dll, restart Road (hoan tac han)
# Restart an toan: con nguoi online thi goi KitoffUser.aspx (dem nguoc 6 phut, luu du lieu roi da ra), cho het nguoi moi tat Road.
param([Parameter(Mandatory = $true)][ValidateSet('bat', 'tat', 'go')][string]$Mode)
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$road = 'C:\Gunny92\Server\road'
$src = 'C:\inst2\forge'
$dll = Join-Path $road 'Game.Server.dll'
$cfg = Join-Path $road 'Road.Service.exe.config'

function Online {
  try {
    $x = (Invoke-WebRequest -UseBasicParsing -Uri ('http://127.0.0.1/ServerList.ashx?rnd=' + (Get-Random))).Content
    if ($x -match 'total="(\d+)"') { return [int]$Matches[1] }
  } catch { }
  return -1
}

function SetForge($v) {
  [xml]$x = Get-Content $cfg -Raw -Encoding UTF8
  $app = $x.configuration.appSettings
  $n = $app.add | Where-Object { $_.key -eq 'Forge100' }
  if (-not $n) { $n = $x.CreateElement('add'); $n.SetAttribute('key', 'Forge100'); [void]$app.AppendChild($n) }
  $n.SetAttribute('value', $v)
  $x.Save($cfg)
  "Forge100 = $v"
}

function StopRoad {
  $n = Online
  if ($n -gt 0) {
    "Dang co $n nguoi online: bat bao tri (KitoffUser, dem nguoc 6 phut, game luu du lieu roi da ra)"
    $r = (Invoke-WebRequest -UseBasicParsing -Uri 'http://127.0.0.1/KitoffUser.aspx').Content
    "KitoffUser tra ve: $($r.Trim().Substring(0, [Math]::Min(20, $r.Trim().Length)))"
    for ($i = 0; $i -lt 60; $i++) {
      Start-Sleep 10
      $n = Online
      if ($n -eq 0 -and $i -ge 36) { break }   # it nhat 6 phut cho dem nguoc + luu
    }
    "Con online: $n"
    Start-Sleep 15
  } else { "Khong ai online (hoac khong doc duoc: $n)" }
  Get-Process Road.Service -ErrorAction SilentlyContinue | Stop-Process -Force
  for ($i = 0; $i -lt 20 -and (Get-Process Road.Service -ErrorAction SilentlyContinue); $i++) { Start-Sleep 1 }
  Start-Sleep 2
  "Da tat Road"
}

function StartRoad {
  Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = "$road\Road.Service.exe"; CurrentDirectory = $road } | Out-Null
  for ($i = 0; $i -lt 90; $i++) {
    Start-Sleep 2
    if (Test-NetConnection -ComputerName 127.0.0.1 -Port 9200 -InformationLevel Quiet -WarningAction SilentlyContinue) { "Road da mo cong 9200 sau $(2 * ($i + 1)) giay"; return }
  }
  "CANH BAO: Road chua mo cong 9200 sau 180 giay, xem $road\logs\Error.log"
}

# sao luu ban dang chay, chi lan dau (ban nay da co va bot, khong phai ban Costura goc)
if (-not (Test-Path "$dll.bak-forge")) { Copy-Item $dll "$dll.bak-forge"; "Sao luu: $dll.bak-forge" }
if (-not (Test-Path "$cfg.bak-forge")) { Copy-Item $cfg "$cfg.bak-forge"; "Sao luu: $cfg.bak-forge" }

switch ($Mode) {
  'bat' {
    foreach ($f in 'Game.Server.dll', 'ForgeTuning.dll') { if (-not (Test-Path (Join-Path $src $f))) { throw "Thieu $src\$f" } }
    StopRoad
    Copy-Item (Join-Path $src 'Game.Server.dll') $dll -Force
    Copy-Item (Join-Path $src 'ForgeTuning.dll') (Join-Path $road 'ForgeTuning.dll') -Force
    SetForge '1'
    StartRoad
  }
  'tat' { StopRoad; SetForge '0'; StartRoad }
  'go' {
    StopRoad
    Copy-Item "$dll.bak-forge" $dll -Force
    Copy-Item "$cfg.bak-forge" $cfg -Force
    Remove-Item (Join-Path $road 'ForgeTuning.dll') -ErrorAction SilentlyContinue
    "Da tra lai Game.Server.dll + config truoc khi va tiem ren"
    StartRoad
  }
}
"md5 Game.Server.dll: " + (Get-FileHash $dll -Algorithm MD5).Hash
