ARCHS = armv7 arm64
CFLAGS = -fobjc-arc -O2
TARGET = iphone:9.3

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TouchIDEverywhere
TouchIDEverywhere_FILES = Tweak.xm UICKeyChainStore.m UITextField.xm TIDEBioServer.mm Safari.xm TIDESettings.m UIWebBrowserView.xm
TouchIDEverywhere_FRAMEWORKS = QuartzCore UIKit Security
TouchIDEverywhere_PRIVATE_FRAMEWORKS = BiometricKit

include $(THEOS_MAKE_PATH)/tweak.mk

#after-install::
#	install.exec "killall -9 SpringBoard"
SUBPROJECTS += tidesettings
include $(THEOS_MAKE_PATH)/aggregate.mk
