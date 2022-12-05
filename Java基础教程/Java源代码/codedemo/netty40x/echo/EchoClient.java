package cn.aofeng.demo.netty40x.echo;

import io.netty.bootstrap.Bootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelOption;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioSocketChannel;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.log4j.Logger;

/**
 * Echo客户端。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class EchoClient {

    private static Logger _logger = Logger.getLogger(EchoClient.class);
    
    public void start(String host, int port) {
        EventLoopGroup worker = new NioEventLoopGroup(1);
        Bootstrap bootstrap = new Bootstrap();
        try {
            bootstrap.group(worker)
                .channel(NioSocketChannel.class)
                .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 1000)
                .handler(new EchoClientHandler())
                .remoteAddress(host, port);
            ChannelFuture cf = bootstrap.connect().sync();
            cf.channel().closeFuture().sync();
        } catch (Exception e) {
            _logger.error("occurs error", e);
        } finally {
            worker.shutdownGracefully();
        }
    }
    
    /**
     * @param args
     */
    public static void main(String[] args) {
        if (args.length != 2) {
            _logger.error("Invalid arguments。Usage：java cn.aofeng.demo.netty40x.echo.EchoClient 192.168.56.102 8080");
            System.exit(-1);
        }
        
        String host = args[0];
        int port = NumberUtils.toInt(args[1], 8080);
        EchoClient client = new EchoClient();
        client.start(host, port);
    }

}
