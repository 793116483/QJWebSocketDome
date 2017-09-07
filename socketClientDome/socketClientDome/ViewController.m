//
//  ViewController.m
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/6.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import "ViewController.h"
#import "SocketIOClient+QJSocket.h"

#import "QJMessagesViewController.h"
#import "QJUserModel.h"

@interface ViewController ()

// 当前聊天房间的聊天记录
@property (nonatomic , strong) NSArray<NSDictionary *> * chatDataArray ;
// 当前进入聊天房间的用户与房间名
@property(nonatomic , strong) QJUserModel * userModel ;


@property(nonatomic , strong) UITextField * accountTF ;
@property(nonatomic , strong) UIButton * loginBtn ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"登录";
    
    [self addSubviews];
    
    // 监听从服务器传过来的数据，然后跳转到对应的 房间
    [self observerJoinRoomEvent];
}

-(void)addSubviews
{
    self.accountTF = [[UITextField alloc] initWithFrame:CGRectMake(80,100, 150, 40)];
    self.accountTF.placeholder = @"请输入聊天名称";
    self.accountTF.contentMode = UIViewContentModeLeft ;
    self.accountTF.layer.cornerRadius = 4 ;
    self.accountTF.layer.borderWidth = 0.5 ;
    self.accountTF.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:self.accountTF];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(80, 180, 80, 50);
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.loginBtn setTitle:@"聊天房间A" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(180, 180, 80, 50);
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.loginBtn setTitle:@"聊天房间B" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
}
-(void)loginBtnDidClicked:(UIButton *)btn
{
    [self.accountTF resignFirstResponder];
    
    // 进入房间告知服务器，好让服务器处理数据。服务器会给当前客户端通过事件 joinRoom 监听发送所有聊天信息
    NSString * roomName = btn.titleLabel.text ;
    [[SocketIOClient shareSocketIOClient] emit:@"joinRoom" with:@[roomName]];
    
    
    // 当前用户信息，为跳转到房间聊天页面做准备
    QJUserModel * userModel = [QJUserModel userModelWithName:self.accountTF.text roomName:roomName];
    if ([userModel.userName isEqualToString:self.userModel.userName]) {
        userModel.userId = self.userModel.userId ;
    }
    self.userModel = userModel ;
    
}

// 监听从服务器传过来的数据，然后跳转到对应的 房间
-(void)observerJoinRoomEvent
{
    // 进入房间时，拿到之前所有的聊天记录
    // 注意：如果这个事件添加多次，则 callback 的 block 会执行多次
    [[SocketIOClient shareSocketIOClient] on:@"joinRoom" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        
        // 拿到当前房间的聊天记录
        if (![data.firstObject isKindOfClass:[NSNull class]]) {
            self.chatDataArray = data.firstObject ;
        }
        
        // 跳转页面
        QJMessagesViewController * messagesVc = [QJMessagesViewController messagesViewControllerWithUserModel:self.userModel chatDataArray:self.chatDataArray];
        
        [self.navigationController pushViewController:messagesVc animated:YES];
    }];
}

#pragma mark - other somthing
// 测式 客户端的 Socket 与 服务端 Socket 通信
//-(void)testSocketIOClient
//{
//    SocketIOClient * socketIOClient = [SocketIOClient shareSocketIOClient] ;
//    
//    [socketIOClient connectWithSuccessBlock:^(NSArray *data){
//        
//        NSLog(@"data = %@ ",data);
//        
//        [socketIOClient emit:@"chat" with:@[@"how are you?"]];
//    }];
//    
//    [socketIOClient on:@"chat" callback:^(NSArray * data, SocketAckEmitter * ack) {
//        NSLog(@"data = %@ , ack = %@",data,ack);
//    }];
//}



@end
