package cn.aofeng.demo.reactor;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;

/**
 * 负责向客户端发送响应数据。
 * 
 * @author <a href="mailto:aofengblog@163.com">NieYong </a>
 */
public class Writer {

    private SocketChannel _clientChannel;
    
    private Object _data;
    
    private Encoder _encoder;
    
    public Writer(SocketChannel clientChannel, Object data) {
        this._clientChannel = clientChannel;
        this._data = data;
    }
    
    public void setEncoder(Encoder encoder) {
        this._encoder = encoder;
    }
    
    public void write() throws IOException {
        if (null == _data || !_clientChannel.isOpen()) {
            return;
        }
        
        ByteBuffer buffer = _encoder.encode(_data);
        if (null == buffer) {
            return;
        }
        _clientChannel.write(buffer);
    }

}
