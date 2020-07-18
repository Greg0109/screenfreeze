#line 1 "Tweak.x"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <libactivator/libactivator.h>
#import <LocalAuthentication/LocalAuthentication.h>


#define kBundlePath @"/Library/MobileSubstrate/DynamicLibraries/ScreenFreezeImage.bundle"

@interface SpringBoard : NSObject
- (BOOL)_handlePhysicalButtonEvent:(UIPressesEvent *)event;
-(void)_simulateHomeButtonPress;
-(void)timer;
@end

@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end

@interface SBLockStateAggregator : NSObject
+(id)sharedInstance;
-(unsigned long long)lockState;
@end

@interface ScreenFreezeActivatorListener : NSObject <LAListener>
@end

NSDate *lastVolumeDown;
UIView *splash;
BOOL disablenotifications;

void blocktouches() {
    
    AudioServicesPlaySystemSound(1519);
    if (splash.superview == nil) {
        NSBundle *imageBundle = [[NSBundle alloc] initWithPath:kBundlePath];
        NSString *imagePath = [imageBundle pathForResource:@"lock" ofType:@"png"];
        UIImageView *image = [[UIImageView alloc] init];
        [image setFrame:CGRectMake(30,30,50,50)];
        [image setImage:[UIImage imageWithContentsOfFile:imagePath]];

        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        splash = [[UIView alloc] initWithFrame:window.frame];
        [splash setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.05]];
        [splash addSubview:image];
        [[[UIApplication sharedApplication] keyWindow].rootViewController.view addSubview:splash];
        splash.userInteractionEnabled = YES;
        splash.exclusiveTouch = YES;
    } else {
      LAContext *context = [LAContext new];
      NSError *error = nil;
      if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error])
          [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"Unlock ScreenFreeze" reply:^(BOOL success, NSError *error) {
              if (success) dispatch_async(dispatch_get_main_queue(), ^{
                  [splash removeFromSuperview];
              });
            }];
    }
}


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBSystemGestureManager; @class SpringBoard; @class SBLockHardwareButtonActions; @class BBServer; 
static BOOL (*_logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIPressesEvent *); static BOOL _logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIPressesEvent *); static void (*_logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPress)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPress(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$_ungrouped$SBSystemGestureManager$isGestureWithTypeAllowed$)(_LOGOS_SELF_TYPE_NORMAL SBSystemGestureManager* _LOGOS_SELF_CONST, SEL, unsigned long long); static BOOL _logos_method$_ungrouped$SBSystemGestureManager$isGestureWithTypeAllowed$(_LOGOS_SELF_TYPE_NORMAL SBSystemGestureManager* _LOGOS_SELF_CONST, SEL, unsigned long long); static void (*_logos_orig$_ungrouped$SBLockHardwareButtonActions$performLongPressActions)(_LOGOS_SELF_TYPE_NORMAL SBLockHardwareButtonActions* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBLockHardwareButtonActions$performLongPressActions(_LOGOS_SELF_TYPE_NORMAL SBLockHardwareButtonActions* _LOGOS_SELF_CONST, SEL); 

#line 62 "Tweak.x"

static BOOL _logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIPressesEvent * event) {
    if (splash.superview == nil) {
        return _logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$(self, _cmd, event);
    } else {
      for (UIPress *press in event.allPresses) {
        if (press.force == 1) {
          if (press.type != 105) {
            blocktouches();
          }
        }
      }
    }
}

static void _logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPress(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if (splash.superview == nil) {
        _logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPress(self, _cmd);
    }
}



static BOOL _logos_method$_ungrouped$SBSystemGestureManager$isGestureWithTypeAllowed$(_LOGOS_SELF_TYPE_NORMAL SBSystemGestureManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, unsigned long long arg1) {
    if (splash.superview == nil) {
        return _logos_orig$_ungrouped$SBSystemGestureManager$isGestureWithTypeAllowed$(self, _cmd, arg1);
    }
}



static void _logos_method$_ungrouped$SBLockHardwareButtonActions$performLongPressActions(_LOGOS_SELF_TYPE_NORMAL SBLockHardwareButtonActions* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if (splash.superview == nil) {
        _logos_orig$_ungrouped$SBLockHardwareButtonActions$performLongPressActions(self, _cmd);
    }
}


static void (*_logos_orig$notifications$BBServer$publishBulletin$destinations$)(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST, SEL, id, unsigned long long); static void _logos_method$notifications$BBServer$publishBulletin$destinations$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST, SEL, id, unsigned long long); 

static void _logos_method$notifications$BBServer$publishBulletin$destinations$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, unsigned long long arg2) {
  if (splash.superview == nil) {
    _logos_orig$notifications$BBServer$publishBulletin$destinations$(self, _cmd, arg1, arg2);
  }
}




@implementation ScreenFreezeActivatorListener
-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
  blocktouches();
}

+(void)load {
  @autoreleasepool {
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.greg0109.screenfreeze.activate"];
  }
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    return @"Toggle ScreenFreeze";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    return @"Activate";
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"springboard", @"application", nil];
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName {
	return @"ScreenFreeze";
}
@end

static __attribute__((constructor)) void _logosLocalCtor_28935dd4(int __unused argc, char __unused **argv, char __unused **envp) {
	NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.greg0109.screenfreezeprefs.plist"];
	disablenotifications = prefs[@"disablenotifications"] ? [prefs[@"disablenotifications"] boolValue] : NO;
  {Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); { MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_handlePhysicalButtonEvent:), (IMP)&_logos_method$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_handlePhysicalButtonEvent$);}{ MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_simulateHomeButtonPress), (IMP)&_logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPress, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPress);}Class _logos_class$_ungrouped$SBSystemGestureManager = objc_getClass("SBSystemGestureManager"); { MSHookMessageEx(_logos_class$_ungrouped$SBSystemGestureManager, @selector(isGestureWithTypeAllowed:), (IMP)&_logos_method$_ungrouped$SBSystemGestureManager$isGestureWithTypeAllowed$, (IMP*)&_logos_orig$_ungrouped$SBSystemGestureManager$isGestureWithTypeAllowed$);}Class _logos_class$_ungrouped$SBLockHardwareButtonActions = objc_getClass("SBLockHardwareButtonActions"); { MSHookMessageEx(_logos_class$_ungrouped$SBLockHardwareButtonActions, @selector(performLongPressActions), (IMP)&_logos_method$_ungrouped$SBLockHardwareButtonActions$performLongPressActions, (IMP*)&_logos_orig$_ungrouped$SBLockHardwareButtonActions$performLongPressActions);}}
  if (disablenotifications) {
    {Class _logos_class$notifications$BBServer = objc_getClass("BBServer"); { MSHookMessageEx(_logos_class$notifications$BBServer, @selector(publishBulletin:destinations:), (IMP)&_logos_method$notifications$BBServer$publishBulletin$destinations$, (IMP*)&_logos_orig$notifications$BBServer$publishBulletin$destinations$);}}
  }
}
