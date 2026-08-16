#!/system/bin/sh
SLOT=$(getprop ro.boot.slot_suffix)

# wait for TWRP to map the logical partitions
i=0
while [ $i -lt 30 ]; do
    [ -e /dev/block/mapper/odm$SLOT ] && break
    sleep 1
    i=$((i+1))
done

# mounts
grep -q " /vendor " /proc/mounts || mount -o ro /dev/block/mapper/vendor$SLOT /vendor
grep -q " /odm " /proc/mounts || mount -o ro /dev/block/mapper/odm$SLOT /odm
grep -q " /system_root " /proc/mounts || mount -o ro /dev/block/mapper/system$SLOT /system_root

# hide the StrongBox HAL declarations - no eSE/OMAPI stack in recovery,
# and keystore2 blocks forever waiting for anything that is declared
mount -o bind /system/etc/empty-device.xml /vendor/etc/vintf/manifest/android.hardware.security.keymint-service.strongbox.nxp.xml
mount -o bind /system/etc/empty-device.xml /vendor/etc/vintf/manifest/android.hardware.security.sharedsecret-service.strongbox.nxp.xml

# keystore2 database dir (its init rc references it but never creates it)
mkdir -p /tmp/misc/keystore
chmod 700 /tmp/misc/keystore

setenforce 0

# make crash reporting work
cp /system_root/system/lib64/libprocinfo.so /system_root/system/lib64/libunwindstack.so /system/lib64/

# servicemanager must re-read VINTF after the bind-mounts above.
# this wipes the service registry, so every HAL starts after it.
kill $(pidof servicemanager)
sleep 2

# TEE + RPMB device permissions (revert to root:root each boot)
chmod 0660 /dev/0:0:0:49476 /dev/0:0:0:49456 /dev/0:0:0:49488 /dev/rpmb0 /dev/ufs-bsg0 /dev/tee0 /dev/teepriv0
chown system:system /dev/0:0:0:49476 /dev/0:0:0:49456 /dev/0:0:0:49488 /dev/rpmb0 /dev/ufs-bsg0 /dev/tee0 /dev/teepriv0

# keymint + gatekeeper chain off tee-supplicant via init.recovery.keymint.rc
setprop ctl.start tee-supplicant
sleep 3
setprop ctl.restart vendor.keymint-mitee
setprop ctl.restart vendor.gatekeeper_mitee
sleep 2
setprop apexd.status activated
setprop sys.boot_completed 1
#setprop ctl.restart keystore2 # re-enable once IKeystoreService registration is solved
