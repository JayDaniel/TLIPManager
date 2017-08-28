//
//  IPModel.m
//  IPManagerDemo
//
//  Created by Ted Liu on 2017/2/17.
//  Copyright © 2017年 Ted Liu. All rights reserved.
//

#import "IPModel.h"

NSString *const kModelIPAddress = @"ipAddress";
NSString *const kModelIPPort    = @"ipPort";
NSString *const kModelIpUseTime = @"ipUseTime";
NSString *const kModelFormatIP  = @"formatIpAddress";

NSString *const kModelIpInput1 = @"ipInput1";
NSString *const kModelIpInput2 = @"ipInput2";
NSString *const kModelIpInput3 = @"ipInput3";
NSString *const kModelIpInput4 = @"ipInput4";

@implementation IPModel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.ipAddress       = [aDecoder decodeObjectForKey:kModelIPAddress];
        self.ipPort          = [aDecoder decodeObjectForKey:kModelIPPort];
        self.ipUseTime       = [aDecoder decodeObjectForKey:kModelIpUseTime];
        self.formatIpAddress = [aDecoder decodeObjectForKey:kModelFormatIP];
        
        self.ipInput1 = [aDecoder decodeObjectForKey:kModelIpInput1];
        self.ipInput2 = [aDecoder decodeObjectForKey:kModelIpInput2];
        self.ipInput3 = [aDecoder decodeObjectForKey:kModelIpInput3];
        self.ipInput4 = [aDecoder decodeObjectForKey:kModelIpInput4];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ipAddress       forKey:kModelIPAddress];
    [aCoder encodeObject:self.ipPort          forKey:kModelIPPort];
    [aCoder encodeObject:self.ipUseTime       forKey:kModelIpUseTime];
    [aCoder encodeObject:self.formatIpAddress forKey:kModelFormatIP];
    
    [aCoder encodeObject:self.ipInput1 forKey:kModelIpInput1];
    [aCoder encodeObject:self.ipInput2 forKey:kModelIpInput2];
    [aCoder encodeObject:self.ipInput3 forKey:kModelIpInput3];
    [aCoder encodeObject:self.ipInput4 forKey:kModelIpInput4];
}

- (NSString *)formatIpAddress
{
    return [NSString stringWithFormat:@"%@:%@",self.ipAddress,self.ipPort];
}

@end
