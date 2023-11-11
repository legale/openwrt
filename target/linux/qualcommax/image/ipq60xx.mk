define Device/yuncore_ax840
	$(call Device/FitImage)
	$(call Device/UbiFit)
	DEVICE_VENDOR := Yuncore
	DEVICE_MODEL := AX840
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	SOC := ipq6018
	DEVICE_DTS_CONFIG := config@cp03-c1
	DEVICE_PACKAGES := ath11k-firmware-ipq6018 ipq-wifi-yuncore_ax840 uboot-env
endef
TARGET_DEVICES += yuncore_ax840
