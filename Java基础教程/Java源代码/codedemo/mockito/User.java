package cn.aofeng.demo.mockito;

/**
 * 用户信息。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class User {

    private long id;
    
    private String name;
    
    private int sex;
    
    private int age;
    
    private String address;

    public User() {
        // nothing
    }
    
    public User(long userId, String userName, int age) {
        this.id = userId;
        this.name = userName;
        this.age = age;
    }
    
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getSex() {
        return sex;
    }

    public void setSex(int sex) {
        this.sex = sex;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

}
