# MATLAB二维底层绘图的修饰

## &gt; 对象和句柄
> *似乎MATLAB也能满足面向对象编程的一些条件诶！  
> MATLAB也能实现GUI图形用户界面编程，同强大的C++、Java有一拼*

***

* **对象和句柄的概念**
	1. MATLAB吧构成图形的各个基本要素成为图形对象，产生每一个图形对象时，MATLAB会自动分配一个唯一的值，用于表示这个对象，成为句柄（好像子对象和指向对象的指针）

* **对象间的基本关系**
	1. 计算机屏幕->图形窗口->（用户菜单，用户控件，坐标轴）
	2. 坐标轴->（曲线，曲面，文字，图像，光源，区域，方框）

## &gt; 基本地城绘图函数

***

* **line对象**
	1. ` h = line([-pi:0.01:pi],sin([-pi:0.01:pi]));`
	2. 其中h成为line曲线对象的句柄。
	3. line对象的修饰
		* color属性
		* LineWidth属性
		* LineStyle属性
		* Marker属性
		* MarkerSize属性
	4. plot函数能够产生line对象，然后继续对返回的句柄进行操作、或者直接在绘制过程进行修饰。
	5.	``` h1 = line('XData',[-pi:0.01:pi],'YData',sin([-pi:0.01:pi]),'LineWidth',1,'LineStyle',':','Color','r'); ```
	6.	 
* **set底层对象的属性设置函数**  
	1. 可以通过生成的句柄对MATLAB中生成的操作对象进行。使用set函数进行设定。` set(h1,'LineWidth',2,'Marker','p','MarkSize','15') ` 
	2. line对象常见的性质XData,YData,ZData,Color(y,m,c,r,g,b,w,k),DisplayName(legend	()),LineStyle(-,--,:,-.,none),LineWidth,Marker(+,o,*,.,X,s,d,'^',V,>,<,p,h,none)。MarkerEdgeColor,MarkerFaceColor,MarkerSize,Type。               
* **text对象，底层标注函数**  
	1. text是一个line的子对象，可以使用text函数进行操作。
	2. ht = text(0,4,'string')
	3. text对象相关的属性：Color，FontSize，String，Rotation。
* **axes对象，底层坐标轴函数**
	1. axes是一个line/figure的对象，可以使用axes（）函数进行操作
	2. ``` hf = figure;
ha = axes('Parent',hf,'Position','Units','Pixels',[10,10,10,100]);```
	3. 常见属性：Box,GridLineStyle,Position,Units,XLabel,Ylabel,ZLabel,Xlim,Ylim,Zlim相关属性。
> 补充一点对MATLAB的认识：  
> MATLAB是矩阵实验室（Matrix　Laboratory）之意。其主要提供了以下几种功能  
> 1. 数值计算  
> 2. 符号计算  
> 3. 文字处理  
> 4. 可视化建模仿真（图形功能强大）  
> 5. 实时控制等功能（自动控制理论应用）  
> MATLAB除了内部函数主包，还有三十多种工具包，用于不同领域，不同需求的功能拓展。
