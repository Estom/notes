# IO工具（文本，CSV，HDF5，…）

pandas的I/O API是一组``read``函数，比如[``pandas.read_csv()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html#pandas.read_csv)函数。这类函数可以返回pandas对象。相应的``write``函数是像[``DataFrame.to_csv()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_csv.html#pandas.DataFrame.to_csv)一样的对象方法。下面是一个方法列表，包含了这里面的所有``readers``函数和``writer``函数。  

Format Type | Data Description | Reader | Writer
---|---|---|---
text | [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) | [read_csv](#io-read-csv-table) | [to_csv](#io-store-in-csv)
text | [JSON](https://www.json.org/) | [read_json](#io-json-reader) | [to_json](#io-json-writer)
text | [HTML](https://en.wikipedia.org/wiki/HTML) | [read_html](#io-read-html) | [to_html](#io-html)
text | Local clipboard | [read_clipboard](#io-clipboard) | [to_clipboard](#io-clipboard)
binary | [MS Excel](https://en.wikipedia.org/wiki/Microsoft_Excel) | [read_excel](#io-excel-reader) | [to_excel](#io-excel-writer)
binary | [OpenDocument](http://www.opendocumentformat.org) | [read_excel](#io-ods) |  
binary | [HDF5 Format](https://support.hdfgroup.org/HDF5/whatishdf5.html) | [read_hdf](#io-hdf5) | [to_hdf](#io-hdf5)
binary | [Feather Format](https://github.com/wesm/feather) | [read_feather](#io-feather) | [to_feather](#io-feather)
binary | [Parquet Format](https://parquet.apache.org/) | [read_parquet](#io-parquet) | [to_parquet](#io-parquet)
binary | [Msgpack](https://msgpack.org/index.html) | [read_msgpack](#io-msgpack) | [to_msgpack](#io-msgpack)
binary | [Stata](https://en.wikipedia.org/wiki/Stata) | [read_stata](#io-stata-reader) | [to_stata](#io-stata-writer)
binary | [SAS](https://en.wikipedia.org/wiki/SAS_(software)) | [read_sas](#io-sas-reader) |  
binary | [Python Pickle Format](https://docs.python.org/3/library/pickle.html) | [read_pickle](#io-pickle) | [to_pickle](#io-pickle)
[SQL](https://en.wikipedia.org/wiki/SQL) | SQL | [read_sql](#io-sql) | [to_sql](#io-sql)
SQL | [Google Big Query](https://en.wikipedia.org/wiki/BigQuery) | [read_gbq](#io-bigquery) | [to_gbq](#io-bigquery)

[Here](#io-perf) is an informal performance comparison for some of these IO methods.

::: tip 注意

比如在使用 ``StringIO`` 类时, 请先确定python的版本信息。也就是说，是使用python2的``from StringIO import StringIO``还是python3的``from io import StringIO``。

:::

## CSV & 文本文件

读文本文件 (a.k.a. flat files)的主要方法 is
[``read_csv()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html#pandas.read_csv). 关于一些更高级的用法请参阅[cookbook](cookbook.html#cookbook-csv)。

### 方法解析(Parsing options)

[``read_csv()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html#pandas.read_csv) 可接受以下常用参数:

#### 基础

filepath_or_buffer : *various* 

- 文件路径 (a [``str``](https://docs.python.org/3/library/stdtypes.html#str), [``pathlib.Path``](https://docs.python.org/3/library/pathlib.html#pathlib.Path),
or ``py._path.local.LocalPath``), URL (including http, ftp, and S3
locations), 或者具有 ``read()`` 方法的任何对象 (such as an open file or
[``StringIO``](https://docs.python.org/3/library/io.html#io.StringIO)).

sep : *str, 默认   [``read_csv()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html#pandas.read_csv)分隔符为``','``, [``read_table()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_table.html#pandas.read_table)方法，分隔符为 ``\t``* 

- 分隔符的使用. 如果分隔符为``None``，虽然C不能解析，但python解析引擎可解析，这意味着python将被使用，通过内置的sniffer tool自动检测分隔符,
[``csv.Sniffer``](https://docs.python.org/3/library/csv.html#csv.Sniffer). 除此之外,字符长度超过１并且不同于 ``'s+'`` 的将被视为正则表达式，并且将强制使用python解析引擎。需要注意的是，正则表达式易于忽略引用数据<font color='red'>（主要注意转义字符的使用）</font> 例如: ``'\\r\\t'``.

delimiter : *str, default ``None``* 

- sep的替代参数.

delim_whitespace : *boolean, default False* 

- 指定是否将空格 (e.g. ``' '`` or ``'\t'``)当作delimiter。
等价于设置 ``sep='\s+'``.
如果这个选项被设置为 ``True``,就不要给
``delimiter`` 传参了.

*version 0.18.1:* 支持Python解析器.

#### 列、索引、名称

header : *int or list of ints, default ``'infer'``* 

- 当选择默认值或``header=0``时，将首行设为列名。如果列名被传入明确值就令``header=None``。注意，当``header=0``时，即使列名被传参也会被覆盖。


- 标题可以是指定列上的MultiIndex的行位置的整数列表，例如 ``[0,1,3]``。在列名指定时，若某列未被指定，读取时将跳过该列 (例如 在下面的例子中第二列将被跳过).注意，如果 ``skip_blank_lines=True``，此参数将忽略空行和注释行, 因此 header=0 表示第一行数据而非文件的第一行.

names : *array-like, default ``None``* 

- 列名列表的使用. 如果文件不包含列名，那么应该设置``header=None``。 列名列表中不允许有重复值.

index_col : *int, str, sequence of int / str, or False, default ``None``* 

-  ``DataFrame``的行索引列表, 既可以是字符串名称也可以是列索引. 如果传入一个字符串序列或者整数序列,那么一定要使用多级索引（MultiIndex）.

- 注意: 当``index_col=False`` ，pandas不再使用首列作为索引。例如， 当你的文件是一个每行末尾都带有一个分割符的格式错误的文件时.

usecols : *list-like or callable, default ``None``* 

- 返回列名列表的子集. 如果该参数为列表形式, 那么所有元素应全为位置（即文档列中的整数索引）或者 全为相应列的列名字符串（这些列名字符串为*names*参数给出的或者文档的``header``行内容）.例如，一个有效的列表型参数
*usecols* 将会是是 ``[0, 1, 2]`` 或者 ``['foo', 'bar', 'baz']``.

- 元素顺序可忽略，因此 ``usecols=[0, 1]``等价于 ``[1, 0]``。如果想实例化一个自定义列顺序的DataFrame，请使用``pd.read_csv(data, usecols=['foo', 'bar'])[['foo', 'bar']]`` ，这样列的顺序为 ``['foo', 'bar']`` 。如果设置``pd.read_csv(data, usecols=['foo', 'bar'])[['bar', 'foo']]`` 那么列的顺序为``['bar', 'foo']`` 。

- 如果使用callable的方式, 可调用函数将根据列名计算，
返回可调用函数计算结果为True的名称:

``` python
In [1]: from io import StringIO, BytesIO

In [2]: data = ('col1,col2,col3\n'
   ...:         'a,b,1\n'
   ...:         'a,b,2\n'
   ...:         'c,d,3')
   ...: 

In [3]: pd.read_csv(StringIO(data))
Out[3]: 
  col1 col2  col3
0    a    b     1
1    a    b     2
2    c    d     3

In [4]: pd.read_csv(StringIO(data), usecols=lambda x: x.upper() in ['COL1', 'COL3'])
Out[4]: 
  col1  col3
0    a     1
1    a     2
2    c     3

```

使用此参数可以大大加快解析时间并降低内存使用率。

squeeze : *boolean, default ``False``* 

- 如果解析的数据仅包含一个列，那么结果将以 ``Series``的形式返回.

prefix : *str, default ``None``* 

- 当没有header时，可通过该参数为数字列名添加前缀, e.g. ‘X’ for X0, X1, …

mangle_dupe_cols : *boolean, default ``True``* 

- 当列名有重复时，解析列名将变为 ‘X’, ‘X.1’…’X.N’而不是 ‘X’…’X’。 如果该参数为 ``False`` ，那么当列名中有重复时，前列将会被后列覆盖。

#### 常规解析配置

dtype : *Type name or dict of column -> type, default ``None``* 

- 指定某列或整体数据的数据类型. E.g. ``{'a': np.float64, 'b': np.int32}``
(不支持 ``engine='python'``).将*str*或*object*与合适的设置一起使用以保留和不解释dtype。

- *New in version 0.20.0:* 支持python解析器.

engine : *{``'c'``, ``'python'``}* 

- 解析引擎的使用。 尽管C引擎速度更快，但是目前python引擎功能更加完美。

converters : *dict, default ``None``* 

- Dict of functions for converting values in certain columns. Keys can either be integers or column labels.

true_values : *list, default ``None``* 

- Values to consider as ``True``.

false_values : *list, default ``None``* 

- Values to consider as ``False``.

skipinitialspace : *boolean, default ``False``* 

- Skip spaces after delimiter.

skiprows : *list-like or integer, default ``None``* 

- Line numbers to skip (0-indexed) or number of lines to skip (int) at the start
of the file.

- If callable, the callable function will be evaluated against the row
indices, returning True if the row should be skipped and False otherwise:

``` python
In [5]: data = ('col1,col2,col3\n'
   ...:         'a,b,1\n'
   ...:         'a,b,2\n'
   ...:         'c,d,3')
   ...: 

In [6]: pd.read_csv(StringIO(data))
Out[6]: 
  col1 col2  col3
0    a    b     1
1    a    b     2
2    c    d     3

In [7]: pd.read_csv(StringIO(data), skiprows=lambda x: x % 2 != 0)
Out[7]: 
  col1 col2  col3
0    a    b     2

```

skipfooter : *int, default ``0``* 

- Number of lines at bottom of file to skip (unsupported with engine=’c’).

nrows : *int, default ``None``* 

- Number of rows of file to read. Useful for reading pieces of large files.

low_memory : *boolean, default ``True``* 

- Internally process the file in chunks, resulting in lower memory use
while parsing, but possibly mixed type inference.  To ensure no mixed
types either set ``False``, or specify the type with the ``dtype`` parameter.
Note that the entire file is read into a single ``DataFrame`` regardless,
use the ``chunksize`` or ``iterator`` parameter to return the data in chunks.
(Only valid with C parser)

memory_map : *boolean, default False* 

- If a filepath is provided for ``filepath_or_buffer``, map the file object
directly onto memory and access the data directly from there. Using this
option can improve performance because there is no longer any I/O overhead.

#### NA and missing data handling

na_values : *scalar, str, list-like, or dict, default ``None``* 

- Additional strings to recognize as NA/NaN. If dict passed, specific per-column
NA values. See [na values const](#io-navaluesconst) below
for a list of the values interpreted as NaN by default.

keep_default_na : *boolean, default ``True``* 

- Whether or not to include the default NaN values when parsing the data.
Depending on whether *na_values* is passed in, the behavior is as follows:
  - If *keep_default_na* is ``True``, and *na_values* are specified, *na_values*
  is appended to the default NaN values used for parsing.
  - If *keep_default_na* is ``True``, and *na_values* are not specified, only
  the default NaN values are used for parsing.
  - If *keep_default_na* is ``False``, and *na_values* are specified, only
  the NaN values specified *na_values* are used for parsing.
  - If *keep_default_na* is ``False``, and *na_values* are not specified, no
  strings will be parsed as NaN.

  Note that if *na_filter* is passed in as ``False``, the *keep_default_na* and *na_values* parameters will be ignored.

na_filter : *boolean, default ``True``* 

- Detect missing value markers (empty strings and the value of na_values). In data without any NAs, passing ``na_filter=False`` can improve the performance of reading a large file.

verbose : *boolean, default ``False``* 

- Indicate number of NA values placed in non-numeric columns.

skip_blank_lines : *boolean, default ``True``* 

- If ``True``, skip over blank lines rather than interpreting as NaN values.

#### Datetime handling

parse_dates : *boolean or list of ints or names or list of lists or dict, default ``False``.* 

- If ``True`` -> try parsing the index.
- If ``[1, 2, 3]`` ->  try parsing columns 1, 2, 3 each as a separate date
column.
- If ``[[1, 3]]`` -> combine columns 1 and 3 and parse as a single date
column.
- If ``{'foo': [1, 3]}`` -> parse columns 1, 3 as date and call result ‘foo’.
A fast-path exists for iso8601-formatted dates.

infer_datetime_format : *boolean, default ``False``* 

- If ``True`` and parse_dates is enabled for a column, attempt to infer the datetime format to speed up the processing.

keep_date_col : *boolean, default ``False``* 

- If ``True`` and parse_dates specifies combining multiple columns then keep the original columns.

date_parser : *function, default ``None``* 

- Function to use for converting a sequence of string columns to an array of
datetime instances. The default uses ``dateutil.parser.parser`` to do the
conversion. pandas will try to call date_parser in three different ways,
advancing to the next if an exception occurs: 1) Pass one or more arrays (as
defined by parse_dates) as arguments; 2) concatenate (row-wise) the string
values from the columns defined by parse_dates into a single array and pass
that; and 3) call date_parser once for each row using one or more strings
(corresponding to the columns defined by parse_dates) as arguments.

dayfirst : *boolean, default ``False``* 

- DD/MM format dates, international and European format.

cache_dates : *boolean, default True* 

- If True, use a cache of unique, converted dates to apply the datetime
conversion. May produce significant speed-up when parsing duplicate
date strings, especially ones with timezone offsets.

*New in version 0.25.0.* 

#### Iteration

iterator : *boolean, default ``False``* 

- Return TextFileReader object for iteration or getting chunks with ``get_chunk()``.

chunksize : *int, default ``None``* 

- Return TextFileReader object for iteration. See [iterating and chunking](https://pandas.pydata.org/pandas-docs/stable/user_guide/io.html#io-chunking) below.

#### Quoting, compression, and file format

compression : *{``'infer'``, ``'gzip'``, ``'bz2'``, ``'zip'``, ``'xz'``, ``None``}, default ``'infer'``* 

- For on-the-fly decompression of on-disk data. If ‘infer’, then use gzip,
bz2, zip, or xz if filepath_or_buffer is a string ending in ‘.gz’, ‘.bz2’,
‘.zip’, or ‘.xz’, respectively, and no decompression otherwise. If using ‘zip’,
the ZIP file must contain only one data file to be read in.
Set to ``None`` for no decompression.

*New in version 0.18.1:* support for ‘zip’ and ‘xz’ compression.

*Changed in version 0.24.0:* ‘infer’ option added and set to default.

thousands : *str, default ``None``* 

- Thousands separator.

decimal : *str, default ``'.'``* 

- Character to recognize as decimal point. E.g. use ',' for European data.

float_precision : *string, default None* 

- Specifies which converter the C engine should use for floating-point values.
The options are ``None`` for the ordinary converter, ``high`` for the
high-precision converter, and ``round_trip`` for the round-trip converter.

lineterminator : *str (length 1), default ``None``* 

- Character to break file into lines. Only valid with C parser.

quotechar : *str (length 1)* 

- The character used to denote the start and end of a quoted item. Quoted items can include the delimiter and it will be ignored.

quoting : *int or ``csv.QUOTE_*`` instance, default ``0``* 

- Control field quoting behavior per ``csv.QUOTE_*`` constants. Use one of ``QUOTE_MINIMAL`` (0), ``QUOTE_ALL`` (1), ``QUOTE_NONNUMERIC`` (2) or ``QUOTE_NONE`` (3).

doublequote : *boolean, default ``True``* 

- When ``quotechar`` is specified and ``quoting`` is not ``QUOTE_NONE``, indicate whether or not to interpret two consecutive ``quotechar`` elements **inside** a field as a single ``quotechar`` element.

escapechar : *str (length 1), default ``None``* 

- One-character string used to escape delimiter when quoting is ``QUOTE_NONE``.

comment : *str, default ``None``* 

- Indicates remainder of line should not be parsed. If found at the beginning of
a line, the line will be ignored altogether. This parameter must be a single
character. Like empty lines (as long as ``skip_blank_lines=True``), fully
commented lines are ignored by the parameter *header* but not by *skiprows*.
For example, if ``comment='#'``, parsing ‘#empty a,b,c 1,2,3’ with *header=0* will result in ‘a,b,c’ being treated as the header.

encoding : *str, default ``None``* 

- Encoding to use for UTF when reading/writing (e.g. ``'utf-8'``). [List of Python standard encodings](https://docs.python.org/3/library/codecs.html#standard-encodings).

dialect : *str or [``csv.Dialect``](https://docs.python.org/3/library/csv.html#csv.Dialect) instance, default ``None``* 

- If provided, this parameter will override values (default or not) for the following parameters: *delimiter, doublequote, escapechar, skipinitialspace, quotechar, and quoting.* If it is necessary to override values, a ParserWarning will be issued. See [csv.Dialect](https://docs.python.org/3/library/csv.html#csv.Dialect) documentation for more details.

#### Error handling

error_bad_lines : *boolean, default ``True``* 

- Lines with too many fields (e.g. a csv line with too many commas) will by
default cause an exception to be raised, and no ``DataFrame`` will be
returned. If ``False``, then these “bad lines” will dropped from the
``DataFrame`` that is returned. See [bad lines](#io-bad-lines) below.

warn_bad_lines : *boolean, default ``True``* 

- If error_bad_lines is ``False``, and warn_bad_lines is ``True``, a warning for each “bad line” will be output.

### Specifying column data types

You can indicate the data type for the whole ``DataFrame`` or individual
columns:

``` python
In [8]: data = ('a,b,c,d\n'
   ...:         '1,2,3,4\n'
   ...:         '5,6,7,8\n'
   ...:         '9,10,11')
   ...: 

In [9]: print(data)
a,b,c,d
1,2,3,4
5,6,7,8
9,10,11

In [10]: df = pd.read_csv(StringIO(data), dtype=object)

In [11]: df
Out[11]: 
   a   b   c    d
0  1   2   3    4
1  5   6   7    8
2  9  10  11  NaN

In [12]: df['a'][0]
Out[12]: '1'

In [13]: df = pd.read_csv(StringIO(data),
   ....:                  dtype={'b': object, 'c': np.float64, 'd': 'Int64'})
   ....: 

In [14]: df.dtypes
Out[14]: 
a      int64
b     object
c    float64
d      Int64
dtype: object

```

Fortunately, pandas offers more than one way to ensure that your column(s)
contain only one ``dtype``. If you’re unfamiliar with these concepts, you can
see [here](https://pandas.pydata.org/pandas-docs/stable/getting_started/basics.html#basics-dtypes) to learn more about dtypes, and
[here](https://pandas.pydata.org/pandas-docs/stable/getting_started/basics.html#basics-object-conversion) to learn more about ``object`` conversion in
pandas.

For instance, you can use the ``converters`` argument
of [``read_csv()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html#pandas.read_csv):

``` python
In [15]: data = ("col_1\n"
   ....:         "1\n"
   ....:         "2\n"
   ....:         "'A'\n"
   ....:         "4.22")
   ....: 

In [16]: df = pd.read_csv(StringIO(data), converters={'col_1': str})

In [17]: df
Out[17]: 
  col_1
0     1
1     2
2   'A'
3  4.22

In [18]: df['col_1'].apply(type).value_counts()
Out[18]: 
<class 'str'>    4
Name: col_1, dtype: int64

```

Or you can use the [``to_numeric()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.to_numeric.html#pandas.to_numeric) function to coerce the
dtypes after reading in the data,

``` python
In [19]: df2 = pd.read_csv(StringIO(data))

In [20]: df2['col_1'] = pd.to_numeric(df2['col_1'], errors='coerce')

In [21]: df2
Out[21]: 
   col_1
0   1.00
1   2.00
2    NaN
3   4.22

In [22]: df2['col_1'].apply(type).value_counts()
Out[22]: 
<class 'float'>    4
Name: col_1, dtype: int64

```

which will convert all valid parsing to floats, leaving the invalid parsing
as ``NaN``.

Ultimately, how you deal with reading in columns containing mixed dtypes
depends on your specific needs. In the case above, if you wanted to ``NaN`` out
the data anomalies, then [``to_numeric()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.to_numeric.html#pandas.to_numeric) is probably your best option.
However, if you wanted for all the data to be coerced, no matter the type, then
using the ``converters`` argument of [``read_csv()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html#pandas.read_csv) would certainly be
worth trying.

*New in version 0.20.0:* support for the Python parser.

The ``dtype`` option is supported by the ‘python’ engine.

::: tip Note

In some cases, reading in abnormal data with columns containing mixed dtypes
will result in an inconsistent dataset. If you rely on pandas to infer the
dtypes of your columns, the parsing engine will go and infer the dtypes for
different chunks of the data, rather than the whole dataset at once. Consequently,
you can end up with column(s) with mixed dtypes. For example,

``` python
In [23]: col_1 = list(range(500000)) + ['a', 'b'] + list(range(500000))

In [24]: df = pd.DataFrame({'col_1': col_1})

In [25]: df.to_csv('foo.csv')

In [26]: mixed_df = pd.read_csv('foo.csv')

In [27]: mixed_df['col_1'].apply(type).value_counts()
Out[27]: 
<class 'int'>    737858
<class 'str'>    262144
Name: col_1, dtype: int64

In [28]: mixed_df['col_1'].dtype
Out[28]: dtype('O')

```

will result with *mixed_df* containing an ``int`` dtype for certain chunks
of the column, and ``str`` for others due to the mixed dtypes from the
data that was read in. It is important to note that the overall column will be
marked with a ``dtype`` of ``object``, which is used for columns with mixed dtypes.

:::

### Specifying categorical dtype

*New in version 0.19.0.* 

``Categorical`` columns can be parsed directly by specifying ``dtype='category'`` or
``dtype=CategoricalDtype(categories, ordered)``.

``` python
In [29]: data = ('col1,col2,col3\n'
   ....:         'a,b,1\n'
   ....:         'a,b,2\n'
   ....:         'c,d,3')
   ....: 

In [30]: pd.read_csv(StringIO(data))
Out[30]: 
  col1 col2  col3
0    a    b     1
1    a    b     2
2    c    d     3

In [31]: pd.read_csv(StringIO(data)).dtypes
Out[31]: 
col1    object
col2    object
col3     int64
dtype: object

In [32]: pd.read_csv(StringIO(data), dtype='category').dtypes
Out[32]: 
col1    category
col2    category
col3    category
dtype: object

```

Individual columns can be parsed as a ``Categorical`` using a dict
specification:

``` python
In [33]: pd.read_csv(StringIO(data), dtype={'col1': 'category'}).dtypes
Out[33]: 
col1    category
col2      object
col3       int64
dtype: object

```

*New in version 0.21.0.* 

Specifying ``dtype='category'`` will result in an unordered ``Categorical``
whose ``categories`` are the unique values observed in the data. For more
control on the categories and order, create a
``CategoricalDtype`` ahead of time, and pass that for
that column’s ``dtype``.

``` python
In [34]: from pandas.api.types import CategoricalDtype

In [35]: dtype = CategoricalDtype(['d', 'c', 'b', 'a'], ordered=True)

In [36]: pd.read_csv(StringIO(data), dtype={'col1': dtype}).dtypes
Out[36]: 
col1    category
col2      object
col3       int64
dtype: object

```

When using ``dtype=CategoricalDtype``, “unexpected” values outside of
``dtype.categories`` are treated as missing values.

``` python
In [37]: dtype = CategoricalDtype(['a', 'b', 'd'])  # No 'c'

In [38]: pd.read_csv(StringIO(data), dtype={'col1': dtype}).col1
Out[38]: 
0      a
1      a
2    NaN
Name: col1, dtype: category
Categories (3, object): [a, b, d]

```

This matches the behavior of ``Categorical.set_categories()``.

::: tip Note

With ``dtype='category'``, the resulting categories will always be parsed
as strings (object dtype). If the categories are numeric they can be
converted using the [``to_numeric()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.to_numeric.html#pandas.to_numeric) function, or as appropriate, another
converter such as [``to_datetime()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.to_datetime.html#pandas.to_datetime).

When ``dtype`` is a ``CategoricalDtype`` with homogeneous ``categories`` (
all numeric, all datetimes, etc.), the conversion is done automatically.

``` python
In [39]: df = pd.read_csv(StringIO(data), dtype='category')

In [40]: df.dtypes
Out[40]: 
col1    category
col2    category
col3    category
dtype: object

In [41]: df['col3']
Out[41]: 
0    1
1    2
2    3
Name: col3, dtype: category
Categories (3, object): [1, 2, 3]

In [42]: df['col3'].cat.categories = pd.to_numeric(df['col3'].cat.categories)

In [43]: df['col3']
Out[43]: 
0    1
1    2
2    3
Name: col3, dtype: category
Categories (3, int64): [1, 2, 3]

```

:::

### Naming and using columns

#### Handling column names

A file may or may not have a header row. pandas assumes the first row should be
used as the column names:

``` python
In [44]: data = ('a,b,c\n'
   ....:         '1,2,3\n'
   ....:         '4,5,6\n'
   ....:         '7,8,9')
   ....: 

In [45]: print(data)
a,b,c
1,2,3
4,5,6
7,8,9

In [46]: pd.read_csv(StringIO(data))
Out[46]: 
   a  b  c
0  1  2  3
1  4  5  6
2  7  8  9

```

By specifying the ``names`` argument in conjunction with ``header`` you can
indicate other names to use and whether or not to throw away the header row (if
any):

``` python
In [47]: print(data)
a,b,c
1,2,3
4,5,6
7,8,9

In [48]: pd.read_csv(StringIO(data), names=['foo', 'bar', 'baz'], header=0)
Out[48]: 
   foo  bar  baz
0    1    2    3
1    4    5    6
2    7    8    9

In [49]: pd.read_csv(StringIO(data), names=['foo', 'bar', 'baz'], header=None)
Out[49]: 
  foo bar baz
0   a   b   c
1   1   2   3
2   4   5   6
3   7   8   9

```

If the header is in a row other than the first, pass the row number to
``header``. This will skip the preceding rows:

``` python
In [50]: data = ('skip this skip it\n'
   ....:         'a,b,c\n'
   ....:         '1,2,3\n'
   ....:         '4,5,6\n'
   ....:         '7,8,9')
   ....: 

In [51]: pd.read_csv(StringIO(data), header=1)
Out[51]: 
   a  b  c
0  1  2  3
1  4  5  6
2  7  8  9

```

::: tip Note

Default behavior is to infer the column names: if no names are
passed the behavior is identical to ``header=0`` and column names
are inferred from the first non-blank line of the file, if column
names are passed explicitly then the behavior is identical to
``header=None``.

:::

### Duplicate names parsing

If the file or header contains duplicate names, pandas will by default
distinguish between them so as to prevent overwriting data:

``` python
In [52]: data = ('a,b,a\n'
   ....:         '0,1,2\n'
   ....:         '3,4,5')
   ....: 

In [53]: pd.read_csv(StringIO(data))
Out[53]: 
   a  b  a.1
0  0  1    2
1  3  4    5

```

There is no more duplicate data because ``mangle_dupe_cols=True`` by default,
which modifies a series of duplicate columns ‘X’, …, ‘X’ to become
‘X’, ‘X.1’, …, ‘X.N’.  If ``mangle_dupe_cols=False``, duplicate data can
arise:

``` python
In [2]: data = 'a,b,a\n0,1,2\n3,4,5'
In [3]: pd.read_csv(StringIO(data), mangle_dupe_cols=False)
Out[3]:
   a  b  a
0  2  1  2
1  5  4  5

```

To prevent users from encountering this problem with duplicate data, a ``ValueError``
exception is raised if ``mangle_dupe_cols != True``:

``` python
In [2]: data = 'a,b,a\n0,1,2\n3,4,5'
In [3]: pd.read_csv(StringIO(data), mangle_dupe_cols=False)
...
ValueError: Setting mangle_dupe_cols=False is not supported yet

```

#### Filtering columns (``usecols``)

The ``usecols`` argument allows you to select any subset of the columns in a
file, either using the column names, position numbers or a callable:

*New in version 0.20.0:* support for callable *usecols* arguments

``` python
In [54]: data = 'a,b,c,d\n1,2,3,foo\n4,5,6,bar\n7,8,9,baz'

In [55]: pd.read_csv(StringIO(data))
Out[55]: 
   a  b  c    d
0  1  2  3  foo
1  4  5  6  bar
2  7  8  9  baz

In [56]: pd.read_csv(StringIO(data), usecols=['b', 'd'])
Out[56]: 
   b    d
0  2  foo
1  5  bar
2  8  baz

In [57]: pd.read_csv(StringIO(data), usecols=[0, 2, 3])
Out[57]: 
   a  c    d
0  1  3  foo
1  4  6  bar
2  7  9  baz

In [58]: pd.read_csv(StringIO(data), usecols=lambda x: x.upper() in ['A', 'C'])
Out[58]: 
   a  c
0  1  3
1  4  6
2  7  9

```

The ``usecols`` argument can also be used to specify which columns not to
use in the final result:

``` python
In [59]: pd.read_csv(StringIO(data), usecols=lambda x: x not in ['a', 'c'])
Out[59]: 
   b    d
0  2  foo
1  5  bar
2  8  baz

```

In this case, the callable is specifying that we exclude the “a” and “c”
columns from the output.

### Comments and empty lines

#### Ignoring line comments and empty lines

If the ``comment`` parameter is specified, then completely commented lines will
be ignored. By default, completely blank lines will be ignored as well.

``` python
In [60]: data = ('\n'
   ....:         'a,b,c\n'
   ....:         '  \n'
   ....:         '# commented line\n'
   ....:         '1,2,3\n'
   ....:         '\n'
   ....:         '4,5,6')
   ....: 

In [61]: print(data)

a,b,c
  
# commented line
1,2,3

4,5,6

In [62]: pd.read_csv(StringIO(data), comment='#')
Out[62]: 
   a  b  c
0  1  2  3
1  4  5  6

```

If ``skip_blank_lines=False``, then ``read_csv`` will not ignore blank lines:

``` python
In [63]: data = ('a,b,c\n'
   ....:         '\n'
   ....:         '1,2,3\n'
   ....:         '\n'
   ....:         '\n'
   ....:         '4,5,6')
   ....: 

In [64]: pd.read_csv(StringIO(data), skip_blank_lines=False)
Out[64]: 
     a    b    c
0  NaN  NaN  NaN
1  1.0  2.0  3.0
2  NaN  NaN  NaN
3  NaN  NaN  NaN
4  4.0  5.0  6.0

```

::: danger Warning

The presence of ignored lines might create ambiguities involving line numbers;
the parameter ``header`` uses row numbers (ignoring commented/empty
lines), while ``skiprows`` uses line numbers (including commented/empty lines):

``` python
In [65]: data = ('#comment\n'
   ....:         'a,b,c\n'
   ....:         'A,B,C\n'
   ....:         '1,2,3')
   ....: 

In [66]: pd.read_csv(StringIO(data), comment='#', header=1)
Out[66]: 
   A  B  C
0  1  2  3

In [67]: data = ('A,B,C\n'
   ....:         '#comment\n'
   ....:         'a,b,c\n'
   ....:         '1,2,3')
   ....: 

In [68]: pd.read_csv(StringIO(data), comment='#', skiprows=2)
Out[68]: 
   a  b  c
0  1  2  3

```

If both ``header`` and ``skiprows`` are specified, ``header`` will be
relative to the end of ``skiprows``. For example:

:::

``` python
In [69]: data = ('# empty\n'
   ....:         '# second empty line\n'
   ....:         '# third emptyline\n'
   ....:         'X,Y,Z\n'
   ....:         '1,2,3\n'
   ....:         'A,B,C\n'
   ....:         '1,2.,4.\n'
   ....:         '5.,NaN,10.0\n')
   ....: 

In [70]: print(data)
# empty
# second empty line
# third emptyline
X,Y,Z
1,2,3
A,B,C
1,2.,4.
5.,NaN,10.0


In [71]: pd.read_csv(StringIO(data), comment='#', skiprows=4, header=1)
Out[71]: 
     A    B     C
0  1.0  2.0   4.0
1  5.0  NaN  10.0

```

#### Comments

Sometimes comments or meta data may be included in a file:

``` python
In [72]: print(open('tmp.csv').read())
ID,level,category
Patient1,123000,x # really unpleasant
Patient2,23000,y # wouldn't take his medicine
Patient3,1234018,z # awesome

```

By default, the parser includes the comments in the output:

``` python
In [73]: df = pd.read_csv('tmp.csv')

In [74]: df
Out[74]: 
         ID    level                        category
0  Patient1   123000           x # really unpleasant
1  Patient2    23000  y # wouldn't take his medicine
2  Patient3  1234018                     z # awesome

```

We can suppress the comments using the ``comment`` keyword:

``` python
In [75]: df = pd.read_csv('tmp.csv', comment='#')

In [76]: df
Out[76]: 
         ID    level category
0  Patient1   123000       x 
1  Patient2    23000       y 
2  Patient3  1234018       z 

```

### Dealing with Unicode data

The ``encoding`` argument should be used for encoded unicode data, which will
result in byte strings being decoded to unicode in the result:

``` python
In [77]: data = (b'word,length\n'
   ....:         b'Tr\xc3\xa4umen,7\n'
   ....:         b'Gr\xc3\xbc\xc3\x9fe,5')
   ....: 

In [78]: data = data.decode('utf8').encode('latin-1')

In [79]: df = pd.read_csv(BytesIO(data), encoding='latin-1')

In [80]: df
Out[80]: 
      word  length
0  Träumen       7
1    Grüße       5

In [81]: df['word'][1]
Out[81]: 'Grüße'

```

Some formats which encode all characters as multiple bytes, like UTF-16, won’t
parse correctly at all without specifying the encoding. [Full list of Python
standard encodings](https://docs.python.org/3/library/codecs.html#standard-encodings).

### Index columns and trailing delimiters

If a file has one more column of data than the number of column names, the
first column will be used as the ``DataFrame``’s row names:

``` python
In [82]: data = ('a,b,c\n'
   ....:         '4,apple,bat,5.7\n'
   ....:         '8,orange,cow,10')
   ....: 

In [83]: pd.read_csv(StringIO(data))
Out[83]: 
        a    b     c
4   apple  bat   5.7
8  orange  cow  10.0

```

``` python
In [84]: data = ('index,a,b,c\n'
   ....:         '4,apple,bat,5.7\n'
   ....:         '8,orange,cow,10')
   ....: 

In [85]: pd.read_csv(StringIO(data), index_col=0)
Out[85]: 
            a    b     c
index                   
4       apple  bat   5.7
8      orange  cow  10.0

```

Ordinarily, you can achieve this behavior using the ``index_col`` option.

There are some exception cases when a file has been prepared with delimiters at
the end of each data line, confusing the parser. To explicitly disable the
index column inference and discard the last column, pass ``index_col=False``:

``` python
In [86]: data = ('a,b,c\n'
   ....:         '4,apple,bat,\n'
   ....:         '8,orange,cow,')
   ....: 

In [87]: print(data)
a,b,c
4,apple,bat,
8,orange,cow,

In [88]: pd.read_csv(StringIO(data))
Out[88]: 
        a    b   c
4   apple  bat NaN
8  orange  cow NaN

In [89]: pd.read_csv(StringIO(data), index_col=False)
Out[89]: 
   a       b    c
0  4   apple  bat
1  8  orange  cow

```

If a subset of data is being parsed using the ``usecols`` option, the
``index_col`` specification is based on that subset, not the original data.

``` python
In [90]: data = ('a,b,c\n'
   ....:         '4,apple,bat,\n'
   ....:         '8,orange,cow,')
   ....: 

In [91]: print(data)
a,b,c
4,apple,bat,
8,orange,cow,

In [92]: pd.read_csv(StringIO(data), usecols=['b', 'c'])
Out[92]: 
     b   c
4  bat NaN
8  cow NaN

In [93]: pd.read_csv(StringIO(data), usecols=['b', 'c'], index_col=0)
Out[93]: 
     b   c
4  bat NaN
8  cow NaN

```

### Date Handling

#### Specifying date columns

To better facilitate working with datetime data, [``read_csv()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html#pandas.read_csv)
uses the keyword arguments ``parse_dates`` and ``date_parser``
to allow users to specify a variety of columns and date/time formats to turn the
input text data into ``datetime`` objects.

The simplest case is to just pass in ``parse_dates=True``:

``` python
# Use a column as an index, and parse it as dates.
In [94]: df = pd.read_csv('foo.csv', index_col=0, parse_dates=True)

In [95]: df
Out[95]: 
            A  B  C
date               
2009-01-01  a  1  2
2009-01-02  b  3  4
2009-01-03  c  4  5

# These are Python datetime objects
In [96]: df.index
Out[96]: DatetimeIndex(['2009-01-01', '2009-01-02', '2009-01-03'], dtype='datetime64[ns]', name='date', freq=None)

```

It is often the case that we may want to store date and time data separately,
or store various date fields separately. the ``parse_dates`` keyword can be
used to specify a combination of columns to parse the dates and/or times from.

You can specify a list of column lists to ``parse_dates``, the resulting date
columns will be prepended to the output (so as to not affect the existing column
order) and the new column names will be the concatenation of the component
column names:

``` python
In [97]: print(open('tmp.csv').read())
KORD,19990127, 19:00:00, 18:56:00, 0.8100
KORD,19990127, 20:00:00, 19:56:00, 0.0100
KORD,19990127, 21:00:00, 20:56:00, -0.5900
KORD,19990127, 21:00:00, 21:18:00, -0.9900
KORD,19990127, 22:00:00, 21:56:00, -0.5900
KORD,19990127, 23:00:00, 22:56:00, -0.5900

In [98]: df = pd.read_csv('tmp.csv', header=None, parse_dates=[[1, 2], [1, 3]])

In [99]: df
Out[99]: 
                  1_2                 1_3     0     4
0 1999-01-27 19:00:00 1999-01-27 18:56:00  KORD  0.81
1 1999-01-27 20:00:00 1999-01-27 19:56:00  KORD  0.01
2 1999-01-27 21:00:00 1999-01-27 20:56:00  KORD -0.59
3 1999-01-27 21:00:00 1999-01-27 21:18:00  KORD -0.99
4 1999-01-27 22:00:00 1999-01-27 21:56:00  KORD -0.59
5 1999-01-27 23:00:00 1999-01-27 22:56:00  KORD -0.59

```

By default the parser removes the component date columns, but you can choose
to retain them via the ``keep_date_col`` keyword:

``` python
In [100]: df = pd.read_csv('tmp.csv', header=None, parse_dates=[[1, 2], [1, 3]],
   .....:                  keep_date_col=True)
   .....: 

In [101]: df
Out[101]: 
                  1_2                 1_3     0         1          2          3     4
0 1999-01-27 19:00:00 1999-01-27 18:56:00  KORD  19990127   19:00:00   18:56:00  0.81
1 1999-01-27 20:00:00 1999-01-27 19:56:00  KORD  19990127   20:00:00   19:56:00  0.01
2 1999-01-27 21:00:00 1999-01-27 20:56:00  KORD  19990127   21:00:00   20:56:00 -0.59
3 1999-01-27 21:00:00 1999-01-27 21:18:00  KORD  19990127   21:00:00   21:18:00 -0.99
4 1999-01-27 22:00:00 1999-01-27 21:56:00  KORD  19990127   22:00:00   21:56:00 -0.59
5 1999-01-27 23:00:00 1999-01-27 22:56:00  KORD  19990127   23:00:00   22:56:00 -0.59

```

Note that if you wish to combine multiple columns into a single date column, a
nested list must be used. In other words, ``parse_dates=[1, 2]`` indicates that
the second and third columns should each be parsed as separate date columns
while ``parse_dates=[[1, 2]]`` means the two columns should be parsed into a
single column.

You can also use a dict to specify custom name columns:

``` python
In [102]: date_spec = {'nominal': [1, 2], 'actual': [1, 3]}

In [103]: df = pd.read_csv('tmp.csv', header=None, parse_dates=date_spec)

In [104]: df
Out[104]: 
              nominal              actual     0     4
0 1999-01-27 19:00:00 1999-01-27 18:56:00  KORD  0.81
1 1999-01-27 20:00:00 1999-01-27 19:56:00  KORD  0.01
2 1999-01-27 21:00:00 1999-01-27 20:56:00  KORD -0.59
3 1999-01-27 21:00:00 1999-01-27 21:18:00  KORD -0.99
4 1999-01-27 22:00:00 1999-01-27 21:56:00  KORD -0.59
5 1999-01-27 23:00:00 1999-01-27 22:56:00  KORD -0.59

```

It is important to remember that if multiple text columns are to be parsed into
a single date column, then a new column is prepended to the data. The *index_col*
specification is based off of this new set of columns rather than the original
data columns:

``` python
In [105]: date_spec = {'nominal': [1, 2], 'actual': [1, 3]}

In [106]: df = pd.read_csv('tmp.csv', header=None, parse_dates=date_spec,
   .....:                  index_col=0)  # index is the nominal column
   .....: 

In [107]: df
Out[107]: 
                                 actual     0     4
nominal                                            
1999-01-27 19:00:00 1999-01-27 18:56:00  KORD  0.81
1999-01-27 20:00:00 1999-01-27 19:56:00  KORD  0.01
1999-01-27 21:00:00 1999-01-27 20:56:00  KORD -0.59
1999-01-27 21:00:00 1999-01-27 21:18:00  KORD -0.99
1999-01-27 22:00:00 1999-01-27 21:56:00  KORD -0.59
1999-01-27 23:00:00 1999-01-27 22:56:00  KORD -0.59

```

::: tip Note

If a column or index contains an unparsable date, the entire column or
index will be returned unaltered as an object data type. For non-standard
datetime parsing, use [``to_datetime()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.to_datetime.html#pandas.to_datetime) after ``pd.read_csv``.

:::

::: tip Note

read_csv has a fast_path for parsing datetime strings in iso8601 format,
e.g “2000-01-01T00:01:02+00:00” and similar variations. If you can arrange
for your data to store datetimes in this format, load times will be
significantly faster, ~20x has been observed.

:::

::: tip Note

When passing a dict as the *parse_dates* argument, the order of
the columns prepended is not guaranteed, because *dict* objects do not impose
an ordering on their keys. On Python 2.7+ you may use *collections.OrderedDict*
instead of a regular *dict* if this matters to you. Because of this, when using a
dict for ‘parse_dates’ in conjunction with the *index_col* argument, it’s best to
specify *index_col* as a column label rather then as an index on the resulting frame.

:::

#### Date parsing functions

Finally, the parser allows you to specify a custom ``date_parser`` function to
take full advantage of the flexibility of the date parsing API:

``` python
In [108]: df = pd.read_csv('tmp.csv', header=None, parse_dates=date_spec,
   .....:                  date_parser=pd.io.date_converters.parse_date_time)
   .....: 

In [109]: df
Out[109]: 
              nominal              actual     0     4
0 1999-01-27 19:00:00 1999-01-27 18:56:00  KORD  0.81
1 1999-01-27 20:00:00 1999-01-27 19:56:00  KORD  0.01
2 1999-01-27 21:00:00 1999-01-27 20:56:00  KORD -0.59
3 1999-01-27 21:00:00 1999-01-27 21:18:00  KORD -0.99
4 1999-01-27 22:00:00 1999-01-27 21:56:00  KORD -0.59
5 1999-01-27 23:00:00 1999-01-27 22:56:00  KORD -0.59

```

Pandas will try to call the ``date_parser`` function in three different ways. If
an exception is raised, the next one is tried:

1. ``date_parser`` is first called with one or more arrays as arguments,
as defined using *parse_dates* (e.g., ``date_parser(['2013', '2013'], ['1', '2'])``).
1. If #1 fails, ``date_parser`` is called with all the columns
concatenated row-wise into a single array (e.g., ``date_parser(['2013 1', '2013 2'])``).
1. If #2 fails, ``date_parser`` is called once for every row with one or more
string arguments from the columns indicated with *parse_dates*
(e.g., ``date_parser('2013', '1')`` for the first row, ``date_parser('2013', '2')``
for the second, etc.).

Note that performance-wise, you should try these methods of parsing dates in order:

1. Try to infer the format using ``infer_datetime_format=True`` (see section below).
1. If you know the format, use ``pd.to_datetime()``:
``date_parser=lambda x: pd.to_datetime(x, format=...)``.
1. If you have a really non-standard format, use a custom ``date_parser`` function.
For optimal performance, this should be vectorized, i.e., it should accept arrays
as arguments.

You can explore the date parsing functionality in
[date_converters.py](https://github.com/pandas-dev/pandas/blob/master/pandas/io/date_converters.py)
and add your own. We would love to turn this module into a community supported
set of date/time parsers. To get you started, ``date_converters.py`` contains
functions to parse dual date and time columns, year/month/day columns,
and year/month/day/hour/minute/second columns. It also contains a
``generic_parser`` function so you can curry it with a function that deals with
a single date rather than the entire array.

#### Parsing a CSV with mixed timezones

Pandas cannot natively represent a column or index with mixed timezones. If your CSV
file contains columns with a mixture of timezones, the default result will be
an object-dtype column with strings, even with ``parse_dates``.

``` python
In [110]: content = """\
   .....: a
   .....: 2000-01-01T00:00:00+05:00
   .....: 2000-01-01T00:00:00+06:00"""
   .....: 

In [111]: df = pd.read_csv(StringIO(content), parse_dates=['a'])

In [112]: df['a']
Out[112]: 
0    2000-01-01 00:00:00+05:00
1    2000-01-01 00:00:00+06:00
Name: a, dtype: object

```

To parse the mixed-timezone values as a datetime column, pass a partially-applied
[``to_datetime()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.to_datetime.html#pandas.to_datetime) with ``utc=True`` as the ``date_parser``.

``` python
In [113]: df = pd.read_csv(StringIO(content), parse_dates=['a'],
   .....:                  date_parser=lambda col: pd.to_datetime(col, utc=True))
   .....: 

In [114]: df['a']
Out[114]: 
0   1999-12-31 19:00:00+00:00
1   1999-12-31 18:00:00+00:00
Name: a, dtype: datetime64[ns, UTC]

```

#### Inferring datetime format

If you have ``parse_dates`` enabled for some or all of your columns, and your
datetime strings are all formatted the same way, you may get a large speed
up by setting ``infer_datetime_format=True``.  If set, pandas will attempt
to guess the format of your datetime strings, and then use a faster means
of parsing the strings.  5-10x parsing speeds have been observed.  pandas
will fallback to the usual parsing if either the format cannot be guessed
or the format that was guessed cannot properly parse the entire column
of strings.  So in general, ``infer_datetime_format`` should not have any
negative consequences if enabled.

Here are some examples of datetime strings that can be guessed (All
representing December 30th, 2011 at 00:00:00):

- “20111230”
- “2011/12/30”
- “20111230 00:00:00”
- “12/30/2011 00:00:00”
- “30/Dec/2011 00:00:00”
- “30/December/2011 00:00:00”

Note that ``infer_datetime_format`` is sensitive to ``dayfirst``.  With
``dayfirst=True``, it will guess “01/12/2011” to be December 1st. With
``dayfirst=False`` (default) it will guess “01/12/2011” to be January 12th.

``` python
# Try to infer the format for the index column
In [115]: df = pd.read_csv('foo.csv', index_col=0, parse_dates=True,
   .....:                  infer_datetime_format=True)
   .....: 

In [116]: df
Out[116]: 
            A  B  C
date               
2009-01-01  a  1  2
2009-01-02  b  3  4
2009-01-03  c  4  5

```

#### International date formats

While US date formats tend to be MM/DD/YYYY, many international formats use
DD/MM/YYYY instead. For convenience, a ``dayfirst`` keyword is provided:

``` python
In [117]: print(open('tmp.csv').read())
date,value,cat
1/6/2000,5,a
2/6/2000,10,b
3/6/2000,15,c

In [118]: pd.read_csv('tmp.csv', parse_dates=[0])
Out[118]: 
        date  value cat
0 2000-01-06      5   a
1 2000-02-06     10   b
2 2000-03-06     15   c

In [119]: pd.read_csv('tmp.csv', dayfirst=True, parse_dates=[0])
Out[119]: 
        date  value cat
0 2000-06-01      5   a
1 2000-06-02     10   b
2 2000-06-03     15   c

```

### Specifying method for floating-point conversion

The parameter ``float_precision`` can be specified in order to use
a specific floating-point converter during parsing with the C engine.
The options are the ordinary converter, the high-precision converter, and
the round-trip converter (which is guaranteed to round-trip values after
writing to a file). For example:

``` python
In [120]: val = '0.3066101993807095471566981359501369297504425048828125'

In [121]: data = 'a,b,c\n1,2,{0}'.format(val)

In [122]: abs(pd.read_csv(StringIO(data), engine='c',
   .....:                 float_precision=None)['c'][0] - float(val))
   .....: 
Out[122]: 1.1102230246251565e-16

In [123]: abs(pd.read_csv(StringIO(data), engine='c',
   .....:                 float_precision='high')['c'][0] - float(val))
   .....: 
Out[123]: 5.551115123125783e-17

In [124]: abs(pd.read_csv(StringIO(data), engine='c',
   .....:                 float_precision='round_trip')['c'][0] - float(val))
   .....: 
Out[124]: 0.0

```

### Thousand separators

For large numbers that have been written with a thousands separator, you can
set the ``thousands`` keyword to a string of length 1 so that integers will be parsed
correctly:

By default, numbers with a thousands separator will be parsed as strings:

``` python
In [125]: print(open('tmp.csv').read())
ID|level|category
Patient1|123,000|x
Patient2|23,000|y
Patient3|1,234,018|z

In [126]: df = pd.read_csv('tmp.csv', sep='|')

In [127]: df
Out[127]: 
         ID      level category
0  Patient1    123,000        x
1  Patient2     23,000        y
2  Patient3  1,234,018        z

In [128]: df.level.dtype
Out[128]: dtype('O')

```

The ``thousands`` keyword allows integers to be parsed correctly:

``` python
In [129]: print(open('tmp.csv').read())
ID|level|category
Patient1|123,000|x
Patient2|23,000|y
Patient3|1,234,018|z

In [130]: df = pd.read_csv('tmp.csv', sep='|', thousands=',')

In [131]: df
Out[131]: 
         ID    level category
0  Patient1   123000        x
1  Patient2    23000        y
2  Patient3  1234018        z

In [132]: df.level.dtype
Out[132]: dtype('int64')

```

### NA values

To control which values are parsed as missing values (which are signified by
``NaN``), specify a string in ``na_values``. If you specify a list of strings,
then all values in it are considered to be missing values. If you specify a
number (a ``float``, like ``5.0`` or an ``integer`` like ``5``), the
corresponding equivalent values will also imply a missing value (in this case
effectively ``[5.0, 5]`` are recognized as ``NaN``).

To completely override the default values that are recognized as missing, specify ``keep_default_na=False``.

The default ``NaN`` recognized values are ``['-1.#IND', '1.#QNAN', '1.#IND', '-1.#QNAN', '#N/A N/A', '#N/A', 'N/A',
'n/a', 'NA', '#NA', 'NULL', 'null', 'NaN', '-NaN', 'nan', '-nan', '']``.

Let us consider some examples:

``` python
pd.read_csv('path_to_file.csv', na_values=[5])

```

In the example above ``5`` and ``5.0`` will be recognized as ``NaN``, in
addition to the defaults. A string will first be interpreted as a numerical
``5``, then as a ``NaN``.

``` python
pd.read_csv('path_to_file.csv', keep_default_na=False, na_values=[""])

```

Above, only an empty field will be recognized as ``NaN``.

``` python
pd.read_csv('path_to_file.csv', keep_default_na=False, na_values=["NA", "0"])

```

Above, both ``NA`` and ``0`` as strings are ``NaN``.

``` python
pd.read_csv('path_to_file.csv', na_values=["Nope"])

```

The default values, in addition to the string ``"Nope"`` are recognized as
``NaN``.

### Infinity

``inf`` like values will be parsed as ``np.inf`` (positive infinity), and ``-inf`` as ``-np.inf`` (negative infinity).
These will ignore the case of the value, meaning ``Inf``, will also be parsed as ``np.inf``.

### Returning Series

Using the ``squeeze`` keyword, the parser will return output with a single column
as a ``Series``:

``` python
In [133]: print(open('tmp.csv').read())
level
Patient1,123000
Patient2,23000
Patient3,1234018

In [134]: output = pd.read_csv('tmp.csv', squeeze=True)

In [135]: output
Out[135]: 
Patient1     123000
Patient2      23000
Patient3    1234018
Name: level, dtype: int64

In [136]: type(output)
Out[136]: pandas.core.series.Series

```

### Boolean values

The common values ``True``, ``False``, ``TRUE``, and ``FALSE`` are all
recognized as boolean. Occasionally you might want to recognize other values
as being boolean. To do this, use the ``true_values`` and ``false_values``
options as follows:

``` python
In [137]: data = ('a,b,c\n'
   .....:         '1,Yes,2\n'
   .....:         '3,No,4')
   .....: 

In [138]: print(data)
a,b,c
1,Yes,2
3,No,4

In [139]: pd.read_csv(StringIO(data))
Out[139]: 
   a    b  c
0  1  Yes  2
1  3   No  4

In [140]: pd.read_csv(StringIO(data), true_values=['Yes'], false_values=['No'])
Out[140]: 
   a      b  c
0  1   True  2
1  3  False  4

```

### Handling “bad” lines

Some files may have malformed lines with too few fields or too many. Lines with
too few fields will have NA values filled in the trailing fields. Lines with
too many fields will raise an error by default:

``` python
In [141]: data = ('a,b,c\n'
   .....:         '1,2,3\n'
   .....:         '4,5,6,7\n'
   .....:         '8,9,10')
   .....: 

In [142]: pd.read_csv(StringIO(data))
---------------------------------------------------------------------------
ParserError                               Traceback (most recent call last)
<ipython-input-142-6388c394e6b8> in <module>
----> 1 pd.read_csv(StringIO(data))

/pandas/pandas/io/parsers.py in parser_f(filepath_or_buffer, sep, delimiter, header, names, index_col, usecols, squeeze, prefix, mangle_dupe_cols, dtype, engine, converters, true_values, false_values, skipinitialspace, skiprows, skipfooter, nrows, na_values, keep_default_na, na_filter, verbose, skip_blank_lines, parse_dates, infer_datetime_format, keep_date_col, date_parser, dayfirst, cache_dates, iterator, chunksize, compression, thousands, decimal, lineterminator, quotechar, quoting, doublequote, escapechar, comment, encoding, dialect, error_bad_lines, warn_bad_lines, delim_whitespace, low_memory, memory_map, float_precision)
    683         )
    684 
--> 685         return _read(filepath_or_buffer, kwds)
    686 
    687     parser_f.__name__ = name

/pandas/pandas/io/parsers.py in _read(filepath_or_buffer, kwds)
    461 
    462     try:
--> 463         data = parser.read(nrows)
    464     finally:
    465         parser.close()

/pandas/pandas/io/parsers.py in read(self, nrows)
   1152     def read(self, nrows=None):
   1153         nrows = _validate_integer("nrows", nrows)
-> 1154         ret = self._engine.read(nrows)
   1155 
   1156         # May alter columns / col_dict

/pandas/pandas/io/parsers.py in read(self, nrows)
   2046     def read(self, nrows=None):
   2047         try:
-> 2048             data = self._reader.read(nrows)
   2049         except StopIteration:
   2050             if self._first_chunk:

/pandas/pandas/_libs/parsers.pyx in pandas._libs.parsers.TextReader.read()

/pandas/pandas/_libs/parsers.pyx in pandas._libs.parsers.TextReader._read_low_memory()

/pandas/pandas/_libs/parsers.pyx in pandas._libs.parsers.TextReader._read_rows()

/pandas/pandas/_libs/parsers.pyx in pandas._libs.parsers.TextReader._tokenize_rows()

/pandas/pandas/_libs/parsers.pyx in pandas._libs.parsers.raise_parser_error()

ParserError: Error tokenizing data. C error: Expected 3 fields in line 3, saw 4

```

You can elect to skip bad lines:

``` python
In [29]: pd.read_csv(StringIO(data), error_bad_lines=False)
Skipping line 3: expected 3 fields, saw 4

Out[29]:
   a  b   c
0  1  2   3
1  8  9  10

```

You can also use the ``usecols`` parameter to eliminate extraneous column
data that appear in some lines but not others:

``` python
In [30]: pd.read_csv(StringIO(data), usecols=[0, 1, 2])

 Out[30]:
    a  b   c
 0  1  2   3
 1  4  5   6
 2  8  9  10

```

### Dialect

The ``dialect`` keyword gives greater flexibility in specifying the file format.
By default it uses the Excel dialect but you can specify either the dialect name
or a [``csv.Dialect``](https://docs.python.org/3/library/csv.html#csv.Dialect) instance.

Suppose you had data with unenclosed quotes:

``` python
In [143]: print(data)
label1,label2,label3
index1,"a,c,e
index2,b,d,f

```

By default, ``read_csv`` uses the Excel dialect and treats the double quote as
the quote character, which causes it to fail when it finds a newline before it
finds the closing double quote.

We can get around this using ``dialect``:

``` python
In [144]: import csv

In [145]: dia = csv.excel()

In [146]: dia.quoting = csv.QUOTE_NONE

In [147]: pd.read_csv(StringIO(data), dialect=dia)
Out[147]: 
       label1 label2 label3
index1     "a      c      e
index2      b      d      f

```

All of the dialect options can be specified separately by keyword arguments:

``` python
In [148]: data = 'a,b,c~1,2,3~4,5,6'

In [149]: pd.read_csv(StringIO(data), lineterminator='~')
Out[149]: 
   a  b  c
0  1  2  3
1  4  5  6

```

Another common dialect option is ``skipinitialspace``, to skip any whitespace
after a delimiter:

``` python
In [150]: data = 'a, b, c\n1, 2, 3\n4, 5, 6'

In [151]: print(data)
a, b, c
1, 2, 3
4, 5, 6

In [152]: pd.read_csv(StringIO(data), skipinitialspace=True)
Out[152]: 
   a  b  c
0  1  2  3
1  4  5  6

```

The parsers make every attempt to “do the right thing” and not be fragile. Type
inference is a pretty big deal. If a column can be coerced to integer dtype
without altering the contents, the parser will do so. Any non-numeric
columns will come through as object dtype as with the rest of pandas objects.

### Quoting and Escape Characters

Quotes (and other escape characters) in embedded fields can be handled in any
number of ways. One way is to use backslashes; to properly parse this data, you
should pass the ``escapechar`` option:

``` python
In [153]: data = 'a,b\n"hello, \\"Bob\\", nice to see you",5'

In [154]: print(data)
a,b
"hello, \"Bob\", nice to see you",5

In [155]: pd.read_csv(StringIO(data), escapechar='\\')
Out[155]: 
                               a  b
0  hello, "Bob", nice to see you  5

```

### Files with fixed width columns

While [``read_csv()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html#pandas.read_csv) reads delimited data, the [``read_fwf()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_fwf.html#pandas.read_fwf) function works
with data files that have known and fixed column widths. The function parameters
to ``read_fwf`` are largely the same as *read_csv* with two extra parameters, and
a different usage of the ``delimiter`` parameter:

- ``colspecs``: A list of pairs (tuples) giving the extents of the
fixed-width fields of each line as half-open intervals (i.e.,  [from, to[ ).
String value ‘infer’ can be used to instruct the parser to try detecting
the column specifications from the first 100 rows of the data. Default
behavior, if not specified, is to infer.
- ``widths``: A list of field widths which can be used instead of ‘colspecs’
if the intervals are contiguous.
- ``delimiter``: Characters to consider as filler characters in the fixed-width file.
Can be used to specify the filler character of the fields
if it is not spaces (e.g., ‘~’).

Consider a typical fixed-width data file:

``` python
In [156]: print(open('bar.csv').read())
id8141    360.242940   149.910199   11950.7
id1594    444.953632   166.985655   11788.4
id1849    364.136849   183.628767   11806.2
id1230    413.836124   184.375703   11916.8
id1948    502.953953   173.237159   12468.3

```

In order to parse this file into a ``DataFrame``, we simply need to supply the
column specifications to the *read_fwf* function along with the file name:

``` python
# Column specifications are a list of half-intervals
In [157]: colspecs = [(0, 6), (8, 20), (21, 33), (34, 43)]

In [158]: df = pd.read_fwf('bar.csv', colspecs=colspecs, header=None, index_col=0)

In [159]: df
Out[159]: 
                 1           2        3
0                                      
id8141  360.242940  149.910199  11950.7
id1594  444.953632  166.985655  11788.4
id1849  364.136849  183.628767  11806.2
id1230  413.836124  184.375703  11916.8
id1948  502.953953  173.237159  12468.3

```

Note how the parser automatically picks column names ``X.<column number>`` when
``header=None`` argument is specified. Alternatively, you can supply just the
column widths for contiguous columns:

``` python
# Widths are a list of integers
In [160]: widths = [6, 14, 13, 10]

In [161]: df = pd.read_fwf('bar.csv', widths=widths, header=None)

In [162]: df
Out[162]: 
        0           1           2        3
0  id8141  360.242940  149.910199  11950.7
1  id1594  444.953632  166.985655  11788.4
2  id1849  364.136849  183.628767  11806.2
3  id1230  413.836124  184.375703  11916.8
4  id1948  502.953953  173.237159  12468.3

```

The parser will take care of extra white spaces around the columns
so it’s ok to have extra separation between the columns in the file.

By default, ``read_fwf`` will try to infer the file’s ``colspecs`` by using the
first 100 rows of the file. It can do it only in cases when the columns are
aligned and correctly separated by the provided ``delimiter`` (default delimiter
is whitespace).

``` python
In [163]: df = pd.read_fwf('bar.csv', header=None, index_col=0)

In [164]: df
Out[164]: 
                 1           2        3
0                                      
id8141  360.242940  149.910199  11950.7
id1594  444.953632  166.985655  11788.4
id1849  364.136849  183.628767  11806.2
id1230  413.836124  184.375703  11916.8
id1948  502.953953  173.237159  12468.3

```

*New in version 0.20.0.* 

``read_fwf`` supports the ``dtype`` parameter for specifying the types of
parsed columns to be different from the inferred type.

``` python
In [165]: pd.read_fwf('bar.csv', header=None, index_col=0).dtypes
Out[165]: 
1    float64
2    float64
3    float64
dtype: object

In [166]: pd.read_fwf('bar.csv', header=None, dtype={2: 'object'}).dtypes
Out[166]: 
0     object
1    float64
2     object
3    float64
dtype: object

```

### Indexes

#### Files with an “implicit” index column

Consider a file with one less entry in the header than the number of data
column:

``` python
In [167]: print(open('foo.csv').read())
A,B,C
20090101,a,1,2
20090102,b,3,4
20090103,c,4,5

```

In this special case, ``read_csv`` assumes that the first column is to be used
as the index of the ``DataFrame``:

``` python
In [168]: pd.read_csv('foo.csv')
Out[168]: 
          A  B  C
20090101  a  1  2
20090102  b  3  4
20090103  c  4  5

```

Note that the dates weren’t automatically parsed. In that case you would need
to do as before:

``` python
In [169]: df = pd.read_csv('foo.csv', parse_dates=True)

In [170]: df.index
Out[170]: DatetimeIndex(['2009-01-01', '2009-01-02', '2009-01-03'], dtype='datetime64[ns]', freq=None)

```

#### Reading an index with a ``MultiIndex``

Suppose you have data indexed by two columns:

``` python
In [171]: print(open('data/mindex_ex.csv').read())
year,indiv,zit,xit
1977,"A",1.2,.6
1977,"B",1.5,.5
1977,"C",1.7,.8
1978,"A",.2,.06
1978,"B",.7,.2
1978,"C",.8,.3
1978,"D",.9,.5
1978,"E",1.4,.9
1979,"C",.2,.15
1979,"D",.14,.05
1979,"E",.5,.15
1979,"F",1.2,.5
1979,"G",3.4,1.9
1979,"H",5.4,2.7
1979,"I",6.4,1.2

```

The ``index_col`` argument to ``read_csv`` can take a list of
column numbers to turn multiple columns into a ``MultiIndex`` for the index of the
returned object:

``` python
In [172]: df = pd.read_csv("data/mindex_ex.csv", index_col=[0, 1])

In [173]: df
Out[173]: 
             zit   xit
year indiv            
1977 A      1.20  0.60
     B      1.50  0.50
     C      1.70  0.80
1978 A      0.20  0.06
     B      0.70  0.20
     C      0.80  0.30
     D      0.90  0.50
     E      1.40  0.90
1979 C      0.20  0.15
     D      0.14  0.05
     E      0.50  0.15
     F      1.20  0.50
     G      3.40  1.90
     H      5.40  2.70
     I      6.40  1.20

In [174]: df.loc[1978]
Out[174]: 
       zit   xit
indiv           
A      0.2  0.06
B      0.7  0.20
C      0.8  0.30
D      0.9  0.50
E      1.4  0.90

```

#### Reading columns with a ``MultiIndex``

By specifying list of row locations for the ``header`` argument, you
can read in a ``MultiIndex`` for the columns. Specifying non-consecutive
rows will skip the intervening rows.

``` python
In [175]: from pandas.util.testing import makeCustomDataframe as mkdf

In [176]: df = mkdf(5, 3, r_idx_nlevels=2, c_idx_nlevels=4)

In [177]: df.to_csv('mi.csv')

In [178]: print(open('mi.csv').read())
C0,,C_l0_g0,C_l0_g1,C_l0_g2
C1,,C_l1_g0,C_l1_g1,C_l1_g2
C2,,C_l2_g0,C_l2_g1,C_l2_g2
C3,,C_l3_g0,C_l3_g1,C_l3_g2
R0,R1,,,
R_l0_g0,R_l1_g0,R0C0,R0C1,R0C2
R_l0_g1,R_l1_g1,R1C0,R1C1,R1C2
R_l0_g2,R_l1_g2,R2C0,R2C1,R2C2
R_l0_g3,R_l1_g3,R3C0,R3C1,R3C2
R_l0_g4,R_l1_g4,R4C0,R4C1,R4C2


In [179]: pd.read_csv('mi.csv', header=[0, 1, 2, 3], index_col=[0, 1])
Out[179]: 
C0              C_l0_g0 C_l0_g1 C_l0_g2
C1              C_l1_g0 C_l1_g1 C_l1_g2
C2              C_l2_g0 C_l2_g1 C_l2_g2
C3              C_l3_g0 C_l3_g1 C_l3_g2
R0      R1                             
R_l0_g0 R_l1_g0    R0C0    R0C1    R0C2
R_l0_g1 R_l1_g1    R1C0    R1C1    R1C2
R_l0_g2 R_l1_g2    R2C0    R2C1    R2C2
R_l0_g3 R_l1_g3    R3C0    R3C1    R3C2
R_l0_g4 R_l1_g4    R4C0    R4C1    R4C2

```

``read_csv`` is also able to interpret a more common format
of multi-columns indices.

``` python
In [180]: print(open('mi2.csv').read())
,a,a,a,b,c,c
,q,r,s,t,u,v
one,1,2,3,4,5,6
two,7,8,9,10,11,12

In [181]: pd.read_csv('mi2.csv', header=[0, 1], index_col=0)
Out[181]: 
     a         b   c    
     q  r  s   t   u   v
one  1  2  3   4   5   6
two  7  8  9  10  11  12

```

Note: If an ``index_col`` is not specified (e.g. you don’t have an index, or wrote it
with ``df.to_csv(..., index=False)``, then any ``names`` on the columns index will be lost.

### Automatically “sniffing” the delimiter

``read_csv`` is capable of inferring delimited (not necessarily
comma-separated) files, as pandas uses the [``csv.Sniffer``](https://docs.python.org/3/library/csv.html#csv.Sniffer)
class of the csv module. For this, you have to specify ``sep=None``.

``` python
In [182]: print(open('tmp2.sv').read())
:0:1:2:3
0:0.4691122999071863:-0.2828633443286633:-1.5090585031735124:-1.1356323710171934
1:1.2121120250208506:-0.17321464905330858:0.11920871129693428:-1.0442359662799567
2:-0.8618489633477999:-2.1045692188948086:-0.4949292740687813:1.071803807037338
3:0.7215551622443669:-0.7067711336300845:-1.0395749851146963:0.27185988554282986
4:-0.42497232978883753:0.567020349793672:0.27623201927771873:-1.0874006912859915
5:-0.6736897080883706:0.1136484096888855:-1.4784265524372235:0.5249876671147047
6:0.4047052186802365:0.5770459859204836:-1.7150020161146375:-1.0392684835147725
7:-0.3706468582364464:-1.1578922506419993:-1.344311812731667:0.8448851414248841
8:1.0757697837155533:-0.10904997528022223:1.6435630703622064:-1.4693879595399115
9:0.35702056413309086:-0.6746001037299882:-1.776903716971867:-0.9689138124473498


In [183]: pd.read_csv('tmp2.sv', sep=None, engine='python')
Out[183]: 
   Unnamed: 0         0         1         2         3
0           0  0.469112 -0.282863 -1.509059 -1.135632
1           1  1.212112 -0.173215  0.119209 -1.044236
2           2 -0.861849 -2.104569 -0.494929  1.071804
3           3  0.721555 -0.706771 -1.039575  0.271860
4           4 -0.424972  0.567020  0.276232 -1.087401
5           5 -0.673690  0.113648 -1.478427  0.524988
6           6  0.404705  0.577046 -1.715002 -1.039268
7           7 -0.370647 -1.157892 -1.344312  0.844885
8           8  1.075770 -0.109050  1.643563 -1.469388
9           9  0.357021 -0.674600 -1.776904 -0.968914

```

### Reading multiple files to create a single DataFrame

It’s best to use [``concat()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.concat.html#pandas.concat) to combine multiple files.
See the [cookbook](cookbook.html#cookbook-csv-multiple-files) for an example.

### Iterating through files chunk by chunk

Suppose you wish to iterate through a (potentially very large) file lazily
rather than reading the entire file into memory, such as the following:

``` python
In [184]: print(open('tmp.sv').read())
|0|1|2|3
0|0.4691122999071863|-0.2828633443286633|-1.5090585031735124|-1.1356323710171934
1|1.2121120250208506|-0.17321464905330858|0.11920871129693428|-1.0442359662799567
2|-0.8618489633477999|-2.1045692188948086|-0.4949292740687813|1.071803807037338
3|0.7215551622443669|-0.7067711336300845|-1.0395749851146963|0.27185988554282986
4|-0.42497232978883753|0.567020349793672|0.27623201927771873|-1.0874006912859915
5|-0.6736897080883706|0.1136484096888855|-1.4784265524372235|0.5249876671147047
6|0.4047052186802365|0.5770459859204836|-1.7150020161146375|-1.0392684835147725
7|-0.3706468582364464|-1.1578922506419993|-1.344311812731667|0.8448851414248841
8|1.0757697837155533|-0.10904997528022223|1.6435630703622064|-1.4693879595399115
9|0.35702056413309086|-0.6746001037299882|-1.776903716971867|-0.9689138124473498


In [185]: table = pd.read_csv('tmp.sv', sep='|')

In [186]: table
Out[186]: 
   Unnamed: 0         0         1         2         3
0           0  0.469112 -0.282863 -1.509059 -1.135632
1           1  1.212112 -0.173215  0.119209 -1.044236
2           2 -0.861849 -2.104569 -0.494929  1.071804
3           3  0.721555 -0.706771 -1.039575  0.271860
4           4 -0.424972  0.567020  0.276232 -1.087401
5           5 -0.673690  0.113648 -1.478427  0.524988
6           6  0.404705  0.577046 -1.715002 -1.039268
7           7 -0.370647 -1.157892 -1.344312  0.844885
8           8  1.075770 -0.109050  1.643563 -1.469388
9           9  0.357021 -0.674600 -1.776904 -0.968914

```

By specifying a ``chunksize`` to ``read_csv``, the return
value will be an iterable object of type ``TextFileReader``:

``` python
In [187]: reader = pd.read_csv('tmp.sv', sep='|', chunksize=4)

In [188]: reader
Out[188]: <pandas.io.parsers.TextFileReader at 0x7f65f17cf7f0>

In [189]: for chunk in reader:
   .....:     print(chunk)
   .....: 
   Unnamed: 0         0         1         2         3
0           0  0.469112 -0.282863 -1.509059 -1.135632
1           1  1.212112 -0.173215  0.119209 -1.044236
2           2 -0.861849 -2.104569 -0.494929  1.071804
3           3  0.721555 -0.706771 -1.039575  0.271860
   Unnamed: 0         0         1         2         3
4           4 -0.424972  0.567020  0.276232 -1.087401
5           5 -0.673690  0.113648 -1.478427  0.524988
6           6  0.404705  0.577046 -1.715002 -1.039268
7           7 -0.370647 -1.157892 -1.344312  0.844885
   Unnamed: 0         0        1         2         3
8           8  1.075770 -0.10905  1.643563 -1.469388
9           9  0.357021 -0.67460 -1.776904 -0.968914

```

Specifying ``iterator=True`` will also return the ``TextFileReader`` object:

``` python
In [190]: reader = pd.read_csv('tmp.sv', sep='|', iterator=True)

In [191]: reader.get_chunk(5)
Out[191]: 
   Unnamed: 0         0         1         2         3
0           0  0.469112 -0.282863 -1.509059 -1.135632
1           1  1.212112 -0.173215  0.119209 -1.044236
2           2 -0.861849 -2.104569 -0.494929  1.071804
3           3  0.721555 -0.706771 -1.039575  0.271860
4           4 -0.424972  0.567020  0.276232 -1.087401

```

### Specifying the parser engine

Under the hood pandas uses a fast and efficient parser implemented in C as well
as a Python implementation which is currently more feature-complete. Where
possible pandas uses the C parser (specified as ``engine='c'``), but may fall
back to Python if C-unsupported options are specified. Currently, C-unsupported
options include:

- ``sep`` other than a single character (e.g. regex separators)
- ``skipfooter``
- ``sep=None`` with ``delim_whitespace=False``

Specifying any of the above options will produce a ``ParserWarning`` unless the
python engine is selected explicitly using ``engine='python'``.

### Reading remote files

You can pass in a URL to a CSV file:

``` python
df = pd.read_csv('https://download.bls.gov/pub/time.series/cu/cu.item',
                 sep='\t')

```

S3 URLs are handled as well but require installing the [S3Fs](https://pypi.org/project/s3fs/) library:

``` python
df = pd.read_csv('s3://pandas-test/tips.csv')

```

If your S3 bucket requires credentials you will need to set them as environment
variables or in the ``~/.aws/credentials`` config file, refer to the [S3Fs
documentation on credentials](https://s3fs.readthedocs.io/en/latest/#credentials).

### Writing out data

#### Writing to CSV format

The ``Series`` and ``DataFrame`` objects have an instance method ``to_csv`` which
allows storing the contents of the object as a comma-separated-values file. The
function takes a number of arguments. Only the first is required.

- ``path_or_buf``: A string path to the file to write or a file object.  If a file object it must be opened with *newline=’‘*
- ``sep`` : Field delimiter for the output file (default “,”)
- ``na_rep``: A string representation of a missing value (default ‘’)
- ``float_format``: Format string for floating point numbers
- ``columns``: Columns to write (default None)
- ``header``: Whether to write out the column names (default True)
- ``index``: whether to write row (index) names (default True)
- ``index_label``: Column label(s) for index column(s) if desired. If None
(default), and *header* and *index* are True, then the index names are
used. (A sequence should be given if the ``DataFrame`` uses MultiIndex).
- ``mode`` : Python write mode, default ‘w’
- ``encoding``: a string representing the encoding to use if the contents are
non-ASCII, for Python versions prior to 3
- ``line_terminator``: Character sequence denoting line end (default *os.linesep*)
- ``quoting``: Set quoting rules as in csv module (default csv.QUOTE_MINIMAL). Note that if you have set a *float_format* then floats are converted to strings and csv.QUOTE_NONNUMERIC will treat them as non-numeric
- ``quotechar``: Character used to quote fields (default ‘”’)
- ``doublequote``: Control quoting of ``quotechar`` in fields (default True)
- ``escapechar``: Character used to escape ``sep`` and ``quotechar`` when
appropriate (default None)
- ``chunksize``: Number of rows to write at a time
- ``date_format``: Format string for datetime objects

#### Writing a formatted string

The ``DataFrame`` object has an instance method ``to_string`` which allows control
over the string representation of the object. All arguments are optional:

- ``buf`` default None, for example a StringIO object
- ``columns`` default None, which columns to write
- ``col_space`` default None, minimum width of each column.
- ``na_rep`` default ``NaN``, representation of NA value
- ``formatters`` default None, a dictionary (by column) of functions each of
which takes a single argument and returns a formatted string
- ``float_format`` default None, a function which takes a single (float)
argument and returns a formatted string; to be applied to floats in the
``DataFrame``.
- ``sparsify`` default True, set to False for a ``DataFrame`` with a hierarchical
index to print every MultiIndex key at each row.
- ``index_names`` default True, will print the names of the indices
- ``index`` default True, will print the index (ie, row labels)
- ``header`` default True, will print the column labels
- ``justify`` default ``left``, will print column headers left- or
right-justified

The ``Series`` object also has a ``to_string`` method, but with only the ``buf``,
``na_rep``, ``float_format`` arguments. There is also a ``length`` argument
which, if set to ``True``, will additionally output the length of the Series.

## JSON

读取和写入 `JSON` 格式的文本和字符串。

### Writing JSON

一个`Series` 或 ` DataFrame` 能转化成一个有效的`JSON`字符串。使用`to_json` 同可选的参数：
- `path_or_buf` ： 写入输出的路径名或缓存可以是`None` ， 在这种情况下会返回一个JSON字符串。
- `orient` :

   `Series` :
    -  默认是 `index` ；
    - 允许的值可以是{`split`, `records`, `index`}。
  
  `DataFrame` : 
  - 默认是 `columns` ;
  - 允许的值可以是{`split`,  `records`, ` index`, `columns`, `values`, `table`}。
  
  JSON字符串的格式：
  

  split  |  dict like {index -> [index], columns -> [columns], data -> [values]}
  ------------- | -------------
  records |  list like [{column -> value}, … , {column -> value}]
  index  |  dict like {index -> {column -> value}}
  columns  |  dict like {column -> {index -> value}}
  values  |  just the values array
    
- `date_format` : 字符串，日期类型的转换，'eposh'是时间戳，'iso'是 ISO8601。

- `double_precision` : 当要编码的是浮点数值时使用的小数位数，默认是 10。

- `force_ascii` : 强制编码字符串为 ASCII , 默认是True。

- `date_unit` : 时间单位被编码来管理时间戳 和 ISO8601精度。's', 'ms', 'us' 或'ns'中的一个分别为 秒，毫秒，微秒，纳秒。默认是 'ms'。

- `default_handler` : 如果一个对象没有转换成一个恰当的JSON格式，处理程序就会被调用。采用单个参数，即要转换的对象，并返回一个序列化的对象。

- `lines` ： 如果面向 `records` ，就将每行写入记录为json。

注意：`NaN`'S , `NaT`'S 和`None` 将会被转换为`null`, 并且`datetime` 将会基于`date_format` 和 `date_unit` 两个参数转换。 

```python
In [192]: dfj = pd.DataFrame(np.random.randn(5, 2), columns=list('AB'))

In [193]: json = dfj.to_json()

In [194]: json
Out[194]: '{"A":{"0":-1.2945235903,"1":0.2766617129,"2":-0.0139597524,"3":-0.0061535699,"4":0.8957173022},"B":{"0":0.4137381054,
"1":-0.472034511,"2":-0.3625429925,"3":-0.923060654,"4":0.8052440254}}'
```

#### 面向选项（Orient options）

要生成JSON文件/字符串，这儿有很多可选的格式。如下面的 `DataFrame ` 和 `Series` :

```python
In [195]: dfjo = pd.DataFrame(dict(A=range(1, 4), B=range(4, 7), C=range(7, 10)),
       ..... :                     columns=list('ABC'), index=list('xyz'))
       ..... : 

In [196]: dfjo
Out[196]: 
   A  B  C
x  1  4  7
y  2  5  8
z  3  6  9

In [197]: sjo = pd.Series(dict(x=15, y=16, z=17), name='D')

In [198]: sjo
Out[198]: 
x    15
y    16
z    17
Name: D, dtype: int64

```

**面向列**  序列化数据（默认是 `DataFrame`)来作为嵌套的JSON对象，且列标签充当主索引：

```python
In [199]: dfjo.to_json(orient="columns")
Out[199]: '{"A":{"x":1,"y":2,"z":3},"B":{"x":4,"y":5,"z":6},"C":{"x":7,"y":8,"z":9}}'

# Not available for Series （不适用于 Series）

```

**面向索引** （默认是 `Series`) 与面向列类似，但是索引标签是主键：

```python
In [200]: dfjo.to_json(orient="index")
Out[200]: '{"x":{"A":1,"B":4,"C":7},"y":{"A":2,"B":5,"C":8},"z":{"A":3,"B":6,"C":9}}'

In [201]: sjo.to_json(orient="index")
Out[201]: '{"x":15,"y":16,"z":17}'

```

**面向记录**  序列化数据为一列JSON数组 -> 值的记录，索引标签不包括在内。这个在传递 `DataFrame` 数据到绘图库的时候很有用，例如JavaScript库 `d3.js` :

```python
In [202]: dfjo.to_json(orient="records")
Out[202]: '[{"A":1,"B":4,"C":7},{"A":2,"B":5,"C":8},{"A":3,"B":6,"C":9}]'

In [203]: sjo.to_json(orient="records")
Out[203]: '[15,16,17]'

```

**面向值** 是一个概要的选项，它只序列化为嵌套的JSON数组值，列和索引标签不包括在内：

```python
In [204]: dfjo.to_json(orient="values")
Out[204]: '[[1,4,7],[2,5,8],[3,6,9]]'

# Not available for Series

```

**面向切分** 序列化成一个JSON对象，它包括单项的值、索引和列。`Series` 的命名也包括：

```python
In [205]: dfjo.to_json(orient="split")
Out[205]: '{"columns":["A","B","C"],"index":["x","y","z"],"data":[[1,4,7],[2,5,8],[3,6,9]]}'

In [206]: sjo.to_json(orient="split")
Out[206]: '{"name":"D","index":["x","y","z"],"data":[15,16,17]}'

```

**面向表格** 序列化为JSON的[ 表格模式（Table Schema）](https://specs.frictionlessdata.io/json-table-schema/ " Table Schema")，允许保存为元数据，包括但不限于dtypes和索引名称。

::: tip 注意

任何面向选项编码为一个JSON对象在转为序列化期间将不会保留索引和列标签的顺序。如果你想要保留标签的顺序，就使用`split`选项，因为它使用有序的容器。

:::

#### 日期处理（Date handling）

用ISO日期格式来写入：

```python
In [207]: dfd = pd.DataFrame(np.random.randn(5, 2), columns=list('AB'))

In [208]: dfd['date'] = pd.Timestamp('20130101')

In [209]: dfd = dfd.sort_index(1, ascending=False)

In [210]: json = dfd.to_json(date_format='iso')

In [211]: json
Out[211]: '{"date":{"0":"2013-01-01T00:00:00.000Z","1":"2013-01-01T00:00:00.000Z","2":"2013-01-01T00:00:00.000Z","3":"2013-01-01T00:00:00.000Z","4":"2013-01-01T00:00:00.000Z"},"B":{"0":2.5656459463,"1":1.3403088498,"2":-0.2261692849,"3":0.8138502857,"4":-0.8273169356},"A":{"0":-1.2064117817,"1":1.4312559863,"2":-1.1702987971,"3":0.4108345112,"4":0.1320031703}}'

```

以ISO日期格式的微秒单位写入：

```python
In [212]: json = dfd.to_json(date_format='iso', date_unit='us')

In [213]: json
Out[213]: '{"date":{"0":"2013-01-01T00:00:00.000000Z","1":"2013-01-01T00:00:00.000000Z","2":"2013-01-01T00:00:00.000000Z","3":"2013-01-01T00:00:00.000000Z","4":"2013-01-01T00:00:00.000000Z"},"B":{"0":2.5656459463,"1":1.3403088498,"2":-0.2261692849,"3":0.8138502857,"4":-0.8273169356},"A":{"0":-1.2064117817,"1":1.4312559863,"2":-1.1702987971,"3":0.4108345112,"4":0.1320031703}}

```
时间戳的时间，以秒为单位：

```python
In [214]: json = dfd.to_json(date_format='epoch', date_unit='s')

In [215]: json
Out[215]: '{"date":{"0":1356998400,"1":1356998400,"2":1356998400,"3":1356998400,"4":1356998400},"B":{"0":2.5656459463,"1":1.3403088498,"2":-0.2261692849,"3":0.8138502857,"4":-0.8273169356},"A":{"0":-1.2064117817,"1":1.4312559863,"2":-1.1702987971,"3":0.4108345112,"4":0.1320031703}}'

```

写入文件，以日期索引和日期列格式：

```python
In [216]: dfj2 = dfj.copy()

In [217]: dfj2['date'] = pd.Timestamp('20130101')

In [218]: dfj2['ints'] = list(range(5))

In [219]: dfj2['bools'] = True

In [220]: dfj2.index = pd.date_range('20130101', periods=5)

In [221]: dfj2.to_json('test.json')

In [222]: with open('test.json') as fh:
        .....:     print(fh.read())
        .....: 
{"A":{"1356998400000":-1.2945235903,"1357084800000":0.2766617129,"1357171200000":-0.0139597524,"1357257600000":-0.0061535699,"1357344000000":0.8957173022},"B":{"1356998400000":0.4137381054,"1357084800000":-0.472034511,"1357171200000":-0.3625429925,"1357257600000":-0.923060654,"1357344000000":0.8052440254},"date":{"1356998400000":1356998400000,"1357084800000":1356998400000,"1357171200000":1356998400000,"1357257600000":1356998400000,"1357344000000":1356998400000},"ints":{"1356998400000":0,"1357084800000":1,"1357171200000":2,"1357257600000":3,"1357344000000":4},"bools":{"1356998400000":true,"1357084800000":true,"1357171200000":true,"1357257600000":true,"1357344000000":true}}

```

#### 回退行为（Fallback behavior）

如果JSON序列不能直接处理容器的内容，他将会以下面的方式发生回退：

- 如果dtype是不被支持的（例如：` np.complex` ) ，则将为每个值调用 `default_handler` （如果提供），否则引发异常。

- 如果对象不受支持，它将尝试以下操作：
    -  检查一下是否对象被定义为 `toDict ` 的方法并调用它。`toDict`的方法将返回一个`dict`，它将会是序列化的JSON格式。
	- 如果提供了`default_handler`，则调用它。
    - 通过遍历其内容将对象转换为`dict`。 但是，这通常会出现`OverflowError`而失败或抛出意外的结果。

通常，对于不被支持的对象或dtypes，处理的最佳方法是提供`default_handler`。 例如:

``` python
>>> DataFrame([1.0, 2.0, complex(1.0, 2.0)]).to_json()  # raises
RuntimeError: Unhandled numpy dtype 15

```

可以通过指定一个简单`default_handler`来处理：

``` python
In [223]: pd.DataFrame([1.0, 2.0, complex(1.0, 2.0)]).to_json(default_handler=str)
Out[223]: '{"0":{"0":"(1+0j)","1":"(2+0j)","2":"(1+2j)"}}'

```

### JSON的读取（Reading JSON)

把JSON字符串读取到pandas对象里会采用很多参数。如果`typ`没有提供或者为`None`，解析器将尝试解析`DataFrame`。 要强制地进行`Series`解析，请传递参数如`typ = series`。

- `filepath_or_buffer` : 一个**有效**的JSON字符串或文件句柄/StringIO(在内存中读写字符串)。字符串可以是一个URL。有效的URL格式包括http， ftp， S3和文件。对于文件型的URL, 最好有个主机地址。例如一个本地文件可以是 file://localhost/path/to/table.json 这样的格式。

- `typ` ： 要恢复的对象类型（series或者frame），默认“frame”。

- `orient` :

  Series:  
    - 默认是 `index `。
    - 允许值为{ `split`, `records`, `index`}。

  DataFrame:
  - 默认是 `columns `。
  - 允许值是{ `split`, `records`, `index`, `columns`, `values`, `table`}。
  
JSON字符串的格式：
  

  split  |  dict like {index -> [index], columns -> [columns], data -> [values]}
  ------------- | -------------
  records |  list like [{column -> value}, … , {column -> value}]
  index  |  dict like {index -> {column -> value}}
  columns  |  dict like {column -> {index -> value}}
  values  |  just the values array
  table  | adhering to the JSON [Table Schema](https://specs.frictionlessdata.io/json-table-schema/)

- ` dtype `： 如果为True，推断dtypes，如果列为dtype的字典，则使用那些；如果为`False`，则根本不推断dtypes，默认为True，仅适用于数据。

- `convert_axes` ： 布尔值，尝试将轴转换为正确的dtypes，默认为`True`。

- `convert_dates` ：一列列表要解析为日期; 如果为`True`，则尝试解析类似日期的列，默认为`True`。

- `keep_default_dates` ：布尔值，默认为`True`。 如果解析日期，则解析默认的类似日期的列。

- `numpy` ：直接解码为NumPy数组。 默认为`False`; 虽然标签可能是非数字的，但仅支持数字数据。 另请注意，如果`numpy = True`，则每个术语的JSON顺序 **必须** 相同。

- `precise_float` ：布尔值，默认为`False`。 当解码字符串为双值时，设置为能使用更高精度（strtod）函数。 默认（`False`）快速使用但不精确的内置功能。

- `date_unit` ：字符串，用于检测转换日期的时间戳单位。 默认无。 默认情况下，将检测时间戳精度，如果不需要，则传递's'，'ms'，'us'或'ns'中的一个，以强制时间戳精度分别为秒，毫秒，微秒或纳秒。

- `lines` ：读取文件每行作为一个JSON对象。

- `encoding` ：用于解码py3字节的编码。

- `chunksize` ：当与`lines = True`结合使用时，返回一个Json读取器（JSONReader），每次迭代读取`chunksize`行。

如果JSON不能解析，解析器将抛出`ValueError / TypeError / AssertionError `中的一个错误。

如果在编码为JSON时使用非默认的`orient`方法，请确保在此处传递相同的选项以便解码产生合理的结果，请参阅 [Orient Options](https://www.pypandas.cn/docs/user_guide/io.html#orient-options)以获取概述。

#### 数据转换（Data conversion）

`convert_axes = True`，`dtype = True`和`convert_dates = True`的默认值将尝试解析轴，并将所有数据解析为适当的类型，包括日期。 如果需要覆盖特定的dtypes，请将字典传递给`dtype`。 如果您需要在轴中保留类似字符串的数字（例如“1”，“2”），则只应将`convert_axes`设置为`False`。

::: tip 注意

如果`convert_dates = True`并且数据和/或列标签显示为“类似日期（'date-like'）“，则可以将大的整数值转换为日期。 确切的标准取决于指定的`date_unit`。 'date-like'表示列标签符合以下标准之一：
- 结尾以 `'_at'`
- 结尾以 `'_time'`
- 开头以 `'timestamp'`
- 它是 `'modified'`
- 它是 `'date'`

:::

::: danger 警告

在读取JSON数据时，自动强制转换为dtypes有一些不同寻常的地方：

- 索引可以按序列化的不同顺序重建，也就是说，返回的顺序不能保证与序列化之前的顺序相同

- 如果可以安全地，那么一列浮动（`float`)数据将被转换为一列整数(`integer`)，例如 一列 `1`
- 布尔列将在重建时转换为整数（`integer `)

因此，有时你会有那样的时刻可能想通过`dtype`关键字参数指定特定的dtypes。

:::

读取JSON字符串：

```python
In [224]: pd.read_json(json)
Out[224]: 
        date         B         A
0 2013-01-01  2.565646 -1.206412
1 2013-01-01  1.340309  1.431256
2 2013-01-01 -0.226169 -1.170299
3 2013-01-01  0.813850  0.410835
4 2013-01-01 -0.827317  0.132003

```
读取文件：

```python
In [225]: pd.read_json('test.json')
Out[225]: 
                   A         B       date  ints  bools
2013-01-01 -1.294524  0.413738 2013-01-01     0   True
2013-01-02  0.276662 -0.472035 2013-01-01     1   True
2013-01-03 -0.013960 -0.362543 2013-01-01     2   True
2013-01-04 -0.006154 -0.923061 2013-01-01     3   True
2013-01-05  0.895717  0.805244 2013-01-01     4   True

```
不要转换任何数据（但仍然转换轴和日期）：

```python
In [226]: pd.read_json('test.json', dtype=object).dtypes
Out[226]: 
A        object
B        object
date     object
ints     object
bools    object
dtype:   object

```
指定转换的dtypes：

```python
In [227]: pd.read_json('test.json', dtype={'A': 'float32', 'bools': 'int8'}).dtypes
Out[227]: 
A               float32
B               float64
date     datetime64[ns]
ints              int64
bools              int8
dtype:   object

```
保留字符串索引：

```python
In [228]: si = pd.DataFrame(np.zeros((4, 4)), columns=list(range(4)),
   .....:                   index=[str(i) for i in range(4)])
   .....: 

In [229]: si
Out[229]: 
     0    1    2    3
0  0.0  0.0  0.0  0.0
1  0.0  0.0  0.0  0.0
2  0.0  0.0  0.0  0.0
3  0.0  0.0  0.0  0.0

In [230]: si.index
Out[230]: Index(['0', '1', '2', '3'], dtype='object')

In [231]: si.columns
Out[231]: Int64Index([0, 1, 2, 3], dtype='int64')

In [232]: json = si.to_json()

In [233]: sij = pd.read_json(json, convert_axes=False)

In [234]: sij
Out[234]: 
   0  1  2  3
0  0  0  0  0
1  0  0  0  0
2  0  0  0  0
3  0  0  0  0

In [235]: sij.index
Out[235]: Index(['0', '1', '2', '3'], dtype='object')

In [236]: sij.columns
Out[236]: Index(['0', '1', '2', '3'], dtype='object')

```
以纳秒为单位的日期需要以纳秒为单位读回：

``` python
In [237]: json = dfj2.to_json(date_unit='ns')

# Try to parse timestamps as milliseconds -> Won't Work
In [238]: dfju = pd.read_json(json, date_unit='ms')

In [239]: dfju
Out[239]: 
                            A         B                 date  ints  bools
1356998400000000000 -1.294524  0.413738  1356998400000000000     0   True
1357084800000000000  0.276662 -0.472035  1356998400000000000     1   True
1357171200000000000 -0.013960 -0.362543  1356998400000000000     2   True
1357257600000000000 -0.006154 -0.923061  1356998400000000000     3   True
1357344000000000000  0.895717  0.805244  1356998400000000000     4   True

# Let pandas detect the correct precision
In [240]: dfju = pd.read_json(json)

In [241]: dfju
Out[241]: 
                   A         B       date  ints  bools
2013-01-01 -1.294524  0.413738 2013-01-01     0   True
2013-01-02  0.276662 -0.472035 2013-01-01     1   True
2013-01-03 -0.013960 -0.362543 2013-01-01     2   True
2013-01-04 -0.006154 -0.923061 2013-01-01     3   True
2013-01-05  0.895717  0.805244 2013-01-01     4   True

# Or specify that all timestamps are in nanoseconds
In [242]: dfju = pd.read_json(json, date_unit='ns')

In [243]: dfju
Out[243]: 
                   A         B       date  ints  bools
2013-01-01 -1.294524  0.413738 2013-01-01     0   True
2013-01-02  0.276662 -0.472035 2013-01-01     1   True
2013-01-03 -0.013960 -0.362543 2013-01-01     2   True
2013-01-04 -0.006154 -0.923061 2013-01-01     3   True
2013-01-05  0.895717  0.805244 2013-01-01     4   True

```

#### Numpy 参数

::: tip 注意

这仅支持数值数据。 索引和列标签可以是非数字的，例如 字符串，日期等。

:::

如果将`numpy = True`传递给`read_json`，则会在反序列化期间尝试找到适当的dtype，然后直接解码到NumPy数组，从而绕过对中间Python对象的需求。

如果要反序列化大量数值数据，这可以提供加速：

``` python
In [244]: randfloats = np.random.uniform(-100, 1000, 10000)

In [245]: randfloats.shape = (1000, 10)

In [246]: dffloats = pd.DataFrame(randfloats, columns=list('ABCDEFGHIJ'))

In [247]: jsonfloats = dffloats.to_json()

```

``` python
In [248]: %timeit pd.read_json(jsonfloats)
12.4 ms +- 116 us per loop (mean +- std. dev. of 7 runs, 100 loops each)

```

``` python
In [249]: %timeit pd.read_json(jsonfloats, numpy=True)
9.56 ms +- 82.8 us per loop (mean +- std. dev. of 7 runs, 100 loops each)

```

对于较小的数据集，加速不太明显：

``` python
In [250]: jsonfloats = dffloats.head(100).to_json()

```

``` python
In [251]: %timeit pd.read_json(jsonfloats)
8.05 ms +- 120 us per loop (mean +- std. dev. of 7 runs, 100 loops each)

```

``` python
In [252]: %timeit pd.read_json(jsonfloats, numpy=True)
7 ms +- 162 us per loop (mean +- std. dev. of 7 runs, 100 loops each)

```
::: danger 警告

直接NumPy解码会产生许多假设并可能导致失败，或如果这些假设不满足，则产生意外地输出：

- 数据是数值。
- 数据是统一的。 从解码的第一个值中找到dtype。可能会引发`ValueError`错误，或者如果这个条件不满足可能产生不正确的输出。

- 标签是有序的。 标签仅从第一个容器读取，假设每个后续行/列已按相同顺序编码。 如果使用`to_json`编码数据，则应该满足这一要求，但如果JSON来自其他来源，则可能不是这种情况。

:::


### 标准化（Normalization）

pandas提供了一个实用程序函数来获取一个字典或字典列表，并将这个半结构化数据规范化为一个平面表。

``` python
In [253]: from pandas.io.json import json_normalize

In [254]: data = [{'id': 1, 'name': {'first': 'Coleen', 'last': 'Volk'}},
   .....:         {'name': {'given': 'Mose', 'family': 'Regner'}},
   .....:         {'id': 2, 'name': 'Faye Raker'}]
   .....: 

In [255]: json_normalize(data)
Out[255]: 
    id name.first name.last name.given name.family        name
0  1.0     Coleen      Volk        NaN         NaN         NaN
1  NaN        NaN       NaN       Mose      Regner         NaN
2  2.0        NaN       NaN        NaN         NaN  Faye Raker

```

``` python
In [256]: data = [{'state': 'Florida',
   .....:          'shortname': 'FL',
   .....:          'info': {'governor': 'Rick Scott'},
   .....:          'counties': [{'name': 'Dade', 'population': 12345},
   .....:                       {'name': 'Broward', 'population': 40000},
   .....:                       {'name': 'Palm Beach', 'population': 60000}]},
   .....:         {'state': 'Ohio',
   .....:          'shortname': 'OH',
   .....:          'info': {'governor': 'John Kasich'},
   .....:          'counties': [{'name': 'Summit', 'population': 1234},
   .....:                       {'name': 'Cuyahoga', 'population': 1337}]}]
   .....: 

In [257]: json_normalize(data, 'counties', ['state', 'shortname', ['info', 'governor']])
Out[257]: 
         name  population    state shortname info.governor
0        Dade       12345  Florida        FL    Rick Scott
1     Broward       40000  Florida        FL    Rick Scott
2  Palm Beach       60000  Florida        FL    Rick Scott
3      Summit        1234     Ohio        OH   John Kasich
4    Cuyahoga        1337     Ohio        OH   John Kasich

```
max_level 参数提供了对结束规范化的级别的更多控制。 当max_level = 1时，以下代码段会标准化，直到提供了字典的第一个嵌套级别为止。

``` python
In [258]: data = [{'CreatedBy': {'Name': 'User001'},
   .....:          'Lookup': {'TextField': 'Some text',
   .....:                     'UserField': {'Id': 'ID001',
   .....:                                   'Name': 'Name001'}},
   .....:          'Image': {'a': 'b'}
   .....:          }]
   .....: 

In [259]: json_normalize(data, max_level=1)
Out[259]: 
  CreatedBy.Name Lookup.TextField                    Lookup.UserField Image.a
0        User001        Some text  {'Id': 'ID001', 'Name': 'Name001'}       b

```

### json的行分割（Line delimited json）

*New in version 0.19.0.* 

pandas能够读取和写入行分隔的json文件通常是在用Hadoop或Spark进行数据处理的管道中。

*New in version 0.21.0.* 

对于行分隔的json文件，pandas也可以返回一个迭代器，它能一次读取`chunksize`行。 这对于大型文件或从数据流中读取非常有用。

``` python
In [260]: jsonl = '''
   .....:     {"a": 1, "b": 2}
   .....:     {"a": 3, "b": 4}
   .....: '''
   .....: 

In [261]: df = pd.read_json(jsonl, lines=True)

In [262]: df
Out[262]: 
   a  b
0  1  2
1  3  4

In [263]: df.to_json(orient='records', lines=True)
Out[263]: '{"a":1,"b":2}\n{"a":3,"b":4}'

# reader is an iterator that returns `chunksize` lines each iteration
In [264]: reader = pd.read_json(StringIO(jsonl), lines=True, chunksize=1)

In [265]: reader
Out[265]: <pandas.io.json._json.JsonReader at 0x7f65f15bac18>

In [266]: for chunk in reader:
   .....:     print(chunk)
   .....: 
Empty DataFrame
Columns: []
Index: []
   a  b
0  1  2
   a  b
1  3  4

```

### 表模式（Table schema）

*New in version 0.20.0.* 

表模式（[Table schema](https://specs.frictionlessdata.io/json-table-schema/)）是用于将表格数据集描述为JSON对象的一种规范。 JSON包含有关字段名称，类型和其他属性的信息。 你可以使用面向`table`来构建一个JSON字符串包含两个字段，`schema`和`data`。

``` python
In [267]: df = pd.DataFrame({'A': [1, 2, 3],
   .....:                    'B': ['a', 'b', 'c'],
   .....:                    'C': pd.date_range('2016-01-01', freq='d', periods=3)},
   .....:                   index=pd.Index(range(3), name='idx'))
   .....: 

In [268]: df
Out[268]: 
     A  B          C
idx                 
0    1  a 2016-01-01
1    2  b 2016-01-02
2    3  c 2016-01-03

In [269]: df.to_json(orient='table', date_format="iso")
Out[269]: '{"schema": {"fields":[{"name":"idx","type":"integer"},{"name":"A","type":"integer"},{"name":"B","type":"string"},{"name":"C","type":"datetime"}],"primaryKey":["idx"],"pandas_version":"0.20.0"}, "data": [{"idx":0,"A":1,"B":"a","C":"2016-01-01T00:00:00.000Z"},{"idx":1,"A":2,"B":"b","C":"2016-01-02T00:00:00.000Z"},{"idx":2,"A":3,"B":"c","C":"2016-01-03T00:00:00.000Z"}]}'

```
`schema`字段包含`fields`主键，它本身包含一个列名称到列对的列表，包括`Index`或`MultiIndex`（请参阅下面的类型列表）。 如果（多）索引是唯一的，则`schema`字段也包含一个`primaryKey`字段。

第二个字段`data`包含用面向`records`来序列化数据。 索引是包括的，并且任何日期时间都是ISO 8601格式，正如表模式规范所要求的那样。

表模式规范中描述了所有支持的全部类型列表。 此表显示了pandas类型的映射：

Pandas type | Table Schema type
---|---
int64 | integer
float64 | number
bool | boolean
datetime64[ns] | datetime
timedelta64[ns] | duration
categorical | any
object | str

关于生成的表模式的一些注意事项：

- `schema`对象包含`pandas_version`的字段。 它包含模式的pandas方言版本，并将随每个修订增加。
- 序列化时，所有日期都转换为UTC。 甚至是时区的初始值，也被视为UTC，偏移量为0。

``` python
In [270]: from pandas.io.json import build_table_schema

In [271]: s = pd.Series(pd.date_range('2016', periods=4))

In [272]: build_table_schema(s)
Out[272]: 
{'fields': [{'name': 'index', 'type': 'integer'},
  {'name': 'values', 'type': 'datetime'}],
 'primaryKey': ['index'],
 'pandas_version': '0.20.0'}

```
- 具有时区的日期时间（在序列化之前），包括具有时区名称的附加字段`tz`（例如：`'US / Central'`）。

``` python
In [273]: s_tz = pd.Series(pd.date_range('2016', periods=12,
   .....:                                tz='US/Central'))
   .....: 

In [274]: build_table_schema(s_tz)
Out[274]: 
{'fields': [{'name': 'index', 'type': 'integer'},
  {'name': 'values', 'type': 'datetime', 'tz': 'US/Central'}],
 'primaryKey': ['index'],
 'pandas_version': '0.20.0'}

```
- 时间段在序列化之前是转换为时间戳的，因此具有转换为UTC的相同方式。 此外，时间段将包含具有时间段频率的附加字段`freq`，例如：`'A-DEC'`。

``` python
In [275]: s_per = pd.Series(1, index=pd.period_range('2016', freq='A-DEC',
   .....:                                            periods=4))
   .....: 

In [276]: build_table_schema(s_per)
Out[276]: 
{'fields': [{'name': 'index', 'type': 'datetime', 'freq': 'A-DEC'},
  {'name': 'values', 'type': 'integer'}],
 'primaryKey': ['index'],
 'pandas_version': '0.20.0'}

```
- 分类使用`any`类型和`enum`约束来列出可能值的集合。 此外，还包括一个`ordered`字段：

``` python
In [277]: s_cat = pd.Series(pd.Categorical(['a', 'b', 'a']))

In [278]: build_table_schema(s_cat)
Out[278]: 
{'fields': [{'name': 'index', 'type': 'integer'},
  {'name': 'values',
   'type': 'any',
   'constraints': {'enum': ['a', 'b']},
   'ordered': False}],
 'primaryKey': ['index'],
 'pandas_version': '0.20.0'}

```
- 如果索引是唯一的，则包含`primaryKey`字段,它包含了标签数组：

``` python
In [279]: s_dupe = pd.Series([1, 2], index=[1, 1])

In [280]: build_table_schema(s_dupe)
Out[280]: 
{'fields': [{'name': 'index', 'type': 'integer'},
  {'name': 'values', 'type': 'integer'}],
 'pandas_version': '0.20.0'}

```
- `primaryKey `的形式与多索引相同，但在这种情况下，`primaryKey`是一个数组：

``` python
In [281]: s_multi = pd.Series(1, index=pd.MultiIndex.from_product([('a', 'b'),
   .....:                                                          (0, 1)]))
   .....: 

In [282]: build_table_schema(s_multi)
Out[282]: 
{'fields': [{'name': 'level_0', 'type': 'string'},
  {'name': 'level_1', 'type': 'integer'},
  {'name': 'values', 'type': 'integer'}],
 'primaryKey': FrozenList(['level_0', 'level_1']),
 'pandas_version': '0.20.0'}

```
- 默认命名大致遵循以下规则：

  - 对于series，使用`object.name`。 如果没有，那么名称就是`values`
  - 对于`DataFrames`，使用列名称的字符串化版本 
  - 对于`Index`（不是`MultiIndex`），使用`index.name`，如果为None，则使用回退`index`。 
  - 对于`MultiIndex`，使用`mi.names`。 如果任何级别没有名称，则使用`level_`。

*New in version 0.23.0.* 

`read_json`也接受`orient ='table'`作为参数。 这允许以可循环移动的方式保存诸如dtypes和索引名称之类的元数据。

``` python
In [283]: df = pd.DataFrame({'foo': [1, 2, 3, 4],
   .....:        'bar': ['a', 'b', 'c', 'd'],
   .....:        'baz': pd.date_range('2018-01-01', freq='d', periods=4),
   .....:        'qux': pd.Categorical(['a', 'b', 'c', 'c'])
   .....:        }, index=pd.Index(range(4), name='idx'))
   .....: 

In [284]: df
Out[284]: 
     foo bar        baz qux
idx                        
0      1   a 2018-01-01   a
1      2   b 2018-01-02   b
2      3   c 2018-01-03   c
3      4   d 2018-01-04   c

In [285]: df.dtypes
Out[285]: 
foo             int64
bar            object
baz    datetime64[ns]
qux          category
dtype: object

In [286]: df.to_json('test.json', orient='table')

In [287]: new_df = pd.read_json('test.json', orient='table')

In [288]: new_df
Out[288]: 
     foo bar        baz qux
idx                        
0      1   a 2018-01-01   a
1      2   b 2018-01-02   b
2      3   c 2018-01-03   c
3      4   d 2018-01-04   c

In [289]: new_df.dtypes
Out[289]: 
foo             int64
bar            object
baz    datetime64[ns]
qux          category
dtype: object

```
请注意，作为 [Index](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.html#pandas.Index) 名称的文字字符串'index'是不能循环移动的，也不能在 [MultiIndex](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.html#pandas.MultiIndex) 中用以`'level_'`开头的任何名称。 这些默认情况下在 [DataFrame.to_json（)](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_json.html#pandas.DataFrame.to_json) 中用于指示缺失值和后续读取无法区分的目的。

``` python
In [290]: df.index.name = 'index'

In [291]: df.to_json('test.json', orient='table')

In [292]: new_df = pd.read_json('test.json', orient='table')

In [293]: print(new_df.index.name)
None

```

## HTML

### 读取HTML的内容

::: danger 警告：

我们**强烈建议**你阅读 [HTML Table Parsing gotchas](https://www.pypandas.cn/docs/user_guide/io.html#io-html-gotchas)里面相关的围绕BeautifulSoup4/html5lib/lxml解析器部分的问题。

:::

顶级的`read_html()`函数能接受HTML字符串/文件/URL格式，并且能解析HTML 表格为pandas`DataFrames`的列表，让我们看看下面的几个例子。

::: tip 注意：

`read_html`返回的是一个`DataFrame`对象的`list`，即便在HTML页面里只包含单个表格。

:::

读取一个没有选项的URL：

```python
In [294]: url = 'https://www.fdic.gov/bank/individual/failed/banklist.html'

In [295]: dfs = pd.read_html(url)

In [296]: dfs
Out[296]: 
[                                             Bank Name        City  ST   CERT                Acquiring Institution       Closing Date       Updated Date
 0                                 The Enloe State Bank      Cooper  TX  10716                   Legend Bank, N. A.       May 31, 2019      June 18, 2019
 1                  Washington Federal Bank for Savings     Chicago  IL  30570                   Royal Savings Bank  December 15, 2017   February 1, 2019
 2      The Farmers and Merchants State Bank of Argonia     Argonia  KS  17719                          Conway Bank   October 13, 2017  February 21, 2018
 3                                  Fayette County Bank  Saint Elmo  IL   1802            United Fidelity Bank, fsb       May 26, 2017   January 29, 2019
 4    Guaranty Bank, (d/b/a BestBank in Georgia & Mi...   Milwaukee  WI  30003  First-Citizens Bank & Trust Company        May 5, 2017     March 22, 2018
 ..                                                 ...         ...  ..    ...                                  ...                ...                ...
 551                                 Superior Bank, FSB    Hinsdale  IL  32646                Superior Federal, FSB      July 27, 2001    August 19, 2014
 552                                Malta National Bank       Malta  OH   6629                    North Valley Bank        May 3, 2001  November 18, 2002
 553                    First Alliance Bank & Trust Co.  Manchester  NH  34264  Southern New Hampshire Bank & Trust   February 2, 2001  February 18, 2003
 554                  National State Bank of Metropolis  Metropolis  IL   3815              Banterra Bank of Marion  December 14, 2000     March 17, 2005
 555                                   Bank of Honolulu    Honolulu  HI  21029                   Bank of the Orient   October 13, 2000     March 17, 2005
 
 [556 rows x 7 columns]]

```

::: tip 注意：

上面的URL数据修改了每个周一以至于上面的数据结果跟下面的数据结果可能有轻微的不同。

:::

从上面的URL读取文件内容并且传递它给`read_html`作为一个字符串：

```python
In [297]: with open(file_path, 'r') as f:
   .....:     dfs = pd.read_html(f.read())
   .....: 

In [298]: dfs
Out[298]: 
[                                    Bank Name          City  ST   CERT                Acquiring Institution       Closing Date       Updated Date
 0    Banks of Wisconsin d/b/a Bank of Kenosha       Kenosha  WI  35386                North Shore Bank, FSB       May 31, 2013       May 31, 2013
 1                        Central Arizona Bank    Scottsdale  AZ  34527                   Western State Bank       May 14, 2013       May 20, 2013
 2                                Sunrise Bank      Valdosta  GA  58185                         Synovus Bank       May 10, 2013       May 21, 2013
 3                       Pisgah Community Bank     Asheville  NC  58701                   Capital Bank, N.A.       May 10, 2013       May 14, 2013
 4                         Douglas County Bank  Douglasville  GA  21649                  Hamilton State Bank     April 26, 2013       May 16, 2013
 ..                                        ...           ...  ..    ...                                  ...                ...                ...
 500                        Superior Bank, FSB      Hinsdale  IL  32646                Superior Federal, FSB      July 27, 2001       June 5, 2012
 501                       Malta National Bank         Malta  OH   6629                    North Valley Bank        May 3, 2001  November 18, 2002
 502           First Alliance Bank & Trust Co.    Manchester  NH  34264  Southern New Hampshire Bank & Trust   February 2, 2001  February 18, 2003
 503         National State Bank of Metropolis    Metropolis  IL   3815              Banterra Bank of Marion  December 14, 2000     March 17, 2005
 504                          Bank of Honolulu      Honolulu  HI  21029                   Bank of the Orient   October 13, 2000     March 17, 2005
 
 [505 rows x 7 columns]]

```

甚至如果你想，你还可以传递一个`StringIO`的实例：

```python
In [299]: with open(file_path, 'r') as f:
   .....:     sio = StringIO(f.read())
   .....: 

In [300]: dfs = pd.read_html(sio)

In [301]: dfs
Out[301]: 
[                                    Bank Name          City  ST   CERT                Acquiring Institution       Closing Date       Updated Date
 0    Banks of Wisconsin d/b/a Bank of Kenosha       Kenosha  WI  35386                North Shore Bank, FSB       May 31, 2013       May 31, 2013
 1                        Central Arizona Bank    Scottsdale  AZ  34527                   Western State Bank       May 14, 2013       May 20, 2013
 2                                Sunrise Bank      Valdosta  GA  58185                         Synovus Bank       May 10, 2013       May 21, 2013
 3                       Pisgah Community Bank     Asheville  NC  58701                   Capital Bank, N.A.       May 10, 2013       May 14, 2013
 4                         Douglas County Bank  Douglasville  GA  21649                  Hamilton State Bank     April 26, 2013       May 16, 2013
 ..                                        ...           ...  ..    ...                                  ...                ...                ...
 500                        Superior Bank, FSB      Hinsdale  IL  32646                Superior Federal, FSB      July 27, 2001       June 5, 2012
 501                       Malta National Bank         Malta  OH   6629                    North Valley Bank        May 3, 2001  November 18, 2002
 502           First Alliance Bank & Trust Co.    Manchester  NH  34264  Southern New Hampshire Bank & Trust   February 2, 2001  February 18, 2003
 503         National State Bank of Metropolis    Metropolis  IL   3815              Banterra Bank of Marion  December 14, 2000     March 17, 2005
 504                          Bank of Honolulu      Honolulu  HI  21029                   Bank of the Orient   October 13, 2000     March 17, 2005
 
 [505 rows x 7 columns]]

```

::: tip 注意：

以下的例子在IPython的程序中不会运行，因为有太多的网络接入函数减缓了文档的创建。如果你的程序报错或者例子不运行，请立即向[ pandas GitHub issues page](https://www.github.com/pandas-dev/pandas/issues) 上报。

:::

读取一个URL并匹配表格里面所包含的具体文本内容：

```python
match = 'Metcalf Bank'
df_list = pd.read_html(url, match=match)

```

指定一个标题行（通过默认的\<th\>或者\<td\>定位并伴随一个\<thead\>被用来作为列的索引，如果是多行含有\<thead\>，则多索引就会被创建）；如果已经指定，标题行则从数据减去已解析的标题元素中获取（\<th\>元素）。

```python
dfs = pd.read_html(url, header=0)

```

指定一个索引列：

```python
dfs = pd.read_html(url, index_col=0)

```

指定跳过行的数量：

```python
dfs = pd.read_html(url, skiprows=0)

```

指定使用列表来跳过行的数量（`xrange`(只在Python 2 中)也有效）：

```python
dfs = pd.read_html(url, skiprows=range(2))

```

指定一个HTML属性：

```python
dfs1 = pd.read_html(url, attrs={'id': 'table'})
dfs2 = pd.read_html(url, attrs={'class': 'sortable'})
print(np.array_equal(dfs1[0], dfs2[0]))  # Should be True

```
指定值将会被转换为NaN(非数值)：

```python
dfs = pd.read_html(url, na_values=['No Acquirer'])

```

*New in version 0.19.*

指定是否保持默认的NaN值的设置：

```python
dfs = pd.read_html(url, keep_default_na=False)

```

*New in version 0.19.*

指定列的转换器。这对于有前置零的数字文本数据很有用。默认情况下，数值列会转换成数值类型且前置零会丢失。为了避免这种情况，我们能转换这些列为字符串。

```python
url_mcc = 'https://en.wikipedia.org/wiki/Mobile_country_code'
dfs = pd.read_html(url_mcc, match='Telekom Albania', header=0,
                   converters={'MNC': str})

```

*New in version 0.19.*

把上面的一些结合使用：

```python
dfs = pd.read_html(url, match='Metcalf Bank', index_col=0)

```

读取pandas`to_html`输出（同时一些精确的浮点会失去）：

```python
df = pd.DataFrame(np.random.randn(2, 2))
s = df.to_html(float_format='{0:.40g}'.format)
dfin = pd.read_html(s, index_col=0)

```

如果`lxml`后端是你提供的唯一解析器，那么它将在解析失败时报错。如果你能提供的解析器只有一个就选字符串，但是传递一个字符串列表会是很好的训练，例如，这个函数期望是一个字符串序列。你可以这样使用：

```python
dfs = pd.read_html(url, 'Metcalf Bank', index_col=0, flavor=['lxml'])

```

或者你可以传递`flavor='lxml'`而不要列表：

```python
dfs = pd.read_html(url, 'Metcalf Bank', index_col=0, flavor='lxml')

```

然而，如果你已经安装了bs4 和 html5lib并且传递`None`或`['lxml', 'bs4']`，那么极大可能会解析成功。注意*一旦解析成功了，函数将会返回。*

```python
dfs = pd.read_html(url, 'Metcalf Bank', index_col=0, flavor=['lxml', 'bs4'])

```

### 写入HTML文件

`DataFrame`对象具有实例的方法`to_html`，它能渲染`DataFrame`的内容为HTML表格。这个函数的参数同上面的`to_string`方法的一样。

::: tip 注意：

为了简洁起见，这儿显示的不是所有的`DataFrame.to_html`可选项。所有的选项设置见`to_html()`。

:::

```python
In [302]: df = pd.DataFrame(np.random.randn(2, 2))

In [303]: df
Out[303]: 
          0         1
0 -0.184744  0.496971
1 -0.856240  1.857977

In [304]: print(df.to_html())  # raw html
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
      <th>1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.184744</td>
      <td>0.496971</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.856240</td>
      <td>1.857977</td>
    </tr>
  </tbody>
</table>

```

HTML:

| **-** | **0** | **1** |
| --- | --- | --- |
| 0 | -0.184744  |  0.496971 |
| 1 | -0.856240  |  1.857977 |

```python
In [302]: df = pd.DataFrame(np.random.randn(2, 2))

In [303]: df
Out[303]: 
          0         1
0 -0.184744  0.496971
1 -0.856240  1.857977

In [304]: print(df.to_html())  # raw html
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
      <th>1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.184744</td>
      <td>0.496971</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.856240</td>
      <td>1.857977</td>
    </tr>
  </tbody>
</table>
```
`columns `参数将限制列的显示：

```python
In [305]: print(df.to_html(columns=[0]))
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.184744</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.856240</td>
    </tr>
  </tbody>
</table>

```
HTML：

| **-** | **0** |
| --- | --- |
| 0 | -0.184744  |
| 1 | -0.856240  |

`float_format`采用可调用的 Python来控制浮点值的精确度：

```python
In [306]: print(df.to_html(float_format='{0:.10f}'.format))
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
      <th>1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.1847438576</td>
      <td>0.4969711327</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.8562396763</td>
      <td>1.8579766508</td>
    </tr>
  </tbody>
</table>

```

HTML：

| **-** | **0** | **1** |
| --- | --- | --- |
| 0 | -0.1847438576 | 0.4969711327 |
| 1 | -0.8562396763 | 1.8579766508 |

默认情况下，`bold_rows`可以加粗行标签，但是你可以关掉它：

```python
In [307]: print(df.to_html(bold_rows=False))
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
      <th>1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>-0.184744</td>
      <td>0.496971</td>
    </tr>
    <tr>
      <td>1</td>
      <td>-0.856240</td>
      <td>1.857977</td>
    </tr>
  </tbody>
</table>

```

| **-** | **0** | **1** |
| --- | --- | --- |
|  0 | -0.184744 | 0.496971 |
|  1 | -0.856240 | 1.857977 |

`classes `参数提供了能生成HTML表的CSS类的功能。注意这些类是已添加到现有的`'dataframe' `类中的。

```python
In [308]: print(df.to_html(classes=['awesome_table_class', 'even_more_awesome_class']))
<table border="1" class="dataframe awesome_table_class even_more_awesome_class">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
      <th>1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.184744</td>
      <td>0.496971</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.856240</td>
      <td>1.857977</td>
    </tr>
  </tbody>
</table>

```
`render_links`参数提供了向包含URL的单元格添加超链接的功能。

*New in version 0.24.*

```python
In [309]: url_df = pd.DataFrame({
   .....:     'name': ['Python', 'Pandas'],
   .....:     'url': ['https://www.python.org/', 'http://pandas.pydata.org']})
   .....: 

In [310]: print(url_df.to_html(render_links=True))
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>name</th>
      <th>url</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Python</td>
      <td><a href="https://www.python.org/" target="_blank">https://www.python.org/</a></td>
    </tr>
    <tr>
      <th>1</th>
      <td>Pandas</td>
      <td><a href="http://pandas.pydata.org" target="_blank">http://pandas.pydata.org</a></td>
    </tr>
  </tbody>
</table>

```

HTML:

| **-** | **name** | **url** |
| --- | --- | --- |
| 0 | Python | [https://www.python.org/](https://www.python.org/) |
| 1 | Pandas | [http://pandas.pydata.org](http://pandas.pydata.org) |

最后，`escape`参数允许你控制是否对生成的 HTML字符“<”, “>”和 “&”进行转义（默认是`True`）。因此，获取不转义的HTML字符就设置为`escape=False`。

```python
In [311]: df = pd.DataFrame({'a': list('&<>'), 'b': np.random.randn(3)})

```
转义的：

```python
In [312]: print(df.to_html())
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>a</th>
      <th>b</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>&amp;</td>
      <td>-0.474063</td>
    </tr>
    <tr>
      <th>1</th>
      <td>&lt;</td>
      <td>-0.230305</td>
    </tr>
    <tr>
      <th>2</th>
      <td>&gt;</td>
      <td>-0.400654</td>
    </tr>
  </tbody>
</table>

```
| **-** | **a** | **b** |
| --- | --- | --- |
| 0 | & | -0.474063 |
| 1 | < | -0.230305 |
| 2 | > | -0.400654 |

不转义的：

```python
In [313]: print(df.to_html(escape=False))
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>a</th>
      <th>b</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>&</td>
      <td>-0.474063</td>
    </tr>
    <tr>
      <th>1</th>
      <td><</td>
      <td>-0.230305</td>
    </tr>
    <tr>
      <th>2</th>
      <td>></td>
      <td>-0.400654</td>
    </tr>
  </tbody>
</table>

```

| **-** | **a** | **b** |
| --- | --- | --- |
| 0 | & | -0.474063 |
| 1 | < | -0.230305 |
| 2 | > | -0.400654 |

::: tip 注意：

一些浏览器在渲染上面的两个HTML表格的时候可能看不出区别。

:::

### HTML表格解析陷阱

在使用顶级的pandas io函数`read_html`来解析HTML表格的时候，围绕这些库，存在一些版本的问题。

**[lxml](https://lxml.de/)问题**:

- 优点：
  - [lxml](https://lxml.de/) 是非常快的。
  - [lxml](https://lxml.de/)要求Cython正确安装。

- 缺点：
  - [lxml](https://lxml.de/) 不能保证它的解析结果除非使用[严格有效地标记](https://validator.w3.org/docs/help.html#validation_basics)。
  - 鉴于上述情况，我们选择允许用户使用 [lxml](https://lxml.de/) 作为后端，但是如果 [lxml](https://lxml.de/) 解析失败，**这个后端将使用[html5lib](https://github.com/html5lib/html5lib-python)**。
  - 因此，强烈推荐你安装**[BeautifulSoup4](https://www.crummy.com/software/BeautifulSoup)**和**[html5lib](https://github.com/html5lib/html5lib-python)**这两个库。这样即使[lxml](https://lxml.de/)解析失败，你仍然能够得到一个有效的结果（前提是其他所有内容都有效）。
  
**[BeautifulSoup4](https://www.crummy.com/software/BeautifulSoup)使用[lxml](https://lxml.de/)作为后端的问题**：

- 以上问题仍然会存在因为**[BeautifulSoup4](https://www.crummy.com/software/BeautifulSoup)**本质上是一个围绕后端解析的包装器。

**[BeautifulSoup4](https://www.crummy.com/software/BeautifulSoup)使用[html5lib](https://github.com/html5lib/html5lib-python)作为后端的问题**：

- 优点：
  - [html5lib](https://github.com/html5lib/html5lib-python)比[lxml](https://lxml.de/)宽容得多，所以会以一种更理智的方式处理*现实生活中的标记*，而不是仅仅，比如在未通知你的情况下删除元素。
  - [html5lib](https://github.com/html5lib/html5lib-python)*能自动从无效标记中生成有效的 HTML5 标记*。这在解析HTML表格的时候是相当重要的，因为它保证了它是有效的文件。然而这不意味着它是“正确的“，因为修复标记的过程没有一个定义。
  - [html5lib](https://github.com/html5lib/html5lib-python)是纯净的Python，除了它自己的安装步骤没有其他的步骤。
  
- 缺点：
  - 使用[html5lib](https://github.com/html5lib/html5lib-python)最大的缺点就是太慢了。但是考虑到网络上许多表格并不足以如解析算法运行时的那么重要，它更可能像是正在通过网络上的URL读取原始文本过程中的瓶颈。例如当IO（输入-输出） 时，对于非常大的表，事实可能并非如此。

## Excel 文件

[read_excel()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_excel.html#pandas.read_excel)方法使用Python的`xlrd`模块来读取Excel 2003（`.xls`)版的文件，而Excel 2007+ （`.xlsx`)版本的是用`xlrd`或者`openpyxl`模块来读取的。[to_excel()](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_excel.html#pandas.DataFrame.to_excel)方法则是用来把`DataFrame`数据存储为Excel格式。一般来说，它的语法同使用[csv](https://www.pypandas.cn/docs/user_guide/io.html#io-read-csv-table)数据是类似的，更多高级的用法可以参考[cookbook](https://www.pypandas.cn/docs/user_guide/cookbook.html#cookbook-excel)。

### 读取 Excel 文件

在大多数基本的使用案例中，`read_excel`会读取Excel文件通过一个路径，并且`sheet_name `会表明需要解析哪一张表格。

```python
# Returns a DataFrame
pd.read_excel('path_to_file.xls', sheet_name='Sheet1')

```

#### `ExcelFile` 类

为了更方便地读取同一个文件的多张表格，`ExcelFile`类可用来打包文件并传递给`read_excel`。因为仅需读取一次内存，所以这种方式读取一个文件的多张表格会有性能上的优势。

```python
xlsx = pd.ExcelFile('path_to_file.xls')
df = pd.read_excel(xlsx, 'Sheet1')

```

`ExcelFile`类也能用来作为上下文管理器。

```python
with pd.ExcelFile('path_to_file.xls') as xls:
    df1 = pd.read_excel(xls, 'Sheet1')
    df2 = pd.read_excel(xls, 'Sheet2')

```

`sheet_names`属性能将文件中的所有表格名字生成一组列表。

`ExcelFile`一个主要的用法就是用来解析多张表格的不同参数：

```python
data = {}
# For when Sheet1's format differs from Sheet2
with pd.ExcelFile('path_to_file.xls') as xls:
    data['Sheet1'] = pd.read_excel(xls, 'Sheet1', index_col=None,
                                   na_values=['NA'])
    data['Sheet2'] = pd.read_excel(xls, 'Sheet2', index_col=1)

```

注意如果所有的表格解析同一个参数，那么这组表格名的列表能轻易地传递给`read_excel`且不会有性能上地损失。

```python
# using the ExcelFile class
data = {}
with pd.ExcelFile('path_to_file.xls') as xls:
    data['Sheet1'] = pd.read_excel(xls, 'Sheet1', index_col=None,
                                   na_values=['NA'])
    data['Sheet2'] = pd.read_excel(xls, 'Sheet2', index_col=None,
                                   na_values=['NA'])

# equivalent using the read_excel function
data = pd.read_excel('path_to_file.xls', ['Sheet1', 'Sheet2'],
                     index_col=None, na_values=['NA'])

```

`ExcelFile`也能同`xlrd.book.Book`对象作为一个参数被调用。这种方法让用户可以控制Excel文件被如何读取。例如，表格可以根据需求加载通过调用`xlrd.open_workbook()`伴随`on_demand=True`。

```python
import xlrd
xlrd_book = xlrd.open_workbook('path_to_file.xls', on_demand=True)
with pd.ExcelFile(xlrd_book) as xls:
    df1 = pd.read_excel(xls, 'Sheet1')
    df2 = pd.read_excel(xls, 'Sheet2')

```

#### 指定表格

::: tip 注意

第二个参数是`sheet_name`，不要同`ExcelFile.sheet_names`搞混淆。

:::

::: tip 注意

ExcelFile's的属性`sheet_names`提供的是多张表格所生成的列表。

:::

- `sheet_name`参数允许指定单张表格或多张表格被读取。

- `sheet_name`的默认值是0，这表明读取的是第一张表格。

- 在工作簿里面，使用字符串指向特定的表格名称。

- 使用整数指向表格的索引，索引遵守Python的约定是从0开始的。

- 无论是使用一组字符串还是整数的列表，返回的都是指定表格的字典。

- 使用`None`值则会返回所有可用表格的一组字典。

```python
# Returns a DataFrame
pd.read_excel('path_to_file.xls', 'Sheet1', index_col=None, na_values=['NA'])

```

使用表格索引：

```python
# Returns a DataFrame
pd.read_excel('path_to_file.xls', 0, index_col=None, na_values=['NA'])

```

使用所有默认值：

```python
# Returns a DataFrame
pd.read_excel('path_to_file.xls')

```

使用None获取所有表格：

```python
# Returns a dictionary of DataFrames
pd.read_excel('path_to_file.xls', sheet_name=None)

```

使用列表获取多张表格：

```python
# Returns the 1st and 4th sheet, as a dictionary of DataFrames.
pd.read_excel('path_to_file.xls', sheet_name=['Sheet1', 3])

```

`read_excel`能读取不止一张表格，通过`sheet_name`能设置为读取表格名称的列表，表格位置的列表，还能设置为`None`来读取所有表格。多张表格能通过表格索引或表格名称分别使用整数或字符串来指定读取。

#### `MultiIndex`读取

`read_excel`能用`MultiIndex`读取多个索引，通过`index_col`方法来传递列的列表和`header`将行的列表传递给`MultiIndex`的列。无论是`index`还是`columns`，如果已经具有序列化的层级名称，则可以通过指定组成层级的行/列来读取它们。

例如，用`MultiIndex`读取没有名称的索引：

```python
In [314]: df = pd.DataFrame({'a': [1, 2, 3, 4], 'b': [5, 6, 7, 8]},
   .....:                   index=pd.MultiIndex.from_product([['a', 'b'], ['c', 'd']]))
   .....: 

In [315]: df.to_excel('path_to_file.xlsx')

In [316]: df = pd.read_excel('path_to_file.xlsx', index_col=[0, 1])

In [317]: df
Out[317]: 
     a  b
a c  1  5
  d  2  6
b c  3  7
  d  4  8

```

如果索引具有层级名称，它们将使用相同的参数进行解析：

```python
In [318]: df.index = df.index.set_names(['lvl1', 'lvl2'])

In [319]: df.to_excel('path_to_file.xlsx')

In [320]: df = pd.read_excel('path_to_file.xlsx', index_col=[0, 1])

In [321]: df
Out[321]: 
           a  b
lvl1 lvl2      
a    c     1  5
     d     2  6
b    c     3  7
     d     4  8

```

如果源文件具有`MultiIndex`索引和多列，那么可以使用`index_col`和`header`指定列表的每个值。

```python
In [322]: df.columns = pd.MultiIndex.from_product([['a'], ['b', 'd']],
   .....:                                         names=['c1', 'c2'])
   .....: 

In [323]: df.to_excel('path_to_file.xlsx')

In [324]: df = pd.read_excel('path_to_file.xlsx', index_col=[0, 1], header=[0, 1])

In [325]: df
Out[325]: 
c1         a   
c2         b  d
lvl1 lvl2      
a    c     1  5
     d     2  6
b    c     3  7
     d     4  8

```

#### 解析特定的列

常常会有这样的情况，当用户想要插入几列数据到Excel表格里面作为临时计算，但是你又不想要读取这些列的时候，`read_excel`提供的`usecols`方法就派上用场了，它让你可以解析指定的列。

*Deprecated since version 0.24.0.*

不推荐`usecols`方法使用单个整数值，请在`usecols`中使用包括从0开始的整数列表。

如果`usecols`是一个整数，那么它将被认为是暗示解析最后一列。

```python
pd.read_excel('path_to_file.xls', 'Sheet1', usecols=2)

```

你也可以将逗号分隔的一组Excel列和范围指定为字符串：

```python
pd.read_excel('path_to_file.xls', 'Sheet1', usecols='A,C:E')

```

如果`usecols`是一组整数列，那么将认为是解析的文件列索引。

```python
pd.read_excel('path_to_file.xls', 'Sheet1', usecols=[0, 2, 3])

```

元素的顺序是可以忽略的，因此`usecols=[0, 1]`是等价于`[1, 0]`的。

*New in version 0.24.*

如果`usecols`是字符串列表，那么可以认为每个字符串对应的就是表格的每一个列名，列名是由`name`中的用户提供或从文档标题行推断出来。这些字符串定义了那些列将要被解析：

```python
pd.read_excel('path_to_file.xls', 'Sheet1', usecols=['foo', 'bar'])

```

元素的顺序同样被忽略，因此`usecols=['baz', 'joe']`等同于`['joe', 'baz']`。

*New in version 0.24.*

如果`usecols`是可调用的，那么该调用函数将会根据列名来调用，也会返回根据可调用函数为`True`的列名。

```python
pd.read_excel('path_to_file.xls', 'Sheet1', usecols=lambda x: x.isalpha())

```

#### 解析日期

当读取excel文件的时候，像日期时间的值通常会自动转换为恰当的dtype(数据类型)。但是如果你有一列字符串看起来很像日期（实际上并不是excel里面的日期格式），那么你就能使用`parse_dates`方法来解析这些字符串为日期：

```python
pd.read_excel('path_to_file.xls', 'Sheet1', parse_dates=['date_strings'])

```

#### 单元格转换

Excel里面的单元格内容是可以通过`converters`方法来进行转换的。例如，把一列转换为布尔值：

```python
pd.read_excel('path_to_file.xls', 'Sheet1', converters={'MyBools': bool})

```

这个方法可以处理缺失值并且能对缺失的数据进行如期的转换。由于转换是在单元格之间发生而不是整列，因此不能保证dtype为数组。例如一列含有缺失值的整数是不能转换为具有整数dtype的数组，因为NaN严格的被认为是浮点数。你能够手动地标记缺失数据为恢复整数dtype：

```python
def cfun(x):
    return int(x) if x else -1


pd.read_excel('path_to_file.xls', 'Sheet1', converters={'MyInts': cfun})

```

#### 数据类型规范

*New in version 0.20.*

作为另一个种转换器，使用*dtype*能指定整列地类型，它能让字典映射列名为数据类型。使用`str`或`object`来转译不能判断类型的数据：

```python
pd.read_excel('path_to_file.xls', dtype={'MyInts': 'int64', 'MyText': str})

```

### 写入Excel文件

#### 写入Excel文件到磁盘

你可以使用`to_excel`方法把`DataFrame`对象写入到Excel文件的一张表格中。它的参数大部分同前面`to_csv `提到的相同，第一个参数是excel文件的名字，而可选的第二个参数是`DataFrame`应该写入的表格名称，例如：

```python
df.to_excel('path_to_file.xlsx', sheet_name='Sheet1')

```

文件以`.xls` 结尾的将用`xlwt`写入，而那些以`.xlsx`结尾的则使用`xlsxwriter`（如果可用的话）或`openpyxl`来写入。

`DataFrame `将尝试以模拟REPL（“读取-求值-输出" 循环的简写）输出的方式写入。`index_label`将代替第一行放置到第二行，你也能放置它到第一行通过在`to_excel()`里设置`merge_cells`选项为`False`:

```python
df.to_excel('path_to_file.xlsx', index_label='label', merge_cells=False)

```

为了把`DataFrames`数据分开写入Excel文件的不同表格中，可以使用`ExcelWriter`方法。

```python
with pd.ExcelWriter('path_to_file.xlsx') as writer:
    df1.to_excel(writer, sheet_name='Sheet1')
    df2.to_excel(writer, sheet_name='Sheet2')

```

::: tip 注意

为了从`read_excel`内部获取更多点的性能，Excel存储所有数值型数据为浮点数。但这会产生意外的情况当读取数据的时候，如果没有损失信息的话（`1.0 --> 1`)，pandas默认的转换整数为浮点数。你可以通过`convert_float=False`禁止这种行为，这可能会在性能上有轻微的优化。

:::

#### 写入Excel文件到内存

Pandas支持写入Excel文件到类缓存区对象如`StringIO`或`BytesIO`，使用`ExcelWriter`方法。

```python
# Safe import for either Python 2.x or 3.x
try:
    from io import BytesIO
except ImportError:
    from cStringIO import StringIO as BytesIO

bio = BytesIO()

# By setting the 'engine' in the ExcelWriter constructor.
writer = pd.ExcelWriter(bio, engine='xlsxwriter')
df.to_excel(writer, sheet_name='Sheet1')

# Save the workbook
writer.save()

# Seek to the beginning and read to copy the workbook to a variable in memory
bio.seek(0)
workbook = bio.read()

```
::: tip 注意

虽然`engine`是可选方法，但是推荐使用。设置engine决定了工作簿生成的版本。设置`engine='xlrd'`将生成 Excel 2003版的工作簿（xls）。而使用`'openpyxl'`或`'xlsxwriter'`将生成Excel 2007版的工作簿（xlsx)。如果省略，将直接生成Excel 2007版的。

:::

### Excel写入引擎

Pandas选择Excel写入有两种方式：

1. 使用`engine`参数
2. 文件名的扩展（通过默认的配置方式指定）

默认的，pandas使用[ XlsxWriter](https://xlsxwriter.readthedocs.io/)为`.xlsx`，使用[openpyxl](https://openpyxl.readthedocs.io/)为`.xlsm`，并且使用[xlwt](http://www.python-excel.org/)为`.xls`文件。如果你安装了多个引擎，你可以通过[setting the config options](https://www.pypandas.cn/docs/user_guide/options.html#options)`io.excel.xlsx.writer`和`io.excel.xls.writer`方法设置默认引擎。如果[ XlsxWriter](https://xlsxwriter.readthedocs.io/)不可用，pandas将回退使用[openpyxl](https://openpyxl.readthedocs.io/)为`xlsx`文件。

为了指定你想要使用的写入方式，你可以设置引擎的主要参数为`to_excel`和`ExcelWriter`。内置引擎是：

- `openpyxl`: 要求2.4或者更高的版本。
- `xlsxwriter`
- `xlwt`

```python
# By setting the 'engine' in the DataFrame 'to_excel()' methods.
df.to_excel('path_to_file.xlsx', sheet_name='Sheet1', engine='xlsxwriter')

# By setting the 'engine' in the ExcelWriter constructor.
writer = pd.ExcelWriter('path_to_file.xlsx', engine='xlsxwriter')

# Or via pandas configuration.
from pandas import options                                     # noqa: E402
options.io.excel.xlsx.writer = 'xlsxwriter'

df.to_excel('path_to_file.xlsx', sheet_name='Sheet1')

```

### 样式

通过pandas产生的Excel工作表的样式可以使用`DataFrame`的`to_excel`方法的以下参数进行修改。

- `float_format`：格式化字符串用于浮点数（默认是`None`)。
- `freeze_panes`：两个整数的元组，表示要固化的最底行和最右列。这些参数中的每个都是以1为底，因此(1, 1)将固化第一行和第一列（默认是`None`)。

使用[ XlsxWriter](https://xlsxwriter.readthedocs.io/)引擎提供的多种方法来修改用`to_excel`方法创建的Excel工作表的样式。你能在[ XlsxWriter](https://xlsxwriter.readthedocs.io/)文档里面找到绝佳的例子：[https://xlsxwriter.readthedocs.io/working_with_pandas.html](https://xlsxwriter.readthedocs.io/working_with_pandas.html)

## OpenDocument 电子表格

*New in version 0.25.*

[`read_excel`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_excel.html#pandas.read_excel "`read_excel`")方法也能使用`odfpy`模块来读取OpenDocument电子表格。读取OpenDocument电子表格的语法和方法同使用`engine='odf'`来操作[Excel files](https://www.pypandas.cn/docs/user_guide/io.html#excel-files "Excel files")的方法类似。

```python
# Returns a DataFrame
pd.read_excel('path_to_file.ods', engine='odf')
```
::: tip 注意

目前pandas仅支持读取OpenDocument电子表格，写入是不行的。

:::
    
## 剪贴板

使用`read_clipboard()`方法是一种便捷的获取数据的方式，通过把剪贴的内容暂存，然后传递给`read_csv`方法。例如，你可以复制以下文本来剪贴（在许多操作系统上是CTRL-C）：

```python
  A B C
x 1 4 p
y 2 5 q
z 3 6 r
```

接着直接使用`DataFrame`来导入数据：

```python
>>> clipdf = pd.read_clipboard()
>>> clipdf
  A B C
x 1 4 p
y 2 5 q
z 3 6 r
```

`to_clipboard`方法可以把`DataFrame`内容写入到剪贴板。使用下面的方法你可以粘贴剪贴板的内容到其他应用（在许多系统中用的是CTRL-V）。这里我们解释一下如何使用`DataFrame`把内容写入到剪贴板并读回。

```python
>>> df = pd.DataFrame({'A': [1, 2, 3],
...                    'B': [4, 5, 6],
...                    'C': ['p', 'q', 'r']},
...                   index=['x', 'y', 'z'])
>>> df
  A B C
x 1 4 p
y 2 5 q
z 3 6 r
>>> df.to_clipboard()
>>> pd.read_clipboard()
  A B C
x 1 4 p
y 2 5 q
z 3 6 r
```

我们可以看到返回了同样的内容，那就是我们早先写入剪贴板的内容。

::: tip 注意

要使用上面的这些方法，你可能需要在Linux上面安装(带有PyQt5, PyQt4 or qtpy)的xclip或者xsel 。

:::

## 序列化(Pickling)

所有的pandas对象都具有`to_pickle`方法，该方法使用Python的` cPickle`模块以序列化格式存储数据结构到磁盘上。

```python
In [326]: df
Out[326]: 
c1         a   
c2         b  d
lvl1 lvl2      
a    c     1  5
     d     2  6
b    c     3  7
     d     4  8

In [327]: df.to_pickle('foo.pkl')
```

在`pandas`中命名的`read_pickle`函数能够从文件中加载任意序列化的pandas对象（或者任何其他的序列化对象）：

```python
In [328]: pd.read_pickle('foo.pkl')
Out[328]: 
c1         a   
c2         b  d
lvl1 lvl2      
a    c     1  5
     d     2  6
b    c     3  7
     d     4  8
```

::: danger 警告

加载来自不信任来源的序列化数据是不安全的。
参见：https://docs.python.org/3/library/pickle.html

:::

::: danger 警告

[`read_pickle()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_pickle.html#pandas.read_pickle "`read_pickle()`")仅在pandas的0.20.3版本及以下版本兼容。

:::

### 压缩序列化文件

*New in version 0.20.0.*

[`read_pickle()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_pickle.html#pandas.read_pickle "`read_pickle()`")，[`DataFrame.to_pickle()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_pickle.html#pandas.DataFrame.to_pickle)和[`Series.to_pickle()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.to_pickle.html#pandas.Series.to_pickle)能够读取和写入压缩的序列化文件。读取和写入所支持的压缩文件类型有`gzip`, `bz2`, `xz`。`zip`文件格式仅支持读取，并且必须仅包含一个要读取的数据文件。

压缩类型可以是显式参数，也可以从文件扩展名中推断出来。如果文件名是以`'.gz'`，` '.bz2'`，` '.zip'`， 或者` '.xz'`结尾的，那么可以推断出应分别使用`gzip`， `bz2`，`zip`，或 `xz`压缩类型。

```python
In [329]: df = pd.DataFrame({
   .....:     'A': np.random.randn(1000),
   .....:     'B': 'foo',
   .....:     'C': pd.date_range('20130101', periods=1000, freq='s')})
   .....: 

In [330]: df
Out[330]: 
            A    B                   C
0   -0.288267  foo 2013-01-01 00:00:00
1   -0.084905  foo 2013-01-01 00:00:01
2    0.004772  foo 2013-01-01 00:00:02
3    1.382989  foo 2013-01-01 00:00:03
4    0.343635  foo 2013-01-01 00:00:04
..        ...  ...                 ...
995 -0.220893  foo 2013-01-01 00:16:35
996  0.492996  foo 2013-01-01 00:16:36
997 -0.461625  foo 2013-01-01 00:16:37
998  1.361779  foo 2013-01-01 00:16:38
999 -1.197988  foo 2013-01-01 00:16:39

[1000 rows x 3 columns]
```
使用显式压缩类型：

```python
In [331]: df.to_pickle("data.pkl.compress", compression="gzip")

In [332]: rt = pd.read_pickle("data.pkl.compress", compression="gzip")

In [333]: rt
Out[333]: 
            A    B                   C
0   -0.288267  foo 2013-01-01 00:00:00
1   -0.084905  foo 2013-01-01 00:00:01
2    0.004772  foo 2013-01-01 00:00:02
3    1.382989  foo 2013-01-01 00:00:03
4    0.343635  foo 2013-01-01 00:00:04
..        ...  ...                 ...
995 -0.220893  foo 2013-01-01 00:16:35
996  0.492996  foo 2013-01-01 00:16:36
997 -0.461625  foo 2013-01-01 00:16:37
998  1.361779  foo 2013-01-01 00:16:38
999 -1.197988  foo 2013-01-01 00:16:39

[1000 rows x 3 columns]
```
从扩展名推断压缩类型：

```python
In [334]: df.to_pickle("data.pkl.xz", compression="infer")

In [335]: rt = pd.read_pickle("data.pkl.xz", compression="infer")

In [336]: rt
Out[336]: 
            A    B                   C
0   -0.288267  foo 2013-01-01 00:00:00
1   -0.084905  foo 2013-01-01 00:00:01
2    0.004772  foo 2013-01-01 00:00:02
3    1.382989  foo 2013-01-01 00:00:03
4    0.343635  foo 2013-01-01 00:00:04
..        ...  ...                 ...
995 -0.220893  foo 2013-01-01 00:16:35
996  0.492996  foo 2013-01-01 00:16:36
997 -0.461625  foo 2013-01-01 00:16:37
998  1.361779  foo 2013-01-01 00:16:38
999 -1.197988  foo 2013-01-01 00:16:39

[1000 rows x 3 columns]
```
默认是使用“推断”：

```python
In [337]: df.to_pickle("data.pkl.gz")

In [338]: rt = pd.read_pickle("data.pkl.gz")

In [339]: rt
Out[339]: 
            A    B                   C
0   -0.288267  foo 2013-01-01 00:00:00
1   -0.084905  foo 2013-01-01 00:00:01
2    0.004772  foo 2013-01-01 00:00:02
3    1.382989  foo 2013-01-01 00:00:03
4    0.343635  foo 2013-01-01 00:00:04
..        ...  ...                 ...
995 -0.220893  foo 2013-01-01 00:16:35
996  0.492996  foo 2013-01-01 00:16:36
997 -0.461625  foo 2013-01-01 00:16:37
998  1.361779  foo 2013-01-01 00:16:38
999 -1.197988  foo 2013-01-01 00:16:39

[1000 rows x 3 columns]

In [340]: df["A"].to_pickle("s1.pkl.bz2")

In [341]: rt = pd.read_pickle("s1.pkl.bz2")

In [342]: rt
Out[342]: 
0     -0.288267
1     -0.084905
2      0.004772
3      1.382989
4      0.343635
         ...   
995   -0.220893
996    0.492996
997   -0.461625
998    1.361779
999   -1.197988
Name: A, Length: 1000, dtype: float64
```
## msgpack（一种二进制格式）

pandas支持`msgpack`格式的对象序列化。他是一种轻量级可移植的二进制格式，同二进制的JSON类似，具有高效的空间利用率以及不错的写入（序列化）和读取（反序列化）性能。

::: danger 警告

从0.25版本开始，不推荐使用msgpack格式，并且之后的版本也将删除它。推荐使用pyarrow对pandas对象进行在线的转换。

:::

::: danger 警告

[`read_msgpack()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_msgpack.html#pandas.read_msgpack "`read_msgpack()`")仅在pandas的0.20.3版本及以下版本兼容。

:::

```python
In [343]: df = pd.DataFrame(np.random.rand(5, 2), columns=list('AB'))

In [344]: df.to_msgpack('foo.msg')

In [345]: pd.read_msgpack('foo.msg')
Out[345]: 
          A         B
0  0.275432  0.293583
1  0.842639  0.165381
2  0.608925  0.778891
3  0.136543  0.029703
4  0.318083  0.604870

In [346]: s = pd.Series(np.random.rand(5), index=pd.date_range('20130101', periods=5))
```

你可以传递一组对象列表并得到反序列化的结果。

```python
In [347]: pd.to_msgpack('foo.msg', df, 'foo', np.array([1, 2, 3]), s)

In [348]: pd.read_msgpack('foo.msg')
Out[348]: 
[          A         B
 0  0.275432  0.293583
 1  0.842639  0.165381
 2  0.608925  0.778891
 3  0.136543  0.029703
 4  0.318083  0.604870, 'foo', array([1, 2, 3]), 2013-01-01    0.330824
 2013-01-02    0.790825
 2013-01-03    0.308468
 2013-01-04    0.092397
 2013-01-05    0.703091
 Freq: D, dtype: float64]
```
你能传递`iterator=True`参数来迭代解压后的结果：

```python
In [349]: for o in pd.read_msgpack('foo.msg', iterator=True):
   .....:     print(o)
   .....: 
          A         B
0  0.275432  0.293583
1  0.842639  0.165381
2  0.608925  0.778891
3  0.136543  0.029703
4  0.318083  0.604870
foo
[1 2 3]
2013-01-01    0.330824
2013-01-02    0.790825
2013-01-03    0.308468
2013-01-04    0.092397
2013-01-05    0.703091
Freq: D, dtype: float64
```
你也能传递`append=True`参数，给现有的包添加写入：

```python
In [350]: df.to_msgpack('foo.msg', append=True)

In [351]: pd.read_msgpack('foo.msg')
Out[351]: 
[          A         B
 0  0.275432  0.293583
 1  0.842639  0.165381
 2  0.608925  0.778891
 3  0.136543  0.029703
 4  0.318083  0.604870, 'foo', array([1, 2, 3]), 2013-01-01    0.330824
 2013-01-02    0.790825
 2013-01-03    0.308468
 2013-01-04    0.092397
 2013-01-05    0.703091
 Freq: D, dtype: float64,           A         B
 0  0.275432  0.293583
 1  0.842639  0.165381
 2  0.608925  0.778891
 3  0.136543  0.029703
 4  0.318083  0.604870]
```
不像其他io方法，`to_msgpack`既可以基于每个对象使用`df.to_msgpack()`方法，也可以在混合pandas对象的时候使用顶层`pd.to_msgpack(...)`方法，该方法可以让你打包任意的Python列表、字典、标量的集合。

```python
In [352]: pd.to_msgpack('foo2.msg', {'dict': [{'df': df}, {'string': 'foo'},
   .....:                                     {'scalar': 1.}, {'s': s}]})
   .....: 

In [353]: pd.read_msgpack('foo2.msg')
Out[353]: 
{'dict': ({'df':           A         B
   0  0.275432  0.293583
   1  0.842639  0.165381
   2  0.608925  0.778891
   3  0.136543  0.029703
   4  0.318083  0.604870},
  {'string': 'foo'},
  {'scalar': 1.0},
  {'s': 2013-01-01    0.330824
   2013-01-02    0.790825
   2013-01-03    0.308468
   2013-01-04    0.092397
   2013-01-05    0.703091
   Freq: D, dtype: float64})}
```

### 读/写API

Msgpacks也能读写字符串。

```python
In [354]: df.to_msgpack()
Out[354]: b'\x84\xa3typ\xadblock_manager\xa5klass\xa9DataFrame\xa4axes\x92\x86\xa3typ\xa5index\xa5klass\xa5Index\xa4name\xc0\xa5dtype\xa6object\xa4data\x92\xa1A\xa1B\xa8compress\xc0\x86\xa3typ\xabrange_index\xa5klass\xaaRangeIndex\xa4name\xc0\xa5start\x00\xa4stop\x05\xa4step\x01\xa6blocks\x91\x86\xa4locs\x86\xa3typ\xa7ndarray\xa5shape\x91\x02\xa4ndim\x01\xa5dtype\xa5int64\xa4data\xd8\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\xa8compress\xc0\xa6values\xc7P\x00\xc84 \x84\xac\xa0\xd1?\x0f\xa4.\xb5\xe6\xf6\xea?\xb9\x85\x9aLO|\xe3?\xac\xf0\xd7\x81>z\xc1?\\\xca\x97\ty[\xd4?\x9c\x9b\x8a:\x11\xca\xd2?\x14zX\xd01+\xc5?4=\x19b\xad\xec\xe8?\xc0!\xe9\xf4\x8ej\x9e?\xa7>_\xac\x17[\xe3?\xa5shape\x92\x02\x05\xa5dtype\xa7float64\xa5klass\xaaFloatBlock\xa8compress\xc0'
```
此外你可以连接字符串生成一个原始的对象列表。

```python
In [355]: pd.read_msgpack(df.to_msgpack() + s.to_msgpack())
Out[355]: 
[          A         B
 0  0.275432  0.293583
 1  0.842639  0.165381
 2  0.608925  0.778891
 3  0.136543  0.029703
 4  0.318083  0.604870, 2013-01-01    0.330824
 2013-01-02    0.790825
 2013-01-03    0.308468
 2013-01-04    0.092397
 2013-01-05    0.703091
 Freq: D, dtype: float64]
```
## HDF5(PyTables) (一种以.h5结尾的分层数据格式）

`HDFStore`是一个能读写pandas的类似字典的对象，它能使用高性能的HDF5格式，该格式是用优秀的[PyTables](https://www.pytables.org/ "PyTables")库写的。一些更高级的用法参考[cookbook](https://www.pypandas.cn/docs/user_guide/cookbook.html#cookbook-hdf "cookbook")。

::: danger 警告

pandas要求使用的`PyTables`版本要 > = 3.0.0。当使用索引来检索存储的时候，`PyTables`< 3.2的版本会出现索引bug。如果返回一个结果的子集，那么你就需要升级`PyTables` 的版本 >= 3.2才行。先前创建的存储数据将会使用更新后的版本再次写入。

:::

```python
In [356]: store = pd.HDFStore('store.h5')

In [357]: print(store)
<class 'pandas.io.pytables.HDFStore'>
File path: store.h5
```

对象能够被写入文件就像成对的键-值添加到字典里面一样：

```python
In [358]: index = pd.date_range('1/1/2000', periods=8)

In [359]: s = pd.Series(np.random.randn(5), index=['a', 'b', 'c', 'd', 'e'])

In [360]: df = pd.DataFrame(np.random.randn(8, 3), index=index,
   .....:                   columns=['A', 'B', 'C'])
   .....: 

# store.put('s', s) is an equivalent method
In [361]: store['s'] = s

In [362]: store['df'] = df

In [363]: store
Out[363]: 
<class 'pandas.io.pytables.HDFStore'>
File path: store.h5
```
在当前或者之后的Python会话中，你都能检索存储的对象：

```python
# store.get('df') is an equivalent method
In [364]: store['df']
Out[364]: 
                   A         B         C
2000-01-01 -0.426936 -1.780784  0.322691
2000-01-02  1.638174 -2.184251  0.049673
2000-01-03 -1.022803  0.889445  2.827717
2000-01-04  1.767446 -1.305266 -0.378355
2000-01-05  0.486743  0.954551  0.859671
2000-01-06 -1.170458 -1.211386 -0.852728
2000-01-07 -0.450781  1.064650  1.014927
2000-01-08 -0.810399  0.254343 -0.875526

# dotted (attribute) access provides get as well
In [365]: store.df
Out[365]: 
                   A         B         C
2000-01-01 -0.426936 -1.780784  0.322691
2000-01-02  1.638174 -2.184251  0.049673
2000-01-03 -1.022803  0.889445  2.827717
2000-01-04  1.767446 -1.305266 -0.378355
2000-01-05  0.486743  0.954551  0.859671
2000-01-06 -1.170458 -1.211386 -0.852728
2000-01-07 -0.450781  1.064650  1.014927
2000-01-08 -0.810399  0.254343 -0.875526
```

使用键删除指定的对象：

```python
# store.remove('df') is an equivalent method
In [366]: del store['df']

In [367]: store
Out[367]: 
<class 'pandas.io.pytables.HDFStore'>
File path: store.h5
```

关闭存储对象并使用环境管理器：

```python
In [368]: store.close()

In [369]: store
Out[369]: 
<class 'pandas.io.pytables.HDFStore'>
File path: store.h5

In [370]: store.is_open
Out[370]: False

# Working with, and automatically closing the store using a context manager
In [371]: with pd.HDFStore('store.h5') as store:
   .....:     store.keys()
   .....: 
```

### 读/写 API

`HDFStore `支持顶层的API，用`read_hdf`来读取，和使用`to_hdf`来写入，类似于`read_csv` 和`to_csv`的用法。

```python
In [372]: df_tl = pd.DataFrame({'A': list(range(5)), 'B': list(range(5))})

In [373]: df_tl.to_hdf('store_tl.h5', 'table', append=True)

In [374]: pd.read_hdf('store_tl.h5', 'table', where=['index>2'])
Out[374]: 
   A  B
3  3  3
4  4  4
```
HDFStore默认不会删除全是缺失值的行，但是通过设置`dropna=True`参数就能改变。

```python
In [375]: df_with_missing = pd.DataFrame({'col1': [0, np.nan, 2],
   .....:                                 'col2': [1, np.nan, np.nan]})
   .....: 

In [376]: df_with_missing
Out[376]: 
   col1  col2
0   0.0   1.0
1   NaN   NaN
2   2.0   NaN

In [377]: df_with_missing.to_hdf('file.h5', 'df_with_missing',
   .....:                        format='table', mode='w')
   .....: 

In [378]: pd.read_hdf('file.h5', 'df_with_missing')
Out[378]: 
   col1  col2
0   0.0   1.0
1   NaN   NaN
2   2.0   NaN

In [379]: df_with_missing.to_hdf('file.h5', 'df_with_missing',
   .....:                        format='table', mode='w', dropna=True)
   .....: 

In [380]: pd.read_hdf('file.h5', 'df_with_missing')
Out[380]: 
   col1  col2
0   0.0   1.0
2   2.0   NaN
```
### 固定格式

上面的例子表明了使用`put`进行存储的情况，该存储将`HDF5`以固定数组格式写入`PyTables`，这就是所谓的`fixed`格式。这些类型的存储一旦被写入后将**不能**再添加数据（虽然你能轻易地删除它们并再次写入），**也不能**查询；必须全部检索它们。它们也不支持没有唯一列名的数据表。`fixed`格式提供了非常快速的写入功能，并且比`table`存储在读取方面更快捷。默认的指定格式是使用`put` 或者`to_hdf` 亦或通过` format='fixed'`或` format='f'`格式。

::: danger 警告

如果你尝试使用`where`来检索，`fixed`格式将会报错` TypeError`：

```python
>>> pd.DataFrame(np.random.randn(10, 2)).to_hdf('test_fixed.h5', 'df')
>>> pd.read_hdf('test_fixed.h5', 'df', where='index>5')
TypeError: cannot pass a where specification when reading a fixed format.
           this store must be selected in its entirety
```
:::

### 表格格式

`HDFStore `支持在磁盘上使用另一种`PyTables`格式，即`table`格式。从概念上来讲，`table`在外形上同具有行和列的DataFrame极度相似。`table`也能被添加到同样的或其他的会话中。此外，删除和查询操作也是支持的。通过指定格式为`format='table'`或`format='t'`到`append`方法或`put`或者`to_hdf`。

`put/append/to_hdf`方法中使用的格式也可以设置为可选`pd.set_option('io.hdf.default_format','table')`，以默认的`table`格式存储。

```python
In [381]: store = pd.HDFStore('store.h5')

In [382]: df1 = df[0:4]

In [383]: df2 = df[4:]

# append data (creates a table automatically)
In [384]: store.append('df', df1)

In [385]: store.append('df', df2)

In [386]: store
Out[386]: 
<class 'pandas.io.pytables.HDFStore'>
File path: store.h5

# select the entire object
In [387]: store.select('df')
Out[387]: 
                   A         B         C
2000-01-01 -0.426936 -1.780784  0.322691
2000-01-02  1.638174 -2.184251  0.049673
2000-01-03 -1.022803  0.889445  2.827717
2000-01-04  1.767446 -1.305266 -0.378355
2000-01-05  0.486743  0.954551  0.859671
2000-01-06 -1.170458 -1.211386 -0.852728
2000-01-07 -0.450781  1.064650  1.014927
2000-01-08 -0.810399  0.254343 -0.875526

# the type of stored data
In [388]: store.root.df._v_attrs.pandas_type
Out[388]: 'frame_table'
```
::: tip 注意

你也可以通过创建`table`来传递`format='table'`或者` format='t`到`put`操作。

:::

### 分层键

存储的键能够指定为字符串，这些分层的路径名就像这样的格式（例如：`foo/bar/bah`）。它将生成子存储的层次结构（或者在PyTables中叫做`Groups`  ）。键可以不带前面的'/'指定而且**总是**单独的（例如：'foo' 指的就是'/foo'）。删除操作能够删除所有子存储及**之后**的数据，所以要小心该操作。

```python
In [389]: store.put('foo/bar/bah', df)

In [390]: store.append('food/orange', df)

In [391]: store.append('food/apple', df)

In [392]: store
Out[392]: 
<class 'pandas.io.pytables.HDFStore'>
File path: store.h5

# a list of keys are returned
In [393]: store.keys()
Out[393]: ['/df', '/food/apple', '/food/orange', '/foo/bar/bah']

# remove all nodes under this level
In [394]: store.remove('food')

In [395]: store
Out[395]: 
<class 'pandas.io.pytables.HDFStore'>
File path: store.h5
```

你能遍历组层次结构使用`walk`方法，该方法将为每个组键及其内容的相对键生成一个元组。

*New in version 0.24.0.*

```python
In [396]: for (path, subgroups, subkeys) in store.walk():
   .....:     for subgroup in subgroups:
   .....:         print('GROUP: {}/{}'.format(path, subgroup))
   .....:     for subkey in subkeys:
   .....:         key = '/'.join([path, subkey])
   .....:         print('KEY: {}'.format(key))
   .....:         print(store.get(key))
   .....: 
GROUP: /foo
KEY: /df
                   A         B         C
2000-01-01 -0.426936 -1.780784  0.322691
2000-01-02  1.638174 -2.184251  0.049673
2000-01-03 -1.022803  0.889445  2.827717
2000-01-04  1.767446 -1.305266 -0.378355
2000-01-05  0.486743  0.954551  0.859671
2000-01-06 -1.170458 -1.211386 -0.852728
2000-01-07 -0.450781  1.064650  1.014927
2000-01-08 -0.810399  0.254343 -0.875526
GROUP: /foo/bar
KEY: /foo/bar/bah
                   A         B         C
2000-01-01 -0.426936 -1.780784  0.322691
2000-01-02  1.638174 -2.184251  0.049673
2000-01-03 -1.022803  0.889445  2.827717
2000-01-04  1.767446 -1.305266 -0.378355
2000-01-05  0.486743  0.954551  0.859671
2000-01-06 -1.170458 -1.211386 -0.852728
2000-01-07 -0.450781  1.064650  1.014927
2000-01-08 -0.810399  0.254343 -0.875526
```
::: danger 警告

分层键对于存储在根节点下的项目，无法使用如上的方法将其作为点（属性）进行检索。

```python
In [8]: store.foo.bar.bah
AttributeError: 'HDFStore' object has no attribute 'foo'

# you can directly access the actual PyTables node but using the root node
In [9]: store.root.foo.bar.bah
Out[9]:
/foo/bar/bah (Group) ''
  children := ['block0_items' (Array), 'block0_values' (Array), 'axis0' (Array), 'axis1' (Array)]
```

相反，使用基于显式字符串的键：

```python
In [397]: store['foo/bar/bah']
Out[397]: 
                   A         B         C
2000-01-01 -0.426936 -1.780784  0.322691
2000-01-02  1.638174 -2.184251  0.049673
2000-01-03 -1.022803  0.889445  2.827717
2000-01-04  1.767446 -1.305266 -0.378355
2000-01-05  0.486743  0.954551  0.859671
2000-01-06 -1.170458 -1.211386 -0.852728
2000-01-07 -0.450781  1.064650  1.014927
2000-01-08 -0.810399  0.254343 -0.875526
```
:::

### 存储类型

#### 在表格中存储混合类型

支持混合数据类型存储。字符串使用添加列的最大尺寸以固定宽度进行存储。后面尝试添加更长的字符串将会报错``ValueError``。

添加参数``min_itemsize={`values`: size}``将给字符串列设置一个更大的最小值。目前支持的存储类型有 ``floats,strings, ints, bools, datetime64`` 。对于字符串列，添加参数 ``nan_rep = 'nan'``将改变磁盘上默认的nan值（转变为*np.nan*），原本默认是*nan*。

``` python
In [398]: df_mixed = pd.DataFrame({'A': np.random.randn(8),
   .....:                          'B': np.random.randn(8),
   .....:                          'C': np.array(np.random.randn(8), dtype='float32'),
   .....:                          'string': 'string',
   .....:                          'int': 1,
   .....:                          'bool': True,
   .....:                          'datetime64': pd.Timestamp('20010102')},
   .....:                         index=list(range(8)))
   .....: 

In [399]: df_mixed.loc[df_mixed.index[3:5],
   .....:              ['A', 'B', 'string', 'datetime64']] = np.nan
   .....: 

In [400]: store.append('df_mixed', df_mixed, min_itemsize={'values': 50})

In [401]: df_mixed1 = store.select('df_mixed')

In [402]: df_mixed1
Out[402]: 
          A         B         C  string  int  bool datetime64
0 -0.980856  0.298656  0.151508  string    1  True 2001-01-02
1 -0.906920 -1.294022  0.587939  string    1  True 2001-01-02
2  0.988185 -0.618845  0.043096  string    1  True 2001-01-02
3       NaN       NaN  0.362451     NaN    1  True        NaT
4       NaN       NaN  1.356269     NaN    1  True        NaT
5 -0.772889 -0.340872  1.798994  string    1  True 2001-01-02
6 -0.043509 -0.303900  0.567265  string    1  True 2001-01-02
7  0.768606 -0.871948 -0.044348  string    1  True 2001-01-02

In [403]: df_mixed1.dtypes.value_counts()
Out[403]: 
float64           2
float32           1
datetime64[ns]    1
int64             1
bool              1
object            1
dtype: int64

# we have provided a minimum string column size
In [404]: store.root.df_mixed.table
Out[404]: 
/df_mixed/table (Table(8,)) ''
  description := {
  "index": Int64Col(shape=(), dflt=0, pos=0),
  "values_block_0": Float64Col(shape=(2,), dflt=0.0, pos=1),
  "values_block_1": Float32Col(shape=(1,), dflt=0.0, pos=2),
  "values_block_2": Int64Col(shape=(1,), dflt=0, pos=3),
  "values_block_3": Int64Col(shape=(1,), dflt=0, pos=4),
  "values_block_4": BoolCol(shape=(1,), dflt=False, pos=5),
  "values_block_5": StringCol(itemsize=50, shape=(1,), dflt=b'', pos=6)}
  byteorder := 'little'
  chunkshape := (689,)
  autoindex := True
  colindexes := {
    "index": Index(6, medium, shuffle, zlib(1)).is_csi=False}

```

#### 存储多层索引数据表

存储多层索引``DataFrames``为表格与从同类索引 ``DataFrames``中存储/选取是非常类似的。

``` python
In [405]: index = pd.MultiIndex(levels=[['foo', 'bar', 'baz', 'qux'],
   .....:                               ['one', 'two', 'three']],
   .....:                       codes=[[0, 0, 0, 1, 1, 2, 2, 3, 3, 3],
   .....:                              [0, 1, 2, 0, 1, 1, 2, 0, 1, 2]],
   .....:                       names=['foo', 'bar'])
   .....: 

In [406]: df_mi = pd.DataFrame(np.random.randn(10, 3), index=index,
   .....:                      columns=['A', 'B', 'C'])
   .....: 

In [407]: df_mi
Out[407]: 
                  A         B         C
foo bar                                
foo one    0.031885  0.641045  0.479460
    two   -0.630652 -0.182400 -0.789979
    three -0.282700 -0.813404  1.252998
bar one    0.758552  0.384775 -1.133177
    two   -1.002973 -1.644393 -0.311536
baz two   -0.615506 -0.084551 -1.318575
    three  0.923929 -0.105981  0.429424
qux one   -1.034590  0.542245 -0.384429
    two    0.170697 -0.200289  1.220322
    three -1.001273  0.162172  0.376816

In [408]: store.append('df_mi', df_mi)

In [409]: store.select('df_mi')
Out[409]: 
                  A         B         C
foo bar                                
foo one    0.031885  0.641045  0.479460
    two   -0.630652 -0.182400 -0.789979
    three -0.282700 -0.813404  1.252998
bar one    0.758552  0.384775 -1.133177
    two   -1.002973 -1.644393 -0.311536
baz two   -0.615506 -0.084551 -1.318575
    three  0.923929 -0.105981  0.429424
qux one   -1.034590  0.542245 -0.384429
    two    0.170697 -0.200289  1.220322
    three -1.001273  0.162172  0.376816

# the levels are automatically included as data columns
In [410]: store.select('df_mi', 'foo=bar')
Out[410]: 
                A         B         C
foo bar                              
bar one  0.758552  0.384775 -1.133177
    two -1.002973 -1.644393 -0.311536

```

### 查询

#### 查询表格

``select`` 和 ``delete`` 操作有一个可选项即能指定选择/删除仅有数据的子集。 这允许用户拥有一个很大的磁盘表并仅检索一部分数据。

在底层里使用``Term`` 类指定查询为布尔表达式。

- 支持的 ``DataFrames``索引器有 ``index`` 和 ``columns`` .
- 如果指定为``data_columns``，这些将作为额外的索引器。 

有效的比较运算符有：

``=, ==, !=, >, >=, <, <=``

有效的布尔表达式包含如下几种：

- ``|`` : 选择
- ``&`` : 并列
- ``(`` 和 ``)`` : 用来分组

这些规则同在pandas的索引中使用布尔表达式是类似的。

::: tip 注意

- ``=`` 将自动扩展为比较运算符 ``==``
- ``~`` 不是运算符，且只在有限的条件下使用
- 如果传递的表达式时列表/元组，他们将通过 ``&``符号合并

:::

以下都是有效的表达式：
- ``'index >= date'``
- ``"columns = ['A', 'D']"``
- ``"columns in ['A', 'D']"``
- ``'columns = A'``
- ``'columns == A'``
- ``"~(columns = ['A', 'B'])"``
- ``'index > df.index[3] & string = "bar"'``
- ``'(index > df.index[3] & index <= df.index[6]) | string = "bar"'``
- ``"ts >= Timestamp('2012-02-01')"``
- ``"major_axis>=20130101"``

`indexers`在子表达式的左边的有：
`columns`, `major_axis`, `ts`

（在比较运算符后面）子表达式可以是：
- 能被求值的函数，比如：``Timestamp('2012-02-01')``
- 字符串，比如： ``"bar"``
- 类似日期，比如： ``20130101``或者 ``"20130101"``
- 列表，比如： ``"['A', 'B']"``
- 以本地命名空间定义的变量，比如：``date``

::: tip 注意

在查询表达式中插入字符串进行查询是不推荐的。如果将带有%的字符串分配给变量，然后在表达式中使用该变量。那么，这样做

``` python
string = "HolyMoly'"
store.select('df', 'index == string')

```
来代替下面这样

``` python
string = "HolyMoly'"
store.select('df', 'index == %s' % string)

```

因为后者将 **不会** 起作用并引起 ``SyntaxError``。注意  ``string``变量的双引号里面有一个单引号。


如果你一定要插入，使用说明符格式 ``'%r'`` 

``` python
store.select('df', 'index == %r' % string)

```

它将会引用变量 ``string``.

:::

这儿有一些例子：

``` python
In [411]: dfq = pd.DataFrame(np.random.randn(10, 4), columns=list('ABCD'),
   .....:                    index=pd.date_range('20130101', periods=10))
   .....: 

In [412]: store.append('dfq', dfq, format='table', data_columns=True)

```
使用布尔表达式同内联求值函数。

``` python
In [413]: store.select('dfq', "index>pd.Timestamp('20130104') & columns=['A', 'B']")
Out[413]: 
                   A         B
2013-01-05  0.450263  0.755221
2013-01-06  0.019915  0.300003
2013-01-07  1.878479 -0.026513
2013-01-08  3.272320  0.077044
2013-01-09 -0.398346  0.507286
2013-01-10  0.516017 -0.501550

```

内联列引用

``` python
In [414]: store.select('dfq', where="A>0 or C>0")
Out[414]: 
                   A         B         C         D
2013-01-01 -0.161614 -1.636805  0.835417  0.864817
2013-01-02  0.843452 -0.122918 -0.026122 -1.507533
2013-01-03  0.335303 -1.340566 -1.024989  1.125351
2013-01-05  0.450263  0.755221 -1.506656  0.808794
2013-01-06  0.019915  0.300003 -0.727093 -1.119363
2013-01-07  1.878479 -0.026513  0.573793  0.154237
2013-01-08  3.272320  0.077044  0.397034 -0.613983
2013-01-10  0.516017 -0.501550  0.138212  0.218366

```
关键词``columns`` 能用来筛选列字段并返回为列表，这等价于传递``'columns=list_of_columns_to_filter'``:

``` python
In [415]: store.select('df', "columns=['A', 'B']")
Out[415]: 
                   A         B
2000-01-01 -0.426936 -1.780784
2000-01-02  1.638174 -2.184251
2000-01-03 -1.022803  0.889445
2000-01-04  1.767446 -1.305266
2000-01-05  0.486743  0.954551
2000-01-06 -1.170458 -1.211386
2000-01-07 -0.450781  1.064650
2000-01-08 -0.810399  0.254343

```

``start`` and ``stop`` 参数能指定总的搜索范围。这些是根据表中的总行数得出来的。

::: tip 注意

如果查询表达式有未知的引用变量，那么``select`` 将会报错 ``ValueError`` 。通常这就意味着你正在尝试选取的一列并**不在**当前数据列中。

如果查询表达式无效，那么``select``将会报错``SyntaxError`` 。

:::

#### timedelta64[ns]的用法

你能使用``timedelta64[ns]``进行存储和查询。使用``()``来指定查询的条目，浮点数可以带符号（和小数），timedelta的单位可以是``D,s,ms,us,ns``。看示例：

```python
In [416]: from datetime import timedelta

In [417]: dftd = pd.DataFrame({'A': pd.Timestamp('20130101'),
   .....:                      'B': [pd.Timestamp('20130101') + timedelta(days=i,
   .....:                                                                 seconds=10)
   .....:                            for i in range(10)]})
   .....: 

In [418]: dftd['C'] = dftd['A'] - dftd['B']

In [419]: dftd
Out[419]: 
           A                   B                  C
0 2013-01-01 2013-01-01 00:00:10  -1 days +23:59:50
1 2013-01-01 2013-01-02 00:00:10  -2 days +23:59:50
2 2013-01-01 2013-01-03 00:00:10  -3 days +23:59:50
3 2013-01-01 2013-01-04 00:00:10  -4 days +23:59:50
4 2013-01-01 2013-01-05 00:00:10  -5 days +23:59:50
5 2013-01-01 2013-01-06 00:00:10  -6 days +23:59:50
6 2013-01-01 2013-01-07 00:00:10  -7 days +23:59:50
7 2013-01-01 2013-01-08 00:00:10  -8 days +23:59:50
8 2013-01-01 2013-01-09 00:00:10  -9 days +23:59:50
9 2013-01-01 2013-01-10 00:00:10 -10 days +23:59:50

In [420]: store.append('dftd', dftd, data_columns=True)

In [421]: store.select('dftd', "C<'-3.5D'")
Out[421]: 
           A                   B                  C
4 2013-01-01 2013-01-05 00:00:10  -5 days +23:59:50
5 2013-01-01 2013-01-06 00:00:10  -6 days +23:59:50
6 2013-01-01 2013-01-07 00:00:10  -7 days +23:59:50
7 2013-01-01 2013-01-08 00:00:10  -8 days +23:59:50
8 2013-01-01 2013-01-09 00:00:10  -9 days +23:59:50
9 2013-01-01 2013-01-10 00:00:10 -10 days +23:59:50
```

#### 索引

你能在表格中已经有数据的情况下（在``append/put``操作之后）使用``create_table_index``创建/修改表格的索引。给表格创建索引是**强**推荐的操作。当你使用带有索引的``select``当作``where``查询条件的时候，这将极大的加快你的查询速度。

::: tip 注意

索引会自动创建在可索引对象和任意你指定的数据列。你可以传递``index=False`` 到``append``来关闭这个操作。

:::

```python
# we have automagically already created an index (in the first section)
In [422]: i = store.root.df.table.cols.index.index

In [423]: i.optlevel, i.kind
Out[423]: (6, 'medium')

# change an index by passing new parameters
In [424]: store.create_table_index('df', optlevel=9, kind='full')

In [425]: i = store.root.df.table.cols.index.index

In [426]: i.optlevel, i.kind
Out[426]: (9, 'full')
```

通常当有大量数据添加保存的时候，关闭添加列的索引创建，等结束后再创建是非常有效的。

```python
In [427]: df_1 = pd.DataFrame(np.random.randn(10, 2), columns=list('AB'))

In [428]: df_2 = pd.DataFrame(np.random.randn(10, 2), columns=list('AB'))

In [429]: st = pd.HDFStore('appends.h5', mode='w')

In [430]: st.append('df', df_1, data_columns=['B'], index=False)

In [431]: st.append('df', df_2, data_columns=['B'], index=False)

In [432]: st.get_storer('df').table
Out[432]: 
/df/table (Table(20,)) ''
  description := {
  "index": Int64Col(shape=(), dflt=0, pos=0),
  "values_block_0": Float64Col(shape=(1,), dflt=0.0, pos=1),
  "B": Float64Col(shape=(), dflt=0.0, pos=2)}
  byteorder := 'little'
  chunkshape := (2730,)
```

当完成添加后再创建索引。

```python
In [433]: st.create_table_index('df', columns=['B'], optlevel=9, kind='full')

In [434]: st.get_storer('df').table
Out[434]: 
/df/table (Table(20,)) ''
  description := {
  "index": Int64Col(shape=(), dflt=0, pos=0),
  "values_block_0": Float64Col(shape=(1,), dflt=0.0, pos=1),
  "B": Float64Col(shape=(), dflt=0.0, pos=2)}
  byteorder := 'little'
  chunkshape := (2730,)
  autoindex := True
  colindexes := {
    "B": Index(9, full, shuffle, zlib(1)).is_csi=True}

In [435]: st.close()
```
看[这里](https://stackoverflow.com/questions/17893370/ptrepack-sortby-needs-full-index "这里")关于如何在现存的表格中创建完全分类索引（CSI)。

#### 通过数据列查询

你可以指定（并建立索引）某些你希望能够执行查询的列（除了可索引的列，你始终可以查询这些列）。例如，假设你要在磁盘上执行此常规操作，仅返回与该查询匹配的帧。你可以指定``data_columns = True``来强制所有列为``data_columns``。

```python
In [436]: df_dc = df.copy()

In [437]: df_dc['string'] = 'foo'

In [438]: df_dc.loc[df_dc.index[4:6], 'string'] = np.nan

In [439]: df_dc.loc[df_dc.index[7:9], 'string'] = 'bar'

In [440]: df_dc['string2'] = 'cool'

In [441]: df_dc.loc[df_dc.index[1:3], ['B', 'C']] = 1.0

In [442]: df_dc
Out[442]: 
                   A         B         C string string2
2000-01-01 -0.426936 -1.780784  0.322691    foo    cool
2000-01-02  1.638174  1.000000  1.000000    foo    cool
2000-01-03 -1.022803  1.000000  1.000000    foo    cool
2000-01-04  1.767446 -1.305266 -0.378355    foo    cool
2000-01-05  0.486743  0.954551  0.859671    NaN    cool
2000-01-06 -1.170458 -1.211386 -0.852728    NaN    cool
2000-01-07 -0.450781  1.064650  1.014927    foo    cool
2000-01-08 -0.810399  0.254343 -0.875526    bar    cool

# on-disk operations
In [443]: store.append('df_dc', df_dc, data_columns=['B', 'C', 'string', 'string2'])

In [444]: store.select('df_dc', where='B > 0')
Out[444]: 
                   A         B         C string string2
2000-01-02  1.638174  1.000000  1.000000    foo    cool
2000-01-03 -1.022803  1.000000  1.000000    foo    cool
2000-01-05  0.486743  0.954551  0.859671    NaN    cool
2000-01-07 -0.450781  1.064650  1.014927    foo    cool
2000-01-08 -0.810399  0.254343 -0.875526    bar    cool

# getting creative
In [445]: store.select('df_dc', 'B > 0 & C > 0 & string == foo')
Out[445]: 
                   A        B         C string string2
2000-01-02  1.638174  1.00000  1.000000    foo    cool
2000-01-03 -1.022803  1.00000  1.000000    foo    cool
2000-01-07 -0.450781  1.06465  1.014927    foo    cool

# this is in-memory version of this type of selection
In [446]: df_dc[(df_dc.B > 0) & (df_dc.C > 0) & (df_dc.string == 'foo')]
Out[446]: 
                   A        B         C string string2
2000-01-02  1.638174  1.00000  1.000000    foo    cool
2000-01-03 -1.022803  1.00000  1.000000    foo    cool
2000-01-07 -0.450781  1.06465  1.014927    foo    cool

# we have automagically created this index and the B/C/string/string2
# columns are stored separately as ``PyTables`` columns
In [447]: store.root.df_dc.table
Out[447]: 
/df_dc/table (Table(8,)) ''
  description := {
  "index": Int64Col(shape=(), dflt=0, pos=0),
  "values_block_0": Float64Col(shape=(1,), dflt=0.0, pos=1),
  "B": Float64Col(shape=(), dflt=0.0, pos=2),
  "C": Float64Col(shape=(), dflt=0.0, pos=3),
  "string": StringCol(itemsize=3, shape=(), dflt=b'', pos=4),
  "string2": StringCol(itemsize=4, shape=(), dflt=b'', pos=5)}
  byteorder := 'little'
  chunkshape := (1680,)
  autoindex := True
  colindexes := {
    "index": Index(6, medium, shuffle, zlib(1)).is_csi=False,
    "B": Index(6, medium, shuffle, zlib(1)).is_csi=False,
    "C": Index(6, medium, shuffle, zlib(1)).is_csi=False,
    "string": Index(6, medium, shuffle, zlib(1)).is_csi=False,
    "string2": Index(6, medium, shuffle, zlib(1)).is_csi=False}
```
把很多列变成*数据列*会存在性能下降的情况，因此它取决于用户。此外，在第一次添加/插入操作后你不能改变数据列（也不能索引）（当然，你能读取数据和创建一个新表！）。

#### 迭代器

你能传递``iterator=True``或者``chunksize=number_in_a_chunk``给``select`` 和``select_as_multiple``，然后在结果中返回一个迭代器。默认一个块返回50,000行。

```python
In [448]: for df in store.select('df', chunksize=3):
   .....:     print(df)
   .....: 
                   A         B         C
2000-01-01 -0.426936 -1.780784  0.322691
2000-01-02  1.638174 -2.184251  0.049673
2000-01-03 -1.022803  0.889445  2.827717
                   A         B         C
2000-01-04  1.767446 -1.305266 -0.378355
2000-01-05  0.486743  0.954551  0.859671
2000-01-06 -1.170458 -1.211386 -0.852728
                   A         B         C
2000-01-07 -0.450781  1.064650  1.014927
2000-01-08 -0.810399  0.254343 -0.875526
```

::: tip 注意

你也能使用``read_hdf`` 打开迭代器，然后迭代结束会自动关闭保存。

```python
for df in pd.read_hdf('store.h5', 'df', chunksize=3):
    print(df)
```

:::

注意，chunksize主要适用于**源**行。因此，如果你正在进行查询，chunksize将细分表中的总行和应用的查询，并在大小可能不相等的块上返回一个迭代器。

这是生成查询并使用它创建大小相等的返回块的方法。

```python
In [449]: dfeq = pd.DataFrame({'number': np.arange(1, 11)})

In [450]: dfeq
Out[450]: 
   number
0       1
1       2
2       3
3       4
4       5
5       6
6       7
7       8
8       9
9      10

In [451]: store.append('dfeq', dfeq, data_columns=['number'])

In [452]: def chunks(l, n):
   .....:     return [l[i:i + n] for i in range(0, len(l), n)]
   .....: 

In [453]: evens = [2, 4, 6, 8, 10]

In [454]: coordinates = store.select_as_coordinates('dfeq', 'number=evens')

In [455]: for c in chunks(coordinates, 2):
   .....:     print(store.select('dfeq', where=c))
   .....: 
   number
1       2
3       4
   number
5       6
7       8
   number
9      10
```

#### 高级查询

##### 选取单列

使用``select_column``方法可以找到单个可索引列或数据列。例如，这将让你非常快速地得到索引。它会返回一个由行号索引的``Series``结果。目前不接受``where``选择器。

```python
In [456]: store.select_column('df_dc', 'index')
Out[456]: 
0   2000-01-01
1   2000-01-02
2   2000-01-03
3   2000-01-04
4   2000-01-05
5   2000-01-06
6   2000-01-07
7   2000-01-08
Name: index, dtype: datetime64[ns]

In [457]: store.select_column('df_dc', 'string')
Out[457]: 
0    foo
1    foo
2    foo
3    foo
4    NaN
5    NaN
6    foo
7    bar
Name: string, dtype: object
```

##### 选取坐标

有时候你想要得到查询的坐标（又叫做 索引的定位），使用``Int64Index``将返回结果的定位。这些坐标也可以传递给之后的``where``操作。

```python
In [458]: df_coord = pd.DataFrame(np.random.randn(1000, 2),
   .....:                         index=pd.date_range('20000101', periods=1000))
   .....: 

In [459]: store.append('df_coord', df_coord)

In [460]: c = store.select_as_coordinates('df_coord', 'index > 20020101')

In [461]: c
Out[461]: 
Int64Index([732, 733, 734, 735, 736, 737, 738, 739, 740, 741,
            ...
            990, 991, 992, 993, 994, 995, 996, 997, 998, 999],
           dtype='int64', length=268)

In [462]: store.select('df_coord', where=c)
Out[462]: 
                   0         1
2002-01-02  0.440865 -0.151651
2002-01-03 -1.195089  0.285093
2002-01-04 -0.925046  0.386081
2002-01-05 -1.942756  0.277699
2002-01-06  0.811776  0.528965
...              ...       ...
2002-09-22  1.061729  0.618085
2002-09-23 -0.209744  0.677197
2002-09-24 -1.808184  0.185667
2002-09-25 -0.208629  0.928603
2002-09-26  1.579717 -1.259530

[268 rows x 2 columns]
```

##### 使用位置遮罩选取

有时你的查询可能涉及到创建要选择的行列表。通常这个``mask``将得到索引操作的``index``结果。下面这个例子显示了选取日期索引的月份等于5的操作。

```python
In [463]: df_mask = pd.DataFrame(np.random.randn(1000, 2),
   .....:                        index=pd.date_range('20000101', periods=1000))
   .....: 

In [464]: store.append('df_mask', df_mask)

In [465]: c = store.select_column('df_mask', 'index')

In [466]: where = c[pd.DatetimeIndex(c).month == 5].index

In [467]: store.select('df_mask', where=where)
Out[467]: 
                   0         1
2000-05-01 -1.199892  1.073701
2000-05-02 -1.058552  0.658487
2000-05-03 -0.015418  0.452879
2000-05-04  1.737818  0.426356
2000-05-05 -0.711668 -0.021266
...              ...       ...
2002-05-27  0.656196  0.993383
2002-05-28 -0.035399 -0.269286
2002-05-29  0.704503  2.574402
2002-05-30 -1.301443  2.770770
2002-05-31 -0.807599  0.420431

[93 rows x 2 columns]
```

##### 存储对象

如果你想检查存储对象，可以通过``get_storer``找到。你能使用这种编程方法获得一个对象的行数。

```python
In [468]: store.get_storer('df_dc').nrows
Out[468]: 8
```

#### 多表查询

``append_to_multiple``和``select_as_multiple``方法能一次性执行多表的添加/选取操作。这个方法是让一个表（称为选择器表）索引大多数/所有列，并执行查询。其他表是带索引的数据表，它会匹配选择器表的索引。然后，你能在选择器表执行非常快速的查询并返回大量数据。这个方法类似于有个非常宽的表，但能高效的查询。

``append_to_multiple``方法根据``d``把单个DataFrame划分为多个表，这里的d指的是字典，即将表名映射到该表中所需的“列”列表。如果使用*None*代替列表，则该表将具有给定DataFrame的其余未指定列。``selector``参数定义了哪张表是选择器表（即你可以从中执行查询的）。``dropna``参数将删除输入``DataFrame ``的行来确保表格是同步的。这意味着如果其中一张表写入的一行全是``np.NaN``，那么将从所有表中删除这行。

如果``dropna``是False，则**用户负责同步表**。记住全是``np.Nan``的行是不会写入HDFStore，因此如果你选择``dropna=False``，一些表会比其他表具有更多行，而且``select_as_multiple ``将不会有作用或返回意外的结果。

```python
In [469]: df_mt = pd.DataFrame(np.random.randn(8, 6),
   .....:                      index=pd.date_range('1/1/2000', periods=8),
   .....:                      columns=['A', 'B', 'C', 'D', 'E', 'F'])
   .....: 

In [470]: df_mt['foo'] = 'bar'

In [471]: df_mt.loc[df_mt.index[1], ('A', 'B')] = np.nan

# you can also create the tables individually
In [472]: store.append_to_multiple({'df1_mt': ['A', 'B'], 'df2_mt': None},
   .....:                          df_mt, selector='df1_mt')
   .....: 

In [473]: store
Out[473]: 
<class 'pandas.io.pytables.HDFStore'>
File path: store.h5

# individual tables were created
In [474]: store.select('df1_mt')
Out[474]: 
                   A         B
2000-01-01  0.475158  0.427905
2000-01-02       NaN       NaN
2000-01-03 -0.201829  0.651656
2000-01-04 -0.766427 -1.852010
2000-01-05  1.642910 -0.055583
2000-01-06  0.187880  1.536245
2000-01-07 -1.801014  0.244721
2000-01-08  3.055033 -0.683085

In [475]: store.select('df2_mt')
Out[475]: 
                   C         D         E         F  foo
2000-01-01  1.846285 -0.044826  0.074867  0.156213  bar
2000-01-02  0.446978 -0.323516  0.311549 -0.661368  bar
2000-01-03 -2.657254  0.649636  1.520717  1.604905  bar
2000-01-04 -0.201100 -2.107934 -0.450691 -0.748581  bar
2000-01-05  0.543779  0.111444  0.616259 -0.679614  bar
2000-01-06  0.831475 -0.566063  1.130163 -1.004539  bar
2000-01-07  0.745984  1.532560  0.229376  0.526671  bar
2000-01-08 -0.922301  2.760888  0.515474 -0.129319  bar

# as a multiple
In [476]: store.select_as_multiple(['df1_mt', 'df2_mt'], where=['A>0', 'B>0'],
   .....:                          selector='df1_mt')
   .....: 
Out[476]: 
                   A         B         C         D         E         F  foo
2000-01-01  0.475158  0.427905  1.846285 -0.044826  0.074867  0.156213  bar
2000-01-06  0.187880  1.536245  0.831475 -0.566063  1.130163 -1.004539  bar
```

### 从表中删除

你能够通过``where``指定有选择地从表中删除数据。删除行，重点理解``PyTables``删除行是通过先抹去行，接着**删除**后面的数据。因此，根据数据的方向来删除会是非常耗时的操作。所以为了获得最佳性能，首先让要删除的数据维度可索引是很有必要的。

数据根据（在磁盘上）可索引项来排序，这里有个简单的用例。你能存储面板数据（也叫时间序列-截面数据），在``major_axis``中存储日期，而``minor_axis``中存储ids。数据像下面这样交错：

- date_1
  - id_1
  - id_2
  - .
  - id_n
- date_2
  - id_1
  - .
  - id_n

应该清楚的是在 ``major_axis`` 上的删除操作将非常快，正如数据块被删除，接着后面的数据也会移动。另一方面，在``minor_axis`` 的操作将非常耗时。在这种情况下，几乎可以肯定使用``where``操作来选取所有除开缺失数据的列重写表格会更快。

::: danger 警告

请注意HDF5**不会自动回收空间**在h5文件中。于是重复地删除（或者移除节点）再添加操作**将会导致文件体积增大**。

要重新打包和清理文件，请使用[ptrepack](https://www.pypandas.cn/docs/user_guide/io.html#io-hdf5-ptrepack "ptrepack")。

:::

### 注意事项

#### 压缩

``PyTables`` 允许存储地数据被压缩。这适用于所有类型地存储，不仅仅是表格。这两个参数
 ``complevel``和 ``complib``可用来控制压缩。

``complevel``指定数据会以何种方式压缩。

``complib`` 指定要使用的压缩库。如果没有指定，那将使用默认的 ``zlib``库。压缩库通常会从压缩率或速度两方面来优化，而结果取决于数据类型。选择哪种压缩类型取决于你的具体需求和数据。下面是支持的压缩库列表：

- [zlib](https://zlib.net/): 默认的压缩库。经典的压缩方式，能获得好的压缩率但是速度有点慢。
- [lzo](https://www.oberhumer.com/opensource/lzo/):  快速地压缩和解压。
- [bzip2](http://bzip.org/): 不错的压缩率。
- [blosc](http://www.blosc.org/): 快速地压缩和解压。

*New in version 0.20.2:* 支持另一种blosc压缩机：

- [blosc:blosclz](http://www.blosc.org/) 这是默认地``blosc``压缩机
- [blosc:lz4](https://fastcompression.blogspot.dk/p/lz4.html):
一款紧凑、快速且流行的压缩机。
- [blosc:lz4hc](https://fastcompression.blogspot.dk/p/lz4.html):
调整后的LZ4版本可产生更好的压缩比，但会牺牲速度。
- [blosc:snappy](https://google.github.io/snappy/):
一款在很多地方使用的流行压缩机。
- [blosc:zlib](https://zlib.net/): 经典款；虽然比前一款速度慢，但是可实现更好的压缩比。
- [blosc:zstd](https://facebook.github.io/zstd/): 极其平衡的编解码器；它是以上所有压缩机中提供最佳压缩比的，且速度相当快。

如果 ``complib``定义为其他的，不在上表中的库 ，那么就会出现 ``ValueError``。

::: tip 注意

如果你的平台上缺失指定的 ``complib`` 库，压缩机会使用默认 ``zlib``库。

:::

文件中所有的对象都可以启用压缩：

``` python
store_compressed = pd.HDFStore('store_compressed.h5', complevel=9,
                               complib='blosc:blosclz')

```
或者在未启用压缩的存储中进行即时压缩（这仅适用于表格）：

``` python
store.append('df', df, complib='zlib', complevel=5)

```

#### ptrepack

``PyTables``不是在一开始的时候开启压缩，而是在表被写入后再压缩，这提供了更好的写入性能。你能使用 ``PyTables`` 提供的实用程序``ptrepack``实现。此外，事实上在``ptrepack`` 之后会改变压缩等级。

``` 
ptrepack --chunkshape=auto --propindexes --complevel=9 --complib=blosc in.h5 out.h5

```

另外， ``ptrepack in.h5 out.h5`` 将重新打包文件让你可以重用之前删除的空间。或者，它能简单的删除文件并再次写入亦或使用 ``copy`` 方法。

#### 注意事项

::: danger 警告

``HDFStore``  **不是一个安全的写入线程**. ``PyTables`` 的底层仅支持（通过线程或进程的）并发读取。如果你要同时读取和写入，那么你需要单个进程的单个线程里序列化这些操作，否则会破坏你的数据。更多信息参见([GH2397](https://github.com/pandas-dev/pandas/issues/2397))。

:::

- 如果你用锁来管理多个进程间的写入， 那么你可能要在释放写锁之前使用[``fsync()``](https://docs.python.org/3/library/os.html#os.fsync) 。方便起见，你能用 ``store.flush(fsync=True)`` 操作。
- 一旦 ``table``创建的列（DataFrame)固定了; 那只有相同的列才可以添加数据。
- 注意时区 (例如, ``pytz.timezone('US/Eastern')``)在不同的时区版本间不相等。
因此，如果使用时区库的一个版本将数据本地化到HDFStore中的特定时区，并且使用另一个版本更新该数据，则由于这些时区不相等，因此数据将转换为UTC。使用相同版本的时区库或在更新的时区定义中使用 ``tz_convert``。

::: danger 警告

如果列名没能用作属性选择器，那么``PyTables`` 将显示``NaturalNameWarning`` 。
自然标识符仅包括字母、数字和下划线，且不能以数字开头。其他标识符不能用``where`` 从句，这通常不是个好主意。

:::

### 数据类型

``HDFStore`` 将对象数据类型映射到 ``PyTables`` 的底层数据类型。这意味着以下的已知类型都有效：

Type | Represents missing values
---|---
floating : float64, float32, float16 | np.nan
integer : int64, int32, int8, uint64,uint32, uint8 |  
boolean |  
datetime64[ns] | NaT
timedelta64[ns] | NaT
categorical : see the section below |  
object : strings | np.nan

不支持``unicode`` 列，这会出现 **映射失败**.

#### 数据类别

你可以写入含``category`` 类型的数据到 ``HDFStore``。如果它是对象数组，那查询方式是一样的。然而， 含``category``的数据会以更高效的方式存储。

``` python
In [477]: dfcat = pd.DataFrame({'A': pd.Series(list('aabbcdba')).astype('category'),
   .....:                       'B': np.random.randn(8)})
   .....: 

In [478]: dfcat
Out[478]: 
   A         B
0  a  1.706605
1  a  1.373485
2  b -0.758424
3  b -0.116984
4  c -0.959461
5  d -1.517439
6  b -0.453150
7  a -0.827739

In [479]: dfcat.dtypes
Out[479]: 
A    category
B     float64
dtype: object

In [480]: cstore = pd.HDFStore('cats.h5', mode='w')

In [481]: cstore.append('dfcat', dfcat, format='table', data_columns=['A'])

In [482]: result = cstore.select('dfcat', where="A in ['b', 'c']")

In [483]: result
Out[483]: 
   A         B
2  b -0.758424
3  b -0.116984
4  c -0.959461
6  b -0.453150

In [484]: result.dtypes
Out[484]: 
A    category
B     float64
dtype: object

```

#### 字符串列

**min_itemsize**

对于字符串列， ``HDFStore``的底层使用的固定列宽（列的大小）。字符串列大小的计算方式是： **在第一个添加的时候**，传递给 ``HDFStore``（该列）数据长度的最大值。 随后的添加可能会引入**更大**一列字符串，这超过了该列所能容纳的内容，这将引发异常（不然，你可以悄悄地截断这些列，让信息丢失）。之后将放松这一点，允许用户指定截断。 

在第一个表创建的时候，传递 ``min_itemsize`` 将优先指定特定字符串列的最小长度。``min_itemsize``可以是整数或将列名映射为整数的字典。 你可以将``values``作为键传递，以允许所有可索引对象或data_columns具有此min_itemsize。

传递 ``min_itemsize``字典将导致所有可传递列自动创建 data_columns。

::: tip 注意

如果你没有传递任意 ``data_columns``,那么``min_itemsize``将会传递任意字符串的最大长度。

:::

``` python
In [485]: dfs = pd.DataFrame({'A': 'foo', 'B': 'bar'}, index=list(range(5)))

In [486]: dfs
Out[486]: 
     A    B
0  foo  bar
1  foo  bar
2  foo  bar
3  foo  bar
4  foo  bar

# A and B have a size of 30
In [487]: store.append('dfs', dfs, min_itemsize=30)

In [488]: store.get_storer('dfs').table
Out[488]: 
/dfs/table (Table(5,)) ''
  description := {
  "index": Int64Col(shape=(), dflt=0, pos=0),
  "values_block_0": StringCol(itemsize=30, shape=(2,), dflt=b'', pos=1)}
  byteorder := 'little'
  chunkshape := (963,)
  autoindex := True
  colindexes := {
    "index": Index(6, medium, shuffle, zlib(1)).is_csi=False}

# A is created as a data_column with a size of 30
# B is size is calculated
In [489]: store.append('dfs2', dfs, min_itemsize={'A': 30})

In [490]: store.get_storer('dfs2').table
Out[490]: 
/dfs2/table (Table(5,)) ''
  description := {
  "index": Int64Col(shape=(), dflt=0, pos=0),
  "values_block_0": StringCol(itemsize=3, shape=(1,), dflt=b'', pos=1),
  "A": StringCol(itemsize=30, shape=(), dflt=b'', pos=2)}
  byteorder := 'little'
  chunkshape := (1598,)
  autoindex := True
  colindexes := {
    "index": Index(6, medium, shuffle, zlib(1)).is_csi=False,
    "A": Index(6, medium, shuffle, zlib(1)).is_csi=False}

```

**nan_rep**

字符串列将序列化 ``np.nan`` （缺失值）以 ``nan_rep`` 的字符串形式。默认的字符串值为``nan``。你可能会无意中将实际的``nan``值转换为缺失值。

``` python
In [491]: dfss = pd.DataFrame({'A': ['foo', 'bar', 'nan']})

In [492]: dfss
Out[492]: 
     A
0  foo
1  bar
2  nan

In [493]: store.append('dfss', dfss)

In [494]: store.select('dfss')
Out[494]: 
     A
0  foo
1  bar
2  NaN

# here you need to specify a different nan rep
In [495]: store.append('dfss2', dfss, nan_rep='_nan_')

In [496]: store.select('dfss2')
Out[496]: 
     A
0  foo
1  bar
2  nan

```

### 外部兼容性

``HDFStore``以特定格式写入``table``对象，这些格式适用于产生无损往返的pandas对象。 对于外部兼容性， ``HDFStore`` 能读取本地的 ``PyTables`` 格式表格。

可以编写一个``HDFStore`` 对象，该对象可以使用``rhdf5`` 库 ([Package website](https://www.bioconductor.org/packages/release/bioc/html/rhdf5.html))轻松导入到``R`` 中。创建表格存储可以像这样：

``` python
In [497]: df_for_r = pd.DataFrame({"first": np.random.rand(100),
   .....:                          "second": np.random.rand(100),
   .....:                          "class": np.random.randint(0, 2, (100, ))},
   .....:                         index=range(100))
   .....: 

In [498]: df_for_r.head()
Out[498]: 
      first    second  class
0  0.366979  0.794525      0
1  0.296639  0.635178      1
2  0.395751  0.359693      0
3  0.484648  0.970016      1
4  0.810047  0.332303      0

In [499]: store_export = pd.HDFStore('export.h5')

In [500]: store_export.append('df_for_r', df_for_r, data_columns=df_dc.columns)

In [501]: store_export
Out[501]: 
<class 'pandas.io.pytables.HDFStore'>
File path: export.h5

```
在这个R文件中使用``rhdf5``库能读入数据到``data.frame``对象中。下面这个示例函数从值中读取相应的列名和数据值，再组合它们到``data.frame``中:

``` R
# Load values and column names for all datasets from corresponding nodes and
# insert them into one data.frame object.

library(rhdf5)

loadhdf5data <- function(h5File) {

listing <- h5ls(h5File)
# Find all data nodes, values are stored in *_values and corresponding column
# titles in *_items
data_nodes <- grep("_values", listing$name)
name_nodes <- grep("_items", listing$name)
data_paths = paste(listing$group[data_nodes], listing$name[data_nodes], sep = "/")
name_paths = paste(listing$group[name_nodes], listing$name[name_nodes], sep = "/")
columns = list()
for (idx in seq(data_paths)) {
  # NOTE: matrices returned by h5read have to be transposed to obtain
  # required Fortran order!
  data <- data.frame(t(h5read(h5File, data_paths[idx])))
  names <- t(h5read(h5File, name_paths[idx]))
  entry <- data.frame(data)
  colnames(entry) <- names
  columns <- append(columns, entry)
}

data <- data.frame(columns)

return(data)
}

```

现在你能导入 ``DataFrame`` 到R中:

``` R
> data = loadhdf5data("transfer.hdf5")
> head(data)
         first    second class
1 0.4170220047 0.3266449     0
2 0.7203244934 0.5270581     0
3 0.0001143748 0.8859421     1
4 0.3023325726 0.3572698     1
5 0.1467558908 0.9085352     1
6 0.0923385948 0.6233601     1

```

::: tip 注意

R函数列出了整个HDF5文件的内容，并从所有匹配的节点组合了``data.frame`` 对象，因此，如果你已将多个``DataFrame``对象存储到单个HDF5文件中，那么只能用它作为起点。

:::

### 性能

- 同``fixed``存储相比较，``tables`` 格式会有写入的性能损失。这样的好处就是便于（大量的数据）能添加/删除和查询。与常规存储相比，写入时间通常更长。但是查询的时间就相当快，特别是在有索引的轴上。
- 你可以传递 ``chunksize=`` 给``append``, 指定写入块的大小（默认是50000）。这将极大地降低写入时地内存使用情况。 
- 你可以将`` expectedrows =``传递给第一个``append``来设置``PyTables``将预期的总行数。 这将优化读取/写入性能。
- 重复的行可以写入表格，但是在选取的时候会进行筛选（会选最后一项；然后表在主要、次要对上是唯一的）。
- 如果你企图存储已经序列化的PyTables类型数据（而不是存储为本地数据），那将引发A ``PerformanceWarning`` 。更多信息和解决办法参见[Here](https://stackoverflow.com/questions/14355151/how-to-make-pandas-hdfstore-put-operation-faster/14370190#14370190)。

## Feather

*New in version 0.20.0.* 

Feather provides binary columnar serialization for data frames. It is designed to make reading and writing data
frames efficient, and to make sharing data across data analysis languages easy.

Feather is designed to faithfully serialize and de-serialize DataFrames, supporting all of the pandas
dtypes, including extension dtypes such as categorical and datetime with tz.

Several caveats.

- This is a newer library, and the format, though stable, is not guaranteed to be backward compatible
to the earlier versions.
- The format will NOT write an ``Index``, or ``MultiIndex`` for the
``DataFrame`` and will raise an error if a non-default one is provided. You
can ``.reset_index()`` to store the index or ``.reset_index(drop=True)`` to
ignore it.
- Duplicate column names and non-string columns names are not supported
- Non supported types include ``Period`` and actual Python object types. These will raise a helpful error message
on an attempt at serialization.

See the [Full Documentation](https://github.com/wesm/feather).

``` python
In [502]: df = pd.DataFrame({'a': list('abc'),
   .....:                    'b': list(range(1, 4)),
   .....:                    'c': np.arange(3, 6).astype('u1'),
   .....:                    'd': np.arange(4.0, 7.0, dtype='float64'),
   .....:                    'e': [True, False, True],
   .....:                    'f': pd.Categorical(list('abc')),
   .....:                    'g': pd.date_range('20130101', periods=3),
   .....:                    'h': pd.date_range('20130101', periods=3, tz='US/Eastern'),
   .....:                    'i': pd.date_range('20130101', periods=3, freq='ns')})
   .....: 

In [503]: df
Out[503]: 
   a  b  c    d      e  f          g                         h                             i
0  a  1  3  4.0   True  a 2013-01-01 2013-01-01 00:00:00-05:00 2013-01-01 00:00:00.000000000
1  b  2  4  5.0  False  b 2013-01-02 2013-01-02 00:00:00-05:00 2013-01-01 00:00:00.000000001
2  c  3  5  6.0   True  c 2013-01-03 2013-01-03 00:00:00-05:00 2013-01-01 00:00:00.000000002

In [504]: df.dtypes
Out[504]: 
a                        object
b                         int64
c                         uint8
d                       float64
e                          bool
f                      category
g                datetime64[ns]
h    datetime64[ns, US/Eastern]
i                datetime64[ns]
dtype: object

```

Write to a feather file.

``` python
In [505]: df.to_feather('example.feather')

```

Read from a feather file.

``` python
In [506]: result = pd.read_feather('example.feather')

In [507]: result
Out[507]: 
   a  b  c    d      e  f          g                         h                             i
0  a  1  3  4.0   True  a 2013-01-01 2013-01-01 00:00:00-05:00 2013-01-01 00:00:00.000000000
1  b  2  4  5.0  False  b 2013-01-02 2013-01-02 00:00:00-05:00 2013-01-01 00:00:00.000000001
2  c  3  5  6.0   True  c 2013-01-03 2013-01-03 00:00:00-05:00 2013-01-01 00:00:00.000000002

# we preserve dtypes
In [508]: result.dtypes
Out[508]: 
a                        object
b                         int64
c                         uint8
d                       float64
e                          bool
f                      category
g                datetime64[ns]
h    datetime64[ns, US/Eastern]
i                datetime64[ns]
dtype: object

```

## Parquet

*New in version 0.21.0.* 

[Apache Parquet](https://parquet.apache.org/) provides a partitioned binary columnar serialization for data frames. It is designed to
make reading and writing data frames efficient, and to make sharing data across data analysis
languages easy. Parquet can use a variety of compression techniques to shrink the file size as much as possible
while still maintaining good read performance.

Parquet is designed to faithfully serialize and de-serialize ``DataFrame`` s, supporting all of the pandas
dtypes, including extension dtypes such as datetime with tz.

Several caveats.

- Duplicate column names and non-string columns names are not supported.
- The ``pyarrow`` engine always writes the index to the output, but ``fastparquet`` only writes non-default
indexes. This extra column can cause problems for non-Pandas consumers that are not expecting it. You can
force including or omitting indexes with the ``index`` argument, regardless of the underlying engine.
- Index level names, if specified, must be strings.
- Categorical dtypes can be serialized to parquet, but will de-serialize as ``object`` dtype.
- Non supported types include ``Period`` and actual Python object types. These will raise a helpful error message
on an attempt at serialization.

You can specify an ``engine`` to direct the serialization. This can be one of ``pyarrow``, or ``fastparquet``, or ``auto``.
If the engine is NOT specified, then the ``pd.options.io.parquet.engine`` option is checked; if this is also ``auto``,
then ``pyarrow`` is tried, and falling back to ``fastparquet``.

See the documentation for [pyarrow](https://arrow.apache.org/docs/python/) and [fastparquet](https://fastparquet.readthedocs.io/en/latest/).

::: tip Note

These engines are very similar and should read/write nearly identical parquet format files.
Currently ``pyarrow`` does not support timedelta data, ``fastparquet>=0.1.4`` supports timezone aware datetimes.
These libraries differ by having different underlying dependencies (``fastparquet`` by using ``numba``, while ``pyarrow`` uses a c-library).

:::

``` python
In [509]: df = pd.DataFrame({'a': list('abc'),
   .....:                    'b': list(range(1, 4)),
   .....:                    'c': np.arange(3, 6).astype('u1'),
   .....:                    'd': np.arange(4.0, 7.0, dtype='float64'),
   .....:                    'e': [True, False, True],
   .....:                    'f': pd.date_range('20130101', periods=3),
   .....:                    'g': pd.date_range('20130101', periods=3, tz='US/Eastern')})
   .....: 

In [510]: df
Out[510]: 
   a  b  c    d      e          f                         g
0  a  1  3  4.0   True 2013-01-01 2013-01-01 00:00:00-05:00
1  b  2  4  5.0  False 2013-01-02 2013-01-02 00:00:00-05:00
2  c  3  5  6.0   True 2013-01-03 2013-01-03 00:00:00-05:00

In [511]: df.dtypes
Out[511]: 
a                        object
b                         int64
c                         uint8
d                       float64
e                          bool
f                datetime64[ns]
g    datetime64[ns, US/Eastern]
dtype: object

```

Write to a parquet file.

``` python
In [512]: df.to_parquet('example_pa.parquet', engine='pyarrow')

In [513]: df.to_parquet('example_fp.parquet', engine='fastparquet')

```

Read from a parquet file.

``` python
In [514]: result = pd.read_parquet('example_fp.parquet', engine='fastparquet')

In [515]: result = pd.read_parquet('example_pa.parquet', engine='pyarrow')

In [516]: result.dtypes
Out[516]: 
a                        object
b                         int64
c                         uint8
d                       float64
e                          bool
f                datetime64[ns]
g    datetime64[ns, US/Eastern]
dtype: object

```

Read only certain columns of a parquet file.

``` python
In [517]: result = pd.read_parquet('example_fp.parquet',
   .....:                          engine='fastparquet', columns=['a', 'b'])
   .....: 

In [518]: result = pd.read_parquet('example_pa.parquet',
   .....:                          engine='pyarrow', columns=['a', 'b'])
   .....: 

In [519]: result.dtypes
Out[519]: 
a    object
b     int64
dtype: object

```

### Handling indexes

Serializing a ``DataFrame`` to parquet may include the implicit index as one or
more columns in the output file. Thus, this code:

``` python
In [520]: df = pd.DataFrame({'a': [1, 2], 'b': [3, 4]})

In [521]: df.to_parquet('test.parquet', engine='pyarrow')

```

creates a parquet file with three columns if you use ``pyarrow`` for serialization:
``a``, ``b``, and ``__index_level_0__``. If you’re using ``fastparquet``, the
index [may or may not](https://fastparquet.readthedocs.io/en/latest/api.html#fastparquet.write)
be written to the file.

This unexpected extra column causes some databases like Amazon Redshift to reject
the file, because that column doesn’t exist in the target table.

If you want to omit a dataframe’s indexes when writing, pass ``index=False`` to
[``to_parquet()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_parquet.html#pandas.DataFrame.to_parquet):

``` python
In [522]: df.to_parquet('test.parquet', index=False)

```

This creates a parquet file with just the two expected columns, ``a`` and ``b``.
If your ``DataFrame`` has a custom index, you won’t get it back when you load
this file into a ``DataFrame``.

Passing ``index=True`` will always write the index, even if that’s not the
underlying engine’s default behavior.

### Partitioning Parquet files

*New in version 0.24.0.* 

Parquet supports partitioning of data based on the values of one or more columns.

``` python
In [523]: df = pd.DataFrame({'a': [0, 0, 1, 1], 'b': [0, 1, 0, 1]})

In [524]: df.to_parquet(fname='test', engine='pyarrow',
   .....:               partition_cols=['a'], compression=None)
   .....: 

```

The *fname* specifies the parent directory to which data will be saved.
The *partition_cols* are the column names by which the dataset will be partitioned.
Columns are partitioned in the order they are given. The partition splits are
determined by the unique values in the partition columns.
The above example creates a partitioned dataset that may look like:

``` 
test
├── a=0
│   ├── 0bac803e32dc42ae83fddfd029cbdebc.parquet
│   └──  ...
└── a=1
    ├── e6ab24a4f45147b49b54a662f0c412a3.parquet
    └── ...

```

## SQL queries

The ``pandas.io.sql`` module provides a collection of query wrappers to both
facilitate data retrieval and to reduce dependency on DB-specific API. Database abstraction
is provided by SQLAlchemy if installed. In addition you will need a driver library for
your database. Examples of such drivers are [psycopg2](http://initd.org/psycopg/)
for PostgreSQL or [pymysql](https://github.com/PyMySQL/PyMySQL) for MySQL.
For [SQLite](https://docs.python.org/3/library/sqlite3.html) this is
included in Python’s standard library by default.
You can find an overview of supported drivers for each SQL dialect in the
[SQLAlchemy docs](https://docs.sqlalchemy.org/en/latest/dialects/index.html).

If SQLAlchemy is not installed, a fallback is only provided for sqlite (and
for mysql for backwards compatibility, but this is deprecated and will be
removed in a future version).
This mode requires a Python database adapter which respect the [Python
DB-API](https://www.python.org/dev/peps/pep-0249/).

See also some [cookbook examples](cookbook.html#cookbook-sql) for some advanced strategies.

The key functions are:

Method | Description
---|---
[read_sql_table](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql.html#pandas.read_sql)(table_name, con[, schema, …]) | Read SQL database table into a DataFrame.
[read_sql_query](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql_query.html#pandas.read_sql_query)(sql, con[, index_col, …]) | Read SQL query into a DataFrame.
[read_sql](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql.html#pandas.read_sql)(sql, con[, index_col, …]) | Read SQL query or database table into a DataFrame.
[DataFrame.to_sql](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_sql.html#pandas.DataFrame.to_sql)(self, name, con[, schema, …]) | Write records stored in a DataFrame to a SQL database.

::: tip Note

The function [``read_sql()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql.html#pandas.read_sql) is a convenience wrapper around
[``read_sql_table()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql_table.html#pandas.read_sql_table) and [``read_sql_query()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql_query.html#pandas.read_sql_query) (and for
backward compatibility) and will delegate to specific function depending on
the provided input (database table name or sql query).
Table names do not need to be quoted if they have special characters.

:::

In the following example, we use the [SQlite](https://www.sqlite.org/) SQL database
engine. You can use a temporary SQLite database where data are stored in
“memory”.

To connect with SQLAlchemy you use the ``create_engine()`` function to create an engine
object from database URI. You only need to create the engine once per database you are
connecting to.
For more information on ``create_engine()`` and the URI formatting, see the examples
below and the SQLAlchemy [documentation](https://docs.sqlalchemy.org/en/latest/core/engines.html)

``` python
In [525]: from sqlalchemy import create_engine

# Create your engine.
In [526]: engine = create_engine('sqlite:///:memory:')

```

If you want to manage your own connections you can pass one of those instead:

``` python
with engine.connect() as conn, conn.begin():
    data = pd.read_sql_table('data', conn)

```

### Writing DataFrames

Assuming the following data is in a ``DataFrame`` ``data``, we can insert it into
the database using [``to_sql()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_sql.html#pandas.DataFrame.to_sql).

id | Date | Col_1 | Col_2 | Col_3
---|---|---|---|---
26 | 2012-10-18 | X | 25.7 | True
42 | 2012-10-19 | Y | -12.4 | False
63 | 2012-10-20 | Z | 5.73 | True

``` python
In [527]: data
Out[527]: 
   id       Date Col_1  Col_2  Col_3
0  26 2010-10-18     X  27.50   True
1  42 2010-10-19     Y -12.50  False
2  63 2010-10-20     Z   5.73   True

In [528]: data.to_sql('data', engine)

```

With some databases, writing large DataFrames can result in errors due to
packet size limitations being exceeded. This can be avoided by setting the
``chunksize`` parameter when calling ``to_sql``.  For example, the following
writes ``data`` to the database in batches of 1000 rows at a time:

``` python
In [529]: data.to_sql('data_chunked', engine, chunksize=1000)

```

#### SQL data types

[``to_sql()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_sql.html#pandas.DataFrame.to_sql) will try to map your data to an appropriate
SQL data type based on the dtype of the data. When you have columns of dtype
``object``, pandas will try to infer the data type.

You can always override the default type by specifying the desired SQL type of
any of the columns by using the ``dtype`` argument. This argument needs a
dictionary mapping column names to SQLAlchemy types (or strings for the sqlite3
fallback mode).
For example, specifying to use the sqlalchemy ``String`` type instead of the
default ``Text`` type for string columns:

``` python
In [530]: from sqlalchemy.types import String

In [531]: data.to_sql('data_dtype', engine, dtype={'Col_1': String})

```

::: tip Note

Due to the limited support for timedelta’s in the different database
flavors, columns with type ``timedelta64`` will be written as integer
values as nanoseconds to the database and a warning will be raised.

:::

::: tip Note

Columns of ``category`` dtype will be converted to the dense representation
as you would get with ``np.asarray(categorical)`` (e.g. for string categories
this gives an array of strings).
Because of this, reading the database table back in does **not** generate
a categorical.

:::

### Datetime data types

Using SQLAlchemy, [``to_sql()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_sql.html#pandas.DataFrame.to_sql) is capable of writing
datetime data that is timezone naive or timezone aware. However, the resulting
data stored in the database ultimately depends on the supported data type
for datetime data of the database system being used.

The following table lists supported data types for datetime data for some
common databases. Other database dialects may have different data types for
datetime data.

Database | SQL Datetime Types | Timezone Support
---|---|---
SQLite | TEXT | No
MySQL | TIMESTAMP or DATETIME | No
PostgreSQL | TIMESTAMP or TIMESTAMP WITH TIME ZONE | Yes

When writing timezone aware data to databases that do not support timezones,
the data will be written as timezone naive timestamps that are in local time
with respect to the timezone.

[``read_sql_table()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql_table.html#pandas.read_sql_table) is also capable of reading datetime data that is
timezone aware or naive. When reading ``TIMESTAMP WITH TIME ZONE`` types, pandas
will convert the data to UTC.

#### Insertion method

*New in version 0.24.0.* 

The parameter ``method`` controls the SQL insertion clause used.
Possible values are:

- ``None``: Uses standard SQL ``INSERT`` clause (one per row).
- ``'multi'``: Pass multiple values in a single ``INSERT`` clause.
It uses a special SQL syntax not supported by all backends.
This usually provides better performance for analytic databases
like Presto and Redshift, but has worse performance for
traditional SQL backend if the table contains many columns.
For more information check the SQLAlchemy [documention](http://docs.sqlalchemy.org/en/latest/core/dml.html#sqlalchemy.sql.expression.Insert.values.params.*args).
- callable with signature ``(pd_table, conn, keys, data_iter)``:
This can be used to implement a more performant insertion method based on
specific backend dialect features.

Example of a callable using PostgreSQL [COPY clause](https://www.postgresql.org/docs/current/static/sql-copy.html):

``` python
# Alternative to_sql() *method* for DBs that support COPY FROM
import csv
from io import StringIO

def psql_insert_copy(table, conn, keys, data_iter):
    # gets a DBAPI connection that can provide a cursor
    dbapi_conn = conn.connection
    with dbapi_conn.cursor() as cur:
        s_buf = StringIO()
        writer = csv.writer(s_buf)
        writer.writerows(data_iter)
        s_buf.seek(0)

        columns = ', '.join('"{}"'.format(k) for k in keys)
        if table.schema:
            table_name = '{}.{}'.format(table.schema, table.name)
        else:
            table_name = table.name

        sql = 'COPY {} ({}) FROM STDIN WITH CSV'.format(
            table_name, columns)
        cur.copy_expert(sql=sql, file=s_buf)

```

### Reading tables

[``read_sql_table()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql_table.html#pandas.read_sql_table) will read a database table given the
table name and optionally a subset of columns to read.

::: tip Note

In order to use [``read_sql_table()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql_table.html#pandas.read_sql_table), you **must** have the
SQLAlchemy optional dependency installed.

:::

``` python
In [532]: pd.read_sql_table('data', engine)
Out[532]: 
   index  id       Date Col_1  Col_2  Col_3
0      0  26 2010-10-18     X  27.50   True
1      1  42 2010-10-19     Y -12.50  False
2      2  63 2010-10-20     Z   5.73   True

```

You can also specify the name of the column as the ``DataFrame`` index,
and specify a subset of columns to be read.

``` python
In [533]: pd.read_sql_table('data', engine, index_col='id')
Out[533]: 
    index       Date Col_1  Col_2  Col_3
id                                      
26      0 2010-10-18     X  27.50   True
42      1 2010-10-19     Y -12.50  False
63      2 2010-10-20     Z   5.73   True

In [534]: pd.read_sql_table('data', engine, columns=['Col_1', 'Col_2'])
Out[534]: 
  Col_1  Col_2
0     X  27.50
1     Y -12.50
2     Z   5.73

```

And you can explicitly force columns to be parsed as dates:

``` python
In [535]: pd.read_sql_table('data', engine, parse_dates=['Date'])
Out[535]: 
   index  id       Date Col_1  Col_2  Col_3
0      0  26 2010-10-18     X  27.50   True
1      1  42 2010-10-19     Y -12.50  False
2      2  63 2010-10-20     Z   5.73   True

```

If needed you can explicitly specify a format string, or a dict of arguments
to pass to [``pandas.to_datetime()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.to_datetime.html#pandas.to_datetime):

``` python
pd.read_sql_table('data', engine, parse_dates={'Date': '%Y-%m-%d'})
pd.read_sql_table('data', engine,
                  parse_dates={'Date': {'format': '%Y-%m-%d %H:%M:%S'}})

```

You can check if a table exists using ``has_table()``

### Schema support

Reading from and writing to different schema’s is supported through the ``schema``
keyword in the [``read_sql_table()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql_table.html#pandas.read_sql_table) and [``to_sql()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_sql.html#pandas.DataFrame.to_sql)
functions. Note however that this depends on the database flavor (sqlite does not
have schema’s). For example:

``` python
df.to_sql('table', engine, schema='other_schema')
pd.read_sql_table('table', engine, schema='other_schema')

```

### Querying

You can query using raw SQL in the [``read_sql_query()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql_query.html#pandas.read_sql_query) function.
In this case you must use the SQL variant appropriate for your database.
When using SQLAlchemy, you can also pass SQLAlchemy Expression language constructs,
which are database-agnostic.

``` python
In [536]: pd.read_sql_query('SELECT * FROM data', engine)
Out[536]: 
   index  id                        Date Col_1  Col_2  Col_3
0      0  26  2010-10-18 00:00:00.000000     X  27.50      1
1      1  42  2010-10-19 00:00:00.000000     Y -12.50      0
2      2  63  2010-10-20 00:00:00.000000     Z   5.73      1

```

Of course, you can specify a more “complex” query.

``` python
In [537]: pd.read_sql_query("SELECT id, Col_1, Col_2 FROM data WHERE id = 42;", engine)
Out[537]: 
   id Col_1  Col_2
0  42     Y  -12.5

```

The [``read_sql_query()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql_query.html#pandas.read_sql_query) function supports a ``chunksize`` argument.
Specifying this will return an iterator through chunks of the query result:

``` python
In [538]: df = pd.DataFrame(np.random.randn(20, 3), columns=list('abc'))

In [539]: df.to_sql('data_chunks', engine, index=False)

```

``` python
In [540]: for chunk in pd.read_sql_query("SELECT * FROM data_chunks",
   .....:                                engine, chunksize=5):
   .....:     print(chunk)
   .....: 
          a         b         c
0 -0.900850 -0.323746  0.037100
1  0.057533 -0.032842  0.550902
2  1.026623  1.035455 -0.965140
3 -0.252405 -1.255987  0.639156
4  1.076701 -0.309155 -0.800182
          a         b         c
0 -0.206623  0.496077 -0.219935
1  0.631362 -1.166743  1.808368
2  0.023531  0.987573  0.471400
3 -0.982250 -0.192482  1.195452
4 -1.758855  0.477551  1.412567
          a         b         c
0 -1.120570  1.232764  0.417814
1  1.688089 -0.037645 -0.269582
2  0.646823 -0.603366  1.592966
3  0.724019 -0.515606 -0.180920
4  0.038244 -2.292866 -0.114634
          a         b         c
0 -0.970230 -0.963257 -0.128304
1  0.498621 -1.496506  0.701471
2 -0.272608 -0.119424 -0.882023
3 -0.253477  0.714395  0.664179
4  0.897140  0.455791  1.549590

```

You can also run a plain query without creating a ``DataFrame`` with
``execute()``. This is useful for queries that don’t return values,
such as INSERT. This is functionally equivalent to calling ``execute`` on the
SQLAlchemy engine or db connection object. Again, you must use the SQL syntax
variant appropriate for your database.

``` python
from pandas.io import sql
sql.execute('SELECT * FROM table_name', engine)
sql.execute('INSERT INTO table_name VALUES(?, ?, ?)', engine,
            params=[('id', 1, 12.2, True)])

```

### Engine connection examples

To connect with SQLAlchemy you use the ``create_engine()`` function to create an engine
object from database URI. You only need to create the engine once per database you are
connecting to.

``` python
from sqlalchemy import create_engine

engine = create_engine('postgresql://scott:tiger@localhost:5432/mydatabase')

engine = create_engine('mysql+mysqldb://scott:tiger@localhost/foo')

engine = create_engine('oracle://scott:tiger@127.0.0.1:1521/sidname')

engine = create_engine('mssql+pyodbc://mydsn')

# sqlite://<nohostname>/<path>
# where <path> is relative:
engine = create_engine('sqlite:///foo.db')

# or absolute, starting with a slash:
engine = create_engine('sqlite:////absolute/path/to/foo.db')

```

For more information see the examples the SQLAlchemy [documentation](https://docs.sqlalchemy.org/en/latest/core/engines.html)

### Advanced SQLAlchemy queries

You can use SQLAlchemy constructs to describe your query.

Use ``sqlalchemy.text()`` to specify query parameters in a backend-neutral way

``` python
In [541]: import sqlalchemy as sa

In [542]: pd.read_sql(sa.text('SELECT * FROM data where Col_1=:col1'),
   .....:             engine, params={'col1': 'X'})
   .....: 
Out[542]: 
   index  id                        Date Col_1  Col_2  Col_3
0      0  26  2010-10-18 00:00:00.000000     X   27.5      1

```

If you have an SQLAlchemy description of your database you can express where conditions using SQLAlchemy expressions

``` python
In [543]: metadata = sa.MetaData()

In [544]: data_table = sa.Table('data', metadata,
   .....:                       sa.Column('index', sa.Integer),
   .....:                       sa.Column('Date', sa.DateTime),
   .....:                       sa.Column('Col_1', sa.String),
   .....:                       sa.Column('Col_2', sa.Float),
   .....:                       sa.Column('Col_3', sa.Boolean),
   .....:                       )
   .....: 

In [545]: pd.read_sql(sa.select([data_table]).where(data_table.c.Col_3 is True), engine)
Out[545]: 
Empty DataFrame
Columns: [index, Date, Col_1, Col_2, Col_3]
Index: []

```

You can combine SQLAlchemy expressions with parameters passed to [``read_sql()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql.html#pandas.read_sql) using ``sqlalchemy.bindparam()``

``` python
In [546]: import datetime as dt

In [547]: expr = sa.select([data_table]).where(data_table.c.Date > sa.bindparam('date'))

In [548]: pd.read_sql(expr, engine, params={'date': dt.datetime(2010, 10, 18)})
Out[548]: 
   index       Date Col_1  Col_2  Col_3
0      1 2010-10-19     Y -12.50  False
1      2 2010-10-20     Z   5.73   True

```

### Sqlite fallback

The use of sqlite is supported without using SQLAlchemy.
This mode requires a Python database adapter which respect the [Python
DB-API](https://www.python.org/dev/peps/pep-0249/).

You can create connections like so:

``` python
import sqlite3
con = sqlite3.connect(':memory:')

```

And then issue the following queries:

``` python
data.to_sql('data', con)
pd.read_sql_query("SELECT * FROM data", con)

```

## Google BigQuery

::: danger Warning

Starting in 0.20.0, pandas has split off Google BigQuery support into the
separate package ``pandas-gbq``. You can ``pip install pandas-gbq`` to get it.

:::

The ``pandas-gbq`` package provides functionality to read/write from Google BigQuery.

pandas integrates with this external package. if ``pandas-gbq`` is installed, you can
use the pandas methods ``pd.read_gbq`` and ``DataFrame.to_gbq``, which will call the
respective functions from ``pandas-gbq``.

Full documentation can be found [here](https://pandas-gbq.readthedocs.io/).

## Stata format

### Writing to stata format

The method ``to_stata()`` will write a DataFrame
into a .dta file. The format version of this file is always 115 (Stata 12).

``` python
In [549]: df = pd.DataFrame(np.random.randn(10, 2), columns=list('AB'))

In [550]: df.to_stata('stata.dta')

```

Stata data files have limited data type support; only strings with
244 or fewer characters, ``int8``, ``int16``, ``int32``, ``float32``
and ``float64`` can be stored in ``.dta`` files.  Additionally,
Stata reserves certain values to represent missing data. Exporting a
non-missing value that is outside of the permitted range in Stata for
a particular data type will retype the variable to the next larger
size.  For example, ``int8`` values are restricted to lie between -127
and 100 in Stata, and so variables with values above 100 will trigger
a conversion to ``int16``. ``nan`` values in floating points data
types are stored as the basic missing data type (``.`` in Stata).

::: tip Note

It is not possible to export missing data values for integer data types.

:::

The Stata writer gracefully handles other data types including ``int64``,
``bool``, ``uint8``, ``uint16``, ``uint32`` by casting to
the smallest supported type that can represent the data.  For example, data
with a type of ``uint8`` will be cast to ``int8`` if all values are less than
100 (the upper bound for non-missing ``int8`` data in Stata), or, if values are
outside of this range, the variable is cast to ``int16``.

::: danger Warning

Conversion from ``int64`` to ``float64`` may result in a loss of precision
if ``int64`` values are larger than 2**53.

:::

::: danger Warning

``StataWriter`` and
``to_stata()`` only support fixed width
strings containing up to 244 characters, a limitation imposed by the version
115 dta file format. Attempting to write Stata dta files with strings
longer than 244 characters raises a ``ValueError``.

:::

### Reading from Stata format

The top-level function ``read_stata`` will read a dta file and return
either a ``DataFrame`` or a ``StataReader`` that can
be used to read the file incrementally.

``` python
In [551]: pd.read_stata('stata.dta')
Out[551]: 
   index         A         B
0      0  1.031231  0.196447
1      1  0.190188  0.619078
2      2  0.036658 -0.100501
3      3  0.201772  1.763002
4      4  0.454977 -1.958922
5      5 -0.628529  0.133171
6      6 -1.274374  2.518925
7      7 -0.517547 -0.360773
8      8  0.877961 -1.881598
9      9 -0.699067 -1.566913

```

Specifying a ``chunksize`` yields a
``StataReader`` instance that can be used to
read ``chunksize`` lines from the file at a time.  The ``StataReader``
object can be used as an iterator.

``` python
In [552]: reader = pd.read_stata('stata.dta', chunksize=3)

In [553]: for df in reader:
   .....:     print(df.shape)
   .....: 
(3, 3)
(3, 3)
(3, 3)
(1, 3)

```

For more fine-grained control, use ``iterator=True`` and specify
``chunksize`` with each call to
``read()``.

``` python
In [554]: reader = pd.read_stata('stata.dta', iterator=True)

In [555]: chunk1 = reader.read(5)

In [556]: chunk2 = reader.read(5)

```

Currently the ``index`` is retrieved as a column.

The parameter ``convert_categoricals`` indicates whether value labels should be
read and used to create a ``Categorical`` variable from them. Value labels can
also be retrieved by the function ``value_labels``, which requires ``read()``
to be called before use.

The parameter ``convert_missing`` indicates whether missing value
representations in Stata should be preserved.  If ``False`` (the default),
missing values are represented as ``np.nan``.  If ``True``, missing values are
represented using ``StataMissingValue`` objects, and columns containing missing
values will have ``object`` data type.

::: tip Note

[``read_stata()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_stata.html#pandas.read_stata) and
``StataReader`` support .dta formats 113-115
(Stata 10-12), 117 (Stata 13), and 118 (Stata 14).

:::

::: tip Note

Setting ``preserve_dtypes=False`` will upcast to the standard pandas data types:
``int64`` for all integer types and ``float64`` for floating point data.  By default,
the Stata data types are preserved when importing.

:::

#### Categorical data

``Categorical`` data can be exported to Stata data files as value labeled data.
The exported data consists of the underlying category codes as integer data values
and the categories as value labels.  Stata does not have an explicit equivalent
to a ``Categorical`` and information about whether the variable is ordered
is lost when exporting.

::: danger Warning

Stata only supports string value labels, and so ``str`` is called on the
categories when exporting data.  Exporting ``Categorical`` variables with
non-string categories produces a warning, and can result a loss of
information if the ``str`` representations of the categories are not unique.

:::

Labeled data can similarly be imported from Stata data files as ``Categorical``
variables using the keyword argument ``convert_categoricals`` (``True`` by default).
The keyword argument ``order_categoricals`` (``True`` by default) determines
whether imported ``Categorical`` variables are ordered.

::: tip Note

When importing categorical data, the values of the variables in the Stata
data file are not preserved since ``Categorical`` variables always
use integer data types between ``-1`` and ``n-1`` where ``n`` is the number
of categories. If the original values in the Stata data file are required,
these can be imported by setting ``convert_categoricals=False``, which will
import original data (but not the variable labels). The original values can
be matched to the imported categorical data since there is a simple mapping
between the original Stata data values and the category codes of imported
Categorical variables: missing values are assigned code ``-1``, and the
smallest original value is assigned ``0``, the second smallest is assigned
``1`` and so on until the largest original value is assigned the code ``n-1``.

:::

::: tip Note

Stata supports partially labeled series. These series have value labels for
some but not all data values. Importing a partially labeled series will produce
a ``Categorical`` with string categories for the values that are labeled and
numeric categories for values with no label.

:::

## SAS formats

The top-level function [``read_sas()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sas.html#pandas.read_sas) can read (but not write) SAS
*xport* (.XPT) and (since v0.18.0) *SAS7BDAT* (.sas7bdat) format files.

SAS files only contain two value types: ASCII text and floating point
values (usually 8 bytes but sometimes truncated).  For xport files,
there is no automatic type conversion to integers, dates, or
categoricals.  For SAS7BDAT files, the format codes may allow date
variables to be automatically converted to dates.  By default the
whole file is read and returned as a ``DataFrame``.

Specify a ``chunksize`` or use ``iterator=True`` to obtain reader
objects (``XportReader`` or ``SAS7BDATReader``) for incrementally
reading the file.  The reader objects also have attributes that
contain additional information about the file and its variables.

Read a SAS7BDAT file:

``` python
df = pd.read_sas('sas_data.sas7bdat')

```

Obtain an iterator and read an XPORT file 100,000 lines at a time:

``` python
def do_something(chunk):
    pass

rdr = pd.read_sas('sas_xport.xpt', chunk=100000)
for chunk in rdr:
    do_something(chunk)

```

The [specification](https://support.sas.com/techsup/technote/ts140.pdf) for the xport file format is available from the SAS
web site.

No official documentation is available for the SAS7BDAT format.

## Other file formats

pandas itself only supports IO with a limited set of file formats that map
cleanly to its tabular data model. For reading and writing other file formats
into and from pandas, we recommend these packages from the broader community.

### netCDF

[xarray](https://xarray.pydata.org/) provides data structures inspired by the pandas ``DataFrame`` for working
with multi-dimensional datasets, with a focus on the netCDF file format and
easy conversion to and from pandas.

## Performance considerations

This is an informal comparison of various IO methods, using pandas
0.20.3. Timings are machine dependent and small differences should be
ignored.

``` python
In [1]: sz = 1000000
In [2]: df = pd.DataFrame({'A': np.random.randn(sz), 'B': [1] * sz})

In [3]: df.info()
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 1000000 entries, 0 to 999999
Data columns (total 2 columns):
A    1000000 non-null float64
B    1000000 non-null int64
dtypes: float64(1), int64(1)
memory usage: 15.3 MB

```

Given the next test set:

``` python
from numpy.random import randn

sz = 1000000
df = pd.DataFrame({'A': randn(sz), 'B': [1] * sz})


def test_sql_write(df):
    if os.path.exists('test.sql'):
        os.remove('test.sql')
    sql_db = sqlite3.connect('test.sql')
    df.to_sql(name='test_table', con=sql_db)
    sql_db.close()


def test_sql_read():
    sql_db = sqlite3.connect('test.sql')
    pd.read_sql_query("select * from test_table", sql_db)
    sql_db.close()


def test_hdf_fixed_write(df):
    df.to_hdf('test_fixed.hdf', 'test', mode='w')


def test_hdf_fixed_read():
    pd.read_hdf('test_fixed.hdf', 'test')


def test_hdf_fixed_write_compress(df):
    df.to_hdf('test_fixed_compress.hdf', 'test', mode='w', complib='blosc')


def test_hdf_fixed_read_compress():
    pd.read_hdf('test_fixed_compress.hdf', 'test')


def test_hdf_table_write(df):
    df.to_hdf('test_table.hdf', 'test', mode='w', format='table')


def test_hdf_table_read():
    pd.read_hdf('test_table.hdf', 'test')


def test_hdf_table_write_compress(df):
    df.to_hdf('test_table_compress.hdf', 'test', mode='w',
              complib='blosc', format='table')


def test_hdf_table_read_compress():
    pd.read_hdf('test_table_compress.hdf', 'test')


def test_csv_write(df):
    df.to_csv('test.csv', mode='w')


def test_csv_read():
    pd.read_csv('test.csv', index_col=0)


def test_feather_write(df):
    df.to_feather('test.feather')


def test_feather_read():
    pd.read_feather('test.feather')


def test_pickle_write(df):
    df.to_pickle('test.pkl')


def test_pickle_read():
    pd.read_pickle('test.pkl')


def test_pickle_write_compress(df):
    df.to_pickle('test.pkl.compress', compression='xz')


def test_pickle_read_compress():
    pd.read_pickle('test.pkl.compress', compression='xz')

```

When writing, the top-three functions in terms of speed are are
``test_pickle_write``, ``test_feather_write`` and ``test_hdf_fixed_write_compress``.

``` python
In [14]: %timeit test_sql_write(df)
2.37 s ± 36.6 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)

In [15]: %timeit test_hdf_fixed_write(df)
194 ms ± 65.9 ms per loop (mean ± std. dev. of 7 runs, 10 loops each)

In [26]: %timeit test_hdf_fixed_write_compress(df)
119 ms ± 2.15 ms per loop (mean ± std. dev. of 7 runs, 10 loops each)

In [16]: %timeit test_hdf_table_write(df)
623 ms ± 125 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)

In [27]: %timeit test_hdf_table_write_compress(df)
563 ms ± 23.7 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)

In [17]: %timeit test_csv_write(df)
3.13 s ± 49.9 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)

In [30]: %timeit test_feather_write(df)
103 ms ± 5.88 ms per loop (mean ± std. dev. of 7 runs, 10 loops each)

In [31]: %timeit test_pickle_write(df)
109 ms ± 3.72 ms per loop (mean ± std. dev. of 7 runs, 10 loops each)

In [32]: %timeit test_pickle_write_compress(df)
3.33 s ± 55.2 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)

```

When reading, the top three are ``test_feather_read``, ``test_pickle_read`` and
``test_hdf_fixed_read``.

``` python
In [18]: %timeit test_sql_read()
1.35 s ± 14.7 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)

In [19]: %timeit test_hdf_fixed_read()
14.3 ms ± 438 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)

In [28]: %timeit test_hdf_fixed_read_compress()
23.5 ms ± 672 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)

In [20]: %timeit test_hdf_table_read()
35.4 ms ± 314 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)

In [29]: %timeit test_hdf_table_read_compress()
42.6 ms ± 2.1 ms per loop (mean ± std. dev. of 7 runs, 10 loops each)

In [22]: %timeit test_csv_read()
516 ms ± 27.1 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)

In [33]: %timeit test_feather_read()
4.06 ms ± 115 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)

In [34]: %timeit test_pickle_read()
6.5 ms ± 172 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)

In [35]: %timeit test_pickle_read_compress()
588 ms ± 3.57 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)

```

Space on disk (in bytes)

``` 
34816000 Aug 21 18:00 test.sql
24009240 Aug 21 18:00 test_fixed.hdf
 7919610 Aug 21 18:00 test_fixed_compress.hdf
24458892 Aug 21 18:00 test_table.hdf
 8657116 Aug 21 18:00 test_table_compress.hdf
28520770 Aug 21 18:00 test.csv
16000248 Aug 21 18:00 test.feather
16000848 Aug 21 18:00 test.pkl
 7554108 Aug 21 18:00 test.pkl.compress

```
