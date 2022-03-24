# latex 概念

## 1 tex语言介绍
Tex是一种语言类型。同时其也是一种排版引擎。基本的TeX系统只有300多个元命令 (primitive) ，十分精悍，但是很难读懂。

## tex语言使用流程
> 语言格式.tex ->  编译程序tex/etex/latex -> .dvi -> 排版程序pdfTex/PdfLatex -> .Pdf

## tex语言格式分类

* Plain Tex是一种语言格式。最小宏集
* LaTeX也是一种语言格式。常见宏集合
* ConTeXt：另一种常见的格式。另一种常见宏集合

分别由Tex语言中不同的宏包定义的语言格式

## 2 tex编译排版介绍
### tex语言编译工具

* tex命令是用来编译Plain Tex书写的.tex文件生成.dvi文件程序。
* etex命令是用来编译Plain Tex书写的.tex文件生成.dvi文件程序。
* latex命令用来编译使用LaTeX语言写的.tex文件生成为.dvi文件程序。

### tex语言排版工具

dvipdfmx程序用来对dvi文件进行排版生成pdf文件。

### tex语言编译排版工具

> 用来将tex文件直接编译成pdf文件。自动包括了编译和排版的过程


* PdfTex是用来排版Plain Tex语言格式的dvi文件，生成PDF文档。
* PdfLaTeX是用来排版LaTeX语言格式的dvi文件，生成PDF文档。
* xetex命令用来编译Plain TeX格式写的dvi文件。使用操作系统字符集，支持Unicode字符集。
* xeLatex命令用来编译LaTeX格式写的dvi文件。使用操作系统字符集，支持Unicode字符集。
* LuaTeX：TeX 语言的一个完整的有扩展的实现。LuaTeX支持Unicode、系统字体和内嵌语言扩展，能直接输出PDF格式文件，也可以仍然输出 DVI 格式。
* LuaLaTeX：TeX 语言的一个完整的有扩展的实现。LuaTeX支持Unicode、系统字体和内嵌语言扩展，能直接输出PDF格式文件，也可以仍然输出 DVI 格式。dvi


补充：
* latexmk 是一个集成命令工具，能够自动运行多次xelatex、biblatex等工具，一次运行多次编译。

## 3 tex发行版介绍

一个完整的TeX需要最基本的TeX引擎、格式支持、各种辅助宏包、一些转换程序、GUI、编辑器、文档查看器等等。通过选择不同的组合就构成了不同的发行版。

* TeX Live：支持Linux，Windows，Mac OS
* MiKTeX：只支持Windows
* CTeX：CTeX基于MiKTeX，并加入了中文的支持，只支持Windows。同时CTEX是一个网站，ctex是可以很好支持中文的宏包。