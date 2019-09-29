# latex字体设置

## 字体属性

### 字体编码

* 正文字体编码
* 数学字体编码


### 字体族

* 罗马字体
* 无衬线字体
* 打字机字体

字体族命令，作用于参数。
\textrm{罗马字体} \textsf{无衬线字体} \texttt{打字机字体}

字体族声明，作用于后续文本
\rmfamliy \sffamily \ttfamily
hello world

可以使用大括号进行分组，限定字体声明的范围。

### 字体系列

* 粗细\textmd{Medium series} \mdseries
* 宽度\textbf{boldface series}  \bfseries

 



### 字体形状

* 直立\textup{} \upshape
* 斜体\textit{} \itshape
* 伪斜体\textsl{} \slshape
* 小型大写\textsc{} \sctext

### 字体类型
> 中文字体设置在ctex宏包当中。

* 宋体\songti{}
* 黑体\heiti{}
* 仿宋\fangsong{}
* 楷书\kaishu{}


### 字体大小
> 基于文档类型的normalsize大小设置\document[12pt]{article},对于英文字体的normalsize只有10,11,12pt。字体大小由一系列声明（无参数命令）控制。

* \tiny
* \scriptsize
* \footnotesize
* \small
* \normalsize
* \large
* \Large
* \LARGE
* \huge
* \Huge

* ctex红包提供了中文字体大小设置基础字体大小。\zihao{5}或者\zihao{-4}表示基础字体为五号或者小四。

> 尽量使用\newcommand命令完成新命令的定义。




## 命令类型

* 有参数命令\usepackage{ctex}
* 无参数命令\rmfamily
* 环境命令：\begin \end成对出现，在不同环境下有不同的latex命令。