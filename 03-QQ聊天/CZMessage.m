

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
