//
//  IPManager.h
//  IPManagerDemo
//
//  Created by Ted Liu on 2017/2/16.
//  Copyright © 2017年 Ted Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface IPManager : NSObject
/**
 单例初始化ip控制器
 */
+ (instancetype)standardManager;
/**
 获取框架bundle资源
 */
+ (NSBundle *) ipManagerBundle;
/**
 获取当前框架默认IP地址
 */
- (IPModel *) getNormalIpModel;
/**
 设置管理器的第一响应者

 @param responder
 */
- (void) managerRegisterFirstResponder:(id) responder;
/**
 跳转并回调选择后的地址
 */
+ (void) actionManagerPresentVC:(UIViewController *) viewController
                completionBlock:(void (^)(IPModel *resultDic))successBlock;

@end
