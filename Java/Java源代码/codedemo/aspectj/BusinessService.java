package cn.aofeng.demo.aspectj;

/**
 * 模拟业务方法，将被Aspectj织入代码，增加功能。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class BusinessService {

    public long add(int a, int b) {
        return a+b;
    }
    
    public long add(int a, int b, int... other) {
        long result = a + b;
        for (int i : other) {
            result += i;
        }
        
        return result;
    }

    public String join(String first, String... appends) {
        if (null == first) {
            throw new IllegalArgumentException("first is null");
        }
        StringBuilder buffer = new StringBuilder();
        buffer.append(first);
        for (String str : appends) {
            buffer.append(str);
        }
        
        return buffer.toString();
    }

    public String addPrefix(String src) {
        if (null == src) {
            throw new IllegalArgumentException("src is null");
        }
        
        return "-->"+src;
    }

    public static void printLine(char style) {
        if ('=' == style) {
            System.out.println("========================================================================================");
        } else if ('-' == style) {
            System.out.println("----------------------------------------------------------------------------------------");
        } else {
            System.out.println(" ");
        }
    }
    
    public static void main(String[] args) {
        final BusinessService bs = new BusinessService();
        
        System.out.println("1、执行方法add(int, int)");
        RunMethod rm = new RunMethod() {
            
            @Override
            public void run() {
                long result = bs.add(1, 2);
                System.out.println(">>> 结果：" + result);
            }
        };
        rm.execute();
        
        System.out.println("2、执行方法add(int, int, int...)");
        rm = new RunMethod() {
            
            @Override
            public void run() {
                long result = bs.add(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
                System.out.println(">>> 结果：" + result);
            }
        };
        rm.execute();
        
        System.out.println("3、执行方法join(String, String...)");
        rm = new RunMethod() {
            
            @Override
            public void run() {
                String str = bs.join("first", "-second", "-third");
                System.out.println(">>> 结果：" + str);
            }
        };
        rm.execute();
        
        System.out.println("4、执行方法join(String, String...)");
        rm = new RunMethod() {
            
            @Override
            public void run() {
                String str = bs.join(null, "-second", "-third");
                System.out.println(">>> 结果：" + str);
            }
        };
        rm.execute();
        
        System.out.println("5、执行方法addPrefix(String)");
        rm = new RunMethod() {
            
            @Override
            public void run() {
                String str = bs.addPrefix("原字符串");
                System.out.println(">>> 结果：" + str);
            }
        };
        rm.execute();
        
        System.out.println("6、执行方法addPrefix(String)");
        rm = new RunMethod() {
            
            @Override
            public void run() {
                String str = bs.addPrefix(null);
                System.out.println(">>> 结果：" + str);
            }
        };
        rm.execute();
    }

    public static abstract class RunMethod {
        
        private char _style = '=';
        
        public void execute() {
            printLine(_style);
            try {
                run();
            } catch (Exception e) {
                e.printStackTrace(System.err);
            }
            printLine(_style);
            printLine(' ');
        }
        
        public abstract void run();
    }

}
