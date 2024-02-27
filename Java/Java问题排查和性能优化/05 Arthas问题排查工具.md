## 1 简介

### 概述

Arthas 是Alibaba开源的Java诊断工具。可实时查看应用 load、内存、gc、线程的状态信息，并能在不修改应用代码的情况下，对业务问题进行诊断，包括查看方法调用的出入参、异常，监测方法执行耗时，类加载信息等，大大提升线上问题排查效率。

### 解决的问题

1.这个类从哪个 jar 包加载的？为什么会报各种类相关的 Exception？
2.我改的代码为什么没有执行到？难道是我没 commit？分支搞错了？
3.遇到问题无法在线上 debug，难道只能通过加日志再重新发布吗？
4.线上遇到某个用户的数据处理有问题，但线上同样无法 debug，线下无法重现！
5.是否有一个全局视角来查看系统的运行状况？
6.有什么办法可以监控到JVM的实时运行状态？

### 参考文档

https://blog.csdn.net/ls18802694089/article/details/134678902

https://arthas.gitee.io/doc/quick-start.html

## 2 使用

### 1.下载启动demo java程序

是一个简单的程序，每隔一秒生成一个随机数，再执行质因数分解，并打印出分解结果

```
curl -O https://arthas.aliyun.com/math-game.jar
java -jar math-game.jar
```

### 2.下载启动 arthas

在命令行下面执行（使用和目标进程一致的用户启动，否则可能 attach 失败）：

```
curl -O https://arthas.aliyun.com/arthas-boot.jar
java -jar arthas-boot.jar
```

执行该程序的用户需要和目标进程具有相同的权限。比如以admin用户来执行：

```
sudo su admin && java -jar arthas-boot.jar 
或 
sudo -u admin -EH java -jar arthas-boot.jar
```

如果 attach 不上目标进程，可以查看~/logs/arthas/ 目录下的日志。

如果下载速度比较慢，可以使用 aliyun 的镜像：

```
java -jar arthas-boot.jar --repo-mirror aliyun --use-http
```

打印更多参数信息。`java -jar arthas-boot.jar -h`

启动后会让我们选择java进程，如下

```
$ $ java -jar arthas-boot.jar
* [1]: 35542
  [2]: 71560 math-game.jar
```

如我们的demo 程序是2，则进程是第 2 个，则输入 2，再输入回车/enter。Arthas 会 attach 到目标进程上。

### 依赖JDK

Install OpenJDK-8

```
RUN apt-get update &&     apt-get install -y openjdk-8-jdk &&     apt-get install -y ant &&     apt-get clean;
```

Fix certificate issues

```
RUN apt-get update &&     apt-get install ca-certificates-java &&     apt-get clean &&     update-ca-certificates -f;
```

Setup JAVA_HOME -- useful for docker commandline

```
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME
```


## 3 操作

### jvm相关

```
dashboard - 当前系统的实时数据面板
getstatic - 查看类的静态属性
heapdump - dump java heap, 类似 jmap 命令的 heap dump 功能
jvm - 查看当前 JVM 的信息
logger - 查看和修改 logger
memory - 查看 JVM 的内存信息
ognl - 执行 ognl 表达式
perfcounter - 查看当前 JVM 的 Perf Counter 信息
sysenv - 查看 JVM 的环境变量
sysprop - 查看和修改 JVM 的系统属性
thread - 查看当前 JVM 的线程堆栈信息
vmoption - 查看和修改 JVM 里诊断相关的 option
vmtool - 从 jvm 里查询对象，执行 forceGc
```

### class/classloader 相关

```
classloader - 查看 classloader 的继承树，urls，类加载信息，使用 classloader 去 getResource
dump - dump 已加载类的 byte code 到特定目录
jad - 反编译指定已加载类的源码
mc - 内存编译器，内存编译.java文件为.class文件
redefine - 加载外部的.class文件，redefine 到 JVM 里
retransform - 加载外部的.class文件，retransform 到 JVM 里
sc - 查看 JVM 已加载的类信息
sm - 查看已加载类的方法信息
```

### monitor/watch/trace 相关

ps:请注意，这些命令，都通过字节码增强技术来实现的，会在指定类的方法中插入一些切面来实现数据统计和观测，因此在线上、预发使用时，请尽量明确需要观测的类、方法以及条件，诊断结束要执行 stop 或将增强过的类执行 reset 命令。

```
monitor - 方法执行监控
stack - 输出当前方法被调用的调用路径
trace - 方法内部调用路径，并输出方法路径上的每个节点上耗时
tt - 方法执行数据的时空隧道，记录下指定方法每次调用的入参和返回信息，并能对这些不同的时间下
watch - 方法执行数据观测
```

