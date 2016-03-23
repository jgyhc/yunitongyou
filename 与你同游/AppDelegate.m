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
#import "Called.h"
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
//    NSArray *arra = @[@"再次相见时，是在一个冷雨飘飞的冬天，她穿着一条浅色的牛仔裤，一件他送的水红色大衣。没有伞，如丝的细雨簌簌地飘满她的发，她的衣，他还是第一次见到这么晶莹剔透的她，他震撼于她的美。", @"　　岁月不饶人，她似乎没能逃过岁月的磨蚀，有些憔悴了，他惊诧于她的沧桑。只不过，她还是那样的矜持，那样的温柔，唯一变化的是眉宇间已经没有了往日的忧伤。她显得那么坚强，好像在这离别的日子里，什么也没有发生，她似乎要告诉他：一切安好。", @"他走了，随他而去的还有那属于他们的过去。人走楼也空、人去茶也凉。一直以为，她自己会陷入黑暗的深渊。谁也没有料到，他们的故事还是续写了下去，这多少有些让她措手不及。她已知道，距离再远也阻挡不了那两颗炽热的心，他已根植于她的世界，她已嵌入他的心扉。", @"也不知道有多少个夜晚，在夜深人静的时候，依然独坐床头，痴痴地、傻傻地等待，等待那跳动的、专属于他的音符，即便等到的总是失望，却也还是那样天真执着。为了不错过那让她魂牵梦萦的声音，放在床边的电话，铃声总是越调越大，直至没法再大。也不知道有多少次，在绝望的等待中睡着了。可她知道，他有他的难处，一个人在遥远的他乡也不是一件易事。她相信，两颗彼此牵挂的心总有相聚时。", @"　一个人的城市，多少有些孤单，一切都是那样单调乏味。工作，还是工作；生活，还是生活。没有忧伤，没有眼泪，没有失落，还是那样出的出类拔萃，没有人知道为什么，除了她自己。也许这一份牵挂总在激励她前行。“海上生明月，天涯共此时”.曾经总是固执的认为，他一直在她身边，从未走远。", @"　一个人的城市，多少有些孤单，一切都是那样单调乏味。工作，还是工作；生活，还是生活。没有忧伤，没有眼泪，没有失落，还是那样出的出类拔萃，没有人知道为什么，除了她自己。也许这一份牵挂总在激励她前行。“海上生明月，天涯共此时”.曾经总是固执的认为，他一直在她身边，从未走远。", @"　　岁月无声，但却已留痕，沧桑已写在他们脸上。“人生若只如初见，何事秋风悲画扇”?对于走过千山万水，经历重重考验的他们，沧桑早非羁绊。"];
//    for (int i = 0; i < arra.count; i ++) {
//        [Comments addComentWithContent:arra[i] userID:@"dc23c0cdf4" type:0 objID:@"791b3496d7" success:^(NSString *commentID) {
//            
//        } failure:^(NSError *error1) {
//            
//        }];
//    }
//    [Called joinInCalledWithCalledID:@"791b3496d7" Success:^(BOOL isSuccess) {
//        
//    } failure:^(NSError *error) {
//        
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
