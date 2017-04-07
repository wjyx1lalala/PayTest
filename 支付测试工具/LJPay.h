//
//  LJPay.h
//  PayDemo
//
//  Created by nuomi on 2016/11/15.
//  Copyright © 2016年 nuomi. All rights reserved.
//支付宝 文档 https://doc.open.alipay.com/docs/doc.htm?spm=a219a.7629140.0.0.GN0t0g&treeId=193&articleId=105295&docType=1

//微信 文档  http://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=11_1
/*
 
 支付考虑几种情况
 1.支付宝支付的时候,用户没有安装客户端,是通过支付宝的webView进行支付的
 2.微信支付在没有安装客户端的时候,是无法进行微信支付的
 
 跳转到支付以后,
 1.假设用户未支付的情况下,未点击取消按钮,却通过其他方式回到客户端, 处理方式为
 2.假设微信用户已支付的情况下,未点击确定按钮,却通过其他方式回到客户端, 处理方式为
 
 兔巢 
 AppID: wx8179d14b2e26609b
 AppSecret: b5070451debf5c10558d810b7d5c5e1e
 
 */

#import <Foundation/Foundation.h>

//支付方式
typedef NS_ENUM(NSInteger, PayType) {
    AlipayMethod, //支付宝支付
    WXPayMothod   //微信支付
};

@interface LJPay : NSObject


+ (instancetype)sharedPay;


//配置微信支付必须的key
- (void)configureWechatPayKeyWith:(NSString *)appid;

//处理支付后的回调信息
- (void)handleOpenUrl:(NSURL *)openUrl;

/**
 *  发起支付
 *  @param type        支付方式
 *  @param payInfo     支付参数信息,支付宝传入字符串,微信传入字典
 *  @param resultBlock 支付结果的回调
 *  isPayOK  支付是否成功
 *  resultDesc  支付结果的描述信息,多用于失败或成功后的提示语句
 */
- (void)payWithPayMethod:(PayType)type andPayInfo:(id)payInfo andComplete:(void(^)(NSString * payResultCode,NSString * resultDesc))resultBlock;


@end
