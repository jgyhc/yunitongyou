//
//  LaunchCollectionViewCell.m
//  viewController
//
//  Created by rimi on 15/10/14.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "LaunchCollectionViewCell.h"

@implementation LaunchCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCellInterface];
    }
    return self;
}

- (void)initCellInterface {
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    
    
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        imageView;
    });
    [self addSubview:self.imageView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height / 4 * 3, self.frame.size.width, self.frame.size.height / 4)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.7;
    [self.imageView addSubview:view];

    
    self.addressLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 150, 20), NO)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.center = CGPointMake(self.frame.size.width / 2 , view.frame.size.height / 2);
        label.font = [UIFont boldSystemFontOfSize:18];
        label;
    });
    [view addSubview:self.addressLabel];

}


@end
