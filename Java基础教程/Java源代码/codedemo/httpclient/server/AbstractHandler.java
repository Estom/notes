/**
 * 创建时间：2016-8-18
 */
package cn.aofeng.demo.httpclient.server;

import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.InetSocketAddress;
import java.net.URI;
import java.util.List;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

/**
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public abstract class AbstractHandler implements HttpHandler {

    private static Logger _logger = Logger.getLogger(AbstractHandler.class);
    
    protected String _charset = "utf-8";
    
    public AbstractHandler(String charset) {
        this._charset = charset;
    }
    
    /**
     * 处理请求头。
     */
    public void handleHeader(HttpExchange httpEx) {
        InetSocketAddress remoteAddress = httpEx.getRemoteAddress();
        _logger.info("收到来自"+remoteAddress.getAddress().getHostAddress()+":"+remoteAddress.getPort()+"的请求");
        
        URI rUri = httpEx.getRequestURI();
        _logger.info("请求地址:"+rUri.toString());
        
        String method = httpEx.getRequestMethod();
        _logger.info("请求方法:"+method);
        
        Headers headers = httpEx.getRequestHeaders();
        Set<Entry<String, List<String>>> headerSet = headers.entrySet();
        _logger.info("请求头:");
        for (Entry<String, List<String>> header : headerSet) {
            _logger.info(header.getKey()+":"+header.getValue());
        }
    }
    
    /**
     * 处理响应。
     */
    public void handleResponse(HttpExchange httpEx, String content)
            throws UnsupportedEncodingException, IOException {
        String rc = "冒号后面是收到的请求，原样返回:"+content;
        byte[] temp = rc.getBytes(_charset);
        Headers outHeaders = httpEx.getResponseHeaders();
        outHeaders.set("ABC", "123");
        httpEx.sendResponseHeaders(200, temp.length);
        OutputStream outs = httpEx.getResponseBody();
        outs.write(temp);
        IOUtils.closeQuietly(outs);
    }

}