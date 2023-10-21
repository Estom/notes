package cn.aofeng.demo.java.rmi;

import java.rmi.Remote;
import java.rmi.RemoteException;

/**
 * 用户信息服务。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public interface UserService extends Remote {

    public User findByName(String name) throws RemoteException;
    
    public User findById(String id) throws RemoteException;
    
    public boolean add(User user) throws RemoteException;

}
