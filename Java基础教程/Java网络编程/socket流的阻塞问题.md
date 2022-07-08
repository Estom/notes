从Socket上读取对端发过来的数据一般有两种方法：

**1）按照字节流读取**

BufferedInputStream in = new BufferedInputStream(socket.getInputStream()); int r
= -1; List\<Byte\> l = new LinkedList\<Byte\>(); while ((r = in.read()) != -1) {
l.add(Byte.valueOf((byte) r)); }

**2）按照字符流读取**

BufferedReader in = new BufferedReader(new
InputStreamReader(socket.getInputStream())); String s; while ((s =
in.readLine()) != null) { System.out.println("Reveived: " + s); }

这两个方法read()和readLine()都会读取对端发送过来的数据，如果无数据可读，就会阻塞直到有数据可读。或者到达流的末尾，这个时候分别返回-1和null。

这个特性使得编程非常方便也很高效。

但是这样也有一个问题，就是如何让程序从这两个方法的阻塞调用中返回。

总结一下，有这么几个方法：

1）发送完后调用Socket的shutdownOutput()方法关闭输出流，这样对端的输入流上的read操作就会返回-1。

注意不能调用socket.getInputStream().close()。这样会导致socket被关闭。

当然如果不需要继续在socket上进行读操作，也可以直接关闭socket。

但是这个方法不能用于通信双方需要多次交互的情况。

2）发送数据时，约定数据的首部固定字节数为数据长度。这样读取到这个长度的数据后，就不继续调用read方法。

3）为了防止read操作造成程序永久挂起，还可以给socket设置超时。

如果read()方法在设置时间内没有读取到数据，就会抛出一个java.net.SocketTimeoutException异常。

例如下面的方法设定超时3秒。

socket.setSoTimeout(3000);

技术的天地广阔无垠，找到充实自己的那些，自由的翱翔
