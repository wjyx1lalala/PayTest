//
//  AlipayViewController.m
//  支付测试工具
//
//  Created by nuomi on 2017/4/7.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import "AlipayViewController.h"
#import "LJPay.h"

@interface AlipayViewController ()

@property (weak, nonatomic) IBOutlet UITextView *tf;


@end

@implementation AlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tf.layer.borderColor = [UIColor colorWithRed:120/255.0 green:211/255.0 blue:149/255.0 alpha:1].CGColor;
    // Do any additional setup after loading the view.
}


- (IBAction)findAliay:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://doc.open.alipay.com/docs/doc.htm?spm=a219a.7629140.0.0.GN0t0g&treeId=193&articleId=105295&docType=1"] options:@{} completionHandler:nil];
}


- (IBAction)gotoAliPay:(id)sender {
    if (self.tf.text.length == 0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"支付参数不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancle];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return;
    }
    [[LJPay sharedPay] payWithPayMethod:AlipayMethod andPayInfo:self.tf.text andComplete:^(NSString *payResultCode, NSString *resultDesc) {
        resultDesc = resultDesc ? resultDesc : @"支付结果未知";
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:resultDesc message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancle];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
