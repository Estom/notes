package cn.aofeng.demo.jetty;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.commons.io.IOUtils;

/**
 * 抓取页面内容。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class HttpGet {

    public String getSomeThing(String urlStr) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection urlConn = (HttpURLConnection) url.openConnection();
        urlConn.setConnectTimeout(3000);
        urlConn.setRequestMethod("GET");
        urlConn.connect();
        
        InputStream ins = null;
        try {
            if (200 == urlConn.getResponseCode()) {
                ins = urlConn.getInputStream();
                ByteArrayOutputStream outs = new ByteArrayOutputStream(1024);
                IOUtils.copy(ins, outs);
                return outs.toString("UTF-8");
            }
        } catch (IOException e) {
            throw e;
        } finally {
            IOUtils.closeQuietly(ins);
        }
        
        return null;
    }

}
