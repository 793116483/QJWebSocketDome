//
//  ViewController.m
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/6.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import "ViewController.h"

#import <SocketIO/SocketIO-Swift.h>

@interface ViewController ()

@property(nonatomic , strong) SocketIOClient *clientSocket ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString * urlStr = @"http://192.168.31.200:8080";
    NSURL * url = [NSURL URLWithString:urlStr];
    
    SocketIOClient * clientSocket = [[SocketIOClient alloc] initWithSocketURL:url config:nil];
    self.clientSocket = clientSocket ;
    
    [clientSocket on:@"connection" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        
        NSLog(@"data = %@ , ack = %@",data,ack);
        
        [clientSocket emit:@"chat" with:@[@"how are you?"]];
        
    }];
    
    [clientSocket on:@"chat" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"data = %@ , ack = %@",data,ack);
    }];
    
    [clientSocket connect];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
