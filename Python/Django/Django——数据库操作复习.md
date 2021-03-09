这个是当前最终要的一部分知识，因为接下来的工作包括太多的数据库操作了，必须得详细了解一下。

\---------------------------------------------------------------------------------------------------------------

关于模型的说明

**字段选项**

定义字段过程中对字段的性质进行控制

-   null

-   blank

-   choices

-   db_column

-   db_index

-   db_tablespace

-   default

-   auto_to_now

-   error_messages

-   help_text

-   primary_key（主键）

-   unique（唯一性）

-   unique_for_date

-   unique_for_month

-   unique_for_year

-   verbose_name

-   验证器

    -   注册和获取查询

**字段类型**

定义字段的类型

-   AutoField自增字段

-   BigIntegerField

-   二进制字段

-   BooleanField

-   For

-   CommaSeparatedIntegerField

-   rendering

-   DateField

-   DecimalField

-   DurationField

-   EmailField

-   FileField

FileField和FieldFile

-   FilePathField

-   FloatField

-   forms

-   IntegerField

-   IPAddressField

-   GenericIPAddressField

-   NullBooleanField

-   PositiveIntegerField

-   PositiveSmallIntegerField

-   SlugField

-   SmallIntegerField

-   TextField（文本域）

-   TimeField

-   URLField

-   UUIDField

**字段关系**

-   ForeignField

-   ManyToManyField

-   OneToOneField

\--------------------------------------------------------------------------------------------------------------------------------

关于对象的操作

**创建对象**

直接创建

