ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
THEOS_PACKAGE_DIR_NAME = debs

include /var/theos/makefiles/common.mk

TWEAK_NAME = critfov
critfov_FILES = Tweak.xm #$(shell find $(THEOS)/include/SCLAlertView -name '*.m')
critfov_FRAMEWORKS = UIKit MessageUI Social QuartzCore CoreGraphics Foundation AVFoundation Accelerate GLKit SystemConfiguration
critfov_LDFLAGS += -Wl,-segalign,4000,-lstdc++
critfov_CFLAGS ?= -fobjc-arc -DALWAYS_INLINE=1 -Os -std=c++11 -w -s

include /var/theos/makefiles/tweak.mk

include /var/theos/makefiles/aggregate.mk
