**Activity** 是用户可以执行的单一任务。Activity
负责创建新的窗口供应用绘制和从系统中接收事件。Activity 是用 Java 编写的，扩展自
[Activity](https://classroom.udacity.com/courses/ud851/lessons/93affc67-3f0b-4f9b-b3a4-a7a26f241a86/concepts/developer.android.com/reference/android/app/Activity.html)
类

Activity 会创建**视图**来向用户显示信息，并使用户与 Activity 互动。视图是
Android UI 框架中的类。它们占据了屏幕上的方形区域，负责绘制并处理事件。Activity
通过读取 XML 布局文件确定要创建哪些视图（并放在何处）。正如 Dan 提到的，这些 XML
文件存储在标记为 **layouts** 的 **res 文件夹**内。

Activity
提供视图上的操作，UI类提供视图的展示格式，包括什么样的按钮，什么样的容器，什么样的文本框。

视图类型UI组件（具有互动性）、容器视图）容纳其他的UI组件或者视图。

视图的XML属性：

id,layout\_width,layout_height,layout_gravity,layout_margin,padding,

R 类

当你的应用被编译时，系统会生成
[R](http://developer.android.youdaxue.com/reference/android/R.html)
类。它会创建常量，使你能够动态地确定 res
文件夹的各种内容，包括布局。要了解详情，请参阅关于[资源](http://developer.android.youdaxue.com/guide/topics/resources/accessing-resources.html)的文档。

本质上是 Android 会读取你的 XML 文件并为你的布局文件中的每个标记生成 Java
对象。然后，你可以在 Java 代码中通过对 Java 对象调用方法修改这些对象。
