#!/system/bin/sh
MODDIR=${0%/*}
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

while [ "$(getprop sys.boot_completed | tr -d '\r')" != "1" ]; do sleep 5; done

mod_apk_path="${MODDIR}/apk/com.google.android.youtube.apk"
stock_path="$(pm path com.google.android.youtube | sed -n '/base/s/package://p')"

if [ ! -f ${mod_apk_path} ]; then
	return 1
fi

am force-stop "com.google.android.youtube"
chcon u:object_r:apk_data_file:s0 "$mod_apk_path"
${SUSFS_BIN} add_sus_kstat ${mod_apk_path}
[ ! -z "$stock_path" ] && mount -o bind "$mod_apk_path" "$stock_path"
${SUSFS_BIN} update_sus_kstat ${stock_path}
${SUSFS_BIN} add_sus_mount ${stock_path}
am force-stop com.google.android.youtube

