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
    
    
    //提交意见
}





- (UILabel *)textlable{
    if (!_textlable) {
        _textlable = ({
            
            UILabel * lable = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(10, 60, 355, 160), NO)];
            lable.text = @"感谢您使用该软件，你的意见将帮助我们不断改进，感谢您使用该软件，你的意见将帮助我们不断改进，感谢您使用该软件，你的意见将帮助我们不断改进，感谢您使用该软件，你的意见将帮助我们不断改进。\n若有疑问，还可拨打服务电话：120118119110";
            lable.numberOfLines = 0;
            lable.textColor = [UIColor grayColor];
            lable;
            
        });
    }
    return _textlable;
}

- (UIButton *)presentButton{
    if (!_presentButton) {
        _presentButton = ({
            
            UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(20, 500, 335, 40), NO)];
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
