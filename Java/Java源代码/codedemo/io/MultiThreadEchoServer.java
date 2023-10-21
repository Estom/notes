package cn.aofeng.demo.io;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 多线程网络echo服务。每接收到一个新连接都新建一个线程处理，连接关闭后线程随之销毁。
 * 
 * @author <a href="mailto:aofengblog@163.com">NieYong</a>
 */
public class MultiThreadEchoServer {

    private final static Logger logger = Logger.getLogger(MultiThreadEchoServer.class.getName());
    
    /**
     * @param args [0]-监听端口
     */
    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("无效的参数。使用示例：");
            System.err.println("    java cn.aofeng.demo.io.MultiThreadEchoServer 9090");
            System.exit(-1);
        }
        
        int port = Integer.parseInt(args[0]);
        ServerSocket serverSocket = null;
        try {
            serverSocket = new ServerSocket();
            serverSocket.bind(new InetSocketAddress(port));
            if (logger.isLoggable(Level.INFO)) {
                logger.info("多线程网络echo服务启动完毕，监听端口：" +port);
            }
            while (true) {
                // 接收新的客户端连接
                Socket socket = serverSocket.accept();
                if (logger.isLoggable(Level.INFO)) {
                    logger.info("收到一个新的连接，客户端IP："+socket.getInetAddress().getHostAddress()+"，客户端Port："+socket.getPort());
                }
                
                // 新建一个线程处理Socket连接
                Thread thread = new Thread(new Worker(socket));
                thread.start();
            }
        } catch (IOException e) {
            logger.log(Level.SEVERE, "处理网络连接出错", e);
        }
    }

}
