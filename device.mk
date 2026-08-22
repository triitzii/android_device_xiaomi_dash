#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# A/B


PRODUCT_PACKAGES += \
    com.android.hardware.boot \
    android.hardware.boot-service.default_recovery

PRODUCT_PACKAGES += \
    create_pl_dev \
    create_pl_dev.recovery

PRODUCT_PACKAGES += \
    update_engine_sideload \

#decryption
PRODUCT_PACKAGES += \
    se_omapi \
    se_omapi.recovery

# API

# Boot animation
TARGET_SCREEN_HEIGHT := 2772
TARGET_SCREEN_WIDTH := 1280

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.mediatek \
    android.hardware.health-service.mediatek-recovery

# Init
PRODUCT_PACKAGES += \
    fstab.mt6991 \
    fstab.mt6991.vendor_ramdisk

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/init.recovery.mt6991.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.mt6991.rc \
    $(LOCAL_PATH)/init/init.recovery.keymint.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.keymint.rc \
    $(LOCAL_PATH)/init/dash-latemount.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/dash-latemount.sh

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# A/B
PRODUCT_AB_OTA_UPDATER := true
PRODUCT_AB_OTA_PARTITIONS += \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor

PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd

# Platform
TARGET_BOARD_PLATFORM := mt6991

# Screen density
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Security
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
INIT_BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \

# Virtualization service

# Inherit the proprietary files

