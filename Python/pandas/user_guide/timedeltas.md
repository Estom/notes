# 时间差

`Timedelta`，时间差，即时间之间的差异，用 `日、时、分、秒` 等时间单位表示，时间单位可为正，也可为负。

`Timedelta` 是 `datetime.timedelta` 的子类，两者的操作方式相似，但 `Timedelta` 兼容 `np.timedelta64` 等数据类型，还支持自定义表示形式、能解析多种类型的数据，并支持自有属性。

## 解析数据，生成时间差

`Timedelta()` 支持用多种参数生成时间差：

``` python
In [1]: import datetime

# 字符串
In [2]: pd.Timedelta('1 days')
Out[2]: Timedelta('1 days 00:00:00')

In [3]: pd.Timedelta('1 days 00:00:00')
Out[3]: Timedelta('1 days 00:00:00')

In [4]: pd.Timedelta('1 days 2 hours')
Out[4]: Timedelta('1 days 02:00:00')

In [5]: pd.Timedelta('-1 days 2 min 3us')
Out[5]: Timedelta('-2 days +23:57:59.999997')

# datetime.timedelta
# 注意：必须指定关键字参数
In [6]: pd.Timedelta(days=1, seconds=1)
Out[6]: Timedelta('1 days 00:00:01')

# 用整数与时间单位生成时间差
In [7]: pd.Timedelta(1, unit='d')
Out[7]: Timedelta('1 days 00:00:00')

# datetime.timedelta 与 np.timedelta64
In [8]: pd.Timedelta(datetime.timedelta(days=1, seconds=1))
Out[8]: Timedelta('1 days 00:00:01')

In [9]: pd.Timedelta(np.timedelta64(1, 'ms'))
Out[9]: Timedelta('0 days 00:00:00.001000')

# 用字符串表示负数时间差
# 更接近 datetime.timedelta
In [10]: pd.Timedelta('-1us')
Out[10]: Timedelta('-1 days +23:59:59.999999')

# 时间差缺失值
In [11]: pd.Timedelta('nan')
Out[11]: NaT

In [12]: pd.Timedelta('nat')
Out[12]: NaT

# ISO8601 时间格式字符串
In [13]: pd.Timedelta('P0DT0H1M0S')
Out[13]: Timedelta('0 days 00:01:00')

In [14]: pd.Timedelta('P0DT0H0M0.000000123S')
Out[14]: Timedelta('0 days 00:00:00.000000')
```

