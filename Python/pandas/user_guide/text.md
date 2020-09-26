---
meta:
  - name: keywords
    content: Pandas 处理字符串
  - name: description
    content: 序列和索引包含一些列的字符操作方法，这可以使我们轻易操作数组中的各个元素。最重要的是，这些方法可以自动跳过 缺失/NA 值。这些方法可以在``str``属性中访问到，并且基本上和python内建的（标量）字符串方法同名：
---

# Pandas 处理文本字符串

序列和索引包含一些列的字符操作方法，这可以使我们轻易操作数组中的各个元素。最重要的是，这些方法可以自动跳过 缺失/NA 值。这些方法可以在``str``属性中访问到，并且基本上和python内建的（标量）字符串方法同名：

``` python
In [1]: s = pd.Series(['A', 'B', 'C', 'Aaba', 'Baca', np.nan, 'CABA', 'dog', 'cat'])

In [2]: s.str.lower()
Out[2]: 
0       a
1       b
2       c
3    aaba
4    baca
5     NaN
6    caba
7     dog
8     cat
dtype: object

In [3]: s.str.upper()
Out[3]: 
0       A
1       B
2       C
3    AABA
4    BACA
5     NaN
6    CABA
7     DOG
8     CAT
dtype: object

In [4]: s.str.len()
Out[4]: 
0    1.0
1    1.0
2    1.0
3    4.0
4    4.0
5    NaN
6    4.0
7    3.0
8    3.0
dtype: float64
```

``` python
In [5]: idx = pd.Index([' jack', 'jill ', ' jesse ', 'frank'])

In [6]: idx.str.strip()
Out[6]: Index(['jack', 'jill', 'jesse', 'frank'], dtype='object')

In [7]: idx.str.lstrip()
Out[7]: Index(['jack', 'jill ', 'jesse ', 'frank'], dtype='object')

In [8]: idx.str.rstrip()
Out[8]: Index([' jack', 'jill', ' jesse', 'frank'], dtype='object')
```

索引的字符串方法在清理或者转换数据表列的时候非常有用。例如，你的列中或许会包含首位的白空格：

``` python
In [9]: df = pd.DataFrame(np.random.randn(3, 2),
   ...:                   columns=[' Column A ', ' Column B '], index=range(3))
   ...: 

In [10]: df
Out[10]: 
    Column A    Column B 
0    0.469112   -0.282863
1   -1.509059   -1.135632
2    1.212112   -0.173215
```

Since ``df.columns`` is an Index object, we can use the ``.str`` accessor

``` python
In [11]: df.columns.str.strip()
Out[11]: Index(['Column A', 'Column B'], dtype='object')

In [12]: df.columns.str.lower()
Out[12]: Index([' column a ', ' column b '], dtype='object')
```

这些字符串方法可以被用来清理需要的列。这里，我们想清理开头和结尾的白空格，将所有的名称都换为小写，并且将其余的空格都替换为下划线：

``` python
In [13]: df.columns = df.columns.str.strip().str.lower().str.replace(' ', '_')

In [14]: df
Out[14]: 
   column_a  column_b
0  0.469112 -0.282863
1 -1.509059 -1.135632
2  1.212112 -0.173215
```

::: tip 小贴士

如果你有一个序列，里面有很多重复的值
（即，序列中唯一元素的数量远小于``序列``的长度），将原有序列转换为一种分类类型，然后使用``.str.`` 或者 ``.dt.``方法，则会获得更快的速度。
速度的差异来源于，在``分类类型``的``序列``中，字符操作只是在``categories``中完成的，而不是针对``序列``中的每一个元素。

请注意，相比于字符串类型的``序列``，带``.categories``类型的 ``分类`` 类别的 ``序列``有一些限制（例如，你不能像其中的元素追加其他的字串：``s + " " + s`` 将不能正确工作，如果s是一个``分类``类型的序列。并且，``.str`` 中，那些可以对 ``列表（list）`` 类型的元素进行操作的方法，在分类序列中也无法使用。

