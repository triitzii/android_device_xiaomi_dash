$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, device/xiaomi/dash/device.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

PRODUCT_BRAND := POCO
PRODUCT_DEVICE := dash
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := 2602BPC18G
PRODUCT_NAME := twrp_dash
