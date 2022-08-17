package com.ykl.innerclass;





public class PartialDemo {
    static String name = "王五";
    String name2 = "周七";         
    public void demo() {
        String name = "张三";			
         class Inner{
              String name = "李四";				  
              public void showInner(String name) {
                  System.out.println("这是外部类变量："+PartialDemo.this.name2);
                  System.out.println("这是外部类变量（静态变量可以）："+PartialDemo.name);
                  System.out.println("这是方法中局部变量变量："+name);
                  System.out.println("这是局部内部类中的变量："+this.name);
                 
              }
        }
         Inner inner=new Inner();
         inner.showInner(name);			 
    }
    
    public static void main(String[] args) {
        PartialDemo partialDemo = new PartialDemo();
        partialDemo.demo();			
    }

}