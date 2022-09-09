//
//  NetworkTools.h
//  OCLearning
//
//  Created by 徐丽然 on 2022/8/15.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

/** 网络请求类型枚举， GET， POST */
typedef enum : NSUInteger {
    GET,    // get请求
    POST    // post请求
} RequestMethod;


/**
 http通讯成功的block
 
 @param responseObject 返回的数据
 */
typedef void (^HTTPRequestSuccessBlock)(id responseObject);

/**
 http通讯失败的block
 
 @param error 返回的错误信息
 */
typedef void (^HTTPRequestFailedBlock)(NSError *error);

// 超时时间
extern NSInteger const kAFNetworkingTimeOutInterval;


@interface NetworkTools : NSObject

// 单例
//+ (instancetype)sharedTools;

/**
 * 网路请求的实例方法
 *
 * @param type          get/post
 * @param urlString     请求的地址
 * @param parameters    请求的参数
 * @param successBlock  请求成功的回调
 * @param failureBlock  请求失败的回调
 * @param header        网络请求的header
 
 */

+ (void)requestWithType:(RequestMethod) type urlString:(NSString *)urlString header:(NSDictionary *)header parameters:(NSDictionary *)parameters
successBlcok:(HTTPRequestSuccessBlock) successBlock
           failureBlock:(HTTPRequestFailedBlock) failureBlock;

/**
 * 取消队列
 */
+ (void)cancelDataTask;

/**
 POST请求
 */
+ (void)postRequstWithAPi:(NSString *)api header:(NSDictionary *)header parameters:(NSDictionary *)parameters
             successBlcok:(HTTPRequestSuccessBlock) successBlock
                        failureBlock:(HTTPRequestFailedBlock) failureBlock;

/**
 GET请求
 */
+ (void)getRequstWithAPi:(NSString *)api header:(NSDictionary *)header parameters:(NSDictionary *)parameters
             successBlcok:(HTTPRequestSuccessBlock) successBlock
                        failureBlock:(HTTPRequestFailedBlock) failureBlock;

@end

NS_ASSUME_NONNULL_END
