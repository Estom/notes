第一类:属性值为true或false

android:layout_centerHrizontal 水平居中

android:layout_centerVertical 垂直居中

android:layout_centerInparent 相对于父元素完全居中

android:layout_alignParentBottom 贴紧父元素的下边缘

android:layout_alignParentLeft 贴紧父元素的左边缘

android:layout_alignParentRight 贴紧父元素的右边缘

android:layout_alignParentTop 贴紧父元素的上边缘

android:layout_alignWithParentIfMissing
如果对应的兄弟元素找不到的话就以父元素做参照物

第二类：属性值必须为id的引用名”

android:layout_below 在某元素的下方

android:layout_above 在某元素的的上方

android:layout_toLeftOf 在某元素的左边

android:layout_toRightOf 在某元素的右边

android:layout_alignTop 本元素的上边缘和某元素的的上边缘对齐

android:layout_alignLeft 本元素的左边缘和某元素的的左边缘对齐

android:layout_alignBottom 本元素的下边缘和某元素的的下边缘对齐

android:layout_alignRight 本元素的右边缘和某元素的的右边缘对齐

第三类：属性值为具体的像素值，如30dip，40px

android:layout_marginBottom 离某元素底边缘的距离

android:layout_marginLeft 离某元素左边缘的距离

android:layout_marginRight 离某元素右边缘的距离

android:layout_marginTop 离某元素上边缘的距离

EditText的android:hint 设置EditText为空时输入框内的提示信息。

android:gravity

android:gravity属性是对该view 内容的限定．比如一个button 上面的text.
你可以设置该text
在view的靠左，靠右等位置．以button为例，android:gravity="right"则button上面的文字靠右

android:layout\_gravity

android:layout_gravity是用来设置该view相对与起父view 的位置．比如一个button
在linearlayout里，你想把该button放在靠左、靠右等位置就可以通过该属性设置．以button为例，android:layout_gravity="right"则button靠右

android:scaleType：

android:scaleType是控制图片如何resized/moved来匹对ImageView的size。ImageView.ScaleType
/ android:scaleType值的意义区别：

CENTER /center
按图片的原来size居中显示，当图片长/宽超过View的长/宽，则截取图片的居中部分显示

CENTER_CROP / centerCrop
按比例扩大图片的size居中显示，使得图片长(宽)等于或大于View的长(宽)

CENTER_INSIDE / centerInside
将图片的内容完整居中显示，通过按比例缩小或原来的size使得图片长/宽等于或小于View的长/宽

FIT_CENTER / fitCenter 把图片按比例扩大/缩小到View的宽度，居中显示

FIT_END / fitEnd 把图片按比例扩大/缩小到View的宽度，显示在View的下部分位置

FIT_START / fitStart 把图片按比例扩大/缩小到View的宽度，显示在View的上部分位置

FIT_XY / fitXY 把图片不按比例扩大/缩小到View的大小显示

MATRIX / matrix 用矩阵来绘制，动态缩小放大图片来显示。

\*\* 要注意一点，Drawable文件夹里面的图片命名是不能大写的。

\-------------------------------------------------------------------------------------------------------------------------------------------------------------

android:id

为控件指定相应的ID

android:text

指定控件当中显示的文字，需要注意的是，这里尽量使用strings.xml文件当中的字符串

android:gravity

指定View组件的对齐方式，比如说居中，居右等位置
这里指的是控件中的文本位置并不是控件本身

android:layout\_gravity

指定Container组件的对齐方式．比如一个button
在linearlayout里，你想把该button放在靠左、靠右等位置就可以通过该属性设置．以button为例，android:layout_gravity="right"则button靠右

android:textSize

指定控件当中字体的大小

android:background

指定该控件所使用的背景色，RGB命名法

android:width

指定控件的宽度

android:height

指定控件的高度

android:layout\_width

指定Container组件的宽度

android:layout\_height

指定Container组件的高度

android:layout\_weight

View中很重要的属性，按比例划分空间

android:padding\*

指定控件的内边距，也就是说控件当中的内容

android:sigleLine

如果设置为真的话，则控件的内容在同一行中进行显示

android:scaleType

是控制图片如何resized/moved来匹对ImageView的siz

android:layout\_centerHrizontal

水平居中

android:layout\_centerVertical

垂直居中

android:layout\_centerInparent

相对于父元素完全居中

android:layout\_alignParentBottom

贴紧父元素的下边缘

android:layout\_alignParentLeft

贴紧父元素的左边缘

android:layout\_alignParentRight

贴紧父元素的右边缘

android:layout\_alignParentTop

贴紧父元素的上边缘

android:layout\_alignWithParentIfMissing

如果对应的兄弟元素找不到的话就以父元素做参照物

android:layout\_below

在某元素的下方

android:layout\_above

在某元素的的上方

android:layout\_toLeftOf

在某元素的左边

android:layout\_toRightOf

在某元素的右边

android:layout\_alignTop

本元素的上边缘和某元素的的上边缘对齐

android:layout\_alignLeft

本元素的左边缘和某元素的的左边缘对齐

android:layout\_alignBottom

