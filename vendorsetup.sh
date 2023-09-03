#
#    This file is part of the OrangeFox Recovery Project
#     Copyright (C) 2019-2023 The OrangeFox Recovery Project
#
#    OrangeFox is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    any later version.
#
#    OrangeFox is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#     This software is released under GPL version 3 or any later version.
#    See <http://www.gnu.org/licenses/>.
# 
#     Please maintain this if you use this script or any part of it
#

FDEVICE="a01core"

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep $FDEVICE)
   if [ -n "$chkdev" ]; then
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep $FDEVICE)
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
    # builder
    export LC_ALL="C"
    export ALLOW_MISSING_DEPENDENCIES=true
    export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
#    export USE_CCACHE=1
#    export CCACHE_EXEC=/usr/bin/ccache
    
    # samsung patches
    export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
    export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"
    export FOX_RECOVERY_INSTALL_PARTITION="/dev/block/by-name/recovery"
    export FOX_RECOVERY_BOOT_PARTITION="/dev/block/by-name/boot"
    export FOX_VANILLA_BUILD=1
    
    export OF_NO_SAMSUNG_SPECIAL=1
#    export FOX_DYNAMIC_SAMSUNG_FIX=1

    # a01core
    export OF_STATUS_H="88"
    export OF_SCREEN_H="1480"

    export OF_FLASHLIGHT_ENABLE=1
    export OF_FL_PATH1="/system/flashlight"
    export OF_FL_PATH2="/sys/class/leds/S2MU005_TORCH_LED"

    export OF_USE_SYSTEM_FINGERPRINT=1
    export OF_USE_TWRP_SAR_DETECT=1
    export OF_QUICK_BACKUP_LIST="/super;/boot;/vbmeta;/vbmeta_samsung;/dtbo;/efs;/sec_efs"
    export OF_ENABLE_LPTOOLS=1
    export OF_DEVICE_WITHOUT_PERSIST=1
    export OF_DONT_KEEP_LOG_HISTORY=1
    export OF_ALLOW_DISABLE_NAVBAR=0
    export OF_CLOCK_POS=1
    export FOX_ENABLE_APP_MANAGER=1

    # Magisk
    function download_magisk(){
        # Usage: download_magisk <destination_path>
        local DEST=$1
        if [ -n "${DEST}" ]; then
            if [ ! -e ${DEST} ]; then
                echo "Downloading the Latest Release of Magisk..."
                local LATEST_MAGISK_URL=$(curl -sL https://api.github.com/repos/topjohnwu/Magisk/releases/latest | grep browser_download_url | grep Magisk- | cut -d : -f 2,3 | tr -d '"')
                mkdir -p $(dirname ${DEST})
                wget -q ${LATEST_MAGISK_URL} -O ${DEST} || wget ${LATEST_MAGISK_URL} -O ${DEST}
                local RCODE=$?
                if [ "$RCODE" = "0" ]; then
                    echo "Successfully Downloaded Magisk to ${DEST}!"
                    echo "Done!"
                else
                    echo "Failed to Download Magisk to ${DEST}!"
                fi
            fi
        fi
    }
    export FOX_USE_SPECIFIC_MAGISK_ZIP=~/Magisk/Magisk.zip
    download_magisk $FOX_USE_SPECIFIC_MAGISK_ZIP

    export OF_USE_MAGISKBOOT=1
    export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1

    # Let's See what are our Build VARs
    if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
       export | grep "FOX" >> $FOX_BUILD_LOG_FILE
       export | grep "OF_" >> $FOX_BUILD_LOG_FILE
       export | grep "TARGET_" >> $FOX_BUILD_LOG_FILE
       export | grep "TW_" >> $FOX_BUILD_LOG_FILE
    fi
fi
