
import java.lang.Thread;
 /**
  * AnonymousClass
  */
 public class AnonymousClass {
 
    private int a;

    public static void main(String[] args){
        new AnonymousClass().test(2);
        // 成员内部类需要创建对象
        AnonymousClass ac =  new AnonymousClass();
        ac.new Inner().getName();
        //静态内部类可以直接访问
        new AnonymousClass.StaticInner().getName();
    }

    public class Inner{
        public void getName(){
            System.out.println("成员内部类");
        }
    }

    public static class StaticInner{
        public void getName(){
            System.out.println("静态内部类");
        }
    } 

    //事实证明匿名内部类必须访问final类型的变量，或者事实上final类型的变量。
    public void test(final int a){
        int b =10;
        int c =11;
        new Thread(){
            public void run() {
                System.out.println(a);
                System.out.println(b);
            }
        }.start();
        // b = 12;
        System.out.print(b);
    }

 }