4# 第四章Activity和Fragment（2）

----

## &gt;Activity的回调机制
----

* **回调机制的解释**
	通用程序框架在完成整个应用个通用功能和流程时，在特定点上需要相应的业务逻辑实现。（java swing中的init()方法，java Thread中的run（）方法，都是一种回调机制）
* **回调机制的存在形式**
	1. 以接口的形式存在
	2. 以抽象方法的形式存在，通过oncreate、onActivityResult()函数能够直接创建一个Activity，例如当有一个Activity被调用时（生成相应的实例时）就会通过onCreate方法创建一个Activity。

## &gt;Activity的生命周期

-----
* 四个状态
	1. 运行状态：当前Activity位于前台，用户可见，可以获得焦点。
	2. 暂停状态：其他Activity位于前台，该activity依然可见，但不能获得焦点
	3. 停止状态：该activity不可见失去焦点
	4. 销毁状态：activity结束。
* 生命周期示例图
	![Activity的生命周期](http://img.my.csdn.net/uploads/201109/1/0_1314838777He6C.gif)

* Activity的四种加载模式
	1. standard:标准模式  
		每次启动Activityandroid都会启动一个新的实例，并通过Activity添加到当前的task栈顶，就相当于同一个类会有多个对象同时在运行。
	2. sigleTop:Task栈顶单例模式  
		与standard模式基本相同，但是当要启动的类本身就位于栈顶事，那么将不会重新创建Activity实例，而是复用之前的Activity。
	3. sigleTask:Task内单例模式
		在同一个task中只允许有一种实例。不存在创建，存在移动到栈顶显示。
	4. sigleInstace:全局单利模式
		无论从哪个任务中启动Activity都会只创建一个单一的实例。

> android 采用task栈对Activity进行管理，先启动的放在 task栈底，后启动的Activity被放在了task栈顶。

## &gt;Fragment详解

-----

* **Fragment的简介**  
	Fragment代表了Activity的子模块，因此可以吧Fragment理解成Activity片段。Fragment拥有自己的生命周期，能够接受自己的输入事件。
	* Fragment总作为Activity的界面组成部分。Fragment可调用getActivity()方法返回Activity，Activity可以使用FragmentManager来管理相应的Fragment
	* Fragment的add(),remove(),replace()方法可以动态地添加、删除或者替换Fragment。
	* 一个Activity可以痛死组合多个Fragment；一个Fragment 也可以被多个Activity复用。
	* Fragment可以响应自己的输入输出事件，有自己的生命周期。但是收到Activity的控制。
	>Fragment主要是为了简化大屏手机的UI的设计。

* **创建Fragment**  
	onCreate()系统创建Fragment回调的方法  
	onCreateView()当Fragment绘制界面时回调这个方法   
	onPause()用户离开Fragment后回调的方法

## &gt;Fragment与Activity通信
----

* 在布局文件中使用<Fragment.../>元素添加Fragment  
	```
	<Fragment
		android:name="org.BookListFragment" //指定Fragment的实现类
		Android:id="@+id/book_list"
		Android:layout_height="match_parent"
		android:layout_weight="1"/>
	```
* 在java代码中通过FragmentManager对象实现。getFragmentManager()返回FragmentManager，beginTransaction()启动返回FragmentTransaction对象。

## &gt;Fragment管理与Fragment事物

----

* FragmentManager可以完成的功能
	* FragmentManager.findFragmentById()/...ByTag()获取指定的Fragment  
	* popBackStack()将Fragment从后台栈中弹出
	* 调用addOnBackStackChangeListener()注册监听器
	* add()
	* remove()
	* commit()
	* replace()

## &gt;Fragment 的生命周期

----

* 四种不同的状态
	* 运行状态,fragment位于前台获取焦点
	* 暂停状态,activity位于前台Fragment可见
	* 停止状态，Fragment不可见失去焦点
	* 销毁状态，fragment被删除。

* 生命周期的控制函数。
	> 以下的函数都是回调函数，在不同的时间被触发调用
	* onAttach()当Fragment被添加到Activity中时
	* onCreate()创建Fragment时
	* onActivityCreated()当所在Fragment所在的Activity被启动时
	* onCreateView()每次创建绘制该Fragment的View组件时
	* onStart()启动Fragment时
	* onResume()恢复Fragment时
	* onPause()暂停Fragment时
	* onStop()停止Fragment时
	* onDestroyView()销毁Fragment包含的组件时
	* onDestroy()销毁Fragment时
	* onDetach()将该Fragment从Activity中删除时