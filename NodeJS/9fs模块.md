# fs模块
## 1 流读写
### 流的四种状态

* Readable - 可读操作。

* Writable - 可写操作。

* Duplex - 可读可写操作.

* Transform - 操作被写入数据，然后读出结果。

### 流对象事件

* data - 当有数据可读时触发。

* end - 没有更多的数据可读时触发。

* error - 在接收和写入过程中发生错误时触发。

* finish - 所有数据已被写入到底层系统时触发。

### 流读取
```js
var fs = require("fs");
var data = '';

// 创建可读流
var readerStream = fs.createReadStream('input.txt');

// 设置编码为 utf8。
readerStream.setEncoding('UTF8');

// 处理流事件 --> data, end, and error
readerStream.on('data', function(chunk) {
   data += chunk;
});

readerStream.on('end',function(){
   console.log(data);
});

readerStream.on('error', function(err){
   console.log(err.stack);
});

console.log("程序执行完毕");
```

### 流写入
```js
var fs = require("fs");
var data = '菜鸟教程官网地址：www.runoob.com';

// 创建一个可以写入的流，写入到文件 output.txt 中
var writerStream = fs.createWriteStream('output.txt');

// 使用 utf8 编码写入数据
writerStream.write(data,'UTF8');

// 标记文件末尾
writerStream.end();

// 处理流事件 --> data, end, and error
writerStream.on('finish', function() {
    console.log("写入完成。");
});

writerStream.on('error', function(err){
   console.log(err.stack);
});

console.log("程序执行完毕");
```
### 管道流
通过读取一个文件内容并将内容写入到另外一个文件中。
```js
var fs = require("fs");

// 创建一个可读流
var readerStream = fs.createReadStream('input.txt');

// 创建一个可写流
var writerStream = fs.createWriteStream('output.txt');

// 管道读写操作
// 读取 input.txt 文件内容，并将内容写入到 output.txt 文件中
readerStream.pipe(writerStream);

console.log("程序执行完毕");
```

### 链式流
链式是通过连接输出流到另外一个流并创建多个流操作链的机制。链式流一般用于管道操作。接下来我们就是用管道和链式来压缩和解压文件。

压缩过程链式流：
```js
var fs = require("fs");
var zlib = require('zlib');

// 压缩 input.txt 文件为 input.txt.gz
fs.createReadStream('input.txt')
  .pipe(zlib.createGzip())
  .pipe(fs.createWriteStream('input.txt.gz'));
  
console.log("文件压缩完成。");
```

解压过程链式流
```js
var fs = require("fs");
var zlib = require('zlib');

// 解压 input.txt.gz 文件为 input.txt
fs.createReadStream('input.txt.gz')
  .pipe(zlib.createGunzip())
  .pipe(fs.createWriteStream('input.txt'));
  
console.log("文件解压完成。");
```
## 2 文件操作

### 文件读取
```js
var fs = require("fs");

// 异步读取
fs.readFile('input.txt', function (err, data) {
   if (err) {
       return console.error(err);
   }
   console.log("异步读取: " + data.toString());
});

// 同步读取
var data = fs.readFileSync('input.txt');
console.log("同步读取: " + data.toString());

console.log("程序执行完毕。");
```

