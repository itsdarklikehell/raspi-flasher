#!/bin/bash
whiptail --title "Disclaimer!" --msgbox "This script can flash various raspberry pi images. You must hit OK to continue." 8 78

VERSION=$(whiptail --title "Select version for download" --radiolist \
"Please select a version to download:" 20 78 4 \
"raspbian_lite_latest" "Raspbian Lite" ON \
"raspbian_full_latest" "Raspbian with desktop and recommended software" OFF \
"raspbian_latest" "Raspbian with desktop" OFF 3>&1 1>&2 2>&3)

FLASH_FILE(){
WORKDIR=$PWD
whiptail --title "Find output device" --msgbox "Next you will see a list of mounted devices, so make sure you have your device plugged in or connected before proceeding and scroll down to check if the device is found and take note of the devicename, its eighter something like /dev/sdX or /dev/mmcblkX." 8 78
lsblk > /tmp/lsblk_textbox
whiptail --textbox --scrolltext /tmp/lsblk_textbox 12 80
OUTPUTDEV=$(whiptail --inputbox "What is full path to the output device?" 8 78 "/dev/sdX" --title "Output Device Dialog" 3>&1 1>&2 2>&3)
if (whiptail --title "Final sanity check" --yesno "So, LAST CHECK! you want to flash $VERSION from $WORKDIR/$VERSION.zip to $OUTPUTDEV?." 8 78); then
unzip -p $WORKDIR/$VERSION.zip | sudo dd of=$OUTPUTDEV bs=4M conv=fsync status=progress && sync
echo "Flashed: $VERSION"
echo "From: $WORKDIR/$VERSION.zip"
echo "To: $OUTPUTDEV"
else
    echo "User selected No, exit status was $?."
    exit 1
fi
}

if [[ -z "$VERSION" ]]; then
echo "\$VERSION is empty"
exit 1
elif [[ "$VERSION" == "raspbian_lite_latest" ]]; then
FLASH_FILE
elif [[ "$VERSION" == "raspbian_full_latest" ]]; then
FLASH_FILE
elif [[ "$VERSION" == "raspbian_latest" ]]; then
FLASH_FILE