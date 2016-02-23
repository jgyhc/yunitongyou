//
//  DrawerViewController.m
//  Deep_Breath
//
//  Created by rimi on 15/9/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "DrawerViewController.h"
 
#define LEFT_W 300
#define SYSTEM_V [[[UIDevice currentDevice] systemVersion] floatValue]
@interface DrawerViewController ()

@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIPanGestureRecognizer *RightpanGestureRecognizer;
@property (nonatomic, strong) UIButton *rightMaskButton;
@property (nonatomic, assign) BOOL isAutoLogin;
  


@end

@implementation DrawerViewController
#pragma mark -- 带左抽屉的初始化
- (instancetype)initWithMainViewControlle:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController {
    self = [super init];
    if (self) {
        _leftViewController = leftViewController;
        _mainViewController = mainViewController;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#pragma mark -- 判断是否需要重新登录
//    self.isAutoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
//    if (self.isAutoLogin) {
//        [self toAutoLogin];
//    }else {
//    [self initUserInterface];
//    }
    [self initUserInterface];
}
//判断是否需要推送登录界面
- (void)toAutoLogin {
    //自动网络请求
    
    
    
}

#pragma mark -- 页面加载
- (void)initUserInterface {
    [self addChildViewController:self.leftViewController];
    [self addChildViewController:self.mainViewController];
    
    self.leftViewController.view.frame = flexibleFrame(CGRectMake(-LEFT_W, 0, LEFT_W, 667), NO);
    [self.mainViewController.view addGestureRecognizer:self.RightpanGestureRecognizer];
//    [self.mainViewController.view addGestureRecognizer:self.edgePanGesture];
}
#pragma mark -- 加载子视图控制器
- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    [self.view addSubview:childController.view];
    
}


#pragma mark -- 打开左视图
- (void)openLeftViewController {
    [UIView animateWithDuration:0.2 animations:^{
        self.leftViewController.view.frame = flexibleFrame(CGRectMake(0, 0, LEFT_W, 667), NO);
        self.mainViewController.view.frame = flexibleFrame(CGRectMake( LEFT_W, 0, 375, 667), NO);
    } completion:^(BOOL finished) {
    }];
    [[NSUserDefaults standardUserDefaults]  setValue:@"0" forKey:@"switch1"];
}
#pragma mark -- 关闭左视图
- (void)closeLeftViewController {
    [UIView animateWithDuration:0.4 animations:^{
        self.mainViewController.view.frame = flexibleFrame(CGRectMake( 0, 0, 375, 667), NO);
        self.leftViewController.view.frame = flexibleFrame(CGRectMake(-LEFT_W, 0, LEFT_W, 667), NO);
    } completion:^(BOOL finished) {
    }];
    [[NSUserDefaults standardUserDefaults]  setValue:@"1" forKey:@"switch1"];
}
- (void)action_buttonPressed:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults]  setValue:@"1" forKey:@"switch1"];
    [self closeLeftViewController];
}
- (void)handlePan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged ) {
        CGFloat velocity = [sender translationInView:self.mainViewController.view].x;
        if (velocity < 0 || velocity > 235) {
            return;
        }
        CGFloat tranlation = [sender translationInView:self.view].x;
        CGFloat precent = (tranlation * 1.6) / self.view.frame.size.width;
        self.mainViewController.view.frame = flexibleFrame(CGRectMake(LEFT_W * precent, 0, 375, 667), NO);
        self.leftViewController.view.frame = flexibleFrame(CGRectMake(-LEFT_W + LEFT_W * precent, 0, LEFT_W, 667), NO);
        
        
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat velocity = [sender translationInView:self.view].x;
        CGFloat precent = velocity / self.view.frame.size.width;
        
        if (precent >= 0.5) {
            [self openLeftViewController];
        }else {
            [self closeLeftViewController];
        }
    }
    

}
#pragma mark --Getter
- (UIPanGestureRecognizer *)RightpanGestureRecognizer {
    if (!_RightpanGestureRecognizer) {
        _RightpanGestureRecognizer = ({
        
            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                            initWithTarget:self
                                                            action:@selector(handlePan:)];
            panGestureRecognizer;
        });
    }
    return _RightpanGestureRecognizer;
}





                       
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
