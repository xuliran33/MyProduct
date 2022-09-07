//
//  LocalNotificationManager.h
//  MyProduct
//
//  Created by dalong on 2022/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalNotificationManager : NSObject

+ (void)sendNotification;

/**
 *  移除所有通知
 */
+ (void)removeAllNotification;

/**
 *  移除指定通知
 */
+ (void)removeOneNitificaitonWithID:(NSString *)noticeId;

/**
 * 跳转到App的设置页面
 */
+ (void)goToAppSystemSetting;



@end

NS_ASSUME_NONNULL_END
