//
//  RecordDetailViewController.m
//  viewController
//
//  Created by rimi on 15/10/16.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "MJRefresh.h"
#import "CommentView.h"
#import "ShareView.h"
#import "DetailTopView.h"
#import "ICommentsView.h"
#import <BmobSDK/Bmob.h>
#import "ThumbUp.h"
#import "Collection.h"
#import "Comments.h"
#define SIZEHEIGHT frame.size.height
#define SIZEHEIGHT frame.size.height

@interface RecordDetailViewController ()<UIScrollViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

#pragma mark --上
@property (nonatomic, strong) DetailTopView * topView;

#pragma mark --中
@property (nonatomic, strong) UIView      * bottomLine;
@property (nonatomic, strong) UIButton    * rightsideButton;
@property (nonatomic, strong) UIButton    * leftsideButton;
@property (nonatomic, strong) ICommentsView * commentView;

#pragma mark --下
@property (nonatomic, strong) UIView      * bottomView;
@property (nonatomic, strong) UIButton    * dianzanbt;
@property (nonatomic, strong) UIButton    * commentbt;
@property (nonatomic, strong) UIButton    * sharebt;
@property (nonatomic, strong) UIButton    * collectionbt;

@property (nonatomic, strong) CommentView * comment;
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) NSTimeInterval duration;



@end

@implementation RecordDetailViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackButton];
    [self initNavTitle:@"游记详情"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUserInterface];
    
    
}

- (void)initUserInterface {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view insertSubview:self.scrollView atIndex:0];
    self.scrollView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).bottomEqualToView(self.view);

    [self.scrollView addSubview:self.topView];
    [self.scrollView addSubview:self.leftsideButton];
    [self.scrollView addSubview:self.rightsideButton];
    [self.scrollView addSubview:self.bottomLine];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.comment.inputView];

    
    self.topView.sd_layout.topEqualToView(self.scrollView).leftEqualToView(self.scrollView).rightEqualToView(self.scrollView).heightIs(flexibleHeight(HEIGHT / 3));
    
    self.leftsideButton.sd_layout.leftEqualToView(self.scrollView).widthIs(flexibleWidth(WIDTH / 2)).heightIs(flexibleHeight(40)).topSpaceToView(self.topView, 0);
    
    self.rightsideButton.sd_layout.rightEqualToView(self.scrollView).widthIs(flexibleWidth(WIDTH / 2)).heightIs(flexibleHeight(40)).topEqualToView(self.leftsideButton);
    
    self.bottomLine.sd_layout.centerXIs(flexibleWidth(WIDTH / 4)).heightIs(flexibleHeight(2)).widthIs(flexibleWidth(WIDTH / 2)).topSpaceToView(self.leftsideButton, 0);

    
    self.bottomView.sd_layout.leftEqualToView(self.view).bottomEqualToView(self.view).widthIs(flexibleWidth(WIDTH)).heightIs(flexibleHeight(40));
    
    self.dianzanbt.sd_layout.leftSpaceToView(self.bottomView,WIDTH /4).topSpaceToView(self.bottomView,5).widthIs(flexibleWidth(30)).heightIs(flexibleHeight(30));
    self.commentbt.sd_layout.leftSpaceToView(self.bottomView,WIDTH / 3 + 20).topSpaceToView(self.bottomView,5).widthIs(flexibleWidth(30)).heightIs(flexibleHeight(30));
    self.sharebt.sd_layout.rightSpaceToView(self.bottomView,WIDTH / 3 + 20).topSpaceToView(self.bottomView,5).widthIs(flexibleWidth(30)).heightIs(flexibleHeight(30));
    self.collectionbt.sd_layout.rightSpaceToView(self.bottomView,WIDTH /4).topSpaceToView(self.bottomView,5).widthIs(flexibleWidth(30)).heightIs(flexibleHeight(30));
    
    
    
    

}

