const http = require('http');
const url = require('url');
http.createServer(
    function(request,response){
        //客户端传递的信息
        console.log(request.url);
        //使用URL模块解析url
        if(request.url!='/favicon.ico'){
            var userinfo = url.parse(request.url,true).query;
            console.log(userinfo.name+userinfo.age);
        }

        //响应客户端的信息
        response.writeHead(200,{'Content-Type':'text/plain;charset=utf-8'});
        response.write("你好ddddthis is node js\n")

        //结束客户端响应
        response.end('hello world');
    }
).listen(8081);
console.log("server runing")