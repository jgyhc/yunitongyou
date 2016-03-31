//
//  LoginViewController.m
//  viewController
//
//  Created by rimi on 15/10/10.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "LoginViewController.h"
#import "PreviousForgetViewController.h"
#import "RegisterViewController.h"
#import "UserModel.h"
#import "UIAlertController+Blocks.h"
#import "LoadingView.h"
#define IMAGE_NAME(X) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:(X)]]

@interface LoginViewController ()

@property (nonatomic, strong)UITextField *phoneNumberTF;
@property (nonatomic, strong)UITextField *passwordTF;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong)UIButton *loginButton;
@property (nonatomic, strong)UIButton *forgetButton; //跳转忘记密码按钮
@property (nonatomic, strong)UIButton *registerButton;
@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UILabel *navLabel;
@property (nonatomic, strong)UserModel *user;
@property (nonatomic, strong)LoadingView *loading;

@end

@implementation LoginViewController

- (void)dealloc {
    [self.user removeObserver:self forKeyPath:@"loginUserData"];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *customBackgournd = [[UIImageView alloc] initWithImage:IMAGE_NAME(@"登录背景图.jpg")];
    customBackgournd.frame = flexibleFrame(CGRectMake(0, 0, 375, 667), NO);
    [self.view addSubview:customBackgournd];
    [self.view addSubview:self.textView];
    [self.textView addSubview:self.phoneNumberTF];
    [self.textView addSubview:self.passwordTF];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.forgetButton];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.navLabel];
    
    [self.user addObserver:self forKeyPath:@"loginUserData" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneNumberTF) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    if (textField == self.passwordTF) {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }
}

- (void)registerButtonAction:(UIButton *)sender {
    RegisterViewController *registerView = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];
}

- (void)forgetAction:(UIButton *)sender {
    PreviousForgetViewController *CFVC = [[PreviousForgetViewController alloc] init];
    [self.navigationController pushViewController:CFVC animated:YES];
}

#pragma mark --登录
- (void)loginButtonAction:(UIButton *)sender {
    if (_phoneNumberTF.text.length == 0) {
        [self message:@"请输入您的手机号"];
    }else if (_phoneNumberTF.text.length != 11 || [self isPureNumandCharacters:_phoneNumberTF.text] == NO || [self isMobileNumber:_phoneNumberTF.text] == NO){
        [self message:@"请输入正确的手机号" ];
    }else if (_passwordTF.text.length == 0 || _passwordTF.text.length < 6) {
        [self message:@"请输入正确的密码"];
    }else {
        [self.loading show];
        [self.user loginWithPhoneNumber:self.phoneNumberTF.text password:self.passwordTF.text successBlock:^(BmobObject *object) {
            [self.loading hide];
            [[NSUserDefaults standardUserDefaults] setObject:object.objectId forKey:@"userID"];
            [self.navigationController popViewControllerAnimated:YES];
        } failBlock:^(NSError *error) {
            [self.loading hide];
            [self message:@"用户名或者密码错误！"];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.loading hide];
        });
    }
}

- (void)message:(NSString *)message {
    [UIAlertController showAlertInViewController:self withTitle:@"温馨提示" message:message cancelButtonTitle:@"确认" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
    }];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loginUserData"]) {

        if (self.user.loginUserData) {
            [self.loading hide];
            [[NSUserDefaults standardUserDefaults] setObject:[self.user.loginUserData objectForKey:@"phoneNumber"] forKey:@"phoneNumber"];
            [[NSUserDefaults standardUserDefaults] setObject:[self.user.loginUserData objectForKey:@"password"] forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setObject:self.user.loginUserData.objectId  forKey:@"objectId"];
          [[NSUserDefaults standardUserDefaults] setObject:[self.user.loginUserData objectForKey:@"username"]  forKey:@"username"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"in" forKey:@"loginState"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
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
#pragma mark --getter

- (UITextField *)phoneNumberTF {
    if (!_phoneNumberTF) {
        _phoneNumberTF = ({
            UITextField *textField = [[UITextField alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 240, 40), NO)];
            textField.center =  flexibleCenter(CGPointMake(300 / 2, 40 + 5), NO);
            textField.placeholder = @"请输入账号";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            textField.textAlignment = NSTextAlignmentLeft;
            textField;
        });
    }
    return _phoneNumberTF;
}

- (UITextField *)passwordTF{
    if (!_passwordTF) {
        _passwordTF = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:flexibleFrame(CGRectMake(0, 0, 240, 40), NO)];
            textField.center =  flexibleCenter(CGPointMake(300 / 2, 120 - 5), NO);
            textField.placeholder = @"请输入密码";
//            textField.text = @"lc007555";
            textField.textAlignment = NSTextAlignmentLeft;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            textField;
        });
    }
    return _passwordTF;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(0, 0, 300, 50), NO);
            button.center =  flexibleCenter(CGPointMake(WIDTH / 2, 440), NO);
            button.layer.cornerRadius = 5.0;
            button.backgroundColor = THEMECOLOR;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"登录" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _loginButton;
}

- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(0, 0, 180, 50), NO);
            button.center =  flexibleCenter(CGPointMake(WIDTH / 4, HEIGHT - 50), NO);
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"忘记密码？" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _forgetButton;
}
- (UIView *)textView {
    if (!_textView) {
        _textView = ({
            UIView *view = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(0, 0, 300, 150), NO)];
            view.center =  flexibleCenter(CGPointMake(375 / 2, 300), NO);
            view.layer.cornerRadius = 10;
            UIView *line = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(0, 0, 250, 1), NO)];
            line.center =  flexibleCenter(CGPointMake(300 / 2, 80), NO);
            line.layer.borderWidth = 0.5;
            line.layer.borderColor = [UIColor colorWithWhite:0.828 alpha:1.000].CGColor;
            [view addSubview:line];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _textView;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(0, 0, 180, 50), NO);
            button.center =  flexibleCenter(CGPointMake(WIDTH / 4 * 3, HEIGHT - 50), NO);
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"注册" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        
        });
    }
    return _registerButton;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(12, 27, 24, 24), NO);
            [button setBackgroundImage:[UIImage imageNamed:@"返回_白色"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _leftButton;
}

- (UILabel *)navLabel {
    if (!_navLabel) {
        _navLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 150, 40), NO)];
            label.center =  flexibleCenter(CGPointMake(WIDTH / 2, 40), NO);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont italicSystemFontOfSize:22];
            label.textColor = [UIColor whiteColor];
            label.text = @"登录";
            label;
        });
    }
    return _navLabel;
}

- (UserModel *)user {
    if (!_user) {
        _user = [[UserModel alloc]init];
    }
    return _user;
}

- (LoadingView *)loading {
    if (!_loading) {
        _loading = [[LoadingView alloc] init];
    }
    return _loading;
}


@end
