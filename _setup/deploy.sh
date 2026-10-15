#!/usr/bin/env bash
# deploy.sh: day code tu repo len VPS Windows (giong cap-nhat.sh cua TLBB, nhung chay o MAY DEV).
#
# Quy trinh: sua code -> git commit -> ./_setup/deploy.sh
#   1. Bat buoc working tree sach (moi thu da commit).
#   2. git push len GitHub truoc.
#   3. Doc commit da deploy lan truoc tren VPS (C:\Gunny92\.deployed-commit).
#   4. Chi day cac file DA DOI trong: website_backend/ Request/ admin/ _setup/
#      (scp len dung duong dan tuong ung trong C:\Gunny92), xoa file da bi xoa.
#   5. Xoa cache Laravel, recycle app pool Request neu can, ghi commit moi len VPS.
#
# Dung:  ./_setup/deploy.sh            (deploy tu commit lan truoc -> HEAD)
#        ./_setup/deploy.sh <commit>   (ep deploy tu <commit> -> HEAD)
#        DRY=1 ./_setup/deploy.sh      (chi in ra se lam gi, khong day)
#
# Bien moi truong (tuy chon): GUNNY_VPS (mac dinh Administrator@171.244.39.225)
#                             GUNNY_KEY (mac dinh ~/.ssh/gunny_vps)
#
# Shell mac dinh khi SSH vao VPS la PowerShell 5.1: lenh tu xa phai la cu phap PowerShell (khong co &&).
# KHONG day: .env, vendor/, storage/, bin/*.dll, Server/*.exe (gitignored / build rieng).
# Sua gameSrc/ (server C#) hoac Request/*.cs -> build bang Visual Studio roi copy exe/dll len tay.
set -euo pipefail

VPS="${GUNNY_VPS:-Administrator@171.244.39.225}"
KEY="${GUNNY_KEY:-$HOME/.ssh/gunny_vps}"
ROOT="C:/Gunny92"
DIRS='^(website_backend|Request|admin|_setup)/'
SSHO=(-i "$KEY" -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=20 -q)

rps(){ ssh "${SSHO[@]}" "$VPS" "\$ProgressPreference='SilentlyContinue'; $1" 2>/dev/null; }
win(){ printf '%s' "$1" | tr '/' '\\'; }   # C:/a/b -> C:\a\b

cd "$(git rev-parse --show-toplevel)"

if [ -n "$(git status --porcelain)" ]; then
  echo "Con thay doi chua commit. Commit truoc roi chay lai." >&2; git status --short >&2; exit 1
fi

HEAD_SHA=$(git rev-parse HEAD)
if [ -z "${DRY:-}" ]; then
  echo ">> git push"
  git push origin HEAD
fi

if [ $# -ge 1 ]; then
  LAST="$1"
else
  LAST=$(rps "Get-Content C:\Gunny92\.deployed-commit -EA SilentlyContinue" | tr -d '\r\n ' || true)
fi
if [ -z "$LAST" ]; then
  echo "VPS chua co .deployed-commit. Chay lai voi commit goc: ./_setup/deploy.sh <commit>" >&2; exit 1
fi
if [ "$LAST" = "$HEAD_SHA" ]; then echo "VPS da o $HEAD_SHA, khong co gi de day."; exit 0; fi
echo ">> deploy $LAST -> $HEAD_SHA"

CHANGES=$(git diff --name-status --no-renames "$LAST" "$HEAD_SHA" | awk -F'\t' -v re="$DIRS" '$2 ~ re')
if [ -z "$CHANGES" ]; then
  echo "Khong co file nao trong website_backend/Request/admin/_setup thay doi."
else
  echo "$CHANGES"
fi
[ -n "${DRY:-}" ] && { echo "(DRY: khong day)"; exit 0; }

if [ -n "$CHANGES" ]; then
  MK=$(echo "$CHANGES" | awk -F'\t' '$1!="D"{print $2}' | xargs -r -n1 dirname | sort -u \
       | while read -r d; do printf "New-Item -ItemType Directory -Force -Path '%s' | Out-Null; " "$(win "$ROOT/$d")"; done)
  [ -n "$MK" ] && rps "$MK" >/dev/null

  while IFS=$'\t' read -r st p; do
    case "$st" in
      D) echo "  xoa  $p"; rps "Remove-Item -Force -EA SilentlyContinue '$(win "$ROOT/$p")'" >/dev/null || true ;;
      *) echo "  day  $p"; scp "${SSHO[@]}" "$p" "$VPS:$ROOT/$p" ;;
    esac
  done <<< "$CHANGES"
fi

POST=""
if echo "$CHANGES" | grep -q $'\twebsite_backend/'; then
  POST+="Set-Location C:\Gunny92\website_backend; C:\PHP7\php.exe artisan view:clear | Out-Null; C:\PHP7\php.exe artisan route:clear | Out-Null; C:\PHP7\php.exe artisan config:clear | Out-Null; "
fi
if echo "$CHANGES" | grep -q $'\tRequest/'; then
  POST+="C:\Windows\System32\inetsrv\appcmd.exe recycle apppool /apppool.name:DefaultAppPool | Out-Null; "
fi
POST+="Set-Content -Path C:\Gunny92\.deployed-commit -Value '$HEAD_SHA' -Encoding ascii"
rps "$POST" >/dev/null
echo ">> xong. VPS dang o $HEAD_SHA"
