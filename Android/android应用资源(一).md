**\>应用资源概述**

-   访问方式分类

    1.  无法通过R资源清单类访问的原生资源，保存在assets目录下

    2.  可通过R资源清单访问的资源，保存在res目录下

-   源代码按照物理存储形式分类

    1.  界面布局文件

    2.  java资源文件

    3.  资源文件（android应用资源）

-   资源的类型和存储方式

    1.  /res/animator/ 定义属性动画

    2.  /res/anim/ 定义补间动画

    3.  /res/color/ 定义颜色列表

    4.  /res/draWble/ 存放各种位图

    5.  /res/layout/ 存放布局界面

    6.  /res/menu/ 存放菜单资源

    7.  /res/raw/ 存放原生资源（音乐视频）

    8.  /res/value/ 存放简单值，字符串值、整型值、颜色值、数组等

    9.  /res/xml/ 原生的XML内容

-   使用资源

    1.  在java文件中访问，Pacage_name.R.resource_type.resource_name;

        在这里使用的是资源清单，而不是实际资源，所储存到的东西不过是指向资源的一个整型数组。

-   getResources().getText(R.String.main_title)通过引用返回实际资源，用来建立资源副本

Drawable logo = res.getDrawavle(R.drawable.logo);

-   在XML文件中访问，@pacage_name:resource_type/resource_name

**\>字符串、颜色、尺寸资源**

-   颜色值的定义\#ARGB都是十六进制书。

\<String name="CSD"\>这是一个字符串\</String\>

\<color name="c1"\>\#FOO\</color\>

\<dimen name="spacing"\>8dp\</dimen\>

\<bool name="is_male"\> true \</bool\>

-   字符串颜色尺寸资源的使用

\<TextView android:text="@string/app_name"
android:textsize="@dimen/title_font"/\> \<GridView
android:horizontalSpacing=dimen/spacing/GridView\>

-   1

-   2

-   3

-   4

-   5

-   6

-   7

-   在java代码中访问如下

R.color.c1 R.string.c1 R.dimen.cell\_width R.bool.bool\_name

-   1

-   2

-   3

-   4

-   5

**\>数组资源**

-   定义普通数组

\<array name="plain_arr"\> \<item\>@color/c1\</item\> \<item\>@color/c2\</itme\>
\</array\>

-   1

-   2

-   3

-   4

-   定义字符串数组

\<string-array name="plain_arr"\> \<item\>@string/c1\</item\>
\<item\>@string/c2\</itme\> \</string-array\>

-   1

-   2

-   3

-   4

-   定义整型数组

**\>使用Drawable资源**

-   使用方式

@package\_name:drawable/file_namepackage_name.R.drawable.file_name

-   1

-   2

-   StateListDrawable资源

能够根据目标组件的状态切换不同的分辨率图片。

支持的属性

android:stata\_active

android:state\_checkable

android:state\_cheked

android:state\_enable

android:state\_first

android:state\_focused

android:state\_last… …

-   具体使用说明

    1.  在res\\drawnable\\my_image.xml中建立如下内容。本质上是在原来直接显示图片的基础上，进行一次封装，是的显示的图片具有动态变化的效果。

\<sector xmlns:android="http:\\\\"\>\<item android:state_focused="true"
android:color="\#f44"/\>\<item android:state_focused="false"
android:color="\#ccf"/\>

-   1

-   2

-   3

-   4

-   5

**\>使用LayerDrawable资源**

-   能够支持的属性

anroid:drawble，制定图片对象

android:id，指定对象的id

android:buttonm tom left button，指定显示的位置。

-   使用的语法格式

**\>使用ShapeDrawable资源**

-   作用：

用来定义一个基本的图形（矩形、线条、圆形）

-   使用：(下一级标签）

定义了四个角的弧度

定义了渐变色填充

定义了几何形状内边距

定义几何形状的大小

定义使用单种颜色填充

定义为集合形状绘制边框

**\>ClipDrawable资源**

-   作用

从其他位图上截取一个图片片段

-   使用：（这个标签的属性）

android:drawable，指定截取的资源

android:clipOrientation，指定截取的方向

android:gravity，指定截取时的对其方式

**\>AnimationDrable资源**

-   作用：

代表一个动画，相当于逐帧动画，也可以通过平移、变换计算出来的补间动画。

：设置透明度

：图片进行缩放变换

：图片进行位移变换

：图片进行旋转

android:interpolator属性指定变化速度，linear_interpolator/accelerate_interploator/decelerate_interpolator:匀速变化/加速变化/减速变化。

-   使用方法：

    -   在XML文件中访问

@package\_name:anim/file_name

-   在java代码中访问

package.R.anim.file_name

**\>属性动画资源**

-   子类

AnimatorSet、ValueAnimator、ObjectAnimator、TimeAnimator

-   定义属性动画的根元素

    -   \<set\> \</set\>

    -   \<objectAnimator\> \</objectAnimator\>

    -   \<animator\> \</animator\>
