
两种类型之间转换。
Java对象和json格式之间转换。

* 序列化：转换成json格式
  * json字符串
  * json字节码
* 反序列化：转换成java格式
  * java对象
  * jsonobject如果没有指定java对象

## 1 Gson介绍
GSON是Google提供的用来在Java对象和JSON数据之间进行映射的Java类库。可以将一个Json字符转成一个Java对象，或者将一个Java转化为Json字符串

### 在使用Gson时需要先引入Gson依赖
```
<!-- https://mvnrepository.com/artifact/com.google.code.gson/gson -->
    <dependency>
      <groupId>com.google.code.gson</groupId>
      <artifactId>gson</artifactId>
      <version>2.8.5</version>
    </dependency>
```
## 2 Gson使用
### 1. 简单对象 序列化/反序列化

序列化：
```
/**
     * 简单对象转Json
     *
     * @param obj
     * @return
     */
    public static String simpleObjToJson(Object obj) {
        if (Objects.isNull(obj)) return "";
        try {
            Gson gson = new Gson();
            return gson.toJson(obj);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
```
测试：

@Test
    void GsonUtilTest() {
        // 简单对象转json
        User user = new User(1, "张三", 18);
        String json = GsonUtil.simpleObjToJson(user);
        System.out.println(json);
    }
结果：

{"id":1,"name":"张三","age":18}
如果对象中存在空值：

先看一下user对象中的数据类型

@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    private int id;
    private String name;
    private Integer age;

    public User(String name, Integer age) {
        this.name = name;
        this.age = age;
    }

    public User(String name) {
        this.name = name;
    }
}
测试：

@Test
void GsonUtilTest() {
    // 简单对象转json
    User user = new User("张三");
    String json = GsonUtil.simpleObjToJson(user);
    System.out.println(json);
}
结果：

{"id":0,"name":"张三"}
可以看出基本类型有默认值，包装类不解析

反序列化：

/**
     * 简单Json转对象
     *
     * @param json
     * @param cls
     * @param <T>
     * @return
     */
    public static <T> T simpleJsonToObj(String json, Class<T> cls) {
        Gson gson = new Gson();
        if (Objects.isNull(json)) return null;
        T obj = gson.fromJson(json, cls);
        if (Objects.isNull(obj)) {
            return null;
        } else {
            return obj;
        }
    }
测试：

@Test
void test2() {
    String json = "{\"id\":1,\"name\":\"张三\",\"age\":18}";
    User user = GsonUtil.simpleJsonToObj(json, User.class);
    System.out.println(user);
}
结果：

User(id=1, name=张三, age=18)
2. 复杂对象 序列化/反序列化（对象中嵌套对象）

同简单对象一样

序列化：

复杂对象：

