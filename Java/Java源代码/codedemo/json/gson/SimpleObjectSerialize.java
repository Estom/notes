package cn.aofeng.demo.json.gson;

import com.google.gson.Gson;

/**
 * Java简单对象的序列化与反序列化。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class SimpleObjectSerialize {

    /**
     * 序列化：将Java对象转换成JSON字符串。
     */
    public void serialize(Person person) {
        Gson gson = new Gson();
        System.out.println( gson.toJson(person) );
    }
    
    /**
     * 反序列化：将JSON字符串转换成Java对象。
     */
    public void deserialize(String json) {
        Gson gson = new Gson();
        Person person = gson.fromJson(json, Person.class);
        System.out.println( person );
    }
    
    public static void main(String[] args) {
        SimpleObjectSerialize ss = new SimpleObjectSerialize();
        
        Person person = new Person("NieYong", 33);
        ss.serialize(person);
        
       String json = " {\"name\":\"AoFeng\",\"age\":32}";
       ss.deserialize(json);
    }

}
