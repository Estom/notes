package cn.aofeng.demo.nio;

import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileChannel.MapMode;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * IO-内存映射。
 * 
 * @author 聂勇 <a href="mailto:aofengblog@163.com">aofengblog@163.com</a>
 */
public class MemoryMapper {

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
             MappedByteBuffer buffer = channel.map(MapMode.READ_ONLY, 0, channel.size());
             long startTime = System.currentTimeMillis();
             long total = 0;
             long len = file.length();
             byte[] bs = new byte[BUFFER_SIZE];
             for (int index = 0; index < len; index+=BUFFER_SIZE) {
                 int readSize = BUFFER_SIZE;
                 if (len-index < BUFFER_SIZE) {
                    readSize = (int) len-index;
                    buffer.get(new byte[readSize]);
                 } else {
                    buffer.get(bs);
                 }
                 
                 total += readSize;
             }
             long endTime = System.currentTimeMillis();
             logger.info("内存映射读取文件耗时：" + (endTime-startTime)+"毫秒，文件长度："+total+"字节");
        } catch (FileNotFoundException e) {
            logger.log(Level.SEVERE, "找不到文件："+filename, e);
        } catch (IOException e) {
            logger.log(Level.SEVERE, "读取文件出错", e);
        } finally{
            close(channel);
        }
        
    }

}
