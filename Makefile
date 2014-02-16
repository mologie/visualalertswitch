#
# Makefile for VisualAlertSwitch
# https://cydia.mologie.com/packages/com.mologie.visualalertswitch/
#

BUNDLE_NAME = VisualAlert
VisualAlert_FILES = VisualAlertSwitch.x
VisualAlert_FRAMEWORKS = UIKit
VisualAlert_LIBRARIES = flipswitch
VisualAlert_INSTALL_PATH = /Library/Switches
VisualAlert_CFLAGS = -Iheaders
VisualAlert_LDFLAGS = -Llib

# Use make DEBUG=1 for building binaries which output logs
DEBUG ?= 0
ifeq ($(DEBUG), 1)
	CFLAGS = -DDEBUG
endif

# Target the iPhone 3GS and all later devices
ARCHS = armv7 armv7s arm64
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 6.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_arm64 = 7.0

include framework/makefiles/common.mk
include framework/makefiles/bundle.mk

after-stage::
	$(ECHO_NOTHING)find "$(THEOS_STAGING_DIR)" -iname '*.plist' -exec plutil -convert binary1 "{}" \;$(ECHO_END)
