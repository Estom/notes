package cn.aofeng.demo.json.gson;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.google.gson.Gson;

/**
 * 集合的序列化。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class CollectionsSerialize {

    public void serialize(Collection<?> c) {
        Gson gson = new Gson();
        System.out.println( gson.toJson(c) );
    }
    
    public void serialize(Map<?, ?> map) {
        Gson gson = new Gson();
        System.out.println( gson.toJson(map) );
    }
    
    public static void main(String[] args) {
        CollectionsSerialize cs = new CollectionsSerialize();
        
        // 整型List
        List<Integer> intList = new ArrayList<Integer>();
        intList.add(9);
        intList.add(8);
        intList.add(0);
        cs.serialize(intList);
        
        // 字符串Set
        Set<String> strSet = new HashSet<String>();
        strSet.add("Hello");
        strSet.add("World");
        strSet.add("Best");
        cs.serialize(strSet);
        
        // Map
        Map<String, Person> objMap = new HashMap<String, Person>();
        objMap.put("marry", new Person("马丽", 20));
        objMap.put("xiaomin", new Person("小明", 21));
        cs.serialize(objMap);
    }

}
