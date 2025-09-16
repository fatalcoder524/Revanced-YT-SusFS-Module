#!/system/bin/sh
PATCHED_YT_VERSION="0.0.0"
APK_MIRROR_URL="https://www.apkmirror.com/apk/google-inc/youtube/youtube-$(echo -n "$RVAPPVER" | tr "." "-")-release/"
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

if [ -f "$MODPATH/base" ]; then
	# Forcefully Install unpatched apk
	ui_print " [+] Installing of unpatched Youtube APK!"
	pm install --force-sdk --full -g -i com.android.vending -r -d "$MODPATH/base/com.google.android.youtube.apk"
	if [ $? -eq 0 ]; then
		ui_print " [+] Installation of unpatched APK successful"
		rm -rf "$MODPATH/base.apk"
	else
		ui_print " [+] Installation of unpatched APK failed"
		ui_print " [+] Likely Current installed version is higher than $PATCHED_YT_VERSION"
		am start -a android.intent.action.VIEW -d "$APK_MIRROR_URL" &>/dev/null
		abort " [+] Aborting installation !!"
	fi
else
	ui_print " [+] Installing pre-installed version of zip"
	ui_print " [+] You should have preinstalled non-bundle normal apk of Youtube of version: $PATCHED_YT_VERSION"
	ui_print " [+] Else you might have crashes!"
fi

# Disable battery optimization for YouTube ReVanced
sleep 1
ui_print " [+] Disable Battery Optimization for YouTube ReVanced"
dumpsys deviceidle whitelist +$PKGNAME > /dev/null 2>&1

ui_print " [+] Forcefully mounting YouTube ReVanced"
ui_print " [+] If mount was successfull, no need to reboot!"
mod_apk_path="${MODPATH}/apk/com.google.android.youtube.apk"
stock_path="$(pm path com.google.android.youtube | sed -n '/base/s/package://p')"
am force-stop "com.google.android.youtube"
chcon u:object_r:apk_data_file:s0 "$mod_apk_path"
"${SUSFS_BIN}" add_sus_kstat "${mod_apk_path}"
if [ -n "$stock_path" ]; then
  mount -o bind "$mod_apk_path" "$stock_path"
  "${SUSFS_BIN}" update_sus_kstat "$stock_path"
  "${SUSFS_BIN}" add_sus_mount "$stock_path"
fi
"${SUSFS_BIN}" add_sus_mount "${stock_path}"
am force-stop "com.google.android.youtube"

ui_print " [+] Install Successfull !!"