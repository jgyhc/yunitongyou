//
//  DetailViewController.m
//  与你同游
//
//  Created by rimi on 15/10/16.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializedAppreance];
}

- (void)initializedAppreance{
    [self initBackButton];
    [self initNavTitle:@"游记详情"];
}

@end
