//
//  SocketIOClient+QJSocket.m
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/7.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import "SocketIOClient+QJSocket.h"

@implementation SocketIOClient (QJSocket)

static SocketIOClient * _socketIOClient ;

+(instancetype)shareSocketIOClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // ws 表示服务器检测到是 ws 会改成 TCP 连接
        NSString * urlStr = @"ws://192.168.31.200:8080";
        NSURL * url = [NSURL URLWithString:urlStr];
        
        _socketIOClient = [[SocketIOClient alloc] initWithSocketURL:url config:nil];
    });
    
    return _socketIOClient ;
}

-(void)connectWithSuccessBlock:(void (^)(NSArray * data))successBlock
{
    [self connect];
    
    [_socketIOClient on:@"connection" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
                
        if (successBlock) {
            successBlock(data);
        }
    }];
}

@end
