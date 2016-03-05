//
//  TravelTableViewCell.m
//  与你同游
//
//  Created by rimi on 15/10/22.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "TravelTableViewCell.h"

@interface TravelTableViewCell ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UIImageView * positionImage;




@end


@implementation TravelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializedApperance];
    }
    return self;
}

- (void)initializedApperance{
    self.imageArray = [NSMutableArray arrayWithObjects:@"11.ipg",@"12.jpg",@"13.jpg",@"14.jpg",@"15.jpg" ,nil];
    
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
    self.layer.borderWidth = 0.5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

   
    [self.contentView addSubview:self.userPortrait];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.positionImage];
    [self.contentView addSubview:self.placeLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLabel];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    
    self.collectionView.collectionImageArray = [self.imageArray mutableCopy];
    
    if (self.imageArray.count < 2) {
        //配置最小行距
        layout.minimumLineSpacing =10;
        //最小间距
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = flexibleSize(CGSizeMake(110,110), NO);
        
        self.collectionView = [[TravelCollectionView alloc]initWithFrame:flexibleFrame(CGRectMake(20, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height, 250, 110), NO) collectionViewLayout:layout];
        [self.contentView addSubview:self.collectionView];
    }
    else{
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = flexibleSize(CGSizeMake(80,80), NO);
        if (self.imageArray.count % 3 == 0) {
            self.collectionView = [[TravelCollectionView alloc]initWithFrame:flexibleFrame(CGRectMake(20, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height,250,85 * (self.imageArray.count / 3)), NO) collectionViewLayout:layout];
            [self.contentView addSubview:self.collectionView];

        }
        else{
            self.collectionView = [[TravelCollectionView alloc]initWithFrame:flexibleFrame(CGRectMake(20, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height, 250, 85 * (self.imageArray.count % 3 + 1)), NO) collectionViewLayout:layout];
            [self.contentView addSubview:self.collectionView];
        }
        
        
        
    }
    [self.contentView addSubview:self.buttomView];

    [self.buttomView addSubview:self.thumbUpButton];
    [self.buttomView addSubview:self.commentsButton];
    [self.buttomView addSubview:self.shareButton];
    
    
    

}




#pragma mark --lazy loading

- (UIButton *)userPortrait{
    if (!_userPortrait) {
        _userPortrait = ({
            
            UIButton * userPortrait = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(20,20, 60, 60), NO)];

            userPortrait.layer.cornerRadius = 0.5 * CGRectGetWidth(userPortrait.bounds);
            userPortrait.clipsToBounds = YES;
            userPortrait;
        });
    }
    return _userPortrait;
}



- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = ({
            
            UILabel * label = [[UILabel alloc] initWithFrame:flexibleFrame(CGRectMake(90, 40, 100, 20), NO) ];//这个frame是初设的，没关系，后面还会重新设置其size。
            label.textColor = [UIColor blackColor];
            
            label.font = [UIFont systemFontOfSize:17];
//                CGSize labelsize = [label.text  sizeWithAttributes:[NSDictionary dictionaryWithObject:label.font forKey:NSFontAttributeName]];
//                [label setFrame:flexibleFrame(CGRectMake(90,30, labelsize.width, 20), NO) ];
            label;
        });
    }
    return _nameLabel;
}

