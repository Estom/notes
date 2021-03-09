**模型的内容**

**from** django.db **import** models

**class** Blog(models.Model):

name **=** models.CharField(max_length**=**100)

tagline **=** models.TextField()

**def** \_\_unicode\__(self): \# \__str_\_ on Python 3

**return** self.name

**class** Author(models.Model):

name **=** models.CharField(max_length**=**50)

email **=** models.EmailField()

**def** \_\_unicode\__(self): \# \__str_\_ on Python 3

**return** self.name

**class** Entry(models.Model):

blog **=** models.ForeignKey(Blog)

headline **=** models.CharField(max_length**=**255)

body_text **=** models.TextField()

pub_date **=** models.DateField()

mod_date **=** models.DateField()

authors **=** models.ManyToManyField(Author)

n_comments **=** models.IntegerField()

n_pingbacks **=** models.IntegerField()

rating **=** models.IntegerField()

**def** \_\_unicode\__(self): \# \__str_\_ on Python 3

**return** self.headline

**使用QuerySet创建对象的方法**

类名字的静态变量objects，就是与值相关的QuerySet对象

\>\>\> **from** blog.models **import** Blog

\>\>\> b **=** Blog(name**=**'Beatles Blog', tagline**=**'All the latest Beatles
news.')

\>\>\> b.save()

总之，一共有四种方法

\# 方法 1

Author.objects.create(name**=**"WeizhongTu", email**=**"tuweizhong@163.com")

\# 方法 2

twz **=** Author(name**=**"WeizhongTu", email**=**"tuweizhong@163.com")

twz.save()

\# 方法 3

twz **=** Author()

twz.name**=**"WeizhongTu"

twz.email**=**"tuweizhong@163.com"

twz.save()

\# 方法 4，首先尝试获取，不存在就创建，可以防止重复

Author.objects.get_or\_create(name**=**"WeizhongTu",
email**=**"tuweizhong@163.com")

\# 返回值(object, True/False)

**查找对象的方法**

Person.objects.all() \# 查询所有

Person.objects.all()[:10]
切片操作，获取10个人，不支持负索引，切片可以节约内存，不支持负索引，后面有相应解决办法，第7条

Person.objects.get(name**=**"WeizhongTu") \# 名称为 WeizhongTu
的一条，多条会报错

get是用来获取一个对象的，如果需要获取满足条件的一些人，就要用到filter

Person.objects.filter(name**=**"abc") \#
等于Person.objects.filter(name__exact="abc") 名称严格等于 "abc" 的人

Person.objects.filter(name_\_iexact**=**"abc") \# 名称为 abc
但是不区分大小写，可以找到 ABC, Abc, aBC，这些都符合条件

Person.objects.filter(name__contains**=**"abc") \# 名称中包含 "abc"的人

Person.objects.filter(name_\_icontains**=**"abc") \#名称中包含
"abc"，且abc不区分大小写

Person.objects.filter(name__regex**=**"\^abc") \# 正则表达式查询

Person.objects.filter(name_\_iregex**=**"\^abc")\# 正则表达式不区分大小写

\# filter是找出满足条件的，当然也有排除符合某条件的

Person.objects.exclude(name__contains**=**"WZ") \# 排除包含 WZ 的Person对象

Person.objects.filter(name__contains**=**"abc").exclude(age**=**23) \#
找出名称含有abc, 但是排除年龄是23岁的

**删除对象的方法**

Person.objects.filter(name__contains**=**"abc").delete() \# 删除 名称中包含
"abc"的人

如果写成

people **=** Person.objects.filter(name__contains**=**"abc")

people.delete()

效果也是一样的，Django实际只执行一条 SQL 语句。

**更新某个内容的方法**

(1) 批量更新，适用于 .all() .filter() .exclude() 等后面
(危险操作，正式场合操作务必谨慎)

Person.objects.filter(name__contains**=**"abc").update(name**=**'xxx') \#
名称中包含 "abc"的人 都改成 xxx

Person.objects.all().delete() \# 删除所有 Person 记录

(2) 单个 object 更新，适合于 .get(), get_or_create(), update_or_create()
等得到的 obj，和新建很类似。

twz **=** Author.objects.get(name**=**"WeizhongTu")

twz.name**=**"WeizhongTu"

twz.email**=**"tuweizhong@163.com"

twz.save() \# 最后不要忘了保存！！！

**QuerySet中可迭代对象**

(1). 如果只是检查 Entry 中是否有对象，应该用 Entry.objects.all().exists()

(2). QuerySet 支持切片 Entry.objects.all()[:10] 取出10条，可以节省内存

(3). 用 len(es) 可以得到Entry的数量，但是推荐用
Entry.objects.count()来查询数量，后者用的是SQL：SELECT COUNT(\*)

(4). list(es) 可以强行将 QuerySet 变成 列表

**QuerySet排序结果**

Author.objects.all().order\_by('name')

Author.objects.all().order_by('-name') \# 在 column name
前加一个负号，可以实现倒序

**QuerySet支持链式查询**

Author.objects.filter(name__contains**=**"WeizhongTu").filter(email**=**"tuweizhong@163.com")

Author.objects.filter(name__contains**=**"Wei").exclude(email**=**"tuweizhong@163.com")

\# 找出名称含有abc, 但是排除年龄是23岁的

Person.objects.filter(name__contains**=**"abc").exclude(age**=**23)

**QuerySet 重复的问题，使用 .distinct() 去重**
