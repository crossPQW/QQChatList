

#import <UIKit/UIKit.h>

@class CZMessageFrame;

@interface CZMessageCell : UITableViewCell

@property (nonatomic, strong) CZMessageFrame *messageFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
