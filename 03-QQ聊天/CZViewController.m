//
//  CZViewController.m
//  03-QQ聊天
//
//  Created by apple on 14-7-27.
//  Copyright (c) 2014年 itcast. All rights reserved.
/*
 使用代码
 可以在UIImageView上面添加子控件
 但是storyboard和xib都不能在UIImageView上面添加子控件
 */

#import "CZViewController.h"
#import "CZMessageFrame.h"
#import "CZMessage.h"
#import "CZMessageCell.h"

@interface CZViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *inputView;

@property (nonatomic, strong) NSMutableArray *messageFrames;

// 自动回复的字典
@property (nonatomic, strong) NSDictionary *autoReply;

@end

@implementation CZViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // 去掉分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    
    self.tableView.allowsSelection = NO;// 不允许选中
    
    
    // 监听键盘的通知（一旦键盘发生改变，系统会主动发布一些通知，我们只需要监听就可以）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    // 设置文本框左边显示一点空隙
    self.inputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    // 左边的leftView一直显示
    self.inputView.leftViewMode = UITextFieldViewModeAlways;
    
    self.inputView.delegate = self;
    
    // 刚进入页面，让cell滚动到最后一行
    [self scorllToLastCell];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSDictionary *)autoReply
{
    if (_autoReply == nil) {
        _autoReply = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AutoRely.plist" ofType:nil]];
    }
    return _autoReply;
}

// 懒加载
- (NSMutableArray *)messageFrames
{
    if (_messageFrames == nil) {
        // 1. 获取文件全路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
        // 2. 读取文件加载到一个数组里
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        // 3. 把字典数组里面的字典出去来转成模型 再放到一个临时数组里
        NSMutableArray *messageFrameArray = [NSMutableArray array];
        for (NSDictionary * dict in dictArray) {
            // 1. 创建小的数据模型
            CZMessage *message  = [CZMessage messageWithDict:dict];
            
            // 取出上一个数据模型，跟当前数据模型进行比较
            CZMessageFrame *lastMf  = [messageFrameArray lastObject];
            CZMessage *lastMesage = lastMf.message;
            
            // 判断两个数据模型里面的消息时间是否一致
            message.hideTime = [lastMesage.time isEqualToString:message.time];
            
            // 2. 创建大得数据模型
            CZMessageFrame *messageFrame = [[CZMessageFrame alloc]init];
            
            // 需要给打的数据模型赋值， 在把小模型赋值给打的数据模型之前，要设置完小模型里面的hideTime属性
            messageFrame.message = message;// 会调用CZMessageFrame里面的setMessage方法
            
            [messageFrameArray addObject:messageFrame];
            
        }
        // 4. 临时数组的数据赋值给整个控制器的数据容器
        _messageFrames = messageFrameArray;
    }
    return _messageFrames;
}
/*
 UIKeyboardAnimationCurveUserInfoKey = 7; // 动画执行的节奏
 UIKeyboardAnimationDurationUserInfoKey = "0.25"; 键盘弹出/隐藏的动画所需要的时间
 UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 216}}";
 UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 588}";
 UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 372}";
 
 // 键盘弹出刚开始的那一刻的frame
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 480}, {320, 216}}";
 // 弹出完毕的时候，键盘的frame
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 264}, {320, 216}}";
 
 // 键盘退出的frame
 // 键盘刚要退出那一刻的frame
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 264}, {320, 216}}";
 // 键盘退出完毕那一刻的frame
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 480}, {320, 216}}";

 */
- (void)keyBoardWillChangeFrame:(NSNotification *)note
{
//    // 键盘弹出的时候 整个self.view都往上移动
//    self.view.transform = CGAffineTransformMakeTranslation(0, -216);
//    
//    // 键盘隐藏的时候，改变sel.view回到原位
//    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    // 取得键盘改变frame以后的frame（取得键盘最后的frame）
    CGRect transYFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 计算self.view需要移动距离（当键盘弹出的时候，距离是-216。当键盘隐藏的时候，距离是0）
    CGFloat transfomY = transYFrame.origin.y - self.view.frame.size.height;
    
    // 取得键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
          self.view.transform = CGAffineTransformMakeTranslation(0, transfomY);
    }];
  
    
    // 设置window颜色
    self.view.window.backgroundColor = self.tableView.backgroundColor;
    
    
//    NSLog(@"note%@", note.userInfo);
}
// 键盘弹出的时候，看到黑色，1.由于动画的不同步 2.self.window

// 当表格开始拖拽的时候，就退出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 退出键盘
    [self.view endEditing:YES];
}

#pragma mark - 数据源方法 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. 创建cell
    CZMessageCell *cell = [CZMessageCell cellWithTableView:tableView];
    
    // 2. 给cell传递数据模型
    cell.messageFrame = self.messageFrames[indexPath.row];
    
    // 3. 返回cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMessageFrame *mf = self.messageFrames[indexPath.row];
    return mf.cellHeight;
}

#pragma mark - UITextFiled的代理

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"%@", textField.text);
    // 1. 自己发一条消息
    [self addMessage:textField.text andType:CZMessageTypeMe];
    
    // 2. 自动回复一条消息
    [self addMessage:[self relayWithText:textField.text] andType:CZMessageTypeOther];
    
    // 清空文字
    self.inputView.text = nil;
    
    return YES;
}

// 根据自己发的内容，返回一个自动回复的内容
- (NSString *)relayWithText:(NSString *)text
{
//    for (int i = 0; i < text.length; i++) {
//        // 遍历拿到你发送的消息里所有的每一个字符
//        NSString *word = [text substringWithRange:NSMakeRange(i, 1)];
//        NSLog(@"word = %@", word);
//        if (self.autoReply[word]) {
//            return self.autoReply[word];
//        }
//    }
    for (int i = 0; i < text.length - 1; i++) {
        // 遍历拿到你发送的消息里所有的每一个字符
        NSString *word = [text substringWithRange:NSMakeRange(i, 2)];
        NSLog(@"word = %@", word);
        if (self.autoReply[word]) {
            return self.autoReply[word];
        }
    }
    return @"走你";
}

- (void)addMessage:(NSString *)text andType:(CZMessageType)type
{
    // 1. 增加一个数据模型
    CZMessage *msg = [[CZMessage alloc] init];
    msg.type = type;
    msg.text = text;
    // 设置时间
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";// 时间的格式
    
    msg.time = [fmt stringFromDate:now];
    
    // 是否需要隐藏时间
    CZMessageFrame *lastMf = [self.messageFrames lastObject];
    CZMessage * lastMsg = lastMf.message;
    msg.hideTime = [msg.time isEqualToString:lastMsg.time];
    
    // 创建打的大的数据模型
    CZMessageFrame *mf = [[CZMessageFrame alloc] init];
    mf.message = msg;
    [self.messageFrames addObject:mf];
    
    // 2. 刷新表格
    [self.tableView reloadData];
    
    // 3. 让表格自动滚到到最后一行
    [self scorllToLastCell];
}
/**
 *
 */
- (void)scorllToLastCell
{
    // 让表格自动滚到到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageFrames.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
