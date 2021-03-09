其中有一节专门讲了File对象如何上传，然而上一次为这个文件上传苦恼了很久。

**重新复习了两个关键对象**

**HttpRequest对象**

.scheme 表示请求的方案http或者https

.body
原始HTTP请求的正文。包括GET请求的参数，POST请求的表单，媒体对象的二进制文件。

.path 表示请求页面的完整路径，不包含域名，可以用来点赞或者喜欢之后刷新原来的网页

.method HTTP请求的方法GET或者POST

.encoding 请求的编码

.GET 一个字典对象，包含HTTP GET的参数

.POST 一个类字典对象，包含了表单数据的请求。

.FILES 一个字段对象，包含所上传的文件。

.COOKIES 标准的python字典，包含所有的cookie。键和值都是字符串

.META 一个python字典，包含HTTP头部信息。

.user 一个用户对象。

.session 一个可以读写的session字典对象。

方法：

get\_host()

获取主机名**127.0.0.1:8000**

get_full\_path()

返回path和查询字符串**/music/bands/the_beatles/?print=true**

**QueryDict对象**

首先实现了字典所有的标准方法。

\_\_getitem\__(key)

\_\_setitem\__(key,value)

\__contains__(key)

get(key,default)不存在时返回默认值

setdefault(key,default)

update(other_dict)，将新的值添加到后边

items()返回字典的一个列表[('a', '3')]

iteritems()

iterlists()

values() 返回值的一个列表['3']

itervalues() 返回一个迭代器

copy()调用python库中的deepcopy()进行神复制

getlist(key,default)以列表返回所有请求的键

appendlist(key,item)

setlistdefault(key,default\_list)

lists()

pop(key)弹出

popitem()随机弹出

dict()返回dict对象

**httpResponse对象**

.content 一个字节字符

.charset response编码的字符串

.status_code HTTP相应状态码

.reason_phrase HTTP原因短语

.streaming 总是false

.closed 响应是否关闭

.\_\_setitem\__(header,value)设定报文首部。

.\_\_delitem\__(header)

.\_\_getitem\__(header)

.has\_header(header)

.set\_cookie()

.set_signed_cookie() 设置cookie，并用秘钥签名

.delete_cookie() 删除cookie

.write()

.flush()

.tell()

**其子类包括以下**

HttpResponseRedirect对象

HttpResponseNotModified

HttpResponsePermanentRedirect
