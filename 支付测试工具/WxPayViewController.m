//
//  WxPayViewController.m
//  支付测试工具
//
//  Created by nuomi on 2017/4/7.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import "WxPayViewController.h"
#import "LJPay.h"

@interface WxPayViewController ()
@property (weak, nonatomic) IBOutlet UITextField *appID;
@property (weak, nonatomic) IBOutlet UITextField *partnerId;
@property (weak, nonatomic) IBOutlet UITextField *prepayId;
@property (weak, nonatomic) IBOutlet UITextField *nonceStr;
@property (weak, nonatomic) IBOutlet UITextField *timeStamp;
@property (weak, nonatomic) IBOutlet UITextField *package;
@property (weak, nonatomic) IBOutlet UITextField *sign;

@end

@implementation WxPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微信支付";
    // Do any additional setup after loading the view.
}
- (IBAction)wxPay:(id)sender {
    if ([self judegeIsEmptyNone:self.appID.text andAlertMsg:@"appID不能为空"]) {
        return;
    }
    if ([self judegeIsEmptyNone:self.partnerId.text andAlertMsg:@"partnerId不能为空"]) {
        return;
    }
    if ([self judegeIsEmptyNone:self.prepayId.text andAlertMsg:@"prepayId不能为空"]) {
        return;
    }
    if ([self judegeIsEmptyNone:self.nonceStr.text andAlertMsg:@"nonceStr不能为空"]) {
        return;
    }
    if ([self judegeIsEmptyNone:self.timeStamp.text andAlertMsg:@"timeStamp不能为空"]) {
        return;
    }
    if ([self judegeIsEmptyNone:self.package.text andAlertMsg:@"package不能为空"]) {
        return;
    }
    if ([self judegeIsEmptyNone:self.sign.text andAlertMsg:@"sign不能为空"]) {
        return;
    }
    
    
    
    
    
    [[LJPay sharedPay] payWithPayMethod:WXPayMothod andPayInfo:@{
        @"appID":self.appID.text,
        @"partnerId":self.partnerId.text,
        @"prepayId":self.prepayId.text,
        @"nonceStr":self.nonceStr.text,
        @"timeStamp":self.timeStamp.text,
        @"package":self.package.text,
        @"sign":self.sign.text
    }andComplete:^(NSString *payResultCode, NSString *resultDesc) {
        resultDesc = resultDesc ? resultDesc : @"支付结果未知";
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:resultDesc message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancle];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }];
}


- (BOOL)judegeIsEmptyNone:(NSString *)str andAlertMsg:(NSString *)alertString{
    if (str.length == 0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:alertString message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancle];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return YES;
    }else{
        return NO;
    }
}




- (IBAction)findWX:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_5"] options:@{} completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
