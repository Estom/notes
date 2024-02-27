
> 参考文献https://blog.csdn.net/javalingyu/article/details/124800644

## 1 简介


Jstat名称：Java Virtual Machine statistics monitoring tool

官方文档：
https://docs.oracle.com/javase/1.5.0/docs/tooldocs/share/jstat.html


功能介绍：
Jstat是JDK自带的一个轻量级小工具。它位于java的bin目录下，主要利用JVM内建的指令对Java应用程序的资源和性能进行实时的命令行的监控，包括了对Heap size和垃圾回收状况的监控。


## 2 用法

### 使用说明

```

C:\Users\Administrator>jstat -help
Usage: jstat -help|-options
       jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]
 
Definitions:
  <option>      An option reported by the -options option
  <vmid>        Virtual Machine Identifier. A vmid takes the following form:
                     <lvmid>[@<hostname>[:<port>]]
                Where <lvmid> is the local vm identifier for the target
                Java virtual machine, typically a process id; <hostname> is
                the name of the host running the target Java virtual machine;
                and <port> is the port number for the rmiregistry on the
                target host. See the jvmstat documentation for a more complete
                description of the Virtual Machine Identifier.
  <lines>       Number of samples between header lines.
  <interval>    Sampling interval. The following forms are allowed:
                    <n>["ms"|"s"]
                Where <n> is an integer and the suffix specifies the units as
                milliseconds("ms") or seconds("s"). The default units are "ms".
  <count>       Number of samples to take before terminating.
```

### 参数说明

```java
option：参数选项
    -class 用于查看类加载情况的统计,包括已经加载和未加载的类。
    -compiler 用于查看HotSpot中即时编译器编译情况的统计
    -gc 用于查看JVM中堆的垃圾收集情况的统计
    -gccapacity 用于查看新生代、老生代及持久代的存储容量情况
    -gcmetacapacity 显示metaspace的大小
    -gcnew 用于查看新生代垃圾收集的情况
    -gcnewcapacity 用于查看新生代存储容量的情况
    -gcold 用于查看老生代及持久代垃圾收集的情况
    -gcoldcapacity 用于查看老生代的容量
    -gcutil 显示垃圾收集信息
    -gccause 显示垃圾回收的相关信息（通-gcutil）,同时显示最后一次仅当前正在发生的垃圾收集的原因
    -printcompilation 输出JIT编译的方法信息
-t：可以在打印的列加上Timestamp列，用于显示系统运行的时间
-h：可以在周期性数据输出的时候，指定输出多少行以后输出一次表头
vmid：Virtual Machine ID（ 进程的 pid）
interval：执行每次的间隔时间，单位为毫秒
count：用于指定输出多少次记录，缺省则会一直打印
```


### 1.-class类加载统计
```
[root@hadoop ~]# jps #先通过jps获取到java进程号（这里是一个zookeeper进程）
3346 QuorumPeerMain
7063 Jps
[root@hadoop ~]# jstat -class 3346 #统计JVM中加载的类的数量与size
Loaded  Bytes  Unloaded  Bytes     Time  
  1527  2842.7        0     0.0       1.02
```
* Loaded:加载类的数量
* Bytes：加载类的size，单位为Byte
* Unloaded：卸载类的数目
* Bytes：卸载类的size，单位为Byte
* Time：加载与卸载类花费的时间

### 2.-compiler 编译统计
```
[root@hadoop ~]# jstat -compiler 3346 #用于查看HotSpot中即时编译器编译情况的统计
Compiled Failed Invalid   Time   FailedType FailedMethod
     404      0       0     0.19          0 
```
* Compiled：编译任务执行数量
* Failed：编译任务执行失败数量
* Invalid：编译任务执行失效数量
* Time：编译任务消耗时间
* FailedType：最后一个编译失败任务的类型
* FailedMethod：最后一个编译失败任务所在的类及方法

### 3.-gc 垃圾回收统计
```
[root@hadoop ~]# jstat -gc 3346 #用于查看JVM中堆的垃圾收集情况的统计
 S0C    S1C    S0U    S1U      EC       EU        OC         OU       MC     MU    CCSC   CCSU   YGC     YGCT    FGC    FGCT     GCT  
128.0  128.0   0.0   128.0   1024.0   919.8    15104.0     2042.4   8448.0 8130.4 1024.0 996.0       7    0.019   0      0.000    0.019
```

