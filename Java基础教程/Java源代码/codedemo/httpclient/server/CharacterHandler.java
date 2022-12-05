/**
 * 创建时间：2016-8-18
 */
package cn.aofeng.demo.httpclient.server;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

/**
 * 字符串处理器。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class CharacterHandler extends AbstractHandler implements HttpHandler {

    static Logger _logger = Logger .getLogger(CharacterHandler.class);

    public CharacterHandler(String charset) {
        super(charset);
    }
    
    @Override
    public void handle(HttpExchange httpEx) throws IOException {
        super.handleHeader(httpEx);
        String content = handleRequest(httpEx);
        super.handleResponse(httpEx, content);
    }
    
    /**
     * 处理请求。
     */
    public String handleRequest(HttpExchange httpEx)
            throws UnsupportedEncodingException, IOException {
        InputStream ins = httpEx.getRequestBody();
        String content = URLDecoder.decode(
                IOUtils.toString(ins, _charset), _charset);
        _logger.info("请求内容:"+content);
        IOUtils.closeQuietly(ins);
        return content;
    }

}