b **=** Blog(name**=**'Beatles Blog', tagline**=**'All the latest Beatles
news.')

可以使用objects管理器的create方法

joe **=** Author**.**objects**.**create(name**=**"Joe")

**保存对象**

可以保存对象的更新，也可以添加新的对象。

save()

**获取对象**

（管理器方法，执行sql语句）

有很多方法QuerySet API，单独说明

**---------------------------------------------------------**

**查询集求值方法**

因为Django采取了惰性查询的方法，只要不是用，就不会执行查询语句求值。以下方法，会导致sql语句被执行。

**迭代**

**切片（step参数为true）**

**序列化缓存**

**repr()**

**len()**返回查询集的长度，并对查询集进行求值（COUNT 函数是不求值得）

**list()**对查询集进行强制求值，从queryset变为普通列表

entry_list **=** list(Entry**.**objects**.**all())

**bool()**判断查询集是否存在

**if** Entry**.**objects**.**filter(headline**=**"Test"): **print**("There is at
least one Entry with the headline Test")

**基本查询**

Entry**.**objects**.**all()

返回包含数据库中所有对象的一个**查询集**。

**filter(\*\*kwargs)**

返回一个新的**查询集**，它包含满足查询参数的对象。

**exclude(\*\*kwargs)**

返回一个新的**查询集**，它包含不满足查询参数的对象。

Entry**.**objects**.**get(**\*\*kwargs**)

直接返回该对象（返回查询到的第一个对象）

**extra**

**extra(**select=None**,** where=None**,** params=None**,** tables=None**,**
order_by=None**,**
select_params=None**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet.extra)

有些情况下，Django的查询语法难以简单的表达复杂的 **WHERE** 子句，对于这种情况,
Django 提供了 **extra()** **QuerySet** 修改机制 — 它能在
**QuerySet**生成的SQL从句中注入新子句

功能太过强大应该用不到

**raw**

**raw(**raw_query**,** params=None**,** translations=None**)**

接收一个原始的SQL 查询，执行它并返回一个**django.db.models.query.RawQuerySet**
实例。这个**RawQuerySet** 实例可以迭代以提供实例对象，就像普通的**QuerySet**
一样。

**不返回查询集的查询**

**get**

**get(**\*\*kwargs**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet.get)

返回按照查询参数匹配到的对象，参数的格式应该符合 [Field
lookups](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#id4)的要求.

-   如果匹配到的对象个数不只一个的话，**get()**
    将会触发[**MultipleObjectsReturned**](http://python.usyiyi.cn/documents/django_182/ref/exceptions.html#django.core.exceptions.MultipleObjectsReturned)
    异常.
    [**MultipleObjectsReturned**](http://python.usyiyi.cn/documents/django_182/ref/exceptions.html#django.core.exceptions.MultipleObjectsReturned)
    异常是模型类的属性.

-   如果根据给出的参数匹配不到对象的话，**get()**
    将触发[**DoesNotExist**](http://python.usyiyi.cn/documents/django_182/ref/models/instances.html#django.db.models.Model.DoesNotExist)
    异常. 这个异常是模型类的属性.

Entry**.**objects**.**get(id**=**'foo') *\# raises Entry.DoesNotExist*

>   异常处理

>   **from** **django.core.exceptions** **import** ObjectDoesNotExist **try**: e
>   **=** Entry**.**objects**.**get(id**=**3) b **=**
>   Blog**.**objects**.**get(id**=**1)**except** ObjectDoesNotExist:
>   **print**("Either the entry or blog doesn't exist.")

**create**

**create(**\*\*kwargs**)**

一个在一步操作中同时创建对象并且保存的便捷方法.

p **=** Person**.**objects**.**create(first_name**=**"Bruce",
last_name**=**"Springsteen")

>   和:

>   p **=** Person(first_name**=**"Bruce", last_name**=**"Springsteen")
>   p**.**save(force_insert**=**True)

>   是等同的.

**get_or_create**

**get_or\_create(**defaults=None**,**
\*\*kwargs**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet.get_or_create)

一个通过给出的**kwargs**
来查询对象的便捷方法（如果你的模型中的所有字段都有默认值，可以为空），需要的话创建一个对象。

>   **try**: obj **=** Person**.**objects**.**get(first_name**=**'John',
>   last_name**=**'Lennon')**except** Person**.**DoesNotExist: obj **=**
>   Person(first_name**=**'John', last_name**=**'Lennon',
>   birthday**=**date(1940, 10, 9)) obj**.**save()

>   等同于

>   obj, created **=**
>   Person**.**objects**.**get_or\_create(first_name**=**'John',
>   last_name**=**'Lennon',defaults**=**{'birthday': date(1940, 10, 9)})

**update_or_create**

**update_or\_create(**defaults=None**,** \*\*kwargs**)**

一个通过给出的**kwargs** 来更新对象的便捷方法，
如果需要的话创建一个新的对象。**defaults** 是一个由 (field, value)
对组成的字典，用于更新对象。

**try**: obj **=** Person**.**objects**.**get(first_name**=**'John',
last_name**=**'Lennon') **for** key, value **in**
updated_values**.**iteritems(): setattr(obj, key, value)
obj**.**save()**except** Person**.**DoesNotExist:
updated_values**.**update({'first_name': 'John', 'last_name': 'Lennon'}) obj
**=** Person(**\*\***updated_values) obj**.**save()

等同于

obj, created **=** Person**.**objects**.**update\_or_create(
first_name**=**'John', last_name**=**'Lennon', defaults**=**updated_values)

**bulk_create**

**bulk\_create(**objs**,** batch_size=None**)**

此方法以有效的方式（通常只有1个查询，无论有多少对象）将提供的对象列表插入到数据库中：

**\>\>\>** Entry**.**objects**.**bulk\_create([**...** 
Entry(headline**=**"Django 1.0 Released"),**...**  Entry(headline**=**"Django
1.1 Announced"),**...**  Entry(headline**=**"Breaking: Django is
awesome")**...** ])

**count**

**count()**

返回在数据库中对应的 **QuerySet**.对象的个数。 **count()** 永远不会引发异常。

例：

*\# Returns the total number of entries in the
database.*Entry**.**objects**.**count()*\# Returns the number of entries whose
headline contains
'Lennon'*Entry**.**objects**.**filter(headline__contains**=**'Lennon')**.**count()

**iterator**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#iterator)

**iterator()**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet.iterator)

评估**QuerySet**（通过执行查询），并返回一个迭代器

**first**

**first()**

返回结果集的第一个对象, 当没有找到时返回**None**.如果 **QuerySet**
没有设置排序,则将会自动按主键进行排序

例：

p **=** Article**.**objects**.**order\_by('title', 'pub_date')**.**first()

笔记:**first()** 是一个简便方法 下面这个例子和上面的代码效果是一样

**try**: p **=** Article**.**objects**.**order\_by('title',
'pub_date')[0]**except** **IndexError**: p **=** None

**aggregate（聚合查询）**

**aggregate(**\*args**,** \*\*kwargs**)**

返回一个字典，包含根据**QuerySet**
计算得到的聚合值（平均数、和等等）。**aggregate()**
的每个参数指定返回的字典中将要包含的值。

**\>\>\> from** **django.db.models** **import** Count **\>\>\>** q **=**
Blog**.**objects**.**aggregate(Count('entry')){'entry__count': 16}

通过使用关键字参数来指定聚合函数，你可以控制返回的聚合的值的名称：

**\>\>\>** q **=**
Blog**.**objects**.**aggregate(number_of_entries**=**Count('entry')){'number_of_entries':
16}

**exists**

**exists()**

如果[**QuerySet**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet)
包含任何结果，则返回**True**，否则返回**False**。

entry **=** Entry**.**objects**.**get(pk**=**123)**if**
some_queryset**.**filter(pk**=**entry**.**pk)**.**exists(): **print**("Entry
contained in queryset")

**update**

**update(**\*\*kwargs**)**

对指定的字段执行SQL更新查询，并返回匹配的行数（如果某些行已具有新值，则可能不等于已更新的行数）。

例如，要对2010年发布的所有博客条目启用评论，您可以执行以下操作：

**\>\>\>**
Entry**.**objects**.**filter(pub_date__year**=**2010)**.**update(comments_on**=**False)

**delete**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#delete)

**delete()**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet.delete)

对[**QuerySet**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet)中的所有行执行SQL删除查询。立即应用**delete()**。您不能在[**QuerySet**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet)上调用**delete()**，该查询已采取切片或以其他方式无法过滤。

要删除特定博客中的所有条目：

**\>\>\>** b **=** Blog**.**objects**.**get(pk**=**1)\# Delete all the entries
belonging to this Blog.**\>\>\>**
Entry**.**objects**.**filter(blog**=**b)**.**delete()

**字段查询**

查询的关键字参数的基本形式是**field__lookuptype=value**。字段查询是指如何指定SQL
**WHERE**子句的内容.
它们通过**查询集**的[**filter()**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet.filter),
[**exclude()**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet.exclude)
and
[**get()**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet.get)的关键字参数指定.

**exact**

精确匹配。如果为比较提供的值为**None**，它将被解释为SQL **NULL**

Entry**.**objects**.**get(id__exact**=**14)
Entry**.**objects**.**get(id__exact**=**None)

**iexact**

不区分大小写的精确匹配

Blog**.**objects**.**get(name_\_iexact**=**'beatles blog')
Blog**.**objects**.**get(name_\_iexact**=**None)

**contains**

区分大小写的包含例子。

Entry**.**objects**.**get(headline__contains**=**'Lennon')

**icontains**

不区分大小写的包含

Entry**.**objects**.**get(headline_\_icontains**=**'Lennon')

**in**

在给定的列表。

Entry**.**objects**.**filter(id__in**=**[1, 3, 4])

在一次查询的结果集合中进行查询

inner_qs **=**
Blog**.**objects**.**filter(name__contains**=**'Ch')**.**values('name') entries
**=** Entry**.**objects**.**filter(blog__name__in**=**inner_qs)

**gt**

大于

Entry**.**objects**.**filter(id_\_gt**=**4)

**gte**

大于或等于

**lt**

小于

**lte**

小于或等于

**startswith**

区分大小写，开始位置匹配

Entry**.**objects**.**filter(headline_\_startswith**=**'Will')

**istartswith**

不区分大小写，开始位置匹配

Entry**.**objects**.**filter(headline_\_istartswith**=**'will')

**endswith**

区分大小写。

**iendswith**

不区分大小写。

**range**

范围测试（包含于之中，在时间相关的查询中尤为重要，如果你要获取这一周的内容的话，肯定要用到这一周的内容）。

**import** **datetime** start_date **=** datetime**.**date(2005, 1, 1) end_date
**=** datetime**.**date(2005, 3, 31)
Entry**.**objects**.**filter(pub_date__range**=**(start_date, end_date))

部分日期的关键字参数

year month day weekday hour minute second

**isnull**

值为 **True** 或 **False**

Entry**.**objects**.**filter(pub_date_\_isnull**=**True)

正则表达式

**regex**

区分大小写的正则表达式匹配。

Entry**.**objects**.**get(title__regex**=**r'\^(An?\|The) +')

**iregex**

不区分大小写的正则表达式匹配。

Entry**.**objects**.**get(title_\_iregex**=**r'\^(an?\|the) +')

**聚合函数**

在**QuerySet** 为空时，聚合函数函数将返回**None**。 例如，如果**QuerySet**
中没有记录，**Sum** 聚合函数将返回**None** 而不是**0**。**Count**
是一个例外，如果**QuerySet** 为空，它将返回**0**。

聚合函数的参数有以下三个

**expression**

引用模型字段的一个字符串，或者一个[查询表达式](http://python.usyiyi.cn/documents/django_182/ref/models/expressions.html)。

**output_field**

用来表示返回值的[模型字段](http://python.usyiyi.cn/documents/django_182/ref/models/fields.html)，它是一个可选的参数。

**\*\*extra**

这些关键字参数可以给聚合函数生成的SQL 提供额外的信息。

具体的聚合函数：

**avg**

class **Avg(**expression**,** output_field=None**,**
\*\*extra**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.Avg)

返回给定expression 的平均值，其中expression 必须为数值。

-   默认的别名：**\<field\>__avg**

-   返回类型：**float**

**Count**

class **Count(**expression**,** distinct=False**,**
\*\*extra**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.Count)

返回与expression 相关的对象的个数。

-   默认的别名：**\<field\>__count**

-   返回类型：**int**

有一个可选的参数：

>   **distinct**

>   如果**distinct=True**，Count 将只计算唯一的实例。它等同于**COUNT(DISTINCT
>   \<field\>)** SQL 语句。默认值为**False**。

**Max**

class **Max(**expression**,** output_field=None**,**
\*\*extra**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.Max)

返回expression 的最大值。

-   默认的别名：**\<field\>__max**

-   返回类型：与输入字段的类型相同，如果提供则为 **output_field** 类型

**Min**

class **Min(**expression**,** output_field=None**,**
\*\*extra**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.Min)

返回expression 的最小值。

-   默认的别名：**\<field\>__min**

-   返回的类型：与输入字段的类型相同，如果提供则为 **output_field** 类型

**StdDev**

class **StdDev(**expression**,** sample=False**,**
\*\*extra**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.StdDev)

返回expression 的标准差。

-   默认的别名：**\<field\>_\_stddev**

-   返回类型：**float**

有一个可选的参数：

>   **sample**

>   默认情况下，**StdDev**
>   返回群体的标准差。但是，如果**sample=True**，返回的值将是样本的标准差。

**Sum**

class **Sum(**expression**,** output_field=None**,**
\*\*extra**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.Sum)

计算expression 的所有值的和。

-   默认的别名：**\<field\>__sum**

-   返回类型：与输入的字段相同，如果提供则为**output_field** 的类型

**Variance**

class **Variance(**expression**,** sample=False**,**
\*\*extra**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.Variance)

返回expression 的方差。

-   默认的别名：**\<field\>__variance**

-   返回的类型：**float**

有一个可选的参数：

>   **sample**

>   默认情况下，**Variance**
>   返回群体的方差。但是，如果**sample=True**，返回的值将是样本的方差。

**链式过滤**

查询集的筛选结果本身还是查询集，所以可以将筛选语句链接在一起。像这样：

**\>\>\>** Entry**.**objects**.**filter(**...** 
headline_\_startswith**=**'What'**...** )**.**exclude(**...** 
pub_date_\_gte**=**datetime**.**date**.**today()**...** )**.**filter(**...** 
pub_date_\_gte**=**datetime(2005, 1, 30)**...** )

**限制查询**

Entry**.**objects**.**all()[:5]

限制查询集记录的条数

**orderby**

Entry**.**objects**.**order\_by('headline')[0]

对查询集进行排序

Entry**.**objects**.**order\_by('blog__name')

通过关联字段进行排序

Entry**.**objects**.**order\_by(Coalesce('summary', 'headline')**.**desc())

通过Coalesce函数指定多个字段，通过desc()和asc()函数制定排序方向

**reverse()**

**reverse()** 方法反向排序QuerySet 中返回的元素。

**distinct([**\*fields**]）**

返回一个在SQL 查询中使用**SELECT DISTINCT**
的新**QuerySet**。它将去除查询结果中重复的行。

**values(**\*fields**)**

返回一个**ValuesQuerySet** —— **QuerySet**
的一个子类，迭代时返回**字典SET**而不是模型实例**对象SET**。

每个字典表示一个对象，键对应于模型对象的属性名称。

**values\_list(**\*fields**,**
flat=False**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet.values_list)

与**values()**
类似，只是在迭代时返回的是**元组SET**而不是**字典SET**。每个元组包含传递给**values_list()**
调用的字段的值 —— 所以第一个元素为第一个字段，以此类推。

**关联查询**

通过关联对象的字段进行查询。可以跨越任意深度。

获取所有**Blog** 的**name** 为**'Beatles Blog'** 的**Entry** 对象：

Entry**.**objects**.**filter(blog__name**=**'Beatles Blog')

对于关联关系也可以反向查询

获取所有的**Blog** 对象，它们至少有一个**Entry** 的**headline** 包含**'Lennon'**

Blog**.**objects**.**filter(entry__headline__contains**=**'Lennon')

**select_related**

**select_related(**\*fields**)**

返回一个**QuerySet**，当执行它的查询时它沿着外键关系查询关联的对象的数据。它会生成一个复杂的查询并引起性能的损耗，但是在以后使用外键关系时将不需要数据库查询。

下面的例子解释了普通查询和**select\_related()**
查询的区别。下面是一个标准的查询：

*\# Hits the database.* e **=** Entry**.**objects**.**get(id**=**5)*\# Hits the
database again to get the related Blog object.* b **=** e**.**blog

下面是一个**select_related** 查询：

*\# Hits the database.* e **=**
Entry**.**objects**.**select\_related('blog')**.**get(id**=**5)*\# Doesn't hit
the database, because e.blog has been prepopulated\# in the previous query.* b
**=** e**.**blog

**prefetch_related¶**

**prefetch_related(**\*lookups**)**[**¶**](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet.prefetch_related)

返回**QuerySet**，它将在单个批处理中自动检索每个指定查找的相关对象。

**\>\>\>** Pizza**.**objects**.**all()["Hawaiian (ham, pineapple)", "Seafood
(prawns, smoked salmon)"...

问题是每次**Pizza .\_\_ str
\__()**要求**self.toppings.all()**它必须查询数据库，因此**Pizza.objects
.all()**将在Pizza **QuerySet**中的**每个**项目的Toppings表上运行查询。

我们可以使用**prefetch_related**减少为只有两个查询：

**\>\>\>** Pizza**.**objects**.**all()**.**prefetch\_related('toppings')

**模糊查询**

Entry**.**objects**.**get(headline__exact**=**"Man bites dog")

**exact** “精确”匹配。

Blog**.**objects**.**get(name_\_iexact**=**"beatles blog")

**iexact**大小写不敏感的匹配

Entry**.**objects**.**get(headline__contains**=**'Lennon')

**contains**大小写敏感的包含关系

Entry**.**objects**.**get(headline_\_icontains**=**'Lennon')

**icontains**大小写不敏感的包含关系。

**--------------------------------------------------------------**

关键概念说明：

管理器：对应数据库中的表。每个模型都有一个objects管理器，用来调用查询方法。管理器只能通过模型的类进行访问，不能通过模型的实例进行访问。

查询集：对应数据库中的记录。查询集 是惰性执行的 ——
创建[查询集](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet)不会带来任何数据库的访问。你可以将过滤器保持一整天，直到[查询集](http://python.usyiyi.cn/documents/django_182/ref/models/querysets.html#django.db.models.query.QuerySet)
需要求值时，Django 才会真正运行这个查询。所以可以放心大胆的查询。

二者关系：

管理器是查询集的主要来源。
