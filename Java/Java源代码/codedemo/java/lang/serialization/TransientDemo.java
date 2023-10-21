package cn.aofeng.demo.java.lang.serialization;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 关键字 transient 测试。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class TransientDemo {

    private static Logger _logger = LoggerFactory.getLogger(TransientDemo.class);
    
    private String _tempFileName = "TransientDemo";
    
    /**
     * 将对象序列化并保存到文件。
     * 
     * @param obj 待序列化的对象
     */
    public void save(Object obj) {
        ObjectOutputStream outs = null;
        try {
            outs = new ObjectOutputStream(
                    new FileOutputStream( getTempFile(_tempFileName) ));
            outs.writeObject(obj);
        } catch (IOException e) {
            _logger.error("save object to file occurs error", e);
        } finally {
            IOUtils.closeQuietly(outs);
        }
    }
    
    /**
     * 从文件读取内容并反序列化成对象。
     * 
     * @return {@link People}对象。如果读取文件出错 或 对象类型转换失败，返回null。
     */
    public <T> T load() {
        ObjectInputStream ins = null;
        try {
            ins = new ObjectInputStream(
                    new FileInputStream( getTempFile(_tempFileName)) );
            return ((T) ins.readObject());
        } catch (IOException e) {
            _logger.error("load object from file occurs error", e);
        } catch (ClassNotFoundException e) {
            _logger.error("load object from file occurs error", e);
        } finally {
            IOUtils.closeQuietly(ins);
        }
        
        return null;
    }
    
    private File getTempFile(String filename) {
        return new File(getTempDir(), filename);
    }
    
    private String getTempDir() {
        return System.getProperty("java.io.tmpdir");
    }
    
    private void displayPeople(People people) {
        if (null == people) {
            return;
        }
        String template = "People[name:%s, age:%d, address:%s, sTestNormal:%s, sTestTransient:%s]";
        System.out.println( String.format(template, people.getName(), people.getAge(), 
                people.getAddress(), people.getsTestNormal(), people.getsTestTransient()));
    }
    
    private void displayMan(Man man) {
        if (null == man) {
            return;
        }
        String template = "Man[manName:%s, manAge:%d, password:%s]";
        System.out.println( String.format(template, man.getManName(), man.getManAge(), man.getPassword()) );
    }
    
    /**
     * @param args
     */
    public static void main(String[] args) {
        System.out.println(">>> Serializable测试");
        TransientDemo demo = new TransientDemo();
        
        People people = new People("张三", 30, "中国广州");
        people.setsTestNormal("normal-first");
        people.setsTestTransient("transient-first");
        System.out.println("序列化之前的对象信息：");
        demo.displayPeople(people);
        demo.save(people);
        
        // 修改静态变量的值
        people.setsTestNormal("normal-second");
        people.setsTestTransient("transient-second");
        
        People fromLoad = demo.load();
        System.out.println("反序列化之后的对象信息：");
        demo.displayPeople(fromLoad);
        
        
        
        System.out.println("");
        System.out.println(">>> Externalizable测试");
        Man man = new Man("李四", 10, "假密码");
        System.out.println("序列化之前的对象信息：");
        demo.displayMan(man);
        demo.save(man);
        
        Man manFromLoadMan = demo.load();
        System.out.println("反序列化之后的对象信息：");
        demo.displayMan(manFromLoadMan);
    }

}
