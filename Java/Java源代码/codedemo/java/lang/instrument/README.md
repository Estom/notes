# 一、Instrumentation入门

* [FirstTransformer.java](FirstTransformer.java) 处理字节码，由类FirstInstrumentation执行
* [FirstInstrumentation.java](FirstInstrumentation.java) instrumentation入口类，由javaagent载入执行
* [build.xml](build.xml) Ant脚本，负责编译、打包和运行

在当前目录下执行命令：
```bash
ant
```

输出信息如下：
>     [java] instrument with options:"Hello, Instrumentation"
>     [java] >>> java/lang/invoke/MethodHandleImpl
>     [java] >>> java/lang/invoke/MethodHandleImpl$1
>     [java] >>> java/lang/invoke/MethodHandleImpl$2
>     [java] >>> java/util/function/Function
>     [java] >>> java/lang/invoke/MethodHandleImpl$3
>     [java] >>> java/lang/invoke/MethodHandleImpl$4
>     [java] >>> java/lang/ClassValue
>     [java] >>> java/lang/ClassValue$Entry
>     [java] >>> java/lang/ClassValue$Identity
>     [java] >>> java/lang/ClassValue$Version
>     [java] >>> java/lang/invoke/MemberName$Factory
>     [java] >>> java/lang/invoke/MethodHandleStatics
>     [java] >>> java/lang/invoke/MethodHandleStatics$1
>     [java] >>> sun/misc/PostVMInitHook
>     [java] >>> sun/usagetracker/UsageTrackerClient
>     [java] >>> java/util/concurrent/atomic/AtomicBoolean
>     [java] >>> sun/usagetracker/UsageTrackerClient$1
>     [java] >>> sun/usagetracker/UsageTrackerClient$4
>     [java] >>> sun/usagetracker/UsageTrackerClient$3
>     [java] >>> java/io/FileOutputStream$1
>     [java] >>> sun/launcher/LauncherHelper
>     [java] >>> cn/aofeng/demo/java/lang/instrument/Hello
>     [java] >>> sun/launcher/LauncherHelper$FXHelper
>     [java] >>> java/lang/Class$MethodArray
>     [java] >>> java/lang/Void
>     [java] >>> java/lang/Shutdown
>     [java] >>> java/lang/Shutdown$Lock
