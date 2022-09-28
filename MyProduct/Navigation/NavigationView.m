//
//  NavigationView.m
//  MyProduct
//
//  Created by dalong on 2022/9/8.
//

#import "NavigationView.h"

@implementation NavigationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationView" owner:self options:nil] lastObject];
        view.backgroundColor = [UIColor clearColor];
        view.frame = self.bounds;
        [self addSubview:view];
    }
    return self;
}


- (IBAction)backAction:(id)sender {
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}

@end
