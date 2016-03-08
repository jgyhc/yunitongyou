//
//  RegisterViewController.m
//  viewController
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserModel.h"
#import "AnimationView.h"
#import "LoadingView.h"

#define THEMECOLORLINE [UIColor colorWithWhite:0.728 alpha:1.000]
@interface RegisterViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UITextField *repeatPasswordTF;
@property (nonatomic, strong) UITextField *phoneNumberTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIView *upview;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) AnimationView *animationView;
@property (nonatomic, strong) LoadingView *load;
@property (nonatomic, strong) UserModel *userModel;


@end

@implementation RegisterViewController

- (void)dealloc {
    [self.userModel removeObserver:self forKeyPath:@"userData"];
    [self.userModel removeObserver:self forKeyPath:@"VerificationCode"];
    [self.userModel removeObserver:self forKeyPath:@"VerificationCodeResult"];
    [self.userModel removeObserver:self forKeyPath:@"registerResult"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.registerResult
    [self initUserInterface];
    [self.userModel addObserver:self forKeyPath:@"userData" options:NSKeyValueObservingOptionNew context:nil];
    [self.userModel addObserver:self forKeyPath:@"VerificationCode" options:NSKeyValueObservingOptionNew context:nil];
    [self.userModel addObserver:self forKeyPath:@"VerificationCodeResult" options:NSKeyValueObservingOptionNew context:nil];
    [self.userModel addObserver:self forKeyPath:@"registerResult" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.animationView];
    [self.view addSubview:self.navView];
    [self initBackButton];
    [self initNavTitle:@"注册"];
    [self.animationView addSubview:self.textView];
    //    [self.textView addSubview:self.usernameTF];
    [self.textView addSubview:self.passwordTF];
    [self.textView addSubview:self.repeatPasswordTF];
    [self.textView addSubview:self.phoneNumberTF];
    [self.textView addSubview:self.codeTF];
    [self.view addSubview:self.completeButton];
    
    UIView *baseView = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(160, 70, 120, 40), NO)];
    baseView.backgroundColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    baseView.layer.cornerRadius = 5;
    
    UIView *upView = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(160, 70, 120, 40), NO)];
    upView.backgroundColor = THEMECOLOR;
    upView.layer.cornerRadius = 5;
    
    UILabel *label = [[UILabel alloc] initWithFrame:flexibleFrame(CGRectMake(160, 70, 120, 40), NO)];
    
    self.upview = upView;
    //手势
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)];
    [upView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    
    singleTap.cancelsTouchesInView = NO;
    label.text = @"获取验证码";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.textView addSubview:baseView];
    [self.textView addSubview:upView];
    [self.textView addSubview:label];
    
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"VerificationCode"]) {
        NSLog(@"%@", self.userModel.VerificationCode);
    }
    if ([keyPath isEqualToString:@"userData"]) {
        NSLog(@"%@", self.userModel.userData);
        
        if ([self.userModel.userData objectForKey:@"objectId"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该账号已经注册！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            [self.load hide];
            return;
        }else {
            [self.userModel VerificationCodeWithVerificationCode:self.codeTF.text phoneNumber:self.phoneNumberTF.text];
        }
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if ([keyPath isEqualToString:@"VerificationCodeResult"]) {
        if ([self.userModel.VerificationCodeResult isEqualToString:@"YES"]) {
            [self.userModel registeredWithPhoneNumber:self.phoneNumberTF.text password:self.passwordTF.text successBlock:nil failBlock:nil];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }
    if ([keyPath isEqualToString:@"registerResult"]) {
        if ([self.userModel.registerResult isEqualToString:@"YES"]) {
            [self.navigationController popViewControllerAnimated:YES];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"注册成功，请登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        }else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"注册失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        [self.load hide];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneNumberTF) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    if (textField == self.passwordTF || textField == self.repeatPasswordTF) {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }
    if (textField == _codeTF) {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
}

- (void)handleSingleTap1:(UITapGestureRecognizer *)sender {
    if (self.phoneNumberTF.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if (_phoneNumberTF.text.length != 11 || [self isPureNumandCharacters:_phoneNumberTF.text] == NO || [self isMobileNumber:_phoneNumberTF.text] == NO) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入正确格式的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else {
        
        [self.userModel VerificationCodeWithPhoneNumber:self.phoneNumberTF.text];
        self.upview.frame = flexibleFrame(CGRectMake(160, 70, 0, 40), NO);
        [UIView animateWithDuration:30 animations:^{
            self.upview.frame = flexibleFrame(CGRectMake(160, 70, 120, 40), NO);
        }];
    }
}

- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)completeRegisterEvent:(UIButton *)sender {
    [self.load show];
    if (_phoneNumberTF.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入您的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }else if (_phoneNumberTF.text.length != 11 || [self isPureNumandCharacters:_phoneNumberTF.text] == NO || [self isMobileNumber:_phoneNumberTF.text] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入正确格式的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }else if (_codeTF.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }else if (_codeTF.text.length != 4) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入正确格式的验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }else if (_passwordTF.text.length < 6 || _passwordTF.text.length >16){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入6-16位的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }else if ([_passwordTF.text isEqualToString:_repeatPasswordTF.text] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"两次密码不一致，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    

    [self.userModel registeredWithPhoneNumber:_phoneNumberTF.text password:_passwordTF.text successBlock:^(NSString *objiectId) {
        
        [self.load hide];
        
    } failBlock:^(NSError *error) {
        
        
    }];
    
}
- (CAKeyframeAnimation *)KeyrotationAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = @[@(-M_PI / 36), @(M_PI / 40), @(-M_PI / 50), @(M_PI / 70), @0];
    animation.duration = 1.5;
    animation.keyTimes = @[@0, @0.25, @0.5, @0.75, @1];
    animation.additive = YES;
    return animation;
}

- (UITextField *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = ({
            UITextField *textField = [[UITextField alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 260, 40), NO)];
            textField.center =  flexibleCenter(CGPointMake(300 / 2, 155), NO);
            textField.placeholder = @"请输入密码";
            CGRect userNameFrame = [textField frame];
            userNameFrame.size.width = 15.0f;
            UIView *userNameLeftview = [[UIView alloc] initWithFrame:userNameFrame];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.leftView = userNameLeftview;
            textField.secureTextEntry = YES;
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            textField;
        });
    }
    return _passwordTF;
}

- (UITextField *)repeatPasswordTF {
    if (!_repeatPasswordTF) {
        _repeatPasswordTF = ({
            UITextField *textField = [[UITextField alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 260, 40), NO)];
            textField.center =  flexibleCenter(CGPointMake(300 / 2, 215), NO);
            textField.placeholder = @"请再次输入密码";
            CGRect userNameFrame = [textField frame];
            userNameFrame.size.width = 15.0f;
            UIView *userNameLeftview = [[UIView alloc] initWithFrame:userNameFrame];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.leftView = userNameLeftview;
            textField.layer.borderColor = THEMECOLORLINE.CGColor;
            textField.secureTextEntry = YES;
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            textField;
        });
    }
    return _repeatPasswordTF;
}

