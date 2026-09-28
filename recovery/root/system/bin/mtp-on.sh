#!/system/bin/sh
# OrangeFox 14.1's MTP server doesn't set sys.usb.ffs.mtp.ready (a TWRP-16
# behaviour), so the gated composition block in init.recovery.keymint.rc never
# fires. Enable MTP in the GUI, then run this.
setprop sys.usb.ffs.mtp.ready 1
