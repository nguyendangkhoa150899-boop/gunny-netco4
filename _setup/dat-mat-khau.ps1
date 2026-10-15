# dat-mat-khau.ps1 - Sau khi giai nen GOI BAN TRANG ra may moi: thay __SA_PASSWORD__ trong config bang mat khau sa that.
#   $env:GUNNY_SA_PASSWORD = '<mat khau sa luc cai SQL Server>'
#   powershell -ExecutionPolicy Bypass -File C:\Gunny92\_setup\dat-mat-khau.ps1
$ErrorActionPreference = 'Stop'
$sa = $env:GUNNY_SA_PASSWORD; if (-not $sa) { throw 'Dat $env:GUNNY_SA_PASSWORD truoc.' }
$n = 0
foreach ($goc in 'C:\Gunny92', 'C:\PHP7') {
  if (-not (Test-Path $goc)) { continue }
  Get-ChildItem $goc -Recurse -File -Include *.config, *.xml, *.json, *.ini, *.txt, *.php, *.env -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch '\\(node_modules|vendor)\\' -and $_.Length -lt 20MB } | ForEach-Object {
      $raw = [IO.File]::ReadAllText($_.FullName)
      if ($raw.Contains('__SA_PASSWORD__')) { [IO.File]::WriteAllText($_.FullName, $raw.Replace('__SA_PASSWORD__', $sa)); $n++; Write-Host ('da dat: ' + $_.FullName) } }
}
Write-Host "Xong: $n file." -ForegroundColor Green
