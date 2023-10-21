/**
 * 创建时间：2016-8-5
 */
package cn.aofeng.demo.httpclient.server;

import java.io.IOException;
import java.net.InetSocketAddress;

import org.apache.log4j.Logger;

import com.sun.net.httpserver.HttpServer;

/**
 * 简单的HTTP Server。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class SimpleHttpServer {

    private static Logger _logger = Logger.getLogger(SimpleHttpServer.class);
    
    private static String _charset = "utf-8";
    
    /**
     * @param args
     */
    public static void main(String[] args) {
        int port = 8888;
        try {
            HttpServer server = HttpServer.create(new InetSocketAddress(port), 128);
            server.createContext("/get", new CharacterHandler(_charset));
            server.createContext("/post", new CharacterHandler(_charset));
            server.createContext("/file", new BinaryHandler(_charset));
            server.start();
            _logger.info("http server already started, listen port:"+port);
        } catch (IOException e) {
            _logger.error("", e);
        }
    }

}
