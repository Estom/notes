package cn.aofeng.demo.json.gson;

import java.lang.reflect.Type;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

/**
 * 自定义序列化。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class CustomSerialize {

    public static void main(String[] args) {
        GsonBuilder builder = new GsonBuilder();
        builder.registerTypeAdapter(Person.class, new PersonSerializer());
        Gson gson = builder.create();
        
        Person obj = new Person("aofeng", 32);
        System.out.println( gson.toJson(obj) ); // 输出结果：{"PersonName":"aofeng","PersonAge":32}
    }

    public static class PersonSerializer implements JsonSerializer<Person> {

        @Override
        public JsonElement serialize(Person obj, Type type,
                JsonSerializationContext context) {
            JsonObject jo = new JsonObject();
            jo.addProperty("PersonName", obj.getName());
            jo.addProperty("PersonAge", obj.getAge());
            
            return jo;
        }
        
    } // end of PersonSerializer
    
}
