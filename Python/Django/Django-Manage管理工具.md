django-admin.py全局管理工具

django-admin.py 基本命令 [参数列表]

-   check

-   compilemessages

-   createcachetable

-   

-   diffsettings

-   dumpdata

-   flush

-   inspectdb

-   loaddata

-   makemessages

**[migrate]:数据库命令**

-   makemigrations

    让django工程记录数据模型的迁移内容。知道那一部分需要迁移，模型有哪些变化，但是不进行操作数据库。

-   migrate

真正的数据模型迁移工作，对应数据模型创建相应的数据表内容。

-   showmigrations

显示数据库迁移内容

[sqldata]:数据库操作命令

-   flush

清空全部数据

-   dumpdata appname \> app.json

导出json格式的数据

-   loaddata

导入json格式的数据

-   dbshell

项目数据库的终端环境，进入数据库的命令行

-   sendtestmail

-   shell

**[sql]:数据库控制命令**

-   sqlflush

-   sqlsequencereset

-   squashmigrations

**[start]:创建命令**

-   startapp

创建Django的数据模型，主要是MVC中的model部分。

-   startproject HelloWorld

创建一个名为HelloWorld的项目

**[test]:测试命令**

-   test

-   testserver

manage.py项目管理工具

manage.py 基本命令 参数列表

**[auth]:用户操作命令**

-   changepassword

修改用户密码

-   createsuperuser

创建超级管理员

**[contenttypes]**

-   remove_stale_contenttypes

**[django]**

-   check

-   compilemessages

-   createcachetable

-   dbshell

-   diffsettings

-   dumpdata

-   flush

-   inspectdb

-   loaddata

-   makemessages

-   makemigrations

-   migrate

-   sendtestemail

-   shell

-   showmigrations

-   sqlflush

-   sqlmigrate

-   sqlsequencereset

-   squashmigrations

-   startapp

-   startproject

-   test

-   testserver

**[sessions]**

-   clearsessions

**[staticfiles]**

-   collectstatic

-   findstatic

-   runserver

启动Django自带的服务器接口，对工程进行部署

python manage.py createssuperuser

用来创建超级用户，通过admin管理工具，实现对数据库的管理。

Django通过模型管理数据库的方法：

from django.contrib import adminfrom TestModel.models import Test\# Register
your models here.admin.site.register(Test)

自定义表单

内联显示

列表显示

可以通过一大堆操作来自定义表单的格式，实现后台管理页面。

准确的说，这个东西是可以用来管理数据的，但是不能用来做前端，毕竟太丑。

也就是说，如果我用Django做完了一个后台管理数据的页面，最多也就新奇的说，能够进行管理了，还要按照Django的模式，来设计前端、对数据进行渲染、然后呈现出来。

也就是说，接下来要用Django做三件事情：

1\. 实现后台的数据管理

2\. 写完具有相应功能的bootstrap前端

3\. 实现后端相应的交互功能。

存在的弊端：

Django是一种重量级的框架，很多东西都封装到内部了，可能搭建一个优美的网站十分简单，但是最后如果要处理Android客户端的请求，返回json格式的数据，还是需要纯python的编程来实现。也就是说要跳出到框架之外。

看情况吧，如果真的需要的话，还是要学习这些新的东西。
