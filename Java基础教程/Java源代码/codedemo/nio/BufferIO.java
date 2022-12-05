package cn.aofeng.demo.nio;

import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * IO-缓冲区操作。
 * 
 * @author 聂勇 <a href="mailto:aofengblog@163.com">aofengblog@163.com</a>
 */
public class BufferIO {

    private static Logger logger = Logger.getLogger("bufferio");
    
    // 缓冲区大小
    private final static int BUFFER_SIZE = 4096;
    
    public static void close(Closeable c) {
        if (null != c) {
            try {
                c.close();
            } catch (IOException e) {
                // ingore
            }
        }
    }
    
    /**
     * @param args [0]：读取文件的完整路径
     */
    public static void main(String[] args) {
        String filename = args[0];
        File file = new File(filename);
        FileChannel channel = null;
        try {
            channel = new FileInputStream(file).getChannel();
            ByteBuffer buffer = ByteBuffer.allocate(BUFFER_SIZE);
            long startTime = System.currentTimeMillis();
            while (channel.read(buffer) > 0) {
                buffer.flip();
                buffer.clear();
            }
            long endTime = System.currentTimeMillis();
            logger.info("缓冲区读取文件耗时：" + (endTime-startTime)+"毫秒");
        } catch (FileNotFoundException e) {
            logger.log(Level.SEVERE, "找不到文件："+filename, e);
        } catch (IOException e) {
            logger.log(Level.SEVERE, "读取文件出错", e);
        } finally{
            close(channel);
        }
    }

}
