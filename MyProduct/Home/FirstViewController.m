//
//  FirstViewController.m
//  MyProduct
//
//  Created by dalong on 2022/9/28.
//

#import "FirstViewController.h"
#import "LocalNotificationManager.h"


@interface FirstViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSArray *dataSource;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataSource = @[@"本地通知",@"屏幕旋转", @"蓝牙连接"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
}

- (void)setNavi{}

#pragma mark --------- UITableViewDelegate,UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // 添加本地通知
        [self addLocalNotification];
    }
    if (indexPath.row == 1) {
        // 屏幕旋转原理
    }
    
}

// 添加本地通知点击事件
- (void)addLocalNotification {
    [LocalNotificationManager sendNotification];
   
}




#pragma mark --------- JXCategoryListContentViewDelegate必须实现的方法
- (UIView *)listView {
    return  self.view;
}


@end
