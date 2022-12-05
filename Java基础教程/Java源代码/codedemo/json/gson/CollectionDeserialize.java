package cn.aofeng.demo.json.gson;

import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

/**
 * 集合的反序列化。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class CollectionDeserialize {

    public <T> T deserialize(String json, Type type) {
        Gson gson = new Gson();
        return gson.fromJson(json, type);
    }
    
    public static void main(String[] args) {
        CollectionDeserialize cd = new CollectionDeserialize();
        
        //整型List
        String intListJson = "[9,8,0]";
        List<Integer> intList = cd.deserialize( intListJson, 
                new TypeToken<List<Integer>>(){}.getType() );
        System.out.println("---------- 整型List ----------");
        for (Integer obj : intList) {
            System.out.println(obj);
        }
        
        // 字符串Set
        String strSetJson = "[\"Best\",\"World\",\"Hello\"]";
        Set<String> strSet = cd.deserialize( strSetJson, 
                new TypeToken<Set<String>>(){}.getType() );
        System.out.println("---------- 字符串Set ----------");
        for (String str : strSet) {
            System.out.println(str);
        }
        
        // Map
        String objMapJson = "{\"xiaomin\":{\"name\":\"小明\",\"age\":21},\"marry\":{\"name\":\"马丽\",\"age\":20}}";
        Map<String, Person> objMap = cd.deserialize( objMapJson, 
                new TypeToken<Map<String, Person>>(){}.getType() );
        System.out.println("---------- Map ----------");
        for (Entry<String, Person> entry : objMap.entrySet()) {
            System.out.println(entry);
        }
    }

}
