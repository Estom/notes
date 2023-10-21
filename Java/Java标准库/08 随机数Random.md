
## 2 Random

### 简介

在 Java中要生成一个指定范围之内的随机数字有两种方法：一种是调用 Math 类的 random() 方法，一种是使用 Random 类。

Random()：该构造方法使用一个和当前系统时间对应的数字作为种子数，然后使用这个种子数构造 Random 对象。
Random(long seed)：使用单个 long 类型的参数创建一个新的随机数生成器。

Random 类提供的所有方法生成的随机数字都是均匀分布的，也就是说区间内部的数字生成的概率是均等的

### 实例

```java
package cn.itcast.demo1;
 
import java.util.Random;//使用时需要先导包
import java.util.Scanner;
 
 
public class RAndom {
    public static void main(String[] args) {
        Random r = new Random();//以系统自身时间为种子数
        int i = r.nextInt();
        System.out.println("i"+i);
        Scanner sc  =new Scanner(System.in);
        int j = sc.nextInt();
        Random r2 = new Random(j);//自定义种子数
        Random r3 = new Random(j);//这里是为了验证上方的注意事项：Random类是伪随机，相同种子数相同次数产生的随机数相同
        int num  = r2.nextInt();
        int num2 = r3.nextInt();
        System.out.println("num"+num);
        System.out.println("num2"+num2);
    }
}
```

### 常用方法

| random.nextInt() | 返回值为整数,范围是int类型范围 |
|---|---|
| random.nextLong() | 返回值为长整型，范围是long类型的范围 |
| random.nextFloat() | 返回值为小数，范围是[0,0.1] |
| random.nextDouble() | 返回值为小数，范围是[0,0.1] |
| random.nextBoolean（） | 返回值为boolean值，true和false概率相同 |
| radom.nextGaussian() | 返回值为呈高斯（“正态”）分布的 double 值，其平均值是 0.0，标准差是 1.0 |
