//
//  MyCommentsViewController.m
//  与你同游
//
//  Created by rimi on 15/10/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "MyCommentsViewController.h"

@implementation MyCommentsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterface];
}
- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"我的评论"];
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