* S0C：年轻代中第一个survivor（幸存区）的容量 （字节）
* S1C：年轻代中第二个survivor（幸存区）的容量 (字节)
* S0U：年轻代中第一个survivor（幸存区）目前已使用空间 (字节)
* S1U：年轻代中第二个survivor（幸存区）目前已使用空间 (字节)
* EC：年轻代中Eden（伊甸园）的容量 (字节)
* EU：年轻代中Eden（伊甸园）目前已使用空间 (字节)
* OC：Old代的容量 (字节)
* OU：Old代目前已使用空间 (字节)
* MC：metaspace(元空间)的容量 (字节)
* MU：metaspace(元空间)目前已使用空间 (字节)
* CCSC：当前压缩类空间的容量 (字节)
* CCSU：当前压缩类空间目前已使用空间 (字节)
* YGC：从应用程序启动到采样时年轻代中gc次数
* YGCT：从应用程序启动到采样时年轻代中gc所用时间(s)
* FGC：从应用程序启动到采样时old代(全gc)gc次数
* FGCT：从应用程序启动到采样时old代(全gc)gc所用时间(s)
* GCT：从应用程序启动到采样时gc用的总时间(s)

### 4.-gccapacity 堆内存统计
```
[root@hadoop ~]# jstat -gccapacity 3346 #用于查看新生代、老生代及持久代的存储容量情况
 NGCMN    NGCMX     NGC     S0C   S1C       EC      OGCMN      OGCMX       OGC         OC       MCMN     MCMX      MC     CCSMN    CCSMX     CCSC    YGC    FGC
  1280.0  83264.0   1280.0  128.0  128.0   1024.0    15104.0   166592.0    15104.0    15104.0      0.0 1056768.0   8448.0      0.0 1048576.0   1024.0      7     0
[root@hadoop ~]# jstat -gccapacity -h5 3346 1000 #-h5：每5行显示一次表头 1000：每1秒钟显示一次，单位为毫秒
 NGCMN    NGCMX     NGC     S0C   S1C       EC      OGCMN      OGCMX       OGC         OC       MCMN     MCMX      MC     CCSMN    CCSMX     CCSC    YGC    FGC
  1280.0  83264.0   1280.0  128.0  128.0   1024.0    15104.0   166592.0    15104.0    15104.0      0.0 1056768.0   8448.0      0.0 1048576.0   1024.0      7     0
  1280.0  83264.0   1280.0  128.0  128.0   1024.0    15104.0   166592.0    15104.0    15104.0      0.0 1056768.0   8448.0      0.0 1048576.0   1024.0      7     0
  1280.0  83264.0   1280.0  128.0  128.0   1024.0    15104.0   166592.0    15104.0    15104.0      0.0 1056768.0   8448.0      0.0 1048576.0   1024.0      7     0
  1280.0  83264.0   1280.0  128.0  128.0   1024.0    15104.0   166592.0    15104.0    15104.0      0.0 1056768.0   8448.0      0.0 1048576.0   1024.0      7     0
  1280.0  83264.0   1280.0  128.0  128.0   1024.0    15104.0   166592.0    15104.0    15104.0      0.0 1056768.0   8448.0      0.0 1048576.0   1024.0      7     0
 NGCMN    NGCMX     NGC     S0C   S1C       EC      OGCMN      OGCMX       OGC         OC       MCMN     MCMX      MC     CCSMN    CCSMX     CCSC    YGC    FGC
  1280.0  83264.0   1280.0  128.0  128.0   1024.0    15104.0   166592.0    15104.0    15104.0      0.0 1056768.0   8448.0      0.0 1048576.0   1024.0      7     0
  1280.0  83264.0   1280.0  128.0  128.0   1024.0    15104.0   166592.0    15104.0    15104.0      0.0 1056768.0   8448.0      0.0 1048576.0   1024.0      7     0
  1280.0  83264.0   1280.0  128.0  128.0   1024.0    15104.0   166592.0    15104.0    15104.0      0.0 1056768.0   8448.0      0.0 1048576.0   1024.0      7     0
  1280.0  83264.0   1280.0  128.0  128.0   1024.0    15104.0   166592.0    15104.0    15104.0      0.0 1056768.0   8448.0      0.0 1048576.0   1024.0      7     0
```

