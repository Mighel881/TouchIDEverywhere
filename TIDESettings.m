#import "TIDESettings.h"

#define TIDEEnabledKey       @"TIDEEnabled"
#define TIDEFillUsernameKey  @"TIDEFillUsername"
#define TIDEAutoEnterKey     @"TIDEAutoEnter"
#define TIDEATSKey           @"TIDEAdvancedTextSupport"
#define TIDEAppellancyKey    @"TIDEAppellancy"

@implementation TIDESettings
+ (instancetype)sharedInstance {
    static TIDESettings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self reloadSettings];
  }

  return self;
}

- (void)reloadSettings {
	@autoreleasepool {
		// Reload Settings
		if (_settings) {
			//CFRelease((__bridge CFDictionaryRef)_settings);
			_settings = nil;
		}
		CFPreferencesAppSynchronize(CFSTR("com.shade.touchideverywhere"));
		CFStringRef appID = CFSTR("com.shade.touchideverywhere");
		CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

		BOOL failed = NO;

		if (keyList) {
			//_settings = (__bridge NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
			_settings = (NSDictionary*)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
			CFRelease(keyList);

			if (!_settings) {
				//HBLogDebug(@"[ReachApp] failure loading from CFPreferences");
				failed = YES;
			}
		}
		else {
			//HBLogDebug(@"[ReachApp] failure loading keyList");
			failed = YES;
		}
		CFRelease(appID);

		if (failed) {
			_settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.shade.touchideverywhere.plist"];
			//HBLogDebug(@"[ReachApp] settings sandbox load: %@", _settings == nil ? @"failed" : @"succeed");
		}

		if (_settings == nil) {
			HBLogDebug(@"[ReachApp] could not load settings from CFPreferences or NSDictionary");
		}
	}
}

- (BOOL)enabled {
	return [[_settings objectForKey:TIDEEnabledKey]?:@YES boolValue];
}

- (BOOL)fillUserName {
	return [[_settings objectForKey:TIDEFillUsernameKey]?:@YES boolValue];
}

- (BOOL)autoEnter {
	return [[_settings objectForKey:TIDEAutoEnterKey]?:@YES boolValue];
}

- (BOOL)advancedTextSupport {
	return [[_settings objectForKey:TIDEATSKey]?:@YES boolValue];
}

- (BOOL)useAppellancy {
	return [[_settings objectForKey:TIDEAppellancyKey]?:@YES boolValue];
}

@end
