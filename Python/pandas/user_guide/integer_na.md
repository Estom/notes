---
meta:
  - name: keywords
    content: Nullable,整型数据类型
  - name: description
    content: 在处理丢失的数据部分, 我们知道pandas主要使用 NaN 来代表丢失数据。因为 NaN 属于浮点型数据，这强制有缺失值的整型array强制转换成浮点型。
---

# Nullable整型数据类型

*在0.24.0版本中新引入* 

::: tip 小贴士

IntegerArray目前属于实验性阶段，因此他的API或者使用方式可能会在没有提示的情况下更改。

:::

在 [处理丢失的数据](missing_data.html#missing-data)部分, 我们知道pandas主要使用 ``NaN`` 来代表丢失数据。因为 ``NaN`` 属于浮点型数据，这强制有缺失值的整型array强制转换成浮点型。在某些情况下，这可能不会有太大影响，但是如果你的整型数据恰好是标识符，数据类型的转换可能会存在隐患。同时，某些整数无法使用浮点型来表示。

Pandas能够将可能存在缺失值的整型数据使用[``arrays.IntegerArray``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.arrays.IntegerArray.html#pandas.arrays.IntegerArray)来表示。这是pandas中内置的 [扩展方式](https://pandas.pydata.org/pandas-docs/stable/development/extending.html#extending-extension-types)。 它并不是整型数据组成array对象的默认方式，并且并不会被pandas直接使用。因此，如果你希望生成这种数据类型，你需要在生成[``array()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.array.html#pandas.array) 或者 [``Series``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.html#pandas.Series)时，在``dtype``变量中直接指定。

``` python
In [1]: arr = pd.array([1, 2, np.nan], dtype=pd.Int64Dtype())

In [2]: arr
Out[2]: 
<IntegerArray>
[1, 2, NaN]
Length: 3, dtype: Int64
```

或者使用字符串``"Int64"``（注意此处的 ``"I"``需要大写，以此和NumPy中的``'int64'``数据类型作出区别）：

``` python
In [3]: pd.array([1, 2, np.nan], dtype="Int64")
Out[3]: 
<IntegerArray>
[1, 2, NaN]
Length: 3, dtype: Int64
```

这样的array对象与NumPy的array对象类似，可以被存放在[``DataFrame``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html#pandas.DataFrame) 或 [``Series``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.html#pandas.Series)中。

``` python
In [4]: pd.Series(arr)
Out[4]: 
0      1
1      2
2    NaN
dtype: Int64
```

你也可以直接将列表形式的数据直接传入[``Series``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.html#pandas.Series)中，并指明``dtype``。

``` python
In [5]: s = pd.Series([1, 2, np.nan], dtype="Int64")

In [6]: s
Out[6]: 
0      1
1      2
2    NaN
dtype: Int64
```

默认情况下（如果你不指明``dtype``），则会使用NumPy来构建这个数据，最终你会得到``float64``类型的Series：

``` python
In [7]: pd.Series([1, 2, np.nan])
Out[7]: 
0    1.0
1    2.0
2    NaN
dtype: float64
```

对使用了整型array的操作与对NumPy中array的操作类似，缺失值会被继承并保留原本的数据类型，但在必要的情况下，数据类型也会发生转变。

``` python
# 运算
In [8]: s + 1
Out[8]: 
0      2
1      3
2    NaN
dtype: Int64

# 比较
In [9]: s == 1
Out[9]: 
0     True
1    False
2    False
dtype: bool

# 索引
In [10]: s.iloc[1:3]
Out[10]: 
1      2
2    NaN
dtype: Int64

# 和其他数据类型联合使用
In [11]: s + s.iloc[1:3].astype('Int8')
Out[11]: 
0    NaN
1      4
2    NaN
dtype: Int64

# 在必要情况下，数据类型发生转变
In [12]: s + 0.01
Out[12]: 
0    1.01
1    2.01
2     NaN
dtype: float64
```

这种数据类型可以作为 ``DataFrame``的一部分进行使用。

``` python
In [13]: df = pd.DataFrame({'A': s, 'B': [1, 1, 3], 'C': list('aab')})

In [14]: df
Out[14]: 
     A  B  C
0    1  1  a
1    2  1  a
2  NaN  3  b

In [15]: df.dtypes
Out[15]: 
A     Int64
B     int64
C    object
dtype: object
```

这种数据类型也可以在合并（merge）、重构（reshape）和类型转换（cast）。

``` python
In [16]: pd.concat([df[['A']], df[['B', 'C']]], axis=1).dtypes
Out[16]: 
A     Int64
B     int64
C    object
dtype: object

In [17]: df['A'].astype(float)
Out[17]: 
0    1.0
1    2.0
2    NaN
Name: A, dtype: float64
```

类似于求和的降维和分组操作也能正常使用。

``` python
In [18]: df.sum()
Out[18]: 
A      3
B      5
C    aab
dtype: object

In [19]: df.groupby('B').A.sum()
Out[19]: 
B
1    3
3    0
Name: A, dtype: Int64
```
