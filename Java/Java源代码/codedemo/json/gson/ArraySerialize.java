package cn.aofeng.demo.json.gson;

import com.google.gson.Gson;

/**
 * 数组的序列化。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class ArraySerialize {

    public void serialize(Object[] arr) {
        Gson gson = new Gson();
        System.out.println( gson.toJson(arr) );
    }
    
    public static void main(String[] args) {
        ArraySerialize as = new ArraySerialize();
        
        // 整型对象数组
        Integer[] intArr = new Integer[3];
        intArr[0] = 9;
        intArr[1] = 7;
        intArr[2] = 5;
        as.serialize(intArr);
        
        // 字符串数组
        String[] names = new String[3];
        names[0] = "张三";
        names[1] = "李四";
        names[2] = "王五";
        as.serialize(names);
        
        // 对象数组
        Person[] persons = new Person[2];
        persons[0] = new Person("小明", 10);
        persons[1] = new Person("马丽", 9);
        as.serialize(persons);
    }

}
