#import <Preferences/Preferences.h>
#import <SettingsKit/SKListControllerProtocol.h>
#import <SettingsKit/SKTintedListController.h>

#define TIDEEnabledKey       @"TIDEEnabled"
#define TIDEFillUsernameKey  @"TIDEFillUsername"
#define TIDEAutoEnterKey     @"TIDEAutoEnter"
#define TIDEATSKey           @"TIDEAdvancedTextSupport"
#define TIDEAppellancyKey    @"TIDEAppellancy"

@interface TIDESettingsListController: SKTintedListController<SKListControllerProtocol>
@end

@implementation TIDESettingsListController

 - (UIColor*)tintColor {
   return [UIColor colorWithRed:255/255.0f green:16/255.0f blue:146/255.0f alpha:1.0f];
 }

- (NSString*)shareMessage {
  return @"I'm using #TouchIDEverywhere by @daementor.";
}

- (NSString*)headerText {
  return @"TouchID";
}

- (NSString*)headerSubText {
  return @"Everywhere";
}

- (NSString*)customTitle {
  return @"TIDE";
}

- (NSArray*)customSpecifiers {
    return @[
             @{ },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.shade.touchideverywhere",
                 @"key": TIDEEnabledKey,
                 @"label": @"Enabled",
                 @"PostNotification": @"com.shade.touchideverywhere/reloadSettings",
                 },

             @{ @"footerText": @"Experimental. Works in most cases however it may/will incorrectly identify some text fields due to their placement. Safari/WebView fields will always have username support regardless of this setting." },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.shade.touchideverywhere",
                 @"key": TIDEFillUsernameKey,
                 @"label": @"Username support",
                 @"PostNotification": @"com.shade.touchideverywhere/reloadSettings",
                 },

             @{ },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.shade.touchideverywhere",
                 @"key": TIDEAutoEnterKey,
                 @"label": @"Auto-Enter/Auto submit",
                 @"PostNotification": @"com.shade.touchideverywhere/reloadSettings",
                 },

             @{ @"footerText": @"This is required for paypal/bank apps, and shouldn't cause any issues. It's here as an option anyway though." },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.shade.touchideverywhere",
                 @"key": TIDEATSKey,
                 @"label": @"Advanced Text Support (required for paypal/bank apps)",
                 @"PostNotification": @"com.shade.touchideverywhere/reloadSettings",
                 },

             @{ },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.shade.touchideverywhere",
                 @"key": TIDEAppellancyKey,
                 @"label": @"Use Appellancy (Not Working)",
                 @"PostNotification": @"com.shade.touchideverywhere/reloadSettings",
                 },
             ];
}
@end
