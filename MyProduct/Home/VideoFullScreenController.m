//
//  VideoFullScreenController.m
//  MyProduct
//
//  Created by dalong on 2022/9/27.
//  屏幕旋转

#import "VideoFullScreenController.h"
#import "AppDelegate.h"
#import "Common.h"

@interface VideoFullScreenController ()

@property (nonatomic, nullable, strong) UIButton *btnFullScreen;


@end

@implementation VideoFullScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.btnFullScreen];
    //添加旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //关闭旋转(恢复原状)
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.suportOrientations = NO;

    [self setDeviceInterfaceOrientation:UIDeviceOrientationPortrait];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.suportOrientations = YES;
    //进入界面：设置横屏
    [self setDeviceInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
    
}


//最后在dealloc中移除通知 和结束设备旋转的通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

// 是否支持旋转
- (BOOL)shouldAutorotate {
    return YES;
}
// 支持的旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (UIButton *)btnFullScreen {
    if (!_btnFullScreen) {
        _btnFullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFullScreen setTitle:@"全屏" forState:UIControlStateNormal];
        _btnFullScreen.backgroundColor = [UIColor orangeColor];
        [_btnFullScreen addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnFullScreen.frame = CGRectMake(50, 80, 150, 50);
    }
    return _btnFullScreen;
}

- (BOOL)onDeviceOrientationDidChange{
    //获取当前设备Device
    UIDevice *device = [UIDevice currentDevice] ;
    //识别当前设备的旋转方向
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
        case UIDeviceOrientationUnknown:
            //系统当前无法识别设备朝向，可能是倾斜
            NSLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.suportOrientations = YES;
            [self setDeviceInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
            NSLog(@"屏幕向左橫置");
            //进入界面：设置横屏
            
            break;
        }
 
        case UIDeviceOrientationLandscapeRight:
        {
            NSLog(@"屏幕向右橫置");
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.suportOrientations = YES;
            [self setDeviceInterfaceOrientation:UIDeviceOrientationLandscapeRight];
            break;
        }
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;
            
        default:
            NSLog(@"無法识别");
            break;
    }
    return YES;
}

- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//方法2：强制屏幕旋转
- (void)setDeviceInterfaceOrientation:(UIDeviceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation] forKey:@"orientation"];
    }
}

- (void)fullScreenAction:(UIButton *)button {
    NSLog(@"%lf, %lf", ScreenWidth, ScreenHeight);
    if (ScreenWidth > ScreenHeight) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.suportOrientations = NO;
        [self setDeviceInterfaceOrientation:UIInterfaceOrientationPortrait];
    }else {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.suportOrientations = YES;
        [self setDeviceInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
        
    }
}

@end

