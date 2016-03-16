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
#import "Comments.h"
//#import "FirstView.h"
#import "NetWorking.h"
#define APPKEY @"affe299f48c2"
#define APPSECRET @"1d94d057d830f3a18a404527ac49e9ee"
//连接Bmob
#define APPLICAYION_ID @"ed38f5e8bc84d1b80a90beab61dbc07b"
#import "AMapLocationKit.h"
@interface AppDelegate ()
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [Bmob registerWithAppKey:APPLICAYION_ID];

    [SMSSDK registerApp:APPKEY withSecret:APPSECRET];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    
    ControllerManager *controllerManager = [ControllerManager shareControllerManager];
    self.window.rootViewController = controllerManager.rootViewController;
    
    [Comments addComentWithContent:@"测试" userID:@"dc23c0cdf4" type:0 objID:@"791b3496d7" success:^(NSString *commentID) {
        
    } failure:^(NSError *error1) {
        
    }];
//
//    [AMapLocationServices sharedServices].apiKey = @"d5adbafffb8ac86b9eacf7f6437f9ca0";
//    self.locationManager = [[AMapLocationManager alloc] init];
//    // 带逆地理（返回坐标和地址信息）
//    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//        
//        if (error)
//        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//            
////            if (error.code == AMapLocatingErrorLocateFailed)
////            {
////                return;
////            }
//        }
//        
//        NSLog(@"location:%@", location);
//        
//        if (regeocode)
//        {
//            NSLog(@"reGeocode:%@", regeocode);
//        }
//    }];
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
