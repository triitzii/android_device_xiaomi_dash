#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from the custom device configuration.
$(call inherit-product, device/xiaomi/dash/device.mk)

# Inherit from the LineageOS configuration.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Device Identifier.
PRODUCT_BRAND := POCO
PRODUCT_DEVICE := dash
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := 2602BPC18G
PRODUCT_NAME := lineage_dash

PRODUCT_BRAND_FOR_ATTESTATION := $(PRODUCT_BRAND)
PRODUCT_DEVICE_FOR_ATTESTATION := $(PRODUCT_DEVICE)
PRODUCT_MODEL_FOR_ATTESTATION := $(PRODUCT_MODEL)
PRODUCT_NAME_FOR_ATTESTATION := dash_global
PRODUCT_MANUFACTURER_FOR_ATTESTATION := $(PRODUCT_MANUFACTURER)

PRODUCT_CHARACTERISTICS := nosdcard
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc=" missi-user 16 BP2A.250605.031.A3 OS3.0.4.0.WPLMIXM release-keys" \
    BuildFingerprint=POCO/dash_global/dash:16/BP2A.250605.031.A3/OS3.0.4.0.WPLMIXM:user/release-keys \
    DeviceName=dash \
    DeviceProduct=dash_global \
    SystemDevice=dash \
    SystemName=dash_global
