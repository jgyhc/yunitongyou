//
//  SuggestionViewController.m
//  与你同游
//
//  Created by rimi on 15/10/24.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "SuggestionViewController.h"
#import "SharedView.h"

@interface SuggestionViewController ()

@property (nonatomic,strong) SharedView * sharedView;
@property (nonatomic,strong) UILabel * textlable;
@property (nonatomic,strong) UIButton * callbt;
@property (nonatomic,strong) UIButton * presentButton;

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUserInterface];
}

- (void)initUserInterface{
    [self initBackButton];
    [self initNavTitle:@"意见反馈"];
    
    [self.view addSubview:self.textlable];
    [self.view addSubview:self.callbt];
    [self.view addSubview:self.presentButton];
    
    
    
    self.sharedView.textView.frame = flexibleFrame(CGRectMake(10, 230, 355, 180), NO);
    self.sharedView.textView.layer.borderWidth = 0.5;
    self.sharedView.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.sharedView.textView.textColor = [UIColor colorWithWhite:0.147 alpha:1.000];
    self.sharedView.textView.layer.cornerRadius = 10;
    UILabel * label = (UILabel *)self.sharedView.textView.subviews[1];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"在此处填写您的意见或您遇到的问题...";
    
    [self.view addSubview:self.sharedView.textView];
    
    
}

- (void)handlePresent{
    if (self.sharedView.textView.text.length == 0) {
        return;
    }
    BmobObject *bmobObject = [BmobObject objectWithClassName:@"Suggestions"];
    [bmobObject setObject:PHONE_NUMBER forKey:@"phoneNumber"];
    [bmobObject setObject:self.sharedView.textView.text forKey:@"suggestion"];
    [bmobObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您填写的信息已提交！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"提交失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }];

    
    //提交意见
}

- (void)handleCall{
    NSString *strPhoneUrl = [NSString stringWithFormat:@"tel:%@",self.callbt.titleLabel.text];
    NSURL *phoneUrl = [NSURL URLWithString:strPhoneUrl];
    [[UIApplication sharedApplication] openURL:phoneUrl];
}



- (UILabel *)textlable{
    if (!_textlable) {
        _textlable = ({
            
            UILabel * lable = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(10, 60, 355, 160), NO)];
            lable.text = @"感谢您使用该软件，你的意见将帮助我们不断改进，感谢您使用该软件，你的意见将帮助我们不断改进，感谢您使用该软件，你的意见将帮助我们不断改进，感谢您使用该软件，你的意见将帮助我们不断改进。\n若有疑问，还可拨打服务电话:";
            lable.numberOfLines = 0;
            lable.textColor = [UIColor grayColor];
            lable;
            
        });
    }
    return _textlable;
}

- (UIButton *)callbt{
    if (!_callbt) {
        _callbt = ({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(240, 182, 120, 20), NO);
            [button setTitle:@"18983311304" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:0.2275 green:0.9294 blue:0.702 alpha:1.0] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(handleCall) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = [UIColor colorWithRed:0.3608 green:0.4431 blue:1.0 alpha:1.0];
            button;
        });
    }
    return _callbt;
}

- (UIButton *)presentButton{
    if (!_presentButton) {
        _presentButton = ({
            
             UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(0, 0, 300,50), NO);
            button.center =  flexibleCenter(CGPointMake(WIDTH / 2, 600), NO);
            button.backgroundColor = THEMECOLOR;
            [button setTitle:@"提交" forState:UIControlStateNormal];
            button.layer.cornerRadius = 6;
            [button addTarget:self action:@selector(handlePresent) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _presentButton;
}

- (SharedView *)sharedView{
    if (!_sharedView) {
        _sharedView = [SharedView new];
    }
    return _sharedView;
}

@end
