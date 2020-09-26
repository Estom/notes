# 索引和数据选择器

Pandas对象中的轴标记信息有多种用途：

- 使用已知指标识别数据（即提供*元数据*），这对于分析，可视化和交互式控制台显示非常重要。
- 启用自动和显式数据对齐。
- 允许直观地获取和设置数据集的子集。

在本节中，我们将重点关注最后一点：即如何切片，切块，以及通常获取和设置pandas对象的子集。主要关注的是Series和DataFrame，因为他们在这个领域受到了更多的开发关注。

::: tip 注意

Python和NumPy索引运算符``[]``和属性运算符``.``
可以在各种用例中快速轻松地访问pandas数据结构。这使得交互式工作变得直观，因为如果您已经知道如何处理Python字典和NumPy数组，那么几乎没有新的东西需要学习。但是，由于预先不知道要访问的数据类型，因此直接使用标准运算符会有一些优化限制。对于生产代码，我们建议您利用本章中介绍的优化的pandas数据访问方法。

:::

::: danger 警告

是否为设置操作返回副本或引用可能取决于上下文。这有时被称为应该避免。请参阅[返回视图与复制](#indexing-view-versus-copy)。``chained assignment``[](#indexing-view-versus-copy)

:::

::: danger 警告

使用浮点数对基于整数的索引进行索引已在0.18.0中进行了说明，有关更改的摘要，请参见[此处](https://pandas.pydata.org/pandas-docs/stable/whatsnew/v0.18.0.html#whatsnew-0180-float-indexers)。

:::

见[多指标/高级索引](advanced.html#advanced)的``MultiIndex``和更先进的索引文件。

有关一些高级策略，请参阅[食谱](cookbook.html#cookbook-selection)。

## 索引的不同选择

对象选择已经有许多用户请求的添加，以支持更明确的基于位置的索引。Pandas现在支持三种类型的多轴索引。

- ``.loc``主要是基于标签的，但也可以与布尔数组一起使用。当找不到物品时``.loc``会提高``KeyError``。允许的输入是：
   - 单个标签，例如``5``或``'a'``（注意，它``5``被解释为索引的
   *标签*。此用法**不是**索引的整数位置。）。
   - 列表或标签数组。``['a', 'b', 'c']``
   - 带标签的切片对象``'a':'f'``（注意，相反普通的Python片，**都**开始和停止都包括在内，当存在于索引中！见[有标签切片](#indexing-slicing-with-labels) 
   和[端点都包括在内](advanced.html#advanced-endpoints-are-inclusive)。）
   - 布尔数组
   - 一个``callable``带有一个参数的函数（调用Series或DataFrame）并返回有效的索引输出（上面的一个）。

   *版本0.18.1中的新功能。*

   在[标签选择中](#indexing-label)查看更多信息。
   
- ``.iloc``是基于主要的整数位置（从``0``到 ``length-1``所述轴的），但也可以用布尔阵列使用。  如果请求的索引器超出范围，``.iloc``则会引发``IndexError``，但允许越界索引的*切片*索引器除外。（这符合Python / NumPy *切片* 
语义）。允许的输入是：
   - 一个整数，例如``5``。
   - 整数列表或数组。``[4, 3, 0]``
   - 带有整数的切片对象``1:7``。
   - 布尔数组。
   - 一个``callable``带有一个参数的函数（调用Series或DataFrame）并返回有效的索引输出（上面的一个）。

   *版本0.18.1中的新功能。*

   有关详细信息，请参阅[按位置选择](#indexing-integer)，[高级索引](advanced.html#advanced)和[高级层次结构](advanced.html#advanced-advanced-hierarchical)。

- ``.loc``，``.iloc``以及``[]``索引也可以接受一个``callable``索引器。在[Select By Callable中](#indexing-callable)查看更多信息。

从具有多轴选择的对象获取值使用以下表示法（使用``.loc``作为示例，但以下也适用``.iloc``）。任何轴访问器可以是空切片``:``。假设超出规范的轴是``:``，例如``p.loc['a']``相当于
 。``p.loc['a', :, :]``

对象类型 | 索引
---|---
系列 | s.loc[indexer]
数据帧 | df.loc[row_indexer,column_indexer]

## 基础知识

正如在[上一节中](/docs/getting_started/basics.html)介绍数据结构时所提到的，索引的主要功能``[]``（也就是``__getitem__``
那些熟悉在Python中实现类行为的人）是选择低维切片。下表显示了使用以下方法索引pandas对象时的返回类型值``[]``：

对象类型 | 选择 | 返回值类型
---|---|---
系列 | series[label] | 标量值
数据帧 | frame[colname] | Series 对应于colname

在这里，我们构建一个简单的时间序列数据集，用于说明索引功能：

``` python
In [1]: dates = pd.date_range('1/1/2000', periods=8)

In [2]: df = pd.DataFrame(np.random.randn(8, 4),
   ...:                   index=dates, columns=['A', 'B', 'C', 'D'])
   ...: 

In [3]: df
Out[3]: 
                   A         B         C         D
2000-01-01  0.469112 -0.282863 -1.509059 -1.135632
2000-01-02  1.212112 -0.173215  0.119209 -1.044236
2000-01-03 -0.861849 -2.104569 -0.494929  1.071804
2000-01-04  0.721555 -0.706771 -1.039575  0.271860
2000-01-05 -0.424972  0.567020  0.276232 -1.087401
2000-01-06 -0.673690  0.113648 -1.478427  0.524988
2000-01-07  0.404705  0.577046 -1.715002 -1.039268
2000-01-08 -0.370647 -1.157892 -1.344312  0.844885
```

::: tip 注意

除非特别说明，否则索引功能都不是时间序列特定的。

:::

因此，如上所述，我们使用最基本的索引``[]``：

``` python
In [4]: s = df['A']

In [5]: s[dates[5]]
Out[5]: -0.6736897080883706
```

您可以传递列表列表``[]``以按该顺序选择列。如果DataFrame中未包含列，则会引发异常。也可以这种方式设置多列：

``` python
In [6]: df
Out[6]: 
                   A         B         C         D
2000-01-01  0.469112 -0.282863 -1.509059 -1.135632
2000-01-02  1.212112 -0.173215  0.119209 -1.044236
2000-01-03 -0.861849 -2.104569 -0.494929  1.071804
2000-01-04  0.721555 -0.706771 -1.039575  0.271860
2000-01-05 -0.424972  0.567020  0.276232 -1.087401
2000-01-06 -0.673690  0.113648 -1.478427  0.524988
2000-01-07  0.404705  0.577046 -1.715002 -1.039268
2000-01-08 -0.370647 -1.157892 -1.344312  0.844885

In [7]: df[['B', 'A']] = df[['A', 'B']]

In [8]: df
Out[8]: 
                   A         B         C         D
2000-01-01 -0.282863  0.469112 -1.509059 -1.135632
2000-01-02 -0.173215  1.212112  0.119209 -1.044236
2000-01-03 -2.104569 -0.861849 -0.494929  1.071804
2000-01-04 -0.706771  0.721555 -1.039575  0.271860
2000-01-05  0.567020 -0.424972  0.276232 -1.087401
2000-01-06  0.113648 -0.673690 -1.478427  0.524988
2000-01-07  0.577046  0.404705 -1.715002 -1.039268
2000-01-08 -1.157892 -0.370647 -1.344312  0.844885
```

您可能会发现这对于将变换（就地）应用于列的子集非常有用。

::: danger 警告

pandas在设置``Series``和``DataFrame``来自``.loc``和时对齐所有AXES ``.iloc``。

这**不会**修改，``df``因为列对齐在赋值之前。

``` python
In [9]: df[['A', 'B']]
Out[9]: 
                   A         B
2000-01-01 -0.282863  0.469112
2000-01-02 -0.173215  1.212112
2000-01-03 -2.104569 -0.861849
2000-01-04 -0.706771  0.721555
2000-01-05  0.567020 -0.424972
2000-01-06  0.113648 -0.673690
2000-01-07  0.577046  0.404705
2000-01-08 -1.157892 -0.370647

In [10]: df.loc[:, ['B', 'A']] = df[['A', 'B']]

In [11]: df[['A', 'B']]
Out[11]: 
                   A         B
2000-01-01 -0.282863  0.469112
2000-01-02 -0.173215  1.212112
2000-01-03 -2.104569 -0.861849
2000-01-04 -0.706771  0.721555
2000-01-05  0.567020 -0.424972
2000-01-06  0.113648 -0.673690
2000-01-07  0.577046  0.404705
2000-01-08 -1.157892 -0.370647
```

交换列值的正确方法是使用原始值：

``` python
In [12]: df.loc[:, ['B', 'A']] = df[['A', 'B']].to_numpy()

In [13]: df[['A', 'B']]
Out[13]: 
                   A         B
2000-01-01  0.469112 -0.282863
2000-01-02  1.212112 -0.173215
2000-01-03 -0.861849 -2.104569
2000-01-04  0.721555 -0.706771
2000-01-05 -0.424972  0.567020
2000-01-06 -0.673690  0.113648
2000-01-07  0.404705  0.577046
2000-01-08 -0.370647 -1.157892
```

:::

## 属性访问

您可以直接访问某个``Series``或列上的索引``DataFrame``作为属性：

``` python
In [14]: sa = pd.Series([1, 2, 3], index=list('abc'))

In [15]: dfa = df.copy()
```

``` python
In [16]: sa.b
Out[16]: 2

In [17]: dfa.A
Out[17]: 
2000-01-01    0.469112
2000-01-02    1.212112
2000-01-03   -0.861849
2000-01-04    0.721555
2000-01-05   -0.424972
2000-01-06   -0.673690
2000-01-07    0.404705
2000-01-08   -0.370647
Freq: D, Name: A, dtype: float64
```

``` python
In [18]: sa.a = 5

In [19]: sa
Out[19]: 
a    5
b    2
c    3
dtype: int64

In [20]: dfa.A = list(range(len(dfa.index)))  # ok if A already exists

In [21]: dfa
Out[21]: 
            A         B         C         D
2000-01-01  0 -0.282863 -1.509059 -1.135632
2000-01-02  1 -0.173215  0.119209 -1.044236
2000-01-03  2 -2.104569 -0.494929  1.071804
2000-01-04  3 -0.706771 -1.039575  0.271860
2000-01-05  4  0.567020  0.276232 -1.087401
2000-01-06  5  0.113648 -1.478427  0.524988
2000-01-07  6  0.577046 -1.715002 -1.039268
2000-01-08  7 -1.157892 -1.344312  0.844885

In [22]: dfa['A'] = list(range(len(dfa.index)))  # use this form to create a new column

In [23]: dfa
Out[23]: 
            A         B         C         D
2000-01-01  0 -0.282863 -1.509059 -1.135632
2000-01-02  1 -0.173215  0.119209 -1.044236
2000-01-03  2 -2.104569 -0.494929  1.071804
2000-01-04  3 -0.706771 -1.039575  0.271860
2000-01-05  4  0.567020  0.276232 -1.087401
2000-01-06  5  0.113648 -1.478427  0.524988
2000-01-07  6  0.577046 -1.715002 -1.039268
2000-01-08  7 -1.157892 -1.344312  0.844885
```

::: danger 警告

- 仅当index元素是有效的Python标识符时才可以使用此访问权限，例如``s.1``，不允许。有关[有效标识符的说明，](https://docs.python.org/3/reference/lexical_analysis.html#identifiers)请参见[此处](https://docs.python.org/3/reference/lexical_analysis.html#identifiers)。
- 如果该属性与现有方法名称冲突，则该属性将不可用，例如``s.min``，不允许。
- 同样的，如果它与任何下面的列表冲突的属性将不可用：``index``，
 ``major_axis``，``minor_axis``，``items``。
- 在任何一种情况下，标准索引仍然可以工作，例如``s['1']``，``s['min']``和``s['index']``将访问相应的元素或列。

:::

如果您使用的是IPython环境，则还可以使用tab-completion来查看这些可访问的属性。

您还可以将a分配``dict``给一行``DataFrame``：

``` python
In [24]: x = pd.DataFrame({'x': [1, 2, 3], 'y': [3, 4, 5]})

In [25]: x.iloc[1] = {'x': 9, 'y': 99}

In [26]: x
Out[26]: 
   x   y
0  1   3
1  9  99
2  3   5
```

您可以使用属性访问来修改DataFrame的Series或列的现有元素，但要小心; 如果您尝试使用属性访问权来创建新列，则会创建新属性而不是新列。在0.21.0及更高版本中，这将引发``UserWarning``：

``` python
In [1]: df = pd.DataFrame({'one': [1., 2., 3.]})
In [2]: df.two = [4, 5, 6]
UserWarning: Pandas doesn't allow Series to be assigned into nonexistent columns - see https://pandas.pydata.org/pandas-docs/stable/indexing.html#attribute_access
In [3]: df
Out[3]:
   one
0  1.0
1  2.0
2  3.0
```

## 切片范围

沿着任意轴切割范围的最稳健和一致的方法在详细说明该方法的“ [按位置选择”](#indexing-integer)部分中描述``.iloc``。现在，我们解释使用``[]``运算符切片的语义。

使用Series，语法与ndarray完全一样，返回值的一部分和相应的标签：

``` python
In [27]: s[:5]
Out[27]: 
2000-01-01    0.469112
2000-01-02    1.212112
2000-01-03   -0.861849
2000-01-04    0.721555
2000-01-05   -0.424972
Freq: D, Name: A, dtype: float64

In [28]: s[::2]
Out[28]: 
2000-01-01    0.469112
2000-01-03   -0.861849
2000-01-05   -0.424972
2000-01-07    0.404705
Freq: 2D, Name: A, dtype: float64

In [29]: s[::-1]
Out[29]: 
2000-01-08   -0.370647
2000-01-07    0.404705
2000-01-06   -0.673690
2000-01-05   -0.424972
2000-01-04    0.721555
2000-01-03   -0.861849
2000-01-02    1.212112
2000-01-01    0.469112
Freq: -1D, Name: A, dtype: float64
```

请注意，设置也适用：

``` python
In [30]: s2 = s.copy()

In [31]: s2[:5] = 0

In [32]: s2
Out[32]: 
2000-01-01    0.000000
2000-01-02    0.000000
2000-01-03    0.000000
2000-01-04    0.000000
2000-01-05    0.000000
2000-01-06   -0.673690
2000-01-07    0.404705
2000-01-08   -0.370647
Freq: D, Name: A, dtype: float64
```

使用DataFrame，切片内部``[]`` **切片**。这主要是为了方便而提供的，因为它是如此常见的操作。

``` python
In [33]: df[:3]
Out[33]: 
                   A         B         C         D
2000-01-01  0.469112 -0.282863 -1.509059 -1.135632
2000-01-02  1.212112 -0.173215  0.119209 -1.044236
2000-01-03 -0.861849 -2.104569 -0.494929  1.071804

In [34]: df[::-1]
Out[34]: 
                   A         B         C         D
2000-01-08 -0.370647 -1.157892 -1.344312  0.844885
2000-01-07  0.404705  0.577046 -1.715002 -1.039268
2000-01-06 -0.673690  0.113648 -1.478427  0.524988
2000-01-05 -0.424972  0.567020  0.276232 -1.087401
2000-01-04  0.721555 -0.706771 -1.039575  0.271860
2000-01-03 -0.861849 -2.104569 -0.494929  1.071804
2000-01-02  1.212112 -0.173215  0.119209 -1.044236
2000-01-01  0.469112 -0.282863 -1.509059 -1.135632
```

## 按标签选择

::: danger 警告

是否为设置操作返回副本或引用可能取决于上下文。这有时被称为应该避免。请参阅[返回视图与复制](#indexing-view-versus-copy)。``chained assignment``[](#indexing-view-versus-copy)

:::

::: danger 警告

``` python
In [35]: dfl = pd.DataFrame(np.random.randn(5, 4),
   ....:                    columns=list('ABCD'),
   ....:                    index=pd.date_range('20130101', periods=5))
   ....: 

In [36]: dfl
Out[36]: 
                   A         B         C         D
2013-01-01  1.075770 -0.109050  1.643563 -1.469388
2013-01-02  0.357021 -0.674600 -1.776904 -0.968914
2013-01-03 -1.294524  0.413738  0.276662 -0.472035
2013-01-04 -0.013960 -0.362543 -0.006154 -0.923061
2013-01-05  0.895717  0.805244 -1.206412  2.565646
```

``` python
In [4]: dfl.loc[2:3]
TypeError: cannot do slice indexing on <class 'pandas.tseries.index.DatetimeIndex'> with these indexers [2] of <type 'int'>
```

切片中的字符串喜欢*可以*转换为索引的类型并导致自然切片。

``` python
In [37]: dfl.loc['20130102':'20130104']
Out[37]: 
                   A         B         C         D
2013-01-02  0.357021 -0.674600 -1.776904 -0.968914
2013-01-03 -1.294524  0.413738  0.276662 -0.472035
2013-01-04 -0.013960 -0.362543 -0.006154 -0.923061
```

:::

::: danger 警告

从0.21.0开始，pandas将显示``FutureWarning``带有缺少标签的列表的if索引。将来这会提高一个``KeyError``。请参阅[list-like使用列表中缺少键的loc是不推荐使用](#indexing-deprecate-loc-reindex-listlike)。

:::

pandas提供了一套方法，以便拥有**纯粹基于标签的索引**。这是一个严格的包含协议。要求的每个标签必须在索引中，否则``KeyError``将被提出。切片时，如果索引中存在，则*包括*起始绑定**和**停止边界。整数是有效标签，但它们是指标签**而不是位置**。******

该``.loc``属性是主要访问方法。以下是有效输入：

- 单个标签，例如``5``或``'a'``（注意，它``5``被解释为索引的*标签*。此用法**不是**索引的整数位置。）。
- 列表或标签数组。``['a', 'b', 'c']``
- 带有标签的切片对象``'a':'f'``（注意，与通常的python切片相反，**包括**起始和停止，当存在于索引中时！请参见[切片标签](#indexing-slicing-with-labels)。
- 布尔数组。
- A ``callable``，参见[按可调用选择](#indexing-callable)。

``` python
In [38]: s1 = pd.Series(np.random.randn(6), index=list('abcdef'))

In [39]: s1
Out[39]: 
a    1.431256
b    1.340309
c   -1.170299
d   -0.226169
e    0.410835
f    0.813850
dtype: float64

In [40]: s1.loc['c':]
Out[40]: 
c   -1.170299
d   -0.226169
e    0.410835
f    0.813850
dtype: float64

In [41]: s1.loc['b']
Out[41]: 1.3403088497993827
```

请注意，设置也适用：

``` python
In [42]: s1.loc['c':] = 0

In [43]: s1
Out[43]: 
a    1.431256
b    1.340309
c    0.000000
d    0.000000
e    0.000000
f    0.000000
dtype: float64
```

使用DataFrame：

``` python
In [44]: df1 = pd.DataFrame(np.random.randn(6, 4),
   ....:                    index=list('abcdef'),
   ....:                    columns=list('ABCD'))
   ....: 

In [45]: df1
Out[45]: 
          A         B         C         D
a  0.132003 -0.827317 -0.076467 -1.187678
b  1.130127 -1.436737 -1.413681  1.607920
c  1.024180  0.569605  0.875906 -2.211372
d  0.974466 -2.006747 -0.410001 -0.078638
e  0.545952 -1.219217 -1.226825  0.769804
f -1.281247 -0.727707 -0.121306 -0.097883

In [46]: df1.loc[['a', 'b', 'd'], :]
Out[46]: 
          A         B         C         D
a  0.132003 -0.827317 -0.076467 -1.187678
b  1.130127 -1.436737 -1.413681  1.607920
d  0.974466 -2.006747 -0.410001 -0.078638
```

通过标签切片访问：

``` python
In [47]: df1.loc['d':, 'A':'C']
Out[47]: 
          A         B         C
d  0.974466 -2.006747 -0.410001
e  0.545952 -1.219217 -1.226825
f -1.281247 -0.727707 -0.121306
```

使用标签获取横截面（相当于``df.xs('a')``）：

``` python
In [48]: df1.loc['a']
Out[48]: 
A    0.132003
B   -0.827317
C   -0.076467
D   -1.187678
Name: a, dtype: float64
```

要使用布尔数组获取值：

``` python
In [49]: df1.loc['a'] > 0
Out[49]: 
A     True
B    False
C    False
D    False
Name: a, dtype: bool

In [50]: df1.loc[:, df1.loc['a'] > 0]
Out[50]: 
          A
a  0.132003
b  1.130127
c  1.024180
d  0.974466
e  0.545952
f -1.281247
```

要明确获取值（相当于已弃用``df.get_value('a','A')``）：

``` python
# this is also equivalent to ``df1.at['a','A']``
In [51]: df1.loc['a', 'A']
Out[51]: 0.13200317033032932
```

### 用标签切片

使用``.loc``切片时，如果索引中存在开始和停止标签，则返回*位于*两者之间的元素（包括它们）：

``` python
In [52]: s = pd.Series(list('abcde'), index=[0, 3, 2, 5, 4])

In [53]: s.loc[3:5]
Out[53]: 
3    b
2    c
5    d
dtype: object
```

如果两个中至少有一个不存在，但索引已排序，并且可以与开始和停止标签进行比较，那么通过选择在两者之间*排名的*标签，切片仍将按预期工作：

``` python
In [54]: s.sort_index()
Out[54]: 
0    a
2    c
3    b
4    e
5    d
dtype: object

In [55]: s.sort_index().loc[1:6]
Out[55]: 
2    c
3    b
4    e
5    d
dtype: object
```

然而，如果两个中的至少一个不存在*并且*索引未被排序，则将引发错误（因为否则将是计算上昂贵的，并且对于混合类型索引可能是模糊的）。例如，在上面的例子中，``s.loc[1:6]``会提高``KeyError``。

有关此行为背后的基本原理，请参阅
 [端点包含](advanced.html#advanced-endpoints-are-inclusive)。

## 按位置选择

::: danger 警告

是否为设置操作返回副本或引用可能取决于上下文。这有时被称为应该避免。请参阅[返回视图与复制](#indexing-view-versus-copy)。``chained assignment``[](#indexing-view-versus-copy)

:::

Pandas提供了一套方法，以获得**纯粹基于整数的索引**。语义紧跟Python和NumPy切片。这些是``0-based``索引。切片时，所结合的开始被*包括*，而上限是*排除*。尝试使用非整数，甚至是**有效的**标签都会引发一个问题``IndexError``。

该``.iloc``属性是主要访问方法。以下是有效输入：

- 一个整数，例如``5``。
- 整数列表或数组。``[4, 3, 0]``
- 带有整数的切片对象``1:7``。
- 布尔数组。
- A ``callable``，参见[按可调用选择](#indexing-callable)。

``` python
In [56]: s1 = pd.Series(np.random.randn(5), index=list(range(0, 10, 2)))

In [57]: s1
Out[57]: 
0    0.695775
2    0.341734
4    0.959726
6   -1.110336
8   -0.619976
dtype: float64

In [58]: s1.iloc[:3]
Out[58]: 
0    0.695775
2    0.341734
4    0.959726
dtype: float64

In [59]: s1.iloc[3]
Out[59]: -1.110336102891167
```

请注意，设置也适用：

``` python
In [60]: s1.iloc[:3] = 0

In [61]: s1
Out[61]: 
0    0.000000
2    0.000000
4    0.000000
6   -1.110336
8   -0.619976
dtype: float64
```

使用DataFrame：

``` python
In [62]: df1 = pd.DataFrame(np.random.randn(6, 4),
   ....:                    index=list(range(0, 12, 2)),
   ....:                    columns=list(range(0, 8, 2)))
   ....: 

In [63]: df1
Out[63]: 
           0         2         4         6
0   0.149748 -0.732339  0.687738  0.176444
2   0.403310 -0.154951  0.301624 -2.179861
4  -1.369849 -0.954208  1.462696 -1.743161
6  -0.826591 -0.345352  1.314232  0.690579
8   0.995761  2.396780  0.014871  3.357427
10 -0.317441 -1.236269  0.896171 -0.487602
```

通过整数切片选择：

``` python
In [64]: df1.iloc[:3]
Out[64]: 
          0         2         4         6
0  0.149748 -0.732339  0.687738  0.176444
2  0.403310 -0.154951  0.301624 -2.179861
4 -1.369849 -0.954208  1.462696 -1.743161

In [65]: df1.iloc[1:5, 2:4]
Out[65]: 
          4         6
2  0.301624 -2.179861
4  1.462696 -1.743161
6  1.314232  0.690579
8  0.014871  3.357427
```

通过整数列表选择：

``` python
In [66]: df1.iloc[[1, 3, 5], [1, 3]]
Out[66]: 
           2         6
2  -0.154951 -2.179861
6  -0.345352  0.690579
10 -1.236269 -0.487602
```

``` python
In [67]: df1.iloc[1:3, :]
Out[67]: 
          0         2         4         6
2  0.403310 -0.154951  0.301624 -2.179861
4 -1.369849 -0.954208  1.462696 -1.743161
```

``` python
In [68]: df1.iloc[:, 1:3]
Out[68]: 
           2         4
0  -0.732339  0.687738
2  -0.154951  0.301624
4  -0.954208  1.462696
6  -0.345352  1.314232
8   2.396780  0.014871
10 -1.236269  0.896171
```

``` python
# this is also equivalent to ``df1.iat[1,1]``
In [69]: df1.iloc[1, 1]
Out[69]: -0.1549507744249032
```

使用整数位置（等效``df.xs(1)``）得到横截面：

``` python
In [70]: df1.iloc[1]
Out[70]: 
0    0.403310
2   -0.154951
4    0.301624
6   -2.179861
Name: 2, dtype: float64
```

超出范围的切片索引正如Python / Numpy中一样优雅地处理。

``` python
# these are allowed in python/numpy.
In [71]: x = list('abcdef')

In [72]: x
Out[72]: ['a', 'b', 'c', 'd', 'e', 'f']

In [73]: x[4:10]
Out[73]: ['e', 'f']

In [74]: x[8:10]
Out[74]: []

In [75]: s = pd.Series(x)

In [76]: s
Out[76]: 
0    a
1    b
2    c
3    d
4    e
5    f
dtype: object

In [77]: s.iloc[4:10]
Out[77]: 
4    e
5    f
dtype: object

In [78]: s.iloc[8:10]
Out[78]: Series([], dtype: object)
```

请注意，使用超出边界的切片可能会导致空轴（例如，返回一个空的DataFrame）。

``` python
In [79]: dfl = pd.DataFrame(np.random.randn(5, 2), columns=list('AB'))

In [80]: dfl
Out[80]: 
          A         B
0 -0.082240 -2.182937
1  0.380396  0.084844
2  0.432390  1.519970
3 -0.493662  0.600178
4  0.274230  0.132885

In [81]: dfl.iloc[:, 2:3]
Out[81]: 
Empty DataFrame
Columns: []
Index: [0, 1, 2, 3, 4]

In [82]: dfl.iloc[:, 1:3]
Out[82]: 
          B
0 -2.182937
1  0.084844
2  1.519970
3  0.600178
4  0.132885

In [83]: dfl.iloc[4:6]
Out[83]: 
         A         B
4  0.27423  0.132885
```

一个超出范围的索引器会引发一个``IndexError``。任何元素超出范围的索引器列表都会引发
 ``IndexError``。

``` python
>>> dfl.iloc[[4, 5, 6]]
IndexError: positional indexers are out-of-bounds

>>> dfl.iloc[:, 4]
IndexError: single positional indexer is out-of-bounds
```

## 通过可调用选择

*版本0.18.1中的新功能。* 

``.loc``，``.iloc``以及``[]``索引也可以接受一个``callable``索引器。在``callable``必须与一个参数（调用系列或数据帧）返回的有效输出索引功能。

``` python
In [84]: df1 = pd.DataFrame(np.random.randn(6, 4),
   ....:                    index=list('abcdef'),
   ....:                    columns=list('ABCD'))
   ....: 

In [85]: df1
Out[85]: 
          A         B         C         D
a -0.023688  2.410179  1.450520  0.206053
b -0.251905 -2.213588  1.063327  1.266143
c  0.299368 -0.863838  0.408204 -1.048089
d -0.025747 -0.988387  0.094055  1.262731
e  1.289997  0.082423 -0.055758  0.536580
f -0.489682  0.369374 -0.034571 -2.484478

In [86]: df1.loc[lambda df: df.A > 0, :]
Out[86]: 
          A         B         C         D
c  0.299368 -0.863838  0.408204 -1.048089
e  1.289997  0.082423 -0.055758  0.536580

In [87]: df1.loc[:, lambda df: ['A', 'B']]
Out[87]: 
          A         B
a -0.023688  2.410179
b -0.251905 -2.213588
c  0.299368 -0.863838
d -0.025747 -0.988387
e  1.289997  0.082423
f -0.489682  0.369374

In [88]: df1.iloc[:, lambda df: [0, 1]]
Out[88]: 
          A         B
a -0.023688  2.410179
b -0.251905 -2.213588
c  0.299368 -0.863838
d -0.025747 -0.988387
e  1.289997  0.082423
f -0.489682  0.369374

In [89]: df1[lambda df: df.columns[0]]
Out[89]: 
a   -0.023688
b   -0.251905
c    0.299368
d   -0.025747
e    1.289997
f   -0.489682
Name: A, dtype: float64
```

您可以使用可调用索引``Series``。

``` python
In [90]: df1.A.loc[lambda s: s > 0]
Out[90]: 
c    0.299368
e    1.289997
Name: A, dtype: float64
```

使用这些方法/索引器，您可以在不使用临时变量的情况下链接数据选择操作。

``` python
In [91]: bb = pd.read_csv('data/baseball.csv', index_col='id')

In [92]: (bb.groupby(['year', 'team']).sum()
   ....:    .loc[lambda df: df.r > 100])
   ....: 
Out[92]: 
           stint    g    ab    r    h  X2b  X3b  hr    rbi    sb   cs   bb     so   ibb   hbp    sh    sf  gidp
year team                                                                                                      
2007 CIN       6  379   745  101  203   35    2  36  125.0  10.0  1.0  105  127.0  14.0   1.0   1.0  15.0  18.0
     DET       5  301  1062  162  283   54    4  37  144.0  24.0  7.0   97  176.0   3.0  10.0   4.0   8.0  28.0
     HOU       4  311   926  109  218   47    6  14   77.0  10.0  4.0   60  212.0   3.0   9.0  16.0   6.0  17.0
     LAN      11  413  1021  153  293   61    3  36  154.0   7.0  5.0  114  141.0   8.0   9.0   3.0   8.0  29.0
     NYN      13  622  1854  240  509  101    3  61  243.0  22.0  4.0  174  310.0  24.0  23.0  18.0  15.0  48.0
     SFN       5  482  1305  198  337   67    6  40  171.0  26.0  7.0  235  188.0  51.0   8.0  16.0   6.0  41.0
     TEX       2  198   729  115  200   40    4  28  115.0  21.0  4.0   73  140.0   4.0   5.0   2.0   8.0  16.0
     TOR       4  459  1408  187  378   96    2  58  223.0   4.0  2.0  190  265.0  16.0  12.0   4.0  16.0  38.0
```

## 不推荐使用IX索引器

::: danger 警告

在0.20.0开始，``.ix``索引器已被弃用，赞成更加严格``.iloc``
和``.loc``索引。

:::

``.ix``在推断用户想要做的事情上提供了很多魔力。也就是说，``.ix``可以根据索引的数据类型决定按*位置*或通过*标签*进行索引。多年来，这引起了相当多的用户混淆。

建议的索引方法是：

- ``.loc``如果你想*标记*索引。
- ``.iloc``如果你想要*定位*索引。

``` python
In [93]: dfd = pd.DataFrame({'A': [1, 2, 3],
   ....:                     'B': [4, 5, 6]},
   ....:                    index=list('abc'))
   ....: 

In [94]: dfd
Out[94]: 
   A  B
a  1  4
b  2  5
c  3  6
```

以前的行为，您希望从“A”列中获取索引中的第0个和第2个元素。

``` python
In [3]: dfd.ix[[0, 2], 'A']
Out[3]:
a    1
c    3
Name: A, dtype: int64
```

用``.loc``。这里我们将从索引中选择适当的索引，然后使用*标签*索引。

``` python
In [95]: dfd.loc[dfd.index[[0, 2]], 'A']
Out[95]: 
a    1
c    3
Name: A, dtype: int64
```

这也可以``.iloc``通过在索引器上显式获取位置，并使用
 *位置*索引来选择事物来表达。

``` python
In [96]: dfd.iloc[[0, 2], dfd.columns.get_loc('A')]
Out[96]: 
a    1
c    3
Name: A, dtype: int64
```

要获得*多个*索引器，请使用``.get_indexer``：

``` python
In [97]: dfd.iloc[[0, 2], dfd.columns.get_indexer(['A', 'B'])]
Out[97]: 
   A  B
a  1  4
c  3  6
```

## 不推荐使用缺少标签的列表进行索引

::: danger 警告

从0.21.0开始，使用``.loc``或``[]``包含一个或多个缺少标签的列表，不赞成使用``.reindex``。

:::

在以前的版本中，``.loc[list-of-labels]``只要找到*至少1*个密钥，使用就可以工作（否则会引起a ``KeyError``）。不推荐使用此行为，并将显示指向此部分的警告消息。推荐的替代方案是使用``.reindex()``。

例如。

``` python
In [98]: s = pd.Series([1, 2, 3])

In [99]: s
Out[99]: 
0    1
1    2
2    3
dtype: int64
```

找到所有键的选择保持不变。

``` python
In [100]: s.loc[[1, 2]]
Out[100]: 
1    2
2    3
dtype: int64
```

以前的行为

``` python
In [4]: s.loc[[1, 2, 3]]
Out[4]:
1    2.0
2    3.0
3    NaN
dtype: float64
```

目前的行为

``` python
In [4]: s.loc[[1, 2, 3]]
Passing list-likes to .loc with any non-matching elements will raise
KeyError in the future, you can use .reindex() as an alternative.

See the documentation here:
http://pandas.pydata.org/pandas-docs/stable/indexing.html#deprecate-loc-reindex-listlike

Out[4]:
1    2.0
2    3.0
3    NaN
dtype: float64
```

### 重新索引

实现选择潜在的未找到元素的惯用方法是通过``.reindex()``。另请参阅[重建索引](https://pandas.pydata.org/pandas-docs/stable/getting_started/basics.html#basics-reindexing)部分。

``` python
In [101]: s.reindex([1, 2, 3])
Out[101]: 
1    2.0
2    3.0
3    NaN
dtype: float64
```

或者，如果您只想选择*有效的*密钥，则以下是惯用且有效的; 保证保留选择的dtype。

``` python
In [102]: labels = [1, 2, 3]

In [103]: s.loc[s.index.intersection(labels)]
Out[103]: 
1    2
2    3
dtype: int64
```

拥有重复索引会引发``.reindex()``：

``` python
In [104]: s = pd.Series(np.arange(4), index=['a', 'a', 'b', 'c'])

In [105]: labels = ['c', 'd']
```

``` python
In [17]: s.reindex(labels)
ValueError: cannot reindex from a duplicate axis
```

通常，您可以将所需标签与当前轴相交，然后重新索引。

``` python
In [106]: s.loc[s.index.intersection(labels)].reindex(labels)
Out[106]: 
c    3.0
d    NaN
dtype: float64
```

但是，如果生成的索引重复，这*仍然会*提高。

``` python
In [41]: labels = ['a', 'd']

In [42]: s.loc[s.index.intersection(labels)].reindex(labels)
ValueError: cannot reindex from a duplicate axis
```

## 选择随机样本

使用该[``sample()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.sample.html#pandas.DataFrame.sample)方法随机选择Series或DataFrame中的行或列。默认情况下，该方法将对行进行采样，并接受要返回的特定行数/列数或一小部分行。

``` python
In [107]: s = pd.Series([0, 1, 2, 3, 4, 5])

# When no arguments are passed, returns 1 row.
In [108]: s.sample()
Out[108]: 
4    4
dtype: int64

# One may specify either a number of rows:
In [109]: s.sample(n=3)
Out[109]: 
0    0
4    4
1    1
dtype: int64

# Or a fraction of the rows:
In [110]: s.sample(frac=0.5)
Out[110]: 
5    5
3    3
1    1
dtype: int64
```

默认情况下，``sample``最多会返回每行一次，但也可以使用以下``replace``选项进行替换：

``` python
In [111]: s = pd.Series([0, 1, 2, 3, 4, 5])

# Without replacement (default):
In [112]: s.sample(n=6, replace=False)
Out[112]: 
0    0
1    1
5    5
3    3
2    2
4    4
dtype: int64

# With replacement:
In [113]: s.sample(n=6, replace=True)
Out[113]: 
0    0
4    4
3    3
2    2
4    4
4    4
dtype: int64
```

默认情况下，每行具有相同的选择概率，但如果您希望行具有不同的概率，则可以将``sample``函数采样权重作为
 ``weights``。这些权重可以是列表，NumPy数组或系列，但它们的长度必须与您采样的对象的长度相同。缺失的值将被视为零的权重，并且不允许使用inf值。如果权重不总和为1，则通过将所有权重除以权重之和来对它们进行重新规范化。例如：

``` python
In [114]: s = pd.Series([0, 1, 2, 3, 4, 5])

In [115]: example_weights = [0, 0, 0.2, 0.2, 0.2, 0.4]

In [116]: s.sample(n=3, weights=example_weights)
Out[116]: 
5    5
4    4
3    3
dtype: int64

# Weights will be re-normalized automatically
In [117]: example_weights2 = [0.5, 0, 0, 0, 0, 0]

In [118]: s.sample(n=1, weights=example_weights2)
Out[118]: 
0    0
dtype: int64
```

应用于DataFrame时，只需将列的名称作为字符串传递，就可以使用DataFrame的列作为采样权重（假设您要对行而不是列进行采样）。

``` python
In [119]: df2 = pd.DataFrame({'col1': [9, 8, 7, 6],
   .....:                     'weight_column': [0.5, 0.4, 0.1, 0]})
   .....: 

In [120]: df2.sample(n=3, weights='weight_column')
Out[120]: 
   col1  weight_column
1     8            0.4
0     9            0.5
2     7            0.1
```

``sample``还允许用户使用``axis``参数对列而不是行进行采样。

``` python
In [121]: df3 = pd.DataFrame({'col1': [1, 2, 3], 'col2': [2, 3, 4]})

In [122]: df3.sample(n=1, axis=1)
Out[122]: 
   col1
0     1
1     2
2     3
```

最后，还可以``sample``使用``random_state``参数为随机数生成器设置种子，该参数将接受整数（作为种子）或NumPy RandomState对象。

``` python
In [123]: df4 = pd.DataFrame({'col1': [1, 2, 3], 'col2': [2, 3, 4]})

# With a given seed, the sample will always draw the same rows.
In [124]: df4.sample(n=2, random_state=2)
Out[124]: 
   col1  col2
2     3     4
1     2     3

In [125]: df4.sample(n=2, random_state=2)
Out[125]: 
   col1  col2
2     3     4
1     2     3
```

## 用放大设定

``.loc/[]``当为该轴设置不存在的键时，操作可以执行放大。

在这种``Series``情况下，这实际上是一种附加操作。

``` python
In [126]: se = pd.Series([1, 2, 3])

In [127]: se
Out[127]: 
0    1
1    2
2    3
dtype: int64

In [128]: se[5] = 5.

In [129]: se
Out[129]: 
0    1.0
1    2.0
2    3.0
5    5.0
dtype: float64
```

A ``DataFrame``可以在任一轴上放大``.loc``。

``` python
In [130]: dfi = pd.DataFrame(np.arange(6).reshape(3, 2),
   .....:                    columns=['A', 'B'])
   .....: 

In [131]: dfi
Out[131]: 
   A  B
0  0  1
1  2  3
2  4  5

In [132]: dfi.loc[:, 'C'] = dfi.loc[:, 'A']

In [133]: dfi
Out[133]: 
   A  B  C
0  0  1  0
1  2  3  2
2  4  5  4
```

这就像是一个``append``操作``DataFrame``。

``` python
In [134]: dfi.loc[3] = 5

In [135]: dfi
Out[135]: 
   A  B  C
0  0  1  0
1  2  3  2
2  4  5  4
3  5  5  5
```

## 快速标量值获取和设置

因为索引``[]``必须处理很多情况（单标签访问，切片，布尔索引等），所以它有一些开销以便弄清楚你要求的是什么。如果您只想访问标量值，最快的方法是使用在所有数据结构上实现的``at``和``iat``方法。

与之类似``loc``，``at``提供基于**标签**的标量查找，同时``iat``提供类似于基于**整数**的查找``iloc``

``` python
In [136]: s.iat[5]
Out[136]: 5

In [137]: df.at[dates[5], 'A']
Out[137]: -0.6736897080883706

In [138]: df.iat[3, 0]
Out[138]: 0.7215551622443669
```

您也可以使用这些相同的索引器进行设置。

``` python
In [139]: df.at[dates[5], 'E'] = 7

In [140]: df.iat[3, 0] = 7
```

``at`` 如果索引器丢失，可以如上所述放大对象。

``` python
In [141]: df.at[dates[-1] + pd.Timedelta('1 day'), 0] = 7

In [142]: df
Out[142]: 
                   A         B         C         D    E    0
2000-01-01  0.469112 -0.282863 -1.509059 -1.135632  NaN  NaN
2000-01-02  1.212112 -0.173215  0.119209 -1.044236  NaN  NaN
2000-01-03 -0.861849 -2.104569 -0.494929  1.071804  NaN  NaN
2000-01-04  7.000000 -0.706771 -1.039575  0.271860  NaN  NaN
2000-01-05 -0.424972  0.567020  0.276232 -1.087401  NaN  NaN
2000-01-06 -0.673690  0.113648 -1.478427  0.524988  7.0  NaN
2000-01-07  0.404705  0.577046 -1.715002 -1.039268  NaN  NaN
2000-01-08 -0.370647 -1.157892 -1.344312  0.844885  NaN  NaN
2000-01-09       NaN       NaN       NaN       NaN  NaN  7.0
```

## 布尔索引

另一种常见操作是使用布尔向量来过滤数据。运营商是：``|``for ``or``，``&``for ``and``和``~``for ``not``。**必须**使用括号对这些进行分组，因为默认情况下，Python将评估表达式，例如as
 ，而期望的评估顺序是
 。``df.A > 2 & df.B < 3````df.A > (2 & df.B) < 3````(df.A > 2) & (df.B < 3)``

使用布尔向量索引系列的工作方式与NumPy ndarray完全相同：

``` python
In [143]: s = pd.Series(range(-3, 4))

In [144]: s
Out[144]: 
0   -3
1   -2
2   -1
3    0
4    1
5    2
6    3
dtype: int64

In [145]: s[s > 0]
Out[145]: 
4    1
5    2
6    3
dtype: int64

In [146]: s[(s < -1) | (s > 0.5)]
Out[146]: 
0   -3
1   -2
4    1
5    2
6    3
dtype: int64

In [147]: s[~(s < 0)]
Out[147]: 
3    0
4    1
5    2
6    3
dtype: int64
```

您可以使用与DataFrame索引长度相同的布尔向量从DataFrame中选择行（例如，从DataFrame的其中一列派生的东西）：

``` python
In [148]: df[df['A'] > 0]
Out[148]: 
                   A         B         C         D   E   0
2000-01-01  0.469112 -0.282863 -1.509059 -1.135632 NaN NaN
2000-01-02  1.212112 -0.173215  0.119209 -1.044236 NaN NaN
2000-01-04  7.000000 -0.706771 -1.039575  0.271860 NaN NaN
2000-01-07  0.404705  0.577046 -1.715002 -1.039268 NaN NaN
```

列表推导和``map``系列方法也可用于产生更复杂的标准：

``` python
In [149]: df2 = pd.DataFrame({'a': ['one', 'one', 'two', 'three', 'two', 'one', 'six'],
   .....:                     'b': ['x', 'y', 'y', 'x', 'y', 'x', 'x'],
   .....:                     'c': np.random.randn(7)})
   .....: 

# only want 'two' or 'three'
In [150]: criterion = df2['a'].map(lambda x: x.startswith('t'))

In [151]: df2[criterion]
Out[151]: 
       a  b         c
2    two  y  0.041290
3  three  x  0.361719
4    two  y -0.238075

# equivalent but slower
In [152]: df2[[x.startswith('t') for x in df2['a']]]
Out[152]: 
       a  b         c
2    two  y  0.041290
3  three  x  0.361719
4    two  y -0.238075

# Multiple criteria
In [153]: df2[criterion & (df2['b'] == 'x')]
Out[153]: 
       a  b         c
3  three  x  0.361719
```

随着选择方法[通过标签选择](#indexing-label)，[通过位置选择](#indexing-integer)和[高级索引](advanced.html#advanced)，你可以沿着使用布尔向量与其他索引表达式中组合选择多个轴。

``` python
In [154]: df2.loc[criterion & (df2['b'] == 'x'), 'b':'c']
Out[154]: 
   b         c
3  x  0.361719
```

## 使用isin进行索引

考虑一下[``isin()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.isin.html#pandas.Series.isin)方法``Series``，该方法返回一个布尔向量，只要``Series``元素存在于传递列表中，该向量就为真。这允许您选择一列或多列具有所需值的行：

``` python
In [155]: s = pd.Series(np.arange(5), index=np.arange(5)[::-1], dtype='int64')

In [156]: s
Out[156]: 
4    0
3    1
2    2
1    3
0    4
dtype: int64

In [157]: s.isin([2, 4, 6])
Out[157]: 
4    False
3    False
2     True
1    False
0     True
dtype: bool

In [158]: s[s.isin([2, 4, 6])]
Out[158]: 
2    2
0    4
dtype: int64
```

``Index``对象可以使用相同的方法，当您不知道哪些搜索标签实际存在时，它们非常有用：

``` python
In [159]: s[s.index.isin([2, 4, 6])]
Out[159]: 
4    0
2    2
dtype: int64

# compare it to the following
In [160]: s.reindex([2, 4, 6])
Out[160]: 
2    2.0
4    0.0
6    NaN
dtype: float64
```

除此之外，还``MultiIndex``允许选择在成员资格检查中使用的单独级别：

``` python
In [161]: s_mi = pd.Series(np.arange(6),
   .....:                  index=pd.MultiIndex.from_product([[0, 1], ['a', 'b', 'c']]))
   .....: 

In [162]: s_mi
Out[162]: 
0  a    0
   b    1
   c    2
1  a    3
   b    4
   c    5
dtype: int64

In [163]: s_mi.iloc[s_mi.index.isin([(1, 'a'), (2, 'b'), (0, 'c')])]
Out[163]: 
0  c    2
1  a    3
dtype: int64

In [164]: s_mi.iloc[s_mi.index.isin(['a', 'c', 'e'], level=1)]
Out[164]: 
0  a    0
   c    2
1  a    3
   c    5
dtype: int64
```

DataFrame也有一个[``isin()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.isin.html#pandas.DataFrame.isin)方法。调用时``isin``，将一组值作为数组或字典传递。如果values是一个数组，则``isin``返回与原始DataFrame形状相同的布尔数据框，并在元素序列中的任何位置使用True。

``` python
In [165]: df = pd.DataFrame({'vals': [1, 2, 3, 4], 'ids': ['a', 'b', 'f', 'n'],
   .....:                    'ids2': ['a', 'n', 'c', 'n']})
   .....: 

In [166]: values = ['a', 'b', 1, 3]

In [167]: df.isin(values)
Out[167]: 
    vals    ids   ids2
0   True   True   True
1  False   True  False
2   True  False  False
3  False  False  False
```

通常，您需要将某些值与某些列匹配。只需将值设置``dict``为键为列的位置，值即为要检查的项目列表。

``` python
In [168]: values = {'ids': ['a', 'b'], 'vals': [1, 3]}

In [169]: df.isin(values)
Out[169]: 
    vals    ids   ids2
0   True   True  False
1  False   True  False
2   True  False  False
3  False  False  False
```

结合数据帧的``isin``同``any()``和``all()``方法来快速选择符合给定的标准对数据子集。要选择每列符合其自己标准的行：

``` python
In [170]: values = {'ids': ['a', 'b'], 'ids2': ['a', 'c'], 'vals': [1, 3]}

In [171]: row_mask = df.isin(values).all(1)

In [172]: df[row_mask]
Out[172]: 
   vals ids ids2
0     1   a    a
```

## 该``where()``方法和屏蔽

从具有布尔向量的Series中选择值通常会返回数据的子集。为了保证选择输出与原始数据具有相同的形状，您可以``where``在``Series``和中使用该方法``DataFrame``。

仅返回选定的行：

``` python
In [173]: s[s > 0]
Out[173]: 
3    1
2    2
1    3
0    4
dtype: int64
```

要返回与原始形状相同的系列：

``` python
In [174]: s.where(s > 0)
Out[174]: 
4    NaN
3    1.0
2    2.0
1    3.0
0    4.0
dtype: float64
```

现在，使用布尔标准从DataFrame中选择值也可以保留输入数据形状。``where``在引擎盖下用作实现。下面的代码相当于。``df.where(df < 0)``

``` python
In [175]: df[df < 0]
Out[175]: 
                   A         B         C         D
2000-01-01 -2.104139 -1.309525       NaN       NaN
2000-01-02 -0.352480       NaN -1.192319       NaN
2000-01-03 -0.864883       NaN -0.227870       NaN
2000-01-04       NaN -1.222082       NaN -1.233203
2000-01-05       NaN -0.605656 -1.169184       NaN
2000-01-06       NaN -0.948458       NaN -0.684718
2000-01-07 -2.670153 -0.114722       NaN -0.048048
2000-01-08       NaN       NaN -0.048788 -0.808838
```

此外，在返回的副本中，``where``使用可选``other``参数替换条件为False的值。

``` python
In [176]: df.where(df < 0, -df)
Out[176]: 
                   A         B         C         D
2000-01-01 -2.104139 -1.309525 -0.485855 -0.245166
2000-01-02 -0.352480 -0.390389 -1.192319 -1.655824
2000-01-03 -0.864883 -0.299674 -0.227870 -0.281059
2000-01-04 -0.846958 -1.222082 -0.600705 -1.233203
2000-01-05 -0.669692 -0.605656 -1.169184 -0.342416
2000-01-06 -0.868584 -0.948458 -2.297780 -0.684718
2000-01-07 -2.670153 -0.114722 -0.168904 -0.048048
2000-01-08 -0.801196 -1.392071 -0.048788 -0.808838
```

您可能希望根据某些布尔条件设置值。这可以直观地完成，如下所示：

``` python
In [177]: s2 = s.copy()

In [178]: s2[s2 < 0] = 0

In [179]: s2
Out[179]: 
4    0
3    1
2    2
1    3
0    4
dtype: int64

In [180]: df2 = df.copy()

In [181]: df2[df2 < 0] = 0

In [182]: df2
Out[182]: 
                   A         B         C         D
2000-01-01  0.000000  0.000000  0.485855  0.245166
2000-01-02  0.000000  0.390389  0.000000  1.655824
2000-01-03  0.000000  0.299674  0.000000  0.281059
2000-01-04  0.846958  0.000000  0.600705  0.000000
2000-01-05  0.669692  0.000000  0.000000  0.342416
2000-01-06  0.868584  0.000000  2.297780  0.000000
2000-01-07  0.000000  0.000000  0.168904  0.000000
2000-01-08  0.801196  1.392071  0.000000  0.000000
```

默认情况下，``where``返回数据的修改副本。有一个可选参数，``inplace``以便可以在不创建副本的情况下修改原始数据：

``` python
In [183]: df_orig = df.copy()

In [184]: df_orig.where(df > 0, -df, inplace=True)

In [185]: df_orig
Out[185]: 
                   A         B         C         D
2000-01-01  2.104139  1.309525  0.485855  0.245166
2000-01-02  0.352480  0.390389  1.192319  1.655824
2000-01-03  0.864883  0.299674  0.227870  0.281059
2000-01-04  0.846958  1.222082  0.600705  1.233203
2000-01-05  0.669692  0.605656  1.169184  0.342416
2000-01-06  0.868584  0.948458  2.297780  0.684718
2000-01-07  2.670153  0.114722  0.168904  0.048048
2000-01-08  0.801196  1.392071  0.048788  0.808838
```

::: tip 注意

签名[``DataFrame.where()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.where.html#pandas.DataFrame.where)不同于[``numpy.where()``](https://docs.scipy.org/doc/numpy/reference/generated/numpy.where.html#numpy.where)。大致相当于。``df1.where(m, df2)````np.where(m, df1, df2)``

``` python
In [186]: df.where(df < 0, -df) == np.where(df < 0, df, -df)
Out[186]: 
               A     B     C     D
2000-01-01  True  True  True  True
2000-01-02  True  True  True  True
2000-01-03  True  True  True  True
2000-01-04  True  True  True  True
2000-01-05  True  True  True  True
2000-01-06  True  True  True  True
2000-01-07  True  True  True  True
2000-01-08  True  True  True  True
```

:::

**对准**

此外，``where``对齐输入布尔条件（ndarray或DataFrame），以便可以使用设置进行部分选择。这类似于部分设置通过``.loc``（但是在内容而不是轴标签上）。

``` python
In [187]: df2 = df.copy()

In [188]: df2[df2[1:4] > 0] = 3

In [189]: df2
Out[189]: 
                   A         B         C         D
2000-01-01 -2.104139 -1.309525  0.485855  0.245166
2000-01-02 -0.352480  3.000000 -1.192319  3.000000
2000-01-03 -0.864883  3.000000 -0.227870  3.000000
2000-01-04  3.000000 -1.222082  3.000000 -1.233203
2000-01-05  0.669692 -0.605656 -1.169184  0.342416
2000-01-06  0.868584 -0.948458  2.297780 -0.684718
2000-01-07 -2.670153 -0.114722  0.168904 -0.048048
2000-01-08  0.801196  1.392071 -0.048788 -0.808838
```

哪里也可以接受``axis``和``level``参数在执行时对齐输入``where``。

``` python
In [190]: df2 = df.copy()

In [191]: df2.where(df2 > 0, df2['A'], axis='index')
Out[191]: 
                   A         B         C         D
2000-01-01 -2.104139 -2.104139  0.485855  0.245166
2000-01-02 -0.352480  0.390389 -0.352480  1.655824
2000-01-03 -0.864883  0.299674 -0.864883  0.281059
2000-01-04  0.846958  0.846958  0.600705  0.846958
2000-01-05  0.669692  0.669692  0.669692  0.342416
2000-01-06  0.868584  0.868584  2.297780  0.868584
2000-01-07 -2.670153 -2.670153  0.168904 -2.670153
2000-01-08  0.801196  1.392071  0.801196  0.801196
```

这相当于（但快于）以下内容。

``` python
In [192]: df2 = df.copy()

In [193]: df.apply(lambda x, y: x.where(x > 0, y), y=df['A'])
Out[193]: 
                   A         B         C         D
2000-01-01 -2.104139 -2.104139  0.485855  0.245166
2000-01-02 -0.352480  0.390389 -0.352480  1.655824
2000-01-03 -0.864883  0.299674 -0.864883  0.281059
2000-01-04  0.846958  0.846958  0.600705  0.846958
2000-01-05  0.669692  0.669692  0.669692  0.342416
2000-01-06  0.868584  0.868584  2.297780  0.868584
2000-01-07 -2.670153 -2.670153  0.168904 -2.670153
2000-01-08  0.801196  1.392071  0.801196  0.801196
```

*版本0.18.1中的新功能。* 

哪里可以接受一个可调用的条件和``other``参数。该函数必须带有一个参数（调用Series或DataFrame），并返回有效的输出作为条件和``other``参数。

``` python
In [194]: df3 = pd.DataFrame({'A': [1, 2, 3],
   .....:                     'B': [4, 5, 6],
   .....:                     'C': [7, 8, 9]})
   .....: 

In [195]: df3.where(lambda x: x > 4, lambda x: x + 10)
Out[195]: 
    A   B  C
0  11  14  7
1  12   5  8
2  13   6  9
```

### 面具

[``mask()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.mask.html#pandas.DataFrame.mask)是的反布尔运算``where``。

``` python
In [196]: s.mask(s >= 0)
Out[196]: 
4   NaN
3   NaN
2   NaN
1   NaN
0   NaN
dtype: float64

In [197]: df.mask(df >= 0)
Out[197]: 
                   A         B         C         D
2000-01-01 -2.104139 -1.309525       NaN       NaN
2000-01-02 -0.352480       NaN -1.192319       NaN
2000-01-03 -0.864883       NaN -0.227870       NaN
2000-01-04       NaN -1.222082       NaN -1.233203
2000-01-05       NaN -0.605656 -1.169184       NaN
2000-01-06       NaN -0.948458       NaN -0.684718
2000-01-07 -2.670153 -0.114722       NaN -0.048048
2000-01-08       NaN       NaN -0.048788 -0.808838
```

## 该``query()``方法

[``DataFrame``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html#pandas.DataFrame)对象有一个[``query()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.query.html#pandas.DataFrame.query)
允许使用表达式进行选择的方法。

您可以获取列的值，其中列``b``具有列值``a``和值之间的值``c``。例如：

``` python
In [198]: n = 10

In [199]: df = pd.DataFrame(np.random.rand(n, 3), columns=list('abc'))

In [200]: df
Out[200]: 
          a         b         c
0  0.438921  0.118680  0.863670
1  0.138138  0.577363  0.686602
2  0.595307  0.564592  0.520630
3  0.913052  0.926075  0.616184
4  0.078718  0.854477  0.898725
5  0.076404  0.523211  0.591538
6  0.792342  0.216974  0.564056
7  0.397890  0.454131  0.915716
8  0.074315  0.437913  0.019794
9  0.559209  0.502065  0.026437

# pure python
In [201]: df[(df.a < df.b) & (df.b < df.c)]
Out[201]: 
          a         b         c
1  0.138138  0.577363  0.686602
4  0.078718  0.854477  0.898725
5  0.076404  0.523211  0.591538
7  0.397890  0.454131  0.915716

# query
In [202]: df.query('(a < b) & (b < c)')
Out[202]: 
          a         b         c
1  0.138138  0.577363  0.686602
4  0.078718  0.854477  0.898725
5  0.076404  0.523211  0.591538
7  0.397890  0.454131  0.915716
```

如果没有名称的列，则执行相同的操作但返回命名索引``a``。

``` python
In [203]: df = pd.DataFrame(np.random.randint(n / 2, size=(n, 2)), columns=list('bc'))

In [204]: df.index.name = 'a'

In [205]: df
Out[205]: 
   b  c
a      
0  0  4
1  0  1
2  3  4
3  4  3
4  1  4
5  0  3
6  0  1
7  3  4
8  2  3
9  1  1

In [206]: df.query('a < b and b < c')
Out[206]: 
   b  c
a      
2  3  4
```

如果您不希望或不能命名索引，则可以``index``在查询表达式中使用该名称
 ：

``` python
In [207]: df = pd.DataFrame(np.random.randint(n, size=(n, 2)), columns=list('bc'))

In [208]: df
Out[208]: 
   b  c
0  3  1
1  3  0
2  5  6
3  5  2
4  7  4
5  0  1
6  2  5
7  0  1
8  6  0
9  7  9

In [209]: df.query('index < b < c')
Out[209]: 
   b  c
2  5  6
```

::: tip 注意

如果索引的名称与列名称重叠，则列名称优先。例如，

``` python
In [210]: df = pd.DataFrame({'a': np.random.randint(5, size=5)})

In [211]: df.index.name = 'a'

In [212]: df.query('a > 2')  # uses the column 'a', not the index
Out[212]: 
   a
a   
1  3
3  3
```

您仍然可以使用特殊标识符'index'在查询表达式中使用索引：

``` python
In [213]: df.query('index > 2')
Out[213]: 
   a
a   
3  3
4  2
```

如果由于某种原因你有一个名为列的列``index``，那么你也可以引用索引``ilevel_0``，但是此时你应该考虑将列重命名为不那么模糊的列。

:::

### ``MultiIndex`` ``query()``语法

您还可以使用的水平``DataFrame``带
 [``MultiIndex``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.html#pandas.MultiIndex)，好像他们是在框架柱：

``` python
In [214]: n = 10

In [215]: colors = np.random.choice(['red', 'green'], size=n)

In [216]: foods = np.random.choice(['eggs', 'ham'], size=n)

In [217]: colors
Out[217]: 
array(['red', 'red', 'red', 'green', 'green', 'green', 'green', 'green',
       'green', 'green'], dtype='<U5')

In [218]: foods
Out[218]: 
array(['ham', 'ham', 'eggs', 'eggs', 'eggs', 'ham', 'ham', 'eggs', 'eggs',
       'eggs'], dtype='<U4')

In [219]: index = pd.MultiIndex.from_arrays([colors, foods], names=['color', 'food'])

In [220]: df = pd.DataFrame(np.random.randn(n, 2), index=index)

In [221]: df
Out[221]: 
                   0         1
color food                    
red   ham   0.194889 -0.381994
      ham   0.318587  2.089075
      eggs -0.728293 -0.090255
green eggs -0.748199  1.318931
      eggs -2.029766  0.792652
      ham   0.461007 -0.542749
      ham  -0.305384 -0.479195
      eggs  0.095031 -0.270099
      eggs -0.707140 -0.773882
      eggs  0.229453  0.304418

In [222]: df.query('color == "red"')
Out[222]: 
                   0         1
color food                    
red   ham   0.194889 -0.381994
      ham   0.318587  2.089075
      eggs -0.728293 -0.090255
```

如果``MultiIndex``未命名的级别，您可以使用特殊名称引用它们：

``` python
In [223]: df.index.names = [None, None]

In [224]: df
Out[224]: 
                   0         1
red   ham   0.194889 -0.381994
      ham   0.318587  2.089075
      eggs -0.728293 -0.090255
green eggs -0.748199  1.318931
      eggs -2.029766  0.792652
      ham   0.461007 -0.542749
      ham  -0.305384 -0.479195
      eggs  0.095031 -0.270099
      eggs -0.707140 -0.773882
      eggs  0.229453  0.304418

In [225]: df.query('ilevel_0 == "red"')
Out[225]: 
                 0         1
red ham   0.194889 -0.381994
    ham   0.318587  2.089075
    eggs -0.728293 -0.090255
```

约定是``ilevel_0``，这意味着第0级的“索引级别0” ``index``。

### ``query()``用例

用例[``query()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.query.html#pandas.DataFrame.query)是当您拥有一组具有共同
 [``DataFrame``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html#pandas.DataFrame)列名（或索引级别/名称）子集的对象时。您可以将相同的查询传递给两个帧，*而* 
无需指定您对查询感兴趣的帧

``` python
In [226]: df = pd.DataFrame(np.random.rand(n, 3), columns=list('abc'))

In [227]: df
Out[227]: 
          a         b         c
0  0.224283  0.736107  0.139168
1  0.302827  0.657803  0.713897
2  0.611185  0.136624  0.984960
3  0.195246  0.123436  0.627712
4  0.618673  0.371660  0.047902
5  0.480088  0.062993  0.185760
6  0.568018  0.483467  0.445289
7  0.309040  0.274580  0.587101
8  0.258993  0.477769  0.370255
9  0.550459  0.840870  0.304611

In [228]: df2 = pd.DataFrame(np.random.rand(n + 2, 3), columns=df.columns)

In [229]: df2
Out[229]: 
           a         b         c
0   0.357579  0.229800  0.596001
1   0.309059  0.957923  0.965663
2   0.123102  0.336914  0.318616
3   0.526506  0.323321  0.860813
4   0.518736  0.486514  0.384724
5   0.190804  0.505723  0.614533
6   0.891939  0.623977  0.676639
7   0.480559  0.378528  0.460858
8   0.420223  0.136404  0.141295
9   0.732206  0.419540  0.604675
10  0.604466  0.848974  0.896165
11  0.589168  0.920046  0.732716

In [230]: expr = '0.0 <= a <= c <= 0.5'

In [231]: map(lambda frame: frame.query(expr), [df, df2])
Out[231]: <map at 0x7f65f7952d30>
```

### ``query()``Python与pandas语法比较

完全类似numpy的语法：

``` python
In [232]: df = pd.DataFrame(np.random.randint(n, size=(n, 3)), columns=list('abc'))

In [233]: df
Out[233]: 
   a  b  c
0  7  8  9
1  1  0  7
2  2  7  2
3  6  2  2
4  2  6  3
5  3  8  2
6  1  7  2
7  5  1  5
8  9  8  0
9  1  5  0

In [234]: df.query('(a < b) & (b < c)')
Out[234]: 
   a  b  c
0  7  8  9

In [235]: df[(df.a < df.b) & (df.b < df.c)]
Out[235]: 
   a  b  c
0  7  8  9
```

通过删除括号略微更好（通过绑定使比较运算符绑定比``&``和更紧``|``）。

``` python
In [236]: df.query('a < b & b < c')
Out[236]: 
   a  b  c
0  7  8  9
```

使用英语而不是符号：

``` python
In [237]: df.query('a < b and b < c')
Out[237]: 
   a  b  c
0  7  8  9
```

非常接近你如何在纸上写它：

``` python
In [238]: df.query('a < b < c')
Out[238]: 
   a  b  c
0  7  8  9
```

### 在``in``与运营商``not in``

[``query()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.query.html#pandas.DataFrame.query)还支持Python ``in``和
 比较运算符的特殊用法，为调用或的方法提供了简洁的语法
 。``not in````isin````Series````DataFrame``

``` python
# get all rows where columns "a" and "b" have overlapping values
In [239]: df = pd.DataFrame({'a': list('aabbccddeeff'), 'b': list('aaaabbbbcccc'),
   .....:                    'c': np.random.randint(5, size=12),
   .....:                    'd': np.random.randint(9, size=12)})
   .....: 

In [240]: df
Out[240]: 
    a  b  c  d
0   a  a  2  6
1   a  a  4  7
2   b  a  1  6
3   b  a  2  1
4   c  b  3  6
5   c  b  0  2
6   d  b  3  3
7   d  b  2  1
8   e  c  4  3
9   e  c  2  0
10  f  c  0  6
11  f  c  1  2

In [241]: df.query('a in b')
Out[241]: 
   a  b  c  d
0  a  a  2  6
1  a  a  4  7
2  b  a  1  6
3  b  a  2  1
4  c  b  3  6
5  c  b  0  2

# How you'd do it in pure Python
In [242]: df[df.a.isin(df.b)]
Out[242]: 
   a  b  c  d
0  a  a  2  6
1  a  a  4  7
2  b  a  1  6
3  b  a  2  1
4  c  b  3  6
5  c  b  0  2

In [243]: df.query('a not in b')
Out[243]: 
    a  b  c  d
6   d  b  3  3
7   d  b  2  1
8   e  c  4  3
9   e  c  2  0
10  f  c  0  6
11  f  c  1  2

# pure Python
In [244]: df[~df.a.isin(df.b)]
Out[244]: 
    a  b  c  d
6   d  b  3  3
7   d  b  2  1
8   e  c  4  3
9   e  c  2  0
10  f  c  0  6
11  f  c  1  2
```

您可以将此与其他表达式结合使用，以获得非常简洁的查询：

``` python
# rows where cols a and b have overlapping values
# and col c's values are less than col d's
In [245]: df.query('a in b and c < d')
Out[245]: 
   a  b  c  d
0  a  a  2  6
1  a  a  4  7
2  b  a  1  6
4  c  b  3  6
5  c  b  0  2

# pure Python
In [246]: df[df.b.isin(df.a) & (df.c < df.d)]
Out[246]: 
    a  b  c  d
0   a  a  2  6
1   a  a  4  7
2   b  a  1  6
4   c  b  3  6
5   c  b  0  2
10  f  c  0  6
11  f  c  1  2
```

::: tip 注意

请注意``in``并在Python中进行评估，因为
它没有相应的操作。但是，**只有** / **expression本身**在vanilla Python中进行评估。例如，在表达式中``not in````numexpr``**** ``in````not in``
****

``` python
df.query('a in b + c + d')
```

``(b + c + d)``通过评估``numexpr``和*然后*的``in``
操作在普通的Python评价。通常，任何可以使用的评估操作``numexpr``都是。

:::

### ``==``运算符与``list``对象的特殊用法

一个比较``list``值的使用列``==``/ ``!=``工程，以类似``in``/ 。``not in``

``` python
In [247]: df.query('b == ["a", "b", "c"]')
Out[247]: 
    a  b  c  d
0   a  a  2  6
1   a  a  4  7
2   b  a  1  6
3   b  a  2  1
4   c  b  3  6
5   c  b  0  2
6   d  b  3  3
7   d  b  2  1
8   e  c  4  3
9   e  c  2  0
10  f  c  0  6
11  f  c  1  2

# pure Python
In [248]: df[df.b.isin(["a", "b", "c"])]
Out[248]: 
    a  b  c  d
0   a  a  2  6
1   a  a  4  7
2   b  a  1  6
3   b  a  2  1
4   c  b  3  6
5   c  b  0  2
6   d  b  3  3
7   d  b  2  1
8   e  c  4  3
9   e  c  2  0
10  f  c  0  6
11  f  c  1  2

In [249]: df.query('c == [1, 2]')
Out[249]: 
    a  b  c  d
0   a  a  2  6
2   b  a  1  6
3   b  a  2  1
7   d  b  2  1
9   e  c  2  0
11  f  c  1  2

In [250]: df.query('c != [1, 2]')
Out[250]: 
    a  b  c  d
1   a  a  4  7
4   c  b  3  6
5   c  b  0  2
6   d  b  3  3
8   e  c  4  3
10  f  c  0  6

# using in/not in
In [251]: df.query('[1, 2] in c')
Out[251]: 
    a  b  c  d
0   a  a  2  6
2   b  a  1  6
3   b  a  2  1
7   d  b  2  1
9   e  c  2  0
11  f  c  1  2

In [252]: df.query('[1, 2] not in c')
Out[252]: 
    a  b  c  d
1   a  a  4  7
4   c  b  3  6
5   c  b  0  2
6   d  b  3  3
8   e  c  4  3
10  f  c  0  6

# pure Python
In [253]: df[df.c.isin([1, 2])]
Out[253]: 
    a  b  c  d
0   a  a  2  6
2   b  a  1  6
3   b  a  2  1
7   d  b  2  1
9   e  c  2  0
11  f  c  1  2
```

### 布尔运算符

您可以使用单词``not``或``~``运算符否定布尔表达式。

``` python
In [254]: df = pd.DataFrame(np.random.rand(n, 3), columns=list('abc'))

In [255]: df['bools'] = np.random.rand(len(df)) > 0.5

In [256]: df.query('~bools')
Out[256]: 
          a         b         c  bools
2  0.697753  0.212799  0.329209  False
7  0.275396  0.691034  0.826619  False
8  0.190649  0.558748  0.262467  False

In [257]: df.query('not bools')
Out[257]: 
          a         b         c  bools
2  0.697753  0.212799  0.329209  False
7  0.275396  0.691034  0.826619  False
8  0.190649  0.558748  0.262467  False

In [258]: df.query('not bools') == df[~df.bools]
Out[258]: 
      a     b     c  bools
2  True  True  True   True
7  True  True  True   True
8  True  True  True   True
```

当然，表达式也可以是任意复杂的：

``` python
# short query syntax
In [259]: shorter = df.query('a < b < c and (not bools) or bools > 2')

# equivalent in pure Python
In [260]: longer = df[(df.a < df.b) & (df.b < df.c) & (~df.bools) | (df.bools > 2)]

In [261]: shorter
Out[261]: 
          a         b         c  bools
7  0.275396  0.691034  0.826619  False

In [262]: longer
Out[262]: 
          a         b         c  bools
7  0.275396  0.691034  0.826619  False

In [263]: shorter == longer
Out[263]: 
      a     b     c  bools
7  True  True  True   True
```

### 的表现¶``query()``

``DataFrame.query()````numexpr``对于大型帧，使用比Python略快。

![query-perf](https://static.pypandas.cn/public/static/images/query-perf.png)

::: tip 注意

如果您的框架超过大约200,000行，您将只看到使用``numexpr``引擎的性能优势``DataFrame.query()``。

![query-perf-small](https://static.pypandas.cn/public/static/images/query-perf-small.png)

:::

此图是使用``DataFrame``3列创建的，每列包含使用生成的浮点值``numpy.random.randn()``。

## 重复数据

如果要识别和删除DataFrame中的重复行，有两种方法可以提供帮助：``duplicated``和``drop_duplicates``。每个都将用于标识重复行的列作为参数。

- ``duplicated`` 返回一个布尔向量，其长度为行数，表示行是否重复。
- ``drop_duplicates`` 删除重复的行。

默认情况下，重复集的第一个观察行被认为是唯一的，但每个方法都有一个``keep``参数来指定要保留的目标。

- ``keep='first'`` （默认值）：标记/删除重复项，第一次出现除外。
- ``keep='last'``：标记/删除重复项，除了最后一次出现。
- ``keep=False``：标记/删除所有重复项。

``` python
In [264]: df2 = pd.DataFrame({'a': ['one', 'one', 'two', 'two', 'two', 'three', 'four'],
   .....:                     'b': ['x', 'y', 'x', 'y', 'x', 'x', 'x'],
   .....:                     'c': np.random.randn(7)})
   .....: 

In [265]: df2
Out[265]: 
       a  b         c
0    one  x -1.067137
1    one  y  0.309500
2    two  x -0.211056
3    two  y -1.842023
4    two  x -0.390820
5  three  x -1.964475
6   four  x  1.298329

In [266]: df2.duplicated('a')
Out[266]: 
0    False
1     True
2    False
3     True
4     True
5    False
6    False
dtype: bool

In [267]: df2.duplicated('a', keep='last')
Out[267]: 
0     True
1    False
2     True
3     True
4    False
5    False
6    False
dtype: bool

In [268]: df2.duplicated('a', keep=False)
Out[268]: 
0     True
1     True
2     True
3     True
4     True
5    False
6    False
dtype: bool

In [269]: df2.drop_duplicates('a')
Out[269]: 
       a  b         c
0    one  x -1.067137
2    two  x -0.211056
5  three  x -1.964475
6   four  x  1.298329

In [270]: df2.drop_duplicates('a', keep='last')
Out[270]: 
       a  b         c
1    one  y  0.309500
4    two  x -0.390820
5  three  x -1.964475
6   four  x  1.298329

In [271]: df2.drop_duplicates('a', keep=False)
Out[271]: 
       a  b         c
5  three  x -1.964475
6   four  x  1.298329
```

此外，您可以传递列表列表以识别重复。

``` python
In [272]: df2.duplicated(['a', 'b'])
Out[272]: 
0    False
1    False
2    False
3    False
4     True
5    False
6    False
dtype: bool

In [273]: df2.drop_duplicates(['a', 'b'])
Out[273]: 
       a  b         c
0    one  x -1.067137
1    one  y  0.309500
2    two  x -0.211056
3    two  y -1.842023
5  three  x -1.964475
6   four  x  1.298329
```

要按索引值删除重复项，请使用``Index.duplicated``然后执行切片。``keep``参数可以使用相同的选项集。

``` python
In [274]: df3 = pd.DataFrame({'a': np.arange(6),
   .....:                     'b': np.random.randn(6)},
   .....:                    index=['a', 'a', 'b', 'c', 'b', 'a'])
   .....: 

In [275]: df3
Out[275]: 
   a         b
a  0  1.440455
a  1  2.456086
b  2  1.038402
c  3 -0.894409
b  4  0.683536
a  5  3.082764

In [276]: df3.index.duplicated()
Out[276]: array([False,  True, False, False,  True,  True])

In [277]: df3[~df3.index.duplicated()]
Out[277]: 
   a         b
a  0  1.440455
b  2  1.038402
c  3 -0.894409

In [278]: df3[~df3.index.duplicated(keep='last')]
Out[278]: 
   a         b
c  3 -0.894409
b  4  0.683536
a  5  3.082764

In [279]: df3[~df3.index.duplicated(keep=False)]
Out[279]: 
   a         b
c  3 -0.894409
```

## 类字典``get()``方法

Series或DataFrame中的每一个都有一个``get``可以返回默认值的方法。

``` python
In [280]: s = pd.Series([1, 2, 3], index=['a', 'b', 'c'])

In [281]: s.get('a')  # equivalent to s['a']
Out[281]: 1

In [282]: s.get('x', default=-1)
Out[282]: -1
```

## 该``lookup()``方法

有时，您希望在给定一系列行标签和列标签的情况下提取一组值，并且该``lookup``方法允许此操作并返回NumPy数组。例如：

``` python
In [283]: dflookup = pd.DataFrame(np.random.rand(20, 4), columns = ['A', 'B', 'C', 'D'])

In [284]: dflookup.lookup(list(range(0, 10, 2)), ['B', 'C', 'A', 'B', 'D'])
Out[284]: array([0.3506, 0.4779, 0.4825, 0.9197, 0.5019])
```

## 索引对象

pandas [``Index``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.html#pandas.Index)类及其子类可以视为实现*有序的多集合*。允许重复。但是，如果您尝试将[``Index``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.html#pandas.Index)具有重复条目的对象转换为a
 ``set``，则会引发异常。

[``Index``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.html#pandas.Index)还提供了查找，数据对齐和重建索引所需的基础结构。[``Index``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.html#pandas.Index)直接创建的最简单方法
 是将一个``list``或其他序列传递给
 [``Index``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.html#pandas.Index)：

``` python
In [285]: index = pd.Index(['e', 'd', 'a', 'b'])

In [286]: index
Out[286]: Index(['e', 'd', 'a', 'b'], dtype='object')

In [287]: 'd' in index
Out[287]: True
```

您还可以传递一个``name``存储在索引中：

``` python
In [288]: index = pd.Index(['e', 'd', 'a', 'b'], name='something')

In [289]: index.name
Out[289]: 'something'
```

名称（如果已设置）将显示在控制台显示中：

``` python
In [290]: index = pd.Index(list(range(5)), name='rows')

In [291]: columns = pd.Index(['A', 'B', 'C'], name='cols')

In [292]: df = pd.DataFrame(np.random.randn(5, 3), index=index, columns=columns)

In [293]: df
Out[293]: 
cols         A         B         C
rows                              
0     1.295989  0.185778  0.436259
1     0.678101  0.311369 -0.528378
2    -0.674808 -1.103529 -0.656157
3     1.889957  2.076651 -1.102192
4    -1.211795 -0.791746  0.634724

In [294]: df['A']
Out[294]: 
rows
0    1.295989
1    0.678101
2   -0.674808
3    1.889957
4   -1.211795
Name: A, dtype: float64
```

### 设置元数据

索引是“不可改变的大多是”，但它可以设置和改变它们的元数据，如指数``name``（或为``MultiIndex``，``levels``和
 ``codes``）。

您可以使用``rename``，``set_names``，``set_levels``，和``set_codes``
直接设置这些属性。他们默认返回一份副本; 但是，您可以指定``inplace=True``使数据更改到位。

有关MultiIndexes的使用，请参阅[高级索引](advanced.html#advanced)。

``` python
In [295]: ind = pd.Index([1, 2, 3])

In [296]: ind.rename("apple")
Out[296]: Int64Index([1, 2, 3], dtype='int64', name='apple')

In [297]: ind
Out[297]: Int64Index([1, 2, 3], dtype='int64')

In [298]: ind.set_names(["apple"], inplace=True)

In [299]: ind.name = "bob"

In [300]: ind
Out[300]: Int64Index([1, 2, 3], dtype='int64', name='bob')
```

``set_names``，``set_levels``并且``set_codes``还采用可选
 ``level``参数

``` python
In [301]: index = pd.MultiIndex.from_product([range(3), ['one', 'two']], names=['first', 'second'])

In [302]: index
Out[302]: 
MultiIndex([(0, 'one'),
            (0, 'two'),
            (1, 'one'),
            (1, 'two'),
            (2, 'one'),
            (2, 'two')],
           names=['first', 'second'])

In [303]: index.levels[1]
Out[303]: Index(['one', 'two'], dtype='object', name='second')

In [304]: index.set_levels(["a", "b"], level=1)
Out[304]: 
MultiIndex([(0, 'a'),
            (0, 'b'),
            (1, 'a'),
            (1, 'b'),
            (2, 'a'),
            (2, 'b')],
           names=['first', 'second'])
```

### 在Index对象上设置操作

两个主要业务是和。这些可以直接称为实例方法，也可以通过重载运算符使用。通过该方法提供差异。``union (|)````intersection (&)````.difference()``

``` python
In [305]: a = pd.Index(['c', 'b', 'a'])

In [306]: b = pd.Index(['c', 'e', 'd'])

In [307]: a | b
Out[307]: Index(['a', 'b', 'c', 'd', 'e'], dtype='object')

In [308]: a & b
Out[308]: Index(['c'], dtype='object')

In [309]: a.difference(b)
Out[309]: Index(['a', 'b'], dtype='object')
```

同时还提供了操作，它返回出现在任一元件或，但不是在两者。这相当于创建的索引，删除了重复项。``symmetric_difference (^)````idx1````idx2````idx1.difference(idx2).union(idx2.difference(idx1))``

``` python
In [310]: idx1 = pd.Index([1, 2, 3, 4])

In [311]: idx2 = pd.Index([2, 3, 4, 5])

In [312]: idx1.symmetric_difference(idx2)
Out[312]: Int64Index([1, 5], dtype='int64')

In [313]: idx1 ^ idx2
Out[313]: Int64Index([1, 5], dtype='int64')
```

::: tip 注意

来自设置操作的结果索引将按升序排序。

:::

在[``Index.union()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.union.html#pandas.Index.union)具有不同dtypes的索引之间执行时，必须将索引强制转换为公共dtype。通常，虽然并非总是如此，但这是对象dtype。例外是在整数和浮点数据之间执行联合。在这种情况下，整数值将转换为float

``` python
In [314]: idx1 = pd.Index([0, 1, 2])

In [315]: idx2 = pd.Index([0.5, 1.5])

In [316]: idx1 | idx2
Out[316]: Float64Index([0.0, 0.5, 1.0, 1.5, 2.0], dtype='float64')
```

### 缺少值

即使``Index``可以保存缺失值（``NaN``），但如果您不想要任何意外结果，也应该避免使用。例如，某些操作会隐式排除缺失值。

``Index.fillna`` 使用指定的标量值填充缺失值。

``` python
In [317]: idx1 = pd.Index([1, np.nan, 3, 4])

In [318]: idx1
Out[318]: Float64Index([1.0, nan, 3.0, 4.0], dtype='float64')

In [319]: idx1.fillna(2)
Out[319]: Float64Index([1.0, 2.0, 3.0, 4.0], dtype='float64')

In [320]: idx2 = pd.DatetimeIndex([pd.Timestamp('2011-01-01'),
   .....:                          pd.NaT,
   .....:                          pd.Timestamp('2011-01-03')])
   .....: 

In [321]: idx2
Out[321]: DatetimeIndex(['2011-01-01', 'NaT', '2011-01-03'], dtype='datetime64[ns]', freq=None)

In [322]: idx2.fillna(pd.Timestamp('2011-01-02'))
Out[322]: DatetimeIndex(['2011-01-01', '2011-01-02', '2011-01-03'], dtype='datetime64[ns]', freq=None)
```

## 设置/重置索引

有时您会将数据集加载或创建到DataFrame中，并希望在您已经完成之后添加索引。有几种不同的方式。

### 设置索引

DataFrame有一个[``set_index()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.set_index.html#pandas.DataFrame.set_index)方法，它采用列名（对于常规``Index``）或列名列表（对于a ``MultiIndex``）。要创建新的重新索引的DataFrame：

``` python
In [323]: data
Out[323]: 
     a    b  c    d
0  bar  one  z  1.0
1  bar  two  y  2.0
2  foo  one  x  3.0
3  foo  two  w  4.0

In [324]: indexed1 = data.set_index('c')

In [325]: indexed1
Out[325]: 
     a    b    d
c               
z  bar  one  1.0
y  bar  two  2.0
x  foo  one  3.0
w  foo  two  4.0

In [326]: indexed2 = data.set_index(['a', 'b'])

In [327]: indexed2
Out[327]: 
         c    d
a   b          
bar one  z  1.0
    two  y  2.0
foo one  x  3.0
    two  w  4.0
```

该``append``关键字选项让你保持现有索引并追加给列一个多指标：

``` python
In [328]: frame = data.set_index('c', drop=False)

In [329]: frame = frame.set_index(['a', 'b'], append=True)

In [330]: frame
Out[330]: 
           c    d
c a   b          
z bar one  z  1.0
y bar two  y  2.0
x foo one  x  3.0
w foo two  w  4.0
```

其他选项``set_index``允许您不删除索引列或就地添加索引（不创建新对象）：

``` python
In [331]: data.set_index('c', drop=False)
Out[331]: 
     a    b  c    d
c                  
z  bar  one  z  1.0
y  bar  two  y  2.0
x  foo  one  x  3.0
w  foo  two  w  4.0

In [332]: data.set_index(['a', 'b'], inplace=True)

In [333]: data
Out[333]: 
         c    d
a   b          
bar one  z  1.0
    two  y  2.0
foo one  x  3.0
    two  w  4.0
```

### 重置索引

为方便起见，DataFrame上有一个新函数，它将
 [``reset_index()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.reset_index.html#pandas.DataFrame.reset_index)索引值传输到DataFrame的列中并设置一个简单的整数索引。这是反向操作[``set_index()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.set_index.html#pandas.DataFrame.set_index)。

``` python
In [334]: data
Out[334]: 
         c    d
a   b          
bar one  z  1.0
    two  y  2.0
foo one  x  3.0
    two  w  4.0

In [335]: data.reset_index()
Out[335]: 
     a    b  c    d
0  bar  one  z  1.0
1  bar  two  y  2.0
2  foo  one  x  3.0
3  foo  two  w  4.0
```

输出更类似于SQL表或记录数组。从索引派生的列的名称是存储在``names``属性中的名称。

您可以使用``level``关键字仅删除索引的一部分：

``` python
In [336]: frame
Out[336]: 
           c    d
c a   b          
z bar one  z  1.0
y bar two  y  2.0
x foo one  x  3.0
w foo two  w  4.0

In [337]: frame.reset_index(level=1)
Out[337]: 
         a  c    d
c b               
z one  bar  z  1.0
y two  bar  y  2.0
x one  foo  x  3.0
w two  foo  w  4.0
```

``reset_index``采用一个可选参数``drop``，如果为true，则只丢弃索引，而不是将索引值放在DataFrame的列中。

### 添加ad hoc索引

如果您自己创建索引，则可以将其分配给``index``字段：

``` python
data.index = index
```

## 返回视图与副本

在pandas对象中设置值时，必须注意避免调用所谓的对象
 。这是一个例子。``chained indexing``

``` python
In [338]: dfmi = pd.DataFrame([list('abcd'),
   .....:                      list('efgh'),
   .....:                      list('ijkl'),
   .....:                      list('mnop')],
   .....:                     columns=pd.MultiIndex.from_product([['one', 'two'],
   .....:                                                         ['first', 'second']]))
   .....: 

In [339]: dfmi
Out[339]: 
    one          two       
  first second first second
0     a      b     c      d
1     e      f     g      h
2     i      j     k      l
3     m      n     o      p
```

比较这两种访问方法：

``` python
In [340]: dfmi['one']['second']
Out[340]: 
0    b
1    f
2    j
3    n
Name: second, dtype: object
```

``` python
In [341]: dfmi.loc[:, ('one', 'second')]
Out[341]: 
0    b
1    f
2    j
3    n
Name: (one, second), dtype: object
```

这两者都产生相同的结果，所以你应该使用哪个？理解这些操作的顺序以及为什么方法2（``.loc``）比方法1（链接``[]``）更受欢迎是有益的。

``dfmi['one']``选择列的第一级并返回单索引的DataFrame。然后另一个Python操作``dfmi_with_one['second']``选择索引的系列``'second'``。这由变量指示，``dfmi_with_one``因为pandas将这些操作视为单独的事件。例如，单独调用``__getitem__``，因此它必须将它们视为线性操作，它们一个接一个地发生。

对比这个``df.loc[:,('one','second')]``将一个嵌套的元组传递``(slice(None),('one','second'))``给一个单独的调用
 ``__getitem__``。这允许pandas将其作为单个实体来处理。此外，这种操作顺序*可以*明显更快，并且如果需要，允许人们对*两个*轴进行索引。

### 使用链式索引时为什么分配失败？

上一节中的问题只是一个性能问题。这是怎么回事与``SettingWithCopy``警示？当你做一些可能花费几毫秒的事情时，我们**通常**不会发出警告！

但事实证明，分配链式索引的产品具有固有的不可预测的结果。要看到这一点，请考虑Python解释器如何执行此代码：

``` python
dfmi.loc[:, ('one', 'second')] = value
# becomes
dfmi.loc.__setitem__((slice(None), ('one', 'second')), value)
```

但是这个代码的处理方式不同：

``` python
dfmi['one']['second'] = value
# becomes
dfmi.__getitem__('one').__setitem__('second', value)
```

看到``__getitem__``那里？除了简单的情况之外，很难预测它是否会返回一个视图或一个副本（它取决于数组的内存布局，关于哪些pandas不能保证），因此是否``__setitem__``会修改``dfmi``或者是一个临时对象之后立即抛出。**那**什么``SettingWithCopy``是警告你！

::: tip 注意

您可能想知道我们是否应该关注``loc``
第一个示例中的属性。但``dfmi.loc``保证``dfmi``
本身具有修改的索引行为，因此``dfmi.loc.__getitem__``/
 直接``dfmi.loc.__setitem__``操作``dfmi``。当然，
 ``dfmi.loc.__getitem__(idx)``可能是一个视图或副本``dfmi``。

:::

有时``SettingWithCopy``，当没有明显的链式索引时，会出现警告。**这些**``SettingWithCopy``是旨在捕获的错误
 ！Pandas可能会试图警告你，你已经这样做了：

``` python
def do_something(df):
    foo = df[['bar', 'baz']]  # Is foo a view? A copy? Nobody knows!
    # ... many lines here ...
    # We don't know whether this will modify df or not!
    foo['quux'] = value
    return foo
```

哎呀！

### 评估订单事项

使用链式索引时，索引操作的顺序和类型会部分确定结果是原始对象的切片还是切片的副本。

Pandas有，``SettingWithCopyWarning``因为分配一个切片的副本通常不是故意的，而是由链式索引引起的错误返回一个预期切片的副本。

如果您希望pandas或多或少地信任链接索引表达式的赋值，则可以将[选项](options.html#options)
设置``mode.chained_assignment``为以下值之一：

- ``'warn'``，默认值表示``SettingWithCopyWarning``打印。
- ``'raise'``意味着大Pandas会提出``SettingWithCopyException``
你必须处理的事情。
- ``None`` 将完全压制警告。

``` python
In [342]: dfb = pd.DataFrame({'a': ['one', 'one', 'two',
   .....:                           'three', 'two', 'one', 'six'],
   .....:                     'c': np.arange(7)})
   .....: 

# This will show the SettingWithCopyWarning
# but the frame values will be set
In [343]: dfb['c'][dfb.a.str.startswith('o')] = 42
```

然而，这是在副本上运行，不起作用。

``` python
>>> pd.set_option('mode.chained_assignment','warn')
>>> dfb[dfb.a.str.startswith('o')]['c'] = 42
Traceback (most recent call last)
     ...
SettingWithCopyWarning:
     A value is trying to be set on a copy of a slice from a DataFrame.
     Try using .loc[row_index,col_indexer] = value instead
```

链式分配也可以在混合dtype帧中进行设置。

::: tip 注意

这些设置规则适用于所有``.loc/.iloc``。

:::

这是正确的访问方法：

``` python
In [344]: dfc = pd.DataFrame({'A': ['aaa', 'bbb', 'ccc'], 'B': [1, 2, 3]})

In [345]: dfc.loc[0, 'A'] = 11

In [346]: dfc
Out[346]: 
     A  B
0   11  1
1  bbb  2
2  ccc  3
```

这有时*会*起作用，但不能保证，因此应该避免：

``` python
In [347]: dfc = dfc.copy()

In [348]: dfc['A'][0] = 111

In [349]: dfc
Out[349]: 
     A  B
0  111  1
1  bbb  2
2  ccc  3
```

这**根本**不起作用，所以应该避免：

``` python
>>> pd.set_option('mode.chained_assignment','raise')
>>> dfc.loc[0]['A'] = 1111
Traceback (most recent call last)
     ...
SettingWithCopyException:
     A value is trying to be set on a copy of a slice from a DataFrame.
     Try using .loc[row_index,col_indexer] = value instead
```

::: danger 警告

链式分配警告/异常旨在通知用户可能无效的分配。可能存在误报; 无意中报告链式作业的情况。

:::
