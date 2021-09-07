# Introduction

本书由很多的libuv教程组成，libuv是一个高性能的，事件驱动的I/O库，并且提供了跨平台（如windows, linux）的API。  

本书会涵盖libuv的主要部分，但是不会详细地讲解每一个函数和数据结构。[官方文档](http://docs.libuv.org/en/v1.x/)中可以查阅到完整的内容。  

本书依然在不断完善中，所以有些章节会不完整，但我希望你能喜欢它。  

## Who this book is for

如果你正在读此书，你或许是：  

>1. 系统程序员，会编写一些底层的程序，例如守护进程或者网络服务器／客户端。你也许发现了event-loop很适合于你的应用场景，然后你决定使用libuv。  
>2. 一个node.js的模块开发人员，决定使用C/C++封装系统平台某些同步或者异步API，并将其暴露给Javascript。你可以在node.js中只使用libuv。但你也需要参考其他资源，因为本书并没有包括v8/node.js相关的内容。  

本书假设你对c语言有一定的了解。  

## Background

[node.js](https://nodejs.org/en/)最初开始于2009年，是一个可以让Javascript代码离开浏览器的执行环境也可以执行的项目。 node.js使用了Google的V8解析引擎和Marc Lehmann的libev。Node.js将事件驱动的I/O模型与适合该模型的编程语言(Javascript)融合在了一起。随着node.js的日益流行，node.js需要同时支持windows, 但是libev只能在Unix环境下运行。Windows 平台上与kqueue(FreeBSD)或者(e)poll(Linux)等内核事件通知相应的机制是IOCP。libuv提供了一个跨平台的抽象，由平台决定使用libev或IOCP。在node-v0.9.0版本中，libuv移除了libev的内容。  

随着libuv的日益成熟，它成为了拥有卓越性能的系统编程库。除了node.js以外，包括Mozilla的[Rust](http://rust-lang.org)编程语言，和许多的语言都开始使用libuv。  

本书基于libuv的v1.3.0。  

## Code

本书中的实例代码都可以在[Github](https://github.com/nikhilm/uvbook/tree/master/code)上找到。
