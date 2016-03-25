//
//  CommentViewController.m
//  与你同游
//
//  Created by rimi on 15/10/24.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "CommentViewController.h"
#import "Comments.h"
@interface CommentViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *content;
@property (nonatomic,strong) UILabel * hintlable;

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
    [self.content addSubview:self.hintlable];
    [self.view addSubview:self.content];
}

- (void)handleCommen {
    if (![self.content.text isEqualToString:@""]) {
        NSLog(@"%@", UserID);
        [Comments addComentWithContent:self.content.text userID:_userID?_userID:nil type:_type == 0?_type:1 objID:self.objId success:^(NSString *commentID) {
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error1) {
            
        }];
        self.content.text = @"";
    }
    else{
        [self message:@"评论不能为空哟~"];
    }

}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.hintlable.hidden = YES;
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.hintlable.hidden = NO;
    }
}



#pragma mark -- getter
- (UITextView *)content {
    if (!_content) {
        _content = ({
            UITextView *textView = [[UITextView alloc] initWithFrame:flexibleFrame(CGRectMake(10, 64, 355, 594), NO)];
            textView.layer.borderWidth = 0.5;
            textView.layer.cornerRadius = 5;
            textView.font = [UIFont systemFontOfSize:14];
            textView.layer.borderColor = [UIColor colorWithWhite:0.766 alpha:1.000].CGColor;
            textView.delegate = self;
            textView;
        });
    }
    return _content;
}

- (UILabel *)hintlable{
    if (!_hintlable) {
        _hintlable = ({
            UILabel * label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(10, 10, 260, 20), NO)];
            label.textColor = [UIColor colorWithWhite:0.666 alpha:1.000];
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"说说您的看法...";
            label.hidden = NO;
            label;
            
        });
    }
    return _hintlable;
}
@end

