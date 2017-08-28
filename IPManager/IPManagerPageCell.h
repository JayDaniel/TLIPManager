//
//  IPManagerPageCell.h
//  IPManagerDemo
//
//  Created by Ted Liu on 2017/3/7.
//  Copyright © 2017年 Ted Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPModel.h"

@interface IPManagerPageCell : UITableViewCell
/**
 *  数据源
 */
@property (nonatomic, weak) IPModel *ipModelDic;

@end
