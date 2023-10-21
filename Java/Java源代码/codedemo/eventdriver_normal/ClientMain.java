package cn.aofeng.demo.eventdriver_normal;
/**
 * 事件驱动调用示例
 * @author aofeng <aofengblog@163.com>
 */
public class ClientMain {

    public static void main(String[] args) {
        EventSource eventSource = new EventSource();
        eventSource.addListener(new HelloWorldListener());
        eventSource.addListener(new SimpleListener());
        eventSource.fire("hello, world!");
    }

    public static class HelloWorldListener implements EventListener {

        @Override
        public void execute(Event event) {
            System.out.println("监听器:"+this +  "接收到事件，事件附带的数据:" + event.getData());
        }
        
    }
    
    public static class SimpleListener implements EventListener {

        @Override
        public void execute(Event event) {
            System.out.println("监听器:"+this +  "接收到事件，事件附带的数据:" + event.getData());
        }
        
    }

}
