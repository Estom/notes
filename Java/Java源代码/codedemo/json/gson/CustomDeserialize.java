package cn.aofeng.demo.json.gson;

import java.lang.reflect.Type;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;

/**
 * 自定义反序列化。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class CustomDeserialize {

    public static void main(String[] args) {
        GsonBuilder builder = new GsonBuilder();
        builder.registerTypeAdapter(Person.class, new PersonDeserializer());
        Gson gson = builder.create();
        
        String json = "{\"PersonName\":\"aofeng\",\"PersonAge\":32}";
        Person obj = gson.fromJson(json, Person.class);
        System.out.println(obj); // 输出结果：Person [name=aofeng, age=32]
    }

    public static class PersonDeserializer implements JsonDeserializer<Person> {

        @Override
        public Person deserialize(JsonElement jsonEle, Type type,
                JsonDeserializationContext context)
                throws JsonParseException {
            JsonObject jo = jsonEle.getAsJsonObject();
            String name = jo.get("PersonName").getAsString();
            int age = jo.get("PersonAge").getAsInt();
            
            Person obj = new Person(name, age);
            return obj;
        }
        
    } // end of PersonDeserializer

}
