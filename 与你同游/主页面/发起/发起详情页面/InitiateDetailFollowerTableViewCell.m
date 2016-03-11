//
//  InitiateDetailFollowerTableViewCell.m
//  与你同游
//
//  Created by rimi on 15/10/21.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "InitiateDetailFollowerTableViewCell.h"

@implementation InitiateDetailFollowerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellInterface];
    }
    return self;
}

- (void)initCellInterface {
    [self.contentView addSubview:self.userHeaderImageView];
    [self.contentView addSubview:self.userIDLabel];
    [self.contentView addSubview:self.allowSwitch];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)userHeaderImageView {
    if (!_userHeaderImageView) {
        _userHeaderImageView =  ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 40, 40), NO)];
            imageView.center = flexibleCenter(CGPointMake(40, 25), NO);
            imageView.layer.cornerRadius = 15;
            imageView.clipsToBounds = YES;
            imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            imageView;
        });
    }
    return _userHeaderImageView;
}

- (UILabel *)userIDLabel {
    if (!_userIDLabel) {
        _userIDLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 120, 30), NO)];
            label.font = [UIFont systemFontOfSize:14];
            label.center = CGPointMake(_userHeaderImageView.frame.origin.x + _userHeaderImageView.frame.size.width * 2 + flexibleHeight(40), _userHeaderImageView.center.y);
            label.textColor = [UIColor colorWithWhite:0.500 alpha:1.000];
            [self.contentView addSubview:label];
            label;
        });
    }
    return _userIDLabel;
}

- (UISwitch *)allowSwitch {
    if (!_allowSwitch) {
        _allowSwitch = ({
            UISwitch *allowSwitch = [[UISwitch alloc]initWithFrame:flexibleFrame(CGRectMake(300, 0, 50, 30), NO)];
            CGPoint point = allowSwitch.center;
            point.y = _userHeaderImageView.center.y;
            allowSwitch.center = point;
            allowSwitch.onTintColor = THEMECOLOR;
            allowSwitch;
        });
    }
    return _allowSwitch;
}
@end
