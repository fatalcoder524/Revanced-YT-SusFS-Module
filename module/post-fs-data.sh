#!/system/bin/sh
MODDIR=/data/adb/modules/revanced_yt_susfs
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

stock_path="$(pm path com.google.android.youtube | sed -n '/base/s/package://p')"
[ ! -z "$stock_path" ] && umount -l "$stock_path"
grep com.google.android.youtube /proc/mounts | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l
