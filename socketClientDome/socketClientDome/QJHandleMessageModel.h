//
//  QJHandleMessageModel.h
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/7.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJHandleMessageModel : NSObject

@property (nonatomic , copy) NSString * displayName ;

@property (nonatomic , copy) NSString * senderId ;

@property (nonatomic , copy) NSString * text ;

@property (nonatomic , copy) NSString * dateStr ;

@property (nonatomic , copy) NSString * roomName ;

+(instancetype)handleMessageModelWithSenderId:(NSString *)senderId displayName:(NSString *)displayName text:(NSString *)text dateStr:(NSString*)dateStr roomName:(NSString *)roomName;


@end
