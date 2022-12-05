package cn.aofeng.demo.easymock;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.Map;

import org.apache.log4j.Logger;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import cn.aofeng.demo.jetty.HttpGet;

/**
 * 用户相关服务。如：获取用户昵称。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class UserService {

    private static Logger _logger = Logger.getLogger(UserService.class);
    
    private HttpGet _httpGet = new HttpGet();
    
    /**
     * 根据用户的账号ID获取昵称。
     * 
     * @param accountId 用户的账号ID
     * @return 如果账号ID有效且请求成功，返回昵称；否则返回默认的昵称"用户xxx"。
     */
    public String getNickname(String accountId) {
        String targetUrl = "http://192.168.56.102:8080/user?method=getNickname&accountId="+accountId;
        String response = null;
        try {
            response = _httpGet.getSomeThing(targetUrl);
        } catch (IOException e) {
            _logger.error("获取用户昵称时出错,账号ID:"+accountId, e);
        }
        
        if (null != response) {
            // 响应数据结构示例：{"nickname":"张三"}
            Type type = new TypeToken<Map<String, String>>() {}.getType();
            Map<String, String> data = new Gson().fromJson(response, type);
            if (null != data && data.containsKey("nickname")) {
                return data.get("nickname");
            }
        }
        
        return "用户"+accountId;
    }

    protected void setHttpGet(HttpGet httpGet) {
        this._httpGet = httpGet;
    }

}
