ARCHS = arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UnderTimeX
UnderTimeX_FILES = UnderTimeX.xm
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += UnderTimeXPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