@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    private int id;
    private String name;
    private Integer age;
    private Job job;
    private List<String> nickName;

    public User(int id, String name, Integer age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }
}
@Data
public class Job {
    private String jobName;
    private String company;
}
/**
     * 复杂对象转Json
     * 
     * @param obj
     * @return
     */
    public static String complexObjToJson(Object obj) {
        if (Objects.isNull(obj)) return "";
        try {
            Gson gson = new Gson();
            return gson.toJson(obj);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
测试：

@Test
    void test3() {
        User user = new User();
        user.setId(1);
        user.setName("张三");
        user.setAge(18);
        Job job = new Job();
        job.setJobName("Java开发");
        job.setCompany("某知名大厂");
        user.setJob(job);
        List<String> list = Arrays.asList("张三", "法外狂徒", "传奇人物");
        user.setNickName(list);
        String json = GsonUtil.complexObjToJson(user);
        System.out.println(json);
    }
结果：

{
    "id":1,
    "name":"张三",
    "age":18,
    "job":{
        "jobName":"Java开发",
        "company":"某知名大厂"
    },
    "nickName":[
        "张三",
        "法外狂徒",
        "传奇人物"
    ]
}
反序列化：

/**
     * 复杂Json转对象
     *
     * @param json
     * @param cls
     * @param <T>
     * @return
     */
    public static <T> T complexJsonToObj(String json, Class<T> cls) {
        Gson gson = new Gson();
        if (Objects.isNull(json)) return null;
        T obj = gson.fromJson(json, cls);
        if (Objects.isNull(obj)) {
            return null;
        } else {
            return obj;
        }
    }
测试：

@Test
void test4() {
    String json = "{\"id\":1,\"name\":\"张三\",\"age\":18,\"job\":{\"jobName\":\"Java开发\",\"company\":\"某知名大厂\"},\"nickName\":[\"张三\",\"法外狂徒\",\"传奇人物\"]}";
    User user = GsonUtil.complexJsonToObj(json, User.class);
    System.out.println(user);
}
结果：

User(id=1, name=张三, age=18, job=Job(jobName=Java开发, company=某知名大厂), nickName=[张三, 法外狂徒, 传奇人物])
3. 数组 序列化/反序列化

这里数据序列化和上面一样，

反序列化又=有一点区别String[] nameArray = gson.fromJson(namesJson, String[].class);

工作中不常用，就不再详细介绍

4. Map和List 序列化反序列化

Map和List是工作中比较常用的，而且这两个操作比较相似：

List序列化和反序列化 序列化：
    /**
     * list To Json
     *
     * @param list
     * @return
     */
    public static String listToJson(List list) {
        if (Objects.isNull(list)) return "";
        try {
            Gson gson = new Gson();
            return gson.toJson(list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
测试：

    @Test
    void test6() {
        List<String> list = new ArrayList<>();
        list.add("zhangsan");
        list.add("lisi");
        list.add("wangwu");
        String json = GsonUtil.listToJson(list);
        System.out.println(json);
    }
结果：

java ["zhangsan","lisi","wangwu"]

反序列化： 这里反序列化时需要提供Type，通过Gson提供的TypeToken<T>.getType()方法可以定义当前List的Type

    /**
     * json to list
     * 
     * @param json
     * @param cls
     * @param <T>
     * @return
     */
    public static <T> T jsonToList(String json,Class<T> cls) {
        if (Objects.isNull(json)) return null;
        try {
            Gson gson = new Gson();
          	// 需要注意这里的type
            Type type = new TypeToken<ArrayList<T>>(){}.getType();
            return gson.fromJson(json, type);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
测试：

    @Test
    void test7() {
        String json = "[{\"id\":1,\"name\":\"zhangsan\",\"age\":18},{\"id\":2,\"name\":\"sili\",\"age\":28}]";
        System.out.println(GsonUtil.jsonToList(json, User.class));
    }
结果：

json [{id=1.0, name=zhangsan, age=18.0}, {id=2.0, name=sili, age=28.0}]

Map 序列化和反序列化
和List一样

Gson进阶用法
1. 指定序列化和反序列化 字段名称

这个用法是常用的，尤其在解析第三方接口返回数据时，可以指定字段名称解析

实体类加@SerializedName注解

@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    private int id;
    @SerializedName("login_name")
    private String name;
    private Integer age;
    private Job job;
    private List<String> nickName;

    public User(int id, String name, Integer age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }
}
反序列化测试：

@Test
    void test8() {
        String json = "{\"id\":1,\"login_name\":\"张三\",\"age\":18}";
        User user = GsonUtil.complexJsonToObj(json, User.class);
        System.out.println(user);
    }
结果：

User(id=1, name=张三, age=18, job=null, nickName=null)
Gson 解析时会将 login_name 解析出的数据封装到 name 属性中

序列化测试：

@Test
    void test9() {
        User user = new User(1, "张三", 18);
        System.out.println(GsonUtil.complexObjToJson(user));
    }
结果：

{"id":1,"login_name":"张三","age":18}
实际工作中用到场景：

我们工作中经常会需要调用第三方提供的接口，第三方接口数据有些字段命名不符合我们习惯，不如字段用下滑线而我们习惯驼峰命名，这是便可以用@SerializedName注解，这个注解还有一个属性alternate，@SerializedName(value = "login_name", alternate = "name")，此时这个注解意思是如果Json中是login_name就用login_name的值，如果是name就用name值。

2. 忽略解析某个值

有两种方式可以在解析是忽略某个值

@Expose注解
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    @Expose()
    private int id; // 参与序列化/反序列化
    @SerializedName("login_name")
    @Expose(serialize = false,deserialize = false)
    private String name; // 不参与序列化，也不参与反序列化
    @Expose(serialize = false, deserialize = true)
    private Integer age; // 只参与反序列化
    @Expose(serialize = true, deserialize = false)
    private Job job; // 只参与序列化
    
    private List<String> nickName;

    public User(int id, String name, Integer age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }
}
在使用这个注解时，就不能使用之前gson对象了，必须使用下面方式构建gson对象，该对象会排除没有注解的字段。

    public static String exposeObjToJson(Object obj) {
        if (Objects.isNull(obj)) return "";
        try {
            GsonBuilder gsonBuilder = new GsonBuilder();
            gsonBuilder.excludeFieldsWithoutExposeAnnotation();
            Gson gson = gsonBuilder.create();
            return gson.toJson(obj);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
    public static <T> T exposeJsonToObj(String json, Class<T> cls) {
        if (Objects.isNull(json)) return null;
        try {
            GsonBuilder gsonBuilder = new GsonBuilder();
            gsonBuilder.excludeFieldsWithoutExposeAnnotation();
            Gson gson = gsonBuilder.create();
            return gson.fromJson(json, cls);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
transient关键字
使用这个关键字，可以直接让变量不参与序列化/反序列化

@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    @Expose()
    private int id; // 参与序列化/反序列化
    @SerializedName(value = "login_name",alternate = "name")
    @Expose(serialize = false,deserialize = false)
    private String name; // 不参与序列化，也不参与反序列化
    @Expose(serialize = false)
    private Integer age; // 只参与反序列化
    @Expose(deserialize = false)
    private Job job; // 只参与序列化

    private transient List<String> nickName; // transient 关键字

    public User(int id, String name, Integer age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }
}
使用该关键字时，直接用普通new的gson对象即可。