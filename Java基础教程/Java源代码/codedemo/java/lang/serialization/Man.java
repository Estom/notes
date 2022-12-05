package cn.aofeng.demo.java.lang.serialization;

import java.io.Externalizable;
import java.io.IOException;
import java.io.ObjectInput;
import java.io.ObjectOutput;

/**
 * 自定义序列化和反序列化。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class Man implements Externalizable {

    private String manName;
    
    private int manAge;
    
    private transient String password;

    public Man() {
        // nothing
    }
    
    public Man(String name, int age) {
        this.manName = name;
        this.manAge = age;
    }
    
    public Man(String name, int age, String password) {
        this.manName = name;
        this.manAge = age;
        this.password = password;
    }
    
    public String getManName() {
        return manName;
    }

    public void setManName(String manName) {
        this.manName = manName;
    }

    public int getManAge() {
        return manAge;
    }

    public void setManAge(int manAge) {
        this.manAge = manAge;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public void writeExternal(ObjectOutput out) throws IOException {
        out.writeObject(manName);
        out.writeInt(manAge);
        out.writeObject(password);
    }

    @Override
    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
        manName = (String) in.readObject();
        manAge = in.readInt();
        password = (String) in.readObject();
    }

}
