//
//  CommentViewController.m
//  与你同游
//
//  Created by rimi on 15/10/24.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "CommentViewController.h"
#import "TravelModel.h"
@interface CommentViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *content;
@property (nonatomic,strong) UILabel * hintlable;
@property (nonatomic, strong) TravelModel *TCNetWorking;
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
- (void)dealloc {
    [self.TCNetWorking removeObserver:self forKeyPath:@"createTCommentResult"];
    
    
}
#pragma mark --  KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"createTCommentResult"]) {
        
        
    }
}
- (void)initUserInterface {
    
    
    [self.content addSubview:self.hintlable];
    [self.view addSubview:self.content];
    
    [self.TCNetWorking addObserver:self forKeyPath:@"createTCommentResult" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)handleCommen {
    [self.TCNetWorking createATravelReviewsWithPhoneNumber:PHONE_NUMBER Password:PASSWORD travel_date:self.travelDate creatorPhoneNumber:self.phoneNumber contents:self.content.text];
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

- (TravelModel *)TCNetWorking {
    if (!_TCNetWorking) {
        _TCNetWorking = [[TravelModel alloc] init];
    }
    return _TCNetWorking;
}

@end

