spider 的使用说明：

继承scrapy.spider

name spider的名字

start_urls初始链接

request 发送请求并且捕获相应，通过回调函数parse处理response相应

request函数能够发送请求，request函数需要一个回调函数，来接受请求。默认的request函数调用了parse，但是在多次request中，需要设置不同的parse函数，来处理多次请求

python
回调函数的意思就是在一个函数的某个地方通过一个函数指针，调用另外一个函数，使得函数跳转。因为python是脚本，所以，在没有返回值的python函数执行时，如果函数跳转到其他地方，并不会返回一个值到原来的地方。

轮换useragent的目的：

当你使用同一个浏览器的时候（同一个useragent）会因为过度浪费服务器资源而被禁掉。

scrapy的一些内置特性：

scrapy内置的数据抽取其：css/xpath/re

scrapy内置结果的输出：csv,xml,json

自动处理编码

有丰富的内置扩展

cookies session 客户端和服务器端的缓存机制

Http features：compression，authentication，caching

user-agent spoofing轮换useragent（用户代理的意思浏览器的类型）

robots.txt 网站中用来告诉爬虫那些资源时可以被访问的，哪些资源时不能被访问的。

crawl depth restriction 限制爬去的深度

itme Pipeline的作用：

清洗HTML数据

验证抓取到的数据

检查是否存在重复

存储抓取到的数据到数据库中。

关于parse分析response后返回值的问题：

如果parse的返回值是一个request，将进行更深层侧的爬虫抓去。

如果parse的返回值是一个item，则程序的执行权就会交个itempipeline，然后pipeline负责处理返回的item对象。包括这些item对象是否合理。

一个简单爬虫的具体分析步骤：

创建工程

编写item用来结构化分析数据使用

编写spider用来爬去具体的网站

编写和配置pipeline，主要实现对生成的item的处理

调试运行代码
