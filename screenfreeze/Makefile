TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ScreenFreeze

ScreenFreeze_FILES = SFPRootListController.m
ScreenFreeze_FRAMEWORKS = UIKit
ScreenFreeze_PRIVATE_FRAMEWORKS = Preferences
ScreenFreeze_INSTALL_PATH = /Library/PreferenceBundles
ScreenFreeze_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
