Django工程创建

**django-admin.py startproject HelloWorld**

创建Django项目。其目录结构为：\|-- HelloWorld //项目的容器，内有view控制中心\|
\|-- \__init_\_.py //包声明文件\| \|-- settings.py //该Django项目的配置文件\|
\|-- urls.py //Django项目的URL声明\| \`-- wsgi.py
//该Django项目的WSGI兼容的web服务器入口（python内置服务器程序） \`-- manage.py
//与项目相关的命令行工具，实现与Django的交互。

**python manage.py runserver 0.0.0.0:8000**

启动服务器，并将该项目部署到服务器当中。

**HelloWorld/view.py**

from django.http import HttpResponsedef hello(request): return
HttpResponse("Hello world ! ")

view文件的标准函数。负责接收request，并将request进行处理，返回response，提供给用户。

**Helloworld/urls.py**

from django.conf.urls import urlfrom . import viewurlpatterns = [ url(r'\^\$',
view.hello),]

urls文件的标准格式，哦调羹说配置URL和view方法之间的对应关系，建立URL和view方法之间的映射。其中urlpatterns变量的配置函数如下：

url(regex, view, kwargs, name)

regex: 正则表达式，匹配相应的url

view: view方法，用来吹与正则表达式匹配的url

kwargs：view使用的字典类型的参数。

name：用来反向获取URL

**关于url name的详细说明。**

-   为了在视图渲染过程中获取真正的请求网址。大致理解了一些，url可以通过正则表达式匹配到urlpattern中的一个函数，但是有的时候这个网址会变化，导致原来的匹配不再生效。那么就提供了一种通过名字来匹配具体url的方式。当网址变化时，名字已久能帮助原来的url定位到新的网址。

-   在原网址链接的地方使用名字+参数的方式，可以自动渲染成最新的url格式。

原来的匹配项

url(r'\^add/(\\d+)/(\\d+)/\$', calc\_views.add2, name**=**'add2'),

现在的匹配项

url(r'\^new_add/(\\d+)/(\\d+)/\$', calc\_views.add2, name**=**'add2'),

原来的链接将不能访问

\<**a** href="/add/4/5/"\>link\</**a**\>

但是通过名字的链接会自动渲染成当前的url匹配模式

\<**a** href="{% url 'add2' 4 5 %}"\>link\</**a**\>

渲染成→\<**a** href="/add/4/5/"\>link\</**a**\>

渲染成→\<**a** href="/new_add/4/5/"\>link\</**a**\>

具体渲染的方式为，下面的方式会生成对应的urlpattern。

**from** django.core.urlresolvers **import** reverse

reverse('add2', args**=**(a, b))
