//
//  ViewController.m
//  MyProduct
//
//  Created by dalong on 2022/9/5.
//

#import "ViewController.h"
#import "LocalNotificationManager.h"
#import <JXCategoryView/JXCategoryView.h>
#import "HomeView.h"



@interface ViewController ()<JXCategoryListContainerViewDelegate>

// tab title 数组
@property (nonatomic, strong) NSArray *tabListArray;

// tab headerView
@property (nonatomic, strong) JXCategoryTitleView *titleView;

// tab底部切换view
@property (nonatomic, strong) JXCategoryListContainerView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabListArray = @[@"我的电脑"];
    
    [self setUI];
}

- (void)setUI{
    
    self.titleView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, kStatsuBarHeight, ScreenWidth, 50)];
    
    self.titleView.titles = self.tabListArray;
    self.titleView.titleSelectedColor = [UIColor blackColor];
    self.titleView.titleSelectedFont = [UIFont systemFontOfSize:17];
    self.titleView.averageCellSpacingEnabled = NO;
    // 颜色渐变过度
    self.titleView.titleColorGradientEnabled = YES;
    
    [self.view addSubview:self.titleView];
    
    // 滑动指示器
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor blueColor];
//    lineView.indicatorWidthIncrement = 10;
    self.titleView.indicators = @[lineView];
    self.containerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.containerView.frame = CGRectMake(0, kStatsuBarHeight + 50, ScreenWidth, ScreenHeight - kStatsuBarHeight - 50);
    [self.view addSubview:self.containerView];
    self.titleView.listContainer = self.containerView;
    
}

#pragma mark ------------ JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.tabListArray.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {

    return [[HomeView alloc] initWithFrame:CGRectMake(0, kStatsuBarHeight + 50, ScreenWidth, ScreenHeight - kStatsuBarHeight - 50)];
}

// 重写设置导航栏的方法，隐藏导航栏
- (void)setNavi{}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//// 添加本地通知点击事件
//- (IBAction)addLocalNotification:(UIButton *)sender {
////    [LocalNotificationManager sendNotification];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
//}





@end
