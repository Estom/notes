package cn.aofeng.demo.nio;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.nio.ByteBuffer;
import java.nio.channels.ClosedChannelException;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.Arrays;
import java.util.Iterator;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 用NIO实现的Echo Server。
 * @author 聂勇 <a href="mailto:aofengblog@163.com">aofengblog@163.com</a>
 */
public class NioEchoServer {
    
    private final static Logger logger = Logger.getLogger(NioEchoServer.class.getName());
    
    // 换行符
    public final static char CR = '\r';
    
    // 回车符
    public final static char LF = '\n';
    
    /**
     * @return 当前系统的行结束符
     */
    private static String getLineEnd() {
        return System.getProperty("line.separator");
    }
    
    /**
     * 重置缓冲区状态标志位：position设置为0，limit设置为capacity的值，所有mark无效。
     * 注：缓冲区原来的内容还在，并没有清除。
     * 
     * @param buffer 字节缓冲区
     */
    private static void clear(ByteBuffer buffer) {
        if (null != buffer) {
            buffer.clear();
        }
    }
    
    /**
     * 将字节缓冲区的每一个字节转换成ASCII字符。
     * @param buffer 字节缓冲区
     * @return 转换后的字节数组字符串
     */
    private static String toDisplayChar(ByteBuffer buffer) {
        if (null == buffer) {
            return "null";
        }
        
        return Arrays.toString(buffer.array());
    }
    
    /**
     * 将字节缓冲区用utf8编码，转换成字符串。
     * 
     * @param buffer　字节缓冲区
     * @return utf8编码转换的字符串
     * @throws UnsupportedEncodingException
     */
    private static String convert2String(ByteBuffer buffer) throws UnsupportedEncodingException {
        return new String(buffer.array(), "utf8");
    }
    
    /**
     * 去掉尾末的行结束符（\r\n），并转换成字符串。
     * 
     * @param buffer 字节缓冲区
     * @return 返回去掉行结束符后的字符串。
     * @throws UnsupportedEncodingException
     * @see #convert2String(ByteBuffer)
     */
    private static String getLineContent(ByteBuffer buffer) throws UnsupportedEncodingException {
        if (null == buffer) {
            return null;
        }
        
        byte[] result = new byte[buffer.limit()-2];
        System.arraycopy(buffer.array(), 0, result, 0, result.length);
        return convert2String(ByteBuffer.wrap(result));
    }
    
    /**
     * 顺序合并两个{@link ByteBuffer}的内容，且不改变{@link ByteBuffer}原来的标志位。即：
     * <pre>
     * 合并后的ByteBuffer = first + second
     * </pre>
     * @param first 第一个待合并的{@link ByteBuffer}，合并后其内容在前面
     * @param second 第二个待合并的{@link ByteBuffer}，合并后其内容在后面
     * @return 合并后的内容。如果两个{@link ByteBuffer}都为null，返回null。
     */
    private static ByteBuffer merge(ByteBuffer first, ByteBuffer second) {
        if (null == first && null == second) {
            return null;
        }
        
        int oneSize = null != first ? first.limit() : 0;
        int twoSize = null != second ? second.limit() : 0;
        ByteBuffer result = ByteBuffer.allocate(oneSize+twoSize);
        if (null != first) {
            result.put(Arrays.copyOfRange(first.array(), 0, oneSize));
        }
        if (null != second) {
            result.put(Arrays.copyOfRange(second.array(), 0, twoSize));
        }
        result.rewind();
        
        return result;
    }
    
    /**
     * 从字节缓冲区中获取"一行"，即获取包括行结束符及其前面的内容。
     * 
     * @param buffer 输入缓冲区
     * @return 有遇到行结束符，返回包括行结束符在内的字节缓冲区；否则返回null。
     */
    private static ByteBuffer getLine(ByteBuffer buffer) {
        int index = 0;
        boolean findCR = false;
        int len = buffer.limit();
        while(index < len) {
            index ++;
            
            byte temp = buffer.get();
            if (CR == temp) {
                findCR = true;
            }
            if (LF == temp && findCR && index > 0) { // 找到了行结束符
                byte[] copy = new byte[index];
                System.arraycopy(buffer.array(), 0, copy, 0, index);
                buffer.rewind(); // 位置复原
                return ByteBuffer.wrap(copy);
            }
        }
        buffer.rewind(); // 位置复原
        
        return null;
    }
    
