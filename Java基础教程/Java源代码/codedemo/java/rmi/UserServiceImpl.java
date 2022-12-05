package cn.aofeng.demo.java.rmi;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

import org.apache.commons.lang.StringUtils;

/**
 * 用户信息服务。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class UserServiceImpl extends UnicastRemoteObject implements UserService {

    public UserServiceImpl() throws RemoteException {
        super();
    }

    private static final long serialVersionUID = -9134952963637302483L;

    @Override
    public User findByName(String name) throws RemoteException {
        if (StringUtils.isBlank(name)) {
            return null;
        }
        
        if ("小明".equals(name)) {
            return createUser("10000", "小明", Gender.MALE);
        }
        
        return null;
    }

    @Override
    public User findById(String id) throws RemoteException {
        if (StringUtils.isBlank(id)) {
            return null;
        }
        
        if ("10000".equals(id)) {
            return createUser("10000", "小丽", Gender.FEMALE);
        }
        
        return null;
    }

    @Override
    public boolean add(User user) throws RemoteException {
        if (null == user || StringUtils.isBlank(user.getId()) || StringUtils.isBlank(user.getName())) {
            return false;
        }
        
        return true;
    }

    private User createUser(String id, String name, char gender) {
        User user = new User();
        user.setId(id);
        user.setName(name);
        user.setGender(gender);
        user.setBirthday(System.currentTimeMillis());
        user.setCountry("中国");
        user.setProvince("广东");
        user.setCity("广州");
        user.setAddress("xxx区xxx街道xxx号");
        
        return user;
    }

}
