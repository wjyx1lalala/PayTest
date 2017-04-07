//
//  AppDelegate.m
//  支付测试工具
//
//  Created by nuomi on 2017/4/7.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import "AppDelegate.h"
#import "LJPay.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    return YES;
}


#pragma mark - 处理回调

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    [[LJPay sharedPay] handleOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[LJPay sharedPay] handleOpenUrl:url];
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[LJPay sharedPay] handleOpenUrl:url];
    return YES;
}

@end
