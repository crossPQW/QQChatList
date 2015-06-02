//
//  CZMessage.m
//  03-QQ聊天
//
//  Created by apple on 14-7-27.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "CZMessage.h"

@implementation CZMessage
+ (instancetype)messageWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithdict:dict];
}

- (instancetype)initWithdict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
