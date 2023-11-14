define Device/linksys_mr7350
	$(call Device/FitImage)
	$(call Device/UbiFit)
	DEVICE_VENDOR := Linksys
	DEVICE_MODEL := MR7350
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	SOC := ipq6018
	DEVICE_PACKAGES := kmod-leds-pca963x
	IMAGES += factory.bin
	IMAGE/factory.bin := append-ubi | qsdk-ipq-factory-nand
endef
TARGET_DEVICES += linksys_mr7350

define Device/yuncore_ax840
	$(call Device/FitImage)
	$(call Device/UbiFit)
	DEVICE_VENDOR := Yuncore
	DEVICE_MODEL := AX840
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	SOC := ipq6018
	DEVICE_DTS_CONFIG := config@cp03-c1
	DEVICE_PACKAGES += ath11k-firmware-ipq6018 ipq-wifi-yuncore_ax840 uboot-env
	#DEVICE_DTC_FLAGS := -P __IPQ_MEM_PROFILE_512MB__
	IMAGES += factory.bin
	IMAGE/factory.bin := append-ubi | qsdk-ipq-factory-nand
endef
TARGET_DEVICES += yuncore_ax840
