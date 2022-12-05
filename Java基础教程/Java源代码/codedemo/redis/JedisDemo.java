package cn.aofeng.demo.redis;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.JedisShardInfo;
import redis.clients.jedis.ShardedJedis;
import redis.clients.jedis.ShardedJedisPool;
import sun.security.krb5.internal.HostAddress;

/**
 * Redis客户端Jedis使用示例。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class JedisDemo {

    /**
     * @param args
     */
    public static void main(String[] args) {
        single();
        pool();
        shardPool();
    }

    /**
     * 单机单连接方式。
     */
    private static void single() {
        Jedis client = new Jedis("192.168.56.102", 6379);
        String result = client.set("key-string", "Hello, Redis!");
        System.out.println( String.format("set指令执行结果:%s", result) );
        String value = client.get("key-string");
        System.out.println( String.format("get指令执行结果:%s", value) );
    }

    /**
     * 集群方式（尚未实现）。
     */
    private static void cluster() {
        // 生成集群节点列表
        Set<HostAndPort> clusterNodes = new HashSet<HostAndPort>();
        clusterNodes.add(new HostAndPort("127.0.0.1", 6379));
        clusterNodes.add(new HostAndPort("192168.56.102", 6379));
        
        // 执行指令
        JedisCluster client = new JedisCluster(clusterNodes);
        String result = client.set("key-string", "Hello, Redis!");
        System.out.println( String.format("set指令执行结果:%s", result) );
        String value = client.get("key-string");
        System.out.println( String.format("get指令执行结果:%s", value) );
    }
    
    /**
     * 单机连接池方式。
     */
    private static void pool() {
        // 在应用初始化的时候生成连接池
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxIdle(10);
        config.setMaxTotal(30);
        config.setMaxWaitMillis(3*1000);
        JedisPool pool = new JedisPool(config, "192.168.56.102", 6379);
        
        // 在业务操作时，从连接池获取连接
        Jedis client = pool.getResource();
        try {
            // 执行指令
            String result = client.set("key-string", "Hello, Redis!");
            System.out.println( String.format("set指令执行结果:%s", result) );
            String value = client.get("key-string");
            System.out.println( String.format("get指令执行结果:%s", value) );
        } catch (Exception e) {
            // TODO: handle exception
        } finally {
            // 业务操作完成，将连接返回给连接池
            if (null != client) {
                pool.returnResource(client);
            }
        } // end of try block
        
        // 应用关闭时，释放连接池资源
        pool.destroy();
    }

    /**
     * 多机分布式＋连接池。
     */
    private static void shardPool() {
        // 生成多机连接信息列表
        List<JedisShardInfo> shards = new ArrayList<JedisShardInfo>();
        shards.add( new JedisShardInfo("127.0.0.1", 6379) );
        shards.add( new JedisShardInfo("192.168.56.102", 6379) );
        
        // 生成连接池配置信息
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxIdle(10);
        config.setMaxTotal(30);
        config.setMaxWaitMillis(3*1000);
        
        // 在应用初始化的时候生成连接池
        ShardedJedisPool pool = new ShardedJedisPool(config, shards);
        
        // 在业务操作时，从连接池获取连接
        ShardedJedis client = pool.getResource();
        try {
            // 执行指令
            String result = client.set("key-string", "Hello, Redis!");
            System.out.println( String.format("set指令执行结果:%s", result) );
            String value = client.get("key-string");
            System.out.println( String.format("get指令执行结果:%s", value) );
        } catch (Exception e) {
            // TODO: handle exception
        } finally {
            // 业务操作完成，将连接返回给连接池
            if (null != client) {
                pool.returnResource(client);
            }
        } // end of try block
        
        // 应用关闭时，释放连接池资源
        pool.destroy();
    }

}