### profiler/火焰图

```
profiler - 使用async-profiler对应用采样，生成火焰图
jfr - 动态开启关闭 JFR 记录
```

### options/查看或设置 Arthas 全局开关

```
options - 查看或设置 Arthas 全局开关
```

### 管道

```
Arthas 支持使用管道对上述命令的结果进行进一步的处理，如sm java.lang.String * | grep 'index'
grep - 搜索满足条件的结果
plaintext - 将命令的结果去除 ANSI 颜色
wc - 按行统计输出结果
```

### 基础命令

```
base64 - base64 编码转换，和 linux 里的 base64 命令类似
cat - 打印文件内容，和 linux 里的 cat 命令类似
cls - 清空当前屏幕区域
echo - 打印参数，和 linux 里的 echo 命令类似
grep - 匹配查找，和 linux 里的 grep 命令类似
help - 查看命令帮助信息
history - 打印命令历史
keymap - Arthas 快捷键列表及自定义快捷键
pwd - 返回当前的工作目录，和 linux 命令类似
quit - 退出当前 Arthas 客户端，其他 Arthas 客户端不受影响
reset - 重置增强类，将被 Arthas 增强过的类全部还原，Arthas 服务端关闭时会重置所有增强过的类
session - 查看当前会话的信息
stop - 关闭 Arthas 服务端，所有 Arthas 客户端全部退出
tee - 复制标准输入到标准输出和指定的文件，和 linux 里的 tee 命令类似
version - 输出当前目标 Java 进程所加载的 Arthas 版本号
```

## 4 常用命令说明

### dashboard

输入dashboard，按回车/enter，会展示类似如下的进程信息，按ctrl+c可以中断执行

![](https://img-blog.csdnimg.cn/direct/784869fa9dce4d8484e80bb5062c2da3.png)


### thread

![](https://img-blog.csdnimg.cn/direct/bd78c1ea6c3249ab8744239f9921e79e.png)

```
thread -n 5：打印前5个最忙的线程并打印堆栈
thread -all ：显示所有匹配的线程
thread -n 3 -i 1000 ：列出1000ms内最忙的3个线程栈
thread –state WAITING，查看指定状态的线程,（TIMED_WAITI、WAITING、RUNNABLE等等）
thread -b：找出阻塞其他线程的线程,当出现死锁后，会提示你出现死锁的位置，代码如下    static Object obj = new Object();
    public static void main(String[] args) throws InterruptedException, IOException {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    synchronized (obj) {
                        System.out.println("我是第一个线程");
                        Thread.sleep(100000);
                    }
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        },"yexindong-one").start();        Thread.sleep(1000);
        new Thread(new Runnable() {
            @Override
            public void run() {
                synchronized (obj) {
                    System.out.println("我是第二个线程");
                }
            }
        },"yexindong-two").start();
    }
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/7123d492ac794709a00389000198b33a.png)


### jad

这里的反编译用起来比较简单，只需要输入全类名即可反编译源码：jad com.test.Test，执行jad命令后还会打印出类加载器和class文件的所在目录；
除此之外jad还可以反编译类中的某个方法，下面的代码只编译main方法，并且不显示行号，lineNumber默认的值是true，现在我们把它设为false就不显示行号了；

```
jad com.test.Test main --lineNumber false
```

### watch

watch命令可以让用户能方便的观察到指定方法的调用情况。能观察到的范围为：返回值、抛出异常、入参，通过编写 OGNL 表达式进行对应变量的查看。
1、以下命令用于观察方法出参和返回值，

```
watch com.test.Test show "{params,returnObj}" -x 2 -b -e -s -f
```

### trace

trace 命令能主动搜索方法调用路径，，并输出方法路径上的每个节点上耗时，渲染和统计整个调用链路上的所有性能开销和追踪调用链路。
监听Test类下show方法的调用链：trace com.test.Test show

```
[arthas@4805]$ trace com.test.Test show
Press Q or Ctrl+C to abort.
Affect(class count: 1 , method count: 1) cost in 28 ms, listenerId: 2
---ts=2021-07-18 21:41:52;thread_name=main;id=1;is_daemon=false;priority=5;TCCL=sun.misc.Launcher$AppClassLoader@18b4aac2     ---[0.884064ms] com.test.Test:show()
        `---[0.135646ms] com.test.Test:showChild() #38
```


通过结果可以看到，在main线程中show()方法调用了showChild()方法，前面的ms数是调用方法所花费的时间，

调用链属性说明

thread_name ：线程名称
id：内部线程id
is_daemon ： 是否为守护线程
priority：线程优先级
TCCL：类加载器