* NGCMN：年轻代(young)中初始化(最小)的大小(字节)
* NGCMX：年轻代(young)的最大容量 (字节)
* NGC：年轻代(young)中当前的容量 (字节)
* S0C：年轻代中第一个survivor（幸存区）的容量 (字节)
* S1C：年轻代中第二个survivor（幸存区）的容量 (字节)
* EC：年轻代中Eden（伊甸园）的容量 (字节)
* OGCMN：old代中初始化(最小)的大小 (字节)
* OGCMX：old代的最大容量(字节)
* OGC：old代当前新生成的容量 (字节)
* OC：Old代的容量 (字节)
* MCMN：metaspace(元空间)中初始化(最小)的大小 (字节)
* MCMX：metaspace(元空间)的最大容量 (字节)
* MC：metaspace(元空间)当前新生成的容量 (字节)
* CCSMN：最小压缩类空间大小
* CCSMX：最大压缩类空间大小
* CCSC：当前压缩类空间大小
* YGC：从应用程序启动到采样时年轻代中gc次数
* FGC：从应用程序启动到采样时old代(全gc)gc次数

### 5.-gcmetacapacity 元数据空间统计
```
[root@hadoop ~]# jstat -gcmetacapacity 3346 #显示元数据空间的大小
MCMN MCMX MC CCSMN CCSMX CCSC YGC FGC FGCT GCT
0.0 1056768.0 8448.0 0.0 1048576.0 1024.0 8 0 0.000 0.020
```

* MCMN：最小元数据容量
* MCMX：最大元数据容量
* MC：当前元数据空间大小
* CCSMN：最小压缩类空间大小
* CCSMX：最大压缩类空间大小
* CCSC：当前压缩类空间大小
* YGC：从应用程序启动到采样时年轻代中gc次数
* FGC：从应用程序启动到采样时old代(全gc)gc次数
* FGCT：从应用程序启动到采样时old代(全gc)gc所用时间(s)
* GCT：从应用程序启动到采样时gc用的总时间(s)


### 6.-gcnew 新生代垃圾回收统计
```
[root@hadoop ~]# jstat -gcnew 3346 #用于查看新生代垃圾收集的情况
S0C S1C S0U S1U TT MTT DSS EC EU YGC YGCT
128.0 128.0 67.8 0.0 1 15 64.0 1024.0 362.2 8 0.020　　
```
* S0C：年轻代中第一个survivor（幸存区）的容量 (字节)
* S1C：年轻代中第二个survivor（幸存区）的容量 (字节)
* S0U：年轻代中第一个survivor（幸存区）目前已使用空间 (字节)
* S1U：年轻代中第二个survivor（幸存区）目前已使用空间 (字节)
* TT：持有次数限制
* MTT：最大持有次数限制
* DSS：期望的幸存区大小
* EC：年轻代中Eden（伊甸园）的容量 (字节)
* EU：年轻代中Eden（伊甸园）目前已使用空间 (字节)
* YGC：从应用程序启动到采样时年轻代中gc次数
* YGCT：从应用程序启动到采样时年轻代中gc所用时间(s)

### 7.-gcnewcapacity 新生代内存统计
```
[root@hadoop ~]# jstat -gcnewcapacity 3346 #用于查看新生代存储容量的情况
NGCMN NGCMX NGC S0CMX S0C S1CMX S1C ECMX EC YGC FGC
1280.0 83264.0 1280.0 8320.0 128.0 8320.0 128.0 66624.0 1024.0 8 0
```
* NGCMN：年轻代(young)中初始化(最小)的大小(字节)
* NGCMX：年轻代(young)的最大容量 (字节)
* NGC：年轻代(young)中当前的容量 (字节)
* S0CMX：年轻代中第一个survivor（幸存区）的最大容量 (字节)
* S0C：年轻代中第一个survivor（幸存区）的容量 (字节)
* S1CMX：年轻代中第二个survivor（幸存区）的最大容量 (字节)
* S1C：年轻代中第二个survivor（幸存区）的容量 (字节)
* ECMX：年轻代中Eden（伊甸园）的最大容量 (字节)
* EC：年轻代中Eden（伊甸园）的容量 (字节)
* YGC：从应用程序启动到采样时年轻代中gc次数
* FGC：从应用程序启动到采样时old代(全gc)gc次数


