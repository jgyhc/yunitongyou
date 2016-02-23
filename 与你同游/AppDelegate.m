//
//  AppDelegate.m
//  与你同游
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "AppDelegate.h"
#import "ControllerManager.h"
#import <BmobSDK/Bmob.h>
#import <SMS_SDK/SMSSDK.h>
#import "Register.h"
//#import "FirstView.h"
#import "NetWorking.h"
#define APPKEY @"affe299f48c2"
#define APPSECRET @"1d94d057d830f3a18a404527ac49e9ee"
#define APPLICAYION_ID @"ed38f5e8bc84d1b80a90beab61dbc07b"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [Bmob registerWithAppKey:@"fa40b7c9510579d713ad9dd286fbdf68"];
//    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"_User"];
//    [bquery whereKey:@"username" equalTo:@"小明"];
//    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        if (error){
//            NSLog(@"error");
//        }else{
//
//            NSLog(@"%@", array);
//            }
//    }];
    [Bmob registerWithAppKey:APPLICAYION_ID];

    [SMSSDK registerApp:APPKEY withSecret:APPSECRET];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    
    ControllerManager *controllerManager = [ControllerManager shareControllerManager];
    
//    FirstView * firstView = [[FirstView alloc]initWithFrame:flexibleFrame(self.window.bounds, NO)];
//    firstView.alpha = 0;
//    [self.window addSubview:firstView];
    
//    [UIView animateWithDuration:6 animations:^{
//        
//        firstView.alpha = 1;
//        
//    } completion:^(BOOL finished) {
//        
//        
//        [firstView removeFromSuperview];
    
        self.window.rootViewController = controllerManager.rootViewController;
// 
//    }];
    
//    NetWorking *net = [[NetWorking alloc] init];
//    [net adddataWithTableName:@"User" data:@"timo" listName:@"username" successBlock:^(BmobObject *object) {
//        
//    } failBlock:^(NSError *error) {
//        
//    }];
//    [net addDataWithTableName:@"User" dic:@{@"username":@"mumu",@"phoneNumber":@"15923459231"} successBlock:^(BmobObject *object) {
//        
//    } failBlock:nil];
//
    Register *re = [[Register alloc] init];
    [re registeredWithPhoneNumber:@"1212" password:@"12312312" successBlock:^(NSString *objiectId) {
        NSLog(@"%@", objiectId);
    } failBlock:^(NSError *error) {
        
    }];
    
    
    
       return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
