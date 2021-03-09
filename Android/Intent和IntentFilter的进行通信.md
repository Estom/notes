**\>intent对象的描述**

-   intent的理解

intent用来表示自己的意图：需要启动哪个Activity。两个Activity可以吧需要交换的数据封装成Bundle对象，然后使用Intent来携带Bundle对象，这样就实现了两个Activity对象之间的数据交换

-   组件的启动方法

    1.  Activity

        -   startActivity(intent)

        -   startActivity(intent,int)

    2.  Service

        -   StartService(Intent)

        -   bindService(inten,seviceConnection,int)

    3.  BroadcastReceiver

        -   sendBroadcast(intent)

        -   sendBroadcast(intetn,String)

        -   sendOrderedBroadcast(intent,String,BraodcastReceiver,Handler,int,String,Bundle)

        -   sendOrderedBroadcast(intet,String)

        -   sendStickyBroadcast(intent)

        -   sendStickyOrderedBroadcast(intent,resultReceiver,scheduler,initialCode,String,Bundle)

-   包含的属性

Component,Action,Category,Data,Type,Extra,Flag

**\>intent的属性及intent-filter配置**

-   Component属性

    -   intent设定component属性的方法：

setClass(Context packageContext,Class

Intent intetn = new
Intent();intetn.setAction(MainActivity.CRAZYIT\_ACTION);startActivity(intent)

-   1

-   2

-   3

-   Category属性的配置

可以通过add

是一个字符串，为Action增加额外的附加信息。可以指定多个Category要求

-   intent-filter的配置，这是被启动的Activity的配置文件，配置的事目标activity的intent属性，这个是activity的唯一标识。

    开始有点理解这些东西了，可能就是一个用来交互的实体类，对于每一个对象的唯一身份标识，只需要创建一个这个实体，就能通过相同的方式启动类，并且通过Bundle传递相应的参数。

\<intent-filter\> \<action android:name="android.intent.action.MAIN" /\>
\<category android:name="android.intent.category.LAUNCHER" /\>\</intent-filter\>

-   1

-   2

-   3

-   4

-   指定Action、Category调用系统的Activity

    1.  ACTION_MAIN

    2.  ACTION_VIEW

    3.  ACTON_ATTACH_DATA

    4.  ACTION_ATTACH_DATA

    5.  ACTION_EDIT。。。。。。。

    6.  CATAGORY_DEFAULT

    7.  CATEGORY_BROWSABLE

    8.  CATEGORY_TAB

-   在intent-filter中，设置用户访问手机的权限

**\>PendingIntent介绍**

-   有条件的intent

pendingIntent是一种特殊的Intent。主要的区别在于Intent的执行立刻的，而pendingIntent的执行不是立刻的。pendingIntent执行的操作实质上是参数传进来的Intent的操作，但是使用pendingIntent的目的在于它所包含的Intent的操作的执行是需要满足某些条件的。

-   调用作用域

PendingIntent可以看作是对Intent的包装。PendingIntent主要持有的信息是它所包装的Intent和当前Application的Context。正由于PendingIntent中保存有当前Application的Context，使它赋予其他程序一种执行的Intent的能力，就算在执行时当前Application已经不存在了，也能通过存在PendingIntent里的Context照样执行Intent
