//
//  ChangePwViewController.m
//  与你同游
//
//  Created by rimi on 15/10/16.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "ChangePwViewController.h"
#import "AnimationView.h"
#import "UserModel.h"
#import "LoadingView.h"


#define THEMECOLORLINE [UIColor colorWithWhite:0.728 alpha:1.000]
@interface ChangePwViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextField *aNewpasswordTF;
@property (nonatomic, strong) UITextField *oldpasswordTF;
@property (nonatomic, strong) UITextField *newPassword;
@property (nonatomic, strong) UIView *upview;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) AnimationView *animationView;
@property (nonatomic, strong) UIView *downView;
@property (nonatomic, strong) LoadingView *load;
@property (nonatomic, strong) UserModel *userModel;

@end
@implementation ChangePwViewController
- (void)dealloc {

    [self.userModel removeObserver:self forKeyPath:@"forgetPasswordResult"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.userModel addObserver:self forKeyPath:@"forgetPasswordResult" options:NSKeyValueObservingOptionNew context:nil];
    [self initUserInterface];
}

#pragma mark --KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"forgetPasswordResult"]) {
        if ([self.userModel.forgetPasswordResult isEqualToString:@"YES"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码修改成功，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
             [[NSUserDefaults standardUserDefaults] setObject:@"out" forKey:@"loginState"];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码修改失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        [self.load hide];
    }
    
}
- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"修改密码"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.downView];
    [self.downView addSubview:self.animationView];
    [self.animationView addSubview:self.textView];
    [self.textView addSubview:self.aNewpasswordTF];
    [self.textView addSubview:self.oldpasswordTF];
    [self.textView addSubview:self.newPassword];
    [self.view addSubview:self.completeButton];
    
    
    UIView *pinsView = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(0, 0, 16, 16), NO)];
    pinsView.center =  flexibleCenter(CGPointMake(375 / 2, 64), NO);
    pinsView.backgroundColor = [UIColor colorWithRed:0.518 green:0.529 blue:0.511 alpha:1.000];
    pinsView.layer.cornerRadius = 8;
    pinsView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    pinsView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    pinsView.layer.shadowOpacity = 0.5;//不透明度
    pinsView.layer.shadowRadius = 5.0;
    [self.view addSubview:pinsView];
    
    
}
- (void)completeChangeEvent:(UIButton *)sender {
    if (self.oldpasswordTF.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您的旧密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if (self.oldpasswordTF.text.length < 6 || self.oldpasswordTF.text.length > 16){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入正确的旧密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if (self.newPassword.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您的新密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if (self.newPassword.text.length < 6 || self.newPassword.text.length > 16) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入正确格式的新密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if (self.aNewpasswordTF.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请重复输入您的新密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if (self.aNewpasswordTF.text.length < 6 || self.aNewpasswordTF.text.length > 16) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请重复输入正确格式的新密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if ([self.newPassword.text isEqualToString:self.aNewpasswordTF.text] == NO) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"新密码和重复的新密码不同" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [self.userModel ForgotPasswordWithPhone:PHONE_NUMBER newPassword:self.newPassword.text];
    [self.load  show];
    
}

- (CAKeyframeAnimation *)KeyrotationAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = @[@(-M_PI / 36), @(M_PI / 40), @(-M_PI / 50), @(M_PI / 70), @0];
    animation.duration = 2;
    animation.keyTimes = @[@0, @0.25, @0.5, @0.75, @1];
    animation.additive = YES;
    return animation;
}

- (UITextField *)aNewpasswordTF {
    if (!_aNewpasswordTF) {
        _aNewpasswordTF = ({
            UITextField *textField = [[UITextField alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 260, 40), NO)];
            textField.center =  flexibleCenter(CGPointMake(300 / 2, 155), NO);
            textField.placeholder = @"请再次输入新密码";
            CGRect userNameFrame = [textField frame];
            userNameFrame.size.width = 15.0f;
            UIView *userNameLeftview = [[UIView alloc] initWithFrame:userNameFrame];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.leftView = userNameLeftview;
            textField.secureTextEntry = YES;
            textField;
        });
    }
    return _aNewpasswordTF;
}


- (UITextField *)oldpasswordTF {
    if (!_oldpasswordTF) {
        _oldpasswordTF = ({
            UITextField *textField = [[UITextField alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 260, 40), NO)];
            textField.center =  flexibleCenter(CGPointMake(300 / 2, 35), NO);
            textField.placeholder = @"请输入旧密码";
            CGRect userNameFrame = [textField frame];
            userNameFrame.size.width = 15.0f;
            UIView *userNameLeftview = [[UIView alloc] initWithFrame:userNameFrame];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.leftView = userNameLeftview;
            textField.layer.borderColor = THEMECOLORLINE.CGColor;
            textField;
        });
    }
    return _oldpasswordTF;
}

- (UITextField *)newPassword {
    if (!_newPassword) {
        _newPassword = ({
            UITextField *textField = [[UITextField alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 130, 40), NO)];
            textField.center =  flexibleCenter(CGPointMake(300 / 4 + 12, 95), NO);
            textField.placeholder = @"请输入新密码";
            CGRect userNameFrame = [textField frame];
            userNameFrame.size.width = 15.0f;
            UIView *userNameLeftview = [[UIView alloc] initWithFrame:userNameFrame];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.leftView = userNameLeftview;
            textField.layer.borderColor = THEMECOLORLINE.CGColor;
            textField.secureTextEntry = YES;
            textField;
        });
    }
    return _newPassword;
}

