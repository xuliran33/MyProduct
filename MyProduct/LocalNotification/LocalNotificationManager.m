//
//  LocalNotificationManager.m
//  MyProduct
//
//  Created by dalong on 2022/9/7.
//

#import <USerNotifications/USerNotifications.h>
#import <UIKit/UIKit.h>

#import "LocalNotificationManager.h"
#import "CommonTools.h"


@implementation LocalNotificationManager

+ (void)sendNotification {
    [self checkUserNotificationEnable];
}

// 添加本地通知
+ (void)addLocalNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        // 标题
        content.title = @"注意休息";
        // 副标题
        content.subtitle = @"夜已深了，好好休息";
        // 内容
        content.body = @"明天又是元气满满的一天";
        // 声音
        content.sound = [UNNotificationSound defaultSound];
//        content.sound = [UNNotificationSound soundNamed:@""];
        content.userInfo = @{@"time": @"today"};
        
        // 角标
        content.badge = @1;
        // 多少秒后发送
//        NSTimeInterval timer = [[NSDate dateWithTimeIntervalSinceNow:3] timeIntervalSinceNow];
        NSTimeInterval timer = 10;
        
        // repeats 是否重复, 如果重复，时间需大于60s，否则报错
        UNTimeIntervalNotificationTrigger *triger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timer repeats:NO];
        
        // 若按日期重复，可用如下代码
//        NSDateComponents *components = [[NSDateComponents alloc] init];
//        components.weekday = 1;
//        components.hour = 19;
//        UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
        
        // 添加通知标识符，可用于移除，更新等操作
        NSString *identifier = @"noticeId";
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:triger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"成功添加推送");
        }];

    }else {
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        notif.alertBody = @"你已经10s没有出现了";
        notif.userInfo = @{@"noticeId":@"0000001"};
        notif.applicationIconBadgeNumber = 1;
        notif.soundName = UILocalNotificationDefaultSoundName;
        notif.repeatInterval = NSCalendarUnitWeekOfYear;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];

    }
}


// 移除某一个指定的通知
+ (void)removeOneNitificaitonWithID:(NSString *)noticeId {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            for (UNNotificationRequest *req in requests) {
                if ([req.identifier isEqual:noticeId]) {
                    [center removePendingNotificationRequestsWithIdentifiers:@[noticeId]];
                    return;
                }
            }
        }];
    }else {
        NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *noti in array) {
            NSDictionary *userInfo = noti.userInfo;
            NSString *obj = [userInfo objectForKey:@"noticeId"];
            if ([obj isEqualToString:noticeId]) {
                [[UIApplication sharedApplication] cancelLocalNotification:noti];
                break;
            }
        }
    }
}

// 移除所有通知
+ (void)removeAllNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllPendingNotificationRequests];
    }else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

// 判断用户是否允许接收通知
+ (void)checkUserNotificationEnable {
    __block BOOL isOn = YES;
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.notificationCenterSetting == UNNotificationSettingEnabled) {
                isOn = YES;
                [self addLocalNotification];
            }else {
                isOn = NO;
                [self showAlertViewController];
            }
        }];
    }else {
        if ([[[UIApplication sharedApplication] currentUserNotificationSettings] types] == UIUserNotificationTypeNone) {
            isOn = NO;
            [self showAlertViewController];
        }else {
            isOn = YES;
            [self addLocalNotification];
        }
    }
}

// 显示弹出窗
+ (void)showAlertViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:@"未获得通知权限，请前去设置" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self goToAppSystemSetting];
        }]];
        
        [[CommonTools getCurrentViewController] presentViewController:alert animated:YES completion:nil];
    });
    
}

// 用户关闭了接收通知的功能，可以通过方法跳转到App设置页面进行
+ (void)goToAppSystemSetting {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [application openURL:url options:@{} completionHandler:nil];
                }
            }else {
                [application openURL:url];
            }
        }
    });
}

@end
