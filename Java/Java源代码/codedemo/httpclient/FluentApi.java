/**
 * 创建时间：2016-8-5
 */
package cn.aofeng.demo.httpclient;

import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Request;
import org.apache.http.client.fluent.Response;
import org.apache.http.message.BasicNameValuePair;
import org.apache.log4j.Logger;

import cn.aofeng.demo.httpclient.server.SimpleHttpServer;

/**
 * 使用Fluent API快速地进行简单的HTTP的请求和响应处理，启动{@link SimpleHttpServer}作为请求的服务端。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class FluentApi {

    private static Logger _logger = Logger.getLogger(FluentApi.class);
    
    private static String _targetHost = "http://127.0.0.1:8888";
    
    private static String _charset = "utf-8";
    
    /**
     * HTTP GET请求，关闭Keep-Alive。
     * 
     * @param targetUrl 请求的地址
     * @param charset 将响应流转换成字符串时使用的编码
     */
    public static void get(String targetUrl, String charset) {
        Response response = null;
        try {
            response =  Request.Get(targetUrl).setHeader("Connection", "close").execute();
            String content = response.returnContent().asString(Charset.forName(charset));
            _logger.info(content);
        } catch (ClientProtocolException e) {
            _logger.error("协议问题", e);
        } catch (IOException e) {
            _logger.error("连接服务器或读取响应出错", e);
        }
    }
    
    /**
     * HTTP POST请求，默认开启Keep-Alive，表单数据使用utf-8编码。
     * 
     * @param targetUrl 请求的地址
     * @param charset 请求表单内容处理和将响应流转换成字符串时使用的编码
     */
    public static void post(String targetUrl, String charset) {
        List<NameValuePair> form = new ArrayList<NameValuePair>();
        form.add(new BasicNameValuePair("hello", "喂"));
        form.add(new BasicNameValuePair("gogogo", "走走走"));
        
        Response response = null;
        try {
            response = Request.Post(targetUrl)
                    .bodyForm(form, Charset.forName(charset))
                    .execute();
            String content = response.returnContent().asString(Charset.forName(charset));
            _logger.info(content);
        } catch (ClientProtocolException e) {
            _logger.error("协议问题", e);
        } catch (IOException e) {
            _logger.error("连接服务器或读取响应出错", e);
        }
    }
    
    /**
     * @param args
     */
    public static void main(String[] args) {
        get(_targetHost+"/get", _charset);
        post(_targetHost+"/post", _charset);
    }

}
