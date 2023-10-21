package cn.aofeng.demo.netty40x.echo;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelOption;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.log4j.Logger;

/**
 * Echo服务端：将客户端发送的请求原样返回。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class EchoServer {

    private static Logger _logger = Logger.getLogger(EchoServer.class);
    
    public void start(int port) {
        EventLoopGroup boss = new NioEventLoopGroup(1);
        EventLoopGroup worker = new NioEventLoopGroup(10);
        ServerBootstrap bootstrap = new ServerBootstrap();
        try {
            bootstrap.group(boss, worker)
                .channel(NioServerSocketChannel.class)
                .option(ChannelOption.SO_BACKLOG, 128)
                .childHandler(new EchoServerHandler())
                .localAddress(port);
            ChannelFuture bindFuture = bootstrap.bind().sync();
            ChannelFuture closeFuture = bindFuture.channel().closeFuture().sync();
            _logger.info( String.format("%s started and listen on %s", this.getClass().getSimpleName(), closeFuture ) );
        } catch(Exception ex) {
            _logger.info( String.format("%s start failed", this.getClass().getSimpleName()), ex);
        } finally {
            boss.shutdownGracefully();
            worker.shutdownGracefully();
        }
        
    }
    
    /**
     * @param args
     */
    public static void main(String[] args) {
        if (args.length != 1) {
            _logger.error("Invalid arguments。Usage：java cn.aofeng.demo.netty40x.echo.EchoServer 8080");
            System.exit(-1);
        }
        
        int port = NumberUtils.toInt(args[0], 8080);
        EchoServer server = new EchoServer();
        server.start(port);
    }

}
