**Django settings 中 cache 默认为**

{

'default': {

'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',

}

}

也就是默认利用**本地的内存**来当缓存，速度很快。当然可能出来内存不够用的情况，其它的一些内建可用的
Backends 有

'django.core.cache.backends.db.DatabaseCache'

'django.core.cache.backends.dummy.DummyCache'

'django.core.cache.backends.filebased.FileBasedCache'

'django.core.cache.backends.locmem.LocMemCache'

'django.core.cache.backends.memcached.MemcachedCache'

'django.core.cache.backends.memcached.PyLibMCCache'

**利用文件系统来缓存：**

CACHES **=** {

'default': {

'BACKEND': 'django.core.cache.backends.filebased.FileBasedCache',

'LOCATION': '/var/tmp/django_cache',

'TIMEOUT': 600,

'OPTIONS': {

'MAX_ENTRIES': 1000

}

}

}

**利用数据库来缓存，利用命令创建相应的表：python manage.py createcachetable
cache_table_name**

CACHES **=** {

'default': {

'BACKEND': 'django.core.cache.backends.db.DatabaseCache',

'LOCATION': 'cache_table_name',

'TIMEOUT': 600,

'OPTIONS': {

'MAX_ENTRIES': 2000

}

}

}

**一般来说我们用 Django 来搭建一个网站，要用到数据库等。**

**from** django.shortcuts **import** render

**def** index(request):

\# 读取数据库等 并渲染到网页

\# 数据库获取的结果保存到 queryset 中

**return** render(request, 'index.html', {'queryset':queryset})

**像这样每次访问都要读取数据库，一般的小网站没什么问题，当访问量非常大的时候，就会有很多次的数据库查询，肯定会造成访问速度变慢，服务器资源占用较多等问题。**

**from** django.shortcuts **import** render

**from** django.views.decorators.cache **import** cache_page

@cache_page(60 **\*** 15) \# 秒数，这里指缓存 15
分钟，不直接写900是为了提高可读性

**def** index(request):

\# 读取数据库等 并渲染到网页

**return** render(request, 'index.html', {'queryset':queryset})
