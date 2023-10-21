## 1 System


### 比较有用的方法
```java
static void setIn(InputStream in)     // 标准输入的重定向
static void setOut(PrintStream out)   // 标准输出的重定向
static void setErr(PrintStream err)   // 标准错误的重定向
/******************************/
static Map<String,String> getenv()    // 返回所有的环境变量的键值对
static String getenv(String name)     // 返回特定环境变量的值
/******************************/
static Properties getProperties()     // 返回所有的系统属性
static String getProperty(String key) // 返回特定的系统属性的值
/******************************/
static void setProperties(Properties props)         // 设置所有的系统属性
static String setProperty(String key, String value) // 设置特定的系统属性的值
/******************************/
static long currentTimeMillis()    // 获取当前系统时间，用毫秒表示，从 1970 年开始。HotSpot VM 中可用
```

### arraycopy(…)方法

arraycopy(…)方法将指定原数组中的数据从指定位置复制到目标数组的指定位置。

```java
static void arraycopy(Object src,  int srcPos, Object dest, int destPos, int length)
```

```java
package com.ibelifly.commonclass.system;

public class Test1 {
    public static void main(String[] args) {
        int[] arr={23,45,20,67,57,34,98,95};
        int[] dest=new int[8];
        System.arraycopy(arr,4,dest,4,4);
        for (int x:dest) {
            System.out.print(x+" ");
        }
    }
}
```

### exit(int status)方法

exit(int status)方法用于终止当前运行的Java虚拟机。如果参数是0，表示正常退出JVM；如果参数非0，表示异常退出JVM。

```java
package com.ibelifly.commonclass.system;

public class Test4 {
    public static void main(String[] args) {
        System.out.println("程序开始了");
        System.exit(0); //因为此处已经终止当前运行的Java虚拟机，故不会执行之后的代码
        System.out.println("程序结束了");
    }
}
```