# 深克隆和浅克隆有什么区别？它的实现方式有哪些？

使用克隆可以为我们快速地构建出一个已有对象的副本，它属于 Java 基础的一部分，也是面试中常被问到的知识点之一。

我们本课时的面试题是，什么是浅克隆和深克隆？如何实现克隆？

## 典型回答

浅克隆（Shadow Clone）是把原型对象中成员变量为值类型的属性都复制给克隆对象，把原型对象中成员变量为引用类型的引用地址也复制给克隆对象，也就是原型对象中如果有成员变量为引用对象，则此引用对象的地址是共享给原型对象和克隆对象的。

简单来说就是浅克隆只会复制原型对象，但不会复制它所引用的对象，如下图所示：

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200605211316.png)

深克隆（Deep Clone）是将原型对象中的所有类型，无论是值类型还是引用类型，都复制一份给克隆对象，也就是说深克隆会把原型对象和原型对象所引用的对象，都复制一份给克隆对象，如下图所示：

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200605211420.png)

在 Java 语言中要实现克隆则需要实现 Cloneable 接口，并重写 Object 类中的 clone() 方法，实现代码如下：

```java
public class CloneExample {
    public static void main(String[] args) throws CloneNotSupportedException {
        // 创建被赋值对象
        People p1 = new People();
        p1.setId(1);
        p1.setName("Java");
        // 克隆 p1 对象
        People p2 = (People) p1.clone();
        // 打印名称
        System.out.println("p2:" + p2.getName());
    }
    static class People implements Cloneable {
        // 属性
        private Integer id;
        private String name;
        /**
         * 重写 clone 方法
         * @throws CloneNotSupportedException
         */
        @Override
        protected Object clone() throws CloneNotSupportedException {
            return super.clone();
        }
        public Integer getId() {
            return id;
        }
        public void setId(Integer id) {
            this.id = id;
        }
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
    }
}
```

以上程序执行的结果为：

```
p2:Java
```

## 考点分析
克隆相关的面试题不算太难，但因为使用频率不高，因此很容易被人忽略，面试官通常会在一面或者二面的时候问到此知识点，和它相关的面试题还有以下这些：

* 在 java.lang.Object 中对 clone() 方法的约定有哪些？
* Arrays.copyOf() 是深克隆还是浅克隆？
* 深克隆的实现方式有几种？
* Java 中的克隆为什么要设计成，既要实现空接口 Cloneable，还要重写 Object 的 clone() 方法？
  

# 知识扩展

## 1. clone() 源码分析
要想真正的了解克隆，首先要从它的源码入手，代码如下：

```java
/**
 * Creates and returns a copy of this object.  The precise meaning
 * of "copy" may depend on the class of the object. The general
 * intent is that, for any object {@code x}, the expression:
 * <blockquote>
 * <pre>
 * x.clone() != x</pre></blockquote>
 * will be true, and that the expression:
 * <blockquote>
 * <pre>
 * x.clone().getClass() == x.getClass()</pre></blockquote>
 * will be {@code true}, but these are not absolute requirements.
 * While it is typically the case that:
 * <blockquote>
 * <pre>
 * x.clone().equals(x)</pre></blockquote>
 * will be {@code true}, this is not an absolute requirement.
 * <p>
 * By convention, the returned object should be obtained by calling
 * {@code super.clone}.  If a class and all of its superclasses (except
 * {@code Object}) obey this convention, it will be the case that
 * {@code x.clone().getClass() == x.getClass()}.
 * <p>
 * By convention, the object returned by this method should be independent
 * of this object (which is being cloned).  To achieve this independence,
 * it may be necessary to modify one or more fields of the object returned
 * by {@code super.clone} before returning it.  Typically, this means
 * copying any mutable objects that comprise the internal "deep structure"
 * of the object being cloned and replacing the references to these
 * objects with references to the copies.  If a class contains only
 * primitive fields or references to immutable objects, then it is usually
 * the case that no fields in the object returned by {@code super.clone}
 * need to be modified.
 * <p>
 * ......
 */
protected native Object clone() throws CloneNotSupportedException;
```

从以上源码的注释信息中我们可以看出，Object 对 clone() 方法的约定有三条：

* 对于所有对象来说，x.clone() !=x 应当返回 true，因为克隆对象与原对象不是同一个对象；

