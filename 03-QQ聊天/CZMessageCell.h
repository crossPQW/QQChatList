//
//  CZMessageCell.h
//  03-QQ聊天
//
//  Created by apple on 14-7-27.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CZMessageFrame;

@interface CZMessageCell : UITableViewCell

@property (nonatomic, strong) CZMessageFrame *messageFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
