//
//  Common.h
//  MyProduct
//
//  Created by dalong on 2022/9/8.
//

#ifndef Common_h
#define Common_h

// 屏宽
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏高
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

// 屏宽系数(分为横屏及竖屏)
#define kScreenScale (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)/375)

#define ADAPT(A) A*kScreenScale
#define ADAPTNEW(A) (A*(DLScreenWidth/375))

#define kStatsuBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

// 单例
#define singleton_interface(class) + (instancetype)shared##class;
#define singleton_implementation(class)\
static class *_instance;\
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[super allocWithZone:NULL] init];\
     });\
\
    return _instance;\
}\
\
+ (instancetype)shared##class \
{\
    if(_instance == nil){\
        _instance = [[class alloc] init];\
    }\
\
    return _instance;\
}\
\
- (id)copyWithZone:(struct _NSZone *)zone\
{\
   return [class shared##class];\
}


// 没有参数没有返回值的block
typedef void (^simpleBlock)(void);

// 一个参数没有返回值的block
typedef void (^oneParamsterBlock)(id);


#endif /* Common_h */
