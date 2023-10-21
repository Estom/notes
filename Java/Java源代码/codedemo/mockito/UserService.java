package cn.aofeng.demo.mockito;

/**
 * 用户服务。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class UserService {

    /** 成人年龄分界线 */
    private final static int ADULT_AGE = 18;
    
    private UserDao _userDao;
    private CommodityDao _commodityDao;
    
    public boolean isAdult(long userId) {
        User user = _userDao.queryById(userId);
        if (null == user || user.getAge() < ADULT_AGE) {
            return false;
        }
        
        return true;
    }
    
    public boolean buy(long userId, String commodityId) {
        if (! isAdult(userId)) {
            return false;
        }
        
        Commodity commodity = _commodityDao.queryById(commodityId);
        if (null == commodity) {
            return false;
        }
        // 省略余下的处理逻辑
        return true;
    }
    
    public UserDao getUserDao() {
        return _userDao;
    }
    
    public void setUserDao(UserDao userDao) {
        this._userDao = userDao;
    }

    public CommodityDao getCommodityDao() {
        return _commodityDao;
    }

    public void setCommodityDao(CommodityDao commodityDao) {
        this._commodityDao = commodityDao;
    }

}
