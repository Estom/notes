package cn.aofeng.demo.json.gson;

/**
 * 简单的Java对象。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class Person {

    private String name;
    
    private int age;

    public Person() {
        // nothing
    }
    
    @SuppressWarnings("unused")
    private void reset() {
        name = null;
        age = 0;
    }
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    @Override
    public String toString() {
        return "Person [name=" + name + ", age=" + age + "]";
    }

}
