1、@PostConstruct注解好多人以为是Spring提供的。其实是Java自己的注解。Java中该注解的说明：@PostConstruct该注解被用来修饰一个非静态的void()方法。被@PostConstruct修饰的方法会在服务器加载Servlet的时候运行，并且只会被服务器执行一次。PostConstruct在构造函数之后执行，init()方法之前执行。
2、通常我们会是在Spring框架中使用到@PostConstruct注解 该注解的方法在整个Bean初始化中的执行顺序：
Constructor(构造方法) -> @Autowired(依赖注入)/@Value -> @PostConstruct(注释的方法)
3、应用：在静态方法中调用依赖注入的Bean中的方法