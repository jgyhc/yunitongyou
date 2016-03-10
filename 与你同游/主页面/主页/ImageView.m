//
//  ImageView.m
//  与你同游
//
//  Created by rimi on 15/10/20.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "ImageView.h"

@interface ImageView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation ImageView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initializedApperance];
        
    }
    return self;
}
- (void)initializedApperance {
    self.scrollView = ({
        UIScrollView *scrollview = [[UIScrollView alloc] init];
        scrollview.frame = flexibleFrame(CGRectMake(0, 0, WIDTH, HEIGHT), NO);
        scrollview.backgroundColor = [UIColor blackColor];
        scrollview;
    });
    [self.view addSubview:self.scrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.iamgeView = ({
        UIImageView *imgview = [[UIImageView alloc] init];
        imgview.frame = flexibleFrame(CGRectMake(0, 0, WIDTH, 224), NO);

        imgview.center = flexibleCenter(CGPointMake(WIDTH / 2, HEIGHT / 2), NO);
        imgview;
    });
    [self.scrollView addSubview:self.iamgeView];
    
    
    UITapGestureRecognizer* singleRecognizer;
    
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signalTap:)];
    
    singleRecognizer.delegate=self;
    
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    [self.scrollView addGestureRecognizer:singleRecognizer];

}

- (void)ShowImage:(UIImage *)image {
    self.iamgeView.image = image;
}
- (void)signalTap:(UITapGestureRecognizer *)sender {

    [self dismissViewControllerAnimated:NO completion:^{
        
    }];

}


@end
