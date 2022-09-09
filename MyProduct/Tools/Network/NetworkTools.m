//
//  NetworkTools.m
//  OCLearning
//
//  Created by 徐丽然 on 2022/8/15.
//

#import "NetworkTools.h"
#import "Urls.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

// 超时时间
NSInteger const kAFNetworkingTimeOutInterval = 15;

@implementation NetworkTools

static NetworkTools *tools;

+ (instancetype)sharedTools {
    static AFHTTPSessionManager *aManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:BaseUrl];
        aManager = [[self alloc] initWithBaseURL:baseURL];
        // 设置反序列化
        aManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
        aManager.responseSerializer = [AFHTTPRequestSerializer serializer];
        // 设置超时时间
        aManager.requestSerializer.timeoutInterval = kAFNetworkingTimeOutInterval;
        
    });
    return tools;
}

+ (void)requestWithType:(RequestMethod)type urlString:(NSString *)urlString header:(NSDictionary *)header parameters:(NSDictionary *)parameters successBlcok:(HTTPRequestSuccessBlock)successBlock failureBlock:(HTTPRequestFailedBlock)failureBlock {
    if (urlString == nil) {
        return;
    }
    
    // 判断网络连接是否可用
    if (!AFNetworkReachabilityManager.sharedManager.isReachable) {
        return;
    }
    // 对url进行utf-8编码
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableDictionary *headerdic = [NSMutableDictionary dictionary];
    NSArray *keys = [header allKeys];
    for (NSString *key in keys) {
        headerdic[key] = header[key];
    }
    
    
    if (type == GET) {
        [[self sharedTools] GET:urlString parameters:parameters headers:[[headerdic allKeys] count] > 0 ? headerdic : nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                successBlock(json);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code != -999) {
                if (failureBlock) {
                    failureBlock(error);
                }else {
                    NSLog(@"取消队列了");
                }
            }
        }];
    }
    
    if (type == POST) {
        [[self sharedTools] POST:urlString parameters:parameters headers:[[headerdic allKeys] count] > 0 ? headerdic : nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                successBlock(json);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code != -999) {
                if (failureBlock) {
                    failureBlock(error);
                }else {
                    NSLog(@"取消队列了");
                }
            }
        }];
    }
    
}

+ (void)cancelDataTask {
    NSMutableArray *dataTasks = [NSMutableArray arrayWithArray:[[self sharedTools] dataTasks]];
    
    for (NSURLSessionDataTask *taskObj in dataTasks) {
        [taskObj cancel];
    }
}

+ (void)postRequstWithAPi:(NSString *)api header:(NSDictionary *)header   parameters:(NSDictionary *)parameters successBlcok:(HTTPRequestSuccessBlock)successBlock failureBlock:(HTTPRequestFailedBlock)failureBlock{
    [self requestWithType:POST urlString:api header:header  parameters:parameters successBlcok:^(id  _Nonnull responseObject) {
        successBlock(responseObject);
    } failureBlock:^(NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

+ (void)getRequstWithAPi:(NSString *)api header:(NSDictionary *)header  parameters:(NSDictionary *)parameters successBlcok:(HTTPRequestSuccessBlock)successBlock failureBlock:(HTTPRequestFailedBlock)failureBlock {
    [self requestWithType:GET urlString:api header:header parameters:parameters successBlcok:^(id  _Nonnull responseObject) {
        successBlock(responseObject);
    } failureBlock:^(NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

@end
