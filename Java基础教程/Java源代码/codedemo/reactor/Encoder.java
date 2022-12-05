package cn.aofeng.demo.reactor;

import java.nio.ByteBuffer;

/**
 * 响应数据封装接口定义。
 * 
 * @author <a href="mailto:aofengblog@163.com">NieYong </a>
 */
public interface Encoder {

    /**
     * 将源数据转换成{@link ByteBuffer}。
     * 
     * @param source 源数据
     * @return {@link ByteBuffer}对象。
     */
    public ByteBuffer encode(Object source);

}
