//
//  IPManager.m
//  IPManagerDemo
//
//  Created by Ted Liu on 2017/2/16.
//  Copyright © 2017年 Ted Liu. All rights reserved.
//

#import "IPManager.h"
#import "IPManagerPageVC.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation IPManager

/**
 单例初始化框架

 @param firstResponder
 @return
 */
+ (instancetype)standardManager{
    
    static IPManager *tools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tools = [[IPManager alloc] init];
    });
    return tools;
}
/**
 设置管理器的第一响应者
 
 @param responder
 */
- (void)managerRegisterFirstResponder:(id)responder
{
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [responder becomeFirstResponder];
}
/**
 获取框架bundle资源
 */
+ (NSBundle *) ipManagerBundle
{
    static NSBundle *managerBundle = nil;
    if (managerBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        managerBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[IPManager class]] pathForResource:@"IPManager" ofType:@"bundle"]];
    }
    return managerBundle;
}
- (IPModel *)getNormalIpModel
{
    // 初始化数据源
    NSMutableDictionary *modelDic = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"kTLIPManager"]]];
    
    if (modelDic[@"dataDic"]) {
        return modelDic[@"dataDic"];
    }
    return nil;
}
/**
 跳转事件

 @param viewController
 @param successBlock
 */
+ (void)actionManagerPresentVC:(UIViewController *)viewController completionBlock:(void (^)(IPModel *))successBlock
{
    IPManagerPageVC *managerList = [[IPManagerPageVC alloc] initWithNibName:@"IPManagerPageVC" bundle:[NSBundle bundleForClass:[IPManager class]]];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:managerList];
    managerList.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [viewController presentViewController:navigation animated:YES completion:nil];
    
    [managerList setSelectedIPResponseSuceesCompletionBlock:^(IPModel *ipModelDic) {
        
        successBlock(ipModelDic);
    }];
}
@end
