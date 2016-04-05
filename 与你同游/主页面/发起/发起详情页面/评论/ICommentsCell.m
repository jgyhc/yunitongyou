//
//  ICommentsCell.m
//  与你同游
//
//  Created by Zgmanhui on 16/3/17.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "ICommentsCell.h"

@interface ICommentsCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *repalyLabel;
@property (nonatomic, strong) UILabel *repaly;
@property (nonatomic, strong) UILabel *contenLabel;
@property (nonatomic, strong) UIButton *repalyButton;
@end

@implementation ICommentsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)isText {

}

- (void)setModel:(BmobObject *)model {
    _model = model;
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contenLabel];
    self.nameLabel.sd_layout.leftSpaceToView(self.contentView, flexibleWidth(15)).heightIs(flexibleHeight(20)).topSpaceToView(self.contentView, flexibleHeight(10));
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    [self.contentView addSubview:self.repalyButton];
    self.repalyButton.sd_layout.rightSpaceToView(self.contentView, flexibleWidth(15)).centerYEqualToView(self.nameLabel).heightIs(flexibleHeight(30)).widthIs(flexibleWidth(50));
    
    if ([model objectForKey:@"Ruser"]) {
        BmobObject *Ruser = [model objectForKey:@"Ruser"];
        [self.contentView addSubview:self.repaly];
        self.repaly.sd_layout.leftSpaceToView(self.nameLabel, flexibleWidth(5)).heightIs(flexibleHeight(20)).topEqualToView(self.nameLabel);
        [self.repaly setSingleLineAutoResizeWithMaxWidth:100];

        
        [self.contentView addSubview:self.repalyLabel];
        self.repalyLabel.sd_layout.leftSpaceToView(self.repaly, flexibleWidth(5)).heightIs(flexibleHeight(20)).topEqualToView(self.nameLabel).rightSpaceToView(self.repalyButton, flexibleWidth(5));

        if (![[Ruser objectForKey:@"username"] isEqualToString:@"还没取昵称哟！"]) {
            self.repalyLabel.text = [Ruser objectForKey:@"username"];
        }else {
            self.repalyLabel.text = [Ruser objectForKey:@"phoneNumber"];
        }
    }
    self.contenLabel.sd_layout.leftSpaceToView(self.contentView, flexibleWidth(15)).topSpaceToView(self.nameLabel, flexibleHeight(10)).autoHeightRatio(0).rightSpaceToView(self.contentView, flexibleWidth(15));
    BmobObject *user = [model objectForKey:@"user"];
    if (![[user objectForKey:@"username"] isEqualToString:@"还没取昵称哟！"]) {
        self.nameLabel.text = [user objectForKey:@"username"];
    }else {
        self.nameLabel.text = [user objectForKey:@"phoneNumber"];
    }
    self.contenLabel.text = [model objectForKey:@"content"];
    [self.contenLabel sizeToFit];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    line.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(flexibleHeight(1)).topSpaceToView(self.contenLabel, flexibleHeight(10));
    
    [self setupAutoHeightWithBottomView:self.contenLabel bottomMargin:flexibleHeight(10)];
    
}

- (void)handRepalyEvent {
    if (_replayBlock) {
        if (!OBJECTID) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录喔！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }

        self.replayBlock(_indexPath);
    }
}

- (UILabel *)contenLabel {
	if(_contenLabel == nil) {
		_contenLabel = [[UILabel alloc] init];
        _contenLabel.font = [UIFont systemFontOfSize:flexibleHeight(14)];
        _contenLabel.textColor = [UIColor colorWithWhite:0.180 alpha:1.000];
	}
	return _contenLabel;
}

- (UILabel *)repaly {
	if(_repaly == nil) {
		_repaly = [[UILabel alloc] init];
        _repaly.text = @"回复:";
        _repaly.textColor = [UIColor colorWithWhite:0.180 alpha:1.000];
        _repaly.font = [UIFont systemFontOfSize:flexibleHeight(14)];
	}
	return _repaly;
}

- (UILabel *)repalyLabel {
	if(_repalyLabel == nil) {
		_repalyLabel = [[UILabel alloc] init];
        _repalyLabel.textColor = [UIColor colorWithRed:0.000 green:0.470 blue:1.000 alpha:1.000];
        _repalyLabel.font = [UIFont systemFontOfSize:flexibleHeight(14)];
	}
	return _repalyLabel;
}

- (UILabel *)nameLabel {
	if(_nameLabel == nil) {
		_nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithRed:0.000 green:0.470 blue:1.000 alpha:1.000];
        _nameLabel.font = [UIFont systemFontOfSize:flexibleHeight(14)];
	}
	return _nameLabel;
}

- (UIButton *)repalyButton {
	if(_repalyButton == nil) {
		_repalyButton = [[UIButton alloc] init];
        [_repalyButton setTitle:@"回复" forState:UIControlStateNormal];
        _repalyButton.titleLabel.font = [UIFont systemFontOfSize:flexibleHeight(14)];
        [_repalyButton addTarget:self action:@selector(handRepalyEvent) forControlEvents:UIControlEventTouchUpInside];
        [_repalyButton setTitleColor:[UIColor colorWithRed:0.000 green:0.470 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
	}
	return _repalyButton;
}

@end