- (void)setTravelObject:(BmobObject *)travelObject{
    _travelObject = travelObject;
    BmobObject * user =  [travelObject objectForKey:@"userId"];
    self.objId = travelObject.objectId;
    self.topView.travelObject = travelObject;
    self.topView.userObject = user;
    
    NSArray * thumbArray = (NSArray *)[travelObject objectForKey:@"thumbArray"];
    for (NSString * userId in thumbArray) {
        if ([userId isEqualToString:OBJECTID]) {
            self.dianzanbt.selected = YES;
        }
        else{
            self.dianzanbt.selected = NO;
        }
    }
    
    NSArray * collectionArray = (NSArray *)[travelObject objectForKey:@"collectionArray"];
    for (NSString * userId in collectionArray) {
        if ([userId isEqualToString:OBJECTID]) {
            self.collectionbt.selected = YES;
        }
        else{
            self.collectionbt.selected = NO;
        }
    }

}



- (void)buttonClickEvent:(UIButton *)sender {
    if (sender == self.leftsideButton) {
//        [self.commentsView removeFromSuperview];
//        [self.scrollView addSubview:self.joinInView];
//        [UIView animateWithDuration:0.3 animations:^{
//            self.separatationLineView.sd_layout.centerXIs(flexibleWidth(WIDTH / 4));
//            [self.separatationLineView updateLayout];
//            [self.scrollView updateLayout];
//        }];
    }
    
    if (sender == self.rightsideButton) {
//        [self.scrollView addSubview:self.commentsView];
//        self.commentsView.sd_layout.leftEqualToView(self.scrollView).rightEqualToView(self.scrollView).topSpaceToView(self.separatationLineView, 0).heightIs(flexibleHeight(10 * flexibleHeight(50)));
//        [self.joinInView removeFromSuperview];
//        [UIView animateWithDuration:0.3 animations:^{
//            self.separatationLineView.sd_layout.centerXIs(flexibleWidth(WIDTH / 4 * 3));
//            [self.scrollView updateLayout];
//            [self.separatationLineView updateLayout];
//        }];
    }
}

- (void)handlePress:(UIButton *)sender{
    if (!OBJECTID) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录喔！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if (sender == self.collectionbt) {
        if (!sender.selected) {
            [Collection CollectionWithID:self.objId type:1 success:^(NSString *commentID) {
                
            } failure:^(NSError *error1) {
                
            }];
        }
        else{
            [Collection cancelCollectionWithID:self.objId type:1 success:^(NSString *commentID) {
                
            } failure:^(NSError *error1) {
                
            }];
        }

    }
    else if (sender == self.dianzanbt){
        if (!sender.selected) {
            [ThumbUp thumUpWithID:self.objId type:1 success:^(NSString *commentID) {
            } failure:^(NSError *error1) {
                
            }];
        }
        else{
            //取消点赞
            [ThumbUp cancelThumUpWithID:self.objId type:1 success:^(NSString *commentID) {
            } failure:^(NSError *error1) {
                
            }];
        }

    }
    else if (sender == self.commentbt){
         [self.comment.inputText becomeFirstResponder];
    }
    else{
        NSArray * imageArray;
        if ([self.travelObject objectForKey:@"urlArray"]) {
            imageArray = [self.travelObject objectForKey:@"urlArray"];
        }
        else{
            imageArray = nil;
        }
        [ShareView sharedWithImages:imageArray content:[self.travelObject objectForKey:@"content"]];
        
    }
    
    sender.selected = !sender.selected;
}
//发表评论
- (void)handleSend{
    
    if (![self.comment.inputText.text isEqualToString:@""]) {
         [Comments addComentWithContent:self.comment.inputText.text userID:nil type:1 objID:self.objId success:^(NSString *commentID) {
             
         } failure:^(NSError *error1) {
             
         }];
        self.comment.inputText.text = @"";
    }
    else{
        [self alertView:@"评论不能为空哟~" cancelButtonTitle:nil sureButtonTitle:@"确定"];
        
        
    }
    
    self.comment.inputView.frame = flexibleFrame(CGRectMake(0,667,375,40), NO);
}
- (void)keyboardWillShow:(NSNotification *)noti{
    CGRect keyboardRect =[noti.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    self.duration = [noti.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        self.comment.inputView.frame = flexibleFrame(CGRectMake(0,667 - (CGRectGetHeight(self.comment.inputText.bounds)+ 10 + self.keyboardHeight),375, CGRectGetHeight(self.comment.inputText.bounds) + 10), NO);
        
    } completion:nil];
    NSLog(@"%f",self.keyboardHeight);
}

