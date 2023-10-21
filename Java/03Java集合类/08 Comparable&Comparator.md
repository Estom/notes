
## Comparable

### 概述
Java Comparable接口，用于根据对象的natural order对array或对象list进行natural order 。 元素的自然排序是通过在对象中实现其compareTo()方法来实现的。
```java
public interface Comparable<T> 
{
    public int compareTo(T o);
}
```

### 使用
```java
import java.time.LocalDate;
 
public class Employee implements Comparable<Employee> {
 
    private Long id;
    private String name;
    private LocalDate dob;
     
    @Override
    public int compareTo(Employee o) 
    {
        return this.getId().compareTo( o.getId() );
    }
}

```
* 使用Collections.sort（）方法对对象list进行排序。
* 使用Arrays.sort（）方法对对象array进行排序。
* Collections.reverseOrder()


## 2 Comparator比较器

我们还是先研究这个方法

`public static <T> void sort(List<T> list)`:将集合中元素按照默认规则排序。

不过这次存储的是字符串类型。

```java
public class CollectionsDemo2 {
    public static void main(String[] args) {
        ArrayList<String>  list = new ArrayList<String>();
        list.add("cba");
        list.add("aba");
        list.add("sba");
        list.add("nba");
        //排序方法
        Collections.sort(list);
        System.out.println(list);
    }
}
```

结果：

```
[aba, cba, nba, sba]
```


* 使用Collections.sort(list, Comparator)方法按提供的比较器实例施加的顺序对对象list进行排序。
* 使用Arrays.sort(array, Comparator)方法按提供的比较器实例施加的顺序对对象array进行排序。

### Comparator.compare()

* ` public int compare(String o1, String o2)`：比较其两个参数的顺序。

> 两个对象比较的结果有三种：大于，等于，小于。
>
> 如果要按照升序排序，
> 则o1 小于o2，返回（负数），相等返回0，01大于02返回（正数）
> 如果要按照降序排序
> 则o1 小于o2，返回（正数），相等返回0，01大于02返回（负数）

操作如下:

```java
public class CollectionsDemo3 {
    public static void main(String[] args) {
        ArrayList<String> list = new ArrayList<String>();
        list.add("cba");
        list.add("aba");
        list.add("sba");
        list.add("nba");
        //排序方法  按照第一个单词的降序
        Collections.sort(list, new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                return o2.charAt(0) - o1.charAt(0);
            }
        });
        System.out.println(list);
    }
}
```

结果如下：

```
[sba, nba, cba, aba]
```

### Collections.comparing()
该实用程序方法接受一个为类提取排序键的函数。 本质上，这是一个将对类对象进行排序的字段。

```java
//Order by name
Comparator.comparing(Employee::getName);
 
//Order by name in reverse order
Comparator.comparing(Employee::getName).reversed();
 
//Order by id field
Comparator.comparing(Employee::getId);
 
//Order by employee age
Comparator.comparing(Employee::getDate);

ArrayList<Employee> list = new ArrayList<>();
         
list.add(new Employee(22l, "Lokesh", LocalDate.now()));
list.add(new Employee(30l, "Bob", LocalDate.now()));
list.add(new Employee(18l, "Alex", LocalDate.now()));
list.add(new Employee(5l, "David", LocalDate.now()));
list.add(new Employee(600l, "Charles", LocalDate.now()));
 
Collections.sort(list, Comparator.comparing( Employee::getName ).reversed());
 
System.out.println(list);
```

### Collections.thenComparing()
此实用程序方法用于group by sort 。

```java
//Order by name and then by age
Comparator.comparing(Employee::getName)
            .thenComparing(Employee::getDob);
 
//Order by name -> date of birth -> id 
Comparator.comparing(Employee::getName)
            .thenComparing(Employee::getDob)
            .thenComparing(Employee::getId);

ArrayList<Employee> list = new ArrayList<>();
         
list.add(new Employee(22l, "Lokesh", LocalDate.now()));
list.add(new Employee(30l, "Lokesh", LocalDate.now()));
list.add(new Employee(18l, "Alex", LocalDate.now()));
list.add(new Employee(5l, "Lokesh", LocalDate.now()));
list.add(new Employee(600l, "Charles", LocalDate.now()));
 
Comparator<Employee> groupByComparator = Comparator.comparing(Employee::getName)
                                        .thenComparing(Employee::getDob)
                                        .thenComparing(Employee::getId);
 
Collections.sort(list, groupByComparator);
 
System.out.println(list);

```
### Collections.reverseOrder()
此实用程序方法返回一个比较器，该比较器对实现Comparable接口的对象集合强加natural ordering或total ordering的逆序。

```java
//Reverse of natural order as specified in 
//Comparable interface's compareTo() method 
 
Comparator.reversed();
 
//Reverse of order by name
 
Comparator.comparing(Employee::getName).reversed();

```

## 3 简述Comparable和Comparator两个接口的区别

**Comparable**：强行对实现它的每个类的对象进行整体排序。这种排序被称为类的自然排序，类的compareTo方法被称为它的自然比较方法。只能在类中实现compareTo()一次，不能经常修改类的代码实现自己想要的排序。实现此接口的对象列表（和数组）可以通过Collections.sort（和Arrays.sort）进行自动排序，对象可以用作有序映射中的键或有序集合中的元素，无需指定比较器。

**Comparator**：强行对某个对象进行整体排序。可以将Comparator 传递给sort方法（如Collections.sort或 Arrays.sort），从而允许在排序顺序上实现精确控制。还可以使用Comparator来控制某些数据结构（如有序set或有序映射）的顺序，或者为那些没有自然顺序的对象collection提供排序。