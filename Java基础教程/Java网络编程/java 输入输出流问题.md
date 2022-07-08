1）确定是数据源和数据目的（输入还是输出）

源:输入流 InputStream Reader

目的:输出流 OutputStream Writer

2）明确操作的数据对象是否是纯文本

是:字符流Reader，Writer

否:字节流InputStream，OutputStream

3）明确具体的设备。

是硬盘文件：File++：

读取：FileInputStream,, FileReader,

写入：FileOutputStream，FileWriter

是内存用数组

byte[]：ByteArrayInputStream, ByteArrayOutputStream

是char[]：CharArrayReader, CharArrayWriter

是String：StringBufferInputStream(已过时，因为其只能用于String的每个字符都是8位的字符串),
StringReader, StringWriter

是网络用Socket流

是键盘：用System.in（是一个InputStream对象）读取，用System.out（是一个OutoutStream对象）打印

3）是否需要转换流

是，就使用转换流，从Stream转化为Reader，Writer：InputStreamReader，OutputStreamWriter

4）是否需要缓冲提高效率

是就加上Buffered：BufferedInputStream, BufferedOuputStream, BuffereaReader,
BufferedWriter

5）是否需要格式化输出

例:将一个文本文件中数据存储到另一个文件中。

1）数据源和数据目的：读取流，InputStream Reader 输出：OutputStream Writer

2）是否纯文本：是！这时就可以选择Reader Writer。

3）设备：是硬盘文件。Reader体系中可以操作文件的对象是 FileReader FileWriter。

FileReader fr = new FileReader("a.txt");

FileWriter fw = new FileWriter("b.txt");

4）是否需要提高效率：是，加Buffer

BufferedReader bfr = new BufferedReader(new FileReader("a.txt"); );

BufferedWriter bfw = new BufferedWriter(new FileWriter("b.txt"); );

PrintStream

PrintStream在OutputStream基础之上提供了增强的功能，即可以方便地输出各种类型的数据（而不仅限于byte型）的格式化表示形式。PrintStream的方法从不抛出IOEceptin

PrintWriter

PrintWriter提供了PrintStream的所有打印方法，其方法也从不抛出IOException。

与PrintStream的区别：作为处理流使用时，PrintStream只能封装OutputStream类型的字节流，而PrintWriter既可以封装OutputStream类型的字节流，还能够封装Writer类型的字符输出流并增强其功能。
