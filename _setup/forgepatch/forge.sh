#!/usr/bin/env bash
# Tiem ren 100% (may dev, Git Bash). Can .NET 8 SDK (winget install Microsoft.DotNet.SDK.8).
#   ./_setup/forgepatch/forge.sh bat   build + va Game.Server.dll DANG CHAY tren VPS, sao luu, thay, Forge100=1, restart Road
#   ./_setup/forgepatch/forge.sh tat   Forge100=0: ve ti le goc, giu DLL da va (bat lai: sua config Forge100=1 + restart, hoac chay 'bat')
#   ./_setup/forgepatch/forge.sh go    hoan tac han: tra lai Game.Server.dll.bak-forge + config, xoa ForgeTuning.dll
# Road restart: con nguoi online thi bao tri 6 phut (KitoffUser) truoc. Chi tiet: README muc 27.
set -euo pipefail
MODE="${1:-}"
[[ "$MODE" == bat || "$MODE" == tat || "$MODE" == go ]] || { echo "dung: forge.sh bat|tat|go"; exit 1; }
VPS="${GUNNY_VPS:-Administrator@171.244.39.225}"
KEY="${GUNNY_KEY:-$HOME/.ssh/gunny_vps}"
SSHO=(-o BatchMode=yes -o ConnectTimeout=15 -i "$KEY")
DIR="$(cd "$(dirname "$0")" && pwd)"
W="$DIR/work"            # gitignore: goc/ (ban tai ve), ra/ (ban da va)
export PATH="$PATH:/c/Program Files/dotnet" DOTNET_CLI_TELEMETRY_OPTOUT=1

ssh "${SSHO[@]}" "$VPS" "New-Item -ItemType Directory -Force C:\\inst2\\forge | Out-Null" >/dev/null
scp -q "${SSHO[@]}" "$DIR/vps-forge.ps1" "$VPS:C:/inst2/forge/vps-forge.ps1"

if [[ "$MODE" == bat ]]; then
  rm -rf "$W"; mkdir -p "$W/goc" "$W/ra"
  echo ">> build"
  dotnet build "$DIR/ForgeTuning" -c Release -v q -nologo
  dotnet build "$DIR/Patcher" -c Release -v q -nologo
  # luon va tu ban CHUA va tiem ren: co .bak-forge thi lay no, khong thi lay ban dang chay
  echo ">> tai Game.Server.dll tu VPS"
  if ssh "${SSHO[@]}" "$VPS" "Test-Path C:\\Gunny92\\Server\\road\\Game.Server.dll.bak-forge" | grep -q True; then
    scp -q "${SSHO[@]}" "$VPS:C:/Gunny92/Server/road/Game.Server.dll.bak-forge" "$W/goc/Game.Server.dll"
  else
    scp -q "${SSHO[@]}" "$VPS:C:/Gunny92/Server/road/Game.Server.dll" "$W/goc/Game.Server.dll"
  fi
  echo ">> va"
  dotnet "$DIR/Patcher/bin/Release/net8.0/Patcher.dll" patch "$W/goc/Game.Server.dll" "$DIR/ForgeTuning/bin/Release/net48/ForgeTuning.dll" "$W/ra"
  scp -q "${SSHO[@]}" "$W/ra/Game.Server.dll" "$W/ra/ForgeTuning.dll" "$VPS:C:/inst2/forge/"
fi

echo ">> VPS: $MODE (co nguoi online thi cho bao tri ~7 phut)"
ssh "${SSHO[@]}" "$VPS" "powershell -ExecutionPolicy Bypass -File C:\\inst2\\forge\\vps-forge.ps1 -Mode $MODE"
