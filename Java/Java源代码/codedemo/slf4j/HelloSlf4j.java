package cn.aofeng.demo.slf4j;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * slf4j使用示例。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class HelloSlf4j {

    private static Logger _logger = LoggerFactory.getLogger(HelloSlf4j.class);

    public static void main(String[] args) {
        // 直接输出字符串
        _logger.info("Hello, slf4j logger.");
        
        // 输出格式字符串（携带多个填充参数）
        _logger.info("{} + {} = {}", 1, 2, (1+2));
        
        // 输出错误信息和异常堆栈
        _logger.error("错误信息", new IOException("测试抛出IO异常信息"));
        
        // 输出错误信息（携带多个填充参数）和异常堆栈
        _logger.error("两个参数。agrs1:{};agrs2:{}的info级别日志", "args1", "args2", new IOException("测试抛出IO异常信息"));
    }

}
