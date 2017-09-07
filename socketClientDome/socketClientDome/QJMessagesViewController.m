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

@interface QJMessagesViewController ()

@property (nonatomic , strong) NSMutableArray<QJMessage *> * messageDatas ;

@end

@implementation QJMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 一开始先要连接 socket ，但已经放在 AppDelegate 加载完成方法里面连接了,所以现在可以不用管这一步
    
    self.title = @"聊天";
    
    // 其他人的回应
    [[SocketIOClient shareSocketIOClient] on:@"chat" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        
    }];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messageDatas.count ;
}


#pragma mark - JSQMessagesCollectionViewDataSource
-(NSMutableArray *)messageDatas
{
    if (!_messageDatas) {
        _messageDatas = [NSMutableArray array];
    }
    
    return _messageDatas ;
}

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

// 按了发送信息按钮
-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    QJMessage * message = [QJMessage messageWithSenderId:senderId displayName:senderDisplayName text:text date:date isCurrentUser:YES];
    
    [self.messageDatas addObject:message];
    
    [self.collectionView reloadData];
    
    // 与服务器通信
    [[SocketIOClient shareSocketIOClient] emit:@"chat" with:@[text]];
}

@end
