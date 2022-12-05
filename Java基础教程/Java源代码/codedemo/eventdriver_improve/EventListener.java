package cn.aofeng.demo.eventdriver_improve;
/**
 * 事件监听器(监听一个或多个事件并进行具体的处理)
 * 
 * @author aofeng <aofengblog@163.com>
 */
public interface EventListener {

	/**
	 * 处理事件
	 * 
	 * @param event    事件
	 */
	public void execute(Event event);

}