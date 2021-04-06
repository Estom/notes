# MATLAB Notebook使用简介
> 沟通MATLAB和word等微软软件功能

## &gt; Notebook的安装和启动

***

* **执行安装命令**  
	notebook -setup
* **执行启动命令**
	1. 原理Word调用MATLAB服务器进行操作。
	2. （MATLAB和excel服务器之间也可以相互调用）
	3. 从Word中启动notebook或者从MATLAB中启动MATLAB。

## &gt; M-book中命令的运行

***

* **代码的运行**
	1. 定义输入单元，格式发生变化define input cell
	2. 执行输入单元，evalute，执行已经输入的单元
	3. 作用，就像是直接在word中进行m脚本文件的一些相关操作，当在论文中插入数据处理时用这种方法。
	4. 使用[plot(a,b)]函数能够直接将图片绘制在word文档中
	5. 定义自动初始化单元。define autoInit cell

* **单元组**
	1. 将a和b定义为分别独立的输入单元，而且，其单步执行（就像给word添加了一种图形绘制和数值计算的能力插件）
	2. 定义为输入单元组，能够识别超过一行的命令。group cell。
	3. 输出格式的控制。（notebook options）