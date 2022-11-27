
> 参考文件https://blog.csdn.net/hellozpc/article/details/122441522
> https://blog.csdn.net/kerongao/article/details/109746190
> https://www.cnblogs.com/chaosmoor/p/1670308e.html
> https://www.jianshu.com/p/cc3a99614476


## 1 概述

### 简介

它是Spring5中引入的响应式web客户端类库，最大特点是支持异步调用；我们还将学习WebTestClient，用于单元测试。

简单地说，WebClient是一个接口，执行web请求的主要入口点。

它是Spring Web Reactive模块的一部分，并且取代经典的RestTemplate而生。此外，新的客户端是一个响应式的、非阻塞的技术方案，可以在HTTP/1.1协议上工作。



## 2 使用

### 步骤

使用WebClient我们需要按照如下几步来操作

1. 创建WebClient实例
2. 执行请求
3. 处理返回数据

### 创建WebClient实例

构建WebClient有三种方法：

第一种，使用默认配置构建WebClient
```java
WebClient client1 = WebClient.create();
```
第二种，使用base URI参数构建WebClient
```java
WebClient client2 = WebClient.create("http://localhost:8080");
```
第三种，使用DefaultWebClientBuilder构造WebClient。构造器流式编程接口创建。
```java
WebClient client3 = WebClient
    .builder()
    .baseUrl("http://localhost:8080")
    .defaultCookie("cookieKey", "cookieValue")
    .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE) 
    .defaultUriVariables(Collections.singletonMap("url", "http://localhost:8080"))
    .build();
```


### WebClient设置Timeouts
通常，默认HTTP的超时为30秒，对于实际业务来说时间太长，所以让我们看看如何为我们的WebClient实例配置它们。

可以通过TcpClient来设置超时时间，超时时间分为链接超时时间和读/写超时时间，为了保证达到预期效果这两个值都需要设置。

我们可以通过ChannelOption.CONNECT_TIMEOUT_MILLIS设置连接超时，我们还可以使用ReadTimeoutHandler和WriteTimeoutHandler分别设置读和写超时
```java
TcpClient tcpClient = TcpClient
  .create()
  .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 5000)
  .doOnConnected(connection -> {
      connection.addHandlerLast(new ReadTimeoutHandler(5000, TimeUnit.MILLISECONDS));
      connection.addHandlerLast(new WriteTimeoutHandler(5000, TimeUnit.MILLISECONDS));
  });
 
WebClient client = WebClient.builder()
  .clientConnector(new ReactorClientHttpConnector(HttpClient.from(tcpClient)))
  .build();
```
> 虽然我们也可以在WebClient客户端请求上调用超时，但这是一个信号超时，而不是HTTP连接或读/写超时;这是Mono/Flux发布者的超时

### 准备请求数据

**第一步**，我们需要通过method(HttpMethod method) 或调yonWebClient来指定请求的HTTP方法get, post,delete:
```java
WebClient.UriSpec<WebClient.RequestBodySpec> request1 = client3.method(HttpMethod.POST);
WebClient.UriSpec<WebClient.RequestBodySpec> request2 = client3.post();
```

**第二步**，设置请求访问URL
```java
WebClient.RequestBodySpec uri1 = client3
  .method(HttpMethod.POST)
  .uri("/resource");
 
WebClient.RequestBodySpec uri2 = client3
  .post()
  .uri(URI.create("/resource"));
```
路径参数：我们使用uriBuilder构建包含路径参数的uri，也可以直接使用占位符。 /events/{id} 访问点并构建相应的 URI：
```java
this.webClient.get()
	.uri(uriBuilder -> uriBuilder
		.path("/events/{id}")
		.build(2))
	.retrieve();
verifyCalledUrl("/events/2");


String url = "http://localhost:8080/user/{id}/{name}";
String id = "123";
String name = "Boss";
Mono<String> mono = WebClient.create()
        .method(HttpMethod.POST)
        .uri(url, id, name)
        .retrieve()
        .bodyToMono(String.class);
String result = mono.block();

```
查询参数：采用 /events?name=[name]&startDate=[startDate]访问点。要设置查询参数，我们需要调用 UriBuilder 接口的 queryParam()方法：
```java
this.webClient.get()
	.uri(uriBuilder -> uriBuilder
		.path("/events")
		.queryParam("name", "InitFailed")
		.queryParam("startDate", "13/02/2021")
		.build())
	.retrieve();
verifyCalledUrl("/events?name=InitFailed&startDate=13/02/2021")
```


