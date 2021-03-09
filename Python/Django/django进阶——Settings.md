MEIDIA_ROOT

保存用户上传的目录和系统绝对文件系统路径。

-   处理从MEDIA_ROOT提供的媒体的URL，用于管理存储的文件。
    如果设置为非空值，则它必须以斜杠结尾。
    您将需要将这些文件配置为在开发和生产环境中提供服务。

-   如果您想在模板中使用{{MEDIA_URL}}，请在“模板”的“context_processors”选项中添加“django.template.context_processors.media”

MEDIA_URL

引用或者说访问MEIDIA_ROOT中的文件时使用的URL，即客户通过浏览器访问的路径。

STATIC_ROOT

用来保存静态文件（搭建网站的css库，scrip脚本，图片），默认值为none。收集静态文件进行部署的目录的绝对路径

STATIC_URL

引用STATIC_ROOT中静态文件时使用的URL

-   如果不是
    None，这将被用作资产定义（Media类）和staticfiles应用程序的基本路径。

-   如果设置为非空值，则它必须以斜杠结尾。您可能需要将这些文件配置为在开发中提供服务，并且在生产中肯定需要这样做。

-   能够构建静态文件相对路径的URL例如将静态文件存储在应用程序中的静态文件夹中。my_app
    / static / my_app / example.jpg：

    {% load static %} \<img src="{% static "my_app/example.jpg" %}" alt="My
    image"/\>

STATICFILES_DIRS

此设置定义如果FileSystemFinder查找器启用，staticfiles应用程序将遍历的其位置，例如
如果您使用collectstatic或findstatic管理命令或使用静态文件服务视图。也就是说添加静态文件查找位置的绝对路径

>   STATICFILES_DIRS = [ "/home/special.polls.com/polls/static",
>   "/home/polls.com/polls/static", "/opt/webfiles/common", ]

-   应将此设置为包含其他文件目录的完整路径的字符串列表

INSTALLED_APPS = (

'django.contrib.admin', \#用来提供数据库管理功能

'django.contrib.auth', \#用来提供用户管理功能，包好访问界面

'django.contrib.contenttypes', \#用来提供：

'django.contrib.sessions', \#用来提供session管理功能

'django.contrib.messages', \#

'django.contrib.staticfiles', \#用来提供静态文件的查找、访问和管理功能。

)

django中自带的app说明

每个APP应该有自己的model、view、templates。

总的APP有一个view和template，不需要model
