//
//  CZMessageFrame.m
//  03-QQ聊天
//
//  Created by apple on 14-7-27.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "CZMessageFrame.h"
#import "CZMessage.h"
#import "NSString+Help.h"

@implementation CZMessageFrame

/**
 *  计算子控件的frame和cell的高度
 */
- (void)setMessage:(CZMessage *)message
{
    _message = message;
    
    // 间距
    CGFloat padding = 10;
    
    // 屏幕的尺寸
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 1. 时间
    if (message.hideTime == NO) { //  显示时间
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = screenW;
        CGFloat timeH = 40;
        _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }

    // 2. 头像
    CGFloat iconY = CGRectGetMaxY(_timeF);
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconX;
    if (message.type == CZMessageTypeMe) {// 自己发的，显示自己的头像
        iconX = screenW - padding - iconW;
    }else{
        iconX = padding;
    }
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 3. 正文
    CGFloat textY = iconY;
    // 文字的尺寸
    CGSize textMaxSize = CGSizeMake(200, MAXFLOAT);
    // 计算出来的真正文字的size
//    CGSize textRealSize = [self sizeWithText:message.text andFont:CZTextFont andMaxSize:textMaxSize];
    CGSize textRealSize = [message.text sizeWithFont:CZTextFont andMaxSize:textMaxSize];
    // 设置按钮的尺寸，比文字尺寸大一些
    CGSize textBtnSize = CGSizeMake(textRealSize.width + 20 * 2, textRealSize.height + 20 * 2);
    
    CGFloat textX;
    if (message.type == CZMessageTypeOther) { // 别人发得
        textX = CGRectGetMaxX(_iconF) + padding;
    }else{ // 自己发的
        textX = iconX - padding - textBtnSize.width;
    }
    _textF = CGRectMake(textX, textY, textBtnSize.width, textBtnSize.height);
//    _textF = (CGRect){{textX, textY}, textSize};
    
    // 4. cell 的高度
    CGFloat textMaxY = CGRectGetMaxY(_textF);
    CGFloat iconMaxY = CGRectGetMaxY(_iconF);
    _cellHeight = MAX(textMaxY, iconMaxY) + padding;

}
@end