- (UITextField *)phoneNumberTF {
    if (!_phoneNumberTF) {
        _phoneNumberTF = ({
            UITextField *textField = [[UITextField alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 260, 40), NO)];
            textField.center =  flexibleCenter(CGPointMake(300 / 2, 35), NO);
            textField.placeholder = @"请输入手机号";
            CGRect userNameFrame = [textField frame];
            userNameFrame.size.width = 15.0f;
            UIView *userNameLeftview = [[UIView alloc] initWithFrame:userNameFrame];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.leftView = userNameLeftview;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.layer.borderColor = THEMECOLORLINE.CGColor;
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            textField;
        });
    }
    return _phoneNumberTF;
}

- (UITextField *)codeTF {
    if (!_codeTF) {
        _codeTF = ({
            UITextField *textField = [[UITextField alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 130, 40), NO)];
            textField.center =  flexibleCenter(CGPointMake(300 / 4 + 12, 95), NO);
            textField.placeholder = @"验证码";
            CGRect userNameFrame = [textField frame];
            userNameFrame.size.width = 15.0f;
            UIView *userNameLeftview = [[UIView alloc] initWithFrame:userNameFrame];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.leftView = userNameLeftview;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.layer.borderColor = THEMECOLORLINE.CGColor;
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            textField;
        });
    }
    return _codeTF;

}
- (UIButton *)completeButton {
    if (!_completeButton) {
        _completeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(0, 0, 300, 50), NO);
            button.center =  flexibleCenter(CGPointMake(WIDTH / 2, 600), NO);
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            button.layer.borderColor = THEMECOLOR.CGColor;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 5.0F;
            button.backgroundColor = THEMECOLOR;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"完成注册" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(completeRegisterEvent:) forControlEvents:UIControlEventTouchUpInside];
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
                line.layer.borderWidth = 0.5;
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
            view.frame = flexibleFrame(CGRectMake(375 / 2, 0, 375.0, 450.0), NO);
            view.layer.position = flexibleCenter(CGPointMake(375.0 / 2, 23), NO);
            view.layer.anchorPoint = CGPointMake(0.5, 0);
            [view.layer addAnimation:[self KeyrotationAnimation]forKey:@""];
            view;
        });
    }
    return  _animationView;
}



- (UserModel *)userModel {
    if (!_userModel) {
        _userModel = [[UserModel alloc]init];
    }
    return _userModel;
}

- (LoadingView *)load {
    if (!_load) {
        _load = [[LoadingView alloc] init];
    }
    return _load;
}
@end
