#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# A/B
ifeq ($(WITH_GMS),true)
PRODUCT_SYSTEM_PARTITIONS_FILE_SYSTEM_TYPE ?= erofs
else
PRODUCT_SYSTEM_PARTITIONS_FILE_SYSTEM_TYPE ?= ext4
endif

ifeq ($(PRODUCT_SYSTEM_PARTITIONS_FILE_SYSTEM_TYPE),ext4)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)
else
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4
PRODUCT_VENDOR_PROPERTIES += ro.virtual_ab.compression.threads=true
endif

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=$(PRODUCT_SYSTEM_PARTITIONS_FILE_SYSTEM_TYPE) \
    POSTINSTALL_OPTIONAL_system=true

PRODUCT_PACKAGES += \
    com.android.hardware.boot \
    android.hardware.boot-service.default_recovery

PRODUCT_PACKAGES += \
    create_pl_dev \
    create_pl_dev.recovery

PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

# API
BOARD_SHIPPING_API_LEVEL := 202404
PRODUCT_SHIPPING_API_LEVEL := 35

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
    $(LOCAL_PATH)/init/init.recovery.mt6991.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.mt6991.rc

# Partitions
PRODUCT_BUILD_PVMFW_IMAGE := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true

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
    hardware/mediatek \
    hardware/xiaomi

# Virtualization service
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

# Inherit the proprietary files
$(call inherit-product, vendor/xiaomi/dash/dash-vendor.mk)
