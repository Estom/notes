# Options and settings

## Overview

pandas has an options system that lets you customize some aspects of its behaviour,
display-related options being those the user is most likely to adjust.

Options have a full “dotted-style”, case-insensitive name (e.g. ``display.max_rows``).
You can get/set options directly as attributes of the top-level ``options`` attribute:

``` python
In [1]: import pandas as pd

In [2]: pd.options.display.max_rows
Out[2]: 15

In [3]: pd.options.display.max_rows = 999

In [4]: pd.options.display.max_rows
Out[4]: 999
```

The API is composed of 5 relevant functions, available directly from the ``pandas``
namespace:

- [``get_option()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.get_option.html#pandas.get_option) / [``set_option()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.set_option.html#pandas.set_option) - get/set the value of a single option.
- [``reset_option()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.reset_option.html#pandas.reset_option) - reset one or more options to their default value.
- [``describe_option()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.describe_option.html#pandas.describe_option) - print the descriptions of one or more options.
- [``option_context()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.option_context.html#pandas.option_context) - execute a codeblock with a set of options
that revert to prior settings after execution.

**Note:** Developers can check out [pandas/core/config.py](https://github.com/pandas-dev/pandas/blob/master/pandas/core/config.py) for more information.

All of the functions above accept a regexp pattern (``re.search`` style) as an argument,
and so passing in a substring will work - as long as it is unambiguous:

``` python
In [5]: pd.get_option("display.max_rows")
Out[5]: 999

In [6]: pd.set_option("display.max_rows", 101)

In [7]: pd.get_option("display.max_rows")
Out[7]: 101

In [8]: pd.set_option("max_r", 102)

In [9]: pd.get_option("display.max_rows")
Out[9]: 102
```

The following will **not work** because it matches multiple option names, e.g.
``display.max_colwidth``, ``display.max_rows``, ``display.max_columns``:

``` python
In [10]: try:
   ....:     pd.get_option("column")
   ....: except KeyError as e:
   ....:     print(e)
   ....: 
'Pattern matched multiple keys'
```

**Note:** Using this form of shorthand may cause your code to break if new options with similar names are added in future versions.

You can get a list of available options and their descriptions with ``describe_option``. When called
with no argument ``describe_option`` will print out the descriptions for all available options.

## Getting and setting options

As described above, [``get_option()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.get_option.html#pandas.get_option) and [``set_option()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.set_option.html#pandas.set_option)
are available from the pandas namespace.  To change an option, call
``set_option('option regex', new_value)``.

``` python
In [11]: pd.get_option('mode.sim_interactive')
Out[11]: False

In [12]: pd.set_option('mode.sim_interactive', True)

In [13]: pd.get_option('mode.sim_interactive')
Out[13]: True
```

**Note:** The option ‘mode.sim_interactive’ is mostly used for debugging purposes.

All options also have a default value, and you can use ``reset_option`` to do just that:

``` python
In [14]: pd.get_option("display.max_rows")
Out[14]: 60

In [15]: pd.set_option("display.max_rows", 999)

In [16]: pd.get_option("display.max_rows")
Out[16]: 999

In [17]: pd.reset_option("display.max_rows")

In [18]: pd.get_option("display.max_rows")
Out[18]: 60
```

It’s also possible to reset multiple options at once (using a regex):

``` python
In [19]: pd.reset_option("^display")
```

``option_context`` context manager has been exposed through
the top-level API, allowing you to execute code with given option values. Option values
are restored automatically when you exit the *with* block:

``` python
In [20]: with pd.option_context("display.max_rows", 10, "display.max_columns", 5):
   ....:     print(pd.get_option("display.max_rows"))
   ....:     print(pd.get_option("display.max_columns"))
   ....: 
10
5

In [21]: print(pd.get_option("display.max_rows"))
60

In [22]: print(pd.get_option("display.max_columns"))
0
```

## Setting startup options in Python/IPython environment

Using startup scripts for the Python/IPython environment to import pandas and set options makes working with pandas more efficient.  To do this, create a .py or .ipy script in the startup directory of the desired profile.  An example where the startup folder is in a default ipython profile can be found at:

``` 
$IPYTHONDIR/profile_default/startup
```

More information can be found in the [ipython documentation](https://ipython.org/ipython-doc/stable/interactive/tutorial.html#startup-files).  An example startup script for pandas is displayed below:

``` python
import pandas as pd
pd.set_option('display.max_rows', 999)
pd.set_option('precision', 5)
```

## Frequently Used Options

The following is a walk-through of the more frequently used display options.

``display.max_rows`` and ``display.max_columns`` sets the maximum number
of rows and columns displayed when a frame is pretty-printed.  Truncated
lines are replaced by an ellipsis.

``` python
In [23]: df = pd.DataFrame(np.random.randn(7, 2))

In [24]: pd.set_option('max_rows', 7)

In [25]: df
Out[25]: 
          0         1
0  0.469112 -0.282863
1 -1.509059 -1.135632
2  1.212112 -0.173215
3  0.119209 -1.044236
4 -0.861849 -2.104569
5 -0.494929  1.071804
6  0.721555 -0.706771

In [26]: pd.set_option('max_rows', 5)

In [27]: df
Out[27]: 
           0         1
0   0.469112 -0.282863
1  -1.509059 -1.135632
..       ...       ...
5  -0.494929  1.071804
6   0.721555 -0.706771

[7 rows x 2 columns]

In [28]: pd.reset_option('max_rows')
```

Once the ``display.max_rows`` is exceeded, the ``display.min_rows`` options
determines how many rows are shown in the truncated repr.

``` python
In [29]: pd.set_option('max_rows', 8)

In [30]: pd.set_option('max_rows', 4)

# below max_rows -> all rows shown
In [31]: df = pd.DataFrame(np.random.randn(7, 2))

In [32]: df
Out[32]: 
           0         1
0  -1.039575  0.271860
1  -0.424972  0.567020
..       ...       ...
5   0.404705  0.577046
6  -1.715002 -1.039268

[7 rows x 2 columns]

# above max_rows -> only min_rows (4) rows shown
In [33]: df = pd.DataFrame(np.random.randn(9, 2))

In [34]: df
Out[34]: 
           0         1
0  -0.370647 -1.157892
1  -1.344312  0.844885
..       ...       ...
7   0.276662 -0.472035
8  -0.013960 -0.362543

[9 rows x 2 columns]

In [35]: pd.reset_option('max_rows')

In [36]: pd.reset_option('min_rows')
```

``display.expand_frame_repr`` allows for the representation of
dataframes to stretch across pages, wrapped over the full column vs row-wise.

``` python
In [37]: df = pd.DataFrame(np.random.randn(5, 10))

In [38]: pd.set_option('expand_frame_repr', True)

In [39]: df
Out[39]: 
          0         1         2         3         4         5         6         7         8         9
0 -0.006154 -0.923061  0.895717  0.805244 -1.206412  2.565646  1.431256  1.340309 -1.170299 -0.226169
1  0.410835  0.813850  0.132003 -0.827317 -0.076467 -1.187678  1.130127 -1.436737 -1.413681  1.607920
2  1.024180  0.569605  0.875906 -2.211372  0.974466 -2.006747 -0.410001 -0.078638  0.545952 -1.219217
3 -1.226825  0.769804 -1.281247 -0.727707 -0.121306 -0.097883  0.695775  0.341734  0.959726 -1.110336
4 -0.619976  0.149748 -0.732339  0.687738  0.176444  0.403310 -0.154951  0.301624 -2.179861 -1.369849

In [40]: pd.set_option('expand_frame_repr', False)

In [41]: df
Out[41]: 
          0         1         2         3         4         5         6         7         8         9
0 -0.006154 -0.923061  0.895717  0.805244 -1.206412  2.565646  1.431256  1.340309 -1.170299 -0.226169
1  0.410835  0.813850  0.132003 -0.827317 -0.076467 -1.187678  1.130127 -1.436737 -1.413681  1.607920
2  1.024180  0.569605  0.875906 -2.211372  0.974466 -2.006747 -0.410001 -0.078638  0.545952 -1.219217
3 -1.226825  0.769804 -1.281247 -0.727707 -0.121306 -0.097883  0.695775  0.341734  0.959726 -1.110336
4 -0.619976  0.149748 -0.732339  0.687738  0.176444  0.403310 -0.154951  0.301624 -2.179861 -1.369849

In [42]: pd.reset_option('expand_frame_repr')
```

``display.large_repr`` lets you select whether to display dataframes that exceed
``max_columns`` or ``max_rows`` as a truncated frame, or as a summary.

``` python
In [43]: df = pd.DataFrame(np.random.randn(10, 10))

In [44]: pd.set_option('max_rows', 5)

In [45]: pd.set_option('large_repr', 'truncate')

In [46]: df
Out[46]: 
           0         1         2         3         4         5         6         7         8         9
0  -0.954208  1.462696 -1.743161 -0.826591 -0.345352  1.314232  0.690579  0.995761  2.396780  0.014871
1   3.357427 -0.317441 -1.236269  0.896171 -0.487602 -0.082240 -2.182937  0.380396  0.084844  0.432390
..       ...       ...       ...       ...       ...       ...       ...       ...       ...       ...
8  -0.303421 -0.858447  0.306996 -0.028665  0.384316  1.574159  1.588931  0.476720  0.473424 -0.242861
9  -0.014805 -0.284319  0.650776 -1.461665 -1.137707 -0.891060 -0.693921  1.613616  0.464000  0.227371

[10 rows x 10 columns]

In [47]: pd.set_option('large_repr', 'info')

In [48]: df
Out[48]: 
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 10 entries, 0 to 9
Data columns (total 10 columns):
0    10 non-null float64
1    10 non-null float64
2    10 non-null float64
3    10 non-null float64
4    10 non-null float64
5    10 non-null float64
6    10 non-null float64
7    10 non-null float64
8    10 non-null float64
9    10 non-null float64
dtypes: float64(10)
memory usage: 928.0 bytes

In [49]: pd.reset_option('large_repr')

In [50]: pd.reset_option('max_rows')
```

``display.max_colwidth`` sets the maximum width of columns.  Cells
of this length or longer will be truncated with an ellipsis.

``` python
In [51]: df = pd.DataFrame(np.array([['foo', 'bar', 'bim', 'uncomfortably long string'],
   ....:                             ['horse', 'cow', 'banana', 'apple']]))
   ....: 

In [52]: pd.set_option('max_colwidth', 40)

In [53]: df
Out[53]: 
       0    1       2                          3
0    foo  bar     bim  uncomfortably long string
1  horse  cow  banana                      apple

In [54]: pd.set_option('max_colwidth', 6)

In [55]: df
Out[55]: 
       0    1      2      3
0    foo  bar    bim  un...
1  horse  cow  ba...  apple

In [56]: pd.reset_option('max_colwidth')
```

``display.max_info_columns`` sets a threshold for when by-column info
will be given.

``` python
In [57]: df = pd.DataFrame(np.random.randn(10, 10))

In [58]: pd.set_option('max_info_columns', 11)

In [59]: df.info()
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 10 entries, 0 to 9
Data columns (total 10 columns):
0    10 non-null float64
1    10 non-null float64
2    10 non-null float64
3    10 non-null float64
4    10 non-null float64
5    10 non-null float64
6    10 non-null float64
7    10 non-null float64
8    10 non-null float64
9    10 non-null float64
dtypes: float64(10)
memory usage: 928.0 bytes

In [60]: pd.set_option('max_info_columns', 5)

In [61]: df.info()
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 10 entries, 0 to 9
Columns: 10 entries, 0 to 9
dtypes: float64(10)
memory usage: 928.0 bytes

In [62]: pd.reset_option('max_info_columns')
```

``display.max_info_rows``: ``df.info()`` will usually show null-counts for each column.
For large frames this can be quite slow. ``max_info_rows`` and ``max_info_cols``
limit this null check only to frames with smaller dimensions then specified. Note that you
can specify the option ``df.info(null_counts=True)`` to override on showing a particular frame.

``` python
In [63]: df = pd.DataFrame(np.random.choice([0, 1, np.nan], size=(10, 10)))

In [64]: df
Out[64]: 
     0    1    2    3    4    5    6    7    8    9
0  0.0  NaN  1.0  NaN  NaN  0.0  NaN  0.0  NaN  1.0
1  1.0  NaN  1.0  1.0  1.0  1.0  NaN  0.0  0.0  NaN
2  0.0  NaN  1.0  0.0  0.0  NaN  NaN  NaN  NaN  0.0
3  NaN  NaN  NaN  0.0  1.0  1.0  NaN  1.0  NaN  1.0
4  0.0  NaN  NaN  NaN  0.0  NaN  NaN  NaN  1.0  0.0
5  0.0  1.0  1.0  1.0  1.0  0.0  NaN  NaN  1.0  0.0
6  1.0  1.0  1.0  NaN  1.0  NaN  1.0  0.0  NaN  NaN
7  0.0  0.0  1.0  0.0  1.0  0.0  1.0  1.0  0.0  NaN
8  NaN  NaN  NaN  0.0  NaN  NaN  NaN  NaN  1.0  NaN
9  0.0  NaN  0.0  NaN  NaN  0.0  NaN  1.0  1.0  0.0

In [65]: pd.set_option('max_info_rows', 11)

In [66]: df.info()
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 10 entries, 0 to 9
Data columns (total 10 columns):
0    8 non-null float64
1    3 non-null float64
2    7 non-null float64
3    6 non-null float64
4    7 non-null float64
5    6 non-null float64
6    2 non-null float64
7    6 non-null float64
8    6 non-null float64
9    6 non-null float64
dtypes: float64(10)
memory usage: 928.0 bytes

In [67]: pd.set_option('max_info_rows', 5)

In [68]: df.info()
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 10 entries, 0 to 9
Data columns (total 10 columns):
0    float64
1    float64
2    float64
3    float64
4    float64
5    float64
6    float64
7    float64
8    float64
9    float64
dtypes: float64(10)
memory usage: 928.0 bytes

In [69]: pd.reset_option('max_info_rows')
```

``display.precision`` sets the output display precision in terms of decimal places.
This is only a suggestion.

``` python
In [70]: df = pd.DataFrame(np.random.randn(5, 5))

In [71]: pd.set_option('precision', 7)

In [72]: df
Out[72]: 
           0          1          2          3          4
0 -1.1506406 -0.7983341 -0.5576966  0.3813531  1.3371217
1 -1.5310949  1.3314582 -0.5713290 -0.0266708 -1.0856630
2 -1.1147378 -0.0582158 -0.4867681  1.6851483  0.1125723
3 -1.4953086  0.8984347 -0.1482168 -1.5960698  0.1596530
4  0.2621358  0.0362196  0.1847350 -0.2550694 -0.2710197

In [73]: pd.set_option('precision', 4)

In [74]: df
Out[74]: 
        0       1       2       3       4
0 -1.1506 -0.7983 -0.5577  0.3814  1.3371
1 -1.5311  1.3315 -0.5713 -0.0267 -1.0857
2 -1.1147 -0.0582 -0.4868  1.6851  0.1126
3 -1.4953  0.8984 -0.1482 -1.5961  0.1597
4  0.2621  0.0362  0.1847 -0.2551 -0.2710
```

``display.chop_threshold`` sets at what level pandas rounds to zero when
it displays a Series of DataFrame. This setting does not change the
precision at which the number is stored.

``` python
In [75]: df = pd.DataFrame(np.random.randn(6, 6))

In [76]: pd.set_option('chop_threshold', 0)

In [77]: df
Out[77]: 
        0       1       2       3       4       5
0  1.2884  0.2946 -1.1658  0.8470 -0.6856  0.6091
1 -0.3040  0.6256 -0.0593  0.2497  1.1039 -1.0875
2  1.9980 -0.2445  0.1362  0.8863 -1.3507 -0.8863
3 -1.0133  1.9209 -0.3882 -2.3144  0.6655  0.4026
4  0.3996 -1.7660  0.8504  0.3881  0.9923  0.7441
5 -0.7398 -1.0549 -0.1796  0.6396  1.5850  1.9067

In [78]: pd.set_option('chop_threshold', .5)

In [79]: df
Out[79]: 
        0       1       2       3       4       5
0  1.2884  0.0000 -1.1658  0.8470 -0.6856  0.6091
1  0.0000  0.6256  0.0000  0.0000  1.1039 -1.0875
2  1.9980  0.0000  0.0000  0.8863 -1.3507 -0.8863
3 -1.0133  1.9209  0.0000 -2.3144  0.6655  0.0000
4  0.0000 -1.7660  0.8504  0.0000  0.9923  0.7441
5 -0.7398 -1.0549  0.0000  0.6396  1.5850  1.9067

In [80]: pd.reset_option('chop_threshold')
```

``display.colheader_justify`` controls the justification of the headers.
The options are ‘right’, and ‘left’.

``` python
In [81]: df = pd.DataFrame(np.array([np.random.randn(6),
   ....:                             np.random.randint(1, 9, 6) * .1,
   ....:                             np.zeros(6)]).T,
   ....:                   columns=['A', 'B', 'C'], dtype='float')
   ....: 

In [82]: pd.set_option('colheader_justify', 'right')

In [83]: df
Out[83]: 
        A    B    C
0  0.1040  0.1  0.0
1  0.1741  0.5  0.0
2 -0.4395  0.4  0.0
3 -0.7413  0.8  0.0
4 -0.0797  0.4  0.0
5 -0.9229  0.3  0.0

In [84]: pd.set_option('colheader_justify', 'left')

In [85]: df
Out[85]: 
   A       B    C  
0  0.1040  0.1  0.0
1  0.1741  0.5  0.0
2 -0.4395  0.4  0.0
3 -0.7413  0.8  0.0
4 -0.0797  0.4  0.0
5 -0.9229  0.3  0.0

In [86]: pd.reset_option('colheader_justify')
```

## Available options

Option | Default | Function
---|---|---
display.chop_threshold | None | If set to a float value, all float values smaller then the given threshold will be displayed as exactly 0 by repr and friends.
display.colheader_justify | right | Controls the justification of column headers. used by DataFrameFormatter.
display.column_space | 12 | No description available.
display.date_dayfirst | False | When True, prints and parses dates with the day first, eg 20/01/2005
display.date_yearfirst | False | When True, prints and parses dates with the year first, eg 2005/01/20
display.encoding | UTF-8 | Defaults to the detected encoding of the console. Specifies the encoding to be used for strings returned by to_string, these are generally strings meant to be displayed on the console.
display.expand_frame_repr | True | Whether to print out the full DataFrame repr for wide DataFrames across multiple lines, max_columns is still respected, but the output will wrap-around across multiple “pages” if its width exceeds display.width.
display.float_format | None | The callable should accept a floating point number and return a string with the desired format of the number. This is used in some places like SeriesFormatter. See core.format.EngFormatter for an example.
display.large_repr | truncate | For DataFrames exceeding max_rows/max_cols, the repr (and HTML repr) can show a truncated table (the default), or switch to the view from df.info() (the behaviour in earlier versions of pandas). allowable settings, [‘truncate’, ‘info’]
display.latex.repr | False | Whether to produce a latex DataFrame representation for jupyter frontends that support it.
display.latex.escape | True | Escapes special characters in DataFrames, when using the to_latex method.
display.latex.longtable | False | Specifies if the to_latex method of a DataFrame uses the longtable format.
display.latex.multicolumn | True | Combines columns when using a MultiIndex
display.latex.multicolumn_format | ‘l’ | Alignment of multicolumn labels
display.latex.multirow | False | Combines rows when using a MultiIndex. Centered instead of top-aligned, separated by clines.
display.max_columns | 0 or 20 | max_rows and max_columns are used in __repr__() methods to decide if to_string() or info() is used to render an object to a string. In case Python/IPython is running in a terminal this is set to 0 by default and pandas will correctly auto-detect the width of the terminal and switch to a smaller format in case all columns would not fit vertically. The IPython notebook, IPython qtconsole, or IDLE do not run in a terminal and hence it is not possible to do correct auto-detection, in which case the default is set to 20. ‘None’ value means unlimited.
display.max_colwidth | 50 | The maximum width in characters of a column in the repr of a pandas data structure. When the column overflows, a “…” placeholder is embedded in the output.
display.max_info_columns | 100 | max_info_columns is used in DataFrame.info method to decide if per column information will be printed.
display.max_info_rows | 1690785 | df.info() will usually show null-counts for each column. For large frames this can be quite slow. max_info_rows and max_info_cols limit this null check only to frames with smaller dimensions then specified.
display.max_rows | 60 | This sets the maximum number of rows pandas should output when printing out various output. For example, this value determines whether the repr() for a dataframe prints out fully or just a truncated or summary repr. ‘None’ value means unlimited.
display.min_rows | 10 | The numbers of rows to show in a truncated repr (when max_rows is exceeded). Ignored when max_rows is set to None or 0. When set to None, follows the value of max_rows.
display.max_seq_items | 100 | when pretty-printing a long sequence, no more then max_seq_items will be printed. If items are omitted, they will be denoted by the addition of “…” to the resulting string. If set to None, the number of items to be printed is unlimited.
display.memory_usage | True | This specifies if the memory usage of a DataFrame should be displayed when the df.info() method is invoked.
display.multi_sparse | True | “Sparsify” MultiIndex display (don’t display repeated elements in outer levels within groups)
display.notebook_repr_html | True | When True, IPython notebook will use html representation for pandas objects (if it is available).
display.pprint_nest_depth | 3 | Controls the number of nested levels to process when pretty-printing
display.precision | 6 | Floating point output precision in terms of number of places after the decimal, for regular formatting as well as scientific notation. Similar to numpy’s precision print option
display.show_dimensions | truncate | Whether to print out dimensions at the end of DataFrame repr. If ‘truncate’ is specified, only print out the dimensions if the frame is truncated (e.g. not display all rows and/or columns)
display.width | 80 | Width of the display in characters. In case python/IPython is running in a terminal this can be set to None and pandas will correctly auto-detect the width. Note that the IPython notebook, IPython qtconsole, or IDLE do not run in a terminal and hence it is not possible to correctly detect the width.
display.html.table_schema | False | Whether to publish a Table Schema representation for frontends that support it.
display.html.border | 1 | A border=value attribute is inserted in the ``<table>`` tag for the DataFrame HTML repr.
display.html.use_mathjax | True | When True, Jupyter notebook will process table contents using MathJax, rendering mathematical expressions enclosed by the dollar symbol.
io.excel.xls.writer | xlwt | The default Excel writer engine for ‘xls’ files.
io.excel.xlsm.writer | openpyxl | The default Excel writer engine for ‘xlsm’ files. Available options: ‘openpyxl’ (the default).
io.excel.xlsx.writer | openpyxl | The default Excel writer engine for ‘xlsx’ files.
io.hdf.default_format | None | default format writing format, if None, then put will default to ‘fixed’ and append will default to ‘table’
io.hdf.dropna_table | True | drop ALL nan rows when appending to a table
io.parquet.engine | None | The engine to use as a default for parquet reading and writing. If None then try ‘pyarrow’ and ‘fastparquet’
mode.chained_assignment | warn | Controls SettingWithCopyWarning: ‘raise’, ‘warn’, or None. Raise an exception, warn, or no action if trying to use [chained assignment](indexing.html#indexing-evaluation-order).
mode.sim_interactive | False | Whether to simulate interactive mode for purposes of testing.
mode.use_inf_as_na | False | True means treat None, NaN, -INF, INF as NA (old way), False means None and NaN are null, but INF, -INF are not NA (new way).
compute.use_bottleneck | True | Use the bottleneck library to accelerate computation if it is installed.
compute.use_numexpr | True | Use the numexpr library to accelerate computation if it is installed.
plotting.backend | matplotlib | Change the plotting backend to a different backend than the current matplotlib one. Backends can be implemented as third-party libraries implementing the pandas plotting API. They can use other plotting libraries like Bokeh, Altair, etc.
plotting.matplotlib.register_converters | True | Register custom converters with matplotlib. Set to False to de-register.

## Number formatting

pandas also allows you to set how numbers are displayed in the console.
This option is not set through the ``set_options`` API.

Use the ``set_eng_float_format`` function
to alter the floating-point formatting of pandas objects to produce a particular
format.

For instance:

``` python
In [87]: import numpy as np

In [88]: pd.set_eng_float_format(accuracy=3, use_eng_prefix=True)

In [89]: s = pd.Series(np.random.randn(5), index=['a', 'b', 'c', 'd', 'e'])

In [90]: s / 1.e3
Out[90]: 
a    303.638u
b   -721.084u
c   -622.696u
d    648.250u
e     -1.945m
dtype: float64

In [91]: s / 1.e6
Out[91]: 
a    303.638n
b   -721.084n
c   -622.696n
d    648.250n
e     -1.945u
dtype: float64
```

To round floats on a case-by-case basis, you can also use [``round()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.round.html#pandas.Series.round) and [``round()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.round.html#pandas.DataFrame.round).

## Unicode formatting

::: danger Warning

Enabling this option will affect the performance for printing of DataFrame and Series (about 2 times slower).
Use only when it is actually required.

:::

Some East Asian countries use Unicode characters whose width corresponds to two Latin characters.
If a DataFrame or Series contains these characters, the default output mode may not align them properly.

::: tip Note

Screen captures are attached for each output to show the actual results.

:::

``` python
In [92]: df = pd.DataFrame({'国籍': ['UK', '日本'], '名前': ['Alice', 'しのぶ']})

In [93]: df
Out[93]: 
   国籍     名前
0  UK  Alice
1  日本    しのぶ
```

![option_unicode01](https://static.pypandas.cn/public/static/images/option_unicode01.png)

Enabling ``display.unicode.east_asian_width`` allows pandas to check each character’s “East Asian Width” property.
These characters can be aligned properly by setting this option to ``True``. However, this will result in longer render
times than the standard ``len`` function.

``` python
In [94]: pd.set_option('display.unicode.east_asian_width', True)

In [95]: df
Out[95]: 
   国籍    名前
0    UK   Alice
1  日本  しのぶ
```

![option_unicode02](https://static.pypandas.cn/public/static/images/option_unicode02.png)

In addition, Unicode characters whose width is “Ambiguous” can either be 1 or 2 characters wide depending on the
terminal setting or encoding. The option ``display.unicode.ambiguous_as_wide`` can be used to handle the ambiguity.

By default, an “Ambiguous” character’s width, such as “¡” (inverted exclamation) in the example below, is taken to be 1.

``` python
In [96]: df = pd.DataFrame({'a': ['xxx', '¡¡'], 'b': ['yyy', '¡¡']})

In [97]: df
Out[97]: 
     a    b
0  xxx  yyy
1   ¡¡   ¡¡
```

![option_unicode03](https://static.pypandas.cn/public/static/images/option_unicode03.png)

Enabling ``display.unicode.ambiguous_as_wide`` makes pandas interpret these characters’ widths to be 2.
(Note that this option will only be effective when ``display.unicode.east_asian_width`` is enabled.)

However, setting this option incorrectly for your terminal will cause these characters to be aligned incorrectly:

``` python
In [98]: pd.set_option('display.unicode.ambiguous_as_wide', True)

In [99]: df
Out[99]: 
      a     b
0   xxx   yyy
1  ¡¡  ¡¡
```

![option_unicode04](https://static.pypandas.cn/public/static/images/option_unicode04.png)

## Table schema display

*New in version 0.20.0.* 

``DataFrame`` and ``Series`` will publish a Table Schema representation
by default. False by default, this can be enabled globally with the
``display.html.table_schema`` option:

``` python
In [100]: pd.set_option('display.html.table_schema', True)
```

Only ``'display.max_rows'`` are serialized and published.
