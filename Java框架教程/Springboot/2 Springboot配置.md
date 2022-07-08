## 1 创建一个springboot项目

1. 创建Maven工程
2. 引入依赖pom.xml
   1. 包括`<parent>`下是springboot的标签。`dependencies`下是相关的依赖。

```
<parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.3.4.RELEASE</version>
    </parent>


    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

    </dependencies>
```
3. 创建主程序

```
/**
 * 主程序类
 * @SpringBootApplication：这是一个SpringBoot应用
 */
@SpringBootApplication
public class MainApplication {

    public static void main(String[] args) {
        SpringApplication.run(MainApplication.class,args);
    }
}
```
4. 编写具体业务

```
@RestController
public class HelloController {


    @RequestMapping("/hello")
    public String handle01(){
        return "Hello, Spring Boot 2!";
    }


}
```
5. 运行测试

6. 简化配置 application.properties
```
server.port=8888
```
7. 简化部署
   1. 把项目打包成jar包，直接在目标服务器程序执行即可。
```
<build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
```


## 2 工程结构
1. 主程序Main.java
2. 业务程序Controller.java
3. maven依赖pom.xml
4. 配置Springboot项目application.properties是Spring的集中配置中心，包括项目相关的所有配置。


## 3 依赖管理 

1. mypom.xml
2. parent -- spring-boot-starter-parent
3. parent -- spring-boot-dependencies

1. 几乎声明了所有的版本，查看Spring-boot-dependencies中的版本。可以自定义properties标签，修改版本号。
2. stater场景启动器。自动引入相关的所有依赖。可以自定义场景启动器，所有场景启动器最基本的以来。spring-boot-starter。引入依赖一部分可以不写版本号。引入非版本仲裁的版本号，必须要写。


## 4 自动配置

1. 自动配好了SpringMVC
   1. 引入了SpringMVC全套组件
   2. 自动配好了SpringMVC常用功能。字符编码问题、多文件上传问题
2. 默认程序结构
   1. 主程序所在包及其所有子包里的文件和组件都能被扫描到。无需配置包扫描
   2. 可以修改SpringbootApplication注解参数中的扫描路径。或者ComponentScan注解。
3. .properties中的文件是绑定到具体的Java类的。这些类会在容器中创建指定的对象。
4. 按需加载所有的自动配置，自动配置都在spring-boot-autoconfigure包中