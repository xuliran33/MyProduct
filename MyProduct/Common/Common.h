//
//  Common.h
//  MyProduct
//
//  Created by dalong on 2022/9/8.
//

#ifndef Common_h
#define Common_h

// 屏宽
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
// 屏高
#define ScreenHeight ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

// 屏宽系数(分为横屏及竖屏)
#define kScreenScale (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)/375)
#define ADAPT(A) A*kScreenScale

#define kStatsuBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height


#endif /* Common_h */
