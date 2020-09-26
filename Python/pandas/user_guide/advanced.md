# 多层级索引和高级索引

本章节包含了[使用多层级索引](#advanced-hierarchical) 以及 [其他高级索引特性](#indexing-index-types)。

请参阅 [索引与选择数据](indexing.html#indexing)来获得更多的通用索引方面的帮助文档

::: danger 警告

基于实际的使用场景不同，返回的内容也会不尽相同（返回一个数据的副本，或者返回数据的引用）。有时，这种情况被称作连锁赋值，但是这种情况应当被尽力避免。参见[返回视图or返回副本](indexing.html#indexing-view-versus-copy)。

::: 

参见 [cookbook](/document/cookbook/index.html)，获取更多高级的使用技巧。



## 分层索引（多层级索引）

分层/多级索引在处理复杂的数据分析和数据操作方面为开发者奠定了基础，尤其是在处理高纬度数据处理上。本质上，它使您能够在较低维度的数据结构(如 ``Series``(1d)和``DataFrame`` (2d))中存储和操作任意维数的数据。

在本节中，我们将展示“层次”索引的确切含义，以及它如何与上面和前面部分描述的所有panda索引功能集成。稍后，在讨论[分组](groupby.html#groupby) 和[数据透视与重塑性数据](reshaping.html#reshaping)时，我们将展示一些重要的应用程序，以说明它如何帮助构建分析数据的结构。

请参阅[cookbook](cookbook.html#cookbook-multi-index)，查看一些高级策略.

*在0.24.0版本中的改变:*``MultIndex.labels``被更名为[``MultiIndex.codes``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.codes.html#pandas.MultiIndex.codes)
，同时 ``MultiIndex.set_labels`` 更名为 [``MultiIndex.set_codes``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.set_codes.html#pandas.MultiIndex.set_codes).

### 创建多级索引和分层索引对象

 [``MultiIndex``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.html#pandas.MultiIndex) 对象是[``标准索引对象``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.html#pandas.Index) 的分层模拟，标准索引对象通常将axis标签存储在panda对象中。您可以将``MultiIndex``看作一个元组数组，其中每个元组都是惟一的。可以从数组列表(使用
[``MultiIndex.from_arrays()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.from_arrays.html#pandas.MultiIndex.from_arrays))、元组数组(使用[``MultiIndex.from_tuples()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.from_tuples.html#pandas.MultiIndex.from_tuples))或交叉迭代器集(使用[``MultiIndex.from_product()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.from_product.html#pandas.MultiIndex.from_product))或者将一个 [``DataFrame``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html#pandas.DataFrame)(使用using
[``MultiIndex.from_frame()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.from_frame.html#pandas.MultiIndex.from_frame))创建多索引。当传递一个元组列表时，``索引``构造函数将尝试返回一个``MultiIndex``。下面的示例演示了初始化多索引的不同方法。

``` python
In [1]: arrays = [['bar', 'bar', 'baz', 'baz', 'foo', 'foo', 'qux', 'qux'],
   ...:           ['one', 'two', 'one', 'two', 'one', 'two', 'one', 'two']]
   ...: 

In [2]: tuples = list(zip(*arrays))

In [3]: tuples
Out[3]: 
[('bar', 'one'),
 ('bar', 'two'),
 ('baz', 'one'),
 ('baz', 'two'),
 ('foo', 'one'),
 ('foo', 'two'),
 ('qux', 'one'),
 ('qux', 'two')]

In [4]: index = pd.MultiIndex.from_tuples(tuples, names=['first', 'second'])

In [5]: index
Out[5]: 
MultiIndex([('bar', 'one'),
            ('bar', 'two'),
            ('baz', 'one'),
            ('baz', 'two'),
            ('foo', 'one'),
            ('foo', 'two'),
            ('qux', 'one'),
            ('qux', 'two')],
           names=['first', 'second'])

In [6]: s = pd.Series(np.random.randn(8), index=index)

In [7]: s
Out[7]: 
first  second
bar    one       0.469112
       two      -0.282863
baz    one      -1.509059
       two      -1.135632
foo    one       1.212112
       two      -0.173215
qux    one       0.119209
       two      -1.044236
dtype: float64
```

当您想要在两个迭代器中对每个元素进行配对时，可以更容易地使用 [``MultiIndex.from_product()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.from_product.html#pandas.MultiIndex.from_product)方法:

``` python
In [8]: iterables = [['bar', 'baz', 'foo', 'qux'], ['one', 'two']]

In [9]: pd.MultiIndex.from_product(iterables, names=['first', 'second'])
Out[9]: 
MultiIndex([('bar', 'one'),
            ('bar', 'two'),
            ('baz', 'one'),
            ('baz', 'two'),
            ('foo', 'one'),
            ('foo', 'two'),
            ('qux', 'one'),
            ('qux', 'two')],
           names=['first', 'second'])
```

还可以使用 [``MultiIndex.from_frame()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.from_frame.html#pandas.MultiIndex.from_frame)方法直接将一个``DataFrame``对象构造一个``多索引``。这是[``MultiIndex.to_frame()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.to_frame.html#pandas.MultiIndex.to_frame)的一个补充方法。

*0.24.0版本新增。*

``` python
In [10]: df = pd.DataFrame([['bar', 'one'], ['bar', 'two'],
   ....:                    ['foo', 'one'], ['foo', 'two']],
   ....:                   columns=['first', 'second'])
   ....: 

In [11]: pd.MultiIndex.from_frame(df)
Out[11]: 
MultiIndex([('bar', 'one'),
            ('bar', 'two'),
            ('foo', 'one'),
            ('foo', 'two')],
           names=['first', 'second'])
```

为了方便，您可以将数组列表直接传递到`Series`或`DataFrame`中，从而自动构造一个`MultiIndex`:

``` python
In [12]: arrays = [np.array(['bar', 'bar', 'baz', 'baz', 'foo', 'foo', 'qux', 'qux']),
   ....:           np.array(['one', 'two', 'one', 'two', 'one', 'two', 'one', 'two'])]
   ....: 

In [13]: s = pd.Series(np.random.randn(8), index=arrays)

In [14]: s
Out[14]: 
bar  one   -0.861849
     two   -2.104569
baz  one   -0.494929
     two    1.071804
foo  one    0.721555
     two   -0.706771
qux  one   -1.039575
     two    0.271860
dtype: float64

In [15]: df = pd.DataFrame(np.random.randn(8, 4), index=arrays)

In [16]: df
Out[16]: 
                0         1         2         3
bar one -0.424972  0.567020  0.276232 -1.087401
    two -0.673690  0.113648 -1.478427  0.524988
baz one  0.404705  0.577046 -1.715002 -1.039268
    two -0.370647 -1.157892 -1.344312  0.844885
foo one  1.075770 -0.109050  1.643563 -1.469388
    two  0.357021 -0.674600 -1.776904 -0.968914
qux one -1.294524  0.413738  0.276662 -0.472035
    two -0.013960 -0.362543 -0.006154 -0.923061
```

所`MultiIndex`构造函数都接受`names`参数，该参数存储级别本身的字符串名称。如果没有提供`name`属性，将分配`None`:

``` python
In [17]: df.index.names
Out[17]: FrozenList([None, None])
```

此索引可以支持panda对象的任何轴，索引的**级别**由开发者决定:

``` python
In [18]: df = pd.DataFrame(np.random.randn(3, 8), index=['A', 'B', 'C'], columns=index)

In [19]: df
Out[19]: 
first        bar                 baz                 foo                 qux          
second       one       two       one       two       one       two       one       two
A       0.895717  0.805244 -1.206412  2.565646  1.431256  1.340309 -1.170299 -0.226169
B       0.410835  0.813850  0.132003 -0.827317 -0.076467 -1.187678  1.130127 -1.436737
C      -1.413681  1.607920  1.024180  0.569605  0.875906 -2.211372  0.974466 -2.006747

In [20]: pd.DataFrame(np.random.randn(6, 6), index=index[:6], columns=index[:6])
Out[20]: 
first              bar                 baz                 foo          
second             one       two       one       two       one       two
first second                                                            
bar   one    -0.410001 -0.078638  0.545952 -1.219217 -1.226825  0.769804
      two    -1.281247 -0.727707 -0.121306 -0.097883  0.695775  0.341734
baz   one     0.959726 -1.110336 -0.619976  0.149748 -0.732339  0.687738
      two     0.176444  0.403310 -0.154951  0.301624 -2.179861 -1.369849
foo   one    -0.954208  1.462696 -1.743161 -0.826591 -0.345352  1.314232
      two     0.690579  0.995761  2.396780  0.014871  3.357427 -0.317441
```

我们已经“稀疏化”了更高级别的索引，使控制台的输出更容易显示。注意，可以使用`pandas.set_options()`中的`multi_sparse`选项控制索引的显示方式:

``` python
In [21]: with pd.option_context('display.multi_sparse', False):
   ....:     df
   ....:
```

值得记住的是，没有什么可以阻止您使用元组作为轴上的原子标签:

``` python
In [22]: pd.Series(np.random.randn(8), index=tuples)
Out[22]: 
(bar, one)   -1.236269
(bar, two)    0.896171
(baz, one)   -0.487602
(baz, two)   -0.082240
(foo, one)   -2.182937
(foo, two)    0.380396
(qux, one)    0.084844
(qux, two)    0.432390
dtype: float64
```

`MultiIndex`之所以重要，是因为它允许您进行分组、选择和重新构造操作，我们将在下面的文档和后续部分中进行描述。正如您将在后面的部分中看到的，您可以发现自己使用分层索引的数据，而不需要显式地创建一个`MultiIndex`。然而，当从文件中加载数据时，您可能希望在准备数据集时生成自己的`MultiIndex`。

### 重构层次标签

[``get_level_values()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.get_level_values.html#pandas.MultiIndex.get_level_values)方法将返回特定级别每个位置的标签向量:

``` python
In [23]: index.get_level_values(0)
Out[23]: Index(['bar', 'bar', 'baz', 'baz', 'foo', 'foo', 'qux', 'qux'], dtype='object', name='first')

In [24]: index.get_level_values('second')
Out[24]: Index(['one', 'two', 'one', 'two', 'one', 'two', 'one', 'two'], dtype='object', name='second')
```

### 基本索引轴上的多索引

层次索引的一个重要特性是，您可以通过`partial`标签来选择数据，该标签标识数据中的子组。**局部** 选择“降低”层次索引的级别，其结果完全类似于在常规数据Dataframe中选择列:

``` python
In [25]: df['bar']
Out[25]: 
second       one       two
A       0.895717  0.805244
B       0.410835  0.813850
C      -1.413681  1.607920

In [26]: df['bar', 'one']
Out[26]: 
A    0.895717
B    0.410835
C   -1.413681
Name: (bar, one), dtype: float64

In [27]: df['bar']['one']
Out[27]: 
A    0.895717
B    0.410835
C   -1.413681
Name: one, dtype: float64

In [28]: s['qux']
Out[28]: 
one   -1.039575
two    0.271860
dtype: float64
```

有关如何在更深层次上进行选择，请参见[具有层次索引的横切](#advanced-xs)。

### 定义不同层次索引

 [``MultiIndex``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.html#pandas.MultiIndex) 保存了所有被定义的索引层级，即使它们实际上没有被使用。在切割索引时，您可能会注意到这一点。例如:

``` python
In [29]: df.columns.levels  # original MultiIndex
Out[29]: FrozenList([['bar', 'baz', 'foo', 'qux'], ['one', 'two']])

In [30]: df[['foo','qux']].columns.levels  # sliced
Out[30]: FrozenList([['bar', 'baz', 'foo', 'qux'], ['one', 'two']])
```

这样做是为了避免重新计算级别，从而使切片具有很高的性能。如果只想查看使用的级别，可以使用[``remove_unused_levels()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.remove_unused_levels.html#pandas.MultiIndex.remove_unused_levels)方法。


``` python
In [31]: df[['foo', 'qux']].columns.to_numpy()
Out[31]: 
array([('foo', 'one'), ('foo', 'two'), ('qux', 'one'), ('qux', 'two')],
      dtype=object)

# for a specific level
In [32]: df[['foo', 'qux']].columns.get_level_values(0)
Out[32]: Index(['foo', 'foo', 'qux', 'qux'], dtype='object', name='first')
```

若要仅使用已使用的级别来重构`MultiIndex `，可以使用[``remove_unused_levels()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.remove_unused_levels.html#pandas.MultiIndex.remove_unused_levels)方法。

*0.20.0.中更新*。

``` python
In [33]: new_mi = df[['foo', 'qux']].columns.remove_unused_levels()

In [34]: new_mi.levels
Out[34]: FrozenList([['foo', 'qux'], ['one', 'two']])
```

### 数据对齐和使用 ``reindex``

在轴上具有`MultiIndex`的不同索引对象之间的操作将如您所期望的那样工作;数据对齐的工作原理与元组索引相同:

``` python
In [35]: s + s[:-2]
Out[35]: 
bar  one   -1.723698
     two   -4.209138
baz  one   -0.989859
     two    2.143608
foo  one    1.443110
     two   -1.413542
qux  one         NaN
     two         NaN
dtype: float64

In [36]: s + s[::2]
Out[36]: 
bar  one   -1.723698
     two         NaN
baz  one   -0.989859
     two         NaN
foo  one    1.443110
     two         NaN
qux  one   -2.079150
     two         NaN
dtype: float64
```

``Series/DataFrames``对象的 [``reindex()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.reindex.html#pandas.DataFrame.reindex)  方法可以调用另一个``MultiIndex`` ，甚至一个列表或数组元组:

``` python
In [37]: s.reindex(index[:3])
Out[37]: 
first  second
bar    one      -0.861849
       two      -2.104569
baz    one      -0.494929
dtype: float64

In [38]: s.reindex([('foo', 'two'), ('bar', 'one'), ('qux', 'one'), ('baz', 'one')])
Out[38]: 
foo  two   -0.706771
bar  one   -0.861849
qux  one   -1.039575
baz  one   -0.494929
dtype: float64
```



## 具有层次索引的高级索引方法

语法上，使用``.loc``方法，在高级索引中加入 ``MultiIndex``（多层索引）是有一些挑战的，但是我们一直在尽己所能地去实现这个功能。简单来说，多层索引的索引键（keys）来自元组的格式。例如，下列代码将会按照你的期望工作：

``` python
In [39]: df = df.T

In [40]: df
Out[40]: 
                     A         B         C
first second                              
bar   one     0.895717  0.410835 -1.413681
      two     0.805244  0.813850  1.607920
baz   one    -1.206412  0.132003  1.024180
      two     2.565646 -0.827317  0.569605
foo   one     1.431256 -0.076467  0.875906
      two     1.340309 -1.187678 -2.211372
qux   one    -1.170299  1.130127  0.974466
      two    -0.226169 -1.436737 -2.006747

In [41]: df.loc[('bar', 'two')]
Out[41]: 
A    0.805244
B    0.813850
C    1.607920
Name: (bar, two), dtype: float64
```

注意 ``df.loc['bar', 'two']``也将会在这个用例中正常工作，但是这种便捷的简写方法总的来说是容易产生歧义的。

如果你也希望使用 ``.loc``对某个特定的列进行索引，你需要使用如下的元组样式：

``` python
In [42]: df.loc[('bar', 'two'), 'A']
Out[42]: 0.8052440253863785
```

你可以只输入元组的第一个元素，而不需要写出所有的多级索引的每一个层级。例如，你可以使用“局部”索引，来获得所有在第一层为``bar``的元素，参见下例：
```python
df.loc[‘bar’]
```
这种方式是对于更为冗长的方式``df.loc[('bar',),]``的一个简写（在本例中，等同于``df.loc['bar',]``）

您也可以类似地使用“局部”切片。

``` python
In [43]: df.loc['baz':'foo']
Out[43]: 
                     A         B         C
first second                              
baz   one    -1.206412  0.132003  1.024180
      two     2.565646 -0.827317  0.569605
foo   one     1.431256 -0.076467  0.875906
      two     1.340309 -1.187678 -2.211372
```

您可以通过使用一个元组的切片，提供一个值的范围(a ‘range’ of values),来进行切片

``` python
In [44]: df.loc[('baz', 'two'):('qux', 'one')]
Out[44]: 
                     A         B         C
first second                              
baz   two     2.565646 -0.827317  0.569605
foo   one     1.431256 -0.076467  0.875906
      two     1.340309 -1.187678 -2.211372
qux   one    -1.170299  1.130127  0.974466

In [45]: df.loc[('baz', 'two'):'foo']
Out[45]: 
                     A         B         C
first second                              
baz   two     2.565646 -0.827317  0.569605
foo   one     1.431256 -0.076467  0.875906
      two     1.340309 -1.187678 -2.211372
```

类似于重命名索引（reindexing），您可以通过输入一个标签的元组来实现：

``` python
In [46]: df.loc[[('bar', 'two'), ('qux', 'one')]]
Out[46]: 
                     A         B         C
first second                              
bar   two     0.805244  0.813850  1.607920
qux   one    -1.170299  1.130127  0.974466
```

::: tip 小技巧

在pandas中，元组和列表，在索引时，是有区别的。一个元组会被识别为一个多层级的索引值（key），而列表被用于表明多个不同的索引值（several keys）。换句话说，元组是按照横向展开的，即水平层级（trasvering levels），而列表是纵向的，即扫描层级（scanning levels）。

:::

注意，一个元组构成的列表提供的是完整的多级索引，而一个列表构成的元组提供的是同一个级别中的多个值：

``` python
In [47]: s = pd.Series([1, 2, 3, 4, 5, 6],
   ....:               index=pd.MultiIndex.from_product([["A", "B"], ["c", "d", "e"]]))
   ....: 

In [48]: s.loc[[("A", "c"), ("B", "d")]]  # list of tuples
Out[48]: 
A  c    1
B  d    5
dtype: int64

In [49]: s.loc[(["A", "B"], ["c", "d"])]  # tuple of lists
Out[49]: 
A  c    1
   d    2
B  c    4
   d    5
dtype: int64
```

### 使用切片器


你可以使用多级索引器来切片一个``多级索引

你可以提供任意的选择器，就仿佛你按照标签索引一样，参见[按照标签索引](indexing.html#indexing-label), 包含切片，标签构成的列表，标签，和布尔值索引器。

你可以使用``slice(None)``来选择所有的该级别的内容。你不需要指明所有的*深层级别*，他们将按照``slice(None)``的方式来做默认推测。

一如既往，切片器的**两侧**都会被包含进来，因为这是按照标签索引的方式进行的。

::: danger 警告
你需要在``.loc``中声明所有的维度，这意味着同时包含**行索引**以及**列索引**。在一些情况下，索引器中的数据有可能会被错误地识别为在两个维度*同时*进行索引，而不是只对行进行多层级索引。

建议使用下列的方式：

``` python
df.loc[(slice('A1', 'A3'), ...), :]             # noqa: E999
```

**不建议**使用下列的方式：

``` python
df.loc[(slice('A1', 'A3'), ...)]                # noqa: E999
```

:::

``` python
In [50]: def mklbl(prefix, n):
   ....:     return ["%s%s" % (prefix, i) for i in range(n)]
   ....: 

In [51]: miindex = pd.MultiIndex.from_product([mklbl('A', 4),
   ....:                                       mklbl('B', 2),
   ....:                                       mklbl('C', 4),
   ....:                                       mklbl('D', 2)])
   ....: 

In [52]: micolumns = pd.MultiIndex.from_tuples([('a', 'foo'), ('a', 'bar'),
   ....:                                        ('b', 'foo'), ('b', 'bah')],
   ....:                                       names=['lvl0', 'lvl1'])
   ....: 

In [53]: dfmi = pd.DataFrame(np.arange(len(miindex) * len(micolumns))
   ....:                       .reshape((len(miindex), len(micolumns))),
   ....:                     index=miindex,
   ....:                     columns=micolumns).sort_index().sort_index(axis=1)
   ....: 

In [54]: dfmi
Out[54]: 
lvl0           a         b     
lvl1         bar  foo  bah  foo
A0 B0 C0 D0    1    0    3    2
         D1    5    4    7    6
      C1 D0    9    8   11   10
         D1   13   12   15   14
      C2 D0   17   16   19   18
...          ...  ...  ...  ...
A3 B1 C1 D1  237  236  239  238
      C2 D0  241  240  243  242
         D1  245  244  247  246
      C3 D0  249  248  251  250
         D1  253  252  255  254

[64 rows x 4 columns]
```

使用切片，列表和标签来进行简单的多层级切片

``` python
In [55]: dfmi.loc[(slice('A1', 'A3'), slice(None), ['C1', 'C3']), :]
Out[55]: 
lvl0           a         b     
lvl1         bar  foo  bah  foo
A1 B0 C1 D0   73   72   75   74
         D1   77   76   79   78
      C3 D0   89   88   91   90
         D1   93   92   95   94
   B1 C1 D0  105  104  107  106
...          ...  ...  ...  ...
A3 B0 C3 D1  221  220  223  222
   B1 C1 D0  233  232  235  234
         D1  237  236  239  238
      C3 D0  249  248  251  250
         D1  253  252  255  254

[24 rows x 4 columns]
```

你可以使用 [``pandas.IndexSlice``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.IndexSlice.html#pandas.IndexSlice)，即使用``:``，一个更为符合习惯的语法，而不是使用slice(None)。

``` python
In [56]: idx = pd.IndexSlice

In [57]: dfmi.loc[idx[:, :, ['C1', 'C3']], idx[:, 'foo']]
Out[57]: 
lvl0           a    b
lvl1         foo  foo
A0 B0 C1 D0    8   10
         D1   12   14
      C3 D0   24   26
         D1   28   30
   B1 C1 D0   40   42
...          ...  ...
A3 B0 C3 D1  220  222
   B1 C1 D0  232  234
         D1  236  238
      C3 D0  248  250
         D1  252  254

[32 rows x 2 columns]
```

您可以使用这种方法在两个维度上同时实现非常复杂的选择。

``` python
In [58]: dfmi.loc['A1', (slice(None), 'foo')]
Out[58]: 
lvl0        a    b
lvl1      foo  foo
B0 C0 D0   64   66
      D1   68   70
   C1 D0   72   74
      D1   76   78
   C2 D0   80   82
...       ...  ...
B1 C1 D1  108  110
   C2 D0  112  114
      D1  116  118
   C3 D0  120  122
      D1  124  126

[16 rows x 2 columns]

In [59]: dfmi.loc[idx[:, :, ['C1', 'C3']], idx[:, 'foo']]
Out[59]: 
lvl0           a    b
lvl1         foo  foo
A0 B0 C1 D0    8   10
         D1   12   14
      C3 D0   24   26
         D1   28   30
   B1 C1 D0   40   42
...          ...  ...
A3 B0 C3 D1  220  222
   B1 C1 D0  232  234
         D1  236  238
      C3 D0  248  250
         D1  252  254

[32 rows x 2 columns]
```

使用布尔索引器，您可以对*数值*进行选择。

``` python
In [60]: mask = dfmi[('a', 'foo')] > 200

In [61]: dfmi.loc[idx[mask, :, ['C1', 'C3']], idx[:, 'foo']]
Out[61]: 
lvl0           a    b
lvl1         foo  foo
A3 B0 C1 D1  204  206
      C3 D0  216  218
         D1  220  222
   B1 C1 D0  232  234
         D1  236  238
      C3 D0  248  250
         D1  252  254
```

您也可以使用``.loc``来明确您所希望的``维度``(``axis``)，从而只在一个维度上来进行切片。

``` python
In [62]: dfmi.loc(axis=0)[:, :, ['C1', 'C3']]
Out[62]: 
lvl0           a         b     
lvl1         bar  foo  bah  foo
A0 B0 C1 D0    9    8   11   10
         D1   13   12   15   14
      C3 D0   25   24   27   26
         D1   29   28   31   30
   B1 C1 D0   41   40   43   42
...          ...  ...  ...  ...
A3 B0 C3 D1  221  220  223  222
   B1 C1 D0  233  232  235  234
         D1  237  236  239  238
      C3 D0  249  248  251  250
         D1  253  252  255  254

[32 rows x 4 columns]
```

进一步，您可以使用下列的方式来*赋值*
``` python
In [63]: df2 = dfmi.copy()

In [64]: df2.loc(axis=0)[:, :, ['C1', 'C3']] = -10

In [65]: df2
Out[65]: 
lvl0           a         b     
lvl1         bar  foo  bah  foo
A0 B0 C0 D0    1    0    3    2
         D1    5    4    7    6
      C1 D0  -10  -10  -10  -10
         D1  -10  -10  -10  -10
      C2 D0   17   16   19   18
...          ...  ...  ...  ...
A3 B1 C1 D1  -10  -10  -10  -10
      C2 D0  241  240  243  242
         D1  245  244  247  246
      C3 D0  -10  -10  -10  -10
         D1  -10  -10  -10  -10

[64 rows x 4 columns]
```

您也可以在等号的右侧使用一个可以被“重命名”的对象来赋值
``` python
In [66]: df2 = dfmi.copy()

In [67]: df2.loc[idx[:, :, ['C1', 'C3']], :] = df2 * 1000

In [68]: df2
Out[68]: 
lvl0              a               b        
lvl1            bar     foo     bah     foo
A0 B0 C0 D0       1       0       3       2
         D1       5       4       7       6
      C1 D0    9000    8000   11000   10000
         D1   13000   12000   15000   14000
      C2 D0      17      16      19      18
...             ...     ...     ...     ...
A3 B1 C1 D1  237000  236000  239000  238000
      C2 D0     241     240     243     242
         D1     245     244     247     246
      C3 D0  249000  248000  251000  250000
         D1  253000  252000  255000  254000

[64 rows x 4 columns]
```

### 交叉选择

``DataFrame`` 的 [``xs()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.xs.html#pandas.DataFrame.xs)方法接受一个额外的参数，从而可以简便地在某个特定的``多级索引``中的某一个层级进行数据的选取。

``` python
In [69]: df
Out[69]: 
                     A         B         C
first second                              
bar   one     0.895717  0.410835 -1.413681
      two     0.805244  0.813850  1.607920
baz   one    -1.206412  0.132003  1.024180
      two     2.565646 -0.827317  0.569605
foo   one     1.431256 -0.076467  0.875906
      two     1.340309 -1.187678 -2.211372
qux   one    -1.170299  1.130127  0.974466
      two    -0.226169 -1.436737 -2.006747

In [70]: df.xs('one', level='second')
Out[70]: 
              A         B         C
first                              
bar    0.895717  0.410835 -1.413681
baz   -1.206412  0.132003  1.024180
foo    1.431256 -0.076467  0.875906
qux   -1.170299  1.130127  0.974466
```

``` python
# using the slicers
In [71]: df.loc[(slice(None), 'one'), :]
Out[71]: 
                     A         B         C
first second                              
bar   one     0.895717  0.410835 -1.413681
baz   one    -1.206412  0.132003  1.024180
foo   one     1.431256 -0.076467  0.875906
qux   one    -1.170299  1.130127  0.974466
```

您也可以用``xs()``并填写坐标参数来选择列。

``` python
In [72]: df = df.T

In [73]: df.xs('one', level='second', axis=1)
Out[73]: 
first       bar       baz       foo       qux
A      0.895717 -1.206412  1.431256 -1.170299
B      0.410835  0.132003 -0.076467  1.130127
C     -1.413681  1.024180  0.875906  0.974466
```

``` python
# using the slicers
In [74]: df.loc[:, (slice(None), 'one')]
Out[74]: 
first        bar       baz       foo       qux
second       one       one       one       one
A       0.895717 -1.206412  1.431256 -1.170299
B       0.410835  0.132003 -0.076467  1.130127
C      -1.413681  1.024180  0.875906  0.974466
```

``xs``也接受多个键（keys）来进行选取

``` python
In [75]: df.xs(('one', 'bar'), level=('second', 'first'), axis=1)
Out[75]: 
first        bar
second       one
A       0.895717
B       0.410835
C      -1.413681
```

``` python
# using the slicers
In [76]: df.loc[:, ('bar', 'one')]
Out[76]: 
A    0.895717
B    0.410835
C   -1.413681
Name: (bar, one), dtype: float64
```

您可以向``xs``传入 ``drop_level=False`` 来保留那些已经选取的层级。

``` python
In [77]: df.xs('one', level='second', axis=1, drop_level=False)
Out[77]: 
first        bar       baz       foo       qux
second       one       one       one       one
A       0.895717 -1.206412  1.431256 -1.170299
B       0.410835  0.132003 -0.076467  1.130127
C      -1.413681  1.024180  0.875906  0.974466
```

请比较上面，使用 ``drop_level=True``(默认值)的结果。

``` python
In [78]: df.xs('one', level='second', axis=1, drop_level=True)
Out[78]: 
first       bar       baz       foo       qux
A      0.895717 -1.206412  1.431256 -1.170299
B      0.410835  0.132003 -0.076467  1.130127
C     -1.413681  1.024180  0.875906  0.974466
```

### 高级重命名索引及对齐

``level``参数已经被加入到pandas对象中的 [``reindex()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.reindex.html#pandas.DataFrame.reindex)  和 [``align()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.align.html#pandas.DataFrame.align) 方法中。这将有助于沿着一个层级来广播值（broadcast values）。例如：

``` python
In [79]: midx = pd.MultiIndex(levels=[['zero', 'one'], ['x', 'y']],
   ....:                      codes=[[1, 1, 0, 0], [1, 0, 1, 0]])
   ....: 

In [80]: df = pd.DataFrame(np.random.randn(4, 2), index=midx)

In [81]: df
Out[81]: 
               0         1
one  y  1.519970 -0.493662
     x  0.600178  0.274230
zero y  0.132885 -0.023688
     x  2.410179  1.450520

In [82]: df2 = df.mean(level=0)

In [83]: df2
Out[83]: 
             0         1
one   1.060074 -0.109716
zero  1.271532  0.713416

In [84]: df2.reindex(df.index, level=0)
Out[84]: 
               0         1
one  y  1.060074 -0.109716
     x  1.060074 -0.109716
zero y  1.271532  0.713416
     x  1.271532  0.713416

# aligning
In [85]: df_aligned, df2_aligned = df.align(df2, level=0)

In [86]: df_aligned
Out[86]: 
               0         1
one  y  1.519970 -0.493662
     x  0.600178  0.274230
zero y  0.132885 -0.023688
     x  2.410179  1.450520

In [87]: df2_aligned
Out[87]: 
               0         1
one  y  1.060074 -0.109716
     x  1.060074 -0.109716
zero y  1.271532  0.713416
     x  1.271532  0.713416
```

### 使用``swaplevel``来交换层级

[``swaplevel()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.swaplevel.html#pandas.MultiIndex.swaplevel)函数可以用来交换两个层级

``` python
In [88]: df[:5]
Out[88]: 
               0         1
one  y  1.519970 -0.493662
     x  0.600178  0.274230
zero y  0.132885 -0.023688
     x  2.410179  1.450520

In [89]: df[:5].swaplevel(0, 1, axis=0)
Out[89]: 
               0         1
y one   1.519970 -0.493662
x one   0.600178  0.274230
y zero  0.132885 -0.023688
x zero  2.410179  1.450520
```

### 使用``reorder_levels``来进行层级重排序

[``reorder_levels()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.reorder_levels.html#pandas.MultiIndex.reorder_levels)是一个更一般化的 ``swaplevel``方法，允许您用简单的一步来重排列索引的层级：

``` python
In [90]: df[:5].reorder_levels([1, 0], axis=0)
Out[90]: 
               0         1
y one   1.519970 -0.493662
x one   0.600178  0.274230
y zero  0.132885 -0.023688
x zero  2.410179  1.450520
```

### 对``索引``和``多层索``引进行重命名

  [``rename()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.rename.html#pandas.DataFrame.rename)方法可以用来重命名``多层索引``，并且他经常被用于``DataFrame``的列名重命名。``renames``的``columns``参数可以接受一个字典，从而仅仅重命名你希望更改名字的列。

``` python
In [91]: df.rename(columns={0: "col0", 1: "col1"})
Out[91]: 
            col0      col1
one  y  1.519970 -0.493662
     x  0.600178  0.274230
zero y  0.132885 -0.023688
     x  2.410179  1.450520
```

该方法也可以被用于重命名一些``DataFrame``的特定主索引的名称。

``` python
In [92]: df.rename(index={"one": "two", "y": "z"})
Out[92]: 
               0         1
two  z  1.519970 -0.493662
     x  0.600178  0.274230
zero z  0.132885 -0.023688
     x  2.410179  1.450520
```

[``rename_axis()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.rename_axis.html#pandas.DataFrame.rename_axis) 方法可以用于对``Index`` 或者 ``MultiIndex``进行重命名。尤其的，你可以明确``MultiIndex``中的不同层级的名称，这可以被用于在之后使用 ``reset_index()`` ，把``多层级索引``的值转换为一个列

``` python
In [93]: df.rename_axis(index=['abc', 'def'])
Out[93]: 
                 0         1
abc  def                    
one  y    1.519970 -0.493662
     x    0.600178  0.274230
zero y    0.132885 -0.023688
     x    2.410179  1.450520
```

注意，``DataFrame``的列也是一个索引，因此在``rename_axis``中使用  ``columns`` 参数，将会改变那个索引的名称

``` python
In [94]: df.rename_axis(columns="Cols").columns
Out[94]: RangeIndex(start=0, stop=2, step=1, name='Cols')
```

``rename`` 和``rename_axis``都支持一个明确的字典，``Series`` 或者一个映射函数，将标签，名称映射为新的值

## 对``多索引``进行排序

对于拥有多层级索引的对象来说，你可以通过排序来是的索引或切片更为高效。就如同其他任何的索引操作一样，你可以使用 ``sort_index``方法来实现。

``` python
In [95]: import random

In [96]: random.shuffle(tuples)

In [97]: s = pd.Series(np.random.randn(8), index=pd.MultiIndex.from_tuples(tuples))

In [98]: s
Out[98]: 
baz  one    0.206053
foo  two   -0.251905
qux  one   -2.213588
foo  one    1.063327
bar  two    1.266143
baz  two    0.299368
bar  one   -0.863838
qux  two    0.408204
dtype: float64

In [99]: s.sort_index()
Out[99]: 
bar  one   -0.863838
     two    1.266143
baz  one    0.206053
     two    0.299368
foo  one    1.063327
     two   -0.251905
qux  one   -2.213588
     two    0.408204
dtype: float64

In [100]: s.sort_index(level=0)
Out[100]: 
bar  one   -0.863838
     two    1.266143
baz  one    0.206053
     two    0.299368
foo  one    1.063327
     two   -0.251905
qux  one   -2.213588
     two    0.408204
dtype: float64

In [101]: s.sort_index(level=1)
Out[101]: 
bar  one   -0.863838
baz  one    0.206053
foo  one    1.063327
qux  one   -2.213588
bar  two    1.266143
baz  two    0.299368
foo  two   -0.251905
qux  two    0.408204
dtype: float64
```

如果你的``多层级索引``都被命名了的话，你也可以向 ``sort_index`` 传入一个层级名称。

``` python
In [102]: s.index.set_names(['L1', 'L2'], inplace=True)

In [103]: s.sort_index(level='L1')
Out[103]: 
L1   L2 
bar  one   -0.863838
     two    1.266143
baz  one    0.206053
     two    0.299368
foo  one    1.063327
     two   -0.251905
qux  one   -2.213588
     two    0.408204
dtype: float64

In [104]: s.sort_index(level='L2')
Out[104]: 
L1   L2 
bar  one   -0.863838
baz  one    0.206053
foo  one    1.063327
qux  one   -2.213588
bar  two    1.266143
baz  two    0.299368
foo  two   -0.251905
qux  two    0.408204
dtype: float64
```

对于多维度的对象来说，你也可以对任意的的维度来进行索引，只要他们是具有``多层级索引``的：

``` python
In [105]: df.T.sort_index(level=1, axis=1)
Out[105]: 
        one      zero       one      zero
          x         x         y         y
0  0.600178  2.410179  1.519970  0.132885
1  0.274230  1.450520 -0.493662 -0.023688
```

即便数据没有排序，你仍然可以对他们进行索引，但是索引的效率会极大降低，并且也会抛出``PerformanceWarning``警告。而且，这将返回一个数据的副本而非一个数据的视图：

``` python
In [106]: dfm = pd.DataFrame({'jim': [0, 0, 1, 1],
   .....:                     'joe': ['x', 'x', 'z', 'y'],
   .....:                     'jolie': np.random.rand(4)})
   .....: 

In [107]: dfm = dfm.set_index(['jim', 'joe'])

In [108]: dfm
Out[108]: 
            jolie
jim joe          
0   x    0.490671
    x    0.120248
1   z    0.537020
    y    0.110968
```

``` python
In [4]: dfm.loc[(1, 'z')]
PerformanceWarning: indexing past lexsort depth may impact performance.

Out[4]:
           jolie
jim joe
1   z    0.64094
```

另外，如果你试图索引一个没有完全lexsorted的对象，你将会碰到如下的错误：

``` python
In [5]: dfm.loc[(0, 'y'):(1, 'z')]
UnsortedIndexError: 'Key length (2) was greater than MultiIndex lexsort depth (1)'
```

在``MultiIndex``上使用 [``is_lexsorted()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.is_lexsorted.html#pandas.MultiIndex.is_lexsorted) 方法，你可以查看这个索引是否已经被排序。而使用``lexsort_depth`` 属性则可以返回排序的深度

``` python
In [109]: dfm.index.is_lexsorted()
Out[109]: False

In [110]: dfm.index.lexsort_depth
Out[110]: 1
```

``` python
In [111]: dfm = dfm.sort_index()

In [112]: dfm
Out[112]: 
            jolie
jim joe          
0   x    0.490671
    x    0.120248
1   y    0.110968
    z    0.537020

In [113]: dfm.index.is_lexsorted()
Out[113]: True

In [114]: dfm.index.lexsort_depth
Out[114]: 2
```

现在，你的选择就可以正常工作了。

``` python
In [115]: dfm.loc[(0, 'y'):(1, 'z')]
Out[115]: 
            jolie
jim joe          
1   y    0.110968
    z    0.537020
```

## Take方法

与``NumPy``的``ndarrays``相似，pandas的 ``Index``， ``Series``，和``DataFrame`` 也提供 [``take()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.take.html#pandas.DataFrame.take) 方法。他可以沿着某个维度，按照给定的索引取回所有的元素。这个给定的索引必须要是一个由整数组成的列表或者ndarray，用以指明在索引中的位置。``take`` 也可以接受负整数，作为相对于结尾的相对位置。

``` python
In [116]: index = pd.Index(np.random.randint(0, 1000, 10))

In [117]: index
Out[117]: Int64Index([214, 502, 712, 567, 786, 175, 993, 133, 758, 329], dtype='int64')

In [118]: positions = [0, 9, 3]

In [119]: index[positions]
Out[119]: Int64Index([214, 329, 567], dtype='int64')

In [120]: index.take(positions)
Out[120]: Int64Index([214, 329, 567], dtype='int64')

In [121]: ser = pd.Series(np.random.randn(10))

In [122]: ser.iloc[positions]
Out[122]: 
0   -0.179666
9    1.824375
3    0.392149
dtype: float64

In [123]: ser.take(positions)
Out[123]: 
0   -0.179666
9    1.824375
3    0.392149
dtype: float64
```

对于``DataFrames``来说，这个给定的索引应当是一个一维列表或者ndarray，用于指明行或者列的位置。

``` python
In [124]: frm = pd.DataFrame(np.random.randn(5, 3))

In [125]: frm.take([1, 4, 3])
Out[125]: 
          0         1         2
1 -1.237881  0.106854 -1.276829
4  0.629675 -1.425966  1.857704
3  0.979542 -1.633678  0.615855

In [126]: frm.take([0, 2], axis=1)
Out[126]: 
          0         2
0  0.595974  0.601544
1 -1.237881 -1.276829
2 -0.767101  1.499591
3  0.979542  0.615855
4  0.629675  1.857704
```

需要注意的是， pandas对象的``take`` 方法并不会正常地工作在布尔索引上，并且有可能会返回一切意外的结果。

``` python
In [127]: arr = np.random.randn(10)

In [128]: arr.take([False, False, True, True])
Out[128]: array([-1.1935, -1.1935,  0.6775,  0.6775])

In [129]: arr[[0, 1]]
Out[129]: array([-1.1935,  0.6775])

In [130]: ser = pd.Series(np.random.randn(10))

In [131]: ser.take([False, False, True, True])
Out[131]: 
0    0.233141
0    0.233141
1   -0.223540
1   -0.223540
dtype: float64

In [132]: ser.iloc[[0, 1]]
Out[132]: 
0    0.233141
1   -0.223540
dtype: float64
```

最后，关于性能方面的一个小建议，因为 ``take`` 方法处理的是一个范围更窄的输入，因此会比话实索引（fancy indexing）的速度快很多。

``` python
In [133]: arr = np.random.randn(10000, 5)

In [134]: indexer = np.arange(10000)

In [135]: random.shuffle(indexer)

In [136]: %timeit arr[indexer]
   .....: %timeit arr.take(indexer, axis=0)
   .....: 
152 us +- 988 ns per loop (mean +- std. dev. of 7 runs, 10000 loops each)
41.7 us +- 204 ns per loop (mean +- std. dev. of 7 runs, 10000 loops each)
```

``` python
In [137]: ser = pd.Series(arr[:, 0])

In [138]: %timeit ser.iloc[indexer]
   .....: %timeit ser.take(indexer)
   .....: 
120 us +- 1.05 us per loop (mean +- std. dev. of 7 runs, 10000 loops each)
110 us +- 795 ns per loop (mean +- std. dev. of 7 runs, 10000 loops each)
```



## 索引类型

我们在前面已经较为深入地探讨过了多层索引。你可以在 [这里](timeseries.html#timeseries-overview)，可以找到关于 ``DatetimeIndex`` 和``PeriodIndex``的说明文件。在 [这里](timedeltas.html#timedeltas-index)，你可以找到关于``TimedeltaIndex``的说明。

In the following sub-sections we will highlight some other index types.

下面的一个子章节，我们将会着重探讨另外的一些索引的类型。

### 分类索引

[``CategoricalIndex``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.CategoricalIndex.html#pandas.CategoricalIndex)分类索引 这种索引类型非常适合有重复的索引。这是一个围绕  [``Categorical``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Categorical.html#pandas.Categorical) 而创建的容器。这可以非常高效地存储和索引的具有大量重复元素的索引。

``` python
In [139]: from pandas.api.types import CategoricalDtype

In [140]: df = pd.DataFrame({'A': np.arange(6),
   .....:                    'B': list('aabbca')})
   .....: 

In [141]: df['B'] = df['B'].astype(CategoricalDtype(list('cab')))

In [142]: df
Out[142]: 
   A  B
0  0  a
1  1  a
2  2  b
3  3  b
4  4  c
5  5  a

In [143]: df.dtypes
Out[143]: 
A       int64
B    category
dtype: object

In [144]: df.B.cat.categories
Out[144]: Index(['c', 'a', 'b'], dtype='object')
```

通过设置索引将会建立一个 ``CategoricalIndex`` 分类索引.

``` python
In [145]: df2 = df.set_index('B')

In [146]: df2.index
Out[146]: CategoricalIndex(['a', 'a', 'b', 'b', 'c', 'a'], categories=['c', 'a', 'b'], ordered=False, name='B', dtype='category')
```

使用 ``__getitem__/.iloc/.loc`` 进行索引，在含有重复值的``索引``上的工作原理相似。索引值**必须**在一个分类中，否者将会引发``KeyError``错误。

``` python
In [147]: df2.loc['a']
Out[147]: 
   A
B   
a  0
a  1
a  5
```

``CategoricalIndex`` 在索引之后也会被**保留**:

``` python
In [148]: df2.loc['a'].index
Out[148]: CategoricalIndex(['a', 'a', 'a'], categories=['c', 'a', 'b'], ordered=False, name='B', dtype='category')
```

索引排序将会按照类别清单中的顺序进行（我们已经基于 ``CategoricalDtype(list('cab'))``建立了一个索引，因此排序的顺序是``cab``）

``` python
In [149]: df2.sort_index()
Out[149]: 
   A
B   
c  4
a  0
a  1
a  5
b  2
b  3
```

分组操作（Groupby）也会保留索引的全部信息。

``` python
In [150]: df2.groupby(level=0).sum()
Out[150]: 
   A
B   
c  4
a  6
b  5

In [151]: df2.groupby(level=0).sum().index
Out[151]: CategoricalIndex(['c', 'a', 'b'], categories=['c', 'a', 'b'], ordered=False, name='B', dtype='category')
```

重设索引的操作将会根据输入的索引值返回一个索引。传入一个列表，将会返回一个最普通的``Index``；如果使用类别对象``Categorical``，则会返回一个分类索引``CategoricalIndex``，按照其中**传入的**的类别值``Categorical`` dtype来进行索引。正如同你可以对**任意**pandas的索引进行重新索引一样，这将允许你随意索引任意的索引值，即便它们并**不存在**在你的类别对象中。
``` python
In [152]: df2.reindex(['a', 'e'])
Out[152]: 
     A
B     
a  0.0
a  1.0
a  5.0
e  NaN

In [153]: df2.reindex(['a', 'e']).index
Out[153]: Index(['a', 'a', 'a', 'e'], dtype='object', name='B')

In [154]: df2.reindex(pd.Categorical(['a', 'e'], categories=list('abcde')))
Out[154]: 
     A
B     
a  0.0
a  1.0
a  5.0
e  NaN

In [155]: df2.reindex(pd.Categorical(['a', 'e'], categories=list('abcde'))).index
Out[155]: CategoricalIndex(['a', 'a', 'a', 'e'], categories=['a', 'b', 'c', 'd', 'e'], ordered=False, name='B', dtype='category')
```

::: danger 警告

对于一个``分类索引``的对象进行变形或者比较操作，一定要确保他们的索引包含相同的列别，否则将会出发类型错误``TypeError`` 

``` python
In [9]: df3 = pd.DataFrame({'A': np.arange(6), 'B': pd.Series(list('aabbca')).astype('category')})

In [11]: df3 = df3.set_index('B')

In [11]: df3.index
Out[11]: CategoricalIndex(['a', 'a', 'b', 'b', 'c', 'a'], categories=['a', 'b', 'c'], ordered=False, name='B', dtype='category')

In [12]: pd.concat([df2, df3])
TypeError: categories must match existing categories when appending
```

:::

### 64位整型索引和范围索引

::: danger 警告

使用浮点数进行基于数值的索引已经再0.18.0的版本中进行了声明。想查看更改的汇总，请参见 [这里](https://pandas.pydata.org/pandas-docs/stable/whatsnew/v0.18.0.html#whatsnew-0180-float-indexers)。
:::

[``Int64Index``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Int64Index.html#pandas.Int64Index) 64位整型索引是pandas中的一种非常基本的索引操作。这是一个不可变的数组组成的一个有序的，可切片的集合。再0.18.0之前，``Int64Index``是会为所有``NDFrame`` 对象提供默认的索引。

[``RangeIndex``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.RangeIndex.html#pandas.RangeIndex)  范围索引是``64位整型索引``的子集，在v0.18.0版本加入。现在由范围索引来为所有的``NDFrame``对象提供默认索引。
``RangeIndex``是一个对于 ``Int64Index`` 的优化版本，能够提供一个有序且严格单调的集合。这个索引与python的 [range types](https://docs.python.org/3/library/stdtypes.html#typesseq-range)是相似的

### 64位浮点索引

默认情况下，当传入浮点数、或者浮点整型混合数的时候，一个64位浮点索引 [``Float64Index``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Float64Index.html#pandas.Float64Index)将会自动被建立。这样将能够确保一个存粹而统一的基于标签的索引切片行为，这样``[],ix,loc``对于标量索引和切片的工作行为将会完全一致。

``` python
In [156]: indexf = pd.Index([1.5, 2, 3, 4.5, 5])

In [157]: indexf
Out[157]: Float64Index([1.5, 2.0, 3.0, 4.5, 5.0], dtype='float64')

In [158]: sf = pd.Series(range(5), index=indexf)

In [159]: sf
Out[159]: 
1.5    0
2.0    1
3.0    2
4.5    3
5.0    4
dtype: int64
```

标量选择对于``[],.loc``永远都是基于标签的。一个整型将会自动匹配一个浮点标签（例如，``3`` 等于 ``3.0``）

``` python
In [160]: sf[3]
Out[160]: 2

In [161]: sf[3.0]
Out[161]: 2

In [162]: sf.loc[3]
Out[162]: 2

In [163]: sf.loc[3.0]
Out[163]: 2
```

唯一能够通过位置进行索引的方式是通过``iloc``方法。

``` python
In [164]: sf.iloc[3]
Out[164]: 3
```

一个找不到的标量索引会触发一个``KeyError``错误。当使用``[],ix,loc``是，切片操作优先会选择索引的值，但是``iloc``**永远**都会按位置索引。唯一的例外是使用布尔索引，此时将始终按位置选择。

``` python
In [165]: sf[2:4]
Out[165]: 
2.0    1
3.0    2
dtype: int64

In [166]: sf.loc[2:4]
Out[166]: 
2.0    1
3.0    2
dtype: int64

In [167]: sf.iloc[2:4]
Out[167]: 
3.0    2
4.5    3
dtype: int64
```

如果你使用的是浮点数索引，那么使用浮点数切片也是可以执行的。

``` python
In [168]: sf[2.1:4.6]
Out[168]: 
3.0    2
4.5    3
dtype: int64

In [169]: sf.loc[2.1:4.6]
Out[169]: 
3.0    2
4.5    3
dtype: int64
```

在非浮点数中，如果使用浮点索引，将会触发``TypeError``错误。

``` python
In [1]: pd.Series(range(5))[3.5]
TypeError: the label [3.5] is not a proper indexer for this index type (Int64Index)

In [1]: pd.Series(range(5))[3.5:4.5]
TypeError: the slice start [3.5] is not a proper indexer for this index type (Int64Index)
```

::: danger 警告

从0.18.0开始，``.iloc``将不能够使用标量浮点数进行索引，因此下列操作将触发``TypeError``错误。

``` python
In [3]: pd.Series(range(5)).iloc[3.0]
TypeError: cannot do positional indexing on <class 'pandas.indexes.range.RangeIndex'> with these indexers [3.0] of <type 'float'>
```

:::

这里有一个典型的场景来使用这种类型的索引方式。设想你有一个不规范的类timedelta的索引方案，但是日期是按照浮点数的方式记录的。这将会导致（例如）毫秒级的延迟。

``` python
In [170]: dfir = pd.concat([pd.DataFrame(np.random.randn(5, 2),
   .....:                                index=np.arange(5) * 250.0,
   .....:                                columns=list('AB')),
   .....:                   pd.DataFrame(np.random.randn(6, 2),
   .....:                                index=np.arange(4, 10) * 250.1,
   .....:                                columns=list('AB'))])
   .....: 

In [171]: dfir
Out[171]: 
               A         B
0.0    -0.435772 -1.188928
250.0  -0.808286 -0.284634
500.0  -1.815703  1.347213
750.0  -0.243487  0.514704
1000.0  1.162969 -0.287725
1000.4 -0.179734  0.993962
1250.5 -0.212673  0.909872
1500.6 -0.733333 -0.349893
1750.7  0.456434 -0.306735
2000.8  0.553396  0.166221
2250.9 -0.101684 -0.734907
```

因此选择操作将总是按照值来进行所有的选择工作，

``` python
In [172]: dfir[0:1000.4]
Out[172]: 
               A         B
0.0    -0.435772 -1.188928
250.0  -0.808286 -0.284634
500.0  -1.815703  1.347213
750.0  -0.243487  0.514704
1000.0  1.162969 -0.287725
1000.4 -0.179734  0.993962

In [173]: dfir.loc[0:1001, 'A']
Out[173]: 
0.0      -0.435772
250.0    -0.808286
500.0    -1.815703
750.0    -0.243487
1000.0    1.162969
1000.4   -0.179734
Name: A, dtype: float64

In [174]: dfir.loc[1000.4]
Out[174]: 
A   -0.179734
B    0.993962
Name: 1000.4, dtype: float64
```

你可以返回第一秒（1000毫秒）的数据：

``` python
In [175]: dfir[0:1000]
Out[175]: 
               A         B
0.0    -0.435772 -1.188928
250.0  -0.808286 -0.284634
500.0  -1.815703  1.347213
750.0  -0.243487  0.514704
1000.0  1.162969 -0.287725
```

如果你想要使用基于整型的选择，你应该使用``iloc``:

``` python
In [176]: dfir.iloc[0:5]
Out[176]: 
               A         B
0.0    -0.435772 -1.188928
250.0  -0.808286 -0.284634
500.0  -1.815703  1.347213
750.0  -0.243487  0.514704
1000.0  1.162969 -0.287725
```

### 间隔索引

*0.20.0中新加入*
[``IntervalIndex``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.IntervalIndex.html#pandas.IntervalIndex)和它自己特有的``IntervalDtype``以及 [``Interval``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Interval.html#pandas.Interval) 标量类型，在pandas中，间隔数据是获得头等支持的。

 ``IntervalIndex``间隔索引允许一些唯一的索引，并且也是 [``cut()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.cut.html#pandas.cut) 和[``qcut()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.qcut.html#pandas.qcut)的返回类型

#### 使用``间隔索引``来进行数据索引

``` python
In [177]: df = pd.DataFrame({'A': [1, 2, 3, 4]},
   .....:                   index=pd.IntervalIndex.from_breaks([0, 1, 2, 3, 4]))
   .....: 

In [178]: df
Out[178]: 
        A
(0, 1]  1
(1, 2]  2
(2, 3]  3
(3, 4]  4
```

在间隔序列上使用基于标签的索引``.loc`` ，正如你所预料到的，将会选择那个特定的间隔

``` python
In [179]: df.loc[2]
Out[179]: 
A    2
Name: (1, 2], dtype: int64

In [180]: df.loc[[2, 3]]
Out[180]: 
        A
(1, 2]  2
(2, 3]  3
```

如果你选取了一个标签，被*包含*在间隔当中，这个间隔也将会被选择

``` python
In [181]: df.loc[2.5]
Out[181]: 
A    3
Name: (2, 3], dtype: int64

In [182]: df.loc[[2.5, 3.5]]
Out[182]: 
        A
(2, 3]  3
(3, 4]  4
```

使用 ``Interval``来选择，将只返回严格匹配（从pandas0.25.0开始）。

``` python
In [183]: df.loc[pd.Interval(1, 2)]
Out[183]: 
A    2
Name: (1, 2], dtype: int64
```

试图选择一个没有被严格包含在 ``IntervalIndex`` 内的区间``Interval``，将会出发``KeyError``错误。

``` python
In [7]: df.loc[pd.Interval(0.5, 2.5)]
---------------------------------------------------------------------------
KeyError: Interval(0.5, 2.5, closed='right')
```

可以使用[``overlaps()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.IntervalIndex.overlaps.html#pandas.IntervalIndex.overlaps)来创建一个布尔选择器，来选中所有与``给定区间``(``Interval``)重复的所有区间。

``` python
In [184]: idxr = df.index.overlaps(pd.Interval(0.5, 2.5))

In [185]: idxr
Out[185]: array([ True,  True,  True, False])

In [186]: df[idxr]
Out[186]: 
        A
(0, 1]  1
(1, 2]  2
(2, 3]  3
```

#### 使用 ``cut`` 和 ``qcut``来为数据分块

[``cut()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.cut.html#pandas.cut) 和 [``qcut()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.qcut.html#pandas.qcut)  都将返回一个分类``Categorical`` 对象，并且每个分块区域都会以 分类索引``IntervalIndex``的方式被创建并保存在它的``.categories``属性中。

``` python
In [187]: c = pd.cut(range(4), bins=2)

In [188]: c
Out[188]: 
[(-0.003, 1.5], (-0.003, 1.5], (1.5, 3.0], (1.5, 3.0]]
Categories (2, interval[float64]): [(-0.003, 1.5] < (1.5, 3.0]]

In [189]: c.categories
Out[189]: 
IntervalIndex([(-0.003, 1.5], (1.5, 3.0]],
              closed='right',
              dtype='interval[float64]')
```

[``cut()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.cut.html#pandas.cut) 也可以接受一个 ``IntervalIndex`` 作为他的 ``bins`` 参数，这样可以使用一个非常有用的pandas的写法。
首先，我们调用 [``cut()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.cut.html#pandas.cut)  在一些数据上面，并且将 ``bins``设置为某一个固定的数 ，从而生成bins。

随后，我们可以在其他的数据上调用 [``cut()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.cut.html#pandas.cut)，并传入``.categories`` 的值，作为 ``bins``参数。这样新的数据就也将会被分配到同样的bins里面

``` python
In [190]: pd.cut([0, 3, 5, 1], bins=c.categories)
Out[190]: 
[(-0.003, 1.5], (1.5, 3.0], NaN, (-0.003, 1.5]]
Categories (2, interval[float64]): [(-0.003, 1.5] < (1.5, 3.0]]
```

任何落在bins之外的数据都将会被设为 ``NaN`` 

#### 生成一定区间内的间隔

如果我们需要经常地使用步进区间，我们可以使用  [``interval_range()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.interval_range.html#pandas.interval_range)  函数，结合 ``start``, ``end``, 和 ``periods``来建立一个 ``IntervalIndex``
对于数值型的间隔，默认的 ``interval_range``间隔频率是1，对于datetime类型的间隔则是日历日。

``` python
In [191]: pd.interval_range(start=0, end=5)
Out[191]: 
IntervalIndex([(0, 1], (1, 2], (2, 3], (3, 4], (4, 5]],
              closed='right',
              dtype='interval[int64]')

In [192]: pd.interval_range(start=pd.Timestamp('2017-01-01'), periods=4)
Out[192]: 
IntervalIndex([(2017-01-01, 2017-01-02], (2017-01-02, 2017-01-03], (2017-01-03, 2017-01-04], (2017-01-04, 2017-01-05]],
              closed='right',
              dtype='interval[datetime64[ns]]')

In [193]: pd.interval_range(end=pd.Timedelta('3 days'), periods=3)
Out[193]: 
IntervalIndex([(0 days 00:00:00, 1 days 00:00:00], (1 days 00:00:00, 2 days 00:00:00], (2 days 00:00:00, 3 days 00:00:00]],
              closed='right',
              dtype='interval[timedelta64[ns]]')
```

 ``freq`` 参数可以被用来明确非默认的频率，并且可以充分地利用各种各样的 [frequency aliases](timeseries.html#timeseries-offset-aliases) datetime类型的时间间隔。

``` python
In [194]: pd.interval_range(start=0, periods=5, freq=1.5)
Out[194]: 
IntervalIndex([(0.0, 1.5], (1.5, 3.0], (3.0, 4.5], (4.5, 6.0], (6.0, 7.5]],
              closed='right',
              dtype='interval[float64]')

In [195]: pd.interval_range(start=pd.Timestamp('2017-01-01'), periods=4, freq='W')
Out[195]: 
IntervalIndex([(2017-01-01, 2017-01-08], (2017-01-08, 2017-01-15], (2017-01-15, 2017-01-22], (2017-01-22, 2017-01-29]],
              closed='right',
              dtype='interval[datetime64[ns]]')

In [196]: pd.interval_range(start=pd.Timedelta('0 days'), periods=3, freq='9H')
Out[196]: 
IntervalIndex([(0 days 00:00:00, 0 days 09:00:00], (0 days 09:00:00, 0 days 18:00:00], (0 days 18:00:00, 1 days 03:00:00]],
              closed='right',
              dtype='interval[timedelta64[ns]]')
```

此外， ``closed`` 参数可以用来声明哪个边界是包含的。默认情况下，间隔的右界是包含的。

``` python
In [197]: pd.interval_range(start=0, end=4, closed='both')
Out[197]: 
IntervalIndex([[0, 1], [1, 2], [2, 3], [3, 4]],
              closed='both',
              dtype='interval[int64]')

In [198]: pd.interval_range(start=0, end=4, closed='neither')
Out[198]: 
IntervalIndex([(0, 1), (1, 2), (2, 3), (3, 4)],
              closed='neither',
              dtype='interval[int64]')
```
*v0.23.0新加入*

使用``start``, ``end``, 和 ``periods``可以从 ``start`` 到 ``end``（包含）生成一个平均分配的间隔，在返回``IntervalIndex``中生成``periods``这么多的元素（译者：区间）。

``` python
In [199]: pd.interval_range(start=0, end=6, periods=4)
Out[199]: 
IntervalIndex([(0.0, 1.5], (1.5, 3.0], (3.0, 4.5], (4.5, 6.0]],
              closed='right',
              dtype='interval[float64]')

In [200]: pd.interval_range(pd.Timestamp('2018-01-01'),
   .....:                   pd.Timestamp('2018-02-28'), periods=3)
   .....: 
Out[200]: 
IntervalIndex([(2018-01-01, 2018-01-20 08:00:00], (2018-01-20 08:00:00, 2018-02-08 16:00:00], (2018-02-08 16:00:00, 2018-02-28]],
              closed='right',
              dtype='interval[datetime64[ns]]')
```


## 其他索引常见问题

### 数值索引

使用数值作为各维度的标签，再基于标签进行索引是一个非常痛苦的话题。在Scientific Python社区的邮件列表中，进行着剧烈的争论。在Pandas中，我们一般性的观点是，标签比实际的（用数值表示的）位置更为重要。因此，对于使用数值作为标签的的对象来说，*只有*基于标签的索引才可以在标准工具，例如``.loc``方法，中正常使用。下面的代码将引发错误：

``` python
In [201]: s = pd.Series(range(5))

In [202]: s[-1]
---------------------------------------------------------------------------
KeyError                                  Traceback (most recent call last)
<ipython-input-202-76c3dce40054> in <module>
----> 1 s[-1]

/pandas/pandas/core/series.py in __getitem__(self, key)
   1062         key = com.apply_if_callable(key, self)
   1063         try:
-> 1064             result = self.index.get_value(self, key)
   1065 
   1066             if not is_scalar(result):

/pandas/pandas/core/indexes/base.py in get_value(self, series, key)
   4721         k = self._convert_scalar_indexer(k, kind="getitem")
   4722         try:
-> 4723             return self._engine.get_value(s, k, tz=getattr(series.dtype, "tz", None))
   4724         except KeyError as e1:
   4725             if len(self) > 0 and (self.holds_integer() or self.is_boolean()):

/pandas/pandas/_libs/index.pyx in pandas._libs.index.IndexEngine.get_value()

/pandas/pandas/_libs/index.pyx in pandas._libs.index.IndexEngine.get_value()

/pandas/pandas/_libs/index.pyx in pandas._libs.index.IndexEngine.get_loc()

/pandas/pandas/_libs/hashtable_class_helper.pxi in pandas._libs.hashtable.Int64HashTable.get_item()

/pandas/pandas/_libs/hashtable_class_helper.pxi in pandas._libs.hashtable.Int64HashTable.get_item()

KeyError: -1

In [203]: df = pd.DataFrame(np.random.randn(5, 4))

In [204]: df
Out[204]: 
          0         1         2         3
0 -0.130121 -0.476046  0.759104  0.213379
1 -0.082641  0.448008  0.656420 -1.051443
2  0.594956 -0.151360 -0.069303  1.221431
3 -0.182832  0.791235  0.042745  2.069775
4  1.446552  0.019814 -1.389212 -0.702312

In [205]: df.loc[-2:]
Out[205]: 
          0         1         2         3
0 -0.130121 -0.476046  0.759104  0.213379
1 -0.082641  0.448008  0.656420 -1.051443
2  0.594956 -0.151360 -0.069303  1.221431
3 -0.182832  0.791235  0.042745  2.069775
4  1.446552  0.019814 -1.389212 -0.702312
```

我们特意地做了这样的设计，是为了阻止歧义性以及一些难以避免的小bug（当我们修改了函数，从而阻止了“滚回”到基于位置的索引方式以后，许多用户报告说，他们发现了bug）。

### 非单调索引要求严格匹配

如果一个  ``序列`` 或者 ``数据表``是单调递增或递减的，那么基于标签的切片行为的边界是可以超出索引的，这与普通的python``列表``的索引切片非常相似。索引的单调性可以使用 [``is_monotonic_increasing()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.is_monotonic_increasing.html#pandas.Index.is_monotonic_increasing) 和[``is_monotonic_decreasing()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.is_monotonic_decreasing.html#pandas.Index.is_monotonic_decreasing) 属性来检查

``` python
In [206]: df = pd.DataFrame(index=[2, 3, 3, 4, 5], columns=['data'], data=list(range(5)))

In [207]: df.index.is_monotonic_increasing
Out[207]: True

# no rows 0 or 1, but still returns rows 2, 3 (both of them), and 4:
In [208]: df.loc[0:4, :]
Out[208]: 
   data
2     0
3     1
3     2
4     3

# slice is are outside the index, so empty DataFrame is returned
In [209]: df.loc[13:15, :]
Out[209]: 
Empty DataFrame
Columns: [data]
Index: []
```

另一方面，如果索引不是单调的，那么切片的两侧边界都必须是索引值中的*唯一*值。

``` python
In [210]: df = pd.DataFrame(index=[2, 3, 1, 4, 3, 5],
   .....:                   columns=['data'], data=list(range(6)))
   .....: 

In [211]: df.index.is_monotonic_increasing
Out[211]: False

# OK because 2 and 4 are in the index
In [212]: df.loc[2:4, :]
Out[212]: 
   data
2     0
3     1
1     2
4     3
```

``` python
# 0 is not in the index
In [9]: df.loc[0:4, :]
KeyError: 0

# 3 is not a unique label
In [11]: df.loc[2:3, :]
KeyError: 'Cannot get right slice bound for non-unique label: 3'
```

``Index.is_monotonic_increasing``和``Index.is_monotonic_decreasing``方法只能进行弱单调性的检查。要进行严格的单调性检查，你可以配合 [``is_unique()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.is_unique.html#pandas.Index.is_unique) 方法一起使用。

``` python
In [213]: weakly_monotonic = pd.Index(['a', 'b', 'c', 'c'])

In [214]: weakly_monotonic
Out[214]: Index(['a', 'b', 'c', 'c'], dtype='object')

In [215]: weakly_monotonic.is_monotonic_increasing
Out[215]: True

In [216]: weakly_monotonic.is_monotonic_increasing & weakly_monotonic.is_unique
Out[216]: False
```

### 终止点被包含在内

与表中的python序列切片中，终止点不被包含不同，基于标签的切片在Pandas中，终止点是被**包含在内**的。最主要的原因是因为，我们很难准确地确定在索引中的“下一个”标签“到底是什么。例如下面这个``序列``：

``` python
In [217]: s = pd.Series(np.random.randn(6), index=list('abcdef'))

In [218]: s
Out[218]: 
a    0.301379
b    1.240445
c   -0.846068
d   -0.043312
e   -1.658747
f   -0.819549
dtype: float64
```

如果我们希望从``c``选取到``e``，如果我们使用基于数值的索引，那将会由如下操作：

``` python
In [219]: s[2:5]
Out[219]: 
c   -0.846068
d   -0.043312
e   -1.658747
dtype: float64
```

然而，如果你只有``c``和``e``，确定下一个索引中的元素将会是比较困难的。例如，下面的这种方法完全是行不通的：

``` python
s.loc['c':'e' + 1]
```

一个非常常见的用例是限制一个时间序列的起始和终止日期。为了能够便于操作，我们决定在基于标签的切片行为中包含两个端点：

``` python
In [220]: s.loc['c':'e']
Out[220]: 
c   -0.846068
d   -0.043312
e   -1.658747
dtype: float64
```

这是一个非常典型的“显示战胜理想”的情况，但是如果你仅仅是想当然的认为基于标签的索引应该会和标准python中的整数型索引有着相同的行为时，你也确实需要多加留意。

### 索引会潜在地改变序列的dtype

不同的索引操作有可能会潜在地改变一个``序列``的dtypes

``` python
In [221]: series1 = pd.Series([1, 2, 3])

In [222]: series1.dtype
Out[222]: dtype('int64')

In [223]: res = series1.reindex([0, 4])

In [224]: res.dtype
Out[224]: dtype('float64')

In [225]: res
Out[225]: 
0    1.0
4    NaN
dtype: float64
```

``` python
In [226]: series2 = pd.Series([True])

In [227]: series2.dtype
Out[227]: dtype('bool')

In [228]: res = series2.reindex_like(series1)

In [229]: res.dtype
Out[229]: dtype('O')

In [230]: res
Out[230]: 
0    True
1     NaN
2     NaN
dtype: object
```

这是因为上述（重新）索引的操作悄悄地插入了 ``NaNs`` ，因此dtype也就随之发生改变了。如果你在使用一些``numpy``的``ufuncs``，如 ``numpy.logical_and``时，将会导致一些问题。

参见 [this old issue](https://github.com/pydata/pandas/issues/2388)了解更详细的讨论过程