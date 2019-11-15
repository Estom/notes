# Apache详解

## Apache目录结构说明
* /etc/httpd/conf/httpd.conf:最主要的配置文件，不过很多其他的distribution都将这个文件拆成数个小文件，分别管理不同的参数。但是最主要配置文件还是以这个文件名为主。
* /etc/httpd/conf.d/*.conf:这个事CentOS的特色之一，如果你不想修改原始配置文件httpd.conf的话，那么可以将你自己的额外参数独立出来，而启动apache时，这个文件就会被读入到主要配置文件。

* /var/www/html:这里是CentOS默认的“首页”所在目录。
* /var/www/error:如果因为主机设置错误，或者是浏览器端要求的数据错误，在浏览器上出现的错误信息就已这个目录的默认信息为主。
* /var/www/icons:提供apache的一些小图标
* /var/www/cgi-bin :默认给一些可执行的CGI程序放置的目录
* /var/log/httpd:默认apache的日志文件都放在这里，对于流量大的网站来说，这个目录要很小心，因为这个文件很容易变的很大，您需要足够的空间哦

* /usr/lib/httpd/modules:apache支持很多的模块，所以您想要使用的模块默认都放置在此目录
* /usr/sbin/apachectl:这是Apache的主要执行文件，这个执行文件其实是shell script,它可以主动检测系统上的一些设置值，好让您启动Apache时更简单
* /usr/sbin/httpd:这是主要的apache的二进制文件
* /usr/bin/htpasswd:当您想登陆某些网页时，需要输入账号与密码。那么Apache本身就提供一个最基本的密码保护方式。该密码的产生就是通过这个命令实现的


## MySQL目录与文件说明


* /etc/my.cnf:这是Mysql的配置文件，包括您想要进行mysql数据库的最佳化，或者是正对mysql进行一些额外的参数指定，都可以在这个文件里实现
* /usr/lib/mysql:这个目录是MySQL数据库放置的位置，当启动任何MySQL的服务器时，请务必记得在备份时，将此目录完整的备份下来。

## PHP文件说明

* /usr/lib/httpd/modules/libphp4.so:PHP提供给apache使用的模块，这个关系我们能否在apache网页上面设计php程序语言的最重要文件
* /etc/httpd/conf.d/php.conf:你要不要手动将该模块写入Httpd.conf中呢？不需要，因为系统已经主动将php设置参数写入到这个文件中了，而这个文件会在apache重新启动时被读入。
* /etc/php.ini:这是PHP的主要配置文件，包括PHP能不能允许用户上传文件，能不能允许某些低安全性的标志等，都在这个配置文件中设置。
* /etc/php.d/mysql.ini /usr/lib/php4/mysql.so:PHP能否可以支持MySQL接口就看这两个文件了。这两个文件是由php-mysql软件提供的
* /usr/bin/phpize /usr/include/php:如果您以后想要安装类似PHP加速器可以让浏览速度加快的话，那么这个文件与目录就需要存在，否则加速器软件没法用。

## Apache的配置说明
* httpd.conf的基本设置是这样的:
```
<设置项目>
      次设置项目内的相关参数
      。。。。
</设置项目>
```

* ServerTokens OS
这个项目在告诉客户端WWW服务器的版本和操作系统，不需要改编它
如果你不想告诉太多的主机信息，将这个项目的OS改成Minor

* ServerRoot "/etc/httpd"
这个是设置文件的最顶层目录，通常使用绝对路径，下面某些数据设置使用相对路径时.
就是与这个目录设置值有关的下层目录，不需要更改它

* TimeOut 
设定 服务器接收至完成的最长等待时间 

* KeepAlive 
设定服务器是否开启连续请求功能,真实服务器一般都要开启
* Port 
设定http服务的默认端口。
* User/Group 
设定 服务器程序的执行者与属组,这个一般是Apache

* Listen 80
端口Listen 12.34.56.78:80

* DocumentRoot "/var/www/html"
文档目录

* 对 /var/www目录访问限制
```
<Directory "/var/www">
    AllowOverride None
    # Allow open access:
    Require all granted
</Directory>
对/var/www/html目录访问限制
	<Directory "/var/www/html">
　　 	Options Indexes FollowSymLinks
　　	 	AllowOverride None
 　　	Require all granted
	</Directory>
```
* 默认编码
```
AddDefaultCharset UTF-8
EnableMMAP off
EnableSendfile on
include进来其它配置文件
IncludeOptional conf.d/*.conf
```

## Mysql服务安装

安装成功，傻瓜安装，一键配置。

## FTP服务的安装


## 工程项目的导入和配置