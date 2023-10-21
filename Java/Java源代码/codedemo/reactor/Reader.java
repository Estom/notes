package cn.aofeng.demo.reactor;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Selector;
import java.nio.channels.SocketChannel;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 负责读取客户端的请求数据并解析。
 * 
 * @author <a href="mailto:aofengblog@163.com">NieYong </a>
 */
public class Reader {

    private final static Logger _logger = Logger.getLogger(Reader.class.getName());
    
    private SocketChannel _clientChannel;
    
    private Decoder _decoder;
    
    private final static int BUFFER_SIZE = 512;
    
    private ByteBuffer _buffer = ByteBuffer.allocate(BUFFER_SIZE);
    
    public Reader(Selector selector, SocketChannel clientChannel) {
        this._clientChannel = clientChannel;
    }
    
    public void setDecoder(Decoder decoder) {
        this._decoder = decoder;
    }
    
    public void read() throws IOException {
        int readCount = _clientChannel.read(_buffer);
        if (-1 == readCount) {
            _clientChannel.close();
        }
        
        _buffer.flip();
        int oldLimit = _buffer.limit();
        String line = null;
        while( (line = (String) _decoder.decode(_buffer)) != null ) { // 处理一次多行发送过来的情况
            if (_logger.isLoggable(Level.FINE)) {
                _logger.fine("收到的数据："+line);
            }
            
            // 处理业务逻辑
            ProcessService service= new ProcessService(_clientChannel, line);
            String result = service.execute();
            
            // 发送响应
            Writer writer = new Writer(_clientChannel, result);
            writer.setEncoder(new LineEncoder());
            writer.write();
            
            // 重建临时数据缓冲区
            rebuildBuffer(line.length());
        }
        
        // 缓冲区数据还没有符合一个decode数据的条件，重置数据缓冲区的状态方便append数据
        if (oldLimit  == _buffer.limit()) {
            resetBuffer();
        }
    }
    
    private void resetBuffer() {
        _buffer.position(_buffer.limit());
        _buffer.limit(_buffer.capacity());
    }

    /**
     * 重建临时数据缓冲区。
     * 
     * @param lineSize 收到的一行数据（不包括行结束符）的长度 
     */
    private void rebuildBuffer(int lineSize) {
        if (_buffer.limit() == lineSize) {
            // 数据刚好是一行
            _buffer = ByteBuffer.allocate(BUFFER_SIZE);
        } else if (_buffer.limit() > lineSize) {
            // 数据多于一行
            byte[] temp = new byte[_buffer.limit() - lineSize];
            System.arraycopy(_buffer.array(), lineSize, temp, 0, temp.length);
            _buffer = ByteBuffer.allocate(BUFFER_SIZE);
            _buffer.put(temp);
            _buffer.flip();
        } else {
            // nothing
        }
    }

}