*0.23.0 版新增*：增加了用 [ISO8601 时间格式](https://en.wikipedia.org/wiki/ISO_8601#Durations)生成时间差。

[DateOffsets](https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#timeseries-offsets)（`Day`、`Hour`、`Minute`、`Second`、`Milli`、`Micro`、`Nano`）也可以用来生成时间差。

``` python
In [15]: pd.Timedelta(pd.offsets.Second(2))
Out[15]: Timedelta('0 days 00:00:02')
```

标量运算生成的也是 `Timedelta` 标量。

``` python
In [16]: pd.Timedelta(pd.offsets.Day(2)) + pd.Timedelta(pd.offsets.Second(2)) +\
   ....:     pd.Timedelta('00:00:00.000123')
   ....: 
Out[16]: Timedelta('2 days 00:00:02.000123')
```

### to_timedelta

`pd.to_timedelta()` 可以把符合时间差格式的标量、数组、列表、序列等数据转换为`Timedelta`。输入数据是序列，输出的就是序列，输入数据是标量，输出的就是标量，其它形式的输入数据则输出 `TimedeltaIndex`。

`to_timedelta()` 可以解析单个字符串：

``` python
In [17]: pd.to_timedelta('1 days 06:05:01.00003')
Out[17]: Timedelta('1 days 06:05:01.000030')

In [18]: pd.to_timedelta('15.5us')
Out[18]: Timedelta('0 days 00:00:00.000015')
```

还能解析字符串列表或数组：

``` python
In [19]: pd.to_timedelta(['1 days 06:05:01.00003', '15.5us', 'nan'])
Out[19]: TimedeltaIndex(['1 days 06:05:01.000030', '0 days 00:00:00.000015', NaT], dtype='timedelta64[ns]', freq=None)
```

`unit` 关键字参数指定时间差的单位：

``` python
In [20]: pd.to_timedelta(np.arange(5), unit='s')
Out[20]: TimedeltaIndex(['00:00:00', '00:00:01', '00:00:02', '00:00:03', '00:00:04'], dtype='timedelta64[ns]', freq=None)

In [21]: pd.to_timedelta(np.arange(5), unit='d')
Out[21]: TimedeltaIndex(['0 days', '1 days', '2 days', '3 days', '4 days'], dtype='timedelta64[ns]', freq=None)
```

### 时间差界限

Pandas 时间差的纳秒解析度是 64 位整数，这就决定了 `Timedelta` 的上下限。

``` python
In [22]: pd.Timedelta.min
Out[22]: Timedelta('-106752 days +00:12:43.145224')

In [23]: pd.Timedelta.max
Out[23]: Timedelta('106751 days 23:47:16.854775')
```

## 运算

以时间差为数据的 `Series` 与 `DataFrame` 支持各种运算，`datetime64 [ns]` 序列或 `Timestamps` 减法运算生成的是`timedelta64 [ns]` 序列。

``` python
In [24]: s = pd.Series(pd.date_range('2012-1-1', periods=3, freq='D'))

In [25]: td = pd.Series([pd.Timedelta(days=i) for i in range(3)])

In [26]: df = pd.DataFrame({'A': s, 'B': td})

In [27]: df
Out[27]: 
           A      B
0 2012-01-01 0 days
1 2012-01-02 1 days
2 2012-01-03 2 days

In [28]: df['C'] = df['A'] + df['B']

In [29]: df
Out[29]: 
           A      B          C
0 2012-01-01 0 days 2012-01-01
1 2012-01-02 1 days 2012-01-03
2 2012-01-03 2 days 2012-01-05

In [30]: df.dtypes
Out[30]: 
A     datetime64[ns]
B    timedelta64[ns]
C     datetime64[ns]
dtype: object

In [31]: s - s.max()
Out[31]: 
0   -2 days
1   -1 days
2    0 days
dtype: timedelta64[ns]

In [32]: s - datetime.datetime(2011, 1, 1, 3, 5)
Out[32]: 
0   364 days 20:55:00
1   365 days 20:55:00
2   366 days 20:55:00
dtype: timedelta64[ns]

In [33]: s + datetime.timedelta(minutes=5)
Out[33]: 
0   2012-01-01 00:05:00
1   2012-01-02 00:05:00
2   2012-01-03 00:05:00
dtype: datetime64[ns]

In [34]: s + pd.offsets.Minute(5)
Out[34]: 
0   2012-01-01 00:05:00
1   2012-01-02 00:05:00
2   2012-01-03 00:05:00
dtype: datetime64[ns]

In [35]: s + pd.offsets.Minute(5) + pd.offsets.Milli(5)
Out[35]: 
0   2012-01-01 00:05:00.005
1   2012-01-02 00:05:00.005
2   2012-01-03 00:05:00.005
dtype: datetime64[ns]
```

`timedelta64 [ns]` 序列的标量运算：

``` python
In [36]: y = s - s[0]

In [37]: y
Out[37]: 
0   0 days
1   1 days
2   2 days
dtype: timedelta64[ns]
```

时间差序列支持 `NaT` 值：

``` python
In [38]: y = s - s.shift()

In [39]: y
Out[39]: 
0      NaT
1   1 days
2   1 days
dtype: timedelta64[ns]
```

与 `datetime` 类似，`np.nan` 把时间差设置为 `NaT`：

``` python
In [40]: y[1] = np.nan

In [41]: y
Out[41]: 
0      NaT
1      NaT
2   1 days
dtype: timedelta64[ns]
```

运算符也可以显示为逆序（序列与单个对象的运算）：

``` python
In [42]: s.max() - s
Out[42]: 
0   2 days
1   1 days
2   0 days
dtype: timedelta64[ns]

In [43]: datetime.datetime(2011, 1, 1, 3, 5) - s
Out[43]: 
0   -365 days +03:05:00
1   -366 days +03:05:00
2   -367 days +03:05:00
dtype: timedelta64[ns]

In [44]: datetime.timedelta(minutes=5) + s
Out[44]: 
0   2012-01-01 00:05:00
1   2012-01-02 00:05:00
2   2012-01-03 00:05:00
dtype: datetime64[ns]
```

`DataFrame` 支持 `min`、`max` 及 `idxmin`、`idxmax` 运算：

``` python
In [45]: A = s - pd.Timestamp('20120101') - pd.Timedelta('00:05:05')

In [46]: B = s - pd.Series(pd.date_range('2012-1-2', periods=3, freq='D'))

In [47]: df = pd.DataFrame({'A': A, 'B': B})

In [48]: df
Out[48]: 
                  A       B
0 -1 days +23:54:55 -1 days
1   0 days 23:54:55 -1 days
2   1 days 23:54:55 -1 days

In [49]: df.min()
Out[49]: 
A   -1 days +23:54:55
B   -1 days +00:00:00
dtype: timedelta64[ns]

In [50]: df.min(axis=1)
Out[50]: 
0   -1 days
1   -1 days
2   -1 days
dtype: timedelta64[ns]

In [51]: df.idxmin()
Out[51]: 
A    0
B    0
dtype: int64

In [52]: df.idxmax()
Out[52]: 
A    2
B    0
dtype: int64
```

`Series` 也支持`min`、`max` 及 `idxmin`、`idxmax` 运算。标量计算结果为 `Timedelta`。

``` python
In [53]: df.min().max()
Out[53]: Timedelta('-1 days +23:54:55')

In [54]: df.min(axis=1).min()
Out[54]: Timedelta('-1 days +00:00:00')

In [55]: df.min().idxmax()
Out[55]: 'A'

In [56]: df.min(axis=1).idxmin()
Out[56]: 0
```

时间差支持 `fillna` 函数，参数是 `Timedelta`，用于指定填充值。

``` python
In [57]: y.fillna(pd.Timedelta(0))
Out[57]: 
0   0 days
1   0 days
2   1 days
dtype: timedelta64[ns]

In [58]: y.fillna(pd.Timedelta(10, unit='s'))
Out[58]: 
0   0 days 00:00:10
1   0 days 00:00:10
2   1 days 00:00:00
dtype: timedelta64[ns]

In [59]: y.fillna(pd.Timedelta('-1 days, 00:00:05'))
Out[59]: 
0   -1 days +00:00:05
1   -1 days +00:00:05
2     1 days 00:00:00
dtype: timedelta64[ns]
```

`Timedelta` 还支持取反、乘法及绝对值（`Abs`）运算：

``` python
In [60]: td1 = pd.Timedelta('-1 days 2 hours 3 seconds')

In [61]: td1
Out[61]: Timedelta('-2 days +21:59:57')

In [62]: -1 * td1
Out[62]: Timedelta('1 days 02:00:03')

In [63]: - td1
Out[63]: Timedelta('1 days 02:00:03')

In [64]: abs(td1)
Out[64]: Timedelta('1 days 02:00:03')
```

## 归约

`timedelta64 [ns]` 数值归约运算返回的是 `Timedelta` 对象。 一般情况下，`NaT` 不计数。

``` python
In [65]: y2 = pd.Series(pd.to_timedelta(['-1 days +00:00:05', 'nat',
   ....:                                 '-1 days +00:00:05', '1 days']))
   ....: 

In [66]: y2
Out[66]: 
0   -1 days +00:00:05
1                 NaT
2   -1 days +00:00:05
3     1 days 00:00:00
dtype: timedelta64[ns]

In [67]: y2.mean()
Out[67]: Timedelta('-1 days +16:00:03.333333')

In [68]: y2.median()
Out[68]: Timedelta('-1 days +00:00:05')

In [69]: y2.quantile(.1)
Out[69]: Timedelta('-1 days +00:00:05')

In [70]: y2.sum()
Out[70]: Timedelta('-1 days +00:00:10')
```

## 频率转换

时间差除法把 `Timedelta` 序列、`TimedeltaIndex`、`Timedelta` 标量转换为其它“频率”，`astype` 也可以将之转换为指定的时间差。这些运算生成的是序列，并把 `NaT` 转换为 `nan`。 注意，NumPy 标量除法是真除法，`astype` 则等同于取底整除（Floor Division）。

::: tip 说明

Floor Division ，即两数的商为向下取整，如，9 / 2 = 4。又译作地板除或向下取整除，本文译作**取底整除**；
 
扩展知识：

Ceiling Division，即两数的商为向上取整，如，9 / 2 = 5。又译作屋顶除或向上取整除，本文译作**取顶整除**。
 
:::

``` python
In [71]: december = pd.Series(pd.date_range('20121201', periods=4))

In [72]: january = pd.Series(pd.date_range('20130101', periods=4))

In [73]: td = january - december

In [74]: td[2] += datetime.timedelta(minutes=5, seconds=3)

In [75]: td[3] = np.nan

In [76]: td
Out[76]: 
0   31 days 00:00:00
1   31 days 00:00:00
2   31 days 00:05:03
3                NaT
dtype: timedelta64[ns]

# 转为日
In [77]: td / np.timedelta64(1, 'D')
Out[77]: 
0    31.000000
1    31.000000
2    31.003507
3          NaN
dtype: float64

In [78]: td.astype('timedelta64[D]')
Out[78]: 
0    31.0
1    31.0
2    31.0
3     NaN
dtype: float64

# 转为秒
In [79]: td / np.timedelta64(1, 's')
Out[79]: 
0    2678400.0
1    2678400.0
2    2678703.0
3          NaN
dtype: float64

In [80]: td.astype('timedelta64[s]')
Out[80]: 
0    2678400.0
1    2678400.0
2    2678703.0
3          NaN
dtype: float64

# 转为月 （此处用常量表示）
In [81]: td / np.timedelta64(1, 'M')
Out[81]: 
0    1.018501
1    1.018501
2    1.018617
3         NaN
dtype: float64
```

`timedelta64 [ns]` 序列与整数或整数序列相乘或相除，生成的也是 `timedelta64 [ns]` 序列。

``` python
In [82]: td * -1
Out[82]: 
0   -31 days +00:00:00
1   -31 days +00:00:00
2   -32 days +23:54:57
3                  NaT
dtype: timedelta64[ns]

In [83]: td * pd.Series([1, 2, 3, 4])
Out[83]: 
0   31 days 00:00:00
1   62 days 00:00:00
2   93 days 00:15:09
3                NaT
dtype: timedelta64[ns]
```

`timedelta64 [ns]` 序列与 `Timedelta` 标量相除的结果为取底整除的整数序列。


``` python
In [84]: td // pd.Timedelta(days=3, hours=4)
Out[84]: 
0    9.0
1    9.0
2    9.0
3    NaN
dtype: float64

In [85]: pd.Timedelta(days=3, hours=4) // td
Out[85]: 
0    0.0
1    0.0
2    0.0
3    NaN
dtype: float64
```

`Timedelta` 的求余（`mod(%)`）与除余（`divmod`）运算，支持时间差与数值参数。

``` python
In [86]: pd.Timedelta(hours=37) % datetime.timedelta(hours=2)
Out[86]: Timedelta('0 days 01:00:00')

# 除余运算的参数为时间差时，返回一对值（int, Timedelta）
In [87]: divmod(datetime.timedelta(hours=2), pd.Timedelta(minutes=11))
Out[87]: (10, Timedelta('0 days 00:10:00'))

# 除余运算的参数为数值时，也返回一对值（Timedelta, Timedelta）
In [88]: divmod(pd.Timedelta(hours=25), 86400000000000)
Out[88]: (Timedelta('0 days 00:00:00.000000'), Timedelta('0 days 01:00:00'))
```

## 属性

`Timedelta` 或 `TimedeltaIndex` 的组件可以直接访问 `days`、`seconds`、`microseconds`、`nanoseconds` 等属性。这些属性与`datetime.timedelta` 的返回值相同，例如，`.seconds` 属性表示大于等于 0 天且小于 1 天的秒数。带符号的 `Timedelta` 返回的值也带符号。

`Series` 的 `.dt` 属性也可以直接访问这些数据。

::: tip 注意

这些属性**不是** `Timedelta` 显示的值。`.components` 可以提取显示的值。

:::

对于 `Series`：

``` python
In [89]: td.dt.days
Out[89]: 
0    31.0
1    31.0
2    31.0
3     NaN
dtype: float64

In [90]: td.dt.seconds
Out[90]: 
0      0.0
1      0.0
2    303.0
3      NaN
dtype: float64
```

直接访问 `Timedelta` 标量字段值。

``` python
In [91]: tds = pd.Timedelta('31 days 5 min 3 sec')

In [92]: tds.days
Out[92]: 31

In [93]: tds.seconds
Out[93]: 303

In [94]: (-tds).seconds
Out[94]: 86097
```

`.components` 属性可以快速访问时间差的组件，返回结果是 `DataFrame`。 下列代码输出 `Timedelta` 的显示值。

``` python
In [95]: td.dt.components
Out[95]: 
   days  hours  minutes  seconds  milliseconds  microseconds  nanoseconds
0  31.0    0.0      0.0      0.0           0.0           0.0          0.0
1  31.0    0.0      0.0      0.0           0.0           0.0          0.0
2  31.0    0.0      5.0      3.0           0.0           0.0          0.0
3   NaN    NaN      NaN      NaN           NaN           NaN          NaN

In [96]: td.dt.components.seconds
Out[96]: 
0    0.0
1    0.0
2    3.0
3    NaN
Name: seconds, dtype: float64
```

`.isoformat` 方法可以把 `Timedelta` 转换为 [ISO8601 时间格式](https://en.wikipedia.org/wiki/ISO_8601#Durations)字符串。

*0.20.0 版新增。*

``` python
In [97]: pd.Timedelta(days=6, minutes=50, seconds=3,
   ....:              milliseconds=10, microseconds=10,
   ....:              nanoseconds=12).isoformat()
   ....: 
Out[97]: 'P6DT0H50M3.010010012S'
```

## TimedeltaIndex

[`TimedeltaIndex`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.TimedeltaIndex.html#pandas.TimedeltaIndex)  或 [`timedelta_range()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.timedelta_range.html#pandas.timedelta_range) 可以生成时间差索引。

`TimedeltaIndex` 支持字符串型的 `Timedelta`、`timedelta` 或 `np.timedelta64`对象。

`np.nan`、`pd.NaT`、`nat` 代表缺失值。

``` python
In [98]: pd.TimedeltaIndex(['1 days', '1 days, 00:00:05', np.timedelta64(2, 'D'),
   ....:                    datetime.timedelta(days=2, seconds=2)])
   ....: 
Out[98]: 
TimedeltaIndex(['1 days 00:00:00', '1 days 00:00:05', '2 days 00:00:00',
                '2 days 00:00:02'],
               dtype='timedelta64[ns]', freq=None)
```

`freq` 关键字参数为 `infer` 时，`TimedeltaIndex` 可以自行推断时间频率：

``` python
In [99]: pd.TimedeltaIndex(['0 days', '10 days', '20 days'], freq='infer')
Out[99]: TimedeltaIndex(['0 days', '10 days', '20 days'], dtype='timedelta64[ns]', freq='10D')
```

### 生成时间差范围

与 [`date_range()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.date_range.html#pandas.date_range) 相似，[`timedelta_range()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.timedelta_range.html#pandas.timedelta_range) 可以生成定频 `TimedeltaIndex`，`timedelta_range` 的默认频率是日历日：

``` python
In [100]: pd.timedelta_range(start='1 days', periods=5)
Out[100]: TimedeltaIndex(['1 days', '2 days', '3 days', '4 days', '5 days'], dtype='timedelta64[ns]', freq='D')
```

`timedelta_range` 支持 `start`、`end`、`periods` 三个参数：

``` python
In [101]: pd.timedelta_range(start='1 days', end='5 days')
Out[101]: TimedeltaIndex(['1 days', '2 days', '3 days', '4 days', '5 days'], dtype='timedelta64[ns]', freq='D')

In [102]: pd.timedelta_range(end='10 days', periods=4)
Out[102]: TimedeltaIndex(['7 days', '8 days', '9 days', '10 days'], dtype='timedelta64[ns]', freq='D')
```

`freq` 参数支持各种[频率别名](https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#timeseries-offset-aliases)：

``` python
In [103]: pd.timedelta_range(start='1 days', end='2 days', freq='30T')
Out[103]: 
TimedeltaIndex(['1 days 00:00:00', '1 days 00:30:00', '1 days 01:00:00',
                '1 days 01:30:00', '1 days 02:00:00', '1 days 02:30:00',
                '1 days 03:00:00', '1 days 03:30:00', '1 days 04:00:00',
                '1 days 04:30:00', '1 days 05:00:00', '1 days 05:30:00',
                '1 days 06:00:00', '1 days 06:30:00', '1 days 07:00:00',
                '1 days 07:30:00', '1 days 08:00:00', '1 days 08:30:00',
                '1 days 09:00:00', '1 days 09:30:00', '1 days 10:00:00',
                '1 days 10:30:00', '1 days 11:00:00', '1 days 11:30:00',
                '1 days 12:00:00', '1 days 12:30:00', '1 days 13:00:00',
                '1 days 13:30:00', '1 days 14:00:00', '1 days 14:30:00',
                '1 days 15:00:00', '1 days 15:30:00', '1 days 16:00:00',
                '1 days 16:30:00', '1 days 17:00:00', '1 days 17:30:00',
                '1 days 18:00:00', '1 days 18:30:00', '1 days 19:00:00',
                '1 days 19:30:00', '1 days 20:00:00', '1 days 20:30:00',
                '1 days 21:00:00', '1 days 21:30:00', '1 days 22:00:00',
                '1 days 22:30:00', '1 days 23:00:00', '1 days 23:30:00',
                '2 days 00:00:00'],
               dtype='timedelta64[ns]', freq='30T')

In [104]: pd.timedelta_range(start='1 days', periods=5, freq='2D5H')
Out[104]: 
TimedeltaIndex(['1 days 00:00:00', '3 days 05:00:00', '5 days 10:00:00',
                '7 days 15:00:00', '9 days 20:00:00'],
               dtype='timedelta64[ns]', freq='53H')
```

*0.23.0 版新增*。

用 `start`、`end`、`period` 可以生成等宽时间差范围，其中，`start` 与 `end`（含）是起止两端的时间，`periods` 为 `TimedeltaIndex` 里的元素数量：

``` python
In [105]: pd.timedelta_range('0 days', '4 days', periods=5)
Out[105]: TimedeltaIndex(['0 days', '1 days', '2 days', '3 days', '4 days'], dtype='timedelta64[ns]', freq=None)

In [106]: pd.timedelta_range('0 days', '4 days', periods=10)
Out[106]: 
TimedeltaIndex(['0 days 00:00:00', '0 days 10:40:00', '0 days 21:20:00',
                '1 days 08:00:00', '1 days 18:40:00', '2 days 05:20:00',
                '2 days 16:00:00', '3 days 02:40:00', '3 days 13:20:00',
                '4 days 00:00:00'],
               dtype='timedelta64[ns]', freq=None)
```

### TimedeltaIndex 应用

与 `DatetimeIndex`、`PeriodIndex` 等 `datetime` 型索引类似，`TimedeltaIndex` 也可当作 pandas 对象的索引。

``` python
In [107]: s = pd.Series(np.arange(100),
   .....:               index=pd.timedelta_range('1 days', periods=100, freq='h'))
   .....: 

In [108]: s
Out[108]: 
1 days 00:00:00     0
1 days 01:00:00     1
1 days 02:00:00     2
1 days 03:00:00     3
1 days 04:00:00     4
                   ..
4 days 23:00:00    95
5 days 00:00:00    96
5 days 01:00:00    97
5 days 02:00:00    98
5 days 03:00:00    99
Freq: H, Length: 100, dtype: int64
```

选择操作也差不多，可以强制转换字符串与切片：

``` python
In [109]: s['1 day':'2 day']
Out[109]: 
1 days 00:00:00     0
1 days 01:00:00     1
1 days 02:00:00     2
1 days 03:00:00     3
1 days 04:00:00     4
                   ..
2 days 19:00:00    43
2 days 20:00:00    44
2 days 21:00:00    45
2 days 22:00:00    46
2 days 23:00:00    47
Freq: H, Length: 48, dtype: int64

In [110]: s['1 day 01:00:00']
Out[110]: 1

In [111]: s[pd.Timedelta('1 day 1h')]
Out[111]: 1
```

`TimedeltaIndex` 还支持局部字符串选择，并且可以推断选择范围：

``` python
In [112]: s['1 day':'1 day 5 hours']
Out[112]: 
1 days 00:00:00    0
1 days 01:00:00    1
1 days 02:00:00    2
1 days 03:00:00    3
1 days 04:00:00    4
1 days 05:00:00    5
Freq: H, dtype: int64
```

### TimedeltaIndex 运算

`TimedeltaIndex` 与 `DatetimeIndex` 运算可以保留 `NaT` 值：

``` python
In [113]: tdi = pd.TimedeltaIndex(['1 days', pd.NaT, '2 days'])

In [114]: tdi.to_list()
Out[114]: [Timedelta('1 days 00:00:00'), NaT, Timedelta('2 days 00:00:00')]

In [115]: dti = pd.date_range('20130101', periods=3)

In [116]: dti.to_list()
Out[116]: 
[Timestamp('2013-01-01 00:00:00', freq='D'),
 Timestamp('2013-01-02 00:00:00', freq='D'),
 Timestamp('2013-01-03 00:00:00', freq='D')]

In [117]: (dti + tdi).to_list()
Out[117]: [Timestamp('2013-01-02 00:00:00'), NaT, Timestamp('2013-01-05 00:00:00')]

In [118]: (dti - tdi).to_list()
Out[118]: [Timestamp('2012-12-31 00:00:00'), NaT, Timestamp('2013-01-01 00:00:00')]
```

### 转换

与 `Series` 频率转换类似，可以把 `TimedeltaIndex` 转换为其它索引。

``` python
In [119]: tdi / np.timedelta64(1, 's')
Out[119]: Float64Index([86400.0, nan, 172800.0], dtype='float64')

In [120]: tdi.astype('timedelta64[s]')
Out[120]: Float64Index([86400.0, nan, 172800.0], dtype='float64')
```

与标量操作类似，会返回**不同**类型的索引。

``` python
# 时间差与日期相加，结果为日期型索引（DatetimeIndex）
In [121]: tdi + pd.Timestamp('20130101')
Out[121]: DatetimeIndex(['2013-01-02', 'NaT', '2013-01-03'], dtype='datetime64[ns]', freq=None)

# 日期与时间戳相减，结果为日期型数据（Timestamp）
# note that trying to subtract a date from a Timedelta will raise an exception
In [122]: (pd.Timestamp('20130101') - tdi).to_list()
Out[122]: [Timestamp('2012-12-31 00:00:00'), NaT, Timestamp('2012-12-30 00:00:00')]

# 时间差与时间差相加，结果还是时间差索引
In [123]: tdi + pd.Timedelta('10 days')
Out[123]: TimedeltaIndex(['11 days', NaT, '12 days'], dtype='timedelta64[ns]', freq=None)

# 除数是整数，则结果为时间差索引
In [124]: tdi / 2
Out[124]: TimedeltaIndex(['0 days 12:00:00', NaT, '1 days 00:00:00'], dtype='timedelta64[ns]', freq=None)

# 除数是时间差，则结果为 Float64Index
In [125]: tdi / tdi[0]
Out[125]: Float64Index([1.0, nan, 2.0], dtype='float64')
```

## 重采样

与[时间序列重采样](https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#timeseries-resampling)一样，`TimedeltaIndex` 也支持重采样。

``` python
In [126]: s.resample('D').mean()
Out[126]: 
1 days    11.5
2 days    35.5
3 days    59.5
4 days    83.5
5 days    97.5
Freq: D, dtype: float64
```