### 打开文件
### 获取文件信息
### 写入文件
### 读取文件
### 关闭文件
### 截取文件
### 删除文件
### 创建目录
### 读取目录
### 删除目录
## 3 fs...
1	fs.rename(oldPath, newPath, callback)
异步 rename().回调函数没有参数，但可能抛出异常。
2	fs.ftruncate(fd, len, callback)
异步 ftruncate().回调函数没有参数，但可能抛出异常。
3	fs.ftruncateSync(fd, len)
同步 ftruncate()
4	fs.truncate(path, len, callback)
异步 truncate().回调函数没有参数，但可能抛出异常。
5	fs.truncateSync(path, len)
同步 truncate()
6	fs.chown(path, uid, gid, callback)
异步 chown().回调函数没有参数，但可能抛出异常。
7	fs.chownSync(path, uid, gid)
同步 chown()
8	fs.fchown(fd, uid, gid, callback)
异步 fchown().回调函数没有参数，但可能抛出异常。
9	fs.fchownSync(fd, uid, gid)
同步 fchown()
10	fs.lchown(path, uid, gid, callback)
异步 lchown().回调函数没有参数，但可能抛出异常。
11	fs.lchownSync(path, uid, gid)
同步 lchown()
12	fs.chmod(path, mode, callback)
异步 chmod().回调函数没有参数，但可能抛出异常。
13	fs.chmodSync(path, mode)
同步 chmod().
14	fs.fchmod(fd, mode, callback)
异步 fchmod().回调函数没有参数，但可能抛出异常。
15	fs.fchmodSync(fd, mode)
同步 fchmod().
16	fs.lchmod(path, mode, callback)
异步 lchmod().回调函数没有参数，但可能抛出异常。Only available on Mac OS X.
17	fs.lchmodSync(path, mode)
同步 lchmod().
18	fs.stat(path, callback)
异步 stat(). 回调函数有两个参数 err, stats，stats 是 fs.Stats 对象。
19	fs.lstat(path, callback)
异步 lstat(). 回调函数有两个参数 err, stats，stats 是 fs.Stats 对象。
20	fs.fstat(fd, callback)
异步 fstat(). 回调函数有两个参数 err, stats，stats 是 fs.Stats 对象。
21	fs.statSync(path)
同步 stat(). 返回 fs.Stats 的实例。
22	fs.lstatSync(path)
同步 lstat(). 返回 fs.Stats 的实例。
23	fs.fstatSync(fd)
同步 fstat(). 返回 fs.Stats 的实例。
24	fs.link(srcpath, dstpath, callback)
异步 link().回调函数没有参数，但可能抛出异常。
25	fs.linkSync(srcpath, dstpath)
同步 link().
26	fs.symlink(srcpath, dstpath[, type], callback)
异步 symlink().回调函数没有参数，但可能抛出异常。 type 参数可以设置为 'dir', 'file', 或 'junction' (默认为 'file') 。
27	fs.symlinkSync(srcpath, dstpath[, type])
同步 symlink().
28	fs.readlink(path, callback)
异步 readlink(). 回调函数有两个参数 err, linkString。
29	fs.realpath(path[, cache], callback)
异步 realpath(). 回调函数有两个参数 err, resolvedPath。
30	fs.realpathSync(path[, cache])
同步 realpath()。返回绝对路径。
31	fs.unlink(path, callback)
异步 unlink().回调函数没有参数，但可能抛出异常。
32	fs.unlinkSync(path)
同步 unlink().
33	fs.rmdir(path, callback)
异步 rmdir().回调函数没有参数，但可能抛出异常。
34	fs.rmdirSync(path)
同步 rmdir().
35	fs.mkdir(path[, mode], callback)
S异步 mkdir(2).回调函数没有参数，但可能抛出异常。 访问权限默认为 0777。
36	fs.mkdirSync(path[, mode])
同步 mkdir().
37	fs.readdir(path, callback)
异步 readdir(3). 读取目录的内容。
38	fs.readdirSync(path)
同步 readdir().返回文件数组列表。
39	fs.close(fd, callback)
异步 close().回调函数没有参数，但可能抛出异常。
40	fs.closeSync(fd)
同步 close().
41	fs.open(path, flags[, mode], callback)
异步打开文件。
42	fs.openSync(path, flags[, mode])
同步 version of fs.open().
43	fs.utimes(path, atime, mtime, callback)
 
44	fs.utimesSync(path, atime, mtime)
修改文件时间戳，文件通过指定的文件路径。
45	fs.futimes(fd, atime, mtime, callback)
 
46	fs.futimesSync(fd, atime, mtime)
修改文件时间戳，通过文件描述符指定。
47	fs.fsync(fd, callback)
异步 fsync.回调函数没有参数，但可能抛出异常。
48	fs.fsyncSync(fd)
同步 fsync.
49	fs.write(fd, buffer, offset, length[, position], callback)
将缓冲区内容写入到通过文件描述符指定的文件。
50	fs.write(fd, data[, position[, encoding]], callback)
通过文件描述符 fd 写入文件内容。
51	fs.writeSync(fd, buffer, offset, length[, position])
同步版的 fs.write()。
52	fs.writeSync(fd, data[, position[, encoding]])
同步版的 fs.write().
53	fs.read(fd, buffer, offset, length, position, callback)
通过文件描述符 fd 读取文件内容。
54	fs.readSync(fd, buffer, offset, length, position)
同步版的 fs.read.
55	fs.readFile(filename[, options], callback)
异步读取文件内容。
56	fs.readFileSync(filename[, options])
57	fs.writeFile(filename, data[, options], callback)
异步写入文件内容。
58	fs.writeFileSync(filename, data[, options])
同步版的 fs.writeFile。
59	fs.appendFile(filename, data[, options], callback)
异步追加文件内容。
60	fs.appendFileSync(filename, data[, options])
The 同步 version of fs.appendFile.
61	fs.watchFile(filename[, options], listener)
查看文件的修改。
62	fs.unwatchFile(filename[, listener])
停止查看 filename 的修改。
63	fs.watch(filename[, options][, listener])
查看 filename 的修改，filename 可以是文件或目录。返回 fs.FSWatcher 对象。
64	fs.exists(path, callback)
检测给定的路径是否存在。
65	fs.existsSync(path)
同步版的 fs.exists.
66	fs.access(path[, mode], callback)
测试指定路径用户权限。
67	fs.accessSync(path[, mode])
同步版的 fs.access。
68	fs.createReadStream(path[, options])
返回ReadStream 对象。
69	fs.createWriteStream(path[, options])
返回 WriteStream 对象。
70	fs.symlink(srcpath, dstpath[, type], callback)
异步 symlink().回调函数没有参数，但可能抛出异常。