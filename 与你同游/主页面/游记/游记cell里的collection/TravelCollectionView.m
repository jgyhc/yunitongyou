//
//  TravelConnectionView.m
//  与你同游
//
//  Created by rimi on 15/11/7.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "TravelCollectionView.h"
#import "ImageView.h"

@interface TravelCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation TravelCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface{
    self.collectionImageArray = [NSMutableArray arrayWithObjects:@"11.jpg", @"12.jpg", @"13.jpg", @"14.jpg", @"15.jpg", nil];
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
    
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"COLLECTIONCELL"];

    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"COLLECTIONCELL" forIndexPath:indexPath];
    
//    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.collectionImageArray[indexPath.row]]];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    //等比例缩放
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.layer.cornerRadius = 5;
    imageView.clipsToBounds = YES;
//    imageView.image = [UIImage imageWithData:data];
    imageView.image = IMAGE_PATH(self.collectionImageArray[indexPath.row]);
    [cell.contentView addSubview:imageView];
    


    return cell;
    
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageView *imgView = [[ImageView alloc] init];
    imgView.view.frame = flexibleFrame(CGRectMake(0, 0, WIDTH, HEIGHT), NO);
    //    [imgView ShowImage:sender.currentImage];
    [imgView ShowImage:IMAGE_PATH(self.collectionImageArray[indexPath.row])];
    float imageWidth = 0.0;
    float imageHeight = 0.0;
    if (IMAGE_PATH(self.collectionImageArray[indexPath.row]).size.width > WIDTH) {
        imageHeight = IMAGE_PATH(self.collectionImageArray[indexPath.row]).size.height * (WIDTH /IMAGE_PATH(self.collectionImageArray[indexPath.row]).size.width);
        imageWidth = WIDTH;
        
    }else {
        imageWidth = IMAGE_PATH(self.collectionImageArray[indexPath.row]).size.width;
        imageHeight = IMAGE_PATH(self.collectionImageArray[indexPath.row]).size.height;
    }
    
    imgView.iamgeView.frame = flexibleFrame(CGRectMake(0, 0, imageWidth, imageHeight), NO);
    imgView.iamgeView.center = flexibleCenter(CGPointMake(WIDTH / 2, HEIGHT / 2), NO);
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imgView animated:NO completion:^{
        
    }];
}



@end
