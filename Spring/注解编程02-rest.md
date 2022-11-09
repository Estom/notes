
## 15 SpringMVC常用注解
### @EnableWebMvc
在配置类中开启Web MVC的配置支持。

### @Controller
在SpringMVC 中，控制器Controller 负责处理由DispatcherServlet 分发的请求，它把用户请求的数据经过业务处理层处理之后封装成一个Model ，然后再把该Model 返回给对应的View 进行展示。

使用@Controller 标记一个类是Controller ，然后使用@RequestMapping 和@RequestParam 等一些注解用以定义URL 请求和Controller 方法之间的映射，这样的Controller 就能被外界访问到。

```java
@Controller
@RequestMapping(“/demoInfo”)
public class DemoController {
    @Autowired
    private DemoInfoService demoInfoService;

    @RequestMapping("/hello")
    public String hello(Map<String,Object> map){
       System.out.println("DemoController.hello()");
       map.put("hello","from TemplateController.helloHtml");
       //会使用hello.html或者hello.ftl模板进行渲染显示.
       return"/hello";
    }
}
```

### @RestController
Spring4，注解是@Controller和@ResponseBody的合集,表示这是个控制器bean,并且是将函数的返回值直 接填入HTTP响应体中,是REST风格的控制器。

```java

@RestController
@RequestMapping(“/demoInfo2”)
publicclass DemoController2 {
    @RequestMapping("/test")
    public [Power By听雨的人]String test(){
       return "ok";
    }
}
```

### @RequestMapping
用于映射web请求，包括访问路径和参数。提供路由信息，是一个用来处理请求地址映射的注解，可用于类或方法上。用于类上，表示类中的所有响应请求的方法都是以该地址作为父路径。

RequestMapping注解有六个属性，下面我们把她分成三类进行说明（下面有相应示例）。

1. value：指定请求的实际地址，指定的地址可以是URI Template 模式（后面将会说明）；
2. method：  指定请求的method类型， GET、POST、PUT、DELETE等；
3. consumes： 指定处理请求的提交内容类型（Content-Type），例如application/json, text/html;
4. produces:指定返回的内容类型，仅当request请求头中的(Accept)类型中包含该指定类型才返回；
5. params： 指定request中必须包含某些参数值是，才让该方法处理。
6. headers： 指定request中必须包含某些指定的header值，才能让该方法处理请求。

```java
@RestController
@RequestMapping("/home")
public class IndexController {
    /**
    * 将多个请求映射到一个方法上去
    */
    @RequestMapping(value = {
        “”,
        “/page”,
        "page*”,
        "view/*,**/msg"
    })
    String indexMultipleMapping() {
        return "Hello from index multiple mapping.”;
    }
    /**
    * 是否是必须传参
    * /home/name?person=xyz 或 /home/name
    */
    @RequestMapping(value = “/name”)
    String getName(@RequestParam(value = "person”, required = false) String personName) {
        return "Required element of request param”;
    }
    /**
    * 请求类型，请求参数，默认值
    */
    @RequestMapping(value = "/name", method = RequestMethod.GET)
    String getName(@RequestParam(value = "person", defaultValue = "John") String personName) {
        return "Required element of request param";
    }
    /**
    * 产生一个 JSON 响应
    */
    @RequestMapping(value = "/prod", produces = {
        "application/JSON"
    })
    @ResponseBody
    String getProduces() {
        return "Produces attribute";
    }
    /**
    * 可以同时处理请求中的 JSON 和 XML 内容
    */
    @RequestMapping(value = "/cons", consumes = {
        "application/JSON",
        "application/XML"
    })
    String getConsumes() {
        return "Consumes attribute";
    }
    /**
    * 根据请求中的消息头内容缩小请求映射的范围
    */
    @RequestMapping(value = “/head”, headers = {
        "content-type=text/plain”,
        "content-type=text/html"
    })
    String post() {
        return "Mapping applied along with headers”;
    }
    /**
    * 可以让多个处理方法处理到同一个URL 的请求, 而这些请求的参数是不一样的
    */
    @RequestMapping(value = “/fetch”, params = {
        "personId=10"
    })
    String getParams(@RequestParam(“personId”) String id) {
        return "Fetched parameter using params attribute = " + id;
    }
    /**
    * 使用正则表达式来只处理可以匹配到正则表达式的动态 URI
    */
    @RequestMapping(value = “/fetch/{id:[a-z]+}/{name}”, method = RequestMethod.GET)
    String getDynamicUriValueRegex(@PathVariable(“name”) String name) {
        System.out.println(“Name is " + name);
        return "Dynamic URI parameter fetched using regex”;
    }
    /**
    * 向 /home 发起的一个请求将会由 default() 来处理，因为注解并没有指定任何值
    */
    @RequestMapping()
    String
    default () {
        return "This is a default method for the class”;
    }
}
```



