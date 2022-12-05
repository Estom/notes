package cn.aofeng.demo.mockito;

/**
 * 商品信息。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class Commodity {

    private String id;
    
    private String name;
    
    private int type;

    public Commodity() {
        // nothing
    }
    
    public Commodity(String id, String name, int type) {
        this.id = id;
        this.name = name;
        this.type = type;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

}
