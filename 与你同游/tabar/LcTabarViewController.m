//
//  LcTabarViewController.m
//  Deep_Breath
//
//  Created by rimi on 15/9/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "LcTabarViewController.h"
 
#define BUTTON_TAG 100
#define IMAGE_NAME(X) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:(X)]]
#define INDEX_ITEM @"发现"
#define TRAVELS_ITEM @"游记"
#define INITIATE_ITEM @"发起"
@interface LcTabarViewController ()

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSArray *barItemimages;
@property (nonatomic, assign) NSInteger selectedControllerIntex;//当前选中的controller
@property (nonatomic, strong) UIView *childControllerContrainerView;//管理子视图
@property (nonatomic, strong) UIView *buttonContainerView;
 
@end

@implementation LcTabarViewController
- (instancetype)initWithViewControllers:(NSArray *)viewControllers barItemImages:(NSArray *)baritemImages {
    self = [super init];
    if (self) {
        _selectedControllerIntex = 0;
        _viewControllers = viewControllers;
        _barItemimages = baritemImages;
    }
    return self;
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
    self = [super init];
    if (self) {
        _selectedControllerIntex = 0;
        _viewControllers = viewControllers;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.922 green:1.000 blue:0.933 alpha:1.000];
    // Do any additional setup after loading the view.
    [self initUserInterface];
}
- (void)initUserInterface {
    [self.view addSubview:self.childControllerContrainerView];
    [self.view addSubview:self.buttonContainerView];
    //判断ViewControllers的数量
    if (self.viewControllers.count == 0) {
        return;
    }
    //加载默认的viewController
    UIViewController *firstViewcontroller = self.viewControllers.firstObject;
    [self addChildViewController:firstViewcontroller];
    //加载所有的标签按钮
    NSArray *arrayName = @[INDEX_ITEM, INITIATE_ITEM, TRAVELS_ITEM];
    NSArray *arrayImageNormal = @[@"首页.png", @"发起未选中.png", @"游记未选中.png"];
    NSArray *arrayImageS = @[@"首页选中.png", @"发起选中.png", @"游记选中.png"];
    CGFloat buttonWidth = 375 / self.viewControllers.count;

    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = flexibleFrame(CGRectMake(buttonWidth *idx + 45, 3, buttonWidth - 90, 30), NO);
        button.tag = BUTTON_TAG + idx;
        [button addTarget:self action:@selector(action_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:IMAGE_NAME(arrayImageS[idx]) forState:UIControlStateSelected];
        [button setBackgroundImage:IMAGE_NAME(arrayImageNormal[idx]) forState:UIControlStateNormal];
        [button setBackgroundImage:IMAGE_NAME(arrayImageNormal[idx]) forState:UIControlStateHighlighted];
        [self.buttonContainerView addSubview:button];
        
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = flexibleFrame(CGRectMake(buttonWidth *idx + 40, 25, 40, 32), NO);
        button1.tag = BUTTON_TAG + 100 + idx;
        button1.titleLabel.font = [UIFont systemFontOfSize:13];
        [button1 setTitleColor:[UIColor colorWithWhite:0.686 alpha:1.000] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor colorWithWhite:0.686 alpha:1.000] forState:UIControlStateHighlighted];
        [button1 setTitleColor:[UIColor colorWithRed:0.188 green:0.788 blue:0.000 alpha:1.000] forState:UIControlStateSelected];
        [button1 addTarget:self action:@selector(action_buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setTitle:arrayName[idx] forState:UIControlStateNormal];
        [button1 setTitle:arrayName[idx] forState:UIControlStateSelected];
        [self.buttonContainerView addSubview:button1];
        
    }];
    UIButton *firstButton = (UIButton *)[self.buttonContainerView viewWithTag:BUTTON_TAG];
    firstButton.selected = YES;
    UIButton *firstButton1 = (UIButton *)[self.buttonContainerView viewWithTag:BUTTON_TAG + 100];
    firstButton1.selected = YES;

}
//点击按钮
- (void)action_buttonPressed:(UIButton *)sender {
    
    NSInteger index = sender.tag - BUTTON_TAG;
    //判断 点击的index是否为当前选中的index
    if(index == self.selectedControllerIntex) {
        return;
    }
    if (index != 0  && self.view.subviews.count > 2) {
        [self.view.subviews.lastObject removeFromSuperview];
    }
    //移除一个选中ViewController
    UIViewController *selectedViewcontroller = self.viewControllers[self.selectedControllerIntex];
    [selectedViewcontroller willMoveToParentViewController:nil];
    [selectedViewcontroller removeFromParentViewController];
    [selectedViewcontroller.view removeFromSuperview];
    //添加当前选中的viewcontroller
    UIViewController *currentViewcontroller = self.viewControllers[index];
    [self addChildViewController:currentViewcontroller];
    //更改button的选中状态
    UIButton *selectdButton = (UIButton *)[self.buttonContainerView viewWithTag:self.selectedControllerIntex + BUTTON_TAG];
    selectdButton.selected = NO;
    sender.selected = YES;
    UIButton *selectdButton1 = (UIButton *)[self.buttonContainerView viewWithTag:self.selectedControllerIntex + BUTTON_TAG + 100];
    selectdButton1.selected = NO;
    UIButton *sender1 = (UIButton *)[self.buttonContainerView viewWithTag:sender.tag + 100];
    sender1.selected = YES;
    //更新选中的下标
    self.selectedControllerIntex = index;
        
}
- (void)action_buttonPressed1:(UIButton *)sender {
    NSInteger index = sender.tag - BUTTON_TAG - 100;
    //判断 点击的index是否为当前选中的index
    if(index == self.selectedControllerIntex) {
        return;
    }
    if (index != 0  && self.view.subviews.count > 2) {
        [self.view.subviews.lastObject removeFromSuperview];
    }
    //移除一个选中ViewController
    UIViewController *selectedViewcontroller = self.viewControllers[self.selectedControllerIntex];
    [selectedViewcontroller willMoveToParentViewController:nil];
    [selectedViewcontroller removeFromParentViewController];
    [selectedViewcontroller.view removeFromSuperview];
    //添加当前选中的viewcontroller
    UIViewController *currentViewcontroller = self.viewControllers[index];
    [self addChildViewController:currentViewcontroller];
    //更改button的选中状态
    UIButton *selectdButton = (UIButton *)[self.buttonContainerView viewWithTag:self.selectedControllerIntex + BUTTON_TAG + 100];
    selectdButton.selected = NO;
    sender.selected = YES;
    UIButton *selectdButton1 = (UIButton *)[self.buttonContainerView viewWithTag:self.selectedControllerIntex + BUTTON_TAG];
    selectdButton1.selected = NO;
    UIButton *sender1 = (UIButton *)[self.buttonContainerView viewWithTag:sender.tag - 100];
    sender1.selected = YES;
    //更新选中的下标
    self.selectedControllerIntex = index;
    
}
//override
- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    [self.childControllerContrainerView addSubview:childController.view];
    [self didMoveToParentViewController:self];
}

#pragma mark --Getter
- (UIView *)childControllerContrainerView {

    if (!_childControllerContrainerView) {
        _childControllerContrainerView = ({
            UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
            view;
        });
    }
    return _childControllerContrainerView;
}
- (UIView *)buttonContainerView {
    if (!_buttonContainerView) {
        _buttonContainerView = ({
            UIView *view = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(0, 667 - 50, 375, 50), NO)];
            UIImageView *customBackgournd = [[UIImageView alloc] initWithImage:IMAGE_NAME(@"tabar.png")];
            customBackgournd.frame = flexibleFrame(CGRectMake(0, 0, 375, 50), NO);
            [view addSubview:customBackgournd];
            view;
        
        });
    }
    return _buttonContainerView;
}


#pragma mark --Setter
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == self.selectedControllerIntex) {
        return;
    }
    if (selectedIndex < self.viewControllers.count) {
        UIButton *button = (UIButton *)[self.buttonContainerView viewWithTag:selectedIndex + BUTTON_TAG];
        [self action_buttonPressed:button];
        self.selectedControllerIntex = selectedIndex;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
