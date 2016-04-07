//
//  JoinInCell.m
//  与你同游
//
//  Created by Zgmanhui on 16/3/17.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "JoinInCell.h"
#import <UIImageView+WebCache.h>
@interface JoinInCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIButton *switchButton;
@end

@implementation JoinInCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.text = @"name";
        [self.contentView addSubview:self.iconImage];

        
        self.iconImage.sd_layout.leftSpaceToView(self.contentView, flexibleWidth(15)).centerYEqualToView(self.contentView).widthIs(flexibleHeight(35)).heightEqualToWidth(1);
        self.iconImage.sd_cornerRadiusFromWidthRatio = @0.5;
        
        self.nameLabel.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.iconImage, flexibleWidth(5)).heightIs(flexibleHeight(12));
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:200];
        

        [self setupAutoHeightWithBottomView:self.iconImage bottomMargin:flexibleHeight(7.5)];
    }
    return self;
}

- (void)isText  {
    [self.contentView addSubview:self.switchButton];
    self.switchButton.sd_layout.rightSpaceToView(self.contentView, flexibleWidth(15)).topSpaceToView(self.contentView, flexibleHeight(5)).widthIs(flexibleWidth(60)).heightIs(flexibleHeight(40));
}

- (void)handleJoinMember:(UIButton *)sender {
    if (self.replayBlock) {
        self.replayBlock(_indexPath);
    }
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        sender.backgroundColor = [UIColor colorWithRed:0.951 green:1.000 blue:0.971 alpha:1.000];
    }else {
         sender.backgroundColor = [UIColor colorWithRed:0.283 green:0.751 blue:0.371 alpha:1.000];
    }
}



- (void)setModel:(BmobObject *)model {
    _model = model;
    if (![[model objectForKey:@"username"] isEqualToString:@"还没取昵称哟！"]) {
        self.nameLabel.text = [model objectForKey:@"username"];
    }else {
        self.nameLabel.text = [model objectForKey:@"phoneNumber"];
    }
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[model objectForKey:@"head_portraits"]] placeholderImage:[UIImage imageNamed:@"无头像.png"]];
    [self.nameLabel sizeToFit];
    
}
- (void)deleteMemeber {
    self.switchButton.selected = NO;
    self.switchButton.backgroundColor = [UIColor colorWithRed:0.283 green:0.751 blue:0.371 alpha:1.000];
    _isMemeber = NO;
}

- (void)member {
    self.switchButton.selected = YES;
    self.switchButton.backgroundColor = [UIColor colorWithRed:0.951 green:1.000 blue:0.971 alpha:1.000];
    _isMemeber = YES;
}

- (UILabel *)nameLabel {
	if(_nameLabel == nil) {
		_nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:flexibleHeight(14)];
        _nameLabel.textColor = [UIColor colorWithRed:0.412 green:0.410 blue:0.414 alpha:1.000];
	}
	return _nameLabel;
}

- (UIImageView *)iconImage {
	if(_iconImage == nil) {
		_iconImage = [[UIImageView alloc] init];
        _iconImage.backgroundColor = [UIColor redColor];
	}
	return _iconImage;
}


- (UIButton *)switchButton {
	if(_switchButton == nil) {
		_switchButton = [[UIButton alloc] init];
        _switchButton.layer.cornerRadius = flexibleHeight(5);
        [_switchButton setTitle:@"同意" forState:UIControlStateNormal];
        _switchButton.backgroundColor = [UIColor colorWithRed:0.283 green:0.751 blue:0.371 alpha:1.000];
        [_switchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _switchButton.titleLabel.font = [UIFont systemFontOfSize:flexibleHeight(14)];
        [_switchButton setTitle:@"已加入" forState:UIControlStateSelected];
        [_switchButton setTitleColor:[UIColor colorWithWhite:0.291 alpha:1.000] forState:UIControlStateSelected];
        _switchButton.layer.borderWidth = flexibleHeight(0.5);
        _switchButton.layer.borderColor = [UIColor colorWithRed:0.283 green:0.751 blue:0.371 alpha:1.000].CGColor;
        _switchButton.titleLabel.font = [UIFont systemFontOfSize:flexibleHeight(14)];
        [_switchButton addTarget:self action:@selector(handleJoinMember:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _switchButton;
}

@end
