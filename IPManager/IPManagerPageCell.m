//
//  IPManagerPageCell.m
//  IPManagerDemo
//
//  Created by Ted Liu on 2017/3/7.
//  Copyright © 2017年 Ted Liu. All rights reserved.
//

#import "IPManagerPageCell.h"

@interface IPManagerPageCell ()

@property (weak, nonatomic) IBOutlet UILabel *ipAddress;
@property (weak, nonatomic) IBOutlet UILabel *ipUseTime;


@end

@implementation IPManagerPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setIpModelDic:(IPModel *)ipModelDic
{
    _ipModelDic = ipModelDic;
    _ipAddress.text = [NSString stringWithFormat:@"%@:%@",_ipModelDic.ipAddress,_ipModelDic.ipPort];
    _ipUseTime.text = [NSString stringWithFormat:@"上次使用时间：%@",_ipModelDic.ipUseTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