- (UIButton *)completeButton {
    if (!_completeButton) {
        _completeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(0, 0, 300,50), NO);
            button.center =  flexibleCenter(CGPointMake(WIDTH / 2, 600), NO);
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            button.layer.borderColor = THEMECOLOR.CGColor;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 5.0F;
            button.backgroundColor = THEMECOLOR;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"完成修改" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(completeChangeEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _completeButton;
}

- (UIView *)textView {
    if (!_textView) {
        _textView = ({
            UIView *view = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(0, 0, 300, 240), NO)];
            view.center =  flexibleCenter(CGPointMake(375 / 2, 370 - 64), NO);
            view.layer.cornerRadius = 10;
            for (int i = 0; i < 3; i ++) {
                UIView *line = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(0, 0, 250, 1), NO)];
                line.center =  flexibleCenter(CGPointMake(300 / 2, 60 * i +60), NO);
                line.backgroundColor = [UIColor colorWithWhite:0.811 alpha:1.000];
                line.layer.borderColor = [UIColor colorWithWhite:0.811 alpha:1.000].CGColor;
                [view addSubview:line];
            }
            UIView *pins1 = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(39.5 + 4, 0, 2, 8), NO)];
            pins1.backgroundColor = [UIColor colorWithWhite:0.537 alpha:1.000];
            [view addSubview:pins1];
            UIView *pins = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(262.5 - 6, 0, 2, 8), NO)];
            pins.backgroundColor = [UIColor colorWithWhite:0.537 alpha:1.000];
            [view addSubview:pins];
            view.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
            view.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
            view.layer.shadowOpacity = 0.5;//不透明度
            view.layer.shadowRadius = 10.0;//半径
            view.backgroundColor = [UIColor colorWithRed:1.000 green:0.976 blue:0.721 alpha:1.000];
            view;
        });
    }
    return _textView;
}


- (AnimationView *)animationView {
    if (!_animationView) {
        _animationView = ({
            AnimationView *view = [[AnimationView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.frame = flexibleFrame(CGRectMake(375 / 2, 0, 375.0, 375.0), NO);
            view.layer.position = flexibleCenter(CGPointMake(375.0 / 2, 0), NO);
            view.layer.anchorPoint = CGPointMake(0.5, 0);
            
            [view.layer addAnimation:[self KeyrotationAnimation]forKey:@""];
            view;
        });
    }
    return  _animationView;
}
- (UIView *)downView {
    if (!_downView) {
        _downView = ({
            UIView *view = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(0, 64.0, 375, 500), NO)];
            view;
        });
    }
    return _downView;
}
- (LoadingView *)load {
    if (!_load) {
        _load = [[LoadingView alloc] init];
    }
    return _load;
}
- (UserModel *)userModel {
    if (!_userModel) {
        _userModel = [[UserModel alloc] init];
    }
    return _userModel;
}

@end
