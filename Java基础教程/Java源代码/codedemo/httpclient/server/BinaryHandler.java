/**
 * 创建时间：2016-8-18
 */
package cn.aofeng.demo.httpclient.server;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

/**
 * 二进制处理器。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class BinaryHandler extends AbstractHandler implements HttpHandler {

    private static Logger _logger = Logger.getLogger(BinaryHandler.class);
    
    private String _dir = "/home/nieyong/temp/JavaTutorial";
    
    public BinaryHandler(String charset) {
        super(charset);
    }
    
    @Override
    public void handle(HttpExchange httpEx) throws IOException {
        super.handleHeader(httpEx);
        handleRequest(httpEx);
        String content = "收到一个二进制的请求";
        super.handleResponse(httpEx, content);
    }
    
    /**
     * 处理请求。
     * @throws IOException 
     */
    public String handleRequest(HttpExchange httpEx) throws IOException {
        OutputStream outs = null;
        InputStream ins = null;
        try {
            File file = new File(_dir, ""+System.currentTimeMillis());
            if (!file.exists()) {
                file.createNewFile();
            }
            outs = new FileOutputStream(file);
            ins = httpEx.getRequestBody();
            IOUtils.copyLarge(ins, outs);
        } catch (Exception e) {
            _logger.error("read request or write file occurs error", e);
        } finally {
            IOUtils.closeQuietly(ins);
            IOUtils.closeQuietly(outs);
        }
        
        return null;
    }

}
