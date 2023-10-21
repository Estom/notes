package cn.aofeng.demo.netty40x.echo;

import java.nio.charset.Charset;

import org.apache.log4j.Logger;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.channel.ChannelHandler.Sharable;

/**
 * 将接收到的数据原样返回给发送方。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
@Sharable
public class EchoServerHandler extends ChannelInboundHandlerAdapter {

    private static Logger _logger = Logger.getLogger(EchoServerHandler.class);
    
    public void channelRead(ChannelHandlerContext ctx, Object msg) {
        ByteBuf inData = (ByteBuf) msg;
        String str = inData.toString(Charset.forName("UTF-8"));
        _logger.info( String.format("Server receive data:%s", str) );
        ctx.write(inData);
    }

    public void channelReadComplete(ChannelHandlerContext ctx) {
        ctx.flush().close();
    }

    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        _logger.error("occurs error", cause);
        ctx.close();
    }

}
