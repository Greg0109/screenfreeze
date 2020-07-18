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
    //NSLog(@"PHOTOLOCK: Notification called");
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

%hook SpringBoard
- (BOOL)_handlePhysicalButtonEvent:(UIPressesEvent *)event {
    if (splash.superview == nil) {
        return %orig;
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

-(void)_simulateHomeButtonPress {
    if (splash.superview == nil) {
        %orig;
    }
}
%end

%hook SBSystemGestureManager
-(BOOL)isGestureWithTypeAllowed:(unsigned long long)arg1 {
    if (splash.superview == nil) {
        return %orig;
    }
}
%end

%hook SBLockHardwareButtonActions
-(void)performLongPressActions {
    if (splash.superview == nil) {
        %orig;
    }
}
%end

%group notifications
%hook BBServer
-(void)publishBulletin:(id)arg1 destinations:(unsigned long long)arg2 {
  if (splash.superview == nil) {
    %orig;
  }
}
%end
%end


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

%ctor {
	NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.greg0109.screenfreezeprefs.plist"];
	disablenotifications = prefs[@"disablenotifications"] ? [prefs[@"disablenotifications"] boolValue] : NO;
  %init();
  if (disablenotifications) {
    %init(notifications);
  }
}
