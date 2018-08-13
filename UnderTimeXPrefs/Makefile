include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = UnderTimeX
UnderTimeX_FILES = UnderTimeXListController.m
UnderTimeX_INSTALL_PATH = /Library/PreferenceBundles
UnderTimeX_FRAMEWORKS = UIKit
UnderTimeX_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/UnderTimeX.plist$(ECHO_END)
