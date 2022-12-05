/**
 * 创建时间：2016-2-23
 */
package cn.aofeng.demo.httpclient;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.FileEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

/**
 * HttpClient的基本操作。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class HttpClientBasic {

    private static Logger _logger = Logger.getLogger(HttpClientBasic.class);
    
    private static String _targetHost = "http://127.0.0.1:8888";
    
    private static String _charset = "utf-8";
    
    public void get() throws URISyntaxException, ClientProtocolException, IOException {
        CloseableHttpClient client = HttpClients.createDefault();
        HttpGet get = new HttpGet(_targetHost+"/get");
        CloseableHttpResponse response = client.execute(get);
        processResponse(response);
    }
    
    public void post() throws ClientProtocolException, IOException {
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("chinese", "中文"));
        params.add(new BasicNameValuePair("english", "英文"));
        UrlEncodedFormEntity entity = new UrlEncodedFormEntity(params, _charset);
        
        CloseableHttpClient client = HttpClients.createDefault();
        HttpPost post = new HttpPost(_targetHost+"/post");
        post.addHeader("Cookie", "character=abcdefghijklmnopqrstuvwxyz; sign=abc-123-jkl-098");
        post.setEntity(entity);
        CloseableHttpResponse response = client.execute(post);
        processResponse(response);
    }
    
    public void sendFile(String filePath) throws UnsupportedOperationException, IOException {
        CloseableHttpClient client = HttpClients.createDefault();
        HttpPost post = new HttpPost(_targetHost+"/file");
        File file = new File(filePath);
        FileEntity entity = new FileEntity(file, ContentType.create(ContentType.TEXT_PLAIN.getMimeType(), _charset));
        post.setEntity(entity);
        CloseableHttpResponse response = client.execute(post);
        processResponse(response);
    }
    
    private void processResponse(CloseableHttpResponse response) 
            throws UnsupportedOperationException, IOException {
        try {
            // 获取响应头
            Header[] headers = response.getAllHeaders();
            for (Header header : headers) {
                _logger.info(header.getName() + ":" + header.getValue());
            }
            
            // 获取状态信息
            StatusLine sl =response.getStatusLine();
            _logger.info( String.format("ProtocolVersion:%s, StatusCode:%d, Desc:%s", 
                    sl.getProtocolVersion().toString(), sl.getStatusCode(), sl.getReasonPhrase()) );
            
            // 获取响应内容
            HttpEntity entity = response.getEntity();
            _logger.info( String.format("ContentType:%s, Length:%d, Encoding:%s", 
                    null == entity.getContentType() ? "" : entity.getContentType().getValue(), 
                    entity.getContentLength(),
                    null == entity.getContentEncoding() ? "" : entity.getContentEncoding().getValue()) );
            _logger.info(EntityUtils.toString(entity, _charset));
//            _logger.info( IOUtils.toString(entity.getContent(), _charset) ); // 大部分情况下效果与上行语句等同，但实现上的编码处理不同
        } finally {
            response.close();
        }
    }
    
    /**
     * @param args
     */
    public static void main(String[] args) throws Exception {
        HttpClientBasic basic = new HttpClientBasic();
//        basic.get();
//        basic.post();
        basic.sendFile("/devdata/projects/open_source/mine/JavaTutorial/LICENSE");
    }

}
