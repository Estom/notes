> [参考文献](https://www.zhihu.com/question/37962386)

# 概念介绍

> 想起我们Java老师经典的话，jsp就是在html里面写java代码，servlet就是在java里面写html代码…其实jsp经过容器解释之后就是servlet.
> 当前后端分离以后，就不需要再Servlet里写html代码了。只需要完成业务逻辑返回序列化的原始数据，由前端自行渲染。所以现在的所有前后端分离技术，像Spring这种后端框架，本质上也是创建servlet的。


## Servlet

Servlet其实就是一个遵循Servlet开发的java类。Servlet是由服务器调用的，运行在服务器端。

* Java基本程序，依赖jdk和jre，就能在虚拟机上运行
* servlet是一种特殊的Java类，遵循新的标准和规范，需要web容器才能提供web服务（没有主类，根据映射选择性执行的Java程序），例如tomcat。相当于为了扩展java无法作为动态语言提供web服务的，建立了新的java技术标准，但是需要额外的运行环境支撑。web容器就是servlet的运行环境。


ervlet是使用Java Servlet 应用程序设计接口（API）及相关类和方法的 Java 程序。除了 Java Servlet API，Servlet 还可以使用用以扩展和添加到 API 的 Java 类软件包。Servlet 在启用 Java 的 Web 服务器上或应用服务器上运行并扩展了该服务器的能力。Java servlet对于Web服务器就好象Java applet对于Web浏览器。Servlet装入Web服务器并在Web服务器内执行，而applet装入Web浏览器并在Web浏览器内执行。Java Servlet API 定义了一个servlet 和Java使能的服务器之间的一个标准接口，这使得Servlets具有跨服务器平台的特性。

Servlet 通过创建一个框架来扩展服务器的能力，以提供在 Web 上进行请求和响应服务。当客户机发送请求至服务器时，服务器可以将请求信息发送给 Servlet，并让 Servlet 建立起服务器返回给客户机的响应。 当启动 Web 服务器或客户机第一次请求服务时，可以自动装入 Servlet。装入后， Servlet 继续运行直到其它客户机发出请求。Servlet 的功能涉及范围很广。例如，Servlet 可完成如下功能：

(1) 创建并返回一个包含基于客户请求性质的动态内容的完整的 HTML页面。

(2) 创建可嵌入到现有 HTML 页面中的一部分 HTML 页面（HTML 片段）。

(3) 与其它服务器资源（包括数据库和基于 Java 的应用程序）进行通信。

(4) 用多个客户机处理连接，接收多个客户机的输入，并将结果广播到多个客户机上。例如，Servlet 可

以是多参与者的游戏服务器。

(5) 当允许在单连接方式下传送数据的情况下，在浏览器上打开服务器至applet的新连接，并将该连

接保持在打开状态。当允许客户机和服务器简单、高效地执行会话的情况下，applet也可以启动客户浏览器和服务器之间的连接。可以通过定制协议或标准（如 IIOP）进行通信。

(6) 对特殊的处理采用 MIME 类型过滤数据，例如图像转换和服务器端包括（SSI）。

(7) 将定制的处理提供给所有服务器的标准例行程序。例如，Servlet 可以修改如何认证用户。

## JSP

JSP全名为Java Server Pages，java服务器页面。JSP是一种基于文本的程序，其特点就是HTML和Java代码共同存在！

JSP是为了简化Servlet的工作出现的替代品，Servlet输出HTML非常困难，JSP就是替代Servlet输出HTML的。

在Tomcat博客中我提到过：Tomcat访问任何的资源都是在访问Servlet！，当然了，JSP也不例外！JSP本身就是一种Servlet。为什么我说JSP本身就是一种Servlet呢？其实JSP在第一次被访问的时候会被编译为HttpJspPage类（该类是HttpServlet的一个子类）

编译过程是这样子的：
1. 浏览器第一次请求1.jsp时，Tomcat会将1.jsp转化成1_jsp.java这么一个类，并将该文件编译成class文件。
2. 编译完毕后再运行class文件来响应浏览器的请求。以后访问1.jsp就不再重新编译jsp文件了，直接调用class文件来响应浏览器。当然了，如果Tomcat检测到JSP页面改动了的话，会重新编译的。
3. 既然JSP是一个Servlet，那JSP页面中的HTML排版标签是用write()出去的罢了。说到底，JSP就是封装了Servlet的java程序罢了。

