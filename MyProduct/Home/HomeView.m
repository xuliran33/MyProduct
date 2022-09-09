//
//  HomeView.m
//  MyProduct
//
//  Created by dalong on 2022/9/9.
//

#import "HomeView.h"

@interface HomeView ()

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation HomeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return  self;
}

#pragma mark --------- JXCategoryListContentViewDelegate必须实现的方法
- (UIView *)listView {
    return  self;
}

@end
