//
//  PositonViewController.m
//  与你同游
//
//  Created by rimi on 15/10/17.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "PositonViewController.h"

@interface PositonViewController ()

@end

@implementation PositonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializedApperance];
}

- (void)initializedApperance{
    [self initNavTitle:@"选择地点吧"];
    [self initBackButton];
}



@end
