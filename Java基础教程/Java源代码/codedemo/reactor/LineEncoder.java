package cn.aofeng.demo.reactor;

import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 将字符串转换成{@link ByteBuffer}并加上行结束符。
 * 
 * @author <a href="mailto:aofengblog@163.com">NieYong </a>
 */
public class LineEncoder implements Encoder {

    private final static Logger logger = Logger.getLogger(LineEncoder.class.getName());
    
    @Override
    public ByteBuffer encode(Object source) {
        String line = (String) source;
        try {
            ByteBuffer buffer = ByteBuffer.wrap(line.getBytes(Constant.CHARSET_UTF8));
            
            return buffer;
        } catch (UnsupportedEncodingException e) {
            logger.log(Level.SEVERE, "将响应数据转换成ByteBuffer出错", e);
        }
        
        return null;
    }

}
