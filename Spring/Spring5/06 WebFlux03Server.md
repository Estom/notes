

## 1 WebFlux基于注解的编程的实现


### 创建WebFlux项目
1. 创建Springboot项目，引入webflux的依赖
```xml
pom.xml

<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.2.1.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.example</groupId>
    <artifactId>shangguigu09</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>shangguigu09</name>
    <description>shangguigu09</description>
    <properties>
        <java.version>1.8</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-webflux</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```
2. 在配置文件中，设置启动端口号8081
```yaml
server.port =8081
```
3. 从上到下设计代码：创建接口和实现类

```java
@Service
public class UserServiceImpl implements UserService {
    private final Map<Integer,User> users = new HashMap<>();

    public UserServiceImpl() {

        this.users.put(1,new User("lucy","nan",10));
        this.users.put(2,new User("mary","nv",38));
        this.users.put(3,new User("jack","nv",32));

    }

    @Override
    public Mono<User> getUserById(int id) {
        return Mono.justOrEmpty(this.users.get(id));
    }

    @Override
    public Flux<User> getAllUser() {
        return Flux.fromIterable(this.users.values());
    }

    @Override
    public Mono<Void> savaUserInfo(Mono<User> userMono) {
        return userMono.doOnNext(person->{
            int id = users.size() + 1;
            users.put(id,person);
        }).thenEmpty(Mono.empty());
    }
}
```

4. 从下到上实现代码：实现业务逻辑
```java

@RestController
public class UserController {
    @Autowired
    private UserService userService;

    //id
    @GetMapping("/user/{id}")
    public Mono<User> getUserById(@PathVariable int id){
        return userService.getUserById(id);
    }

    //all
    @GetMapping("/user")
    public Flux<User> getAllUser(){
        return userService.getAllUser();
    }
    //tianjian
    @GetMapping("/saveuser")
    public Mono<Void> saveUser(@RequestBody User user){
        Mono<User> userMono = Mono.just(user);
        return userService.savaUserInfo(userMono);
    }

        @GetMapping("/hello/{latency}")
    public Mono<String> hello(@PathVariable long latency) {
        System.out.println("Start:" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS")));
        System.out.println("Page count:" + COUNT.incrementAndGet());
        Mono<String> res = Mono.just("welcome to Spring Webflux").delayElement(Duration.ofSeconds(latency));//阻塞latency秒，模拟处理耗时
        System.out.println("End:  " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS")));
        return res;
    }
}
```


### 实现说明
* SpringMVC范式，同步阻塞方式，基于SpringMVC+Servlet+Tomcat
* SpringWebflux方式，异步非阻塞方式，基于SpringMVCWebflux+Reactor+Netty


## 2 WebFlux基于函数的编程的实现

### 简要说明
> bio,nio,aio
在使用函数式编程，需要自己初始化服务器

基于函数式编程模型的时候，有两个核心接口。
* RouterFunction 实现路由功能，请求转发给对应的handler
* HandlerFunction 处理请求生成响应函数。

核心任务定义两个函数式接口的实现，并启动需要的服务器。

SpringWebFlux的请求和响应是
* ServerRequest
* ServerResponse


### 实现流程
1. 从上到下实现业务bean
2. 创建handler实现Mono方法

```java

public class UserHandler {

    private final UserService userService;
    public UserHandler(UserService userService){
        this.userService = userService;
    }

    //根据id
    public Mono<ServerResponse> getUserById(ServerRequest request){
        //获取id值
        int  userid = Integer.valueOf( request.pathVariable("id"));
        Mono<ServerResponse> notFound = ServerResponse.notFound().build();
        //调用service方法取得数据
        Mono<User> userMono = this.userService.getUserById(userid);

        //UserMono进行转换返回。Reactor操作符
        return userMono.flatMap(person->ServerResponse.ok().contentType(MediaType.APPLICATION_JSON)
                .body(fromObject(person)))
                .switchIfEmpty(notFound);

    }

    //所有用户
    public Mono<ServerResponse> getAllUsers(){
        Flux<User> users = this.userService.getAllUser();
        return ServerResponse.ok().contentType(MediaType.APPLICATION_JSON).body(users,User.class);

    }


    //添加
    public Mono<ServerResponse> saveUser(ServerRequest request){
        Mono<User> userMono = request.bodyToMono(User.class);
        return ServerResponse.ok().build(this.userService.savaUserInfo(userMono));
    }
}
```

3. 创建并初始化服务器，设置路由和handler

```java
public class Server {
    //创建路由
    public RouterFunction<ServerResponse> route(){
        UserService userService = new UserServiceImpl();
        UserHandler handler = new UserHandler(userService);

        return RouterFunctions.route(GET("/users/{id}").and(accept(MediaType.APPLICATION_JSON)),handler::getUserById);
//                .andRoute(GET("users").and(accept(MediaType.APPLICATION_JSON)),handler::getAllUsers)
//                .andRoute(GET("saveuser").and(accept(MediaType.APPLICATION_JSON)),handler::saveUser);

    }

    public void createReactorServer(){
        RouterFunction<ServerResponse> route = route();
        HttpHandler httpHandler = toHttpHandler(route);

        ReactorHttpHandlerAdapter reactorHttpHandlerAdapter = new ReactorHttpHandlerAdapter(httpHandler);

        HttpServer httpServer = HttpServer.create();
        httpServer.handle(reactorHttpHandlerAdapter).bindNow();
    }

    public static void main(String[] args) throws Exception{
        Server server = new Server();
        server.createReactorServer();
        System.out.println("enter to exit");
        System.in.read();
    }
}
```

## 3 WebClient调用


```java
public class Client {

    public static void main(String[] args) {
        WebClient webClient = WebClient.create("http://127.0.0.1:62418");
        User userMono = webClient.get().uri("/users/{id}", "1").accept(MediaType.APPLICATION_JSON).retrieve().bodyToMono(User.class).block();
        System.out.println(userMono.getName());
    }
}

```