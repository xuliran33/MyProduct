//
//  AppDelegate.m
//  MyProduct
//
//  Created by dalong on 2022/9/5.
//

#import "AppDelegate.h"
#import <USerNotifications/USerNotifications.h>
#import "LaunchViewController.h"
#import "VideoFullScreenController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate, UIApplicationDelegate>


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setStartRootViewController];
    [self registerLocalAPN];
    
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        [self didDealLocalNotificationWithUserInfo:launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]];
    }
    return YES;
}

// 程序启动时把LaunchViewController设置为rootViewController
- (void)setStartRootViewController {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
        
    // 设置相应的 ViewController
    LaunchViewController *vc = [[LaunchViewController alloc] init];
//    VideoFullScreenController *vc= [[VideoFullScreenController alloc] init];
    self.window.rootViewController = vc;

    [self.window makeKeyAndVisible];
}

#pragma mark ---------------通知相关-------

// iOS之前程序在后台，或前台接收到本地通知时调用，iOS8-10，如果应用在前台，则本地通知不会呈现出来， iOS10以后本地通知会在状态栏弹出
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self didDealLocalNotificationWithUserInfo:notification.userInfo];
}

// 当程序进入前台时，清除通知角标
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

// 处理本地通知
- (void)didDealLocalNotificationWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@"recieve localNotification - %@", userInfo);
}

// 注册本地通知 iOS8以后发送本地通知需要先注册一个本地通知
- (void)registerLocalAPN {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        // 请求通知权限
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
    }else {
        UIUserNotificationSettings * setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}

// 应用在前台时收到本地通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSLog(@"title: %@", notification.request.content.title);
    NSLog(@"subtitle: %@", notification.request.content.subtitle);
    NSLog(@"body: %@", notification.request.content.body);
    NSLog(@"uerInfo: %@", notification.request.content.userInfo);
    
    // 这个回调可以设置接收通知后，有哪些效果呈现
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

// 应用在后台接收本地通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"apllicationState %ld", (long)[UIApplication sharedApplication].applicationState);
    
    switch ([UIApplication sharedApplication].applicationState) {
        case UIApplicationStateActive:
            // 程序在前台时点击了alert会执行这里
            break;
        
        case UIApplicationStateInactive:
            // 应用程序运行在前台但不接收事件，程序从后台刚进入前台时的状态，当在后台点击alert进入前台时会执行
            NSLog(@"title: %@", response.notification.request.content.title);
            NSLog(@"subtitle: %@", response.notification.request.content.subtitle);
            NSLog(@"body: %@", response.notification.request.content.body);
            NSLog(@"uerInfo: %@", response.notification.request.content.userInfo);
                        
            break;
        
        case UIApplicationStateBackground:
            // 程序在后台，这种状态在这里捕获不到
            break;
        
        default:
            break;
    }
    
    completionHandler();
}



@end
