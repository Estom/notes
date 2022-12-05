package cn.aofeng.demo.java.lang.serialization;

import java.io.Serializable;

/**
 * 默认序列化和
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class People implements Serializable {

    private static final long serialVersionUID = 6235620243018494633L;

    private String name;
    
    private int age;
    
    private transient String address;
    
    private static String sTestNormal;
    
    private static transient String sTestTransient;

    public People(String name) {
        this.name = name;
    }
    
    public People(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public People(String name, int age, String address) {
        this.name = name;
        this.age = age;
        this.address = address;
    }
    
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getsTestNormal() {
        return sTestNormal;
    }

    public void setsTestNormal(String sTestNormal) {
        People.sTestNormal = sTestNormal;
    }

    public String getsTestTransient() {
        return sTestTransient;
    }

    public void setsTestTransient(String sTestTransient) {
        People.sTestTransient = sTestTransient;
    }

}
