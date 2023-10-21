package cn.aofeng.demo.json.gson;

import com.google.gson.Gson;

/**
 * 数组的反序列化。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class ArrayDeserialize {

    public <T> T deserialize(String json, Class<T> claz) {
        Gson gson = new Gson();
        return gson.fromJson(json, claz);
    }
    
    public static void main(String[] args) {
        ArrayDeserialize ad = new ArrayDeserialize();
        
        // 整型数组
        String intArrJson = "[9,7,5]";
        int[] intArr = ad.deserialize(intArrJson, int[].class);
        System.out.println("---------- 整型数组 ----------");
        for (int i : intArr) {
            System.out.println(i);
        }
        
        // 字符串数组
        String strArrJson = "[\"张三\",\"李四\",\"王五\"]";
        String[] strArr = ad.deserialize(strArrJson, String[].class);
        System.out.println("---------- 字符串数组 ----------");
        for (String str : strArr) {
            System.out.println(str);
        }
        
        // 对象数组
        String objArrJson = "[{\"name\":\"小明\",\"age\":10},{\"name\":\"马丽\",\"age\":9}]";
        Person[] objArr = ad.deserialize(objArrJson, Person[].class);
        System.out.println("---------- 对象数组 ----------");
        for (Person person : objArr) {
            System.out.println(person);
        }
    }

}
