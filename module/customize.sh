#!/system/bin/sh
PATCHED_YT_VERSION="20.1.1"
APK_MIRROR_URL="https://www.apkmirror.com/apk/google-inc/youtube/youtube-$(echo -n "$RVAPPVER" | tr "." "-")-release/"

# Forcefully Install unpatched apk
pm install --force-sdk --full -g -i com.android.vending -r -d $MODPATH/base/com.google.android.youtube.apk
if [ $? -eq 0 ]; then
	ui_print "- Installation of unpatched APK successful"
	rm -rf $MODPATH/base.apk
else
	ui_print "- Installation of unpatched APK failed"
	ui_print "- Likely Current installed version is higher than $PATCHED_YT_VERSION"
	am start -a android.intent.action.VIEW -d "$APK_MIRROR_URL" &>/dev/null
	abort "- Aborting installation !!"
fi

# Disable battery optimization for YouTube ReVanced
sleep 1
ui_print " [+] Disable Battery Optimization for YouTube ReVanced"
dumpsys deviceidle whitelist +$PKGNAME > /dev/null 2>&1


ui_print " [+] Install Successful !!"