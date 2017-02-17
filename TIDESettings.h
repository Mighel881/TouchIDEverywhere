@interface TIDESettings : NSObject {
      NSDictionary *_settings;
}
+ (instancetype)sharedInstance;

- (void)reloadSettings;

- (BOOL)enabled;
- (BOOL)fillUserName;
- (BOOL)autoEnter;
- (BOOL)advancedTextSupport;
- (BOOL)useAppellancy;
@end
