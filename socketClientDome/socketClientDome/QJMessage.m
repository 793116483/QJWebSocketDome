//
//  QJMessage.m
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/7.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import "QJMessage.h"

@implementation QJMessage

+(instancetype)messageWithSenderId:(NSString *)senderId displayName:(NSString *)displayName text:(NSString *)text date:(NSDate*)date isCurrentUser:(BOOL)isCurrentUser
{
    QJMessage * message = [[self alloc] initWithSenderId:senderId senderDisplayName:displayName date:date text:text];
    
    // UserInitials     : 用户头像显示成字
    // backgroundColor  : 头像的背景颜色
    // textColor        : 头像字的颜色
    // font             : 头像字的字体大小
    // diameter         : 头像显示成圆形直径
    
    // 头像只显示 displayName 的 头一个字
    NSString * userInitials = [displayName substringToIndex:1];
    message.msgAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:userInitials backgroundColor:[UIColor blueColor] textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:23] diameter:50];
    
    // 气泡
    if (isCurrentUser) { // 如果是当前用户发出的信息，则气泡背景为下面的颜色
        message.msgBubbleImage = [[[JSQMessagesBubbleImageFactory alloc] init] outgoingMessagesBubbleImageWithColor:[UIColor brownColor]];
    }
    else{ // other user send message for bubble image
        message.msgBubbleImage = [[[JSQMessagesBubbleImageFactory alloc] init] incomingMessagesBubbleImageWithColor:[UIColor lightGrayColor]];
    }
    
    return message ;
}

@end
