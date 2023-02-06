KERNEL_LOADADDR := 0x41080000

DEVICE_VARS += CE_TYPE


define Device/yuncore_ax840
  DEVICE_TITLE := YunCore AX840
  DEVICE_DTS := qcom-ipq6018-yuncore-ax840
  DEVICE_DTS_CONFIG := config@cp03-c1
  SUPPORTED_DEVICES := yuncore,ax840
  DEVICE_PACKAGES := ath11k-wifi-yuncore-ax840 uboot-env
endef
TARGET_DEVICES += yuncore_ax840


