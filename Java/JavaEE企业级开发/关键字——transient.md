# 序列化

对序列化的理解

JAVA序列化是指把JAVA对象转换为字节序列的过程。JAVA反序列化是吧字节恢复为JAVA对象。

应用：当两个进程进行远程通信时，可以相互发送各种类型的数据。包括文本、图片、音频、视频，这些数据都是以二进制序列的形式在网络上传送。

两个JAVA进程通信的时候，也可以传送对象，将JAVA序列化为字节序列，装载为字节流，然后进行传送。.接收端将字节流反序列化为JAVA对象。

作用：实现了数据的持久化，通过序列化，能够将数据永久的保存到硬盘上。利用序列化可以实现数据流的输入输出和远程通信。

实现方法：

java.io.ObjectOuptutStream:对象输出流writeObject()

java.io.ObjectInputStream:对象输入流readObject()

对象能被序列化的要求

implement了Serializable接口，通过默认的方法进行序列化

implement了Serializable接口，并且实现了相应的方法，然后通过自己的方式进行序列化和反序列化

序列化的步骤：

步骤一：创建一个对象输出流，它可以包装一个其它类型的目标输出流，如文件输出流：

ObjectOutputStream out = new ObjectOutputStream(new
fileOutputStream(“D:\\\\objectfile.obj”));

步骤二：通过对象输出流的writeObject()方法写对象：

out.writeObject(“Hello”);

out.writeObject(new Date());

反序列化的步骤：

步骤一：创建一个对象输入流，它可以包装一个其它类型输入流，如文件输入流：

ObjectInputStream in = new ObjectInputStream(new
fileInputStream(“D:\\\\objectfile.obj”));

步骤二：通过对象输出流的readObject()方法读取对象：

String obj1 = (String)in.readObject();

Date obj2 = (Date)in.readObject();

# transient关键字说明

可以理解为瞬态、不可序列化。

简单的说，truansient 变量就是在对象序列化的过程中没有被序列化变量。
