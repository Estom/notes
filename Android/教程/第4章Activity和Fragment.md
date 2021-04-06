# 第四章Activity与Fragment的应用

----


## &gt;建立配置和使用Activity

----

* activity能够提供许多不同的操作页面，它们做成Activity栈，当前活动的应用位于栈顶。
* **LauncherActivity&&ArrayAdapter**  
	每一个列表项对应一个intent，用于保存启动不同的activity的相关信息。
	intentForPostion（）提供了位置和不同activity对应的信息，将列表项链接到制定的intent。

* **ExpandableListActivity&&ExpandableListAdapter**
	设置界面显示过程中，使用了适配器的相关函数，其中复写的函数能够自动调用生成相应的界面。
	* getChild()获得子字表的内容
	* getChildID()获得子表的id
	* getChildrenCount()获得子表的项目数量
	* TextView()获得每个子表的textView配置
	* getChildView()获得每个子表的textView内容
	* getGroup()获得主表
	* getGroupCount()获得主表的数量
	* getGroupId()获得主表的id
	* getGroupView()决定主表的外观
	* isChildSelectable()返回被选中的子表像
	* hasStableIds()返回id  
	当在ExpandableListActivity中定义Adapter时，这些函数必须都被复写，保证能够生成一个新的列表，就相当于XML对应的配置属性一样，这样才能完整的显示整个表格。

* **PreferenceActivity&&PreferenceFragment**  
	1. 实现了参数设置界面，让Fragment集成了PreferenceFragment
	2. 在onCreate中调用addPreferencFromResource()方法，加载制定的界面布局文件。

* **在manifest.xml中配置多个Activity资源**
	2. 配置多个Activity：  
	```  
        <activity
            android:name=".MainActivity"
            android:label="@string/app_name"
            android:theme="@style/AppTheme.NoActionBar">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
	```

## &gt;启动和关闭Activity
----

* **启动activity的两种方法**
	* context.startActivity(intent)
	* context.startActivity(intent,int)

* **关闭Activity的两种方法**
	* context.finish()
	* context.finishActivity(int)
* **代码示例**
	```
	Intent intent = new Intent(MainActivity.this,SecondActivity.class);
	startActivity(intent);
	```

## &gt;使用Bundle向指定的activity传递数据

----

* **intent携带额外数据的方法**
	* putExtras(Bundle)
	* getExtras()
	* putExtra()
	* getXxxExtra()
	* putXXX(String,XXX)
	* putSeriaLizable(String,Srializagle)
	* getXXX(String)
	* getSerializable(String,Serializable)

* **使用bundle和intent机制向指定的activity传递数据的方法**  
	* 定义方法，向介质添加批数据并且将介质传递给目标activity
	```
	Person p = new Person(name.getText(),toString(),passwd.getText().toString(),gender);
	Bundle data = new Bundle();
	data.putSerializable("person),p);
	Intent intent = new Intent(MainActivity.this,ResultActivity.class);
	intent.putExtras(data);
	startActivity(intent);
	```
	* 使用方法,从传递过来的intent中提取数据
	```
	Intent intent = getIntent();
	Person p = (Person) intent.getSerializableExtra("person");
	```
## &gt;启动Activity并且获取返回结果
* 当前的Activity启动另一个Activity获取它的结果并且返回到当前的Activity。
* **实现方法**
	重写onActivityResult(int requestCode,int resultCode,intent intent)方法（相当于一种回调方法）当被启动的Activity生命周期结束并且返回结果时，该方法将会被触发。
* **实现过程**
	1. 用特殊函数启动另外的activity
	```
	Intent intent = new Intent(MainActivity.this,ResultActivity.class);
	intent.putExtras(data);
	startActivityForResult(intent,0);
	```
	2. 当activity结束时，触发onActivity函数，需要重写它。
	3. 在另外的activity中仍旧需要bundle和intent进行配合传递数据








>对类的补充：  

### Intent类（交互介质）
* **Intent类作用**  
每个应用程序都有若干个Activity组成，每一个Activity都是一个应用程序与用户进行交互的窗口，呈现不同的交互界面。因为每一个Acticity的任务不一样，所以经常互在各个Activity之间进行跳转，在Android中这个动作是靠Intent来完成的。你通过startActivity()方法发送一个Intent给系统，系统会根据这个Intent帮助你找到对应的Activity，即使这个Activity在其他的应用中，也可以用这种方法启动它。  
* **Intent的定义：**  
Intent是Android系统用来抽象描述要执行的一个操作，也可以在不同组件之间进行沟通和消息传递。
Intent意图可以是明确的指定组件的名称，这样你可以精确的启动某个系统组件，比如启动一个Activity。它也可以是模糊的，没有指定组件名称，只要是能够匹配到这个Intent的应用都可以接收到，比如发送一个拍照Intent，所有的拍照应用都会响应。  
* **Intent有以下几个属性：**  
动作(Action),数据(Data),分类(Category),类型(Type),组件(Compent)以及扩展信(Extra)。其中最常用的是Action属性和Data属性。


###Bundle类(批数据，是一个键值对)

