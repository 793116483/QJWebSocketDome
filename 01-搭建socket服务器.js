
// 引入 http 框架
var http = require('http');

var server = http.createServer();

// 引入 socket 框架
var socketIo = require('socket.io');
// 创建 socket 端 
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

        console.log('====',roomName);                     
    });
    

    // 3.必须在完成连接后，监听 clientSocket 的 chat 事件 
    clietSocket.on('chat',function listener(data){

        // 添加聊天记录
        roomChatRecords.push(data);


        // 一个客户端发出的信息在当前的房间内都可以接收到 data 数据
        serverSocket.to(data.roomName).emit('chat',data);


        // // 设置自动回应的数据 用于测式，现在不用了，用两台设备就可以通信了
        // var text = new String('好的好的');
        // var callBackDic = {'senderId':'183628','displayName':'Jack','text':text,'dateStr':data.dateStr,'isCurrentUser':0};
        // dataArray.push(callBackDic);        
        // // 向所有连接服务器的发送数据
        // serverSocket.emit('chat',callBackDic);
        
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
