
两种类型之间转换。
Java对象和json格式之间转换。

* 序列化：转换成json格式
  * json字符串
  * json字节码
* 反序列化：转换成java格式
  * java对象
  * jsonobject如果没有指定java对象


https://blog.csdn.net/qq_37436172/article/details/127334627

https://www.jianshu.com/p/f5407d45d590
## 序列化



```java
package com.alibaba.fastjson;

public abstract class JSON {
    // 将Java对象序列化为JSON字符串，支持各种各种Java基本类型和JavaBean
    public static String toJSONString(Object object, SerializerFeature... features);

    // 将Java对象序列化为JSON字符串，返回JSON字符串的utf-8 bytes
    public static byte[] toJSONBytes(Object object, SerializerFeature... features);

    // 将Java对象序列化为JSON字符串，写入到Writer中
    public static void writeJSONString(Writer writer, 
                                       Object object, 
                                       SerializerFeature... features);

    // 将Java对象序列化为JSON字符串，按UTF-8编码写入到OutputStream中
    public static final int writeJSONString(OutputStream os,
                                            Object object,
                                            SerializerFeature... features);
}
```


## 反序列化

```java
package com.alibaba.fastjson;

public abstract class JSON {
    // 将JSON字符串反序列化为JavaBean
    public static <T> T parseObject(String jsonStr, 
                                    Class<T> clazz, 
                                    Feature... features);

    // 将JSON字符串反序列化为JavaBean
    public static <T> T parseObject(byte[] jsonBytes,  // UTF-8格式的JSON字符串
                                    Class<T> clazz, 
                                    Feature... features);

    // 将JSON字符串反序列化为泛型类型的JavaBean
    public static <T> T parseObject(String text, 
                                    TypeReference<T> type, 
                                    Feature... features);

    // 将JSON字符串反序列为JSONObject
    public static JSONObject parseObject(String text);
}
```


## Map泛型反序列化
JSON串转为 Map，含有泛型的 JSON 反序列化

### JSON串 --> Map<String, Object>
```java
@Test
public void test() {
    Map<String, Order> orderMap = new HashMap<String, Order>(){{
        put("001", new Order(1001L, "T001"));
        put("002", new Order(1002L, "T002"));
    }};
    String jsonStr = JSON.toJSONString(orderMap);

    // 没有泛型 是不安全的
    Map map = JSON.parseObject(jsonStr);

    // TypeReference 但构造方法是protected，所以使用它的子类
    // 用匿名内部类作为 TypeReference 子类
    TypeReference<Map<String, Order>> typeReference = new TypeReference<Map<String, Order>>() {};
    Map<String, Order> result = JSON.parseObject(jsonStr, typeReference);
```
### JSON串 --> Map<String, List<Object>>

```java
@Test
public void test() {

    Map<Integer, List<Order>> data = new HashMap<Integer, List<Order>>() {{
        put(2022001, Arrays.asList(new Order(1001L, "T001")));
        put(2022002, Arrays.asList(new Order(1002L, "T002")));
    }};
    String jsonStr = JSON.toJSONString(data);

    Map<Integer, List<Order>> map = JSON.parseObject(jsonStr, new TypeReference<Map<Integer, List<Order>>>() {});

    // 方式一：使用 Type
    Type type = new TypeReference<Map<Integer, List<Order>>>(){}.getType();
    Map<Integer, List<Order>> resultMap = JSON.parseObject(jsonStr, type);

    // 方式二
    Map<Integer, List<Order>> integerListMap = JSON.parseObject(jsonStr, new TypeReference<Map<Integer, List<Order>>>() {});

}
```