@protocol _SBUIBiometricKitInterfaceDelegate
@required
- (void)biometricKitInterface:(id)interface handleEvent:(unsigned long long)event;
@end

@interface _SBUIBiometricKitInterface : NSObject
@property (assign,nonatomic) id<_SBUIBiometricKitInterfaceDelegate> delegate;
- (void)cancel;
- (void)setDelegate:(id<_SBUIBiometricKitInterfaceDelegate>)arg1;
- (int)detectFingerWithOptions:(id)arg1 ;
- (int)matchWithMode:(unsigned long long)arg1 andCredentialSet:(id)arg2;
@end

@interface BiometricKit : NSObject
@property (assign,nonatomic) id delegate;
+ (id)manager;
@end

#define TouchIDFingerDown  1
#define TouchIDFingerUp    0
#define TouchIDFingerHeld  2
#define TouchIDMatched     3
#define TouchIDNotMatched  10

@interface TIDEBioServer : NSObject <_SBUIBiometricKitInterfaceDelegate> {
	BOOL isMonitoring;
	NSArray *activatorListenerNames;
	id _oldDelegate;
}
+ (instancetype)sharedInstance;
- (void)startMonitoring;
- (void)stopMonitoring;
- (void)setUpForMonitoring;
- (BOOL)isMonitoring;
@end