### @RequestBody
允许request的参数在request体中，而不是在直接连接的地址后面。（放在参数前）

### @PathVariable
用于接收路径参数，比如@RequestMapping(“/hello/{name}”)声明的路径，将注解放在参数前，即可获取该值，通常作为Restful的接口实现方法。

用于将请求URL中的模板变量映射到功能处理方法的参数上，即取出uri模板中的变量作为参数。

```java
@Controller
public [cnblogs.com/GoCircle]class="hljs-keyword">class TestController {
    @RequestMapping(value="/user/{userId}/roles/{roleId}",method = RequestMethod.GET)
    public String getLogin(@PathVariable("userId") String userId,@PathVariable("roleId") String roleId){
        System.out.println("User Id : " + userId);
        System.out.println("Role Id : " + roleId);
        return "hello";
    }
    @RequestMapping(value="/product/{productId}",method = RequestMethod.GET)
    public String getProduct(@PathVariable("productId") String productId){
        System.out.println("Product Id : " + productId);
        return "hello";
    }
    @RequestMapping(value="/javabeat/{regexp1:[a-z-]+}",
    method = RequestMethod.GET)
    public String getRegExp(@PathVariable("regexp1") String regexp1){
        System.out.println("URI Part 1 : " + regexp1);
        return "hello";
    }
```
### @RequestParam
@RequestParam主要用于在SpringMVC后台控制层获取参数，类似一种是request.getParameter("name")，它有三个常用参数：defaultValue = "0", required = false, value = "isApp"；defaultValue 表示设置默认值，required 通过boolean设置是否是必须要传入的参数，value 值表示接受的传入的参数类型。
```java
public Resp test(@RequestParam(value="course_id") Integer id){
    return Resp.success(customerInfoService.fetch(id));
}
```
### @ResponseBody
Spring4后出现的注解。支持将返回值放到response内，而不是一个页面，通常用户返回json数据。

作用： 该注解用于将Controller的方法返回的对象，用于构建RESTful的api，通过适当的HttpMessageConverter转换为指定格式后，写入到Response对象的body数据区。

使用时机：返回的数据不是html标签的页面，而是其他某种格式的数据时（如json、xml等）使用。
```java
@RequestMapping(“/test”)
@ResponseBody
public String test(){
    return”ok”;
}
```
### @ResponseStatus
此注解用于方法和exception类上，声明此方法或者异常类返回的http状态码。可以在Controller上使用此注解，这样所有的@RequestMapping都会继承。


### @ControllerAdvice
全局异常处理
全局数据绑定
全局数据预处理
ControllerAdvice的常用场景

### @ExceptionHandler
用于全局处理控制器里的异常。

### @InitBinder
用来设置WebDataBinder，WebDataBinder用来自动绑定前台请求参数到Model中。

### @ModelAttribute
（1）@ModelAttribute注释方法 

如果把@ModelAttribute放在方法的注解上时，代表的是：该Controller的所有方法在调用前，先执行此@ModelAttribute方法。可以把这个@ModelAttribute特性，应用在BaseController当中，所有的Controller继承BaseController，即可实现在调用Controller时，先执行@ModelAttribute方法。比如权限的验证（也可以使用Interceptor）等。

（2）@ModelAttribute注释一个方法的参数 

当作为方法的参数使用，指示的参数应该从模型中检索。如果不存在，它应该首先实例化，然后添加到模型中，一旦出现在模型中，参数字段应该从具有匹配名称的所有请求参数中填充。


hellorWord方法的userLogin参数的值来源于getUserLogin()方法中的model属性。


### @SessionAttribute
此注解用于方法的参数上，用于将session中的属性绑定到参数。
### @CookieValue
此注解用在@RequestMapping声明的方法的参数上，可以把HTTP cookie中相应名称的cookie绑定上去。cookie即http请求中name为JSESSIONID的cookie值。
```
@ReuestMapping("/cookieValue")
publicvoid getCookieValue(@CookieValue("JSESSIONID") String cookie){
}
```