### 8.-gcold 老年代垃圾回收统计
```
[root@hadoop ~]# jstat -gcold 3346 #用于查看老年代及持久代垃圾收集的情况
MC MU CCSC CCSU OC OU YGC FGC FGCT GCT
8448.0 8227.5 1024.0 1003.7 15104.0 2102.2 8 0 0.000 0.020　
```

* MC：metaspace(元空间)的容量 (字节)
* MU：metaspace(元空间)目前已使用空间 (字节)
* CCSC：压缩类空间大小
* CCSU：压缩类空间使用大小
* OC：Old代的容量 (字节)
* OU：Old代目前已使用空间 (字节)
* YGC：从应用程序启动到采样时年轻代中gc次数
* FGC：从应用程序启动到采样时old代(全gc)gc次数
* FGCT：从应用程序启动到采样时old代(全gc)gc所用时间(s)
* GCT：从应用程序启动到采样时gc用的总时间(s)


### 9.-gcoldcapacity 老年代内存统计
```
[root@hadoop ~]# jstat -gcoldcapacity 3346 #用于查看老年代的容量
OGCMN OGCMX OGC OC YGC FGC FGCT GCT
15104.0 166592.0 15104.0 15104.0 8 0 0.000 0.020
```
* OGCMN：old代中初始化(最小)的大小 (字节)
* OGCMX：old代的最大容量(字节)
* OGC：old代当前新生成的容量 (字节)
* OC：Old代的容量 (字节)
* YGC：从应用程序启动到采样时年轻代中gc次数
* FGC：从应用程序启动到采样时old代(全gc)gc次数
* FGCT：从应用程序启动到采样时old代(全gc)gc所用时间(s)
* GCT：从应用程序启动到采样时gc用的总时间(s)

### 10.-gcutil 垃圾回收统计
```
[root@hadoop ~]# jstat -gcutil 3346 #显示垃圾收集信息
S0 S1 E O M CCS YGC YGCT FGC FGCT GCT
52.97 0.00 42.10 13.92 97.39 98.02 8 0.020 0 0.000 0.020　
```

* S0：年轻代中第一个survivor（幸存区）已使用的占当前容量百分比
* S1：年轻代中第二个survivor（幸存区）已使用的占当前容量百分比
* E：年轻代中Eden（伊甸园）已使用的占当前容量百分比
* O：old代已使用的占当前容量百分比
* M：元数据区已使用的占当前容量百分比
* CCS：压缩类空间已使用的占当前容量百分比
* YGC ：从应用程序启动到采样时年轻代中gc次数
* YGCT ：从应用程序启动到采样时年轻代中gc所用时间(s)
* FGC ：从应用程序启动到采样时old代(全gc)gc次数
* FGCT ：从应用程序启动到采样时old代(全gc)gc所用时间(s)
* GCT：从应用程序启动到采样时gc用的总时间(s)

### 11.-gccause
```
[root@hadoop ~]# jstat -gccause 3346 #显示垃圾回收的相关信息（通-gcutil）,同时显示最后一次或当前正在发生的垃圾回收的诱因
S0 S1 E O M CCS YGC YGCT FGC FGCT GCT LGCC GCC
52.97 0.00 46.09 13.92 97.39 98.02 8 0.020 0 0.000 0.020 Allocation Failure No GC
```

* LGCC：最后一次GC原因
* GCC：当前GC原因（No GC 为当前没有执行GC）

### 12.-printcompilation JVM编译方法统计
```
[root@hadoop ~]# jstat -printcompilation 3346 #输出JIT编译的方法信息
Compiled Size Type Method
421 60 1 sun/nio/ch/Util$2 clear
```
* Compiled：编译任务的数目
* Size：方法生成的字节码的大小
* Type：编译类型
* Method：类名和方法名用来标识编译的方法。类名使用/做为一个命名空间分隔符。方法名是给定类中的方法。上述格式是由-XX:+PrintComplation选项进行设置的

### 远程监控

与jps一样，jstat也支持远程监控，同样也需要开启安全授权，方法参照jps。

``` 
C:\Users\Administrator>jps 192.168.146.128
3346 QuorumPeerMain
3475 Jstatd
C:\Users\Administrator>jstat -gcutil 3346@192.168.146.128
  S0     S1     E      O      M     CCS    YGC     YGCT    FGC    FGCT     GCT
 52.97   0.00  65.15  13.92  97.39  98.02      8    0.020     0    0.000    0.020
```