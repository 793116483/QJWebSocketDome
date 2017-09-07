//
//  QJMessage.h
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/7.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessage.h>

#import <JSQMessagesViewController/JSQMessagesBubbleImageFactory.h>
#import <JSQMessagesViewController/JSQMessagesAvatarImageFactory.h>

@interface QJMessage : JSQMessage

/**
    头像：发出每一条显示信息的用户头像
 */
@property (nonatomic , strong) JSQMessagesAvatarImage * msgAvatarImage ;

/**
    气泡：指的是在每一条显示发出的信息背景样式
 */
@property (nonatomic , strong) JSQMessagesBubbleImage * msgBubbleImage ;


/**
 创建对象

 @param senderId        发送信息的用户id
 @param displayName     发送信息的用户显示名称
 @param text            发送的信息
 @param isCurrentUser   是否是当前账号的用户
 @return                对象
 */
+(instancetype)messageWithSenderId:(NSString *)senderId displayName:(NSString *)displayName text:(NSString *)text date:(NSDate*)date isCurrentUser:(BOOL)isCurrentUser ;

@end
