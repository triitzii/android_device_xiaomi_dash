Device Specifications for REDMI Turbo 5 Max / POCO X8 Pro Max
=============================================================

Basic                   | Spec Sheet
-----------------------:|:--------------------------------------------------------------------------------
CPU                     | Octa-core (1x3.73 GHz Cortex-X925 & 3x3.3 GHz Cortex-X4 & 4x2.4 GHz Cortex-A720)
Chipset                 | Mediatek Dimensity 9500s (3 nm)
GPU                     | Immortalis-G925 MC11 / MC12
Shipped Android Version | 16.0
Memory                  | 12 / 16 GB (LPDDR5X)
Storage                 | 256 / 512 / 1024 GB (UFS 4.1)
Battery                 | Si/C Li-Ion 8500 / 9000 mAh
Display                 | AMOLED, 1280 x 2772 pixels, 6.83 inches (~447 ppi density)
Main Camera             | 50 MP, f/1.5, 26mm (wide), 8 MP, f/2.2, 15mm (ultrawide)
Selfie Camera           | 20 MP, f/2.2, (wide)




# Build instructions
## initial setup
```
mkdir ~/OrangeFox_sync
cd ~/OrangeFox_sync
git clone https://gitlab.com/OrangeFox/sync.git # (or, using ssh, "git clone git@gitlab.com:OrangeFox/sync.git")
cd ~/OrangeFox_sync/sync/
./orangefox_sync.sh --branch 14.1 --path ~/fox_14.1
cd ~/fox_14.1
mkdir -p device/xiaomi/dash && git clone https://github.com/triitzii/android_device_xiaomi_dash device/xiaomi/dash
mkdir -p device/xiaomi/dash-kernel && git clone https://github.com/triitzii/android_device_xiaomi_dash_kernel device/xiaomi/dash-kernel ##Clones the device's kernel-source into the device tree
```
## Set up repacker and apply patches to OrangeFox
### You need to supply your ROM's stock vendor_boot.img for this step!
```
mkdir ~/vb
git clone https://github.com/triitzii/dash-recovery-tools ~/vb && cd ~/vb
./extract-stock.sh # You need to supply your own stock vendor_boot.img for this script to work.
./apply-patches.sh
```
## Compile the recovery image
```
cd ~/fox_14.1
source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true 
export FOX_BUILD_DEVICE=dash
export LC_ALL="C"
export FOX_AB_DEVICE
export FOX_VIRTUAL_AB_DEVICE
export FOX_ADD_API_V36_PREBUILT=2
OF_USE_LEGACY_BATTERY_SERVICES=1
lunch twrp_dash-ap2a-eng
mka adbd vendorbootimage
```
## repack the recovery into the stock vendor_boot.img
```
cd ~/vb
./repack.sh # The script will output a flashable vendor_boot_new.img
```
# Flash the vendor_boot_new.img via fastboot.
```
fastboot flash vendor_boot_(a|b) path/to/vendor_boot_new.img
fastboot reboot recovery
