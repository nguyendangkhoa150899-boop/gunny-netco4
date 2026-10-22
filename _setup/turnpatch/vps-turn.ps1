# Chay tren VPS: powershell -ExecutionPolicy Bypass -File C:\inst2\turn\vps-turn.ps1 -Mode bat|go [-ThongBao '<chu da ma hoa URL>']
#   bat : dat Game.Logic.dll da va (C:\inst2\turn) canh Road.Service.exe (CLR nap DLL roi truoc ban Costura nhung), sao luu ban
#         roi cu (.bak-turn) neu co, restart Road. Pho ban: thoi gian ban = so giay luc va (Patcher, README muc 32).
#   go  : xoa Game.Logic.dll roi (tra .bak-turn neu co), restart Road -> ve ban nhung goc.
# Restart co thong bao: SystemNotice.aspx toan server; con nguoi online thi KitoffUser.aspx (dem nguoc 6 phut, luu roi da ra).
param([Parameter(Mandatory = $true)][ValidateSet('bat', 'go')][string]$Mode, [string]$ThongBao = '')
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$road = 'C:\Gunny92\Server\road'
$dll = Join-Path $road 'Game.Logic.dll'

function Online {
  try {
    $x = (Invoke-WebRequest -UseBasicParsing -Uri ('http://127.0.0.1/ServerList.ashx?rnd=' + (Get-Random))).Content
    if ($x -match 'total="(\d+)"') { return [int]$Matches[1] }
  } catch { }
  return -1
}

function StopRoad {
  if ($ThongBao) {
    $r = (Invoke-WebRequest -UseBasicParsing -Uri ('http://127.0.0.1/SystemNotice.aspx?content=' + $ThongBao)).Content
    "Thong bao toan server: " + $r.Trim().Substring(0, [Math]::Min(10, $r.Trim().Length))
    Start-Sleep 20
  }
  $n = Online
  if ($n -gt 0) {
    "Dang co $n nguoi online: bao tri KitoffUser (dem nguoc 6 phut, game luu du lieu roi da ra)"
    $null = Invoke-WebRequest -UseBasicParsing -Uri 'http://127.0.0.1/KitoffUser.aspx'
    for ($i = 0; $i -lt 60; $i++) { Start-Sleep 10; $n = Online; if ($n -eq 0 -and $i -ge 36) { break } }
    "Con online: $n"
    Start-Sleep 15
  } else { "Khong ai online ($n)" }
  Get-Process Road.Service -ErrorAction SilentlyContinue | Stop-Process -Force
  for ($i = 0; $i -lt 20 -and (Get-Process Road.Service -ErrorAction SilentlyContinue); $i++) { Start-Sleep 1 }
  Start-Sleep 2
  "Da tat Road"
}

function StartRoad {
  $luc = Get-Date
  Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = "$road\Road.Service.exe"; CurrentDirectory = $road } | Out-Null
  for ($i = 0; $i -lt 90; $i++) {
    Start-Sleep 2
    if (Test-NetConnection -ComputerName 127.0.0.1 -Port 9200 -InformationLevel Quiet -WarningAction SilentlyContinue) { "Road da mo cong 9200 sau $(2 * ($i + 1)) giay"; break }
    if ($i -eq 89) { "CANH BAO: Road chua mo cong 9200 sau 180 giay" }
  }
  $log = Join-Path $road 'logs\Error.log'
  if ((Test-Path $log) -and (Get-Item $log).LastWriteTime -gt $luc) { "Error.log moi (20 dong cuoi):"; Get-Content $log -Tail 20 }
  else { "Error.log khong co dong moi" }
}

if ($Mode -eq 'bat') {
  if (-not (Test-Path 'C:\inst2\turn\Game.Logic.dll')) { throw 'Thieu C:\inst2\turn\Game.Logic.dll' }
  StopRoad
  if ((Test-Path $dll) -and -not (Test-Path "$dll.bak-turn")) { Copy-Item $dll "$dll.bak-turn"; "Sao luu Game.Logic.dll cu -> .bak-turn" }
  Copy-Item 'C:\inst2\turn\Game.Logic.dll' $dll -Force
  "Da dat Game.Logic.dll da va"
  StartRoad
} else {
  StopRoad
  if (Test-Path "$dll.bak-turn") { Move-Item "$dll.bak-turn" $dll -Force; "Tra lai Game.Logic.dll .bak-turn" }
  elseif (Test-Path $dll) { Remove-Item $dll -Force; "Da xoa Game.Logic.dll roi (ve ban nhung)" }
  StartRoad
}