    private static void readData(Selector selector, SelectionKey selectionKey) throws IOException {
        SocketChannel socketChannel = (SocketChannel) selectionKey.channel();
        
        // 获取上次已经读取的数据
        ByteBuffer oldBuffer = (ByteBuffer) selectionKey.attachment();
        if (logger.isLoggable(Level.FINE)) {
            logger.fine("上一次读取的数据："+oldBuffer+getLineEnd()+toDisplayChar(oldBuffer));
        }
        
        // 读新的数据
        int readNum = 0;
        ByteBuffer newBuffer = ByteBuffer.allocate(1024);
        if ( (readNum = socketChannel.read(newBuffer)) <= 0 ) {
            return;
        }
        if (logger.isLoggable(Level.FINE)) {
            logger.fine("这次读取的数据："+newBuffer+getLineEnd()+toDisplayChar(newBuffer));
        }
        
        newBuffer.flip();
        ByteBuffer lineRemain = getLine(newBuffer);
        if (logger.isLoggable(Level.FINE)) {
            logger.fine("解析的行数据剩余部分："+lineRemain+getLineEnd()+toDisplayChar(lineRemain));
        }
        if (null != lineRemain) { // 获取到行结束符
            ByteBuffer completeLine = merge(oldBuffer, lineRemain);
            if (logger.isLoggable(Level.FINE)) {
                logger.fine("准备输出的数据："+completeLine+getLineEnd()+toDisplayChar(completeLine));
            }
            while (completeLine.hasRemaining()) { // 有可能一次没有写完，需多次写
                socketChannel.write(completeLine);
            }
            
            // 清除数据
            selectionKey.attach(null);
            clear(oldBuffer);
            clear(lineRemain);
            
            // 判断是否退出
            String lineStr = getLineContent(completeLine);
            if (logger.isLoggable(Level.FINE)) {
                logger.fine("判断是否退出的行数据："+lineStr);
            }
            if ("exit".equalsIgnoreCase(lineStr) || "quit".equalsIgnoreCase(lineStr)) {
                socketChannel.close();
            }
            
            // FIXME 行结束符后面是否还有数据？ 此部分代码尚未测试
            if (lineRemain.limit()+2 < newBuffer.limit()) {
                byte[] temp = new byte[newBuffer.limit() - lineRemain.limit()];
                newBuffer.get(temp, lineRemain.limit(), temp.length);
                
                selectionKey.attach(temp);
            }
        } else { // 没有读到一个完整的行，继续读并且带上已经读取的部分数据
            ByteBuffer temp = merge(oldBuffer, newBuffer);
            socketChannel.register(selector, SelectionKey.OP_READ, temp); 
            
            if (logger.isLoggable(Level.FINE)) {
                logger.fine("暂存到SelectionKey的数据："+temp+getLineEnd()+toDisplayChar(temp));
            }
        }
    }

    /**
     * 接受新的Socket连接。
     * 
     * @param selector 选择器
     * @param selectionKey 
     * @return
     * @throws IOException
     * @throws ClosedChannelException
     */
    private static SocketChannel acceptNew(Selector selector,
            SelectionKey selectionKey) throws IOException,
            ClosedChannelException {
        ServerSocketChannel server = (ServerSocketChannel) selectionKey.channel();
        SocketChannel socketChannel = server.accept();
        if (null != socketChannel) {
            if (logger.isLoggable(Level.INFO)) {
                logger.info("收到一个新的连接，客户端IP："+socketChannel.socket().getInetAddress().getHostAddress()+"，客户端Port："+socketChannel.socket().getPort());
            }
            socketChannel.configureBlocking(false);
            socketChannel.register(selector, SelectionKey.OP_READ);
        }
        
        return socketChannel;
    }
    
    /**
     * 启动服务器。
     * 
     * @param port 服务监听的端口
     * @param selectTimeout {@link Selector}检查通道就绪状态的超时时间（单位：毫秒）
     */
    private static void startServer(int port, int selectTimeout) {
        ServerSocketChannel serverChannel = null;
        try {
            serverChannel = ServerSocketChannel.open();
            serverChannel.configureBlocking(false);
            ServerSocket serverSocket = serverChannel.socket();
            serverSocket.bind(new InetSocketAddress(port));
            if (logger.isLoggable(Level.INFO)) {
                logger.info("NIO echo网络服务启动完毕，监听端口：" +port);
            }
            
            Selector selector = Selector.open();
            serverChannel.register(selector, SelectionKey.OP_ACCEPT);
            
            while (true) {
                int selectNum = selector.select(selectTimeout);
                if (0 == selectNum) {
                    continue;
                }
                
                Set<SelectionKey> selectionKeys = selector.selectedKeys();
                Iterator<SelectionKey> it = selectionKeys.iterator();
                while (it.hasNext()) {
                    SelectionKey selectionKey = (SelectionKey) it.next();
                    
                    // 接受新的Socket连接
                    if (selectionKey.isAcceptable()) {
                        acceptNew(selector, selectionKey);
                    }
                    
                    // 读取并处理Socket的数据
                    if (selectionKey.isReadable()) {
                        readData(selector, selectionKey);
                    }
                    
                    it.remove();
                } // end of while iterator
            }
        } catch (IOException e) {
            logger.log(Level.SEVERE, "处理网络连接出错", e);
        }
    }
    
    public static void main(String[] args) {
        int port = 9090;
        int selectTimeout = 1000;
        
        startServer(port, selectTimeout);
    }

}
