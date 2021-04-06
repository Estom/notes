# android总体知识总结（一）

----

## Activity宏观的介绍

-----

* Activity是一个应用程序窗口，本身不提供用户界面元素，只提供UI组件摆放和依附的容器，视图（View）在layout.xml中定义，Activity.setContentView()方法，将Activity于View建立关联。
* 布局管理器--导演
* Activity--舞台
* View（UI控件）--演员
* 生命周期的每个阶段都有自己的回调函数
	* onCreate
	* onStart
	* onResume
	* onRestrart
	* onPause
	* onStop
	* onDestroy
*  