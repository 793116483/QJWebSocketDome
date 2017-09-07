//
//  ViewController.m
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/6.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import "ViewController.h"
#import "SocketIOClient+QJSocket.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}



// 测式 客户端的 Socket 与 服务端 Socket 通信
-(void)testSocketIOClient
{
    SocketIOClient * socketIOClient = [SocketIOClient shareSocketIOClient] ;
    
    [socketIOClient connectWithSuccessBlock:^(NSArray *data){
        
        NSLog(@"data = %@ ",data);
        
        [socketIOClient emit:@"chat" with:@[@"how are you?"]];
        
    }];
    
    [socketIOClient on:@"chat" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"data = %@ , ack = %@",data,ack);
    }];
}



@end
