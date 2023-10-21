package cn.aofeng.demo.eventdriver_improve;
/**
 * 事件驱动调用示例
 * @author 聂勇 <a href="mailto:aofengblog@163.com">aofengblog@163.com</a>
 */
public class ClientMain {

    public static void main(String[] args) {
        EventManagement eventManagement = new EventManagement();
        eventManagement.addListener("read", new HelloWorldListener());
        eventManagement.addListener("write", new SimpleListener());
        
        EventSource eventSource = new EventSource(eventManagement);
        eventSource.fire(new Event("read", "this is a read event"));
        eventSource.fire(new Event("write", "this is a write event"));
    }

    public static class HelloWorldListener implements EventListener {

        @Override
        public void execute(Event event) {
            System.out.println("监听器:"+this +  "接收到事件，事件类型是:" 
                    + event.getEventType() + ", 事件附带的数据:" + event.getData());
        }
        
    }
    
    public static class SimpleListener implements EventListener {

        @Override
        public void execute(Event event) {
            System.out.println("监听器:"+this +  "接收到事件，事件类型是:" 
                    + event.getEventType() + ", 事件附带的数据:" + event.getData());
        }
        
    }

}
