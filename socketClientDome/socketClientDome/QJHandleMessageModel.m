//
//  QJHandleMessageModel.m
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/7.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import "QJHandleMessageModel.h"

@implementation QJHandleMessageModel

+(instancetype)handleMessageModelWithSenderId:(NSString *)senderId displayName:(NSString *)displayName text:(NSString *)text dateStr:(NSString *)dateStr roomName:(NSString *)roomName
{
    QJHandleMessageModel * messageModel = [[self alloc] init];
    
    messageModel.senderId = senderId ;
    messageModel.displayName = displayName ;
    messageModel.text = text ;
    messageModel.dateStr = dateStr ;
    messageModel.roomName = roomName ;
    
    return messageModel ;
}

@end
