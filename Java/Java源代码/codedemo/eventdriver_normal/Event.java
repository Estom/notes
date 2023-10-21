package cn.aofeng.demo.eventdriver_normal;
/**
 * 事件
 * @author aofeng <aofengblog@163.com>
 */
public class Event {

    private Object data;
    
	public Event(Object obj){
	    this.data = obj;
	}

	public Object getData() {
	    return data;
	}
}