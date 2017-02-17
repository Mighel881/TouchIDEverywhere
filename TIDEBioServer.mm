#import "TIDEBioServer.h"
#import <objc/runtime.h>
#import <notify.h>
#import <substrate.h>
#import <UIKit/UIKit.h>
#import <libactivator/libactivator.h>
#import "TIDESettings.h"

@interface UIApplication (SpringBoard)
-(BOOL) isLocked;
@end

void startMonitoring_(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo)
{
    [[TIDEBioServer sharedInstance] startMonitoring];
}

void stopMonitoring_(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo)
{
    [[TIDEBioServer sharedInstance] stopMonitoring];
}

@implementation TIDEBioServer


+ (instancetype)sharedInstance {
    static TIDEBioServer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)biometricKitInterface:(id)interface handleEvent:(unsigned long long)event {
	if (!self.isMonitoring) {
		return;
	}

	switch (event) {
		case TouchIDMatched: {
      [self notifyClientsOfSuccess];
      [self stopMonitoring];
			break;
    }
		case TouchIDNotMatched: {
      [self notifyClientsOfFailure];
      break;
    }
    default:
      break;
	}
}

- (void)startMonitoring {
	if (isMonitoring || [[UIApplication sharedApplication] isLocked]) {
    return;
  }

	activatorListenerNames = nil;
	id activator = [objc_getClass("LAActivator") sharedInstance];
	if (activator)
    {
		id event = [objc_getClass("LAEvent") eventWithName:@"libactivator.fingerprint-sensor.press.single" mode:@"application"]; // LAEventNameFingerprintSensorPressSingle
		if (event)
        {
			activatorListenerNames = [activator assignedListenerNamesForEvent:event];
			if (activatorListenerNames)
				for (NSString *listenerName in activatorListenerNames)
					[activator removeListenerAssignment:listenerName fromEvent:event];
		}
	}
	isMonitoring = YES;

  _SBUIBiometricKitInterface *interface = [[objc_getClass("BiometricKit") manager] delegate];
  _oldDelegate = interface.delegate;
  [interface setDelegate:self];
	[interface matchWithMode:0 andCredentialSet:nil];
}

- (void)stopMonitoring {
	if (!isMonitoring || [[UIApplication sharedApplication] isLocked]) {
    return;
  }

	isMonitoring = NO;
  _SBUIBiometricKitInterface *interface = [[objc_getClass("BiometricKit") manager] delegate];
	[interface cancel];
	[interface setDelegate:_oldDelegate];
	[interface detectFingerWithOptions:nil];

	_oldDelegate = nil;

  id activator = [objc_getClass("LAActivator") sharedInstance];
  if (activator && activatorListenerNames) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
         id event = [objc_getClass("LAEvent") eventWithName:@"libactivator.fingerprint-sensor.press.single" mode:@"application"]; // LAEventNameFingerprintSensorPressSingle
         if (event)
             for (NSString *listenerName in activatorListenerNames)
                 [activator addListenerAssignment:listenerName toEvent:event];
      });
  }
}

- (void)setUpForMonitoring {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &startMonitoring_, CFSTR("com.shade.touchideverywhere/startMonitoring"), NULL, 0);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &stopMonitoring_, CFSTR("com.shade.touchideverywhere/stopMonitoring"), NULL, 0);
}

- (void)notifyClientsOfSuccess {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shade.touchideverywhere/success"), nil, nil, YES);
}

- (void)notifyClientsOfFailure {
	// TODO: implement into clients
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shade.touchideverywhere/failure"), nil, nil, YES);
}

- (BOOL)isMonitoring {
	return isMonitoring;
}
@end
