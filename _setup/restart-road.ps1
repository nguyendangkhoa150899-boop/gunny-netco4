# Restart Road an toan (chay tren VPS): powershell -ExecutionPolicy Bypass -File C:\Gunny92\_setup\restart-road.ps1 [-Nhanh]
# Thong bao toan server (SystemNotice) -> con nguoi online thi KitoffUser (dem nguoc 6 phut, game LUU du lieu roi da ra)
# -> tat Road -> bat lai bang WMI (khong chet theo phien SSH) -> cho cong 9200.
# -Nhanh: khong bao tri, tat ngay (CHI dung khi khong ai online: nguoi dang online mat du lieu chua luu).
# Dung khi doi du lieu Road chi doc luc khoi dong: hop qua (Shop_Goods_Box), roi do (Drop_Item), Pve_Info, Server_Config, Game_Commands...
param([switch]$Nhanh)
$ProgressPreference = 'SilentlyContinue'
$road = 'C:\Gunny92\Server\road'
function Online {
  try { $x = (Invoke-WebRequest -UseBasicParsing -Uri ('http://127.0.0.1/ServerList.ashx?rnd=' + (Get-Random))).Content; if ($x -match 'total="(\d+)"') { return [int]$Matches[1] } } catch { }
  return -1
}
"Bat dau: " + (Get-Date -Format 'HH:mm:ss')
$n = Online
if ($n -gt 0 -and -not $Nhanh) {
  $tb = [Uri]::EscapeDataString('Máy chủ sẽ bảo trì sau 6 phút để cập nhật, vui lòng thoát an toàn. Khoảng 7 phút sau vào lại.')
  try { $null = Invoke-WebRequest -UseBasicParsing -Uri ('http://127.0.0.1/SystemNotice.aspx?content=' + $tb) } catch { }
  "Co $n nguoi online: bao tri KitoffUser 6 phut"
  $null = Invoke-WebRequest -UseBasicParsing -Uri 'http://127.0.0.1/KitoffUser.aspx'
  for ($i = 0; $i -lt 60; $i++) { Start-Sleep 10; $n = Online; if ($n -eq 0 -and $i -ge 36) { break } }
  "Con online: $n"; Start-Sleep 15
} else { "Online: $n, tat ngay" }
Get-Process Road.Service -ErrorAction SilentlyContinue | Stop-Process -Force
for ($i = 0; $i -lt 20 -and (Get-Process Road.Service -ErrorAction SilentlyContinue); $i++) { Start-Sleep 1 }
Start-Sleep 2
Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = "$road\Road.Service.exe"; CurrentDirectory = $road } | Out-Null
for ($i = 0; $i -lt 90; $i++) {
  Start-Sleep 2
  if (Test-NetConnection -ComputerName 127.0.0.1 -Port 9200 -InformationLevel Quiet -WarningAction SilentlyContinue) { "Road da mo cong 9200 luc " + (Get-Date -Format 'HH:mm:ss'); exit 0 }
}
"CANH BAO: Road chua mo cong 9200 sau 180 giay, xem $road\logs\Error.log"; exit 1
