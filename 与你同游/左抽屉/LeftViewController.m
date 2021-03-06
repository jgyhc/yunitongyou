//
//  LeftViewController.m
//  Deep_Breath
//
//  Created by rimi on 15/9/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "LeftViewController.h"
#import "gradientView.h"
#import "LoginViewController.h"

#import "MyCollectionViewController.h"
#import "MyTravelsViewController.h"
#import "MyActivitiesViewController.h"

#import "SetViewController.h"
#import "UserModel.h"
#import "LoadingView.h"

#import "PersonalViewController.h"

#import "UIImageView+WebCache.h"//图片缓存，第三方提供（不是系统的，也不是自己写的，这里是网上提供的图片）




#define IMAGE_NAME(X) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:(X)]]

@interface LeftViewController ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) gradientView *gradient;
@property (nonatomic, strong) UIButton *userName;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) LoadingView *load;
@end

@implementation LeftViewController

- (void)dealloc {
    [self.user removeObserver:self forKeyPath:@"getUserData"];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:NO];
    
    [self.user addObserver:self forKeyPath:@"getUserData" options:NSKeyValueObservingOptionNew context:nil];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginState"] isEqualToString:@"in"]) {
        
        [self.user getwithObjectId:OBJECTID successBlock:nil failBlock:nil];
        
    }else {
        self.icon.image = IMAGE_NAME(@"用户未登录.png");
        [self.userName setTitle:@"点击登录" forState:UIControlStateNormal];
        self.userName.userInteractionEnabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {
    
    if ([keyPath isEqualToString:@"getUserData"]) {
        if (![[self.user.getUserData objectForKey:@"username"] isEqualToString:@"还没取昵称哟！"]) {
            [self.userName setTitle:[self.user.getUserData objectForKey:@"username"]  forState:UIControlStateNormal];
            self.userName.userInteractionEnabled = NO;
        }else {
            [self.userName setTitle:[self.user.getUserData objectForKey:@"phoneNumber"]  forState:UIControlStateNormal];
            self.userName.userInteractionEnabled = NO;
        }
        NSString * imageString =[self.user.getUserData objectForKey:@"head_portraits"];
        if (imageString.length > 0) {
            NSURL * imageUrl = [NSURL URLWithString:[self.user.getUserData objectForKey:@"head_portraits"]];
            [self.icon sd_setImageWithURL:imageUrl];
        }
        else{
            self.icon.image = IMAGE_PATH(@"无头像.png");
        }
         self.icon.clipsToBounds = YES;
        
            
        
    }
}

- (void)initUserInterface {
    [self.view addSubview:self.gradient];
    [self.view addSubview:self.icon];
    [self.view addSubview:self.userName];
    
    NSArray * myselfNameArray = @[@"我的收藏",@"我的活动", @"我的游记", @"设置"];
    NSArray * imageArray = @[@"我的收藏.png",@"我的发起.png", @"我的游记.png", @"设置.png"];
    
    for (int i = 0 ; i < myselfNameArray.count; i ++)
    {
        UIView *line = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(40, 330 + i * 65, 230, 1), NO)];
        line.backgroundColor = [UIColor colorWithRed:0.694 green:1.000 blue:0.769 alpha:1.000];
        [self.view addSubview:line];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        button.frame = flexibleFrame(CGRectMake(0, 270 + i * 65, 300, 60), YES);
        [button setImage:IMAGE_NAME(imageArray[i]) forState:UIControlStateNormal];
        [button setImage:IMAGE_NAME(imageArray[i]) forState:UIControlStateHighlighted];
        
        button.imageEdgeInsets = UIEdgeInsetsMake((SCREEN_WIDTH / WIDTH) * 19, (SCREEN_HEIGHT / HEIGHT) * 12, (SCREEN_WIDTH / WIDTH) * 16, (SCREEN_HEIGHT / HEIGHT) * 225);
        
        [button setTitle:myselfNameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        button.contentEdgeInsets = UIEdgeInsetsMake(0, (SCREEN_WIDTH / WIDTH) * 40, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [button addTarget:self action:@selector(handleEventUserCenter:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:flexibleFrame(CGRectMake(240, 290 + i * 65, 26, 24), NO)];
        image.image = IMAGE_NAME(@"xiangyou.png");
        [self.view addSubview:image];
    }
}
#pragma mark -- private methods
- (void)photoTapped{
        if ([self.userName.titleLabel.text isEqualToString:@"点击登录"]) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alertView show];
            
        }
        else{
            PersonalViewController *PVC = [[PersonalViewController alloc] init];
            PVC.userInfo = self.user.getUserData;
            PVC.type = 0;
            [self presentViewController:PVC animated:YES completion:nil];
        }
}
#pragma mark -- 进入登录页面
- (void)handleEventLogin:(UIButton *)sender {
    LoginViewController *loginView = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginView animated:YES];
}
#pragma mark --进入
- (void)handleEventUserCenter:(UIButton * )sender
{
    if (!OBJECTID && sender.tag != 105) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录喔！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }

    if (sender.tag == 100)
    {
        MyCollectionViewController *MCVC = [[MyCollectionViewController alloc] init];
        [self.navigationController pushViewController:MCVC animated:YES];
    }
    if (sender.tag == 101)
    {
        MyActivitiesViewController * MAVC = [[MyActivitiesViewController alloc] init];
        [self.navigationController pushViewController:MAVC animated:YES];
    }if (sender.tag == 102)
    {
        MyTravelsViewController *MTVC = [[MyTravelsViewController alloc] init];
        [self.navigationController pushViewController:MTVC animated:YES];
    }if (sender.tag == 103)
    {
        SetViewController *settingVC = [[SetViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
        
    }
}

#pragma mark --getter

- (UIImageView *)icon {
    if (!_icon) {
        _icon = ({
            UIImageView *view = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(100, 100, 100, 100), YES)];
            view.backgroundColor = [UIColor whiteColor];
            view.image = IMAGE_NAME(@"用户未登录.png");
            view.layer.cornerRadius = flexibleWidth(50);
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped)];
            [view addGestureRecognizer:singleTap];
            view;
        });
    }
    return _icon;
}
- (gradientView *)gradient {
    if (!_gradient) {
        _gradient = ({
            gradientView *view= [[gradientView alloc] initWithFrame:flexibleFrame(CGRectMake(0, 0, 300, 667), YES)];
            view;
        });
    }
    return _gradient;
}

- (UIButton *)userName {
    if (!_userName) {
        _userName = ({
            UIButton *button = [[UIButton alloc] init];
            button.frame = flexibleFrame(CGRectMake(0, 0, 200, 20), NO);
            button.center = flexibleCenter(CGPointMake(300 / 2, 220), NO);
            [button addTarget:self action:@selector(handleEventLogin:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button;
        
        });
    }
    return _userName;

}


- (UserModel *)user {
    if (!_user) {
        _user = [[UserModel alloc] init];
    }
    return _user;
}


- (LoadingView *)load {
    if (!_load) {
        _load = [[LoadingView alloc] init];
    }
    return _load;
}








@end
