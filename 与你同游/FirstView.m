//
//  FirstView.m
//  与你同游
//
//  Created by rimi on 15/10/27.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "FirstView.h"

@interface FirstView ()
@property (nonatomic,strong) UIImageView * logoView;
@property (nonatomic,strong) UILabel * firstLabel;
@property (nonatomic,strong) UILabel * secondLabel;

@end

@implementation FirstView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initFirstInterface];
    }
    return self;
}

- (void)initFirstInterface{
    
    self.backgroundColor = [UIColor colorWithRed:0.443 green:0.785 blue:0.601 alpha:1.000];
    
    self.logoView = ({
        UIImageView * imageView = [[UIImageView alloc]initWithImage:IMAGE_PATH(@"logo.png")];
        imageView.center = flexibleCenter(CGPointMake(187.5,200), NO);
        imageView.bounds = flexibleFrame(CGRectMake(0, 0,140,140),NO);
        imageView;
    });
    [self addSubview:self.logoView];
    
    self.firstLabel = ({
        UILabel * label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(87.5,260,200, 40), NO)];
        label.text = @"yo,travel!your first choice";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Snell Roundhand" size:28];
        label;
    });
    [self addSubview:self.firstLabel];
    
    
//    self.secondLabel = ({
//        
//    });
//    [self addSubview:self.secondLabel];
    
    
    
}


@end
