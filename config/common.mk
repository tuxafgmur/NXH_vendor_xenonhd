# XenonHD product
PRODUCT_BRAND ?= xenonhd
PRODUCT_NAME ?= xenonhd

# Definitions
CONFIG := vendor/xenonhd/config
OVERLAY := vendor/xenonhd/overlay
PREBUILT := vendor/xenonhd/prebuilt/common

DEVICE_PACKAGE_OVERLAYS += $(OVERLAY)/common

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=$(shell date +"%s")

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Default sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.alarm_alert=Tourmaline.ogg \
    ro.config.notification_sound=Omicron.ogg

# XenonHD Overrides
PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    media.sf.extractor-plugin=libffmpeg_extractor.so \
    media.sf.omx-plugin=libffmpeg_omx.so \
    persist.sys.dun.override=0 \
    persist.sys.root_access=3 \
    ro.adb.secure=0 \
    ro.build.selinux=1 \
    ro.opa.eligible_device=true \
    ro.secure=0 \
    ro.storage_manager.enabled=true

# Telephony
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

# Backup Tool & init.d support
PRODUCT_COPY_FILES += \
    $(PREBUILT)/bin/50-rom.sh:system/addon.d/50-rom.sh \
    $(PREBUILT)/bin/backuptool.functions:install/bin/backuptool.functions \
    $(PREBUILT)/bin/backuptool.sh:install/bin/backuptool.sh \
    $(PREBUILT)/bin/sysinit:system/bin/sysinit \
    $(PREBUILT)/bin/wget:system/bin/wget

# XenonHD-specific files
PRODUCT_COPY_FILES += \
    $(CONFIG)/permissions/backup.xml:system/etc/sysconfig/backup.xml \
    $(CONFIG)/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml \
    $(CONFIG)/permissions/power-whitelist.xml:system/etc/sysconfig/power-whitelist.xml \
    $(PREBUILT)/lib/content-types.properties:system/lib/content-types.properties \

# Enable SIP+VoIP on all targets & wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Include OTA config, XenonHD audio files, Theme engine
include $(CONFIG)/ota.mk

# CMSDK
ifneq ($(TARGET_DISABLE_CMSDK), true)
include $(CONFIG)/cmsdk_common.mk
endif

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/xenonhd/config/twrp.mk
endif

# XenonHD packages
PRODUCT_PACKAGES += \
    AudioFX \
    BluetoothExt \
    CMAudioService \
    CMParts \
    CMSettingsProvider \
    Calculator \
    DeskClock \
    Development \
    Eleven \
    Jelly \
    LiveWallpapersPicker \
    LockClock \
    PhotoTable \
    Profiles \
    Recorder \
    Terminal \
    Wallpapers \
    libemoji \
    libffmpeg_extractor \
    libffmpeg_omx \
    libprotobuf-cpp-full \
    librsjni \
    media_codecs_ffmpeg.xml \
    mnml

PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su

# Extra tools in XenonHD
PRODUCT_PACKAGES += \
    7z \
    bzip2 \
    curl \
    fsck.ntfs \
    gdbserver \
    htop \
    lib7z \
    libsepol \
    micro_bench \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs \
    oprofiled \
    pigz \
    powertop \
    rsync \
    scp \
    sftp \
    sqlite3 \
    ssh \
    ssh-keygen \
    sshd \
    sshd_config \
    start-ssh \
    strace \
    tune2fs \
    unrar \
    unzip \
    zip

# An other files
 PRODUCT_COPY_FILES += \
    $(PREBUILT)/etc/mkshrc:system/etc/mkshrc \
    $(PREBUILT)/xbin/busybox:system/xbin/busybox \
    $(PREBUILT)/xbin/sysro:system/xbin/sysro \
    $(PREBUILT)/xbin/sysrw:system/xbin/sysrw

# Exfat
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat \
    mount.exfat

-include $(CONFIG)/partner_gms.mk
-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
