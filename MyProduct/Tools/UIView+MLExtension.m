// uiview extension


#import "UIView+MLExtension.h"

@implementation UIView (MLExtension)

+ (instancetype)viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)borderWithColor:(UIColor *)color
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = 3;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}


- (CGFloat)left
{
    return self.x;
}

- (void)setLeft:(CGFloat)left
{
    self.x = left;
}

- (CGFloat)right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right
{
    
    if (right > 0) {
        if (self.x) {
            self.width = right - self.x;
        }else if (self.width){
            self.x = right - self.width;
        }
    }else{
        if (self.x) {
            self.width = CGRectGetMaxX(self.superview.frame) + right - self.x;
        }else if (self.width){
            self.x = CGRectGetMaxX(self.superview.frame) + right - self.width;
        }
    }
}

- (CGFloat)top
{
    return self.y;
}

- (void)setTop:(CGFloat)top
{
    self.y = top;
}

- (CGFloat)bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom
{
    if (bottom > 0) {
        if (self.y) {
            self.height = bottom - self.y;
        }else if (self.height){
            self.y = bottom - self.height;
        }
    }else{
        if (self.y) {
            self.height = CGRectGetMaxY(self.superview.frame) + bottom - self.y;
        }else if (self.height){
            self.y = CGRectGetMaxY(self.superview.frame) + bottom - self.height;
        }
    }
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}


- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)setL:(CGFloat)L R:(CGFloat)R T:(CGFloat)T B:(CGFloat)B
{
    self.top = T;
    self.left = L;
    self.right = R;
    self.bottom = B;
}

- (void)setH:(CGFloat)H W:(CGFloat)W T:(CGFloat)T L:(CGFloat)L
{
    self.top = T;
    self.left = L;
    self.height = H;
    self.width = W;
}

- (void)setT:(CGFloat)T L:(CGFloat)L
{
    self.top = T;
    self.left = L;
}
- (void)setL:(CGFloat)L B:(CGFloat)B
{
    self.left = L;
    self.bottom = B;
}
- (void)setT:(CGFloat)T R:(CGFloat)R
{
    self.top = T;
    self.right = R;
}
- (void)setB:(CGFloat)B R:(CGFloat)R
{
    self.bottom = B;
    self.right = R;
}

- (void)setW:(CGFloat)W H:(CGFloat)H
{
    self.width = W;
    self.height = H;
}

- (void)clearAllSubViewsFrame
{
    for (UIView * v in self.subviews) {
        v.frame = CGRectZero;
    }
}

- (void)clearALLSubViews
{
    for (id v in self.subviews) {
        [v removeFromSuperview];
    }
}

- (instancetype)clipsCircleViewWithCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    return self;
}

@end
