template模板的具体使用

创建模板，目录结构如下：

\|-- HelloWorld\|-- manage.py \`-- templates \`-- hello.html

修改配置文件当中TEMPLATES的基础路径

...TEMPLATES = [ { 'BACKEND': 'django.template.backends.django.DjangoTemplates',
'DIRS': [BASE_DIR+"/templates",], \# 修改位置 'APP_DIRS': True, 'OPTIONS': {
'context_processors': [ 'django.template.context_processors.debug',
'django.template.context_processors.request',
'django.contrib.auth.context_processors.auth',
'django.contrib.messages.context_processors.messages', ], }, },]...

使用模板如下(view.py)：

使用render函数+数据+渲染内容实现结果输出

from django.shortcuts import renderdef hello(request): context = {}
context['hello'] = 'Hello World!' return render(request, 'hello.html', context)

Django templates模板标签

**if-elif-endif标签**

{% if condition %}

display 1

{% elif condition2 %}

display 2

{% else %}

display 3

{% endif %}

**for-endfor标签**

{% for athlete in athlete_list %}

\<li\>{{ athlete.name}}\</li\>

{% endfor %}

循环中的默认变量

{**%** **for** item **in** List **%**}

{{ item }}{**%** **if** **not** forloop.last **%**},{**%** endif **%**}

{**%** endfor **%**}

\<**ul**\>

{% for athlete in athlete_list %}

\<**li**\>{{ athlete.name }}\</**li**\>

{% empty %}

\<**li**\>抱歉，列表为空\</**li**\>

{% endfor %}

\</**ul**\>

| 变量                    | 描述                                                  |
|-------------------------|-------------------------------------------------------|
| **forloop.counter**     | 索引从 1 开始算                                       |
| **forloop.counter0**    | 索引从 0 开始算                                       |
| **forloop.revcounter**  | 索引从最大长度到 1                                    |
| **forloop.revcounter0** | 索引从最大长度到 0                                    |
| **forloop.first**       | 当遍历的元素为第一项时为真                            |
| **forloop.last**        | 当遍历的元素为最后一项时为真                          |
| **forloop.parentloop**  | 用在嵌套的 for 循环中， 获取上一层 for 循环的 forloop |

**ifequal/ifnotequal 标签**

{% ifequal user currentuser %}

\<h1\>Welcome!\</h1\>

{% endifequal %}

**注释标签**

{\# 这是一个注释 \#}

**过滤器标签**

lower是一个过滤管道，允许被套接

{{ name\|lower }}

常见的过滤管道

{{...\|first\|upper\|lower\|truncatewords:"30"\|date:"F j ,Y"}}

**include标签**

{% include "nav.html" %}

Django模板的继承

模板通过继承实现代码的复用，下面是父文件

\<body\> \<h1\>Hello World!\</h1\> \<p\>菜鸟教程 Django 测试。\</p\> {% block
mainbody %} \<p\>original\</p\>{% endblock %}\</body\>

下面是子文件，可以替换block部分

{% extends "base.html" %} {% block mainbody %}\<p\>继承了 base.html 文件\</p\>{%
endblock %}
