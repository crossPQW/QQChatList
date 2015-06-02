//
//  CZMessageCell.m
//  03-QQ聊天
//
//  Created by apple on 14-7-27.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "CZMessageCell.h"
#import "CZMessage.h"
#import "CZMessageFrame.h"
#import "UIImage+Help.h"

@interface CZMessageCell ()

/**
 *  时间
 */
@property (nonatomic, weak) UILabel *timeView;

/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;

/**
 *  正文
 */
@property (nonatomic, weak) UIButton *textView;

@end

@implementation CZMessageCell

// 提供一个快速创建cell的方法
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"message";
    // 1. 创建cell
    CZMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CZMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makView];
    }
    return self;
}

//初始化子控件
- (void)makView
{
    // 0. 设置cell的背景色
    self.backgroundColor = [UIColor clearColor];
    
    // 1. 时间
    UILabel *timeView = [[UILabel alloc] init];
    timeView.textAlignment = NSTextAlignmentCenter;
    timeView.font = [UIFont systemFontOfSize:13];
    timeView.textColor = [UIColor grayColor];
    [self.contentView addSubview:timeView];
    self.timeView = timeView;
    
    // 2. 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 3. 正文
    UIButton *textView = [[UIButton alloc] init];
    [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    textView.titleLabel.font = CZTextFont;
    textView.titleLabel.numberOfLines = 0;
//    [textView setBackgroundColor:[UIColor greenColor]];

    [self.contentView addSubview:textView];
    self.textView = textView;
    
    // 设置cell里面文字的内边距
    textView.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
}

// 重写setter方法，在这里来给子控件进行数据的初始化和frame的设置
- (void)setMessageFrame:(CZMessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    
    // 拿出来小的数据模型
    CZMessage *message = messageFrame.message;
    
    //1. 时间
    self.timeView.text = message.time;
    self.timeView.frame = messageFrame.timeF;
    
    //2. 头像
    NSString *icon = (message.type == CZMessageTypeMe) ? @"me" : @"other";
    self.iconView.image = [UIImage imageNamed:icon];
    self.iconView.frame = messageFrame.iconF;
    
    //3. 正文
    [self.textView setTitle:message.text forState:UIControlStateNormal];
    self.textView.frame = messageFrame.textF;

    // 4. 正文的背景
    if (message.type == CZMessageTypeMe) {// 自己发的，蓝色图片
        
//        // 普通的图片
//        UIImage *normal = [UIImage imageNamed:@"chat_send_nor"];
//        // 把普通的图片转换成一个可以拉伸的图片
//        // 这个方法就是把普通图片转成一个可以拉伸的图片，要告诉对象复制哪一块区域来进行填充
//        UIImage *lastImage = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(26, 30, 30, 26)];
        
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_send_nor"] forState:UIControlStateNormal];
    } else {
        
        // 想把图片的拉伸这个功能封装起来
        
//        UIImage *normal = [UIImage imageNamed:@"chat_recive_nor"];
//        CGFloat w = normal.size.width * 0.5;
//        CGFloat h = normal.size.height * 0.5;
//        
//     // 告诉图片，以最中间的一个点为基准，进行复制，来填充
//        UIImage *lastImage = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
        
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_recive_nor"] forState:UIControlStateNormal];
    }
}

@end
