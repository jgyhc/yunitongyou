//
//  BaseViewController.m
//  viewController
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "BaseViewController.h"
#import "ControllerManager.h"
@interface BaseViewController ()

@property (nonatomic, strong)UILabel *navLabel;
 
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initYoyoUserInterface];
}

- (void)initYoyoUserInterface {
    [self.view addSubview:self.navView];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

}
- (void)initBackButton {
    [_navView addSubview:self.leftButton];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"返回_白色"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initPersonButton {
    [_navView addSubview:self.leftButton];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"左抽屉按钮"] forState:UIControlStateNormal];
    
}

- (void)setNavViewColor:(UIColor *)color {
    _navView.backgroundColor = color;
}

- (void)initRightButtonEvent:(SEL)selector Image:(UIImage *)image{
    [_navView addSubview:self.rightButton];
    [_rightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setImage:image forState:UIControlStateNormal];
}

- (void)initRightButtonEvent:(SEL)selector title:(NSString *)string {
    [_navView addSubview:self.rightButton];
    [_rightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setTitle:string forState:UIControlStateNormal];
}

- (void)initNavTitle:(NSString *)string {
    [_navView addSubview:self.navLabel];
    self.navLabel.textColor = [UIColor whiteColor];
    _navLabel.text = string;
}

- (void)popViewController{
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleEventLeftAction:(UIButton *)sender {
    if ([self.navigationController popViewControllerAnimated:YES]) {
        return;
    }
    static int flag = 0;
    if (flag == 0) {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"switch1"] isEqualToString:@"0"] || [[NSUserDefaults standardUserDefaults] valueForKey:@"switch1"]) {
            [[NSUserDefaults standardUserDefaults]  setValue:@"1" forKey:@"switch1"];
        }
        flag = 1;
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"switch1"] isEqualToString:@"1"]) {
        [[ControllerManager shareControllerManager].drawerViewController openLeftViewController];
    }else {
        [[ControllerManager shareControllerManager].drawerViewController closeLeftViewController];
    }

}

- (void)alertView:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle   sureButtonTitle:(NSString *)sureTitle{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:sureTitle, nil];
    [alertView show];
}


- (void)alertControllerShow:(NSString *)message{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self sureAction];
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)sureAction{
    
}
#pragma mark --lazy Loading

- (BaseGradientView *)navView {
    if (!_navView) {
        _navView = ({
            BaseGradientView *barView = [[BaseGradientView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 375, 64), NO)];
//            barView.backgroundColor = THEMECOLOR;
            barView;
        });
    }
    return _navView;
}

- (UILabel *)navLabel {
    if (!_navLabel) {
        _navLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 150, 40), NO)];
            label.center =  flexibleCenter(CGPointMake(WIDTH / 2, 43), NO);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont italicSystemFontOfSize:20];
            label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
            label;
        });
    }
    return _navLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(12, 30, 25, 25), NO);
            [button addTarget:self action:@selector(handleEventLeftAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(293, 24, 70, 37), NO);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            button.imageEdgeInsets =  UIEdgeInsetsMake(0, 41, 0, 0);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
            button;
        });
    }
    return _rightButton;
}

@end
