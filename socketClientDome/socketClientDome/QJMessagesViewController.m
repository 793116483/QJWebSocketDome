//
//  QJMessagesViewController.m
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/7.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import "QJMessagesViewController.h"

#import "QJUserModel.h"
#import "QJMessage.h"
#import "SocketIOClient+QJSocket.h"
#import "QJHandleMessageModel.h"
#import <MJExtension/MJExtension.h>

@interface QJMessagesViewController ()

@property (nonatomic , strong)QJUserModel * userModel ;
@property (nonatomic , strong) NSMutableArray<NSDictionary *> * chatDataArray ;

@property (nonatomic , strong) NSMutableArray<QJMessage *> * messageDatas ;

@end

@implementation QJMessagesViewController

+(instancetype)messagesViewControllerWithUserModel:(QJUserModel *)userModel chatDataArray:(NSArray<NSDictionary *> *)chatDataArray
{
    QJMessagesViewController * messagesVc = [self messagesViewController];
    
    messagesVc.userModel = userModel ;
    
    for (NSDictionary * dic in chatDataArray) {
        
        [messagesVc.chatDataArray addObject:dic];
        
        QJHandleMessageModel * model = [QJHandleMessageModel mj_objectWithKeyValues:dic];
        BOOL isCurrentUser = [model.senderId isEqualToString:userModel.userId];
        
        QJMessage * message = [QJMessage messageWithSenderId:model.senderId displayName:model.displayName text:model.text date:[messagesVc dateWithDateStr:model.dateStr] isCurrentUser:isCurrentUser];
        
        [messagesVc.messageDatas addObject:message];
    }
    
    return messagesVc ;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self.delegate respondsToSelector:@selector(messagesVc:didChatCompleteData:)]) {
        [self.delegate messagesVc:self didChatCompleteData:self.chatDataArray];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 一开始先要连接 socket ，但已经放在 AppDelegate 加载完成方法里面连接了,所以现在可以不用管这一步
    
    self.title = @"聊天";
    
    [self observerOtherUserCallBackMessage];
}

// 监听其他人的回应信息
-(void)observerOtherUserCallBackMessage
{
    // socket 监听其他人的回应信息
    [[SocketIOClient shareSocketIOClient] on:@"chat" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        
        NSDictionary * keyValues = data.firstObject ;
        
        [self.chatDataArray addObject:keyValues];

        QJHandleMessageModel * model = [QJHandleMessageModel mj_objectWithKeyValues:keyValues];
        
        QJMessage * message = [QJMessage messageWithSenderId:model.senderId displayName:model.displayName text:model.text date:[self dateWithDateStr:model.dateStr] isCurrentUser:NO];
        [self.messageDatas addObject:message];
        
        [self.collectionView reloadData];
    }];
}

#pragma mark -  NSDate 类型的时间 转成 NSString 类型的时间 互换

/**
 把 NSDate 类型的时间 转成 NSString 类型的时间

 @param date NSDate 类型时间
 @return NSString 类型的时间，格式为 yyyy-MM-dd HH:mm:ss
 */
-(NSString *)dateStringWithDate:(NSDate *)date
{
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [dateFormat stringFromDate:date];
}

/**
 把 NSString 类型的时间 转成 NSDate 类型的时间
 
 @param dateStr NSString 类型时间
 @return NSDate 类型的时间，格式为 yyyy-MM-dd HH:mm:ss
 */
-(NSDate *)dateWithDateStr:(NSString *)dateStr
{
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [dateFormat dateFromString:dateStr];
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messageDatas.count ;
}


#pragma mark - JSQMessagesCollectionViewDataSource

// 本人的聊天昵称
- (NSString *)senderDisplayName
{
    return self.userModel.userName ;
}

// 本人的聊天 id
- (NSString *)senderId
{
    return self.userModel.userId ;
}

// 每条信息
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QJMessage * message = self.messageDatas[indexPath.row];
    
    return message ;
}

/**
 *  删除一条信息
 */
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [self.messageDatas removeObjectAtIndex:indexPath.row];
}

// 气泡：即每条信息的显示背景
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QJMessage * message = self.messageDatas[indexPath.row];

    return message.msgBubbleImage ;
}

// 头像
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QJMessage * message = self.messageDatas[indexPath.row];

    return message.msgAvatarImage ;
}

// 按了发送信息按钮 , 这里是按正常的用户逻辑是 需要把信息发到服务器之后才显示
-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    // 添加 当前用户发出的数据
    QJMessage * message = [QJMessage messageWithSenderId:senderId displayName:senderDisplayName text:text date:date isCurrentUser:YES];
    [self.messageDatas addObject:message];
    [self.collectionView reloadData];
    
    // 将发送的信息 转成 字典 传到服务器上
    NSString * dateStr = [self dateStringWithDate:date];
    QJHandleMessageModel * model = [QJHandleMessageModel handleMessageModelWithSenderId:senderId displayName:senderDisplayName text:text dateStr:dateStr] ;
    NSDictionary * keyValues = model.mj_keyValues ;
    
    [self.chatDataArray addObject:keyValues];
    
    // 与服务器通信 , chat 为自定义事件（与服务器的事件一样才能接收到）
    [[SocketIOClient shareSocketIOClient] emit:@"chat" with:@[keyValues]];
}

#pragma mark - getter
-(NSMutableArray *)messageDatas
{
    if (!_messageDatas) {
        _messageDatas = [NSMutableArray array];
    }
    
    return _messageDatas ;
}

-(NSMutableArray<NSDictionary *> *)chatDataArray
{
    if (!_chatDataArray) {
        _chatDataArray = [NSMutableArray array];
    }
    
    return _chatDataArray ;
}


@end
