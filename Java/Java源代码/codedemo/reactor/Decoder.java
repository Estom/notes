package cn.aofeng.demo.reactor;

import java.nio.ByteBuffer;

/**
 * 请求数据解析器接口定义。
 * 
 * @author <a href="mailto:aofengblog@163.com">NieYong </a>
 */
public interface Decoder {

    /**
     * 解析请求数据，不影响源数据的状态和内容。
     * 
     * @param source {@link Reader}读取到的源数据字节数组
     * @return 如果解析到符合要求的数据，则返回解析到的数据；否则返回null。
     */
    public Object decode(ByteBuffer source);

}
