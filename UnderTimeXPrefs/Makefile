include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = UnderTimeXPrefs
UnderTimeXPrefs_FILES = UTXRootListController.m
UnderTimeXPrefs_INSTALL_PATH = /Library/PreferenceBundles
UnderTimeXPrefs_FRAMEWORKS = UIKit
UnderTimeXPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/UnderTimeXPrefs.plist$(ECHO_END)
