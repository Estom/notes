package cn.aofeng.demo.reactor;

import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 行数据解析器。
 * 
 * @author <a href="mailto:aofengblog@163.com">NieYong </a>
 */
public class LineDecoder implements Decoder {

    private final static Logger _logger = Logger.getLogger(LineDecoder.class.getName());
    
    /**
     * 从字节缓冲区中获取"一行"。
     * 
     * @param buffer 输入缓冲区
     * @return 有遇到行结束符，返回不包括行结束符的字符串；否则返回null。
     */
    @Override
    public String decode(ByteBuffer source) {
        int index = 0;
        boolean findCR = false;
        int len = source.limit();
        byte[] bytes = source.array();
        while(index < len) {
            index ++;
            
            byte temp = bytes[index-1];
            if (Constant.CR == temp) {
                findCR = true;
            }
            if (Constant.LF == temp && findCR) { // 找到了行结束符
                byte[] copy = new byte[index];
                System.arraycopy(bytes, 0, copy, 0, index);
                try {
                    return new String(copy, Constant.CHARSET_UTF8);
                } catch (UnsupportedEncodingException e) {
                    _logger.log(Level.SEVERE, "将解析完成的请求数据转换成字符串出错", e);
                }
            }
        }
        
        return null;
    }

}
