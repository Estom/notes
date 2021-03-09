**User对象字段**

-   **username**

-   password

-   email

-   first_name

-   last_name

**创建User**

-   User.objects.create\_user() user.save()

-   manage.py createsuperuser

-   manage.py changepassword username

**验证User的用户名密码**

-   **authenticate(username, password)**

**from** **django.contrib.auth** **import** authenticate user **=**
authenticate(username**=**'john', password**=**'secret')**if** user **is**
**not** None: *\# the password verified for the user* **if** user**.**is_active:
**print**("User is valid, active and authenticated") **else**: **print**("The
password is valid, but the account has been disabled!")**else**: *\# the
authentication system was unable to verify the username and password*
**print**("The username and password were incorrect.")

**关于权限（User本身设置的两个权限已经够用，后台管理员和普通用户）**

**web请求中的认证**

-   **Django**使用会话（session）和中间件来拦截request对象到认证系统当中。会在每一个请求上提供一个request.user属性，表示当前用户。若果当前用户没有登录，则该属性被设置为AnonymousmousUser的一个实例，否则是User的一个实例。

-   通过is_authenticated() 区分他们

**if** request**.**user**.**is\_authenticated(): *\# Do something for
authenticated users.* **...else**: *\# Do something for anonymous users.*
**...**

**登录一个用户**

-   从视图中登入一个用户，使用login函数，接受一个HttpRequest对象和一个User对象。

-   login()使用Django的session框架保存用户的信息，作为服务器端和客户端记住登录状态的工具。

**from** **django.contrib.auth** **import** authenticate, login **def**
**my_view**(request): username **=** request**.**POST['username'] password **=**
request**.**POST['password'] user **=** authenticate(username**=**username,
password**=**password) **if** user **is** **not** None: **if**
user**.**is_active: login(request, user) *\# Redirect to a success page.*
**else**: *\# Return a 'disabled account' error message* **...** **else**: *\#
Return an 'invalid login' error message.* **...**

**登出一个用户**

-   使用logout()函数。接受一个HttpRequest对象并且没有返回值。即使没有用户登入也不会抛出错误。所有的会话session框架中的数据都将会被清除。

-   能够接受一个URL作为登出后跳转的URL

**只允许登录的用户访问**

-   原始方法使用request.user.is_authenticated()并进行重定向到一个登录页面。或者使用一个新的页面对错误信息进行渲染

**from** **django.conf** **import** settings **from** **django.shortcuts**
**import** redirect **def** **my_view**(request): **if** **not**
request**.**user**.**is_authenticated(): **return**
redirect('**%s**?next=**%s**' **%** (settings**.**LOGIN_URL, request**.**path))
*\# ...*

**from** **django.shortcuts** **import** render **def** **my_view**(request):
**if** **not** request**.**user**.**is_authenticated(): **return**
render(request, 'myapp/login_error.html') *\# ...*

-   使用login_required装饰器，比较快捷的方式

**login\_required([**redirect_field_name=REDIRECT_FIELD_NAME**,**
login_url=None**])**

**from** **django.contrib.auth.decorators** **import** login_required
@login\_required**def** **my_view**(request): **...**

主要完成了下面的事，如果用户没有登入，则重定向到setting.LOGIN_URL，并将当前访问的绝对路径传递到查询字符串中；如果用户已经登入，则正常执行视图。视图的代码可以安全地假设用户已经登入。

默认情况下，在成功认证后用户应该被重定向的路径存储在查询字符串的一个叫做**"next"**的参数中。如果对该参数你倾向使用一个不同的名字，[**login\_required()**](http://python.usyiyi.cn/documents/django_182/topics/auth/default.html#django.contrib.auth.decorators.login_required)带有一个可选的**redirect_field_name**参数

**from** **django.contrib.auth.decorators** **import** login_required
@login_required(redirect_field_name**=**'my_redirect_field')**def**
**my_view**(request):

可以添加一个login_url参数，用来作为认证失败后重定向的位置

**from** **django.contrib.auth.decorators** **import** login_required
@login_required(login_url**=**'/accounts/login/')**def** **my_view**(request):
**...**

**给已经登录的用户添加访问限制（两个装饰器估计用不到）**

-   原始方法，检查request.user的不同的字段

-   **user_passes_test** 装饰器，进行重定向。

-   permission_required装饰器，检查是否具有权限。

-   对基于类的普通视图进行权限控制，可以加装饰器view.dispatch

**密码更改后session会失效**

**用户登录认证的视图（方便快速的完成登录注册等操作）**

**这个真的没看懂怎么用，貌似就是一系列的默认视图，但是……不是很懂**

**扩展已有的用户模型**

你可以创建基于[**User**](http://python.usyiyi.cn/documents/django_182/ref/contrib/auth.html#django.contrib.auth.models.User)
的[代理模型](http://python.usyiyi.cn/documents/django_182/topics/db/models.html#proxy-models)。代理模型提供的功能包括默认的排序、自定义管理器以及自定义模型方法。如果你想存储新字段到已有的**User**里，那么你可以选择[one-to-one
relationship](http://python.usyiyi.cn/documents/django_182/ref/models/fields.html#ref-onetoone)来扩展用户信息。这种
one-to-one 模型一般被称为资料模型(profile
model)，它通常被用来存储一些有关网站用户的非验证性（ non-auth
）资料。例如，你可以创建一个员工模型 (Employee model)：

**from** **django.contrib.auth.models** **import** User **class**
**Employee**(models**.**Model): user **=** models**.**OneToOneField(User)
department **=** models**.**CharField(max_length**=**100)

在视图中的访问方式，可以直接查找代理中的其他数据类型

**\>\>\>** u **=** User**.**objects**.**get(username**=**'fsmith')**\>\>\>**
freds_department **=** u**.**employee**.**department

要将个人资料模型的字段添加到管理后台的用户页面中，请在应用程序的**admin.py**定义一个[**InlineModelAdmin**](http://python.usyiyi.cn/documents/django_182/ref/contrib/admin/index.html#django.contrib.admin.InlineModelAdmin)（对于本示例，我们将使用[**StackedInline**](http://python.usyiyi.cn/documents/django_182/ref/contrib/admin/index.html#django.contrib.admin.StackedInline)
)并将其添加到**UserAdmin**类并向[**User**](http://python.usyiyi.cn/documents/django_182/ref/contrib/auth.html#django.contrib.auth.models.User)类注册的：

**from** **django.contrib** **import** admin **from**
**django.contrib.auth.admin** **import** UserAdmin **from**
**django.contrib.auth.models** **import** User **from**
**my_user_profile_app.models** **import** Employee *\# Define an inline admin
descriptor for Employee model\# which acts a bit like a singleton***class**
**EmployeeInline**(admin**.**StackedInline): model **=** Employee can_delete
**=** False verbose_name_plural **=** 'employee'*\# Define a new User
admin***class** **UserAdmin**(UserAdmin): inlines **=** (EmployeeInline, ) *\#
Re-register UserAdmin*admin**.**site**.**unregister(User)
admin**.**site**.**register(User, UserAdmin)

这些Profile models在任何方面都不特殊，它们就是和User
model多了一个一对一链接的普通Django models。
这种情形下，它们不会在一名用户创建时自动创建, 但是
**django.db.models.signals.post_save** 可以在适当的时候用于创建或更新相关模型。

注意使用相关模型的成果需另外的查询或者联结来获取相关数据，基于你的需求替换用户模型并添加相关字段可能是你更好的选择。但是，在你项目应用程序中，指向默认用户模型的链接可能带来额外的数据库负载。

为了表明这个模型是对于那个给定的站点，我们还需要配置一个AUTH_PROFILE_MODULE，这是一个字符串，包含两部分信息，由点号相连

-   app名：大小写敏感，一般是你使用manage.py startapp创建时用的名称

-   你自定义的模型名称，大小写不敏感

比如，app名为accounts，模型名为UserProfile

AUTH_PROFILE_MODULE = 'accounts.UserProfile'

一旦一个用户档案模型（额外信息模型）被定义然后用上述方法指明，每一个user对象都会有一个方法--get_profile()--去返回跟该用户相关的额外信息

**因为新建的数据库还没有迁移，所以与用户相关的功能还不能实现。那么可以先实现用户登录香瓜的功能。**

**如用户的注册、登录、登出等功能的相关控制。然后在实现与用户相关的功能，并添加权限控制。**

**1. 通过代理的方式建立UserNoramal用户扩展类。**

**配置UserNormal为User表的内联表，在管理页面进行管理。**

**（由于没有迁移数据库，不能运行admin）**

**2. 从登录页面开始继续下去，已经完成了各个页面的配置工作。**
