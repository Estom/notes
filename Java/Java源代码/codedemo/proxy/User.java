/**
 * 
 */
package cn.aofeng.demo.proxy;

/**
 * 用户信息。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class User {

    private long uid;
    
    private String nickname;

    public long getUid() {
        return uid;
    }

    public void setUid(long uid) {
        this.uid = uid;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    @Override
    public String toString() {
        return "User [uid=" + uid + ", nickname=" + nickname + "]";
    }

}
