//
//  AppDelegate.m
//  i_就业
//
//  Created by 赵奎博 on 16/4/13.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ZKB_TabarViewController.h"
#import "EMSDK.h"
#import "EaseSDKHelper.h"
#import "ChatDemoHelper.h"
#import "EMOptions+PrivateDeploy.h"

//#import "AppDelegate+EaseMob.h"
#define EaseMobAppKey @"ijob-dh#ijob"
#define kSDKConfigEnableConsoleLogger @"SDKConfigEnableConsoleLogger"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ///*
    EMOptions *options = [EMOptions optionsWithAppkey:@"ijob-dh#ijob"];
    options.apnsCertName = @"pro";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"chat"];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] isEqualToString:@"1"])
    {
        
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:[[NSUserDefaults standardUserDefaults]objectForKey:@"code"] password:[[NSUserDefaults standardUserDefaults]objectForKey:@"pass"]];
        if (!error) {
            NSLog(@"登录成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"chatsuc" object:nil];
            });
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"chat"];
        }else{
            NSLog(@"失败----\n%@",error.errorDescription);
        }
    });
    }
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
//#warning 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
//#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = @"pro";
//#if DEBUG
//    apnsCertName = @"dev";
//#else
//    apnsCertName = @"pro";
//#endif
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appkey = [ud stringForKey:@"identifier_appkey"];
    if (!appkey) {
        appkey = EaseMobAppKey;
        [ud setObject:appkey forKey:@"identifier_appkey"];
    }
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:appkey
                                         apnsCertName:apnsCertName
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES],@"easeSandBox":[NSNumber numberWithBool:[self isSpecifyServer]]}];
    
    [ChatDemoHelper shareHelper];
    
    //*/
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] isEqualToString:@"1"])
    {
        ZKB_TabarViewController * nv = [[ZKB_TabarViewController alloc]init];
        self.window.rootViewController = nv;
    }
    else
    {
        UINavigationController * nv = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]init]];
        nv.navigationBarHidden = YES;
        self.window.rootViewController = nv;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myb" object:nil];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
//    NSError *parseError = nil;
//    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
//                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
//    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
//                                                    message:str
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                                          otherButtonTitles:nil];
//    [alert show];
    
}

-(BOOL)isSpecifyServer{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSNumber *specifyServer = [ud objectForKey:@"identifier_enable"];
    if ([specifyServer boolValue]) {
        NSString *apnsCertName = nil;
#if DEBUG
        apnsCertName = @"dev";
#else
        apnsCertName = @"pro";
#endif
        NSString *appkey = [ud stringForKey:@"identifier_appkey"];
        if (!appkey)
        {
            appkey = EaseMobAppKey;
            [ud setObject:appkey forKey:@"identifier_appkey"];
        }
        NSString *imServer = [ud stringForKey:@"identifier_imserver"];
        if (!imServer)
        {
            imServer = @"120.26.12.158";
            [ud setObject:imServer forKey:@"identifier_imserver"];
        }
        NSString *imPort = [ud stringForKey:@"identifier_import"];
        if (!imPort)
        {
            imPort = @"6717";
            [ud setObject:imPort forKey:@"identifier_import"];
        }
        NSString *restServer = [ud stringForKey:@"identifier_restserver"];
        if (!restServer)
        {
            restServer = @"42.121.255.137";
            [ud setObject:restServer forKey:@"identifier_restserver"];
        }
        [ud synchronize];
        
        EMOptions *options = [EMOptions optionsWithAppkey:appkey];
        if (![ud boolForKey:@"enable_dns"])
        {
            options.enableDnsConfig = NO;
            options.chatPort = [[ud stringForKey:@"identifier_import"] intValue];
            options.chatServer = [ud stringForKey:@"identifier_imserver"];
            options.restServer = [ud stringForKey:@"identifier_restserver"];
        }
        //    EMOptions *options = [EMOptions optionsWithAppkey:@"easemob-demo#chatdemoui"];
        options.apnsCertName = @"chatdemoui_dev";
        options.enableConsoleLog = YES;
        
        [[EMClient sharedClient] initializeSDKWithOptions:options];
        return YES;
    }
    
    return NO;
}

@end
