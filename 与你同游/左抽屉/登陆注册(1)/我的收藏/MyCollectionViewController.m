//
//  MyCollectionViewController.m
//  与你同游
//
//  Created by rimi on 15/10/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "MyCollectionViewController.h"

@implementation MyCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterface];
}
- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"我的收藏"];
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
