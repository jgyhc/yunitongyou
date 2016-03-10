//
//  SearchResultView.m
//  与你同游
//
//  Created by rimi on 15/10/22.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "SearchResultView.h"
#import "LaunchCollectionViewCell.h"
#import "SearchResultView.h"

#define DATASOURCE [[NSUserDefaults standardUserDefaults] objectForKey:@"searchResult"]

@interface SearchResultView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, strong)NSMutableArray *nameArray;


@end

@implementation SearchResultView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(WIDTH, 10);
    [self arrayMethod];

    self.collectionView = [[UICollectionView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, WIDTH, HEIGHT - 64), NO) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.collectionView];
    
    [self.collectionView registerClass:[LaunchCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    self.frame = self.collectionView.frame;
    
}

- (void)arrayMethod {
    [DATASOURCE enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj[@"picList"] != NULL) {
            NSMutableArray *array = obj[@"picList"];
            if (array.count != 0) {
                [self.dataSource addObject:obj];
                if (obj[@"name"] == nil) {
                    [self.nameArray addObject:@""];
                }else {
                    [self.nameArray addObject:obj[@"name"]];
                }
//                NSLog(@"seacrhResult = %@",obj[@"picList"][0][@"picUrlSmall"]);
                if ([self getImageFromURL:obj[@"picList"][0][@"picUrlSmall"]] == NULL) {
                    [self.imageArray addObject:IMAGE_PATH(@"空白图片.jpg")];
                }else {
                    [self.imageArray addObject:[self getImageFromURL:obj[@"picList"][0][@"picUrlSmall"]]];
                }
            }
        }
    }];
}


#pragma mark --执行图片下载函数
- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

#pragma mark --CollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = self.nameArray.count;
    return number;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.dataSource != NULL) {
        return 1;
    };
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    
    LaunchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell sizeToFit];
    cell.addressLabel.text = self.nameArray[indexPath.row];
    cell.imageView.image = self.imageArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    
    [headerView addSubview:nil];//头部广告栏
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return flexibleSize(CGSizeMake(originWidth_ / 2 - 10, 130), NO);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToScenicDetailEvent:)]) {
        [self.delegate pushToScenicDetailEvent:self.dataSource[indexPath.row]];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}

- (NSMutableArray *)nameArray {
    if (!_nameArray) {
        _nameArray = [[NSMutableArray alloc]init];
    }
    return _nameArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
