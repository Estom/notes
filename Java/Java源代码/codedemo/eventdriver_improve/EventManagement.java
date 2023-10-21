package cn.aofeng.demo.eventdriver_improve;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 事件管理器。负责
 * 
 * @author aofeng <aofengblog@163.com>
 */
public class EventManagement {

    private Map<String, List<EventListener>> map = new HashMap<String, List<EventListener>>();
    
	public EventManagement(){

	}

	/**
	 * 向指定事件添加一个监听器
	 * 
	 * @param eventType 事件类型
	 * @param listener 事件监听器
	 * @return 添加成功返回true；添加失败返回false
	 */
	public boolean addListener(String eventType, EventListener listener){
	    List<EventListener> listeners = map.get(eventType);
	    if (null == listeners) {
	        listeners = new ArrayList<EventListener>();
        }
	    boolean result = listeners.add(listener);
	    map.put(eventType, listeners);
	    
		return result;
	}

	/**
	 * 移除事件的某一个监听器
	 * 
	 * @param eventType 事件类型
     * @param listener 事件监听器
     * @return 移除成功返回true；移除失败返回false
	 */
	public boolean removeListener(String eventType, EventListener listener){
	    List<EventListener> listeners = map.get(eventType);
        if (null != listeners) {
            return listeners.remove(listener);
        }
        
		return false;
	}

	/**
	 * 获取指定事件的监听器
	 * 
	 * @param eventType 事件类型
	 * @return 如果指定的事件没有监听器返回null；否则返回监听器列表
	 */
	public List<EventListener> getEventListeners(String eventType) {
	    return map.get(eventType);
	}

}