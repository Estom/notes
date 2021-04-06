# Android的HelloWorld级别的问题解决

--------------

## &gt;附加知识补充

----

> 1. sdk manager管理Android开发环境和系统镜像的文件夹
2. avd manager管理Android虚拟设备的工具,我们自己创建的avd设备存放在.android的目录下面。
3. android device monitorAndroid的状态监视工具和控制台命令窗口
4. android debug bridge（adb）Android的调试工具

----

>使用eclipse创建Android程序比Androidstudio困难n倍，毕竟自己小白，不懂一些原理，所以导致helloworld小程序的各种难产。

## &gt; Android创建过程中的版本问题

* 首先在高版本的Android sdk中提供了对低版本Android sdk的支持，这种支持不是直接兼容低版本的东西，而是通过支持库包来时线即Android Support Library package来保证高版本的sdk的向下兼容性，也就是说让低版本的sdk能够运行高版本的功能。其中：  
	V4 Support Library支持API4及更高版本的Android sdk  
	V7-----------------------7-----------------------  
	V9-----------------------9-----------------------  
	V13----------------------13----------------------  
	V17----------------------17----------------------  
* 在libs的文件夹目录下会产生低版本兼容库，Android-support-v4或者v7等，这与你在创建工程时选择的最低兼容sdk版本有关。另外，如果选择的编译版本较高时，会产生一个单独的兼容文件夹，并且会报错（此错误网上有解决方法，经测试，没几个可行的）


## &gt;关于style.xml/AppTheme相关的问题

------

解决这个问题主要有三种方法，参考：  
http://www.jianshu.com/p/6ad7864e005e  
（给的原理说明十分清晰）

1. 将所有values下的styles.xml都改为同样的最基础版本的theme，即baseTheme里的基本主题
2. 如果想使用最新的主题效果，可以可以将AndroidManifest.xml里的minSdkVersion改成14（及已经包含此主题的sdk）
3. 如果想兼容更低版本并且支持新主题，需要导入支持库，即Android-support-v7-appcompat库，下载完成后通过导入工程的方式，将这个库导入到相应的文件当中。在libs目录下回有兼容库包。（具体方法参考原网站）  

## &gt;Android使用过程中图标的导入问题

------

android:icon="@drawable/bear"变量的值经常出错，在制定文件夹下面并没有对应的图标需要插入自己导入的图标然后修改这个变量的值。


## &gt;关于Android启动模拟器失败的解决方法

--------

> Dx unsupported class file version 52.0

* 首先创建虚拟设备，对应相应的sdk，然后运行虚拟设备，继续讲程序launch到虚拟设备当中，其间出现这样的错误，在其他网站上已经有比较详细的说明：  
	这个问题主要的原因是依赖包的编译版本比主程序的编译版本高，导致主程序无法正常编译或运行，解决这个问题无非两招：
     1. 提升主程序的编译器版本，用最新的编译器编译主程序，这样就可以兼容那个依赖包
     2. 降低依赖包的编译版本。

具体方法参考：  
http://blog.csdn.net/feijitouhaha/article/details/52141274  



