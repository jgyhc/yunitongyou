//
//  DidImageCollectionViewCell.m
//  ManJi
//
//  Created by Zgmanhui on 16/1/19.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import "DidImageCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
@implementation DidImageCollectionViewCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    [self.contentView addSubview:self.photoImageView];
    [self.contentView addSubview:self.selectedButton];
}

- (void)hanleEvent:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(handleSelectEvent:Cell:)]) {
        [self.delegate handleSelectEvent:sender Cell:self];
    }
}




- (UIButton *)selectedButton
{
    if (!_selectedButton) {
        UIButton *button = [[UIButton alloc]init];
        button.frame = flexibleFrame(CGRectMake(75, 0, 22, 22), YES);
        [button setBackgroundImage:[UIImage imageNamed:@"选照片"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"照片选中"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(hanleEvent:) forControlEvents:UIControlEventTouchUpInside];
        _selectedButton = button;
    }
    return _selectedButton;
}


- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = self.bounds;
        image.contentMode = UIViewContentModeScaleToFill;
        _photoImageView = image;
    }
    return _photoImageView;
}



@end
