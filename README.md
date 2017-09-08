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

## 需要在项目中下载 socket.io 框架模块
> **cd 到指定项目所在的文件夹 ， 然后在终端输入 node install socket.io --save 下载框架**

## 创建 基于 http 的 Socket 服务端

```
// 引入 http 框架
var http = require('http');

var server = http.createServer();

// 引入 socket 框架
var socketIo = require('socket.io');
// 创建 socket 服务端 
var serverSocket = socketIo(server);

```

## 监听 connection 事件 ， clietSocket 是客户端的 socket 

```
serverSocket.on('connection',function listener(clietSocket){
    // 在完成客户端与服务端连接后，在这里面监听事件从客户端发过来的数据去做一些事
}

```

## 给客户端监听的 connection 事件发送数据

```
clietSocket.emit('connection',data);

```

## 把 clietSocket 加入到名为 roomName 的房间

```
// 把当前的客户端添加到 room 名为 roomName 的房间内
// 这样的话，只要在发送数据给客户端时 就可以区分房间发送信息
clietSocket.join(roomName);

```

## 向名为 roomName 的房间内所有客户端发送数据

```
// 一个客户端发出的信息在当前的房间内都可以接收到 data 数据
serverSocket.to(data.roomName).emit('chat',data);

```

## clientSocket 客户端离开名为 roomName 的房间

```
// 一个客户端发出的信息在当前的房间内都可以接收到 data 数据
clietSocket.leave(roomName);

```

# 服务端所有的代码

```

// 引入 http 框架
var http = require('http');

var server = http.createServer();

// 引入 socket 框架
var socketIo = require('socket.io');
// 创建 socket 服务端 
var serverSocket = socketIo(server);

// 记录聊天房间数量
var rooms = [];
// 记录每个房间的聊天记录
var roomChatRecords = new Array();

serverSocket.on('connection',function listener(clietSocket){

console.log('建立连接成功');
// 1.向客户端发送数据，表示已经连接成功
// serverSocket.emit : 表示广播，给所有连接到服务器的客户端发送数据
//  clietSocket.emit  : 给当前的客户端发送数据
clietSocket.emit('connection',[]);


// 2.加入房间 joinRoom 事件 , 参数为 roomName
clietSocket.on('joinRoom',function listener(roomName){

// 把当前的客户端添加到 room 名为 roomName 的房间内
// 这样的话，只要在发送数据给客户端时 就可以区分房间发送信息
clietSocket.join(roomName);

// 记录房间名
var isNeedAdd = 1 ;
for(var i = 0 ; i < rooms.length ; i++){
var otherRoomName = rooms[i];
if(otherRoomName == roomName){
isNeedAdd = 0 ;
break ;
}
}
if(isNeedAdd){

rooms.push(roomName);
}

// 进入房间时，发送每个房间的所有聊天记录
// 先择出对应 room 房间的 聊天记录
var roomRecords = [];
for(var i = 0 ; i < roomChatRecords.length ; i++){
var data = roomChatRecords[i];
if(data.roomName == roomName)
roomRecords.push(data);
}
clietSocket.emit('joinRoom',roomRecords);

console.log('当前客户端加入房间',roomName);                     
});


// 3.必须在完成连接后，监听 clientSocket 的 chat 事件 
clietSocket.on('chat',function listener(data){

// 添加聊天记录
roomChatRecords.push(data);


// 一个客户端发出的信息在当前的房间内都可以接收到 data 数据
serverSocket.to(data.roomName).emit('chat',data);

console.log('========',data);        
});


// 4.离开房间事件监听 clientSocket 的 chat 事件 
clietSocket.on('leave',function listener(roomName){

// 一个客户端发出的信息在当前的房间内都可以接收到 data 数据
clietSocket.leave(roomName);

console.log('离开房间: ',roomName);        
});   

});

// 监听
server.listen('8080');

console.log('开始监听 web socket 8080 端口');


```


