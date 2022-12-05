package cn.aofeng.demo.reactor;

import java.io.IOException;
import java.nio.channels.SocketChannel;

/**
 * 业务逻辑处理。
 * 
 * @author <a href="mailto:aofengblog@163.com">NieYong </a>
 */
public class ProcessService {

    private SocketChannel _clientChannel;
    
    private String _line;
    
    public ProcessService(SocketChannel clientChannel, String line) {
        this._clientChannel = clientChannel;
        this._line = line;
    }
    
    public String execute() {
        // 判断客户端是否发送了退出指令
        String content = _line.substring(0, _line.length()-2);
        if (isCloseClient(content)) {
            try {
                _clientChannel.close();
            } catch (IOException e) {
                // nothing
            }
        }
        
        return _line;
    }
    
    /**
     * 客户端是否发送了退出指令（"quit" | "exit"）。
     * 
     * @param str 收到的客户端数据
     * @return 返回true表示收到了退出指令；否则返回false。
     */
    private boolean isCloseClient(String str) {
        return "exit".equalsIgnoreCase(str) || "quit".equalsIgnoreCase(str);
    }

}