:::

::: danger 警告

v.0.25.0版以前， ``.str``访问器只会进行最基本的类型检查。
从v.0.25.0起，序列的类型会被自动推断出来，并且会更为激进地使用恰当的类型。

一般来说 ``.str`` 访问器只倾向于针对字符串类型工作。只有在个别的情况下，才能对非字符串类型工作，但是这也将会在未来的版本中被逐步修正
:::

## 拆分和替换字符串

类似``split``的方法返回一个列表类型的序列：

``` python
In [15]: s2 = pd.Series(['a_b_c', 'c_d_e', np.nan, 'f_g_h'])

In [16]: s2.str.split('_')
Out[16]: 
0    [a, b, c]
1    [c, d, e]
2          NaN
3    [f, g, h]
dtype: object
```

切分后的列表中的元素可以通过 ``get`` 方法或者 ``[]`` 方法进行读取：

``` python
In [17]: s2.str.split('_').str.get(1)
Out[17]: 
0      b
1      d
2    NaN
3      g
dtype: object

In [18]: s2.str.split('_').str[1]
Out[18]: 
0      b
1      d
2    NaN
3      g
dtype: object
```

使用``expand``方法可以轻易地将这种返回展开为一个数据表.

``` python
In [19]: s2.str.split('_', expand=True)
Out[19]: 
     0    1    2
0    a    b    c
1    c    d    e
2  NaN  NaN  NaN
3    f    g    h
```

同样，我们也可以限制切分的次数：

``` python
In [20]: s2.str.split('_', expand=True, n=1)
Out[20]: 
     0    1
0    a  b_c
1    c  d_e
2  NaN  NaN
3    f  g_h
```

``rsplit``与``split``相似，不同的是，这个切分的方向是反的。即，从字串的尾端向首段切分：

``` python
In [21]: s2.str.rsplit('_', expand=True, n=1)
Out[21]: 
     0    1
0  a_b    c
1  c_d    e
2  NaN  NaN
3  f_g    h
```

