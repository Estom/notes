## 自动配置类

### SpringBootApplication注解的详细解释
```
@SpringBootApplication ==>
    @SpringBootConfiguration //本身是一个配置类@Configuration，利用容器中的东西完成业务逻辑
    @EnableAutoConfiguration 
        @AutoConfigurationPackage
          @Import(AutoConfigurationPackages.Register.class)利用register，将指定的包下的所有组件注册到容器中。所以默认包路径是Main程序所在的包。
        @Import(AutoConfigurationSelector.class)获取所有导入到容器中的配置类。利用Spring工厂加载器，从spring-boot-autoconfigure./META-INF/spring-factories中加载文件。Springboot一启动就要加载的所有配置类。
    @ComponentScan //包扫描的范围
```