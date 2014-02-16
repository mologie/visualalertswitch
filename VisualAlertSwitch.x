
#import <CoreFoundation/CoreFoundation.h>
#import <Flipswitch/Flipswitch.h>
#import <dlfcn.h>

typedef BOOL(*_AXSVisualAlertEnabled_type)(void);
typedef int(*_AXSVisualAlertSetEnabled_type)(BOOL enabled);

static _AXSVisualAlertEnabled_type _AXSVisualAlertEnabled;
static _AXSVisualAlertSetEnabled_type _AXSVisualAlertSetEnabled;
static BOOL operational;

@interface VisualAlertSwitch : NSObject <FSSwitchDataSource>
@end

@implementation VisualAlertSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	if (!operational)
		return FSSwitchStateIndeterminate;
	return _AXSVisualAlertEnabled() ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (!operational)
		return;
	switch (newState) {
	case FSSwitchStateIndeterminate:
		break;
	case FSSwitchStateOn:
		_AXSVisualAlertSetEnabled(YES);
		break;
	case FSSwitchStateOff:
		_AXSVisualAlertSetEnabled(NO);
		break;
	}
}

- (NSString *)titleForSwitchIdentifier:(NSString *)switchIdentifier {
	return @"LED alert";
}

- (BOOL)switchWithIdentifierIsEnabled:(NSString *)switchIdentifier {
	return operational;
}

@end

%ctor
{
	void *libAccessibility = dlopen("/usr/lib/libAccessibility.dylib", RTLD_LAZY);
	if (libAccessibility) {
		_AXSVisualAlertEnabled = (_AXSVisualAlertEnabled_type)dlsym(libAccessibility, "_AXSVisualAlertEnabled");
		_AXSVisualAlertSetEnabled = (_AXSVisualAlertSetEnabled_type)dlsym(libAccessibility, "_AXSVisualAlertSetEnabled");
	}
	if (_AXSVisualAlertEnabled && _AXSVisualAlertSetEnabled) {
		operational = YES;
	} else {
		NSLog(@"VisualAlertSwitch: Error importing from libAccessibility.dylib");
	}
}
