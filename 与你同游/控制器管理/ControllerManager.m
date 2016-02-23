//
//  ControllerManager.m
//  Deep_Breath
//
//  Created by rimi on 15/9/16.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
#import "ControllerManager.h"
#import "InitiateViewcontroller.h"
#import "LaunchViewController.h"
#import "TravelsViewController.h"


@interface ControllerManager ()

@property (nonatomic, strong)LeftViewController *leftViewController;
@end
//单例
@implementation ControllerManager
+ (ControllerManager *)shareControllerManager {
    
    static ControllerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ControllerManager alloc] init];
    });
    return manager;
}


#pragma mark --Getter
- (UINavigationController *)rootViewController {
    if (!_rootViewController) {
        _rootViewController = ({
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.drawerViewController];
            nav.navigationBarHidden = YES;
            nav;
        });
    }
    return _rootViewController;

}


- (UIViewController *)drawerViewController {
    if (!_drawerViewController) {
        _drawerViewController = ({
            DrawerViewController *drawerVC = [[DrawerViewController alloc] initWithMainViewControlle:self.mainViewController leftViewController:self.leftViewController];
            drawerVC;
        });
    }
    return _drawerViewController;
}

- (UIViewController *)mainViewController {
    if (!_mainViewController) {
        NSArray *classNames = @[@"LaunchViewController", @"InitiateViewcontroller", @"TravelsViewController",];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:3];
        [classNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Class class = NSClassFromString(obj);
            UIViewController *viewController = [[class alloc] init];
            [viewControllers addObject:viewController];
        }];
//        NSArray *array = @[@"1000-1", @"1001-1", @"1002-1", @"1003-1", @"1004-1"];
        _mainViewController = ({
            LcTabarViewController *mainVC = [[LcTabarViewController alloc] initWithViewControllers:viewControllers barItemImages:nil];
//            LcTabarViewController *TabarViewController = [[LcTabarViewController alloc] init];
            mainVC;
        });
    }
    return _mainViewController;
}


- (LeftViewController *)leftViewController {

    if (!_leftViewController) {
        _leftViewController = [[LeftViewController alloc] init];
    }
    return _leftViewController;
}




















@end
