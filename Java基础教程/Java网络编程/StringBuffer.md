String与StringBuffer的区别

简单地说，就是一个变量和常量的关系。StringBuffer对象的内容可以修改；而String对象一旦产生后就不可以被修改，重新赋值其实是两个对象。

StringBuffer的内部实现方式和String不同，StringBuffer在进行字符串处理时，不生成新的对象，在内存使用上要优于String类。所以在实际使用时，如果经常需要对一个字符串进行修改，例如插入、删除等操作，使用StringBuffer要更加适合一些。

String:在String类中没有用来改变已有字符串中的某个字符的方法，由于不能改变一个java字符串中的某个单独字符，所以在JDK文档中称String类的对象是不可改变的。然而，不可改变的字符串具有一个很大的优点:编译器可以把字符串设为共享的。

StringBuffer:StringBuffer类属于一种辅助类，可预先分配指定长度的内存块建立一个字符串缓冲区。这样使用StringBuffer类的append方法追加字符
比 String使用 + 操作符添加字符 到 一个已经存在的字符串后面有效率得多。因为使用 +
操作符每一次将字符添加到一个字符串中去时，字符串对象都需要寻找一个新的内存空间来容纳更大的字符串，这无凝是一个非常消耗时间的操作。添加多个字符也就意味着要一次又一次的对字符串重新分配内存。使用StringBuffer类就避免了这个问题。

StringBuffer是线程安全的，在多线程程序中也可以很方便的进行使用，但是程序的执行效率相对来说就要稍微慢一些。

StringBuffer的常用方法

StringBuffer类中的方法要偏重于对字符串的变化例如追加、插入和删除等，这个也是StringBuffer和String类的主要区别。

1、append方法

public StringBuffer append(boolean b)

该方法的作用是追加内容到当前StringBuffer对象的末尾，类似于字符串的连接。调用该方法以后，StringBuffer对象的内容也发生改变，例如：

StringBuffer sb = new StringBuffer(“abc”);

sb.append(true);

则对象sb的值将变成”abctrue”。

使用该方法进行字符串的连接，将比String更加节约内容，例如应用于数据库SQL语句的连接，例如：

StringBuffer sb = new StringBuffer();

String user = “test”;

String pwd = “123”;

sb.append(“select \* from userInfo where username=“)

.append(user)

.append(“ and pwd=”)

.append(pwd);

这样对象sb的值就是字符串“select \* from userInfo where username=test and
pwd=123”。

2、deleteCharAt方法

public StringBuffer deleteCharAt(int index)

该方法的作用是删除指定位置的字符，然后将剩余的内容形成新的字符串。例如：

StringBuffer sb = new StringBuffer(“Test”);

sb. deleteCharAt(1);

该代码的作用删除字符串对象sb中索引值为1的字符，也就是删除第二个字符，剩余的内容组成一个新的字符串。所以对象sb的值变为”Tst”。

还存在一个功能类似的delete方法：

public StringBuffer delete(int start,int end)

该方法的作用是删除指定区间以内的所有字符，包含start，不包含end索引值的区间。例如：

StringBuffer sb = new StringBuffer(“TestString”);

sb. delete (1,4);

该代码的作用是删除索引值1(包括)到索引值4(不包括)之间的所有字符，剩余的字符形成新的字符串。则对象sb的值是”TString”。

3、insert方法

public StringBuffer insert(int offset, String s)

该方法的作用是在StringBuffer对象中插入内容，然后形成新的字符串。例如：

StringBuffer sb = new StringBuffer(“TestString”);

sb.insert(4,“false”);

该示例代码的作用是在对象sb的索引值4的位置插入字符串false，形成新的字符串，则执行以后对象sb的值是”TestfalseString”。

4、reverse方法

public StringBuffer reverse()

该方法的作用是将StringBuffer对象中的内容反转，然后形成新的字符串。例如：

StringBuffer sb = new StringBuffer(“abc”);

sb.reverse();

经过反转以后，对象sb中的内容将变为”cba”。

5、setCharAt方法

public void setCharAt(int index, char ch)

该方法的作用是修改对象中索引值为index位置的字符为新的字符ch。例如：

StringBuffer sb = new StringBuffer(“abc”);

sb.setCharAt(1,’D’);

则对象sb的值将变成”aDc”。

6、trimToSize方法

public void trimToSize()

该方法的作用是将StringBuffer对象的中存储空间缩小到和字符串长度一样的长度，减少空间的浪费。

7、构造方法：

StringBuffer s0=new StringBuffer();分配了长16字节的字符缓冲区

StringBuffer s1=new StringBuffer(512);分配了512字节的字符缓冲区

8、获取字符串的长度: length()

StringBuffer s = new StringBuffer("www");

int i=s.length();

m.返回字符串的一部分值

substring(int start) //返回从start下标开始以后的字符串

substring(int start,int end) //返回从start到 end-1字符串

9.替换字符串

replace(int start,int end,String str)

s.replace(0,1,"qqq");

10.转换为不变字符串:toString()。
