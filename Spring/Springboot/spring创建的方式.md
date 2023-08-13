# springApplication创建的方法

### 1.通过类的静态方法直接创建

```java
SpringApplication.run(ApplicationConfiguration.class,args);
```

### 2.通过自定义SpringApplication创建

```java
SpringApplication springApplication = new SpringApplication(ApplicationConfiguration.class); //这里也是传入配置源，但也可以不传
springApplication.setWebApplicationType(WebApplicationType.NONE); //指定服务类型 可以指定成非Web应用和SERVLET应用以及REACTIVE应用
springApplication.setAdditionalProfiles("prod");  //prodFiles配置
Set<String> sources = new HashSet<>(); //创建配置源
sources.add(ApplicationConfiguration.class.getName()); //指定配置源
springApplication.setSources(sources); //设置配置源，注意配置源可以多个
ConfigurableApplicationContext context = springApplication.run(args); //运行SpringApplication 返回值为服务上下文对象
context.close(); //上下文关闭
```


### 3.通过Builder工厂模式
> 只是一种初始化对象的方法。

```java
ConfigurableApplicationContext context = new SpringApplicationBuilder(ApplicationConfiguration.class)//这里也是传入配置源，但也可以不传
        .web(WebApplicationType.REACTIVE)
        .profiles("java7")
        .sources(ApplicationConfiguration.class) //可以多个Class
        .run();
context.close(); //上下文关闭
```