
- [深入解析 Java 反射（1）- 基础](http://www.sczyh30.com/posts/Java/java-reflection-1/)
- [Java反射超详细，一个快乐的野指针](https://blog.csdn.net/qq_44715943/article/details/120587716)
## 1 反射概述

### 反射机制的作用
* 通过java语言中的反射机制可以操作字节码文件（可以读和修改字节码文件。）
* 通过反射机制可以操作代码片段。（class文件。）


### Class对象

Class对象的作用
* 每个类都有一个**Class**对象，包含了与类有关的信息,代表整个字节码。代表一个类型，代表整个类。。当编译一个新类时，会产生一个同名的 .class 文件，该文件内容保存着 Class 对象。

* 类加载相当于 Class 对象的加载，类在第一次使用时才动态加载到 JVM 中。也可以使用 `Class.forName("com.mysql.jdbc.Driver")` 这种方式来控制类的加载，该方法会返回一个 Class 对象。

* 反射可以提供运行时的类信息，并且这个类可以在运行时才加载进来，甚至在编译时期该类的 .class 不存在也可以加载进来。

获取Class对象的方法

* Class.forName(“完整类名带包名”)	静态方法
* 对象.getClass()	
* 任何类型.class


### 反射机制的使用

java.lang.reflect.*;存储与反射相关的类

| 类          | 含义         |
|------------------|-----|
| java.lang.Class               | 代表整个字节码。代表一个类型，代表整个类。              |
| java.lang.reflect.Method      | 代表字节码中的方法字节码。代表类中的方法。              |
| java.lang.reflect.Constructor | 代表字节码中的构造方法字节码。代表类中的构造方法。          |
| java.lang.reflect.Field       | 代表字节码中的属性字节码。代表类中的成员变量（静态变量+实例变量）。 |




Class 和 java.lang.reflect.* 一起对反射提供了支持，java.lang.reflect 类库主要包含了以下三个类：

-  **Field**  ：可以使用 get() 和 set() 方法读取和修改 Field 对象关联的字段；
-  **Method**  ：可以使用 invoke() 方法调用与 Method 对象关联的方法；
-  **Constructor**  ：可以用 Constructor 的 newInstance() 创建新的对象。

### 反射机制的优点

-  **可扩展性**   ：应用程序可以利用全限定名创建可扩展对象的实例，来使用来自外部的用户自定义类。
-  **类浏览器和可视化开发环境**   ：一个类浏览器需要可以枚举类的成员。可视化开发环境（如 IDE）可以从利用反射中可用的类型信息中受益，以帮助程序员编写正确的代码。
-  **调试器和测试工具**   ： 调试器需要能够检查一个类里的私有成员。测试工具可以利用反射来自动地调用类里定义的可被发现的 API 定义，以确保一组测试中有较高的代码覆盖率。

### 反射的缺点

尽管反射非常强大，但也不能滥用。如果一个功能可以不用反射完成，那么最好就不用。在我们使用反射技术时，下面几条内容应该牢记于心。

-  **性能开销**   ：反射涉及了动态类型的解析，所以 JVM 无法对这些代码进行优化。因此，反射操作的效率要比那些非反射操作低得多。我们应该避免在经常被执行的代码或对性能要求很高的程序中使用反射。

-  **安全限制**   ：使用反射技术要求程序必须在一个没有安全限制的环境中运行。如果一个程序必须在有安全限制的环境中运行，如 Applet，那么这就是个问题了。

-  **内部暴露**   ：由于反射允许代码执行一些在正常情况下不被允许的操作（比如访问私有的属性和方法），所以使用反射可能会导致意料之外的副作用，这可能导致代码功能失调并破坏可移植性。反射代码破坏了抽象性，因此当平台发生改变的时候，代码的行为就有可能也随着变化。




### 反射机制的使用

* 使用Class实例化一个对象。
```java
class ReflectTest02{
    public static void main(String[] args) throws ClassNotFoundException, InstantiationException, IllegalAccessException {
        // 下面这段代码是以反射机制的方式创建对象。

        // 通过反射机制，获取Class，通过Class来实例化对象
        Class c = Class.forName("javase.reflectBean.User");
        // newInstance() 这个方法会调用User这个类的无参数构造方法，完成对象的创建。
        // 重点是：newInstance()调用的是无参构造，必须保证无参构造是存在的！
        Object obj = c.newInstance();
        System.out.println(obj);
    }
}
```


* 使得一个类的静态代码执行，而其他代码不执行。例如JDBC中不需要创建实例而知识执行静态方法.这个方法的执行会导致类加载，类加载时，静态代码块执行。

```java
Class.forName("完整类名");
```

## 2 反射机制实现
### Class 中的方法
| 方法名 | 备注 |
|---|---|
| public T newInstance() | 创建对象 |
| public String getName() | 返回完整类名带包名 |
| public String getSimpleName() | 返回类名 |
| public Field[] getFields() | 返回类中public修饰的属性 |
| public Field[] getDeclaredFields() | 返回类中所有的属性 |
| public Field getDeclaredField(String name) | 根据属性名name获取指定的属性 |
| public native int getModifiers() | 获取属性的修饰符列表,返回的修饰符是一个数字，每个数字是修饰符的代号【一般配合Modifier类的toString(int x)方法使用】 |
| public Method[] getDeclaredMethods() | 返回类中所有的实例方法 |
| public Method getDeclaredMethod(String name, Class&lt;?&gt;… parameterTypes) | 根据方法名name和方法形参获取指定方法 |
| public Constructor&lt;?&gt;[] getDeclaredConstructors() | 返回类中所有的构造方法 |
| public Constructor getDeclaredConstructor(Class&lt;?&gt;… parameterTypes) | 根据方法形参获取指定的构造方法 |
| ---- | ---- |
| public native Class&lt;? super T&gt; getSuperclass() | 返回调用类的父类 |
| public Class&lt;?&gt;[] getInterfaces() | 返回调用类实现的接口集合 |


### Field中的方法

| 方法名 | 备注 |
|---|---|
| public String getName() | 返回属性名 |
| public int getModifiers() | 获取属性的修饰符列表,返回的修饰符是一个数字，每个数字是修饰符的代号【一般配合Modifier类的toString(int x)方法使用】 |
| public Class&lt;?&gt; getType() | 以Class类型，返回属性类型【一般配合Class类的getSimpleName()方法使用】 |
| public void set(Object obj, Object value) | 设置属性值 |
| public Object get(Object obj) | 读取属性值 |


```java
/*
必须掌握：
    怎么通过反射机制访问一个java对象的属性？
        给属性赋值set
        获取属性的值get
 */
class ReflectTest07{
    public static void main(String[] args) throws ClassNotFoundException, InstantiationException, IllegalAccessException, NoSuchFieldException {
        //不使用反射机制给属性赋值
        Student student = new Student();
        /**给属性赋值三要素：给s对象的no属性赋值1111
         * 要素1：对象s
         * 要素2：no属性
         * 要素3：1111
         */
        student.no = 1111;
        /**读属性值两个要素：获取s对象的no属性的值。
         * 要素1：对象s
         * 要素2：no属性
         */
        System.out.println(student.no);

        //使用反射机制给属性赋值
        Class studentClass = Class.forName("javase.reflectBean.Student");
        Object obj = studentClass.newInstance();// obj就是Student对象。（底层调用无参数构造方法）

        // 获取no属性（根据属性的名称来获取Field）
        Field noField = studentClass.getDeclaredField("no");
        // 给obj对象(Student对象)的no属性赋值
        /*
            虽然使用了反射机制，但是三要素还是缺一不可：
                要素1：obj对象
                要素2：no属性
                要素3：22222值
            注意：反射机制让代码复杂了，但是为了一个“灵活”，这也是值得的。
         */
        noField.set(obj, 22222);

        // 读取属性的值
        // 两个要素：获取obj对象的no属性的值。
        System.out.println(noField.get(obj));
    }
```

* set()方法不可以访问私有属性，需要打破封装，才可以。
* public void setAccessible(boolean flag)	默认false，设置为true为打破封装
```java
        // 可以访问私有的属性吗？
        Field nameField = studentClass.getDeclaredField("name");
        // 打破封装（反射机制的缺点：打破封装，可能会给不法分子留下机会！！！）
        // 这样设置完之后，在外部也是可以访问private的。
        nameField.setAccessible(true);
        // 给name属性赋值
        nameField.set(obj, "xiaowu");
        // 获取name属性的值
        System.out.println(nameField.get(obj));
```


### Method中的方法

| 方法名 | 备注 |
|---|---|
| public String getName() | 返回方法名 |
| public int getModifiers() | 获取方法的修饰符列表,返回的修饰符是一个数字，每个数字是修饰符的代号【一般配合Modifier类的toString(int x)方法使用】 |
| public Class&lt;?&gt; getReturnType() | 以Class类型，返回方法类型【一般配合Class类的getSimpleName()方法使用】 |
| public Class&lt;?&gt;[] getParameterTypes() | 返回方法的修饰符列表（一个方法的参数可能会有多个。）【结果集一般配合Class类的getSimpleName()方法使用】 |
| public Object invoke(Object obj, Object… args) | 调用方法 |

* 获取一个类中的method方法
```java
/*
了解一下，不需要掌握（反编译一个类的方法。）
 */
class ReflectTest09{
    public static void main(String[] args) throws ClassNotFoundException {
        StringBuilder s = new StringBuilder();

        Class userServiceClass = Class.forName("java.lang.String");

        s.append(Modifier.toString(userServiceClass.getModifiers()));
        s.append(" class ");
        s.append(userServiceClass.getSimpleName());
        s.append(" {\n");

        // 获取所有的Method（包括私有的！）
        Method[] methods = userServiceClass.getDeclaredMethods();
        for (Method m : methods){
            s.append("\t");
            // 获取修饰符列表
            s.append(Modifier.toString(m.getModifiers()));
            s.append(" ");
            // 获取方法的返回值类型
            s.append(m.getReturnType().getSimpleName());
            s.append(" ");
            // 获取方法名
            s.append(m.getName());
            s.append("(");
            // 方法的修饰符列表（一个方法的参数可能会有多个。）
            Class[] parameterTypes = m.getParameterTypes();
            for (int i = 0; i < parameterTypes.length; i++){
                s.append(parameterTypes[i].getSimpleName());
                if (i != parameterTypes.length - 1) s.append(", ");
            }
            s.append(") {}\n");
        }
        s.append("}");
        System.out.println(s);
    }
}
```


* 调用类中的方法Method
* 方法.invoke(对象, 实参);

```java
/*
重点：必须掌握，通过反射机制怎么调用一个对象的方法？
    五颗星*****

    反射机制，让代码很具有通用性，可变化的内容都是写到配置文件当中，
    将来修改配置文件之后，创建的对象不一样了，调用的方法也不同了，
    但是java代码不需要做任何改动。这就是反射机制的魅力。
 */
class ReflectTest10{
    public static void main(String[] args) throws Exception {
        // 不使用反射机制，怎么调用方法
        // 创建对象
        UserService userService = new UserService();
        // 调用方法
        /*
            要素分析：
                要素1：对象userService
                要素2：login方法名
                要素3：实参列表
                要素4：返回值
         */
        System.out.println(userService.login("admin", "123") ? "登入成功！" : "登入失败！");

        //使用反射机制调用方法
        Class userServiceClass = Class.forName("javase.reflectBean.UserService");
        // 创建对象
        Object obj = userServiceClass.newInstance();
        // 获取Method
        Method loginMethod = userServiceClass.getDeclaredMethod("login", String.class, String.class);
//        Method loginMethod = userServiceClass.getDeclaredMethod("login");//注：没有形参就不传
        // 调用方法
        // 调用方法有几个要素？ 也需要4要素。
        // 反射机制中最最最最最重要的一个方法，必须记住。
        /*
            四要素：
            loginMethod方法
            obj对象
            "admin","123" 实参
            retValue 返回值
         */
        Object resValues = loginMethod.invoke(obj, "admin", "123");//注：方法返回值是void 结果是null
        System.out.println(resValues);
    }
}
```


### Constructor中的方法

| 方法名 | 备注 |
|---|---|
| public String getName() | 返回构造方法名 |
| public int getModifiers() | 获取构造方法的修饰符列表,返回的修饰符是一个数字，每个数字是修饰符的代号【一般配合Modifier类的toString(int x)方法使用】 |
| public Class&lt;?&gt;[] getParameterTypes() | 返回构造方法的修饰符列表（一个方法的参数可能会有多个。）【结果集一般配合Class类的getSimpleName()方法使用】 |
| public T newInstance(Object … initargs) | 创建对象【参数为创建对象的数据】 |


* 获取Constructor方法

```java
/*
反编译一个类的Constructor构造方法。
 */
class ReflectTest11{
    public static void main(String[] args) throws ClassNotFoundException {
        StringBuilder s = new StringBuilder();

        Class vipClass = Class.forName("javase.reflectBean.Vip");

        //public class UserService {
        s.append(Modifier.toString(vipClass.getModifiers()));
        s.append(" class ");
        s.append(vipClass.getSimpleName());
        s.append("{\n");

        Constructor[] constructors = vipClass.getDeclaredConstructors();
        for (Constructor c : constructors){
            //public Vip(int no, String name, String birth, boolean sex) {
            s.append("\t");
            s.append(Modifier.toString(c.getModifiers()));
            s.append(" ");
//            s.append(c.getName());//包名+类名
            s.append(vipClass.getSimpleName());//类名
            s.append("(");
            Class[] parameterTypes = c.getParameterTypes();
            for (int i = 0; i < parameterTypes.length; i++){
                s.append(parameterTypes[i].getSimpleName());
                if (i != parameterTypes.length - 1 ) s.append(", ");
            }
            s.append("){}\n");
        }

        s.append("}");
        System.out.println(s);
    }
}
```

* 调用Constructor方法创建对象
  * 先获取到这个有参数的构造方法【用ClassgetDeclaredConstructor()方法获取】
  * 调用构造方法new对象【用Constructor类的newInstance()方法new对象】

```java
/*
比上一个例子(ReflectTest11)重要一些！！！

通过反射机制调用构造方法实例化java对象。（这个不是重点）
 */
class ReflectTest12{
    public static void main(String[] args) throws Exception {
        //不适用反射创建对象
        Vip vip1 = new Vip();
        Vip vip2 = new Vip(123, "zhangsan", "2001-10-19", false);

        //使用反射机制创建对象（以前）
        Class vipClass = Class.forName("javase.reflectBean.Vip");
        // 调用无参数构造方法
        Object obj1 = vipClass.newInstance();//Class类的newInstance方法
        System.out.println(obj1);

        //使用反射机制创建对象（现在）
        // 调用有参数的构造方法怎么办？
        // 第一步：先获取到这个有参数的构造方法
        Constructor c1 = vipClass.getDeclaredConstructor(int.class, String.class, String.class, boolean.class);
        // 第二步：调用构造方法new对象
        Object obj2 = c1.newInstance(321, "lsi", "1999-10-11", true);//Constructor类的newInstance方法
        System.out.println(obj2);

        // 获取无参数构造方法
        Constructor c2 = vipClass.getDeclaredConstructor();
        Object obj3 = c2.newInstance();
        System.out.println(obj3);
    }
}
```


### 获取一个类的父类以及实现的接口
两个方法【Class类中的】

* public native Class<? super T> getSuperclass()
* public Class<?>[] getInterfaces()