* **Bundle类的作用**  
	Bundle主要用于传递数据；它保存的数据，是以key-value(键值对)的形式存在的。我们经常使用Bundle在Activity之间传递数据，传递的数据可以是boolean、byte、int、long、float、double、string等基本类型或它们对应的数组，也可以是对象或对象数组。当Bundle传递的是对象或对象数组时，必须实现Serializable 或Parcelable接口。下面分别介绍Activity之间如何传递基本类型、传递对象。
* **Bundle的定义和使用**
	* 新建一个bundle类  
	view plain copy  
	Bundle mBundle = new Bundle();   
	* bundle类中加入数据（key -value的形式，另一个activity里面取数据的时候，就要用到key，找出对应的value）
	view plain copy  
	mBundle.putString("Data", "data from TestBundle");  
	* 新建一个intent对象，并将该bundle加入这个intent对象
	view plain copy  
	Intent intent = new Intent();   
	intent.setClass(TestBundle.this, Target.class);    
	intent.putExtras(mBundle);    
	* Bundle提供了各种常用类型的putxxx()/getxxx()方法，用于读写基本类型的数据。

## Context类的（主体上下文）

----

* **Context类的定义**  
	 Interface to global information about an application environment. This is an abstract class whose implementationis provided by the Android system. It allows access to application-specific resources and classes, as well as up-calls for application-level operations such as launching activities, broadcasting and receiving intents, etc
* **Context使用场景**
	 1. 它描述的是一个应用程序环境的信息，即上下文。
     2. 该类是一个抽象(abstract class)类，Android提供了该抽象类的具体实现类(后面我们会讲到是ContextIml类)。
     3. 通过它我们可以获取应用程序的资源和类，也包括一些应用级别操作，例如：启动一个Activity，发送广播，接受Intent信息
* **Context类图集成关系**
	![context类图继承关系](http://hi.csdn.net/attachment/201203/1/0_1330607569Vj4c.gif)
* **Context相关的方法**
	* getSystemService(String)获得系统级服务
	* startActivity(Intent)启动一个Activity
	* startService(Intent)启动一个service
	* getSharedPreferences(String, int)
* **Context什自己的理解**
	Context类相当于一个上下文环境，能够很好的统筹一个Activity、service或者app的资源和调度方式，他是负责指挥这些资源的类的接口，他能启动关闭一个app等。
	
### Serializable类

----
> 序列化的内容补充  
> 当两个进程在进行远程通信时，彼此可以发送各种类型的数据。无论是何种类型的数据，都会以二进制序列的形式在网络上传送。发送方需要把这个Java对象转换为字节序列，才能在网络上传送；接收方则需要把字节序列再恢复为Java对象。 把Java对象转换为字节序列的过程称为对象的序列化，把字节序列恢复为Java对象的过程称为对象的反序列化。

* **Serializable接口的定义**
	为了保存在内存中的各种对象的状态（也就是实例变量，不是方法），并且可以把保存的对象状态再读出来。虽然你可以用你自己的各种各样的方法来保存object states，但是Java给你提供一种应该比你自己好的保存对象状态的机制，那就是序列化。
* **使用情况**
	* 当你想把的内存中的对象状态保存到一个文件中或者数据库中时候；
    * 当你想用套接字在网络上传送对象的时候；
    * 当你想通过RMI传输对象的时候；

* **Parcelable和Serializable的区别**
	内存间数据传输时推荐使用Parcelable,activity间传输数据使用Parcelable，是Android特有功能，效率比实现Serializable接口高效，可用于Intent数据传递，也可以用于进程间通信（IPC）   
	保存到本地或者网络传输时推荐使用Serializable

### Parcelable类
* **Parcelable类的作用**
	想要在两个activity之间传递对象，那么这个对象必须序列化，Android中序列化一个对象有两种方式，一种是实现Serializable接口，这个非常简单，只需要声明一下就可以了，不痛不痒。但是android中还有一种特有的序列化方法，那就是实现Parcelable接口，使用这种方式来序列化的效率要高于实现Serializable接口。不过Serializable接口实在是太方便了，因此在某些情况下实现这个接口还是非常不错的选择。 
* **Parcelable类的使用情况**
	* 永久性保存对象，保存对象的字节序列到本地文件中；
	* 通过序列化对象在网络中传递对象；
	* 通过序列化在进程间传递对象。
* **Parcelable接口定义**  
	```
	public interface Parcelable 
	{
    //内容描述接口，基本不用管
    public int describeContents();
    //写入接口函数，打包
    public void writeToParcel(Parcel dest, int flags);
    //读取接口，目的是要从Parcel中构造一个实现了Parcelable的类的实例处理。因为实现类在这里还是不可知的，所以需要用到模板的方式，继承类名通过模板参数传入
    //为了能够实现模板参数的传入，这里定义Creator嵌入接口,内含两个接口函数分别返回单个和多个继承类实例
    public interface Creator<T> 
    {
           public T createFromParcel(Parcel source);
           public T[] newArray(int size);
    }
	}
    ```
* **实现序列化的步骤**
	1. implements Parcelable
	2. 重写writeToParcel方法，将你的对象序列化为一个Parcel对象，即：将类的数据写入外部提供的Parcel中，打包需要传递的数据到Parcel容器保存，以便从 Parcel容器获取数据
	3. 重写describeContents方法，内容接口描述，默认返回0就可以
	4. 实例化静态内部对象CREATOR实现接口Parcelable.Creator