* 对于所有对象来说，x.clone().getClass() == x.getClass() 应当返回 true，因为克隆对象与原对象的类型是一样的；

* 对于所有对象来说，x.clone().equals(x) 应当返回 true，因为使用 equals 比较时，它们的值都是相同的。


除了注释信息外，我们看 clone() 的实现方法，发现 clone() 是使用 native 修饰的本地方法，因此执行的性能会很高，并且它返回的类型为 Object，因此在调用克隆之后要把对象强转为目标类型才行。

## 2. Arrays.copyOf()
如果是数组类型，我们可以直接使用 Arrays.copyOf() 来实现克隆，实现代码如下：

```java
People[] o1 = {new People(1, "Java")};
People[] o2 = Arrays.copyOf(o1, o1.length);
// 修改原型对象的第一个元素的值
o1[0].setName("Jdk");
System.out.println("o1:" + o1[0].getName());
System.out.println("o2:" + o2[0].getName());
```

以上程序的执行结果为：

```
o1:jdk
o2:jdk
```

从结果可以看出，我们在修改克隆对象的第一个元素之后，原型对象的第一个元素也跟着被修改了，这说明 Arrays.copyOf() 其实是一个浅克隆。

因为数组比较特殊数组本身就是引用类型，因此在使用 Arrays.copyOf() 其实只是把引用地址复制了一份给克隆对象，如果修改了它的引用对象，那么指向它的（引用地址）所有对象都会发生改变，因此看到的结果是，修改了克隆对象的第一个元素，原型对象也跟着被修改了。

## 3. 深克隆实现方式汇总
深克隆的实现方式有很多种，大体可以分为以下几类：

* 所有对象都实现克隆方法；

* 通过构造方法实现深克隆；

* 使用 JDK 自带的字节流实现深克隆；

* 使用第三方工具实现深克隆，比如 Apache Commons Lang；

* 使用 JSON 工具类实现深克隆，比如 Gson、FastJSON 等。

接下来我们分别来实现以上这些方式，在开始之前先定义一个公共的用户类，代码如下：

```java
/**
 * 用户类
 */
public class People {
    private Integer id;
    private String name;
    private Address address; // 包含 Address 引用对象
    // 忽略构造方法、set、get 方法
}
/**
 * 地址类
 */
public class Address {
    private Integer id;
    private String city;
    // 忽略构造方法、set、get 方法
}
```

可以看出在 People 对象中包含了一个引用对象 Address。

### 1.所有对象都实现克隆

这种方式我们需要修改 People 和 Address 类，让它们都实现 Cloneable 的接口，让所有的引用对象都实现克隆，从而实现 People 类的深克隆，代码如下：

```java
public class CloneExample {
    public static void main(String[] args) throws CloneNotSupportedException {
          // 创建被赋值对象
          Address address = new Address(110, "北京");
          People p1 = new People(1, "Java", address);
          // 克隆 p1 对象
          People p2 = p1.clone();
          // 修改原型对象
          p1.getAddress().setCity("西安");
          // 输出 p1 和 p2 地址信息
          System.out.println("p1:" + p1.getAddress().getCity() +
                  " p2:" + p2.getAddress().getCity());
    }
    /**
     * 用户类
     */
    static class People implements Cloneable {
        private Integer id;
        private String name;
        private Address address;
        /**
         * 重写 clone 方法
         * @throws CloneNotSupportedException
         */
        @Override
        protected People clone() throws CloneNotSupportedException {
            People people = (People) super.clone();
            people.setAddress(this.address.clone()); // 引用类型克隆赋值
            return people;
        }
        // 忽略构造方法、set、get 方法
    }
    /**
     * 地址类
     */
    static class Address implements Cloneable {
        private Integer id;
        private String city;
        /**
         * 重写 clone 方法
         * @throws CloneNotSupportedException
         */
        @Override
        protected Address clone() throws CloneNotSupportedException {
            return (Address) super.clone();
        }
        // 忽略构造方法、set、get 方法
    }
}
```

以上程序的执行结果为：

```
p1:西安 p2:北京
```

从结果可以看出，当我们修改了原型对象的引用属性之后，并没有影响克隆对象，这说明此对象已经实现了深克隆。

### 2.通过构造方法实现深克隆

