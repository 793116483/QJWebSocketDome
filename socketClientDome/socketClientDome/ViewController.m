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

    SocketIOClient * socketIOClient = [SocketIOClient shareSocketIOClient] ;
    
    [socketIOClient connectWithSuccessBlock:^(NSArray *data){
        
        NSLog(@"data = %@ ",data);
        
        [socketIOClient emit:@"chat" with:@[@"how are you?"]];
        
    }];
    
    [socketIOClient on:@"chat" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"data = %@ , ack = %@",data,ack);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
