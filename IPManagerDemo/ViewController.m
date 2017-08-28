//
//  ViewController.m
//  IPManagerDemo
//
//  Created by Ted Liu on 16/4/22.
//  Copyright © 2016年 Ted Liu. All rights reserved.
//

#import "ViewController.h"
#import "IPManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
/**
 结束摇动代理方法
 */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    //振动效果
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //如果有摇动动作，就做相应操作
    if (event.subtype == UIEventSubtypeMotionShake) {
        [IPManager actionManagerPresentVC:self completionBlock:^(IPModel *resultDic) {
            NSLog(@"%@",resultDic.formatIpAddress);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
