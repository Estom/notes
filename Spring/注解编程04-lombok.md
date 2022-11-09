


## 17 Lombok
### @Slf4j
自动生成该类的 log 静态常量，要打日志就可以直接打，不用再手动 new log 静态常量。
```java
public class User{
    private static final Logger log = LoggerFactory.getLogger(User.class);
    public static void main(String[] args){
        log.info("hi");
    }
}
@Slf4j
public class User{
    public static void main(String[] args){
        log.info("hi");
    }
}
```
### @Log4j2
注解在类上。为类提供一个属性名为log 的 log4j 日志对象，和@Log4j注解类似。

### @Setter
注解在属性上。为属性提供 setting 方法。

### @Getter
注解在属性上。为属性提供 getting 方法。

### @ToString
生成toString方法，默认情况下，会输出类名、所有属性，属性会按照顺序输出，以逗号分割。

### @EqualsAndHashCode
默认情况下，会使用所有非瞬态(non-transient)和非静态(non-static)字段来生成equals和hascode方法，也可以指定具体使用哪些属性。

如果某些变量不想要加进判断，可以透过 exclude 排除，也可以使用 of 指定某些字段。
```java
@EqualsAndHashCode(exclude = "name")
public class User{
    private String name;
    private Integer age;
}
```

### @Data
注解在类上。等同于添加如下注解：
```java
@Getter/@Setter

@ToString

@EqualsAndHashCode

@RequiredArgsConstructor
```


### @NoArgsConstructor

注解在类上。为类提供一个无参的构造方法。

### @AllArgsConstructor

 注解在类上。为类提供一个全参的构造方法
### @RequiredArgsConstructor

生成一个包含 "特定参数"的构造器，特定参数指的是那些有加上 final 修饰词的变量。

### @NonNull
注解在属性上，如果注解了，就必须不能为Null。

### @Nullable
注解在属性上，如果注解了，就必须可以为Null。

### @Value
也是整合包，但是他会把所有的变量都设成 final 的，其他的就跟 @Data 一样，等于同时加了以下注解：
```java
@Getter (注意没有setter)

@ToString

@EqualsAndHashCode

@RequiredArgsConstructor
```

### @Builder
自动生成流式 set 值写法，从此之[By cnblogs.com/GoCircle]后再也不用写一堆 setter 了。

注意，虽然只要加上 @Builder 注解，我们就能够用流式写法快速设定对象的值，但是 setter 还是必须要写不能省略的，因为 Spring 或是其他框架有很多地方都会用到对象的 getter/setter 对他们取值/赋值。

所以通常是 @Data 和 @Builder 会一起用在同个类上，既方便我们流式写代码，也方便框架做事。
