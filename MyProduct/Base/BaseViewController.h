//
//  BaseViewController.h
//  MyProduct
//
//  Created by dalong on 2022/9/8.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "NavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController


// 设置导航栏
- (void)setNavi;

@property (nonatomic, strong) NavigationView *naviView;

@end

NS_ASSUME_NONNULL_END
