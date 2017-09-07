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

@interface ViewController ()<QJMessagesViewControllerDelegate>

@property(nonatomic , strong) UITextField * accountTF ;
@property(nonatomic , strong) UIButton * loginBtn ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"登录";
    
    [self addSubviews];
}

-(void)addSubviews
{
    self.accountTF = [[UITextField alloc] initWithFrame:CGRectMake(80,100, 150, 40)];
    self.accountTF.layer.cornerRadius = 4 ;
    self.accountTF.layer.borderWidth = 0.5 ;
    self.accountTF.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:self.accountTF];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(80, 180, 150, 50);
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
}
-(void)loginBtnDidClicked
{
    QJUserModel * userModel = [QJUserModel userModelWithName:self.accountTF.text];
    QJMessagesViewController * messagesVc = [QJMessagesViewController messagesViewControllerWithUserModel:userModel chatDataArray:self.chatDataArray];
    messagesVc.delegate = self ;
    
    [self.navigationController pushViewController:messagesVc animated:YES];
}

#pragma mark - QJMessagesViewControllerDelegate
-(void)messagesVc:(QJMessagesViewController *)msgVc didChatCompleteData:(NSArray<NSDictionary *> *)chatDataArray
{
    self.chatDataArray = chatDataArray ;
}


#pragma mark - other somthing
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
