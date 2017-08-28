//
//  IPModel.h
//  IPManagerDemo
//
//  Created by Ted Liu on 2017/2/17.
//  Copyright © 2017年 Ted Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPModel : NSObject
/**
 IP地址
 */
@property (nonatomic, copy) NSString *ipAddress;
/**
 IP端口
 */
@property (nonatomic, copy) NSString *ipPort;
/**
 IP使用时间
 */
@property (nonatomic, copy) NSString *ipUseTime;
/**
 格式化后的IP地址
 */
@property (nonatomic, copy) NSString *formatIpAddress;

/**
 对应iP输入前四个输入框，内部使用，可忽略
 */
@property (nonatomic, copy) NSString *ipInput1;
@property (nonatomic, copy) NSString *ipInput2;
@property (nonatomic, copy) NSString *ipInput3;
@property (nonatomic, copy) NSString *ipInput4;

@end
