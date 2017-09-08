# QJWebSocketDome 

# 简介
- **本 Dome 基于 Socket框架， 主要的功能就是即时通讯功能，创建房间，并与发送信息给所有在房间内的客户端，与QQ群相似，群的人数可以是'>'=2个人在房间内。**


# 使用过程
- **1、启动 Socket 服务器**
 > **node 01-搭建socket服务器.js**

- **2、打开 socketClientDome 工程，并运行代码。**

- **3、进入页面后，可以任意输入一个用户名字，然后进行登录**

- **4、socket 客户端 发送信息，与服务器通信，并监听服务返回的数据(即相当于他人给你回的信息)**


# 代码主要部份

## 服务端

### 需要在项目中下载 socket.io 框架模块
> **cd 到指定项目所在的文件夹 ， 然后在终端输入 node install socket.io --save 下载框架**

### 创建 基于 http 的 Socket 服务端

```
// 引入 http 框架
var http = require('http');

var server = http.createServer();

// 引入 socket 框架
var socketIo = require('socket.io');
// 创建 socket 服务端 
var serverSocket = socketIo(server);

```

### 监听 connection 事件 ， clietSocket 是客户端的 socket 

```
serverSocket.on('connection',function listener(clietSocket){
    // 在完成客户端与服务端连接后，在这里面监听事件从客户端发过来的数据去做一些事
}

```

### 给客户端监听的 connection 事件发送数据

```
clietSocket.emit('connection',data);

```

### 把 clietSocket 加入到名为 roomName 的房间

```
// 把当前的客户端添加到 room 名为 roomName 的房间内
// 这样的话，只要在发送数据给客户端时 就可以区分房间发送信息
clietSocket.join(roomName);

```

### 向名为 roomName 的房间内所有客户端发送数据

```
// 一个客户端发出的信息在当前的房间内都可以接收到 data 数据
serverSocket.to(data.roomName).emit('chat',data);

```

### clientSocket 客户端离开名为 roomName 的房间

```
// 一个客户端发出的信息在当前的房间内都可以接收到 data 数据
clietSocket.leave(roomName);

```



----

## 客户端

### 使用 cocoapods 导入 Socket.IO-Client-Swift 即时通讯 等所需的框架


```
use_frameworks!

target 'socketClientDome' do

pod 'Socket.IO-Client-Swift', '~> 11.1.0'

pod 'JSQMessagesViewController', '~> 7.3.5'

pod 'MJExtension', '~> 3.0.13'

end

```
 
## 创建 SocketIOClient 分类名为 QJSocket 的文件，添加一些方法

```
// 创建 socketIOClient
+(instancetype)shareSocketIOClient;

// 连接服务器 socketIO
-(void)connectWithSuccessBlock:(void(^)(NSArray * data))successBlock ;

```

## 连接 Socket 服务器

```
// 连接 Socket 服务器
[[SocketIOClient shareSocketIOClient] connectWithSuccessBlock:^(NSArray *data) {

NSLog(@"socket 连接成功 ，data = %@",data);

}];

```

## 监听从服务器传过来的数据，然后跳转到对应的 房间

```
// 进入房间时，拿到之前所有的聊天记录
// 注意：如果这个事件添加多次，则 callback 的 block 会执行多次
__weak typeof(self) weakSlef = self ;

[[SocketIOClient shareSocketIOClient] on:@"joinRoom" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {

// 拿到当前房间的聊天记录
if (![data.firstObject isKindOfClass:[NSNull class]]) {
weakSlef.chatDataArray = data.firstObject ;
}

// 跳转到聊天房间页面
[weakSlef jumpToMessagesVc];
}];

```

## 告诉服务端当前客户端准进入名为 roomName 的房间

```
// 进入房间告知服务器，好让服务器处理数据。服务器会给当前客户端通过事件 joinRoom 监听发送所有聊天信息
[[SocketIOClient shareSocketIOClient] emit:@"joinRoom" with:@[roomName]];

```


## 监听其他人的回应信息

```
// socket 监听其他人的回应信息
__weak typeof(self) weakSlef = self ;

[[SocketIOClient shareSocketIOClient] on:@"chat" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {

NSDictionary * keyValues = data.firstObject ;


QJHandleMessageModel * model = [QJHandleMessageModel mj_objectWithKeyValues:keyValues];
BOOL isCurrentUser = [model.senderId isEqualToString:weakSlef.userModel.userId];

QJMessage * message = [QJMessage messageWithSenderId:model.senderId displayName:model.displayName text:model.text date:[weakSlef dateWithDateStr:model.dateStr] isCurrentUser:isCurrentUser];
[weakSlef.messageDatas addObject:message];

[weakSlef.collectionView reloadData];

// 完成接收信息，让接收到最新的信息显示在底部，信息不会被遮档
[weakSlef finishReceivingMessageAnimated:YES];
}];

```

## 当前用户在房间内发信息

```
// 与服务器通信 , chat 为自定义事件（与服务器的事件一样才能接收到）
[[SocketIOClient shareSocketIOClient] emit:@"chat" with:@[keyValues]];

```



