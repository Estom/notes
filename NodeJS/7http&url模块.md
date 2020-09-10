# http&url模块

## 1 模块说明
* 用来构建nodejs的原声的服务器程序。

## 2 代码示例

### server.js
```java
var http = require("http");
var url = require("url");
 
function start(route) {
  function onRequest(request, response) {
    var pathname = url.parse(request.url).pathname;
    console.log("Request for " + pathname + " received.");
 
    route(pathname);
 
    response.writeHead(200, {"Content-Type": "text/plain"});
    response.write("Hello World");
    response.end();
  }
 
  http.createServer(onRequest).listen(8888);
  console.log("Server has started.");
}
 
exports.start = start;
```
### index.js
```java
var server = require("./server");
var router = require("./router");
 
server.start(router.route);
```