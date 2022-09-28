//
//  LaunchViewController.m
//  MyProduct
//
//  Created by dalong on 2022/9/9.
//

#import "LaunchViewController.h"
#import "ViewController.h"


@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    [self configRootViewController];
    
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(configRootViewController) userInfo:nil repeats:NO];

}

// 判断首页，已登录显示首页，未登录显示登录页
- (void)configRootViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [UIApplication sharedApplication].delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
}

@end
