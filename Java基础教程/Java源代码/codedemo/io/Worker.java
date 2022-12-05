package cn.aofeng.demo.io;

import java.io.BufferedReader;
import java.io.Closeable;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 处理客户端Socket连接的工作线程。
 * 
 * @author 聂勇 <a href="mailto:aofengblog@163.com">aofengblog@163.com</a>
 */
public class Worker implements Runnable {

    private final static Logger logger = Logger.getLogger(MultiThreadEchoServer.class.getName());
    
    // 字符集编码
    private final static String CHAR_SET = "utf8"; 
    
    // 行结束符
    private final static String CRLF = "\r\n";
    
    private Socket socket = null;
    
    public Worker(Socket socket) {
        this.socket = socket;
    }
    
    public void setSocket(Socket socket) {
        this.socket = socket;
    }
    
    public void close(Closeable c) {
        if (null != c) {
            try {
                c.close();
            } catch (IOException e) {
                // ingore
            }
        }
    }
    
    @Override
    public void run() {
        if (null == socket || socket.isClosed()) {
            logger.warning("无效的Socket连接：" + socket);
            return;
        }
        
        String lineEnd = CRLF;
        try {
            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(
                            socket.getInputStream()));
            OutputStream outs = socket.getOutputStream(); 
            String line = null;
            while ( null != (line = reader.readLine()) ) {
                // 客户端退出
                if ("quit".equalsIgnoreCase(line) || "exit".equalsIgnoreCase(line)) {
                    break;
                }
                
                outs.write(line.getBytes(CHAR_SET));
                outs.write(lineEnd.getBytes(CHAR_SET));
            }
            close(reader);
            close(outs);
        } catch (IOException e) {
            logger.log(Level.SEVERE, "读取网络连接数据出错", e);
        }
    }
    
}