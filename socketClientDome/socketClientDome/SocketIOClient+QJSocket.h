//
//  SocketIOClient+QJSocket.h
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/7.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketIO/SocketIO-Swift.h>

@interface SocketIOClient (QJSocket)

+(instancetype)shareSocketIOClient;

-(void)connectWithSuccessBlock:(void(^)(NSArray * data))successBlock ;

@end
