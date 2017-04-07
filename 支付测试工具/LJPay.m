//
//  LJPay.m
//  PayDemo
//
//  Created by nuomi on 2016/11/15.
//  Copyright © 2016年 nuomi. All rights reserved.
//

#import "LJPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#define kStringNotEmpty(str) ([str isKindOfClass:[NSString class]] && str && str.length > 0)
#define kDictNotEmpty(objDict) ([objDict isKindOfClass:[NSDictionary class]] && objDict && objDict.count > 0)

@interface LJPay ()<WXApiDelegate>

@property (nonatomic,copy)void(^resultBlock)(NSString * resultCode,NSString * resultDesc);//回调

@end

@implementation LJPay

static LJPay *_singleton;

+ (instancetype)sharedPay{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[self alloc] init];;
    });
    return _singleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [super allocWithZone:zone];
    });
    return _singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appHasComein) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

//程序进入前台的回调
- (void)appHasComein{
  
  //防止已经执行了回调,1秒后再次进行校验
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (self.resultBlock) {
      NSLog(@"IOS 点击了左上角的跳转 或者通过home键位  进行的回调   导致客户端无法获取到支付的回调信息");
      self.resultBlock(@"3",@"支付状态未知");
      self.resultBlock = nil;
    }
  });
}

#pragma mark - 配置基础数据
- (void)configureWechatPayKeyWith:(NSString *)appid{
    [WXApi registerApp:appid withDescription:@"支付测试"];
}


- (void)payWithPayMethod:(PayType)type andPayInfo:(id)payInfo andComplete:(void(^)(NSString * payResultCode,NSString * resultDesc))resultBlock{
  
    self.resultBlock = resultBlock;

    //支付宝支付
    if(type == AlipayMethod){
        NSString * orderString = payInfo;
        if(kStringNotEmpty(orderString) == NO){
            if(self.resultBlock){
                [self payEndWithDesc:@"创建支付宝订单失败" andPayResult:2];
            }
            return ;
        }
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"paytestdemo" callback:^(NSDictionary *resultDic) {
            /*没有安装支付宝客户端,在webview里面支付的回调*/
            [self checkAliPayResult:resultDic];
        }];
    }else if (type == WXPayMothod){
      
        if([WXApi isWXAppInstalled] == NO){
            resultBlock(@"4",@"本机未安装微信客户端,请选择其他支付方式");
            return ;
        }
          
        NSDictionary *result  = payInfo;
        if (kDictNotEmpty(result) == NO) {
            if(self.resultBlock){
              [self payEndWithDesc:@"创建微信订单失败" andPayResult:2];
            }
            return ;
        }

        BOOL callWechatClientSuccess = YES;
        [self configureWechatPayKeyWith:result[@"appID"]];

        PayReq* req = [[PayReq alloc] init];
        req.partnerId = [result objectForKey:@"partnerId"];
        req.prepayId = [result objectForKey:@"prepayId"];
        req.nonceStr = [result objectForKey:@"nonceStr"];
        req.timeStamp = [[result objectForKey:@"timeStamp"] intValue];
        req.package = [result objectForKey:@"package"];
        req.sign = [result objectForKey:@"sign"];
        callWechatClientSuccess = [WXApi sendReq:req];
      
        if (callWechatClientSuccess == NO) {
        [self payEndWithDesc:@"调用微信客户端失败" andPayResult:2];
        }
      
    }
}


#pragma mark - 支付宝支付后的回调
- (void)checkAliPayResult:(NSDictionary *)result{
    
    NSString * aliMemo = result[@"memo"];
    
    if([result[@"resultStatus"] integerValue] == 4000){
        
        NSString * memo = @"订单支付失败";
        if (aliMemo && [aliMemo isKindOfClass:[NSString class]]) {
            memo = [memo stringByAppendingString:@"\n"];
            memo = [memo stringByAppendingString:aliMemo];
        }
        [self payEndWithDesc:memo andPayResult:2];
        
    }else if ([result[@"resultStatus"] integerValue] == 6001) {
        NSString * memo = @"支付取消";
        if (aliMemo && [aliMemo isKindOfClass:[NSString class]]) {
            memo = [memo stringByAppendingString:@"\n"];
            memo = [memo stringByAppendingString:aliMemo];
        }
        [self payEndWithDesc:memo andPayResult:2];
        
    }else if([result[@"resultStatus"] integerValue] == 6002){
        NSString * memo = @"网络连接出错";
        if (aliMemo && [aliMemo isKindOfClass:[NSString class]]) {
            memo = [memo stringByAppendingString:@"\n"];
            memo = [memo stringByAppendingString:aliMemo];
        }
        [self payEndWithDesc:memo andPayResult:2];
        
    }else if([result[@"resultStatus"] integerValue] == 8000){
        NSString * memo = @"支付宝正在处理中";
        if (aliMemo && [aliMemo isKindOfClass:[NSString class]]) {
            memo = [memo stringByAppendingString:@"\n"];
            memo = [memo stringByAppendingString:aliMemo];
        }
        [self payEndWithDesc:memo andPayResult:2];
        
    }else if ([result[@"resultStatus"] integerValue] == 9000){
        NSString * memo = @"支付成功";
        if (aliMemo && [aliMemo isKindOfClass:[NSString class]]) {
            memo = [memo stringByAppendingString:@"\n"];
            memo = [memo stringByAppendingString:aliMemo];
        }
        [self payEndWithDesc:memo andPayResult:1];
    }
}

#pragma mark - 微信支付后的回调
- (void)checkWXPayResult:(int )errorCode{
      if(errorCode == WXSuccess){
          //支付成功
          [self payEndWithDesc:@"支付成功" andPayResult:1];
      }else if(errorCode == WXErrCodeUserCancel){
          //支付取消
          [self payEndWithDesc:@"支付取消" andPayResult:2];
      }
}


//回调给外部支付结果
- (void)payEndWithDesc:(NSString *)desc andPayResult:(int)resultCode{
        NSString * resulString = [NSString stringWithFormat:@"%d",resultCode];
      if(self.resultBlock){
        self.resultBlock(resulString,desc);
        self.resultBlock = nil;
      }
}

//处理支付回调
- (void)handleOpenUrl:(NSURL *)openUrl{
    if ([openUrl.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:openUrl standbyCallback:^(NSDictionary *resultDic) {
            [self checkAliPayResult:resultDic];
        }];
    }else{
        [WXApi handleOpenURL:openUrl delegate:self];
    }
}

#pragma mark - WXApiDelegate 微信支付后的回调处理
- (void)onResp:(BaseResp *)resp {
  if([resp isKindOfClass:[PayResp class]]){
    //支付返回结果，实际支付结果需要去微信服务器端查询
    //PayResp * result = (PayResp *)resp;
    //NSLog(@"返回结果是:%@",result.returnKey);
    [self checkWXPayResult:resp.errCode];
  }
}


@end











