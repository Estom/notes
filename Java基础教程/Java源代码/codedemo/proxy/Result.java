package cn.aofeng.demo.proxy;

/**
 * 账号服务操作结果。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class Result {

    /**
     * 200xxxx 表示成功。<br/>
     * 400xxxx 表示参数错误。<br/>
     * 500xxxx 表示服务内部错误。
     */
    private int code;
    
    /**
     * code对应的描述信息。
     */
    private String msg;
    
    /**
     * 只有code为200xxxx时才有值，其他情况下为null。
     */
    private User data;

    public Result() {
        // nothing
    }
    
    public Result(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }
    
    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public User getData() {
        return data;
    }

    public void setData(User data) {
        this.data = data;
    }

    @Override
    public String toString() {
        return "Result [code=" + code + ", msg=" + msg + ", data=" + data + "]";
    }

}
