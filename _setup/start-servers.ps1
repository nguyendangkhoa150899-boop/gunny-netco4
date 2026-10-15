# GunnyServers watchdog: wait for SQL, spawn any game server that is not running (detached via WMI).
# Runs from Task Scheduler (onstart + every 5 min) as SYSTEM.
for ($i=0; $i -lt 40; $i++) {
  if (Test-NetConnection -ComputerName 127.0.0.1 -Port 1433 -InformationLevel Quiet) { break }
  Start-Sleep 3
}
function Spawn($exe,$dir){ Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{CommandLine=$exe; CurrentDirectory=$dir} | Out-Null }
if (-not (Get-Process Center.Service -ErrorAction SilentlyContinue)) {
  Spawn "C:\Gunny92\Server\center\Center.Service.exe" "C:\Gunny92\Server\center"
  Start-Sleep 12
}
if (-not (Get-Process Fighting.Service -ErrorAction SilentlyContinue)) {
  Spawn "C:\Gunny92\Server\fight\Fighting.Service.exe" "C:\Gunny92\Server\fight"
  Start-Sleep 6
}
if (-not (Get-Process Road.Service -ErrorAction SilentlyContinue)) {
  Spawn "C:\Gunny92\Server\road\Road.Service.exe" "C:\Gunny92\Server\road"
}
