define Device/FitImage
	KERNEL_SUFFIX := -fit-uImage.itb
	KERNEL = kernel-bin | gzip | fit gzip $$(DEVICE_DTS_DIR)/$$(DEVICE_DTS).dtb
	KERNEL_NAME := Image
endef

define Device/FitImageLzma
	KERNEL_SUFFIX := -fit-uImage.itb
	KERNEL = kernel-bin | lzma | fit lzma $$(DEVICE_DTS_DIR)/$$(DEVICE_DTS).dtb
	KERNEL_NAME := Image
endef

define Device/FitzImage
	KERNEL_SUFFIX := -fit-zImage.itb
	KERNEL = kernel-bin | fit none $$(DEVICE_DTS_DIR)/$$(DEVICE_DTS).dtb
	KERNEL_NAME := zImage
endef

define Device/UbiFit
	KERNEL_IN_UBI := 1
	IMAGES := nand-factory.ubi nand-sysupgrade.bin
	IMAGE/nand-factory.ubi := append-ubi
	IMAGE/nand-sysupgrade.bin := sysupgrade-tar | append-metadata
endef


define Device/yuncore_ax840
	DEVICE_VENDOR := YunCore
	DEVICE_MODEL := AX840
	DEVICE_TITLE := YunCore AX840
  	DEVICE_DTS := qcom-ipq6018-yuncore-ax840
  	DEVICE_DTS_CONFIG := config@cp03-c1
  	SUPPORTED_DEVICES := yuncore,ax840
	SOC := ipq6018
        KERNEL = kernel-bin | gzip | fit gzip $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb
        #KERNEL_INITRAMFS = kernel-bin | gzip | fit gzip $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb
        KERNEL_INITRAMFS = kernel-bin | fit none $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb

  	DEVICE_PACKAGES := ath11k-wifi-yuncore-ax840 ipq-wifi-yuncore_ax840 uboot-env
endef
TARGET_DEVICES += yuncore_ax840
