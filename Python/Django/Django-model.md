MVC模型中model部分，提供对数据库的操作支持。

**配置文件settings.py**

DATABASES = { 'default': { 'ENGINE': 'django.db.backends.mysql', \# 或者使用
mysql.connector.django 'NAME': 'test', 'USER': 'test', 'PASSWORD': 'test123',
'HOST':'localhost', 'PORT':'3306', } }

**django-admin.py startapp TestModel**

创建模型，目录结构如下

HelloWorld\|-- TestModel\| \|-- \__init_\_.py\| \|-- admin.py
在管理界面中修改应用程序的模型\| \|-- models.py 存储所有的应用程序的模型\| \|--
tests.py 单元测试\| \|-- views.p 应用程序的视图

**对models.py的理解**

\# models.pyfrom django.db import modelsclass Test(models.Model): name =
models.CharField(max_length=20)

是模型定义的地方，提供了与数据库对应的类方法

**配置INSTALLED_APPS这一项**

INSTALLED_APPS = ( 'django.contrib.admin', 'django.contrib.auth',
'django.contrib.contenttypes', 'django.contrib.sessions',
'django.contrib.messages', 'django.contrib.staticfiles', 'TestModel', \#
添加此项)

**实现数据库迁移工作**

-   **python manage.py makemigrations TestModel**

    创建特定的.py
    文件，用来让Django记录模型的特点，和对数据库的操作（但实际上没有操作数据库。）

-   **python manage.py migrate TestModel**

    将模型和数据库链接。对应模型，在数据库中创建指定的表格。如果已经建好数据库，应该不用执这两个命令。

数据库的相关操作def testdb(request): \# 初始化 response = "" response1 = "" \#
通过objects这个模型管理器的all()获得所有数据行，相当于SQL中的SELECT \* FROM list
= Test.objects.all() \# filter相当于SQL中的WHERE，可设置条件过滤结果 response2 =
Test.objects.filter(id=1) \# 获取单个对象 response3 = Test.objects.get(id=1) \#
限制返回的数据 相当于 SQL 中的 OFFSET 0 LIMIT 2;
Test.objects.order_by('name')[0:2] \#数据排序 Test.objects.order_by("id") \#
上面的方法可以连锁使用 Test.objects.filter(name="runoob").order_by("id") \#
输出所有数据 for var in list: response1 += var.name + " " response = response1
return HttpResponse("\<p\>" + response + "\</p\>")

**Python可以使用自带的shell实现数据库的操作（真他妈的简洁优雅）**

-   数据库存储

    p = Person(name = "WZ", age = 23)

    p.save()

-   all()用来获取对象列表

-   get()用来获取一个对象

-   filter()用来获取满足条件的一系列对象，允许使用Python这则表达式进行查询。
