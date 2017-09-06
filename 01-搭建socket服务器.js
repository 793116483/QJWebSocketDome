
// 引入 http 框架
var http = require('http');

var server = http.createServer();

// 引入 socket 框架
var socketIo = require('socket.io');
// 创建 socket 端 
var serverSocket = socketIo(server);

serverSocket.on('connection',function listener(clietSocket){

    console.log('建立连接成功');

    // 客户端发送数据
    // serverSocket.emit : 表示广播，给所有连接到服务器的客户端发送数据
    //  clietSocket.emit  : 给当前的客户端发送数据
    clietSocket.emit('connection','success');
    
    // 必须在完成连接后，监听 clientSocket 的 chat 事件 
    clietSocket.on('chat',function listener(data){
        console.log('========',data);

        clietSocket.emit('chat','Im fine ,thanks!!');
        
    });
});

// 监听
server.listen('8080');

console.log('开始监听 web socket 8080 端口');
