package cn.aofeng.demo.java.rmi;

import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class RmiClient {

    private static Logger _logger = LoggerFactory.getLogger(RmiClient.class);
    
    private static String assembleUrl(String hostUrl, String bindName) {
        if (StringUtils.isBlank(hostUrl) || StringUtils.isBlank(bindName)) {
            return null;
        }
        
        String host = hostUrl.endsWith("/") ? hostUrl.substring(0, hostUrl.length()-1) : hostUrl;
        String name = bindName.startsWith("/") ? bindName.substring(1) : bindName;
        
        return host + "/" + name;
    }
    
    /**
     * @param args 
     * <ul>
     *   <li>[0]：待连接的RMI主机。如：rmi://192.168.56.102:9999</li>
     *   <li>[1]：服务名称。如：UserService</li>
     * </ul>
     */
    public static void main(String[] args) throws MalformedURLException, RemoteException, NotBoundException {
        String host = args[0];
        String serviceName = args[1];
        String url = assembleUrl(host, serviceName);
        UserService userService = (UserService) Naming.lookup(url);
        
        String userId = "10000";
        User user = userService.findById(userId);
        _logger.info("身份证号为{}的用户信息{}", userId, user);
        userId = "10001";
        user = userService.findById(userId);
        _logger.info("身份证号为{}的用户信息{}", userId, user);
        
        String userName = "小明";
        user = userService.findByName(userName);
        _logger.info("姓名为{}的用户信息{}", userName, user);
        userName = "张三";
        user = userService.findByName(userName);
        _logger.info("姓名为{}的用户信息{}", userName, user);
    }

}