``replace`` 方法默认使用 [正则表达式](https://docs.python.org/3/library/re.html):

``` python
In [22]: s3 = pd.Series(['A', 'B', 'C', 'Aaba', 'Baca',
   ....:                '', np.nan, 'CABA', 'dog', 'cat'])
   ....: 

In [23]: s3
Out[23]: 
0       A
1       B
2       C
3    Aaba
4    Baca
5        
6     NaN
7    CABA
8     dog
9     cat
dtype: object

In [24]: s3.str.replace('^.a|dog', 'XX-XX ', case=False)
Out[24]: 
0           A
1           B
2           C
3    XX-XX ba
4    XX-XX ca
5            
6         NaN
7    XX-XX BA
8      XX-XX 
9     XX-XX t
dtype: object
```

一定要时时记得，是正则表达式，因此要格外小心。例如，因为正则表达式中的*$*符号,下列代码将会导致一些麻烦：

``` python
# Consider the following badly formatted financial data
In [25]: dollars = pd.Series(['12', '-$10', '$10,000'])

# This does what you'd naively expect:
In [26]: dollars.str.replace('$', '')
Out[26]: 
0        12
1       -10
2    10,000
dtype: object

# But this doesn't:
In [27]: dollars.str.replace('-$', '-')
Out[27]: 
0         12
1       -$10
2    $10,000
dtype: object

# We need to escape the special character (for >1 len patterns)
In [28]: dollars.str.replace(r'-\$', '-')
Out[28]: 
0         12
1        -10
2    $10,000
dtype: object
```

*v0.23.0. 新加入* 

如果你只是向单纯地替换字符 (等价于python中的
[``str.replace()``](https://docs.python.org/3/library/stdtypes.html#str.replace))，你可以将可选参数 ``regex`` 设置为 ``False``，而不是傻傻地转义所有符号。这种情况下，``pat`` 和 ``repl`` 就都将作为普通字符对待：

``` python
# These lines are equivalent
In [29]: dollars.str.replace(r'-\$', '-')
Out[29]: 
0         12
1        -10
2    $10,000
dtype: object

In [30]: dollars.str.replace('-$', '-', regex=False)
Out[30]: 
0         12
1        -10
2    $10,000
dtype: object
```

*v0.20.0. 新加入* 

``replace`` 方法也可以传入一个可调用对象作为替换值。它针对每一个 ``pat`` 通过[``re.sub()``](https://docs.python.org/3/library/re.html#re.sub)来调用。可调用对象应只具有一个形参（一个正则表达式对象）并且返回一个字符串。

``` python
# Reverse every lowercase alphabetic word
In [31]: pat = r'[a-z]+'

In [32]: def repl(m):
   ....:     return m.group(0)[::-1]
   ....: 

In [33]: pd.Series(['foo 123', 'bar baz', np.nan]).str.replace(pat, repl)
Out[33]: 
0    oof 123
1    rab zab
2        NaN
dtype: object

# Using regex groups
In [34]: pat = r"(?P<one>\w+) (?P<two>\w+) (?P<three>\w+)"

In [35]: def repl(m):
   ....:     return m.group('two').swapcase()
   ....: 

In [36]: pd.Series(['Foo Bar Baz', np.nan]).str.replace(pat, repl)
Out[36]: 
0    bAR
1    NaN
dtype: object
```

*v0.20.0. 新加入* 

 ``replace`` 方法也可以接受一个来自[``re.compile()``](https://docs.python.org/3/library/re.html#re.compile) 编译过的正则表达式对象，来做为``表达式``。所有的标记都应该被包含在这个已经编译好的正则表达式对象中。

``` python
In [37]: import re

In [38]: regex_pat = re.compile(r'^.a|dog', flags=re.IGNORECASE)

In [39]: s3.str.replace(regex_pat, 'XX-XX ')
Out[39]: 
0           A
1           B
2           C
3    XX-XX ba
4    XX-XX ca
5            
6         NaN
7    XX-XX BA
8      XX-XX 
9     XX-XX t
dtype: object
```

如果在已经使用编译的正则对象中继续传入``flags`` 参数，并进行替换，将会导致``ValueError``。

``` python
In [40]: s3.str.replace(regex_pat, 'XX-XX ', flags=re.IGNORECASE)
---------------------------------------------------------------------------
ValueError: case and flags cannot be set when pat is a compiled regex
```

## 拼接

Pandas提供了不同的方法将``序列``或``索引``与他们自己或者其他的对象进行拼接，所有的方法都是基于各自的[``cat()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.cat.html#pandas.Series.str.cat),
resp. ``Index.str.cat``.

### 将单个序列拼接为一个完整字符串

``序列``或``索引``的内容可以进行拼接：

``` python
In [41]: s = pd.Series(['a', 'b', 'c', 'd'])

In [42]: s.str.cat(sep=',')
Out[42]: 'a,b,c,d'
```

如果没有额外声明，``sep`` 即分隔符默认为空字串，即``sep=''``：

``` python
In [43]: s.str.cat()
Out[43]: 'abcd'
```

默认情况下，缺失值会被忽略。使用``na_rep``参数，可以对缺失值进行赋值：

``` python
In [44]: t = pd.Series(['a', 'b', np.nan, 'd'])

In [45]: t.str.cat(sep=',')
Out[45]: 'a,b,d'

In [46]: t.str.cat(sep=',', na_rep='-')
Out[46]: 'a,b,-,d'
```

### 拼接序列和其他类列表型对象为新的序列

[``cat()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.cat.html#pandas.Series.str.cat)  的第一个参数为类列表对象，但必须要确保长度与``序列``或``索引``相同.

``` python
In [47]: s.str.cat(['A', 'B', 'C', 'D'])
Out[47]: 
0    aA
1    bB
2    cC
3    dD
dtype: object
```


任何一端的缺失值都会导致之中结果为缺失值，*除非*使用``na_rep``：

``` python
In [48]: s.str.cat(t)
Out[48]: 
0     aa
1     bb
2    NaN
3     dd
dtype: object

In [49]: s.str.cat(t, na_rep='-')
Out[49]: 
0    aa
1    bb
2    c-
3    dd
dtype: object
```

### 拼接序列与类数组对象为新的序列

*v0.23.0. 新加入* 

``others`` 参数可以是二维的。此时，行数需要与``序列``或``索引``的长度相同。

``` python
In [50]: d = pd.concat([t, s], axis=1)

In [51]: s
Out[51]: 
0    a
1    b
2    c
3    d
dtype: object

In [52]: d
Out[52]: 
     0  1
0    a  a
1    b  b
2  NaN  c
3    d  d

In [53]: s.str.cat(d, na_rep='-')
Out[53]: 
0    aaa
1    bbb
2    c-c
3    ddd
dtype: object
```

### 对齐拼接序列与带索引的对象成为新的序列

*v0.23.0.新加入* 

对于拼接``序列``或者``数据表``，我们可以使用 ``join``关键字来对齐索引。

``` python
In [54]: u = pd.Series(['b', 'd', 'a', 'c'], index=[1, 3, 0, 2])

In [55]: s
Out[55]: 
0    a
1    b
2    c
3    d
dtype: object

In [56]: u
Out[56]: 
1    b
3    d
0    a
2    c
dtype: object

In [57]: s.str.cat(u)
Out[57]: 
0    ab
1    bd
2    ca
3    dc
dtype: object

In [58]: s.str.cat(u, join='left')
Out[58]: 
0    aa
1    bb
2    cc
3    dd
dtype: object
```

::: danger 警告

如果不使用``join`` 关键字， [``cat()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.cat.html#pandas.Series.str.cat) 方法将会滚回到0.23.0版之前，即（无对齐）模式。但如果任何的索引不一致时，将会抛出一个
``FutureWarning``  警告，因为在未来的版本中，默认行为将改为join='left' 。

:::

``join`` 的选项为（``'left'``, ``'outer'``, ``'inner'``, ``'right'``）中的一个。
特别的，对齐操作使得两个对象可以是不同的长度。

``` python
In [59]: v = pd.Series(['z', 'a', 'b', 'd', 'e'], index=[-1, 0, 1, 3, 4])

In [60]: s
Out[60]: 
0    a
1    b
2    c
3    d
dtype: object

In [61]: v
Out[61]: 
-1    z
 0    a
 1    b
 3    d
 4    e
dtype: object

In [62]: s.str.cat(v, join='left', na_rep='-')
Out[62]: 
0    aa
1    bb
2    c-
3    dd
dtype: object

In [63]: s.str.cat(v, join='outer', na_rep='-')
Out[63]: 
-1    -z
 0    aa
 1    bb
 2    c-
 3    dd
 4    -e
dtype: object
```

当``others``是一个``数据表``时，也可以执行相同的对齐操作：

``` python
In [64]: f = d.loc[[3, 2, 1, 0], :]

In [65]: s
Out[65]: 
0    a
1    b
2    c
3    d
dtype: object

In [66]: f
Out[66]: 
     0  1
3    d  d
2  NaN  c
1    b  b
0    a  a

In [67]: s.str.cat(f, join='left', na_rep='-')
Out[67]: 
0    aaa
1    bbb
2    c-c
3    ddd
dtype: object
```

### 将一个序列与多个对象拼接为一个新的序列

所有的一维，类列表对象都可以任意组合进一个类列表的容器（包括迭代器，dict-视图等）：

``` python
In [68]: s
Out[68]: 
0    a
1    b
2    c
3    d
dtype: object

In [69]: u
Out[69]: 
1    b
3    d
0    a
2    c
dtype: object

In [70]: s.str.cat([u, u.to_numpy()], join='left')
Out[70]: 
0    aab
1    bbd
2    cca
3    ddc
dtype: object
```

除了那些有索引的，所有传入没有索引的元素（如``np.ndarray``）必须与``序列``或``索引``有相同的长度。但是，只要禁用对齐``join=None``，那么``序列``或``索引``就可以是任意长度。


``` python
In [71]: v
Out[71]: 
-1    z
 0    a
 1    b
 3    d
 4    e
dtype: object

In [72]: s.str.cat([v, u, u.to_numpy()], join='outer', na_rep='-')
Out[72]: 
-1    -z--
 0    aaab
 1    bbbd
 2    c-ca
 3    dddc
 4    -e--
dtype: object
```

如果在一个包含不同的索引的``others``列表上使用``join='right'``，所有索引的并集将会被作为最终拼接的基础：

``` python
In [73]: u.loc[[3]]
Out[73]: 
3    d
dtype: object

In [74]: v.loc[[-1, 0]]
Out[74]: 
-1    z
 0    a
dtype: object

In [75]: s.str.cat([u.loc[[3]], v.loc[[-1, 0]]], join='right', na_rep='-')
Out[75]: 
-1    --z
 0    a-a
 3    dd-
dtype: object
```

## 使用.str进行索引

你可以使用 ``[]``方法来直接索引定位。如果你的索引超过了字符串的结尾，将返回``NaN``。

``` python
In [76]: s = pd.Series(['A', 'B', 'C', 'Aaba', 'Baca', np.nan,
   ....:                'CABA', 'dog', 'cat'])
   ....: 

In [77]: s.str[0]
Out[77]: 
0      A
1      B
2      C
3      A
4      B
5    NaN
6      C
7      d
8      c
dtype: object

In [78]: s.str[1]
Out[78]: 
0    NaN
1    NaN
2    NaN
3      a
4      a
5    NaN
6      A
7      o
8      a
dtype: object
```

## 提取子字符串

### 提取第一个匹配的对象  (extract)

::: danger 警告

在 0.18.0中，``extract``拥有了 ``expand`` 参数。当 ``expand=False``时， 将返回一个序列，索引或者数据表， 这取决于原对象和正则表达式（之前的版本也是如此）。当 ``expand=True``时，它则总是返回一个``DataFrame``，这样可以更加一致，并且减少用户的混淆。 ``Expand=True`` 从0.23.0版本之后成为默认值。

:::

``extract`` 方法接受一个至少含有一个捕获组的 [正则表达式](https://docs.python.org/3/library/re.html)。

使用超过一个捕获组的正则表达式则会提取并返回一个数据表，每一列为一个捕获组。

``` python
In [79]: pd.Series(['a1', 'b2', 'c3']).str.extract(r'([ab])(\d)', expand=False)
Out[79]: 
     0    1
0    a    1
1    b    2
2  NaN  NaN
```

没有成功匹配的元素将会返回一行``NaN``。因此，一个序列的混乱的字符串可以被‘转换’为一个类似索引的序列或数据表。返回的内容会更为清爽，而且不需要使用``get()``方法来访问元组中的成员或者``re.match``对象。返回的类型将总是``object``类，即使匹配失败，返回的全是``NaN``。

有名称的捕获组，如：

``` python
In [80]: pd.Series(['a1', 'b2', 'c3']).str.extract(r'(?P<letter>[ab])(?P<digit>\d)',
   ....:                                           expand=False)
   ....: 
Out[80]: 
  letter digit
0      a     1
1      b     2
2    NaN   NaN
```

可选组类似，如：

``` python
In [81]: pd.Series(['a1', 'b2', '3']).str.extract(r'([ab])?(\d)', expand=False)
Out[81]: 
     0  1
0    a  1
1    b  2
2  NaN  3
```
也可以被使用。注意，任何有名称的捕获组，其名称都会被用做列名，否则将会直接使用数字。

如果仅使用正则表达式捕获一个组，而``expand=True``，那么仍然将返回一个``数据表``。

``` python
In [82]: pd.Series(['a1', 'b2', 'c3']).str.extract(r'[ab](\d)', expand=True)
Out[82]: 
     0
0    1
1    2
2  NaN
```

如果``expand=False``，则会返回一个``序列``。

``` python
In [83]: pd.Series(['a1', 'b2', 'c3']).str.extract(r'[ab](\d)', expand=False)
Out[83]: 
0      1
1      2
2    NaN
dtype: object
```

在``索引``上使用正则表达式，并且仅捕获一个组时，将会返回一个``数据表``，如果``expand=True``。

``` python
In [84]: s = pd.Series(["a1", "b2", "c3"], ["A11", "B22", "C33"])

In [85]: s
Out[85]: 
A11    a1
B22    b2
C33    c3
dtype: object

In [86]: s.index.str.extract("(?P<letter>[a-zA-Z])", expand=True)
Out[86]: 
  letter
0      A
1      B
2      C
```

如果``expand=False``，则返回一个``Index``。

``` python
In [87]: s.index.str.extract("(?P<letter>[a-zA-Z])", expand=False)
Out[87]: Index(['A', 'B', 'C'], dtype='object', name='letter')
```

如果在``索引``上使用正则并捕获多个组，则返回一个``数据表``，如果``expand=True``。

``` python
In [88]: s.index.str.extract("(?P<letter>[a-zA-Z])([0-9]+)", expand=True)
Out[88]: 
  letter   1
0      A  11
1      B  22
2      C  33
```

如果 ``expand=False``，则抛出``ValueError``。

``` python
>>> s.index.str.extract("(?P<letter>[a-zA-Z])([0-9]+)", expand=False)
ValueError: only one regex group is supported with Index
```

下面的表格总结了``extract (expand=False)``时的行为（输入对象在第一列，捕获组的数量在第一行）

  | 1 group | >1 group
---|---|---
Index | Index | ValueError
Series | Series | DataFrame

### 提取所有的匹配 (extractall)

*v0.18.0. 新加入* 

不同于 ``extract``（只返回第一个匹配），

``` python
In [89]: s = pd.Series(["a1a2", "b1", "c1"], index=["A", "B", "C"])

In [90]: s
Out[90]: 
A    a1a2
B      b1
C      c1
dtype: object

In [91]: two_groups = '(?P<letter>[a-z])(?P<digit>[0-9])'

In [92]: s.str.extract(two_groups, expand=True)
Out[92]: 
  letter digit
A      a     1
B      b     1
C      c     1
```

``extractall``方法返回所有的匹配。``extractall``总是返回一个带有行``多重索引``的``数据表``，最后一级``多重索引``被命名为``match``，它指出匹配的顺序

``` python
In [93]: s.str.extractall(two_groups)
Out[93]: 
        letter digit
  match             
A 0          a     1
  1          a     2
B 0          b     1
C 0          c     1
```

当所有的对象字串都只有一个匹配时，

``` python
In [94]: s = pd.Series(['a3', 'b3', 'c2'])

In [95]: s
Out[95]: 
0    a3
1    b3
2    c2
dtype: object
```

``extractall(pat).xs(0, level='match')`` 的返回与``extract(pat)``相同。

``` python
In [96]: extract_result = s.str.extract(two_groups, expand=True)

In [97]: extract_result
Out[97]: 
  letter digit
0      a     3
1      b     3
2      c     2

In [98]: extractall_result = s.str.extractall(two_groups)

In [99]: extractall_result
Out[99]: 
        letter digit
  match             
0 0          a     3
1 0          b     3
2 0          c     2

In [100]: extractall_result.xs(0, level="match")
Out[100]: 
  letter digit
0      a     3
1      b     3
2      c     2
```

``索引``也支持``.str.extractall``。 它返回一个``数据表``，其中包含与``Series.str.estractall``相同的结果，使用默认索引（从0开始）

*v0.19.0. 新加入* 

``` python
In [101]: pd.Index(["a1a2", "b1", "c1"]).str.extractall(two_groups)
Out[101]: 
        letter digit
  match             
0 0          a     1
  1          a     2
1 0          b     1
2 0          c     1

In [102]: pd.Series(["a1a2", "b1", "c1"]).str.extractall(two_groups)
Out[102]: 
        letter digit
  match             
0 0          a     1
  1          a     2
1 0          b     1
2 0          c     1
```

## 测试匹配或包含模式的字符串

你可以检查是否一个元素包含一个可以匹配到的正则表达式：

``` python
In [103]: pattern = r'[0-9][a-z]'

In [104]: pd.Series(['1', '2', '3a', '3b', '03c']).str.contains(pattern)
Out[104]: 
0    False
1    False
2     True
3     True
4     True
dtype: bool
```

或者是否元素完整匹配一个正则表达式

``` python
In [105]: pd.Series(['1', '2', '3a', '3b', '03c']).str.match(pattern)
Out[105]: 
0    False
1    False
2     True
3     True
4    False
dtype: bool
```

``match``和``contains``的区别是是否严格匹配。``match``严格基于``re.match``，而``contains``基于``re.search``。

类似``match``, ``contains``, ``startswith`` 和 ``endswith`` 可以传入一个额外的``na``参数，因此，因此缺失值在匹配时可以被认为是``True``或者``False``：

``` python
In [106]: s4 = pd.Series(['A', 'B', 'C', 'Aaba', 'Baca', np.nan, 'CABA', 'dog', 'cat'])

In [107]: s4.str.contains('A', na=False)
Out[107]: 
0     True
1    False
2    False
3     True
4    False
5    False
6     True
7    False
8    False
dtype: bool
```

## 建立一个指示变量

你从字符串列可以抽出一个哑变量。例如，是否他们由``|``分割:

``` python
In [108]: s = pd.Series(['a', 'a|b', np.nan, 'a|c'])

In [109]: s.str.get_dummies(sep='|')
Out[109]: 
   a  b  c
0  1  0  0
1  1  1  0
2  0  0  0
3  1  0  1
```

索引也支持``get_dummies``，它返回一个多重索引：

*v0.18.1. 新加入* 

``` python
In [110]: idx = pd.Index(['a', 'a|b', np.nan, 'a|c'])

In [111]: idx.str.get_dummies(sep='|')
Out[111]: 
MultiIndex([(1, 0, 0),
            (1, 1, 0),
            (0, 0, 0),
            (1, 0, 1)],
           names=['a', 'b', 'c'])
```

参见 [``get_dummies()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.get_dummies.html#pandas.get_dummies).

## 方法总览

方法 | 描述
---|---
[cat()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.cat.html#pandas.Series.str.cat) | 拼接字符串
[split()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.split.html#pandas.Series.str.split) | 基于分隔符切分字符串
[rsplit()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.rsplit.html#pandas.Series.str.rsplit) | 基于分隔符，逆向切分字符串
[get()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.get.html#pandas.Series.str.get) | 索引每一个元素（返回第i个元素）
[join()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.join.html#pandas.Series.str.join) | 使用传入的分隔符依次拼接每一个元素
[get_dummies()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.get_dummies.html#pandas.Series.str.get_dummies) | 用分隔符切分字符串，并返回一个含有哑变量的数据表 
[contains()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.contains.html#pandas.Series.str.contains) | 返回一个布尔矩阵表明是每个元素包含字符串或正则表达式
[replace()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.replace.html#pandas.Series.str.replace) | 将匹配到的子串或正则表达式替换为另外的字符串，或者一个可调用对象的返回值
[repeat()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.repeat.html#pandas.Series.str.repeat) | 值复制（s.str.repeat(3)等价于x * 3）
[pad()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.pad.html#pandas.Series.str.pad) | 将白空格插入到字符串的左、右或者两端
[center()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.center.html#pandas.Series.str.center) | 等价于``str.center`` 
[ljust()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.ljust.html#pandas.Series.str.ljust) | 等价于``str.ljust``
[rjust()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.rjust.html#pandas.Series.str.rjust) | 等价于``str.rjust`` 
[zfill()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.zfill.html#pandas.Series.str.zfill) | 等价于``str.zfill``
[wrap()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.wrap.html#pandas.Series.str.wrap) | 将长字符串转换为不长于给定长度的行
[slice()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.slice.html#pandas.Series.str.slice) | 将序列中的每一个字符串切片
[slice_replace()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.slice_replace.html#pandas.Series.str.slice_replace) | 用传入的值替换每一个字串中的切片
[count()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.count.html#pandas.Series.str.count) | 对出现符合的规则进行计数
[startswith()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.startswith.html#pandas.Series.str.startswith) | 等价于``str.startswith(pat)`` 
[endswith()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.endswith.html#pandas.Series.str.endswith) | 等价于 ``str.endswith(pat)`` 
[findall()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.findall.html#pandas.Series.str.findall) | 返回每一个字串中出现的所有满足样式或正则的匹配
[match()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.match.html#pandas.Series.str.match) | 素调用 ``re.match``，并以列表形式返回匹配到的组
[extract()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.extract.html#pandas.Series.str.extract) | Call 对每一个元素调用 ``re.search``, 并以数据表的形式返回。行对应原有的一个元素，列对应所有捕获的组
[extractall()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.extractall.html#pandas.Series.str.extractall) | 一个元素调用 ``re.findall``, 并以数据表的形式返回。行对应原有的一个元素，列对应所有捕获的组
[len()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.len.html#pandas.Series.str.len) | 计算字符串长度
[strip()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.strip.html#pandas.Series.str.strip) | 等价于``str.strip`` 
[rstrip()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.rstrip.html#pandas.Series.str.rstrip) | 等价于``str.rstrip``
[lstrip()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.lstrip.html#pandas.Series.str.lstrip) | 等价于``str.lstrip``
[partition()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.partition.html#pandas.Series.str.partition) | 等价于 ``str.partition``
[rpartition()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.rpartition.html#pandas.Series.str.rpartition) | 等价于 ``str.rpartition``
[lower()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.lower.html#pandas.Series.str.lower) | 等价于 ``str.lower``
[casefold()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.casefold.html#pandas.Series.str.casefold) | 等价于 ``str.casefold``
[upper()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.upper.html#pandas.Series.str.upper) | 等价于 ``str.upper`` 
[find()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.find.html#pandas.Series.str.find) | 等价于``str.find``
[rfind()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.rfind.html#pandas.Series.str.rfind) | 等价于 ``str.rfind`` 
[index()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.index.html#pandas.Series.str.index) | 等价于 ``str.index``
[rindex()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.rindex.html#pandas.Series.str.rindex) | 等价于 ``str.rindex``
[capitalize()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.capitalize.html#pandas.Series.str.capitalize) | 等价于 ``str.capitalize``
[swapcase()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.swapcase.html#pandas.Series.str.swapcase) | 等价于 ``str.swapcase``
[normalize()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.normalize.html#pandas.Series.str.normalize) | 返回Unicode 标注格式。等价于 unicodedata.normalize
[translate()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.translate.html#pandas.Series.str.translate) | 等价于 ``str.translate``
[isalnum()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.isalnum.html#pandas.Series.str.isalnum) | 等价于 ``str.isalnum`` 
[isalpha()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.isalpha.html#pandas.Series.str.isalpha) | 等价于 ``str.isalpha`` 
[isdigit()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.isdigit.html#pandas.Series.str.isdigit) | 等价于 ``str.isdigit``
[isspace()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.isspace.html#pandas.Series.str.isspace) |  等价于 ``str.isspace``
[islower()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.islower.html#pandas.Series.str.islower) | 等价于 ``str.islower``
[isupper()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.isupper.html#pandas.Series.str.isupper) | 等价于 ``str.isupper``
[istitle()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.istitle.html#pandas.Series.str.istitle) | 等价于 ``str.istitle``
[isnumeric()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.isnumeric.html#pandas.Series.str.isnumeric) | 等价于 ``str.isnumeric``
[isdecimal()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.isdecimal.html#pandas.Series.str.isdecimal) |  等价于 ``str.isdecimal``