#pragma mark --uiScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = 1 - scrollView.contentOffset.y / 250;
    self.navView.alpha = alpha;
    self.leftButton.alpha = alpha;
}




- (void)textViewDidChange:(UITextView *)textView{
    if (![textView.text isEqualToString:@""]) {
        
        CGSize size = [textView sizeThatFits:CGSizeMake(280,CGFLOAT_MAX)];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.comment.inputText.frame = flexibleFrame(CGRectMake(20,5,280, size.height), NO);
            
            self.comment.inputView.frame = flexibleFrame(CGRectMake(0,667 - (size.height + 10 + self.keyboardHeight),375, size.height + 10), NO);
        } completion:nil];
        
        
        
        
    }
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(280,CGFLOAT_MAX)];
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.comment.inputText.frame = flexibleFrame(CGRectMake(20,5,280, size.height), NO);
        
        self.comment.inputView.frame = flexibleFrame(CGRectMake(0,667,375, size.height + 10), NO);
    } completion:nil];
    
}


#pragma mark -- getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]init];
            scrollView.delegate = self;
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView;
        });
    }
    return _scrollView;
}

- (DetailTopView *)topView{
    if (!_topView) {
        _topView = [DetailTopView new];
    }
    return _topView;
}
- (UIButton *)leftsideButton {
    if (!_leftsideButton) {
        _leftsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitle:@"评论" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _leftsideButton;
}

- (UIButton *)rightsideButton {
    if (!_rightsideButton) {
        _rightsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitle:@"点赞" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _rightsideButton;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = THEMECOLOR;
    }
    return _bottomLine;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];//如果是clearColor,阴影则设置无效
        _bottomView.layer.shadowOffset = CGSizeMake(0, -1);
        _bottomView.layer.shadowColor= [UIColor blackColor].CGColor;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowRadius = 2;
    }
    return _bottomView;
}
- (UIButton *)dianzanbt{
    if (!_dianzanbt) {
        _dianzanbt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dianzanbt addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
        [_dianzanbt setBackgroundImage:IMAGE_PATH(@"未点赞.png") forState:UIControlStateNormal];
        [_dianzanbt setBackgroundImage:IMAGE_PATH(@"点赞.png") forState:UIControlStateSelected];
        [self.bottomView addSubview:_dianzanbt];
    }
    return _dianzanbt;
}
- (UIButton *)commentbt{
    if (!_commentbt) {
        _commentbt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentbt addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
        [_commentbt setBackgroundImage:IMAGE_PATH(@"评论.png") forState:UIControlStateNormal];
        [self.bottomView addSubview:_commentbt];
    }
    return _commentbt;
}

- (UIButton *)sharebt{
    if (!_sharebt) {
        _sharebt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sharebt addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
        [_sharebt setBackgroundImage:IMAGE_PATH(@"未分享.png") forState:UIControlStateNormal];
        [self.bottomView addSubview:_sharebt];
    }
    return _sharebt;
}
- (UIButton *)collectionbt{
    if (!_collectionbt) {
        _collectionbt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionbt addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
        [_collectionbt setBackgroundImage:IMAGE_PATH(@"未收藏.png") forState:UIControlStateNormal];
        [_collectionbt setBackgroundImage:IMAGE_PATH(@"已收藏.png") forState:UIControlStateSelected];
        [self.bottomView addSubview:_collectionbt];
    }
    return _collectionbt;
}

- (CommentView *)comment{
    if (!_comment) {
        _comment = [[CommentView alloc]init];
        self.comment.inputText.delegate = self;
        [self.comment.conmmentButton addTarget:self action:@selector(handleSend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comment;
}

@end

