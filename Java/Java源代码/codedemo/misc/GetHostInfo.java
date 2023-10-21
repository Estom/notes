package cn.aofeng.demo.misc;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Enumeration;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;

/**
 * 获取本机IP和主机名以及Java环境信息。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class GetHostInfo {

    /**
     * @param args
     * @throws UnknownHostException 
     * @throws SocketException 
     */
    public static void main(String[] args) throws UnknownHostException, SocketException {
        InetAddress address =  InetAddress.getLocalHost();
        System.out.println("计算机名：" + address.getHostName());
        Enumeration<NetworkInterface> nis = NetworkInterface.getNetworkInterfaces();
        while (nis.hasMoreElements()) {
            StringBuilder buffer = new StringBuilder();
            NetworkInterface ni = nis.nextElement();
            buffer.append("网卡：").append(ni.getName());
            buffer.append("    绑定IP：");
            Enumeration<InetAddress> ias = ni.getInetAddresses();
            int count  = 0;
            while (ias.hasMoreElements()) {
                InetAddress ia = ias.nextElement();
                if (count > 0) {
                    buffer.append(", ");
                }
                buffer.append(ia.getHostAddress());
            }
            System.out.println(buffer.toString());
        }
        
        System.out.println("Java环境信息:");
        System.out.println("---------------------------------------------------:");
        Properties pros = System.getProperties();
        Set<Entry<Object, Object>> javaEnums = pros.entrySet();
        for (Entry<Object, Object> entry : javaEnums) {
            System.out.println(entry.getKey() + " : " + entry.getValue());
        }
        System.out.println("");
        System.out.println("系统环境信息:");
        System.out.println("---------------------------------------------------:");
        Map<String, String> envs = System.getenv();
        Set<Entry<String, String>> envSet = envs.entrySet();
        for (Entry<String, String> entry : envSet) {
            System.out.println(entry.getKey() + " : " + entry.getValue());
        }
    }

}