/** 屏幕旋转原理
 一、三种枚举
    1.设备方向 ： UIDeviceOrientation
    设备方向只能取值，不能设置，获取当前设备旋转方向的使用方法[UIDevice currentDevice].orientation ，可以用addObserver监听设备方向的改变
    
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationDidChange)
                      name:UIDeviceOrientationDidChangeNotification
                                                object:nil];

 [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

  - (BOOL)onDeviceOrientationDidChange{
     //获取当前设备Device
     UIDevice *device = [UIDevice currentDevice] ;
     //识别当前设备的旋转方向
     switch (device.orientation) {
         case UIDeviceOrientationFaceUp:
             NSLog(@"屏幕幕朝上平躺");
             break;

         case UIDeviceOrientationFaceDown:
             NSLog(@"屏幕朝下平躺");
             break;

         case UIDeviceOrientationUnknown:
             //系统当前无法识别设备朝向，可能是倾斜
             NSLog(@"未知方向");
             break;

         case UIDeviceOrientationLandscapeLeft:
             NSLog(@"屏幕向左橫置");
             break;

         case UIDeviceOrientationLandscapeRight:
             NSLog(@"屏幕向右橫置");
             break;

         case UIDeviceOrientationPortrait:
             NSLog(@"屏幕直立");
             break;

         case UIDeviceOrientationPortraitUpsideDown:
             NSLog(@"屏幕直立，上下顛倒");
             break;

         default:
             NSLog(@"無法识别");
             break;
     }
     return YES;
 }
 
 2.页面方向 ： UIInterfaceOrientation 程序界面的当前旋转方向，可以设置
 3.页面方向 ： UIInterfaceOrientationMask， iOS6之后增加的枚举，是为了支持多种UIInterfaceOrientation而定义的类型
 iOS6之后，控制单个界面的旋转，我们通常用如下方法
 //方法1
 - (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
 //方法2
 - (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
 // Returns interface orientation masks.
 //方法3
 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
 
 方法2的作用是设置当前界面支持的所有方向
 方法3是进入页面时默认的方向
 
 二 两种屏幕旋转的触发方式
 
 情况1 系统没有关闭自动旋转屏幕的功能，支持页面跟新用户手持设备旋转方向自动旋转，需要添加如下方法
 //1.决定当前界面是否开启自动转屏，如果返回NO，后面两个方法也不会被调用，只是会支持默认的方向
 - (BOOL)shouldAutorotate {
       return YES;
 }

 //2.返回支持的旋转方向
 //iPad设备上，默认返回值UIInterfaceOrientationMaskAllButUpSideDwon
 //iPad设备上，默认返回值是UIInterfaceOrientationMaskAll
 - (UIInterfaceOrientationMask)supportedInterfaceOrientations{
      return UIInterfaceOrientationMaskAll;
 }

 //3.返回进入界面默认显示方向
 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
      return UIInterfaceOrientationPortrait;
 }
 
 情况二：单个界面强制旋转
 // 方法1：
 - (void)setInterfaceOrientation:(UIDeviceOrientation)orientation {
       if ([[UIDevice currentDevice]   respondsToSelector:@selector(setOrientation:)]) {
           [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation]
                                        forKey:@"orientation"];
         }
     }

 // 方法2：
 - (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
             SEL selector = NSSelectorFromString(@"setOrientation:");
             NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice
         instanceMethodSignatureForSelector:selector]];
             [invocation setSelector:selector];
             [invocation setTarget:[UIDevice currentDevice]];
             int val = orientation;
             [invocation setArgument:&val atIndex:2];
             [invocation invoke];
         }
     }
 
 注意：使用这两个方法的时候，也要确保shouldAutorotate方法返回YES，这样这两个方法才会生效。还要注意两者使用的参数类型不同。
 
 三、屏幕旋转控制的优先级
    关于屏幕旋转的设置有很多，有Xcode的General设置，也有info.plist设置，更还有代码设置等，这么多的设置很是繁杂。但是这些其实都是在不同级别上实现旋转的设置，我们会遇到设置关闭旋转无效的情况，这就很可能是被上一级别控制的原因。
    控制屏幕旋转优先级为：工程Target属性配置(全局权限，info.plist设置) = Appdelegate&&Window > 根视图控制器> 普通视图控制器。
 四、屏幕旋转的设置方式
 1. 【Target】->【General】—>【Deployment Info】—>【Device Orientation】,和info.plist中的设置是同步的
 2. Appdelegate&&Window中设置
 正常情况下，我们的App从Appdelegate中启动，而Appdelegate所持有唯一的Window对象是全局的，所以在Appdelegate文件中设置屏幕旋转也是全局有效的。下面的代码设置了只支持竖屏和右旋转：
 - (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
 
 return  UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;

 }
 若在AppDelegate中设置了，则在方法一种的设置将失效
 
 五 开启屏幕旋转
 自全局权限开启之后，接下来具有最高权限的就是Window的根视图控制器rootViewController了。如果我们要具体控制单个界面UIViewController的旋转就必须先看一下根视图控制器的配置情况了。
 当然，在一般情况下，我们的项目都是用UITabbarViewController作为Window的根视图控制器，然后管理着若干个导航控制器UINavigationBarController，再由导航栏控制器去管理普通的视图控制器UIViewController。若以此为例的话，关于旋转的优先级从高到低就是UITabbarViewController>UINavigationBarController >UIViewController了。如果具有高优先级的控制器关闭了旋转设置，那么低优先级的控制器是无法做到旋转的。
 
 在Tabbar中设置屏幕旋转
 //是否自动旋转
 -(BOOL)shouldAutorotate{
     return self.selectedViewController.shouldAutorotate;
 }

 //支持哪些屏幕方向
 - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
     return [self.selectedViewController supportedInterfaceOrientations];
 }

 //默认方向
 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
     return [self.selectedViewController preferredInterfaceOrientationForPresentation];
 }
 
 导航控制器UINavigationController
 
 //是否自动旋转
 //返回导航控制器的顶层视图控制器的自动旋转属性，因为导航控制器是以栈的原因叠加VC的
 //topViewController是其最顶层的视图控制器，
 -(BOOL)shouldAutorotate{
     return self.topViewController.shouldAutorotate;
 }

 //支持哪些屏幕方向
 - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
     return [self.topViewController supportedInterfaceOrientations];
 }

 //默认方向
 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
     return [self.topViewController preferredInterfaceOrientationForPresentation];
 }
 
 方法2 模态推出
 使用模态视图可以不受这种根视图控制器优先级的限制。这个也很容易理解，模态弹出的视图控制器是隔离出来的，不受根视图控制的影响。具体的设置和普通视图器代码相同，这里就不累述了。
 
 方法1：使用基类控制器逐级控制
 方法2：Appdelegate增设旋转属性，本项目中使用的此方法
 
 默认横屏无效的问题
 在上面的项目中，我们可能会遇到一个关于默认横屏的问题，把它拿出来细说一下。 我们项目中有支持竖屏的界面A，也有支持横竖屏的界面B，而且界面B需要进入时就显示横屏。从界面A到界面B中，如果我们使用第五节中的方法1会遇到无法显示默认横屏的情况，因为没有旋转设备，shouldAutorotate就没被调用，也就没法显示我们需要的横屏。
 
 方法1：在自定义导航控制器中增加以下方法
 #pragma mark -UINavigationControllerDelegate
 //不要忘记设置delegate
 - (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
     [self presentViewController:[UIViewController new] animated:NO completion:^{
         [self dismissViewControllerAnimated:NO completion:nil];
     }];
 }
 
 
 这个方法的缺点是，原理上利用弹出模态视图来调用转屏，造成切换界面的时候有闪烁效果，体验不佳。所以这里也只是提供一种思路，不推荐使用。
 
 方法2:在需要默认横屏的界面里设置，进入时强制横屏，离开时强制竖屏，如本项目
 
 注：两种方法不可同时使用
 
 关于旋转后的适配问题
 
 屏幕旋转的实现会带来相应的UI适配问题，我们需要针对不同方向下的界面重新调整视图布局。首先我们要能够监测到屏幕旋转事件，这里分为两种情况：
 
 1.视图控制器UIViewController里的监测
 当发生转屏事件的时候，下面的UIViewControoller方法会监测到视图View的大小变化，从而帮助我们适配
 - (void)viewWillTransitionToSize:(CGSize)size
 withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator NS_AVAILABLE_IOS(8_0);
 
 此方法在屏幕旋转的时候被调用，我们使用时候也应该首先调用super方法，具体代码使用示例如下：
 - (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
     [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
     if (size.width > size.height) {
         //横屏设置，为防止遮挡键盘,调整输入视图的高度
         self.textView_height.constant = 50;
     }else{
         //竖屏设置
         self.textView_height.constant = 200;
     }
 }
 
 2.子视图横竖屏监测
 如果是类似于表视图的单元格，要监测到屏幕变化实现适配，我们需要用到layoutSubviews方法，因为屏幕切换横竖屏时会触发此方法，然后我们根据状态栏的位置就可以判断横竖屏了，代码示例如下：
 
 - (void)layoutSubviews {
     [super layoutSubviews];
      //通过状态栏电池图标判断横竖屏
     if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationMaskPortrait) {
         //竖屏布局
     } else {
         //横屏布局
     }
 }
 
 参考文档 http://www.manongjc.com/detail/51-ooothccwrfhzdvi.html

*/
