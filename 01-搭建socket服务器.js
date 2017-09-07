
// 引入 http 框架
var http = require('http');

var server = http.createServer();

// 引入 socket 框架
var socketIo = require('socket.io');
// 创建 socket 端 
var serverSocket = socketIo(server);

var dataArray = [];

serverSocket.on('connection',function listener(clietSocket){

    console.log('建立连接成功');

    // 客户端发送数据
    // serverSocket.emit : 表示广播，给所有连接到服务器的客户端发送数据
    //  clietSocket.emit  : 给当前的客户端发送数据
    clietSocket.emit('connection',dataArray);
    
    // 必须在完成连接后，监听 clientSocket 的 chat 事件 
    clietSocket.on('chat',function listener(data){
        console.log('========',data);
        // 一个客户端发出的信息，再用服务端发送给所有的接收都
        serverSocket.emit('chat',data);
        
        dataArray.push(data);

        // // 设置自动回应的数据 用于测式，现在不用了，用两台设备就可以通信了
        // var text = new String('好的好的');
        // var callBackDic = {'senderId':'183628','displayName':'Jack','text':text,'dateStr':data.dateStr,'isCurrentUser':0};
        // dataArray.push(callBackDic);        
        // // 向所有连接服务器的发送数据
        // serverSocket.emit('chat',callBackDic);
        
    });
});

// 监听
server.listen('8080');

console.log('开始监听 web socket 8080 端口');
