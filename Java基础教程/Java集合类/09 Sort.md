## 1 数组排序Arrays.sort
Java程序使用Arrays.sort()方法升序排序
```java
import java.util.Arrays;
 
public class JavaSortExample 
{    
    public static void main(String[] args) 
    {
        //Unsorted array
        Integer[] numbers = new Integer[] { 15, 11, 9, 55, 47, 18, 520, 1123, 366, 420 };
         
        //Sort the array
        Arrays.sort(numbers);
         
        //Print array to confirm
        System.out.println(Arrays.toString(numbers));
    }
}
```
### 逆序

```java
Integer[] numbers = new Integer[] { 15, 11, 9, 55, 47, 18, 520, 1123, 366, 420 };
 
//Sort the array in reverse order
Arrays.sort(numbers, Collections.reverseOrder());
 
//Print array to confirm
System.out.println(Arrays.toString(numbers));
```

### 部分排序

```java
//Unsorted array
Integer[] numbers = new Integer[] { 15, 11, 9, 55, 47, 18, 1123, 520, 366, 420 };
 
//Sort the array
Arrays.sort(numbers, 2, 6);
 
//Print array to confirm
System.out.println(Arrays.toString(numbers));
```

### 并发排序

它将数组分解为不同的子数组，并且每个子数组在different threads使用Arrays.sort()进行排序。 最终，所有排序的子数组将合并为一个数组。

```java
Arrays.parallelSort(numbers);
 
Arrays.parallelSort(numbers, 2, 6);
 
Arrays.parallelSort(numbers, Collections.reverseOrder());
```


> 不支持集合排序。转换为列表，然后排序，然后转换为集合。
> 不支持map排序。获取keyset，然后排序访问。
> 但是treeSet和TreeMap本身都是排序好的。

## 2 字符串排序方法

### Stream API
使用Stream.sorted() API对字符串的字符进行排序的示例。

```java
String randomString = "adcbgekhs";
         
String sortedChars = Stream.of( randomString.split("") )
                        .sorted()
                        .collect(Collectors.joining());
 
System.out.println(sortedChars);    // abcdeghks
```

### Arrays.sort()
使用Arrays.sort()方法对字符串排序的示例。

```java
String randomString = "adcbgekhs";
         
//Convert string to char array
char[] chars = randomString.toCharArray();  
 
//Sort char array
Arrays.sort(chars);
 
//Convert char array to string
String sortedString = String.valueOf(chars);
 
System.out.println(sortedChars);    // abcdeghks
```


## 3 ArraysList排序

### 自带的sort方法

```java
//Unsorted list
List<String> names = Arrays.asList("Alex", "Charles", "Brian", "David");  
 
//1. Natural order
names.sort( Comparator.comparing( String::toString ) ); 
 
System.out.println(names);
 
//2. Reverse order
names.sort( Comparator.comparing( String::toString ).reversed() );  
 
System.out.println(names);
```

### Collections.sort

```java
//Unsorted list
List<String> names = Arrays.asList("Alex", "Charles", "Brian", "David");  
 
//1. Natural order
Collections.sort(names);
 
System.out.println(names);
 
//2. Reverse order
Collections.sort(names, Collections.reverseOrder());    
 
System.out.println(names);
```

### Stream

```java
//Unsorted list
List<String> names = Arrays.asList("Alex", "Charles", "Brian", "David");
 
//1. Natural order
List<String> sortedNames = names                          
.stream()
.sorted(Comparator.comparing(String::toString))
.collect(Collectors.toList());  
 
System.out.println(sortedNames);
 
//2. Reverse order
List<String> reverseSortedNames = names                   
    .stream()
    .sorted(Comparator.comparing(String::toString).reversed())
    .collect(Collectors.toList());
 
System.out.println(reverseSortedNames);
```

## 4 ObjectSort

将Comparable&Comparator

