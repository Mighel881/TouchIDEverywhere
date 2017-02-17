#import <UIKit/UIKit.h>
#import "TIDEBioServer.h"
#import "TIDESettings.h"

void reloadSettings(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo)
{
    [[TIDESettings sharedInstance] reloadSettings];
}

%ctor {
	if (IN_SPRINGBOARD) {
		[[TIDEBioServer sharedInstance] setUpForMonitoring];
	}

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &reloadSettings, CFSTR("com.shade.touchideverywhere/reloadSettings"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	[TIDESettings sharedInstance];
}

@interface SBLockStateAggregator : NSObject
+ (id)sharedInstance;
- (void)_updateLockState;
- (_Bool)hasAnyLockState;
@end

// Dunno if I even need this...
/*
BOOL wasMonitoring = NO;
%hook SBLockStateAggregator
-(void)_updateLockState
{
	%orig;

	if ([self hasAnyLockState])
	{
		wasMonitoring = [[TIDEBioServer sharedInstance] isMonitoring];
		if (wasMonitoring)
			[[TIDEBioServer sharedInstance] stopMonitoring];
	}
	else
	{
		if (wasMonitoring)
			[[TIDEBioServer sharedInstance] startMonitoring];
	}
}
%end
*/
