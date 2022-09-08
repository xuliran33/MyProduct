//
//  ViewController.m
//  MyProduct
//
//  Created by dalong on 2022/9/5.
//

#import "ViewController.h"
#import "LocalNotificationManager.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 添加本地通知点击事件
- (IBAction)addLocalNotification:(UIButton *)sender {
//    [LocalNotificationManager sendNotification];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}





@end
