//
//  CommentViewController.m
//  与你同游
//
//  Created by rimi on 15/10/24.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "CommentViewController.h"
#import "Comments.h"
#import "SSTextView.h"
@interface CommentViewController ()
@property (nonatomic, strong) SSTextView *content;

@end

@implementation CommentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBackButton];
    [self initNavTitle:@"评论"];
    [self initRightButtonEvent:@selector(handleCommen) title:@"完成"];
    [self initUserInterface];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1.000];
}

- (void)initUserInterface {
    [self.view addSubview:self.content];
}

- (void)setUsername:(NSString *)username {
    _username = username;
    self.content.placeholder = [NSString stringWithFormat:@"回复%@:", username];
}

- (void)handleCommen {
    if (![self.content.text isEqualToString:@""]) {
        [Comments addComentWithContent:self.content.text userID:_userID?_userID:nil type:_type objID:self.objId success:^(NSString *commentID) {
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error1) {
            
        }];
        self.content.text = @"";
    }
    else{
        [self message:@"评论不能为空哟~"];
    }

}




#pragma mark -- getter


- (SSTextView *)content {
	if(_content == nil) {
        _content = [[SSTextView alloc] initWithFrame:flexibleFrame(CGRectMake(10, 64, 355, 594), NO)];
        _content.layer.borderWidth = 0.5;
        _content.layer.cornerRadius = 5;
        _content.font = [UIFont systemFontOfSize:14];
        _content.layer.borderColor = [UIColor colorWithWhite:0.766 alpha:1.000].CGColor;
        _content.placeholder = @"说说您的看法。。。";
	}
	return _content;
}

@end

