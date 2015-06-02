

typedef enum{
    CZMessageTypeMe = 0, // 自己发的
    CZMessageTypeOther //别人发的
}CZMessageType;

#import <Foundation/Foundation.h>

@interface CZMessage : NSObject
/**
 *   聊天的内容
 */
@property (nonatomic, copy) NSString *text;

/**
 *  发送时间
 */
@property (nonatomic, copy) NSString *time;

/**
 *  消息类型 0 表示自己发布 1 表示别人发布 2 ...
 */
@property (nonatomic, assign) CZMessageType type;

/**
 * 是否隐藏时间
 */
@property (nonatomic, assign) BOOL hideTime;

+ (instancetype)messageWithDict:(NSDictionary *)dict;

- (instancetype)initWithdict:(NSDictionary *)dict;

@end
