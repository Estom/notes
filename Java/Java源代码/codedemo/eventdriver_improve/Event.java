package cn.aofeng.demo.eventdriver_improve;
/**
 * 事件
 * 
 * @author aofeng <aofengblog@163.com>
 */
public class Event {

    // 事件附带的数据
    private Object data;
    
    // 事件类型
    private String eventType;
    
    public Event(String eventType, Object obj){
        this.eventType = eventType;
        this.data = obj;
    }

    public Object getData() {
        return this.data;
    }
    
    public String getEventType() {
        return this.eventType;
    }

}