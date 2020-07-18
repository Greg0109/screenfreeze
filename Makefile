export TARGET = iphone::13.0:latest
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ScreenFreeze

ScreenFreeze_FILES = Tweak.x
ScreenFreeze_LIBRARIES = activator
ScreenFreeze_CFLAGS = -fobjc-arc

BUNDLE_NAME = ScreenFreezeImage
ScreenFreezeImage_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
ScreenFreezeImage_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/bundle.mk

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += screenfreeze
include $(THEOS_MAKE_PATH)/aggregate.mk
