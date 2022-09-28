
#import <UIKit/UIKit.h>

@interface UIView (MLExtension)
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right; 
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

+ (instancetype)viewFromXib;


//T = top ,L = left, B = bottom, R = right,W = width,H = height;
//设置B和R的时候必须要有对应的T和L或者W和H,以免出错
//例:[Label setT:imageView.ml_bottom + 10 L:self.view.ml_left];
- (void)setL:(CGFloat)L R:(CGFloat)R T:(CGFloat)T B:(CGFloat)B;
- (void)setH:(CGFloat)H W:(CGFloat)W T:(CGFloat)T L:(CGFloat)L;
- (void)setT:(CGFloat)T L:(CGFloat)L;
- (void)setL:(CGFloat)L B:(CGFloat)B;
- (void)setT:(CGFloat)T R:(CGFloat)R;
- (void)setB:(CGFloat)B R:(CGFloat)R;
- (void)setW:(CGFloat)W H:(CGFloat)H;
/**
 * 清除所有子控件的frame值
 */
- (void)clearAllSubViewsFrame;
/**
 * 清除所有子控件
 */
- (void)clearALLSubViews;
/**
 * 设置一个带颜色圆角边框
 */
- (void)borderWithColor:(UIColor *)color;
/**
 * 裁剪一个View的圆角
 */
- (instancetype)clipsCircleViewWithCornerRadius:(CGFloat)cornerRadius;
@end
