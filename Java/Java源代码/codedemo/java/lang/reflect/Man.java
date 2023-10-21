package cn.aofeng.demo.java.lang.reflect;

import cn.aofeng.demo.json.gson.Person;
import cn.aofeng.demo.util.LogUtil;

/**
 * 男人。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class Man extends Person {

    private boolean marry;
    
    private int power;
    
    public int height;

    public Man() {
        super();
        LogUtil.log("%s的默认构造方法被调用", Man.class.getName());
    }
    
    protected Man(String name) {
        super(name, 0);
        LogUtil.log("%s带name参数的构造方法被调用", Man.class.getName());
    }
    
    @SuppressWarnings("unused")
    private Man(String name, int age) {
        super(name, age);
        LogUtil.log("%s带name和age参数的构造方法被调用", Man.class.getName());
    }
    
    public static void fight(Man a, Man b) {
        String win = "unkown";
        if (a.power > b.power) {
            win = a.getName();
        } else if (b.power > a.power) {
            win = a.getName();
        }
        
        LogUtil.log("%s vs %s, fight result:%s", a.getName(), b.getName(), win);
    }
    
    public boolean isMarry() {
        return marry;
    }

    public void setMarry(boolean marry) {
        this.marry = marry;
    }

    public int getPower() {
        return power;
    }

    @SuppressWarnings("unused")
    private void setPower(int power) {
        this.power = power;
    }

}
