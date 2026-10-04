#!/bin/bash

set -euo pipefail

# Logging
LOG_FILE="${LOG_FILE:-/tmp/raspi-downloader.log}"
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

# DRY_RUN guard
DRY_RUN="${DRY_RUN:-}"
maybe_mutate() {
  if [ -n "$DRY_RUN" ]; then
    log "  [DRY-RUN] Would: $*"
    return 0
  fi
  "$@"
}
whiptail --title "Disclaimer!" --msgbox "This script can download various raspberry pi images. You must hit OK to continue." 8 78

VERSION=$(whiptail --title "Select version for download" --radiolist \
"Please select a version to download:" 20 78 4 \
"raspbian_lite_latest" "Raspbian Lite" ON \
"raspbian_full_latest" "Raspbian with desktop and recommended software" OFF \
"raspbian_latest" "Raspbian with desktop" OFF 3>&1 1>&2 2>&3)

GET_FILE(){
WORKDIR=$PWD
BASEURL="https://downloads.raspberrypi.org"
wget -c $BASEURL/$VERSION -O $WORKDIR/$VERSION.zip
echo "Downloaded: $VERSION"
echo "From: $BASEURL"
echo "To: $WORKDIR/$VERSION.zip"
}

if [[ -z "$VERSION" ]]; then
echo "\$VERSION is empty"
exit 1
elif [[ "$VERSION" == "raspbian_lite_latest" ]]; then
GET_FILE
elif [[ "$VERSION" == "raspbian_full_latest" ]]; then
GET_FILE
elif [[ "$VERSION" == "raspbian_latest" ]]; then
GET_FILE
fi