ARCHS = arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FreeRAMUnderTimeX
FreeRAMUnderTimeX_FILES = FreeRAMUnderTimeX.xm
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
