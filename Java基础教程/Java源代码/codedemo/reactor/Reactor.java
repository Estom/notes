package cn.aofeng.demo.reactor;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.util.Iterator;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 负责Echo Server启动和停止 ，ACCEPT和READ事件的分派。
 * 
 * @author <a href="mailto:aofengblog@163.com">NieYong </a>
 */
public class Reactor {
    
    private final static Logger logger = Logger.getLogger(Reactor.class.getName());
    
    // 监听端口
    private int _port;
    
    // {@link Selector}检查通道就绪状态的超时时间（单位：毫秒）
    private int _selectTimeout = 3000;
    
    // 服务运行状态
    private volatile boolean _isRun = true;
    
    /**
     * @param port 服务监听端口。
     */
    public Reactor(int port) {
        this._port = port;
    }
    
    public void setSelectTimeout(int selectTimeout) {
        this._selectTimeout = selectTimeout;
    }
    
    /**
     * 启动服务。
     */
    public void start() {
        ServerSocketChannel serverChannel = null;
        try {
            serverChannel = ServerSocketChannel.open();
            serverChannel.configureBlocking(false);
            ServerSocket serverSocket = serverChannel.socket();
            serverSocket.bind(new InetSocketAddress(_port));
            _isRun = true;
            if (logger.isLoggable(Level.INFO)) {
                logger.info("NIO echo网络服务启动完毕，监听端口：" +_port);
            }
            
            Selector selector = Selector.open();
            serverChannel.register(selector, SelectionKey.OP_ACCEPT, new Acceptor(selector, serverChannel));
            
            while (_isRun) {
                int selectNum = selector.select(_selectTimeout);
                if (0 == selectNum) {
                    continue;
                }
                
                Set<SelectionKey> selectionKeys = selector.selectedKeys();
                Iterator<SelectionKey> it = selectionKeys.iterator();
                while (it.hasNext()) {
                    SelectionKey selectionKey = (SelectionKey) it.next();
                    
                    // 接受新的Socket连接
                    if (selectionKey.isValid() && selectionKey.isAcceptable()) {
                         Acceptor acceptor = (Acceptor) selectionKey.attachment();
                         acceptor.accept();
                    }
                    
                    // 读取并处理Socket的数据
                    if (selectionKey.isValid() && selectionKey.isReadable()) {
                        Reader reader = (Reader) selectionKey.attachment();
                        reader.read();
                    }
                    
                    // 移除已经处理过的Key
                    it.remove();
                } // end of while iterator
            }
        } catch (IOException e) {
            logger.log(Level.SEVERE, "处理网络连接出错", e);
        }
    }
    
    /**
     * 停止服务。
     */
    public void stop() {
        _isRun = false;
    }
    
    public static void main(String[] args) {
        if (1 != args.length) {
            logger.severe("无效参数。使用示例：\n    java cn.aofeng.demo.reactor.Reactor 9090");
            System.exit(-1);
        }
        int port = Integer.parseInt(args[0]);
        int selectTimeout = 1000;
        
        Reactor reactor = new Reactor(port);
        reactor.setSelectTimeout(selectTimeout);
        reactor.start();
    }

}
