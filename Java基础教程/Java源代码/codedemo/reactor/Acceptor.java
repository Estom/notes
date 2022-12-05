package cn.aofeng.demo.reactor;

import java.io.IOException;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 负责处理新连入的客户端Socket连接。
 * 
 * @author <a href="mailto:aofengblog@163.com">NieYong </a>
 */
public class Acceptor {

    private final static Logger _logger = Logger.getLogger(Acceptor.class.getName());
    
    protected Selector _selector;
    
    protected ServerSocketChannel _serverChannel;
    
    public Acceptor(Selector selector, ServerSocketChannel serverChannel) {
        this._selector = selector;
        this._serverChannel = serverChannel;
    }
    
    /**
     * 接收一个新连入的客户端Socket连接，交给{@link Reader}处理：{@link Reader}向{@link Selector}注册并关注READ事件。
     * 
     * @throws IOException
     */
    public void accept() throws IOException {
        SocketChannel clientChannel = _serverChannel.accept();
        if (null != clientChannel) {
            if (_logger.isLoggable(Level.INFO)) {
                _logger.info("收到一个新的连接，客户端IP："+clientChannel.socket().getInetAddress().getHostAddress()
                        +"，客户端Port："+clientChannel.socket().getPort());
            }
            clientChannel.configureBlocking(false);
            Reader reader = new Reader(_selector, clientChannel);
            reader.setDecoder(new LineDecoder());
            clientChannel.register(_selector, SelectionKey.OP_READ, reader);
        }
    }

}
