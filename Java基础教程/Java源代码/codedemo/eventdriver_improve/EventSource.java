package cn.aofeng.demo.eventdriver_improve;
import java.util.List;

/**
 * 事件源(事件发送者)
 * 
 * @author aofeng <aofengblog@163.com>
 */
public class EventSource {

    // 事件管理器
    private EventManagement eventManagement;;
    
	public EventSource(EventManagement eventManagement){
	    this.eventManagement = eventManagement;
	}

	/**
     * 派发事件
     * 
     * @param data 事件
     */
    public void fire(Event event) {
        if (null == event) {
            return;
        }
        
        List<EventListener> listeners = eventManagement.getEventListeners(event.getEventType());
        if (null == listeners) {
            return;
        }
        
        for (EventListener listener : listeners) {
            listener.execute(event);
        }
    }

}