//
//  ChooseImageListCollectionViewCell.m
//  与你同游
//
//  Created by rimi on 15/11/6.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "ChooseImageListCollectionViewCell.h"

@implementation ChooseImageListCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:clickButtonDidPressed:)]) {
        [self.delegate cell:self clickButtonDidPressed:sender];
    }
}


#pragma mark -- getter
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = ({
            UIImageView *image = [[UIImageView alloc] init];
            image.frame = self.bounds;
            image.contentMode = UIViewContentModeScaleToFill;
            image;
        });
    }
    return _photoImageView;
}

- (UIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(84, 0, 26, 26), NO);
            [button setBackgroundImage:IMAGE_PATH(@"选照片.png") forState:UIControlStateNormal];
            [button setBackgroundImage:IMAGE_PATH(@"照片选中.png") forState:UIControlStateSelected];
            [button addTarget:self action:@selector(hanleEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        
        });
    }
    return _selectedButton;
}






@end
