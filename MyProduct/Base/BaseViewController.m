//
//  BaseViewController.m
//  MyProduct
//
//  Created by dalong on 2022/9/8.
//

#import "BaseViewController.h"



@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    self.naviView = [[NavigationView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kStatsuBarHeight + 44)];
    kWeakSelf(self)
    [self.naviView setButtonBlock:^{
        kStrongSelf(self);
        [self backAction];
    }];
    [self.view addSubview:self.naviView];
}

@end
