# 画图的标准步骤

------  

    package painting;
	
	import java.awt.Frame;
	import java.awt.Graphics;
	
	/**
	 * 画图过程的整体框架.
	 * 继承了Frame类能够使用相关的框体数据。
	 * 实现了Rnnable接口，本类能够作为一个线程被执行。
	 * @author 宙斯
	 * 
	 */
	public class framePaint extends Frame implements Runnable{
	public static void main(String [] args){
		framePaint workStart = new framePaint();
	}
	
	/**
	 * 无参构造函数.
	 * 设置了窗体的基本属性。
	 * 创建了与本类相关的线程并且执行。
	 * 也就是说，这个类的对象在创建的时候，就已经执行了相关的画图代码，并且产生了一个看见的图形对象。
	 * 而且这个绘制的过程，会作为一个普通的线程被执行。
	 */
	public framePaint(){
		super("framePaint");
		setSize(350,350);
		setVisible(true);
	
		new Thread(this).start();
	}
	
	/**
	 * 实现多线程的方法.
	 * run方法时Runnable线程的主要方法，当线程开始是，执行这个方法，所以画图方法在这个线程方法中被调用
	 * 这个方法相当于画图过程的总方法。
	 * @see java.lang.Runnable#run()
	 */
	public void run(){
		
		repaint();
	}
	
	/**
	 * 实现画图的过程.
	 * 主要的画图方法，在调用画图对象的repaint方法时，这个方法被自动加载。
	 * @see java.awt.Window#paint(java.awt.Graphics)
	 */
	public void paint(Graphics g){
		
	}
	}

# Graphics类中的主要方法

-----

> 能绘制的图形：  
> String 字符串  
> Line 直线  
> Rect 长方形  
> Oval  椭圆形
> Arc 弧线  
> Polygon 多边形  
> 

* draw系列  
	绘制线条图形
* fill系列  
	绘制平面图形，用前景色填充内容物
* clearRect()  
	清除指定区域内的图形
* clipRect()  
	截取制定区域内的图形
* copyArea()  
	赋值制定区域内的图形到指定区域
* get/setColor/Font  
	设置颜色字体等
* setClip()  
	截取制定形状内的图形