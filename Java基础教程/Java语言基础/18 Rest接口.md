## 1 概述

### 基本概念

java.ws.rs是jax-rs规范中定义的包名。jax-rs全称Java API for RESTful Services。jax-rs规范目前版本是2.0规范文档

jax-rs中定义了
* 一组启动方式 (以jee作为http容器 还是配合servlet作为http容器)
* 一组注解@GET, @POST, @DELETE, @PUT, @Consumes … 通过 POJO Resource类 提供Rest服务

### 实现框架

* Apache CXF开源的Web服务框架
* Jersey 由Sun提供的JAX-RS的参考实现
* RESTEasy JBoss的实现
* Restlet 由Jerome Louvel和Dave Pawson开发 是最早的REST框架 先于JAX-RS出现
* Apache Wink 一个Apache软件基金会孵化器中的项目 其服务模块实现JAX-RS规范

## 2 注解
### @Path 
注解位置 类注解 方法注解

标注class时 表明该类是个资源类 凡是资源类必须使用该注解

标注method时 表示具体的请求资源的路径

### @GET @POST @PUT @DELETE 

注解位置 方法注解

指明接收HTTP请求的方式属于get,post,put,delete中的哪一种 具体指定请求方式 是由客户端发起请求时指定

### @Consumes 
注解位置 方法注解

指定HTTP请求的MIME类型 默认是*/* 表示任意的MIME类型 该注解支持多个值设定 可以使用MediaType来指定MIME类型
```
MediaType的类型大致有

application/xml
application/atom+xml
application/json
application/svg+xml
application/x-www-form-urlencoded
application/octet-stream
multipart/form-data
text/plain
text/xml
text/html
```
```java
@Path("{username"})
@Consumes({MediaType.APPLICATION_JSON})
public User getUser(@PathParam("username") String userName) {
    ...
}
```

### @Produces 

注解位置 方法注解

指定HTTP响应的MIME类型 默认是*/* 表示任意的MIME类型 同Consumes使用MediaType来指定MIME类型
```
@Path("{username"})
@Consumes({MediaType.APPLICATION_JSON})
@Produces(MediaType.APPLICATION_JSON)
public User getUser(@PathParam("username") String userName) {
    ...
}
```

### @PathParam 

注解位置 参数注解

配合@Path进行使用 可以获取URI中指定规则的参数

```
@GET
@Path("{username"})
@Produces(MediaType.APPLICATION_JSON)
public User getUser(@PathParam("username") String userName) {
    ...
}
// 浏览器请求http://ip:port/user/lilei时 userName值为lilei
```

### @QueryParam 

注解位置 参数注解

用于获取GET请求中的查询参数 实际上是url拼接在?后面的参数
```
@GET
@Path("/user")
@Produces("text/plain")
public User getUser(@QueryParam("name") String name,
                    @QueryParam("age") int age) {
    ...
}

// 浏览器请求http://ip:port/user?name=lilei&age=18时 name值为lilei age值为18 如需要为参数设置默认值 可以使用@DefaultValue
```
### @FormParam 

注解位置 参数注解

用于获取POST请求且以form(MIME类型为application/x-www-form-urlencoded)方式提交的表单的参数
```
@POST
@Consumes("application/x-www-form-urlencoded")
public void post(@FormParam("name") String name) {
    ...
}
```

### @FormDataParam 
注解位置 参数注解

用于获取POST请求且以form(MIME类型为multipart/form-data)方式提交的表单的参数 通常是在上传文件的时候

### @HeaderParam 

注解位置 参数注解

用于获取HTTP请求头中的参数值
```
@GET
@Path("/user/get")
public Response getUser(@HeaderParam("user-agent") String userAgent) {
    ...
}
// 这里获取user-agent的值
```
### @CookieParam 

注解位置 参数注解

用于获取HTTP请求cookie中的参数值
```
@GET
public String callService(@CookieParam("sessionid") String sessionid) {
    ...
}
```
### @MatrixParam 
注解位置 参数注解

可以用来绑定包含多个property (属性)=value(值) 方法参数表达式 用于获取请求URL参数中的键值对 必须使用’;'作为键值对分隔符
```
@Path("/books")
public class BookService {
    @GET
    @Path("{year}")
    public Response getBooks(@PathParam("year") String year,
            @MatrixParam("author") String author,
            @MatrixParam("country") String country) {
        ...
    }
}
// 请求1 "/books/2012/" 解析结果为 年份 2012 作者 null 国家 null
// 请求2 "/books/2012;author=andih" 解析结果为 年份 2012 作者 andih 国家 null
```

> 注意MatrixParam与QueryParam的区别
> QueryParam请求url的格式为 url?key1=value1&key2=value2&…
> MatrixParam请求url的格式为 url;key1=value1;key2=value2;…

### @DefaultValue

配合前面的参数注解等使用 用来设置默认值 如果请求指定的参数中没有值 通过该注解给定默认值

注解位置 参数注解
```
@POST
@Path("/user/add")
@Consumes({MediaType.APPLICATION_FORM_URLENCODED})
@Produces({MediaType.APPLICATION_JSON})
public Response addUser(@FormParam("username") String userName, @DefaultValue("0") @FormParam("age") int age, @DefaultValue("1") @FormParam("sex") int sex){
    ...
}
```

> 注意 DefaultValue指定的值在解析过程中出错时(@DefaultValue(“test”) @QueryParam(“age”) int age) 将返回404错误

### @BeanParam 
注解位置 参数注解

如果传递的较多 使用@FormParam等参数注解一个一个的接收每个参数可能显得太臃肿 可以通过Bean方式接收自定义的Bean 在自定义的Bean中字段使用@FormParam等参数注解 只需定义一个参数接收即可
```
public class MyBean {
	@FormParam("myData")
	private String data;
	@HeaderParam("myHeader")
	private String header;
	@PathParam("id")
	public void setResourceId(String id) {...}
        ...
}

@Path("myresources")
public class MyResources {
	@POST
	@Path("{id}")
	public void post(@BeanParam MyBean myBean) {
		...
	}
	...
}
```

### @Context 
注解位置 属性注解 参数注解

用来用来解析上下文参数 和Spring中的AutoWired效果类似 通过该注解可以获取ServletConfig ServletContext HttpServletRequest HttpServletResponse和HttpHeaders等信息
```
@Path("/user")
publicclass Resource {
    @Context
    HttpServletRequest req;
    @Context
    ServletConfig servletConfig;
    @Context
    ServletContext servletContext;

    @GET
    public String get(@Context HttpHeaders hh) {
        MultivaluedMap<String, String> headerParams = hh.getRequestHeaders();
        Map<String, Cookie> pathParams = hh.getCookies();
    }
}
```

### @Encoded
禁止解码 客户端发送的参数是什么样 服务器就原样接收