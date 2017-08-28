//
//  IPManagerPageVC.h
//  IPManagerDemo
//
//  Created by Ted Liu on 2017/3/6.
//  Copyright © 2017年 Ted Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPModel.h"

@interface IPManagerPageVC : UIViewController
/**
 选择IP地址成功回调
 */
@property (nonatomic, copy) void (^selectedIPResponseSuceesCompletionBlock)(IPModel *ipModelDic);

@end