- (UIImageView *)positionImage{
    if (!_positionImage) {
        _positionImage = ({
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(180,40,18,18), NO)];
            imageView.image = IMAGE_PATH(@"定位选中.png");
            imageView;
        });
    }
    return _positionImage;
}
- (UILabel *)placeLabel{
    if (!_placeLabel) {
        _placeLabel = ({
            
            UILabel * placeLabel = [[UILabel alloc] initWithFrame:flexibleFrame(CGRectMake(210,40, 100, 20), NO) ];//这个frame是初设的，没关系，后面还会重新设置其size。
            placeLabel.textColor = [UIColor colorWithWhite:0.497 alpha:1.000];
            placeLabel.font = [UIFont systemFontOfSize:14];
//                CGSize size = [placeLabel.text  sizeWithAttributes:[NSDictionary dictionaryWithObject:placeLabel.font forKey:NSFontAttributeName]];
//            
//                if ((self.positionImage.frame.origin.x + self.positionImage.frame.size.width + 5 + size.width) < 285) {
//            
//                    [placeLabel setFrame:flexibleFrame(CGRectMake(self.positionImage.frame.origin.x + self.positionImage.frame.size.width + 5,30, size.width, 20), NO) ];
//                }
//                else{
//                    placeLabel.frame = flexibleFrame(CGRectMake(self.positionImage.frame.origin.x + self.positionImage.frame.size.width + 5,30,285 - (self.positionImage.frame.origin.x + self.positionImage.frame.size.width + 5), 20), NO);
//                }
            placeLabel;
            
        });
    }
    return _placeLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = ({
            
            UILabel * timeLabel = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(275,40 ,60, 20), NO)];
            timeLabel.textColor = [UIColor lightGrayColor];
            timeLabel.font = [UIFont systemFontOfSize:12];
            timeLabel.textAlignment = NSTextAlignmentRight;
            timeLabel;
        });
    }
    return _timeLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(10, 65, 335, 80), NO)];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor colorWithWhite:0.601 alpha:1.000];
            label.font = [UIFont boldSystemFontOfSize:(SCREEN_HEIGHT / 667.0) * 14];
            label;


        });
    }
    return _contentLabel;
}

- (UIView *)buttomView{
    if (!_buttomView) {
        _buttomView = ({
            UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, self.collectionView.frame.origin.y + self.collectionView.bounds.size.height + 20, WIDTH, 30), NO)];
            for (int i = 0; i < 2; i ++) {
                UIView *lineView = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(119 + i * 119, 0, 0.5, CGRectGetHeight(view.bounds)), NO)];
                lineView.backgroundColor = [UIColor colorWithWhite:0.600 alpha:1.000];
                [view addSubview:lineView];
            }
            view;
        });
    }
    return _buttomView;
}
- (UIButton *)thumbUpButton {
    if (!_thumbUpButton) {
        _thumbUpButton = ({
        
            UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(0,0,119, CGRectGetHeight(self.buttomView.bounds)), NO)];
            
//            [button setImageEdgeInsets:UIEdgeInsetsMake(5,40,5,59)];
//            [button setImage:IMAGE_PATH(@"未点赞.png") forState:UIControlStateNormal];
//            [button setImage:IMAGE_PATH(@"点赞.png") forState:UIControlStateSelected];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(40, 5, 20, 20), NO)];
            imageView.image = IMAGE_PATH(@"未点赞.png");
            [button addSubview:imageView];
            
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(64, 5, 59, 20), NO)];
            label.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            label.font = [UIFont systemFontOfSize:15];
            [button addSubview:label];
            button.selected = NO;

            button;
            
         });
    }
    return _thumbUpButton;
}

- (UIButton *)commentsButton {
    if (!_commentsButton) {
        _commentsButton = ({
            UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(119,0,119, CGRectGetHeight(self.buttomView.bounds)), NO)];

            UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(40, 5, 20, 20), NO)];
            imageView.image = IMAGE_PATH(@"评论.png");
            [button addSubview:imageView];
            
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(64, 5, 59, 20), NO)];
            label.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            label.font = [UIFont systemFontOfSize:15];
            [button addSubview:label];
            
            button;
        });
    }
    return _commentsButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = ({
            UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(238,0,119, CGRectGetHeight(self.buttomView.bounds)), NO)];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(40, 5, 20, 20), NO)];
            imageView.image = IMAGE_PATH(@"未分享.png");
            [button addSubview:imageView];
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(64,5, 59, 20), NO)];
            label.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            label.font = [UIFont systemFontOfSize:15];
            [button addSubview:label];
            
            button;
        });
    }
    return _shareButton;

}

@end