**第三步**，设置request body、content type、 length、cookies、headers 等请求参数

例如，如果我们想要设置一个request body，有两种可用的方法:用一个BodyInserter，或者把这个工作委托给Publisher
```java
WebClient.RequestHeadersSpec requestSpec1 = WebClient
  .create()
  .method(HttpMethod.POST)
  .uri("/resource")
  .body(BodyInserters.fromPublisher(Mono.just("data")), String.class);
 
WebClient.RequestHeadersSpec<?> requestSpec2 = WebClient
  .create("http://localhost:8080")
  .post()
  .uri(URI.create("/resource"))
  .body(BodyInserters.fromObject("data"));
```
BodyInserter 是一个接口，负责向request body中插入请求的body值

我们还可以设置MultiValueMap数据作为request body值
```java
LinkedMultiValueMap map = new LinkedMultiValueMap();
 
map.add("key1", "value1");
map.add("key2", "value2");
 
BodyInserter<MultiValueMap, ClientHttpRequest> inserter2
 = BodyInserters.fromMultipartData(map);
```
或者插入一个对象
```java
BodyInserter<Object, ReactiveHttpOutputMessage> inserter3
 = BodyInserters.fromObject(new Object());
```
在设置request body之后，我们可以设置content type、 length、cookies、headers

此外，它还支持最常用的头文件，如“If-None-Match”、“If-Modified-Since”、“Accept”和“Accept- charset”。
```java
WebClient.ResponseSpec response1 = uri1
  .body(inserter3)
    .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
    .accept(MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML)
    .acceptCharset(Charset.forName("UTF-8"))
    .ifNoneMatch("*")
    .ifModifiedSince(ZonedDateTime.now())
  .retrieve();
```

### 获取Response
最后一个步骤是发送请求和接收响应,这可以通过exchange或retrieve方法来完成
* exchange方法提供了ClientResponse以及它的status和header
* 而retrieve方法是直接获取body的内容:
```java
String response2 = request1.exchange()
  .block()
  .bodyToMono(String.class)
  .block();
String response3 = request2
  .retrieve()
  .bodyToMono(String.class)
  .block();
```
需要注意的是bodyToMono方法，如果状态代码是4xx(客户端错误)或5xx(服务器错误)，它将抛出一个WebClientException。

* Monos.block()方法来订阅和检索与响应一起发送的实际数据
* Monos.subscribe()非阻塞式获取响应结果
```java
@Test
public void testSubscribe() {
    Mono<String> mono = WebClient
            .create()
            .method(HttpMethod.GET)
            .uri("http://localhost:8080/hello")
            .retrieve()
            .bodyToMono(String.class);
    mono.subscribe(WebClientTest::handleMonoResp);
}
//响应回调
private static void handleMonoResp(String monoResp) {
    System.out.println("请求结果为：" + monoResp);
}
```

注意！在使用新版的spring boot 2.4.0，可能会出现如下错误：
```java
org.springframework.core.io.buffer.DataBufferLimitException: Exceeded limit on max bytes to buffer : 262144
```
可以通过修改application.yaml配置文件,增加缓冲区大小(测试发现不起作用)
```java
spring.codec.max-in-memory-size: 5MB
```
通过代码配置缓冲区大小
```java
 WebClient client = WebClient.builder()
                .exchangeStrategies(ExchangeStrategies.builder()
                        .codecs(configurer -> {
                                configurer.defaultCodecs()
                                .maxInMemorySize(16 * 1024 * 1024) ; }
                        )
                        .build())
                .build();

```
设置缓冲区大小为16MB
