//
//  CZMessageFrame.h
//  03-QQ聊天
//
//  Created by apple on 14-7-27.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CZTextFont [UIFont systemFontOfSize:15]

@class CZMessage;

@interface CZMessageFrame : NSObject
/**
 *  头像的frame
 */
@property (nonatomic, assign, readonly) CGRect iconF;

/**
*  时间的frame
*/
@property (nonatomic, assign, readonly) CGRect timeF;

/**
*  正文的frame
*/
@property (nonatomic, assign, readonly) CGRect textF;

/**
*  cell的高度
*/
@property (nonatomic, assign) CGFloat cellHeight;

/**
*  数据模型
*/
@property (nonatomic, strong) CZMessage *message;

@end
