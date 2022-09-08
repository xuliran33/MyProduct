//
//  BaseViewController.m
//  MyProduct
//
//  Created by dalong on 2022/9/8.
//

#import "BaseViewController.h"
#import "NavigationView.h"
#import "Common.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 隐藏默认导航栏
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavi];
    // Do any additional setup after loading the view.
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavi {
    NavigationView *view = [[NavigationView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kStatsuBarHeight + 44)];
    
    [self.view addSubview:view];
}

@end