本元素的下边缘和某元素的的下边缘对齐

android:layout\_alignRight

本元素的右边缘和某元素的的右边缘对齐

android:layout\_marginBottom

离某元素底边缘的距离

android:layout\_marginLeft

离某元素左边缘的距离

android:layout\_marginRight

离某元素右边缘的距离

android:layout\_marginTop

离某元素上边缘的距离

android:paddingLeft

本元素内容离本元素右边缘的距离

android:paddingRight

本元素内容离本元素上边缘的距离

android:hint

设置EditText为空时输入框内的提示信息

android:LinearLayout

它确定了LinearLayout的方向，其值可以为vertical，
表示垂直布局horizontal，表示水平布局

\-----------------------------------------------------------------------------------------------------------------------------------------------------

android:interpolator

可能有很多人不理解它的用法，文档里说的也不太清楚，其实很简单，看下面：interpolator定义一个动画的变化率（the
rate of change）。这使得基本的动画效果(alpha, scale, translate,
rotate）得以加速，减速，重复等。用通俗的一点的话理解就是：动画的进度使用
Interpolator 控制。interpolator
定义了动画的变化速度，可以实现匀速、正加速、负加速、无规则变加速等。Interpolator
是基类，封装了所有 Interpolator 的共同方法，它只有一个方法，即 getInterpolation
(float input)，该方法 maps a point on the timeline to a multiplier to be applied
to the transformations of an animation。Android 提供了几个 Interpolator
子类，实现了不同的速度曲线，如下：

AccelerateDecelerateInterpolator
在动画开始与介绍的地方速率改变比较慢，在中间的时侯加速

AccelerateInterpolator 在动画开始的地方速率改变比较慢，然后开始加速

CycleInterpolator 动画循环播放特定的次数，速率改变沿着正弦曲线

DecelerateInterpolator 在动画开始的地方速率改变比较慢，然后开始减速

LinearInterpolator 在动画的以均匀的速率改变

对于 LinearInterpolator ，变化率是个常数，即 f (x) = x.

public float getInterpolation(float input) {

return input;

}

Interpolator其他的几个子类，也都是按照特定的算法，实现了对变化率。还可以定义自己的
Interpolator 子类，实现抛物线、自由落体等物理效果。

Xml代码

\<!--

FrameLayout ——
里面只可以有一个控件，并且不能设计这个控件的位置，控件会放到左上角

LinearLayout —— 里面可以放多个控件，但是一行只能放一个控件

TableLayout —— 这个要和TableRow配合使用，很像html里面的table

AbsoluteLayout —— 里面可以放多个控件，并且可以自己定义控件的x,y的位置

RelativeLayout —— 里面可以放多个控件，不过控件的位置都是相对位置

(界面的布局好像还可以直接引用一些view，如ScrollView等)

Xml代码

android:orientation ——
它确定了LinearLayout的方向，其值可以为\*vertical，表示垂直布局 \*horizontal，
表示水平布局

Xml代码

android:layout_width ——
指在父控件中当前控件的宽，可以设定其确定的值，但一般使用下面两个值\*fill_parent，填满父控件的空白\*wrap_content，表示大小刚好足够显示当前控件里的内容

Xml代码

android:layout_height ——
指明了在父控件中当前控件的高，可以设定其确定的值，但一般使用下面两个值\*fill_parent，填满父控件的空白\*wrap_content，表示大小刚好足够显示当前控件里的内容

Xml代码

android:id —— 为控件指定相应的ID

Xml代码

android:text ——
指定控件当中显示的文字，需要注意的是，这里尽量使用strings.xml文件当中的字符串

Xml代码

android:grivity ——
指定控件的基本位置，比如说居中，居右等位置。如果是没有子控件的view设置此属性，表示内容的对齐方式；如果是有子控件的view设置此属性，则表示子控件的对齐方式（重力倾向），其值需要多个时，用“\|”分开）

Xml代码

android:textSize —— 指定控件当中字体的大小

Xml代码

android:background ——
指定该控件所使用的背景色,RGB命名法。如果设置一个透明的背景图片按钮android:background="@android:color/transparent"

Xml代码

android:width —— 指定控件的宽度

Xml代码

android:height —— 指定控件的高度

Xml代码

android:padding\* —— 指定控件的内边距，也就是说控件当中的内容

Xml代码

android:sigleLine —— 如果设置为真的话，则将控件的内容在同一行当中进行显示

Xml代码

android:src ——
引用资源，例如：应用另一个XML，android:src="@drawable/imageselector"

Xml代码

android:layout_alignBottom ——
属性是用来与某控件的底部对齐。例如:android:layout\_alignBottom="@id/TVfilepath"

Xml代码

android:layout_marginRight ——
属性设置边缘空白，有上下左右之分。例如:android:layout\_marginRight="3dip"

Xml代码

android:layout_gravity属性设置该控件位于父控件的位置。例如:android:layout\_gravity="center_vertical"

Xml代码

第一类:属性值为true或false

android:layout_centerHorizontal ——
如果值为真，该控件将被至于水平方向的中央(水平居中)

android:layout_centerVertical ——
如果值为真，该控件将被至于垂直方向的中央(垂直居中)

android:layout_centerInParent ——
如果值为真，该控件将被至于父控件水平方向和垂直方向的中央(相对于父元素完全居中 )

android:layout_alignParentBottom ——
如果该值为true，则将该控件的底部和父控件的底部对齐(贴紧父元素的下边缘)

android:layout_alignParentLeft ——
如果该值为true，则将该控件的左边与父控件的左边对齐(贴紧父元素的左边缘)

android:layout_alignParentRight ——
如果该值为true，则将该控件的右边与父控件的右边对齐(贴紧父元素的右边缘)

android:layout_alignParentTop ——
如果该值为true，则将空间的顶部与父控件的顶部对齐(贴紧父元素的上边缘)

android:layout_alignWithParentIfMissing ——
如果对应的兄弟元素找不到的话就以父元素做参照物

Xml代码

第二类：属性值必须为id的引用名“@id/id-name”

android:layout_above —— 将该控件的底部至于给定ID的控件之上(在某元素的的上方)

android:layout_below —— 将该控件的顶部至于给定ID的控件之下(在某元素的下方 )

android:layout_toLeftOf ——
将该控件的右边缘和给定ID的控件的左边缘对齐(在某元素的左边 )

android:layout_toRightOf ——
将该控件的左边缘和给定ID的控件的右边缘对齐(在某元素的左边 )

android:layout_alignTop ——
将给定控件的顶部边缘与给定ID控件的顶部对齐(本元素的上边缘和某元素的的上边缘对齐)

android:layout_alignBottom ——
将该控件的底部边缘与给定ID控件的底部边缘(本元素的下边缘和某元素的的下边缘对齐 )

android:layout_alignLeft ——
将该控件的左边缘与给定ID控件的左边缘对齐(本元素的左边缘和某元素的的左边缘对齐)

android:layout_alignRight ——
将该控件的右边缘与给定ID控件的右边缘对齐(本元素的右边缘和某元素的的右边缘对齐)

android:layout_alignBaseline —— 该控件的baseline和给定ID的控件的baseline对齐

Xml代码

EditText的android:hint

设置EditText为空时输入框内的提示信息。

android:gravity

android:gravity属性是对该view 内容的限定．比如一个button 上面的text.
你可以设置该text
在view的靠左，靠右等位置．以button为例，android:gravity="right"则button上面的文字靠右

android:layout\_gravity

android:layout_gravity是用来 设置该view相对与起父view 的位置．比如一个button
在linearlayout里，你想把该button放在靠左、靠右等位置就可以通过该属性设置．以button为例，android:layout_gravity="right"则button靠右

android:layout\_alignParentRight

使 当前控件的右端和父控件的右端对齐。这里属性值只能为true或false，默认false。

android:scaleType：

android:scaleType是控制图片如何
resized/moved来匹对ImageView的size。ImageView.ScaleType /
android:scaleType值的意义区别：

CENTER /center
按图片的原来size居中显示，当图片长/宽超过View的长/宽，则截取图片的居中部分显示

CENTER_CROP / centerCrop
按比例扩大图片的size居中显示，使得图片长(宽)等于或大于View的长(宽)

CENTER_INSIDE / centerInside
将图片的内容完整居中显示，通过按比例缩小或原来的size使得图片长/宽等于或小于View的长/宽

FIT_CENTER / fitCenter 把图片按比例扩大/缩小到View的宽度，居中显示

FIT_END / fitEnd 把图片按比例扩大/缩小到View的宽度，显示在View的下部分位置

FIT_START / fitStart 把图片按比例扩大/缩小到View的宽度，显示在View的上部分位置

FIT_XY / fitXY 把图片不按比例扩大/缩小到View的大小显示

MATRIX / matrix 用矩阵来绘制，动态缩小放大图片来显示。

\*\* 要注意一点，Drawable文件夹里面的图片命名是不能大写的

\--\>

http://panshengneng.iteye.com/blog/1187928

Layout_margn与padding的区别:

**layout_margn**是指组件距离父窗体的距离，而padding是指组件中的内容距离组件边缘的距离

与子对应的**Layout_grivaty**与**grivaty**这两者有点相似，**layout_grivaty**是指组件相对父窗体显示的位置，而**grivaty**是用来控制组件中的内容显示位置：比如

**layout_grivaty="center_vertical\|center_horizontal"**;表示组件显示是水平居中且垂直居中也就是组件位于屏幕的正中央

Android**:gravity="center_vertical\|center_horizontal"**表示组件中的内容显示位置是正中央。

我们也可以这样来理解，layout_margn与layout_grivaty都与布局有关，控制组件在屏幕中的显示位置

padding与grivaty都是用来控制内容在组件中的显示位置

那么，layout_margn与layout_grivaty有什么区别呢？grivaty与padding又有什么区别呢？

区别：layout_grivaty与grivaty的值都是给定的，我们只能在这些给定的属性中选择

layout_margn与padding的值我们可以任意给，相对于layout_grivaty和grivaty更灵活，我们根据需要选择合适的属性。
