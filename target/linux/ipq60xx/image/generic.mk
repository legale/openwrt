define Device/FitImage
	KERNEL_SUFFIX := -uImage.itb
	KERNEL = kernel-bin | gzip | fit gzip $$(KDIR)/image-$$(DEVICE_DTS).dtb
	KERNEL_INITRAMFS = kernel-bin | gzip | fit gzip $$(KDIR)/image-$$(DEVICE_DTS).dtb 
	KERNEL_NAME := Image
endef

define Device/UbiFit
	KERNEL_IN_UBI := 1
	IMAGES := factory.ubi factory.bin sysupgrade.bin
	IMAGE/factory.ubi := append-ubi
	IMAGE/factory.bin := append-ubi | qsdk-ipq-factory-nand
	IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef

define Device/yuncore_ax840
	$(call Device/FitImage)
	$(call Device/UbiFit)
	DEVICE_VENDOR := Yuncore
	DEVICE_MODEL := AX840
	DEVICE_DTS_CONFIG := config@cp03-c1
	SOC := ipq6018
	DEVICE_PACKAGES := ipq-wifi-yuncore_ax840
endef
TARGET_DEVICES += yuncore_ax840

