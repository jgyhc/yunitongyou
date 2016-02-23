//
//  RecordDetailTableViewCell.m
//  viewController
//
//  Created by rimi on 15/10/16.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "RecordDetailTableViewCell.h"

@interface RecordDetailTableViewCell ()




@end

@implementation RecordDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUserInterface];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)initUserInterface {
    self.userHeaderImageView = ({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 30, 30), NO)];
        imageView.center = flexibleCenter(CGPointMake(20, 25), NO);
        imageView.layer.cornerRadius = 15;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        imageView;
    });
    [self.contentView addSubview:self.userHeaderImageView];
    
//    self.addressLabel = ({
//        UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 100, 20), NO)];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.center = flexibleCenter(CGPointMake(110, 13));
//        label.font = [UIFont boldSystemFontOfSize:15];
//        label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
//        label;
//    });
//    [self.contentView addSubview:self.addressLabel];
    
    self.contensLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(15, 30, 345, 100), NO)];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize:13];
        label.textColor = [UIColor colorWithWhite:0.670 alpha:1.000];
        label;
    });
    [self.contentView addSubview:self.contensLabel];
    
    self.speakerLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(50, 13, 355, 20), NO)];
        label.textAlignment = NSTextAlignmentLeft;
//        label.center = flexibleCenter(CGPointMake(110, 10));
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = [UIColor colorWithWhite:0.524 alpha:1.000];
        label;
    });
    [self.contentView addSubview:self.speakerLabel];
    
    self.receiverLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(50, 10, 355, 30), NO)];
        label.textAlignment = NSTextAlignmentLeft;
        //        label.center = flexibleCenter(CGPointMake(110, 10));
        label.font = [UIFont boldSystemFontOfSize:13];
        label.textColor = [UIColor colorWithWhite:0.524 alpha:1.000];
        label;
    
    });
    [self.contentView addSubview:self.receiverLabel];
    
    self.timeLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(235, 10, 125, 30), NO)];
        label.textAlignment = NSTextAlignmentLeft;
        //        label.center = flexibleCenter(CGPointMake(110, 10));
        label.font = [UIFont boldSystemFontOfSize:13];
        label.textColor = [UIColor colorWithWhite:0.670 alpha:1.000];
        label;
    
    });
    [self.contentView addSubview:self.timeLabel];

}



//-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
//{
//    NSDictionary *attrs = @{NSFontAttributeName : font};
//    
//    return [aString sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];;
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
