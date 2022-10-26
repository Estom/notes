
## 1 简介


### 概述
JBoss Resteasy是一个遵守JAX-RS 标准的REST的开源项目

RESTEasy是JBoss的一个开源项目，提供各类框架帮助你构建RESTful Web Services和RESTful Java应用程序。做为一个JBOSS的项目，它固然能和**JBOSS应用服务器**很好地集成在一块儿。可是，它也能在任何运行JDK5或以上版本的Servlet容器中运行。


## 2 使用

```java
package com.liao;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Response;

@Path("/message")
public class MessageRestService {

    @GET
    @Path("/{param}")
    public Response printMessage(@PathParam("param") String msg) {

        String result = "Restful example : " + msg;

        return Response.status(200).entity(result).build();

    }

}
```


## Resteasy Client


JAX-RS 2.0介绍了一种新的client API，涉及主要3个类：Client , WebTarget 和Response。有两种方式来创建一个Client，标准的方式和使用ResteasyClientBuilder类，后一种方式配置client的方法更少。

```
 Client client = ClientBuilder.newClient();
            ... or...
            Client client = ClientBuilder.newBuilder().build();
            WebTarget target = client.target("http://foo.com/resource");
            Response response = target.request().get();
            String value = response.readEntity(String.class);
            response.close();  // You should close connections!
 
            ResteasyClient client = new ResteasyClientBuilder().build();
            ResteasyWebTarget target = client.target("http://foo.com/resource");
```