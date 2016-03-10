//
//  LaunchViewScrollImage.m
//  viewController
//
//  Created by rimi on 15/10/13.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "LaunchViewScrollImage.h"

@interface LaunchViewScrollImage () <UIScrollViewDelegate>{
    
    NSTimer *_timer;
}

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;



@property (nonatomic, strong)NSArray *tempArray;
@property (nonatomic,strong ) UILabel *addressLabel;

@end

@implementation LaunchViewScrollImage

- (instancetype)initWithFrame:(CGRect)frame AddressArray:(NSArray *)addressArray
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAddressArray:addressArray];
    }
    return self;
}

- (void)setAddressArray:(NSArray *)addressArray {
    self.tempArray = addressArray;
    [self initUserinterface];
}

- (void)initUserinterface {
    _scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, WIDTH, 200), NO)];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView;
    });
    [self addSubview:_scrollView];
    
    UIView *containerView = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 180, WIDTH, 20), NO)];
    containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:containerView];
    UIView *alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame))];
    alphaView.backgroundColor = [UIColor colorWithRed:0.211 green:0.921 blue:0.722 alpha:0.400];
    alphaView.alpha = 0.7;
    [containerView addSubview:alphaView];
    
    _pageControl = ({
        UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:flexibleFrame(CGRectMake(10, 0, WIDTH - 10, 20) ,NO)];
        pageControl.currentPage = 0;
        pageControl;
    });
    [containerView addSubview:_pageControl];
    
    _addressLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(WIDTH / 2 - 10, 0, WIDTH / 2, 20), NO)];
        label.font = [UIFont boldSystemFontOfSize:(SCREEN_HEIGHT / 667.0) * 15];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentRight;
        label.text = _tempArray[0];
        label;
    });
    [containerView addSubview:_addressLabel];
    
    //定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)timerAction:(NSTimer *)timer {
    if (_totalNum > 1) {
        CGPoint newOffset = _scrollView.contentOffset;
        newOffset.x = newOffset.x + CGRectGetWidth(_scrollView.frame);
        if (newOffset.x > (CGRectGetWidth(_scrollView.frame) * (_totalNum - 1))) {
            newOffset.x = 0;
        }
        
        int index = newOffset.x / CGRectGetWidth(_scrollView.frame);
        newOffset.x = index * CGRectGetWidth(_scrollView.frame);
        [_scrollView setContentOffset:newOffset animated:YES];
    }else {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark --deleagete

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isMemberOfClass:[UITableView class]]) {
    }else {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        _pageControl.currentPage = index;
        _addressLabel.text = _tempArray[index];
        for (UIView *view in scrollView.subviews) {
            if (view.tag == index) {
                
            }else {
            }
        }
    }
}

- (void)setArray:(NSArray *)imgArray {
    _totalNum = [imgArray count];
    if (_totalNum>0) {
        for (int i = 0; i<_totalNum; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.image = IMAGE_PATH(imgArray[i]);
            [img setTag:i];
            [_scrollView addSubview:img];
        }
        _pageControl.numberOfPages = _totalNum; //设置页数 //滚动范围 600=300*2，分2页
        CGRect frame;
        frame = _pageControl.frame;
        frame.size.width = 15*_totalNum;
        _pageControl.frame = frame;
    }else{
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        [img setImage:IMAGE_PATH(@"拍照.png")];
        img.userInteractionEnabled = YES;
        [_scrollView addSubview:img];
        _addressLabel.text = @"提示：滚动栏无数据。";
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame)*_totalNum,CGRectGetHeight(_scrollView.frame));//滚动范围 600=300*2，分2页
}

- (void)setUrlArray:(NSArray *)imgUrlArray {
    _totalNum = [imgUrlArray count];
    if (_totalNum>0) {
        for (int i = 0; i<_totalNum; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.image = imgUrlArray[i];
            [img setTag:i];
            [_scrollView addSubview:img];
        }
        _pageControl.numberOfPages = _totalNum; //设置页数 //滚动范围 600=300*2，分2页
        CGRect frame;
        frame = _pageControl.frame;
        frame.size.width = 15*_totalNum;
        _pageControl.frame = frame;
    }else{
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        [img setImage:IMAGE_PATH(@"拍照.png")];
        img.userInteractionEnabled = YES;
        [_scrollView addSubview:img];
        _addressLabel.text = @"提示：滚动栏无数据。";
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame)*_totalNum,CGRectGetHeight(_scrollView.frame));//滚动范围 600=300*2，分2页
}


- (void)openTimer {
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)closeTimer {
    [_timer setFireDate:[NSDate distantFuture]];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
