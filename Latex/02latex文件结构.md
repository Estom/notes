# latex文件结构

```
\documentclass{article}
\title{hello}
\author{estom}
\usepackage{ctex}
\newcommad\degree{^\circ}
\begin{document}

\maketitle

\section{hello}
hello world殷康龙
\end{document}
```

## 具体结构

### 导言区
* 用来声明文档类型\documentclass{article}
* 文档的基础信息\title{hello}
* 导入的宏包\usepackage{ctex}
* 定义新的latex命令\newcommad\degree{^\circ}


### 正文区

* 用来完成文档主体。\begin{document}
* 能够设置不同的环境\begin{equation}

> 不同的环境下能够编写不同形式的命令。



## 设置中文文档

* 使用\usepackage{ctex}宏包
* 使用ctex提供的\documentclass{ctexarticle}文档类
* 然后使用xelatex命令进行编译。

> ctex宏包主要提供中文字体的排版。xelatex命令主要实现utf8字体的编译。


## 查看帮助手册
* texdoc ctex可以查看帮助手册。
* texdoc lshot-zh可以查看一个简单的教程