《Effective Java》 中推荐使用构造器（Copy Constructor）来实现深克隆，如果构造器的参数为基本数据类型或字符串类型则直接赋值，如果是对象类型，则需要重新 new 一个对象，实现代码如下：

```java
public class SecondExample {
    public static void main(String[] args) throws CloneNotSupportedException {
        // 创建对象
        Address address = new Address(110, "北京");
        People p1 = new People(1, "Java", address);

        // 调用构造函数克隆对象
        People p2 = new People(p1.getId(), p1.getName(),
                new Address(p1.getAddress().getId(), p1.getAddress().getCity()));

        // 修改原型对象
        p1.getAddress().setCity("西安");

        // 输出 p1 和 p2 地址信息
        System.out.println("p1:" + p1.getAddress().getCity() +
                " p2:" + p2.getAddress().getCity());
    }

    /**
     * 用户类
     */
    static class People {
        private Integer id;
        private String name;
        private Address address;
        // 忽略构造方法、set、get 方法
    }

    /**
     * 地址类
     */
    static class Address {
        private Integer id;
        private String city;
        // 忽略构造方法、set、get 方法
    }
}
```

以上程序的执行结果为：

```
p1:西安 p2:北京
```

从结果可以看出，当我们修改了原型对象的引用属性之后，并没有影响克隆对象，这说明此对象已经实现了深克隆。

### 3.通过字节流实现深克隆

通过 JDK 自带的字节流实现深克隆的方式，是要先将原型对象写入到内存中的字节流，然后再从这个字节流中读出刚刚存储的信息，来作为一个新的对象返回，那么这个新对象和原型对象就不存在任何地址上的共享，这样就实现了深克隆，代码如下：

```java
import java.io.*;

public class ThirdExample {
    public static void main(String[] args) throws CloneNotSupportedException {
        // 创建对象
        Address address = new Address(110, "北京");
        People p1 = new People(1, "Java", address);

        // 通过字节流实现克隆
        People p2 = (People) StreamClone.clone(p1);

        // 修改原型对象
        p1.getAddress().setCity("西安");

        // 输出 p1 和 p2 地址信息
        System.out.println("p1:" + p1.getAddress().getCity() +
                " p2:" + p2.getAddress().getCity());
    }

    /**
     * 通过字节流实现克隆
     */
    static class StreamClone {
        public static <T extends Serializable> T clone(People obj) {
            T cloneObj = null;
            try {
                // 写入字节流
                ByteArrayOutputStream bo = new ByteArrayOutputStream();
                ObjectOutputStream oos = new ObjectOutputStream(bo);
                oos.writeObject(obj);
                oos.close();
                // 分配内存,写入原始对象,生成新对象
                ByteArrayInputStream bi = new ByteArrayInputStream(bo.toByteArray());//获取上面的输出字节流
                ObjectInputStream oi = new ObjectInputStream(bi);
                // 返回生成的新对象
                cloneObj = (T) oi.readObject();
                oi.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return cloneObj;
        }
    }

    /**
     * 用户类
     */
    static class People implements Serializable {
        private Integer id;
        private String name;
        private Address address;
        // 忽略构造方法、set、get 方法
    }

    /**
     * 地址类
     */
    static class Address implements Serializable {
        private Integer id;
        private String city;
        // 忽略构造方法、set、get 方法
    }
}
```

以上程序的执行结果为：

```
p1:西安 p2:北京
```

此方式需要注意的是，由于是通过字节流序列化实现的深克隆，因此每个对象必须能被序列化，必须实现 Serializable 接口，标识自己可以被序列化，否则会抛出异常 (java.io.NotSerializableException)。

### 4.通过第三方工具实现深克隆

本课时使用 Apache Commons Lang 来实现深克隆，实现代码如下：

```java
import org.apache.commons.lang3.SerializationUtils;

import java.io.Serializable;

/**
 * 深克隆实现方式四：通过 apache.commons.lang 实现
 */
public class FourthExample {
    public static void main(String[] args) throws CloneNotSupportedException {
        // 创建对象
        Address address = new Address(110, "北京");
        People p1 = new People(1, "Java", address);

        // 调用 apache.commons.lang 克隆对象
        People p2 = (People) SerializationUtils.clone(p1);

        // 修改原型对象
        p1.getAddress().setCity("西安");

        // 输出 p1 和 p2 地址信息
        System.out.println("p1:" + p1.getAddress().getCity() +
                " p2:" + p2.getAddress().getCity());
    }

    /**
     * 用户类
     */
    static class People implements Serializable {
        private Integer id;
        private String name;
        private Address address;
        // 忽略构造方法、set、get 方法
    }

    /**
     * 地址类
     */
    static class Address implements Serializable {
        private Integer id;
        private String city;
        // 忽略构造方法、set、get 方法
    }
}
```

