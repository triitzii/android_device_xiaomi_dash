#!/system/bin/sh
exec > /dev/kmsg 2>&1
set -x
setenforce 0
SLOT=$(getprop ro.boot.slot_suffix)
echo "SLOT=[$SLOT]"
ls -la /dev/block/mapper/

# wait for TWRP to map the logical partitions
i=0
while [ $i -lt 30 ]; do
    [ -e /dev/block/mapper/odm$SLOT ] && [ -e /dev/block/mapper/system$SLOT ] && break
    sleep 1
    i=$((i+1))
done

mkdir -p /system_root

# mount and verify each one; retry until the mount actually takes
i=0
while [ $i -lt 60 ]; do
    grep -q " /vendor " /proc/mounts || mount -t erofs -o ro /dev/block/mapper/vendor$SLOT /vendor
    grep -q " /odm " /proc/mounts || mount -t erofs -o ro /dev/block/mapper/odm$SLOT /odm
    grep -q " /system_root " /proc/mounts || mount -t erofs -o ro /dev/block/mapper/system$SLOT /system_root
    [ -x /vendor/bin/tee-supplicant ] && grep -q " /odm " /proc/mounts && break
    sleep 1
    i=$((i+1))
done

echo "--- mounts after wait ---"
grep -E " /vendor | /odm | /system_root " /proc/mounts
[ -x /vendor/bin/tee-supplicant ] || { echo "FATAL: /vendor not mounted"; exit 0; }

# Keystore2 blocks forever waiting for anything that is declared
mount -o bind /system/etc/empty-device.xml /vendor/etc/vintf/manifest/android.hardware.security.keymint-service.strongbox.nxp.xml
mount -o bind /system/etc/empty-device.xml /vendor/etc/vintf/manifest/android.hardware.security.sharedsecret-service.strongbox.nxp.xml

# keystore2 database dir (its init rc references it but never creates it)
mkdir -p /tmp/misc/keystore
chmod 700 /tmp/misc/keystore

# make crash reporting work
cp /system_root/system/lib64/libprocinfo.so /system_root/system/lib64/libunwindstack.so /system/lib64/

# servicemanager must re-read VINTF after the bind-mounts above.
# this wipes the service registry, so every HAL starts after it.
#kill $(pidof servicemanager)
sleep 2

# TEE + RPMB device permissions (revert to root:root each boot)
chmod 0660 /dev/0:0:0:49476 /dev/0:0:0:49456 /dev/0:0:0:49488 /dev/rpmb0 /dev/ufs-bsg0 /dev/tee0 /dev/teepriv0
chown system:system /dev/0:0:0:49476 /dev/0:0:0:49456 /dev/0:0:0:49488 /dev/rpmb0 /dev/ufs-bsg0 /dev/tee0 /dev/teepriv0

# keymint + gatekeeper chain off tee-supplicant via init.recovery.keymint.rc
setprop ctl.start tee-supplicant
sleep 3
setprop ctl.restart vendor.keymint-mitee
setprop ctl.start delayed_gatekeeper      # was: ctl.restart vendor.gatekeeper_mitee
sleep 2
setprop apexd.status activated
setprop sys.boot_completed 1
i=0
while [ $i -lt 20 ]; do
    [ "$(getprop init.svc.vendor.keymint-mitee)" = "running" ] && break
    sleep 1
    i=$((i+1))
done
sleep 3
setprop ctl.restart keystore2

insmod /lib/modules/nxp_i2c.ko
insmod /lib/modules/p73.ko
[ -e /dev/p73 ] || echo "WARN: /dev/p73 missing - weaver will fail"
chmod 0660 /dev/p73
chown 1027:1027 /dev/p73
setprop ctl.start vendor.secure_element_hal_service
sleep 2
setprop ctl.start se_omapi
sleep 2
setprop ctl.start vendor.weaver_nxp
sleep 2
chmod 0666 /dev/xiaomi-touch
chown system system /dev/xiaomi-touch
setprop ctl.start touchfeature-service
