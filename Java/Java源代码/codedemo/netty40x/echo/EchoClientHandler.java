package cn.aofeng.demo.netty40x.echo;

import java.nio.charset.Charset;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.util.CharsetUtil;

/**
 * 发送数据给服务端，并接收服务端的数据。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class EchoClientHandler extends ChannelInboundHandlerAdapter {

    private static Logger _logger = Logger.getLogger(EchoClientHandler.class);
    
    private final Charset _utf8 = CharsetUtil.UTF_8;
    
    public void channelActive(ChannelHandlerContext ctx) {
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSZ");
        String currTimeStr = format.format(new Date());
        String data = String.format("Hello, current time is %s", currTimeStr);
        ctx.writeAndFlush( Unpooled.copiedBuffer(data, _utf8) );
        _logger.info( String.format("Client send data:%s", data) );
    }
    
    public void channelRead(ChannelHandlerContext ctx, Object msg) {
        ByteBuf inData = (ByteBuf) msg;
        _logger.info( String.format("Client receive data:%s",  inData.toString(_utf8)) );
    }
    
    public void channelReadComplete(ChannelHandlerContext ctx) {
        ctx.close();
    }
    
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        _logger.error("occurs error", cause);
        ctx.close();
    }

}
