## 新的事件监听机制

-----

* 之前是定义一个组件对象（事件源），队组建对象绑定一个监听器对象，在监听器对象中有监听同一事件不同动作的函数，函数内部对事件进行处理。从监听器的角度对事件和动作进行处理。
* 现在是直接将静态事件绑定到事件源上，通过process函数运行运行事件发生时的处理方式。而且这些静态事件是已经存在于awtEvent类中的。

```  

	package EventHandle;

	import java.awt.*;
	import java.awt.event.ComponentEvent;
	import java.awt.event.MouseEvent;
	import java.awt.event.WindowEvent;
	
	/**
	 * @author 宙斯  
	 * 准确的说这并不是先前的事件监听机制吧。它不存在指明的监听器。  
	 * 应该更像一种组件自带的事件匹配功能。  
	 * 具体步骤：  
	 * 	打开某一类型的事件匹配功能。  
	 * 	使用process函数运行某个事件  
	 * 	当事件发生时通过事件的ID匹配具体的动作。  
	 * 	匹配后设置相应的处理方式。  
	 */  

	public class baseEvent extends Frame{
	private int x = 0,y = 0,flag = 0;
	private Image img;
	private int dx = 0,dy = 0;

	public static void main(String[] args) {
		baseEvent bE = new baseEvent();
	}
	public baseEvent(){
		super();
		setSize(500,500);
		this.setVisible(true);
		
		Toolkit tk = Toolkit.getDefaultToolkit();
		img = tk.getImage("first.png");
		
		//相当于添加了对Component事件的监听器，似乎监听器类在底层已经直接绑定。
		enableEvents(AWTEvent.COMPONENT_EVENT_MASK);
		enableEvents(AWTEvent.WINDOW_EVENT_MASK);
		enableEvents(AWTEvent.MOUSE_EVENT_MASK);
		
		repaint();
		
	}
	
	//直接调用底层的事件处理函数
	public void processComponentEvent(ComponentEvent e){
		if(e.getID() == ComponentEvent.COMPONENT_MOVED){
			System.out.println(e.getSource());
			System.out.println(e.getID());
			
		}
	}
	
	public void processWindowEvent(WindowEvent e){
		if(e.getID() == WindowEvent.WINDOW_CLOSING){
			System.exit(0);
		}
	}
	/*	
	public void processMouseEvent(MouseEvent e){
		if(e.getID() == MouseEvent.MOUSE_PRESSED){
			System.out.println("pressed");
			if((e.getX()>= x)&&(e.getX()<=x+100)&&(e.getY()>=y)&&(e.getY()<=y+100)){
				flag = 1;
				System.out.println(e.getX()+"..."+e.getY());

			}
		}
		if((e.getID()==MouseEvent.MOUSE_RELEASED)&&(flag == 1)){
			x = e.getX();
			y = e.getY();
			repaint();
			flag = 0;
		}
	}
	*/
	public void processMouseEvent(MouseEvent e){
		if(e.getID() == MouseEvent.MOUSE_PRESSED){
			System.out.println("pressed");
			if((e.getX()>= x)&&(e.getX()<=x+100)&&(e.getY()>=y)&&(e.getY()<=y+100)){
				dx = e.getX()-x;
				dy = e.getY()-y;
				flag = 1;
				System.out.println(e.getX()+"..."+e.getY());

			}
		}
		if(e.getID()== MouseEvent.MOUSE_MOVED&&flag ==1){
			x = e.getX()-dx;
			y = e.getY()-dy;
			System.out.println(e.getX()+"..."+e.getY());

			repaint();

		}
		if((e.getID()==MouseEvent.MOUSE_RELEASED)&&(flag == 1)){
			flag = 0;
		}

	}
	public void paint(Graphics g){
		g.drawImage(img, x, y,100,100, this);
	}
	

}


```