以上程序的执行结果为：

```
p1:西安 p2:北京
```

可以看出此方法和第三种实现方式类似，都需要实现 Serializable 接口，都是通过字节流的方式实现的，只不过这种实现方式是第三方提供了现成的方法，让我们可以直接调用。

### 5.通过 JSON 工具类实现深克隆

本课时我们使用 Google 提供的 JSON 转化工具 Gson 来实现，其他 JSON 转化工具类也是类似的，实现代码如下：

```java
import com.google.gson.Gson;

/**
 * 深克隆实现方式五：通过 JSON 工具实现
 */
public class FifthExample {
    public static void main(String[] args) throws CloneNotSupportedException {
        // 创建对象
        Address address = new Address(110, "北京");
        People p1 = new People(1, "Java", address);

        // 调用 Gson 克隆对象
        Gson gson = new Gson();
        People p2 = gson.fromJson(gson.toJson(p1), People.class);

        // 修改原型对象
        p1.getAddress().setCity("西安");

        // 输出 p1 和 p2 地址信息
        System.out.println("p1:" + p1.getAddress().getCity() +
                " p2:" + p2.getAddress().getCity());
    }

    /**
     * 用户类
     */
    static class People {
        private Integer id;
        private String name;
        private Address address;
        // 忽略构造方法、set、get 方法
    }

    /**
     * 地址类
     */
    static class Address {
        private Integer id;
        private String city;
        // 忽略构造方法、set、get 方法
    }
}
```

以上程序的执行结果为：

```
p1:西安 p2:北京
```

使用 JSON 工具类会先把对象转化成字符串，再从字符串转化成新的对象，因为新对象是从字符串转化而来的，因此不会和原型对象有任何的关联，这样就实现了深克隆，其他类似的 JSON 工具类实现方式也是一样的。

### 6. 克隆设计理念猜想
对于克隆为什么要这样设计，官方没有直接给出答案，我们只能凭借一些经验和源码文档来试着回答一下这个问题。Java 中实现克隆需要两个主要的步骤，一是 实现 Cloneable 空接口，二是重写 Object 的 clone() 方法再调用父类的克隆方法 (super.clone())，那为什么要这么做？

从源码中可以看出 Cloneable 接口诞生的比较早，JDK 1.0 就已经存在了，因此从那个时候就已经有克隆方法了，那我们怎么来标识一个类级别对象拥有克隆方法呢？克隆虽然重要，但我们不能给每个类都默认加上克隆，这显然是不合适的，那我们能使用的手段就只有这几个了：

* 在类上新增标识，此标识用于声明某个类拥有克隆的功能，像 final 关键字一样；
* 使用 Java 中的注解；
* 实现某个接口；
* 继承某个类。

先说第一个，为了一个重要但不常用的克隆功能， 单独新增一个类标识，这显然不合适；再说第二个，因为克隆功能出现的比较早，那时候还没有注解功能，因此也不能使用；第三点基本满足我们的需求，第四点和第一点比较类似，为了一个克隆功能需要牺牲一个基类，并且 Java 只能单继承，因此这个方案也不合适。采用排除法，无疑使用实现接口的方式是那时最合理的方案了，而且在 Java 语言中一个类可以实现多个接口。

那为什么要在 Object 中添加一个 clone() 方法呢？

因为 clone() 方法语义的特殊性，因此最好能有 JVM 的直接支持，既然要 JVM 直接支持，就要找一个 API 来把这个方法暴露出来才行，最直接的做法就是把它放入到一个所有类的基类 Object 中，这样所有类就可以很方便地调用到了。

# 小结 

本课时我们讲了浅克隆和深克隆的概念，以及 Object 对 clone() 方法的约定；还演示了数组的 copyOf() 方法其实为浅克隆，以及深克隆的 5 种实现方式；最后我们讲了 Java 语言中克隆的设计思路猜想。