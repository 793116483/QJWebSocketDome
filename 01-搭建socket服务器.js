
// 引入 http 框架
var http = require('http');

var server = http.createServer();

// 引入 socket 框架
var socketIo = require('socket.io');
// 创建 socket 端 
var serverSocket = socketIo(server);

serverSocket.on('connection',function listener(clietSocket){

    console.log(serverSocket , clietSocket);

});

// 监听
server.listen('8080');

console.log('开始监听 web socket 8080 端口');
