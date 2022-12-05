package cn.aofeng.demo.java.rmi;

import java.rmi.AlreadyBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * RMI服务端。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class RmiServer {

    private static Logger _logger = LoggerFactory.getLogger(RmiServer.class);
    
    public static Registry createRegistry(int port) {
        Registry registry = null;
        try {
            registry = LocateRegistry.createRegistry(port);
        } catch (RemoteException e) {
            _logger.info( String.format("注册端口%s失败", port), e);
        }
        
        return registry;
    }
    
    /**
     * @param args [0]:绑定端口
     * @throws RemoteException 
     */
    public static void main(String[] args) throws RemoteException {
        int port = Integer.parseInt(args[0]);
        UserService userService = new UserServiceImpl();
        Registry registry = createRegistry(port);
        if (null == registry) {
            System.exit(0);
        }
        
        String bindName = "UserService";
        try {
            registry.bind(bindName, userService);
        } catch (AlreadyBoundException e) {
            _logger.info("服务{}已经绑定过", bindName);
        }
        
        _logger.info("RMI Server started, listen port:{}", port);
    }

}
