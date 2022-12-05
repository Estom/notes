package cn.aofeng.demo.eventdriver_normal;
import java.util.ArrayList;
import java.util.List;

/**
 * 事件源(事件发送者)
 * 
 * @author aofeng <aofengblog@163.com>
 */
public class EventSource {

    private List<EventListener> listeners = new ArrayList<EventListener>();
    
    public EventSource() {

    }

    /**
     * 添加事件监听器
     * 
     * @param listener 事件监听器
     */
    public boolean addListener(EventListener listener) {
        return listeners.add(listener);
    }

    /**
     * 移除事件监听器
     * 
     * @param listener 移除事件监听器
     */
    public boolean removeListener(EventListener listener) {
        return listeners.remove(listener);
    }

    /**
     * 派发事件
     * 
     * @param data 事件
     */
    public void fire(Object data) {
        for (EventListener listener : listeners) {
            listener.execute(new Event(data));
        }
    }

}