# android第五章Intent和IntentFilter的进行通信

-----

## &gt;intent对象的描述

----

* intent的理解
	intent用来表示自己的意图：需要启动哪个Activity。两个Activity可以吧需要交换的数据封装成Bundle对象，然后使用Intent来携带Bundle对象，这样就实现了两个Activity对象之间的数据交换

* 组件的启动方法
	1. Activity  
		* startActivity(intent)  
		* startActivity(intent,int)
	2. Service  
		* StartService(Intent)
		* bindService(inten,seviceConnection,int)
	3. BroadcastReceiver
		* sendBroadcast(intent)
		* sendBroadcast(intetn,String)
		* sendOrderedBroadcast(intent,String,BraodcastReceiver,Handler,int,String,Bundle)
		* sendOrderedBroadcast(intet,String)
		* sendStickyBroadcast(intent)
		* sendStickyOrderedBroadcast(intent,resultReceiver,scheduler,initialCode,String,Bundle)
* 包含的属性
	Component,Action,Category,Data,Type,Extra,Flag

## &gt;intent的属性及intent-filter配置

----

* Component属性
	* intent设定component属性的方法：  
	setClass(Context packageContext,Class<?> cls)  
	setClassName(Context packageContext,String className)  
	setClassName(String packageName,String className)  
	分别通过应用环境接口Context类，component类和字符串的方式实现了指定启动对象的方法
	* 启动Activity的中组件的具体方法：
	> MainActivity.this表示自身，在内部使用外部类的时候这样表示。
	```
		ComponentName comp = new ComponentName(MainActivity.this,secondActivity.class）  
		Intent intent = new Intent();  
		intent.setComponent(comp)  
		startActivity(intent)  
	```
* Action属性的配置
	是一个字符串，制定Intent要去完成的一个抽象的动作。Action的值可能是intent.ACTION_VIEW，具体查看什么取决于<intent-filter/>  
	可以通过setAction方法这只Action属性
```
Intent intetn = new Intent();
intetn.setAction(MainActivity.CRAZYIT_ACTION);
startActivity(intent)
```


* Category属性的配置
	可以通过add 
	是一个字符串，为Action增加额外的附加信息。可以指定多个Category要求

* intent-filter的配置，这是被启动的Activity的配置文件，配置的事目标activity的intent属性，这个是activity的唯一标识。
> 开始有点理解这些东西了，可能就是一个用来交互的实体类，对于每一个对象的唯一身份标识，只需要创建一个这个实体，就能通过相同的方式启动类，并且通过Bundle传递相应的参数。

```
<intent-filter>
	<action android:name="android.intent.action.MAIN" />
	<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
```
* 指定Action、Category调用系统的Activity
	1. ACTION_MAIN
	2. ACTION_VIEW
	3. ACTON_ATTACH_DATA
	4. ACTION_ATTACH_DATA
	5. ACTION_EDIT。。。。。。。
	6. CATAGORY_DEFAULT
	7. CATEGORY_BROWSABLE
	8. CATEGORY_TAB

* 在intent-filter中，设置用户访问手机的权限

<user-permission android:name"android.permission.READ_CONTACTS"/>设置按钮，系统返回桌面

* Data，type属性的配置  
	向action提供操作的数据，data属性可以接受一个URI对象（scheme：/host：port/path）  
	content://com.android.contacts/contacts/1  
	tel:123  
	Type属性用来指定Data所对应的URI的MIME类型。
> Toast.makeText(this.intent.toString(),Toast.LENGTH_LONG).show()相当于弹窗程序，可以用来检测数据的值。  

	--在androidManifest.xml中实现data和type属性的配置方法
	<data andriod:mimeType=""
		android:scheme=""
		android:host=""
		android:port=""
		android:path=""
		android:pathPrefix=""
		android:pathPattern=""/>

其中data元素匹配启动的方式是不完全匹配，只要已经显示定义的值相同就能启动相应的activity。其中如果帮同事这只了Action和Data属性，则能够同时通过两者启动Activity。
当启动了多个Activity时，系统会显示打开这个请求的应用选择界面。也就是说，平时会看到的选择某个应用打开这个文档，就是通过这种方式实现的，通过指定Data和Type属性来定位不同的应用。

> 通过Action和data属性的组合应用，可以达到和系统交互信息的功能，就是简单的调用系统固有的组件，启动系统中本身存在的Activity

* Extra属性  
	用来在多个Action之间进行数据交互，Extra是一个Bundle对象，类似于C++中的map类  

* Flag属性  
	为intent添加一些额外的控制标志，通过addFlags()方法实现。
	* FLAG_ACTIVITY_BROUGHT_TO_FRONT不会被杀死的Activity启动。  
	* FLAG_ACTIVITY_CLEAR_TOP弑父线程
	* FLAG_ACTIVITY_NEW_TASK创建一个新的Ativity
	* FLAG_ACTIVITY_NO_ANIMATION不使用过度动画
	* FLAG_ACTIVITY_NO_HISTORY将被启动线程弹出工作栈
	* FLAG_ACTIVITY_REORDER_TO_FRONT带到前台
	* FLAG_ACTIVITY_SINGLE_TOP只会启动一个这样的activity



