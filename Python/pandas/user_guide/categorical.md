# Categorical data

This is an introduction to pandas categorical data type, including a short comparison
with R’s ``factor``.

*Categoricals* are a pandas data type corresponding to categorical variables in
statistics. A categorical variable takes on a limited, and usually fixed,
number of possible values (*categories*; *levels* in R). Examples are gender,
social class, blood type, country affiliation, observation time or rating via
Likert scales.

In contrast to statistical categorical variables, categorical data might have an order (e.g.
‘strongly agree’ vs ‘agree’ or ‘first observation’ vs. ‘second observation’), but numerical
operations (additions, divisions, …) are not possible.

All values of categorical data are either in *categories* or *np.nan*. Order is defined by
the order of *categories*, not lexical order of the values. Internally, the data structure
consists of a *categories* array and an integer array of *codes* which point to the real value in
the *categories* array.

The categorical data type is useful in the following cases:

- A string variable consisting of only a few different values. Converting such a string
variable to a categorical variable will save some memory, see [here](#categorical-memory).
- The lexical order of a variable is not the same as the logical order (“one”, “two”, “three”).
By converting to a categorical and specifying an order on the categories, sorting and
min/max will use the logical order instead of the lexical order, see [here](#categorical-sort).
- As a signal to other Python libraries that this column should be treated as a categorical
variable (e.g. to use suitable statistical methods or plot types).

See also the [API docs on categoricals](https://pandas.pydata.org/pandas-docs/stable/reference/arrays.html#api-arrays-categorical).

## Object creation

### Series creation

Categorical ``Series`` or columns in a ``DataFrame`` can be created in several ways:

By specifying ``dtype="category"`` when constructing a ``Series``:

``` python
In [1]: s = pd.Series(["a", "b", "c", "a"], dtype="category")

In [2]: s
Out[2]: 
0    a
1    b
2    c
3    a
dtype: category
Categories (3, object): [a, b, c]
```

By converting an existing ``Series`` or column to a ``category`` dtype:

``` python
In [3]: df = pd.DataFrame({"A": ["a", "b", "c", "a"]})

In [4]: df["B"] = df["A"].astype('category')

In [5]: df
Out[5]: 
   A  B
0  a  a
1  b  b
2  c  c
3  a  a
```

By using special functions, such as [``cut()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.cut.html#pandas.cut), which groups data into
discrete bins. See the [example on tiling](reshaping.html#reshaping-tile-cut) in the docs.

``` python
In [6]: df = pd.DataFrame({'value': np.random.randint(0, 100, 20)})

In [7]: labels = ["{0} - {1}".format(i, i + 9) for i in range(0, 100, 10)]

In [8]: df['group'] = pd.cut(df.value, range(0, 105, 10), right=False, labels=labels)

In [9]: df.head(10)
Out[9]: 
   value    group
0     65  60 - 69
1     49  40 - 49
2     56  50 - 59
3     43  40 - 49
4     43  40 - 49
5     91  90 - 99
6     32  30 - 39
7     87  80 - 89
8     36  30 - 39
9      8    0 - 9
```

By passing a [``pandas.Categorical``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Categorical.html#pandas.Categorical) object to a ``Series`` or assigning it to a ``DataFrame``.

``` python
In [10]: raw_cat = pd.Categorical(["a", "b", "c", "a"], categories=["b", "c", "d"],
   ....:                          ordered=False)
   ....: 

In [11]: s = pd.Series(raw_cat)

In [12]: s
Out[12]: 
0    NaN
1      b
2      c
3    NaN
dtype: category
Categories (3, object): [b, c, d]

In [13]: df = pd.DataFrame({"A": ["a", "b", "c", "a"]})

In [14]: df["B"] = raw_cat

In [15]: df
Out[15]: 
   A    B
0  a  NaN
1  b    b
2  c    c
3  a  NaN
```

Categorical data has a specific ``category`` [dtype](https://pandas.pydata.org/pandas-docs/stable/getting_started/basics.html#basics-dtypes):

``` python
In [16]: df.dtypes
Out[16]: 
A      object
B    category
dtype: object
```

### DataFrame creation

Similar to the previous section where a single column was converted to categorical, all columns in a
``DataFrame`` can be batch converted to categorical either during or after construction.

This can be done during construction by specifying ``dtype="category"`` in the ``DataFrame`` constructor:

``` python
In [17]: df = pd.DataFrame({'A': list('abca'), 'B': list('bccd')}, dtype="category")

In [18]: df.dtypes
Out[18]: 
A    category
B    category
dtype: object
```

Note that the categories present in each column differ; the conversion is done column by column, so
only labels present in a given column are categories:

``` python
In [19]: df['A']
Out[19]: 
0    a
1    b
2    c
3    a
Name: A, dtype: category
Categories (3, object): [a, b, c]

In [20]: df['B']
Out[20]: 
0    b
1    c
2    c
3    d
Name: B, dtype: category
Categories (3, object): [b, c, d]
```

*New in version 0.23.0.* 

Analogously, all columns in an existing ``DataFrame`` can be batch converted using [``DataFrame.astype()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.astype.html#pandas.DataFrame.astype):

``` python
In [21]: df = pd.DataFrame({'A': list('abca'), 'B': list('bccd')})

In [22]: df_cat = df.astype('category')

In [23]: df_cat.dtypes
Out[23]: 
A    category
B    category
dtype: object
```

This conversion is likewise done column by column:

``` python
In [24]: df_cat['A']
Out[24]: 
0    a
1    b
2    c
3    a
Name: A, dtype: category
Categories (3, object): [a, b, c]

In [25]: df_cat['B']
Out[25]: 
0    b
1    c
2    c
3    d
Name: B, dtype: category
Categories (3, object): [b, c, d]
```

### Controlling behavior

In the examples above where we passed ``dtype='category'``, we used the default
behavior:

1. Categories are inferred from the data.
1. Categories are unordered.

To control those behaviors, instead of passing ``'category'``, use an instance
of ``CategoricalDtype``.

``` python
In [26]: from pandas.api.types import CategoricalDtype

In [27]: s = pd.Series(["a", "b", "c", "a"])

In [28]: cat_type = CategoricalDtype(categories=["b", "c", "d"],
   ....:                             ordered=True)
   ....: 

In [29]: s_cat = s.astype(cat_type)

In [30]: s_cat
Out[30]: 
0    NaN
1      b
2      c
3    NaN
dtype: category
Categories (3, object): [b < c < d]
```

Similarly, a ``CategoricalDtype`` can be used with a ``DataFrame`` to ensure that categories
are consistent among all columns.

``` python
In [31]: from pandas.api.types import CategoricalDtype

In [32]: df = pd.DataFrame({'A': list('abca'), 'B': list('bccd')})

In [33]: cat_type = CategoricalDtype(categories=list('abcd'),
   ....:                             ordered=True)
   ....: 

In [34]: df_cat = df.astype(cat_type)

In [35]: df_cat['A']
Out[35]: 
0    a
1    b
2    c
3    a
Name: A, dtype: category
Categories (4, object): [a < b < c < d]

In [36]: df_cat['B']
Out[36]: 
0    b
1    c
2    c
3    d
Name: B, dtype: category
Categories (4, object): [a < b < c < d]
```

::: tip Note

To perform table-wise conversion, where all labels in the entire ``DataFrame`` are used as
categories for each column, the ``categories`` parameter can be determined programmatically by
``categories = pd.unique(df.to_numpy().ravel())``.

:::

If you already have ``codes`` and ``categories``, you can use the
[``from_codes()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Categorical.from_codes.html#pandas.Categorical.from_codes) constructor to save the factorize step
during normal constructor mode:

``` python
In [37]: splitter = np.random.choice([0, 1], 5, p=[0.5, 0.5])

In [38]: s = pd.Series(pd.Categorical.from_codes(splitter,
   ....:                                         categories=["train", "test"]))
   ....:
```

### Regaining original data

To get back to the original ``Series`` or NumPy array, use
``Series.astype(original_dtype)`` or ``np.asarray(categorical)``:

``` python
In [39]: s = pd.Series(["a", "b", "c", "a"])

In [40]: s
Out[40]: 
0    a
1    b
2    c
3    a
dtype: object

In [41]: s2 = s.astype('category')

In [42]: s2
Out[42]: 
0    a
1    b
2    c
3    a
dtype: category
Categories (3, object): [a, b, c]

In [43]: s2.astype(str)
Out[43]: 
0    a
1    b
2    c
3    a
dtype: object

In [44]: np.asarray(s2)
Out[44]: array(['a', 'b', 'c', 'a'], dtype=object)
```

::: tip Note

In contrast to R’s *factor* function, categorical data is not converting input values to
strings; categories will end up the same data type as the original values.

:::

::: tip Note

In contrast to R’s *factor* function, there is currently no way to assign/change labels at
creation time. Use *categories* to change the categories after creation time.

:::

## CategoricalDtype

*Changed in version 0.21.0.* 

A categorical’s type is fully described by

1. ``categories``: a sequence of unique values and no missing values
1. ``ordered``: a boolean

This information can be stored in a ``CategoricalDtype``.
The ``categories`` argument is optional, which implies that the actual categories
should be inferred from whatever is present in the data when the
[``pandas.Categorical``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Categorical.html#pandas.Categorical) is created. The categories are assumed to be unordered
by default.

``` python
In [45]: from pandas.api.types import CategoricalDtype

In [46]: CategoricalDtype(['a', 'b', 'c'])
Out[46]: CategoricalDtype(categories=['a', 'b', 'c'], ordered=None)

In [47]: CategoricalDtype(['a', 'b', 'c'], ordered=True)
Out[47]: CategoricalDtype(categories=['a', 'b', 'c'], ordered=True)

In [48]: CategoricalDtype()
Out[48]: CategoricalDtype(categories=None, ordered=None)
```

A ``CategoricalDtype`` can be used in any place pandas
expects a *dtype*. For example [``pandas.read_csv()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html#pandas.read_csv),
[``pandas.DataFrame.astype()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.astype.html#pandas.DataFrame.astype), or in the ``Series`` constructor.

::: tip Note

As a convenience, you can use the string ``'category'`` in place of a
``CategoricalDtype`` when you want the default behavior of
the categories being unordered, and equal to the set values present in the
array. In other words, ``dtype='category'`` is equivalent to
``dtype=CategoricalDtype()``.

:::

### Equality semantics

Two instances of ``CategoricalDtype`` compare equal
whenever they have the same categories and order. When comparing two
unordered categoricals, the order of the ``categories`` is not considered.

``` python
In [49]: c1 = CategoricalDtype(['a', 'b', 'c'], ordered=False)

# Equal, since order is not considered when ordered=False
In [50]: c1 == CategoricalDtype(['b', 'c', 'a'], ordered=False)
Out[50]: True

# Unequal, since the second CategoricalDtype is ordered
In [51]: c1 == CategoricalDtype(['a', 'b', 'c'], ordered=True)
Out[51]: False
```

All instances of ``CategoricalDtype`` compare equal to the string ``'category'``.

``` python
In [52]: c1 == 'category'
Out[52]: True
```

::: danger Warning

Since ``dtype='category'`` is essentially ``CategoricalDtype(None, False)``,
and since all instances ``CategoricalDtype`` compare equal to ``'category'``,
all instances of ``CategoricalDtype`` compare equal to a
``CategoricalDtype(None, False)``, regardless of ``categories`` or
``ordered``.

:::

## Description

Using [``describe()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.describe.html#pandas.DataFrame.describe) on categorical data will produce similar
output to a ``Series`` or ``DataFrame`` of type ``string``.

``` python
In [53]: cat = pd.Categorical(["a", "c", "c", np.nan], categories=["b", "a", "c"])

In [54]: df = pd.DataFrame({"cat": cat, "s": ["a", "c", "c", np.nan]})

In [55]: df.describe()
Out[55]: 
       cat  s
count    3  3
unique   2  2
top      c  c
freq     2  2

In [56]: df["cat"].describe()
Out[56]: 
count     3
unique    2
top       c
freq      2
Name: cat, dtype: object
```

## Working with categories

Categorical data has a *categories* and a *ordered* property, which list their
possible values and whether the ordering matters or not. These properties are
exposed as ``s.cat.categories`` and ``s.cat.ordered``. If you don’t manually
specify categories and ordering, they are inferred from the passed arguments.

``` python
In [57]: s = pd.Series(["a", "b", "c", "a"], dtype="category")

In [58]: s.cat.categories
Out[58]: Index(['a', 'b', 'c'], dtype='object')

In [59]: s.cat.ordered
Out[59]: False
```

It’s also possible to pass in the categories in a specific order:

``` python
In [60]: s = pd.Series(pd.Categorical(["a", "b", "c", "a"],
   ....:               categories=["c", "b", "a"]))
   ....: 

In [61]: s.cat.categories
Out[61]: Index(['c', 'b', 'a'], dtype='object')

In [62]: s.cat.ordered
Out[62]: False
```

::: tip Note

New categorical data are **not** automatically ordered. You must explicitly
pass ``ordered=True`` to indicate an ordered ``Categorical``.

:::

::: tip Note

The result of [``unique()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.unique.html#pandas.Series.unique) is not always the same as ``Series.cat.categories``,
because ``Series.unique()`` has a couple of guarantees, namely that it returns categories
in the order of appearance, and it only includes values that are actually present.

``` python
In [63]: s = pd.Series(list('babc')).astype(CategoricalDtype(list('abcd')))

In [64]: s
Out[64]: 
0    b
1    a
2    b
3    c
dtype: category
Categories (4, object): [a, b, c, d]

# categories
In [65]: s.cat.categories
Out[65]: Index(['a', 'b', 'c', 'd'], dtype='object')

# uniques
In [66]: s.unique()
Out[66]: 
[b, a, c]
Categories (3, object): [b, a, c]
```

:::

### Renaming categories

Renaming categories is done by assigning new values to the
``Series.cat.categories`` property or by using the
``rename_categories()`` method:

``` python
In [67]: s = pd.Series(["a", "b", "c", "a"], dtype="category")

In [68]: s
Out[68]: 
0    a
1    b
2    c
3    a
dtype: category
Categories (3, object): [a, b, c]

In [69]: s.cat.categories = ["Group %s" % g for g in s.cat.categories]

In [70]: s
Out[70]: 
0    Group a
1    Group b
2    Group c
3    Group a
dtype: category
Categories (3, object): [Group a, Group b, Group c]

In [71]: s = s.cat.rename_categories([1, 2, 3])

In [72]: s
Out[72]: 
0    1
1    2
2    3
3    1
dtype: category
Categories (3, int64): [1, 2, 3]

# You can also pass a dict-like object to map the renaming
In [73]: s = s.cat.rename_categories({1: 'x', 2: 'y', 3: 'z'})

In [74]: s
Out[74]: 
0    x
1    y
2    z
3    x
dtype: category
Categories (3, object): [x, y, z]
```

::: tip Note

In contrast to R’s *factor*, categorical data can have categories of other types than string.

:::

::: tip Note

Be aware that assigning new categories is an inplace operation, while most other operations
under ``Series.cat`` per default return a new ``Series`` of dtype *category*.

:::

Categories must be unique or a *ValueError* is raised:

``` python
In [75]: try:
   ....:     s.cat.categories = [1, 1, 1]
   ....: except ValueError as e:
   ....:     print("ValueError:", str(e))
   ....: 
ValueError: Categorical categories must be unique
```

Categories must also not be ``NaN`` or a *ValueError* is raised:

``` python
In [76]: try:
   ....:     s.cat.categories = [1, 2, np.nan]
   ....: except ValueError as e:
   ....:     print("ValueError:", str(e))
   ....: 
ValueError: Categorial categories cannot be null
```

### Appending new categories

Appending categories can be done by using the
``add_categories()`` method:

``` python
In [77]: s = s.cat.add_categories([4])

In [78]: s.cat.categories
Out[78]: Index(['x', 'y', 'z', 4], dtype='object')

In [79]: s
Out[79]: 
0    x
1    y
2    z
3    x
dtype: category
Categories (4, object): [x, y, z, 4]
```

### Removing categories

Removing categories can be done by using the
``remove_categories()`` method. Values which are removed
are replaced by ``np.nan``.:

``` python
In [80]: s = s.cat.remove_categories([4])

In [81]: s
Out[81]: 
0    x
1    y
2    z
3    x
dtype: category
Categories (3, object): [x, y, z]
```

### Removing unused categories

Removing unused categories can also be done:

``` python
In [82]: s = pd.Series(pd.Categorical(["a", "b", "a"],
   ....:               categories=["a", "b", "c", "d"]))
   ....: 

In [83]: s
Out[83]: 
0    a
1    b
2    a
dtype: category
Categories (4, object): [a, b, c, d]

In [84]: s.cat.remove_unused_categories()
Out[84]: 
0    a
1    b
2    a
dtype: category
Categories (2, object): [a, b]
```

### Setting categories

If you want to do remove and add new categories in one step (which has some
speed advantage), or simply set the categories to a predefined scale,
use ``set_categories()``.

``` python
In [85]: s = pd.Series(["one", "two", "four", "-"], dtype="category")

In [86]: s
Out[86]: 
0     one
1     two
2    four
3       -
dtype: category
Categories (4, object): [-, four, one, two]

In [87]: s = s.cat.set_categories(["one", "two", "three", "four"])

In [88]: s
Out[88]: 
0     one
1     two
2    four
3     NaN
dtype: category
Categories (4, object): [one, two, three, four]
```

::: tip Note

Be aware that ``Categorical.set_categories()`` cannot know whether some category is omitted
intentionally or because it is misspelled or (under Python3) due to a type difference (e.g.,
NumPy S1 dtype and Python strings). This can result in surprising behaviour!

:::

## Sorting and order

If categorical data is ordered (``s.cat.ordered == True``), then the order of the categories has a
meaning and certain operations are possible. If the categorical is unordered, ``.min()/.max()`` will raise a ``TypeError``.

``` python
In [89]: s = pd.Series(pd.Categorical(["a", "b", "c", "a"], ordered=False))

In [90]: s.sort_values(inplace=True)

In [91]: s = pd.Series(["a", "b", "c", "a"]).astype(
   ....:     CategoricalDtype(ordered=True)
   ....: )
   ....: 

In [92]: s.sort_values(inplace=True)

In [93]: s
Out[93]: 
0    a
3    a
1    b
2    c
dtype: category
Categories (3, object): [a < b < c]

In [94]: s.min(), s.max()
Out[94]: ('a', 'c')
```

You can set categorical data to be ordered by using ``as_ordered()`` or unordered by using ``as_unordered()``. These will by
default return a *new* object.

``` python
In [95]: s.cat.as_ordered()
Out[95]: 
0    a
3    a
1    b
2    c
dtype: category
Categories (3, object): [a < b < c]

In [96]: s.cat.as_unordered()
Out[96]: 
0    a
3    a
1    b
2    c
dtype: category
Categories (3, object): [a, b, c]
```

Sorting will use the order defined by categories, not any lexical order present on the data type.
This is even true for strings and numeric data:

``` python
In [97]: s = pd.Series([1, 2, 3, 1], dtype="category")

In [98]: s = s.cat.set_categories([2, 3, 1], ordered=True)

In [99]: s
Out[99]: 
0    1
1    2
2    3
3    1
dtype: category
Categories (3, int64): [2 < 3 < 1]

In [100]: s.sort_values(inplace=True)

In [101]: s
Out[101]: 
1    2
2    3
0    1
3    1
dtype: category
Categories (3, int64): [2 < 3 < 1]

In [102]: s.min(), s.max()
Out[102]: (2, 1)
```

### Reordering

Reordering the categories is possible via the ``Categorical.reorder_categories()`` and
the ``Categorical.set_categories()`` methods. For ``Categorical.reorder_categories()``, all
old categories must be included in the new categories and no new categories are allowed. This will
necessarily make the sort order the same as the categories order.

``` python
In [103]: s = pd.Series([1, 2, 3, 1], dtype="category")

In [104]: s = s.cat.reorder_categories([2, 3, 1], ordered=True)

In [105]: s
Out[105]: 
0    1
1    2
2    3
3    1
dtype: category
Categories (3, int64): [2 < 3 < 1]

In [106]: s.sort_values(inplace=True)

In [107]: s
Out[107]: 
1    2
2    3
0    1
3    1
dtype: category
Categories (3, int64): [2 < 3 < 1]

In [108]: s.min(), s.max()
Out[108]: (2, 1)
```

::: tip Note

Note the difference between assigning new categories and reordering the categories: the first
renames categories and therefore the individual values in the ``Series``, but if the first
position was sorted last, the renamed value will still be sorted last. Reordering means that the
way values are sorted is different afterwards, but not that individual values in the
``Series`` are changed.

:::

::: tip Note

If the ``Categorical`` is not ordered, [``Series.min()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.min.html#pandas.Series.min) and [``Series.max()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.max.html#pandas.Series.max) will raise
``TypeError``. Numeric operations like ``+``, ``-``, ``*``, ``/`` and operations based on them
(e.g. [``Series.median()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.median.html#pandas.Series.median), which would need to compute the mean between two values if the length
of an array is even) do not work and raise a ``TypeError``.

:::

### Multi column sorting

A categorical dtyped column will participate in a multi-column sort in a similar manner to other columns.
The ordering of the categorical is determined by the ``categories`` of that column.

``` python
In [109]: dfs = pd.DataFrame({'A': pd.Categorical(list('bbeebbaa'),
   .....:                                         categories=['e', 'a', 'b'],
   .....:                                         ordered=True),
   .....:                     'B': [1, 2, 1, 2, 2, 1, 2, 1]})
   .....: 

In [110]: dfs.sort_values(by=['A', 'B'])
Out[110]: 
   A  B
2  e  1
3  e  2
7  a  1
6  a  2
0  b  1
5  b  1
1  b  2
4  b  2
```

Reordering the ``categories`` changes a future sort.

``` python
In [111]: dfs['A'] = dfs['A'].cat.reorder_categories(['a', 'b', 'e'])

In [112]: dfs.sort_values(by=['A', 'B'])
Out[112]: 
   A  B
7  a  1
6  a  2
0  b  1
5  b  1
1  b  2
4  b  2
2  e  1
3  e  2
```

## Comparisons

Comparing categorical data with other objects is possible in three cases:

- Comparing equality (``==`` and ``!=``) to a list-like object (list, Series, array,
…) of the same length as the categorical data.
- All comparisons (``==``, ``!=``, ``>``, ``>=``, ``<``, and ``<=``) of categorical data to
another categorical Series, when ``ordered==True`` and the *categories* are the same.
- All comparisons of a categorical data to a scalar.

All other comparisons, especially “non-equality” comparisons of two categoricals with different
categories or a categorical with any list-like object, will raise a ``TypeError``.

::: tip Note

Any “non-equality” comparisons of categorical data with a ``Series``, ``np.array``, ``list`` or
categorical data with different categories or ordering will raise a ``TypeError`` because custom
categories ordering could be interpreted in two ways: one with taking into account the
ordering and one without.

:::

``` python
In [113]: cat = pd.Series([1, 2, 3]).astype(
   .....:     CategoricalDtype([3, 2, 1], ordered=True)
   .....: )
   .....: 

In [114]: cat_base = pd.Series([2, 2, 2]).astype(
   .....:     CategoricalDtype([3, 2, 1], ordered=True)
   .....: )
   .....: 

In [115]: cat_base2 = pd.Series([2, 2, 2]).astype(
   .....:     CategoricalDtype(ordered=True)
   .....: )
   .....: 

In [116]: cat
Out[116]: 
0    1
1    2
2    3
dtype: category
Categories (3, int64): [3 < 2 < 1]

In [117]: cat_base
Out[117]: 
0    2
1    2
2    2
dtype: category
Categories (3, int64): [3 < 2 < 1]

In [118]: cat_base2
Out[118]: 
0    2
1    2
2    2
dtype: category
Categories (1, int64): [2]
```

Comparing to a categorical with the same categories and ordering or to a scalar works:

``` python
In [119]: cat > cat_base
Out[119]: 
0     True
1    False
2    False
dtype: bool

In [120]: cat > 2
Out[120]: 
0     True
1    False
2    False
dtype: bool
```

Equality comparisons work with any list-like object of same length and scalars:

``` python
In [121]: cat == cat_base
Out[121]: 
0    False
1     True
2    False
dtype: bool

In [122]: cat == np.array([1, 2, 3])
Out[122]: 
0    True
1    True
2    True
dtype: bool

In [123]: cat == 2
Out[123]: 
0    False
1     True
2    False
dtype: bool
```

This doesn’t work because the categories are not the same:

``` python
In [124]: try:
   .....:     cat > cat_base2
   .....: except TypeError as e:
   .....:     print("TypeError:", str(e))
   .....: 
TypeError: Categoricals can only be compared if 'categories' are the same. Categories are different lengths
```

If you want to do a “non-equality” comparison of a categorical series with a list-like object
which is not categorical data, you need to be explicit and convert the categorical data back to
the original values:

``` python
In [125]: base = np.array([1, 2, 3])

In [126]: try:
   .....:     cat > base
   .....: except TypeError as e:
   .....:     print("TypeError:", str(e))
   .....: 
TypeError: Cannot compare a Categorical for op __gt__ with type <class 'numpy.ndarray'>.
If you want to compare values, use 'np.asarray(cat) <op> other'.

In [127]: np.asarray(cat) > base
Out[127]: array([False, False, False])
```

When you compare two unordered categoricals with the same categories, the order is not considered:

``` python
In [128]: c1 = pd.Categorical(['a', 'b'], categories=['a', 'b'], ordered=False)

In [129]: c2 = pd.Categorical(['a', 'b'], categories=['b', 'a'], ordered=False)

In [130]: c1 == c2
Out[130]: array([ True,  True])
```

## Operations

Apart from [``Series.min()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.min.html#pandas.Series.min), [``Series.max()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.max.html#pandas.Series.max) and [``Series.mode()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.mode.html#pandas.Series.mode), the
following operations are possible with categorical data:

``Series`` methods like [``Series.value_counts()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.value_counts.html#pandas.Series.value_counts) will use all categories,
even if some categories are not present in the data:

``` python
In [131]: s = pd.Series(pd.Categorical(["a", "b", "c", "c"],
   .....:               categories=["c", "a", "b", "d"]))
   .....: 

In [132]: s.value_counts()
Out[132]: 
c    2
b    1
a    1
d    0
dtype: int64
```

Groupby will also show “unused” categories:

``` python
In [133]: cats = pd.Categorical(["a", "b", "b", "b", "c", "c", "c"],
   .....:                       categories=["a", "b", "c", "d"])
   .....: 

In [134]: df = pd.DataFrame({"cats": cats, "values": [1, 2, 2, 2, 3, 4, 5]})

In [135]: df.groupby("cats").mean()
Out[135]: 
      values
cats        
a        1.0
b        2.0
c        4.0
d        NaN

In [136]: cats2 = pd.Categorical(["a", "a", "b", "b"], categories=["a", "b", "c"])

In [137]: df2 = pd.DataFrame({"cats": cats2,
   .....:                     "B": ["c", "d", "c", "d"],
   .....:                     "values": [1, 2, 3, 4]})
   .....: 

In [138]: df2.groupby(["cats", "B"]).mean()
Out[138]: 
        values
cats B        
a    c     1.0
     d     2.0
b    c     3.0
     d     4.0
c    c     NaN
     d     NaN
```

Pivot tables:

``` python
In [139]: raw_cat = pd.Categorical(["a", "a", "b", "b"], categories=["a", "b", "c"])

In [140]: df = pd.DataFrame({"A": raw_cat,
   .....:                    "B": ["c", "d", "c", "d"],
   .....:                    "values": [1, 2, 3, 4]})
   .....: 

In [141]: pd.pivot_table(df, values='values', index=['A', 'B'])
Out[141]: 
     values
A B        
a c       1
  d       2
b c       3
  d       4
```

## Data munging

The optimized pandas data access methods  ``.loc``, ``.iloc``, ``.at``, and ``.iat``,
work as normal. The only difference is the return type (for getting) and
that only values already in *categories* can be assigned.

### Getting

If the slicing operation returns either a ``DataFrame`` or a column of type
``Series``, the ``category`` dtype is preserved.

``` python
In [142]: idx = pd.Index(["h", "i", "j", "k", "l", "m", "n"])

In [143]: cats = pd.Series(["a", "b", "b", "b", "c", "c", "c"],
   .....:                  dtype="category", index=idx)
   .....: 

In [144]: values = [1, 2, 2, 2, 3, 4, 5]

In [145]: df = pd.DataFrame({"cats": cats, "values": values}, index=idx)

In [146]: df.iloc[2:4, :]
Out[146]: 
  cats  values
j    b       2
k    b       2

In [147]: df.iloc[2:4, :].dtypes
Out[147]: 
cats      category
values       int64
dtype: object

In [148]: df.loc["h":"j", "cats"]
Out[148]: 
h    a
i    b
j    b
Name: cats, dtype: category
Categories (3, object): [a, b, c]

In [149]: df[df["cats"] == "b"]
Out[149]: 
  cats  values
i    b       2
j    b       2
k    b       2
```

An example where the category type is not preserved is if you take one single
row: the resulting ``Series`` is of dtype ``object``:

``` python
# get the complete "h" row as a Series
In [150]: df.loc["h", :]
Out[150]: 
cats      a
values    1
Name: h, dtype: object
```

Returning a single item from categorical data will also return the value, not a categorical
of length “1”.

``` python
In [151]: df.iat[0, 0]
Out[151]: 'a'

In [152]: df["cats"].cat.categories = ["x", "y", "z"]

In [153]: df.at["h", "cats"]  # returns a string
Out[153]: 'x'
```

::: tip Note

The is in contrast to R’s *factor* function, where ``factor(c(1,2,3))[1]``
returns a single value *factor*.

:::

To get a single value ``Series`` of type ``category``, you pass in a list with
a single value:

``` python
In [154]: df.loc[["h"], "cats"]
Out[154]: 
h    x
Name: cats, dtype: category
Categories (3, object): [x, y, z]
```

### String and datetime accessors

The accessors  ``.dt`` and ``.str`` will work if the ``s.cat.categories`` are of
an appropriate type:

``` python
In [155]: str_s = pd.Series(list('aabb'))

In [156]: str_cat = str_s.astype('category')

In [157]: str_cat
Out[157]: 
0    a
1    a
2    b
3    b
dtype: category
Categories (2, object): [a, b]

In [158]: str_cat.str.contains("a")
Out[158]: 
0     True
1     True
2    False
3    False
dtype: bool

In [159]: date_s = pd.Series(pd.date_range('1/1/2015', periods=5))

In [160]: date_cat = date_s.astype('category')

In [161]: date_cat
Out[161]: 
0   2015-01-01
1   2015-01-02
2   2015-01-03
3   2015-01-04
4   2015-01-05
dtype: category
Categories (5, datetime64[ns]): [2015-01-01, 2015-01-02, 2015-01-03, 2015-01-04, 2015-01-05]

In [162]: date_cat.dt.day
Out[162]: 
0    1
1    2
2    3
3    4
4    5
dtype: int64
```

::: tip Note

The returned ``Series`` (or ``DataFrame``) is of the same type as if you used the
``.str.`` / ``.dt.`` on a ``Series`` of that type (and not of
type ``category``!).

:::

That means, that the returned values from methods and properties on the accessors of a
``Series`` and the returned values from methods and properties on the accessors of this
``Series`` transformed to one of type *category* will be equal:

``` python
In [163]: ret_s = str_s.str.contains("a")

In [164]: ret_cat = str_cat.str.contains("a")

In [165]: ret_s.dtype == ret_cat.dtype
Out[165]: True

In [166]: ret_s == ret_cat
Out[166]: 
0    True
1    True
2    True
3    True
dtype: bool
```

::: tip Note

The work is done on the ``categories`` and then a new ``Series`` is constructed. This has
some performance implication if you have a ``Series`` of type string, where lots of elements
are repeated (i.e. the number of unique elements in the ``Series`` is a lot smaller than the
length of the ``Series``). In this case it can be faster to convert the original ``Series``
to one of type ``category`` and use ``.str.`` or ``.dt.`` on that.

:::

### Setting

Setting values in a categorical column (or ``Series``) works as long as the
value is included in the *categories*:

``` python
In [167]: idx = pd.Index(["h", "i", "j", "k", "l", "m", "n"])

In [168]: cats = pd.Categorical(["a", "a", "a", "a", "a", "a", "a"],
   .....:                       categories=["a", "b"])
   .....: 

In [169]: values = [1, 1, 1, 1, 1, 1, 1]

In [170]: df = pd.DataFrame({"cats": cats, "values": values}, index=idx)

In [171]: df.iloc[2:4, :] = [["b", 2], ["b", 2]]

In [172]: df
Out[172]: 
  cats  values
h    a       1
i    a       1
j    b       2
k    b       2
l    a       1
m    a       1
n    a       1

In [173]: try:
   .....:     df.iloc[2:4, :] = [["c", 3], ["c", 3]]
   .....: except ValueError as e:
   .....:     print("ValueError:", str(e))
   .....: 
ValueError: Cannot setitem on a Categorical with a new category, set the categories first
```

Setting values by assigning categorical data will also check that the *categories* match:

``` python
In [174]: df.loc["j":"k", "cats"] = pd.Categorical(["a", "a"], categories=["a", "b"])

In [175]: df
Out[175]: 
  cats  values
h    a       1
i    a       1
j    a       2
k    a       2
l    a       1
m    a       1
n    a       1

In [176]: try:
   .....:     df.loc["j":"k", "cats"] = pd.Categorical(["b", "b"],
   .....:                                              categories=["a", "b", "c"])
   .....: except ValueError as e:
   .....:     print("ValueError:", str(e))
   .....: 
ValueError: Cannot set a Categorical with another, without identical categories
```

Assigning a ``Categorical`` to parts of a column of other types will use the values:

``` python
In [177]: df = pd.DataFrame({"a": [1, 1, 1, 1, 1], "b": ["a", "a", "a", "a", "a"]})

In [178]: df.loc[1:2, "a"] = pd.Categorical(["b", "b"], categories=["a", "b"])

In [179]: df.loc[2:3, "b"] = pd.Categorical(["b", "b"], categories=["a", "b"])

In [180]: df
Out[180]: 
   a  b
0  1  a
1  b  a
2  b  b
3  1  b
4  1  a

In [181]: df.dtypes
Out[181]: 
a    object
b    object
dtype: object
```

### Merging

You can concat two ``DataFrames`` containing categorical data together,
but the categories of these categoricals need to be the same:

``` python
In [182]: cat = pd.Series(["a", "b"], dtype="category")

In [183]: vals = [1, 2]

In [184]: df = pd.DataFrame({"cats": cat, "vals": vals})

In [185]: res = pd.concat([df, df])

In [186]: res
Out[186]: 
  cats  vals
0    a     1
1    b     2
0    a     1
1    b     2

In [187]: res.dtypes
Out[187]: 
cats    category
vals       int64
dtype: object
```

In this case the categories are not the same, and therefore an error is raised:

``` python
In [188]: df_different = df.copy()

In [189]: df_different["cats"].cat.categories = ["c", "d"]

In [190]: try:
   .....:     pd.concat([df, df_different])
   .....: except ValueError as e:
   .....:     print("ValueError:", str(e))
   .....:
```

The same applies to ``df.append(df_different)``.

See also the section on [merge dtypes](merging.html#merging-dtypes) for notes about preserving merge dtypes and performance.

### Unioning

*New in version 0.19.0.* 

If you want to combine categoricals that do not necessarily have the same
categories, the [``union_categoricals()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.api.types.union_categoricals.html#pandas.api.types.union_categoricals) function will
combine a list-like of categoricals. The new categories will be the union of
the categories being combined.

``` python
In [191]: from pandas.api.types import union_categoricals

In [192]: a = pd.Categorical(["b", "c"])

In [193]: b = pd.Categorical(["a", "b"])

In [194]: union_categoricals([a, b])
Out[194]: 
[b, c, a, b]
Categories (3, object): [b, c, a]
```

By default, the resulting categories will be ordered as
they appear in the data. If you want the categories to
be lexsorted, use ``sort_categories=True`` argument.

``` python
In [195]: union_categoricals([a, b], sort_categories=True)
Out[195]: 
[b, c, a, b]
Categories (3, object): [a, b, c]
```

``union_categoricals`` also works with the “easy” case of combining two
categoricals of the same categories and order information
(e.g. what you could also ``append`` for).

``` python
In [196]: a = pd.Categorical(["a", "b"], ordered=True)

In [197]: b = pd.Categorical(["a", "b", "a"], ordered=True)

In [198]: union_categoricals([a, b])
Out[198]: 
[a, b, a, b, a]
Categories (2, object): [a < b]
```

The below raises ``TypeError`` because the categories are ordered and not identical.

``` python
In [1]: a = pd.Categorical(["a", "b"], ordered=True)
In [2]: b = pd.Categorical(["a", "b", "c"], ordered=True)
In [3]: union_categoricals([a, b])
Out[3]:
TypeError: to union ordered Categoricals, all categories must be the same
```

*New in version 0.20.0.* 

Ordered categoricals with different categories or orderings can be combined by
using the ``ignore_ordered=True`` argument.

``` python
In [199]: a = pd.Categorical(["a", "b", "c"], ordered=True)

In [200]: b = pd.Categorical(["c", "b", "a"], ordered=True)

In [201]: union_categoricals([a, b], ignore_order=True)
Out[201]: 
[a, b, c, c, b, a]
Categories (3, object): [a, b, c]
```

[``union_categoricals()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.api.types.union_categoricals.html#pandas.api.types.union_categoricals) also works with a
``CategoricalIndex``, or ``Series`` containing categorical data, but note that
the resulting array will always be a plain ``Categorical``:

``` python
In [202]: a = pd.Series(["b", "c"], dtype='category')

In [203]: b = pd.Series(["a", "b"], dtype='category')

In [204]: union_categoricals([a, b])
Out[204]: 
[b, c, a, b]
Categories (3, object): [b, c, a]
```

::: tip Note

``union_categoricals`` may recode the integer codes for categories
when combining categoricals.  This is likely what you want,
but if you are relying on the exact numbering of the categories, be
aware.

``` python
In [205]: c1 = pd.Categorical(["b", "c"])

In [206]: c2 = pd.Categorical(["a", "b"])

In [207]: c1
Out[207]: 
[b, c]
Categories (2, object): [b, c]

# "b" is coded to 0
In [208]: c1.codes
Out[208]: array([0, 1], dtype=int8)

In [209]: c2
Out[209]: 
[a, b]
Categories (2, object): [a, b]

# "b" is coded to 1
In [210]: c2.codes
Out[210]: array([0, 1], dtype=int8)

In [211]: c = union_categoricals([c1, c2])

In [212]: c
Out[212]: 
[b, c, a, b]
Categories (3, object): [b, c, a]

# "b" is coded to 0 throughout, same as c1, different from c2
In [213]: c.codes
Out[213]: array([0, 1, 2, 0], dtype=int8)
```

:::

### Concatenation

This section describes concatenations specific to ``category`` dtype. See [Concatenating objects](merging.html#merging-concat) for general description.

By default, ``Series`` or ``DataFrame`` concatenation which contains the same categories
results in ``category`` dtype, otherwise results in ``object`` dtype.
Use ``.astype`` or ``union_categoricals`` to get ``category`` result.

``` python
# same categories
In [214]: s1 = pd.Series(['a', 'b'], dtype='category')

In [215]: s2 = pd.Series(['a', 'b', 'a'], dtype='category')

In [216]: pd.concat([s1, s2])
Out[216]: 
0    a
1    b
0    a
1    b
2    a
dtype: category
Categories (2, object): [a, b]

# different categories
In [217]: s3 = pd.Series(['b', 'c'], dtype='category')

In [218]: pd.concat([s1, s3])
Out[218]: 
0    a
1    b
0    b
1    c
dtype: object

In [219]: pd.concat([s1, s3]).astype('category')
Out[219]: 
0    a
1    b
0    b
1    c
dtype: category
Categories (3, object): [a, b, c]

In [220]: union_categoricals([s1.array, s3.array])
Out[220]: 
[a, b, b, c]
Categories (3, object): [a, b, c]
```

Following table summarizes the results of ``Categoricals`` related concatenations.

arg1 | arg2 | result
---|---|---
category | category (identical categories) | category
category | category (different categories, both not ordered) | object (dtype is inferred)
category | category (different categories, either one is ordered) | object (dtype is inferred)
category | not category | object (dtype is inferred)

## Getting data in/out

You can write data that contains ``category`` dtypes to a ``HDFStore``.
See [here](io.html#io-hdf5-categorical) for an example and caveats.

It is also possible to write data to and reading data from *Stata* format files.
See [here](io.html#io-stata-categorical) for an example and caveats.

Writing to a CSV file will convert the data, effectively removing any information about the
categorical (categories and ordering). So if you read back the CSV file you have to convert the
relevant columns back to *category* and assign the right categories and categories ordering.

``` python
In [221]: import io

In [222]: s = pd.Series(pd.Categorical(['a', 'b', 'b', 'a', 'a', 'd']))

# rename the categories
In [223]: s.cat.categories = ["very good", "good", "bad"]

# reorder the categories and add missing categories
In [224]: s = s.cat.set_categories(["very bad", "bad", "medium", "good", "very good"])

In [225]: df = pd.DataFrame({"cats": s, "vals": [1, 2, 3, 4, 5, 6]})

In [226]: csv = io.StringIO()

In [227]: df.to_csv(csv)

In [228]: df2 = pd.read_csv(io.StringIO(csv.getvalue()))

In [229]: df2.dtypes
Out[229]: 
Unnamed: 0     int64
cats          object
vals           int64
dtype: object

In [230]: df2["cats"]
Out[230]: 
0    very good
1         good
2         good
3    very good
4    very good
5          bad
Name: cats, dtype: object

# Redo the category
In [231]: df2["cats"] = df2["cats"].astype("category")

In [232]: df2["cats"].cat.set_categories(["very bad", "bad", "medium",
   .....:                                 "good", "very good"],
   .....:                                inplace=True)
   .....: 

In [233]: df2.dtypes
Out[233]: 
Unnamed: 0       int64
cats          category
vals             int64
dtype: object

In [234]: df2["cats"]
Out[234]: 
0    very good
1         good
2         good
3    very good
4    very good
5          bad
Name: cats, dtype: category
Categories (5, object): [very bad, bad, medium, good, very good]
```

The same holds for writing to a SQL database with ``to_sql``.

## Missing data

pandas primarily uses the value *np.nan* to represent missing data. It is by
default not included in computations. See the [Missing Data section](missing_data.html#missing-data).

Missing values should **not** be included in the Categorical’s ``categories``,
only in the ``values``.
Instead, it is understood that NaN is different, and is always a possibility.
When working with the Categorical’s ``codes``, missing values will always have
a code of ``-1``.

``` python
In [235]: s = pd.Series(["a", "b", np.nan, "a"], dtype="category")

# only two categories
In [236]: s
Out[236]: 
0      a
1      b
2    NaN
3      a
dtype: category
Categories (2, object): [a, b]

In [237]: s.cat.codes
Out[237]: 
0    0
1    1
2   -1
3    0
dtype: int8
```

Methods for working with missing data, e.g. [``isna()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.isna.html#pandas.Series.isna), [``fillna()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.fillna.html#pandas.Series.fillna),
[``dropna()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.dropna.html#pandas.Series.dropna), all work normally:

``` python
In [238]: s = pd.Series(["a", "b", np.nan], dtype="category")

In [239]: s
Out[239]: 
0      a
1      b
2    NaN
dtype: category
Categories (2, object): [a, b]

In [240]: pd.isna(s)
Out[240]: 
0    False
1    False
2     True
dtype: bool

In [241]: s.fillna("a")
Out[241]: 
0    a
1    b
2    a
dtype: category
Categories (2, object): [a, b]
```

## Differences to R’s factor

The following differences to R’s factor functions can be observed:

- R’s *levels* are named *categories*.
- R’s *levels* are always of type string, while *categories* in pandas can be of any dtype.
- It’s not possible to specify labels at creation time. Use ``s.cat.rename_categories(new_labels)``
afterwards.
- In contrast to R’s *factor* function, using categorical data as the sole input to create a
new categorical series will *not* remove unused categories but create a new categorical series
which is equal to the passed in one!
- R allows for missing values to be included in its *levels* (pandas’ *categories*). Pandas
does not allow *NaN* categories, but missing values can still be in the *values*.

## Gotchas

### Memory usage

The memory usage of a ``Categorical`` is proportional to the number of categories plus the length of the data. In contrast,
an ``object`` dtype is a constant times the length of the data.

``` python
In [242]: s = pd.Series(['foo', 'bar'] * 1000)

# object dtype
In [243]: s.nbytes
Out[243]: 16000

# category dtype
In [244]: s.astype('category').nbytes
Out[244]: 2016
```

::: tip Note

If the number of categories approaches the length of the data, the ``Categorical`` will use nearly the same or
more memory than an equivalent ``object`` dtype representation.

``` python
In [245]: s = pd.Series(['foo%04d' % i for i in range(2000)])

# object dtype
In [246]: s.nbytes
Out[246]: 16000

# category dtype
In [247]: s.astype('category').nbytes
Out[247]: 20000
```

:::

### Categorical is not a numpy array

Currently, categorical data and the underlying ``Categorical`` is implemented as a Python
object and not as a low-level NumPy array dtype. This leads to some problems.

NumPy itself doesn’t know about the new *dtype*:

``` python
In [248]: try:
   .....:     np.dtype("category")
   .....: except TypeError as e:
   .....:     print("TypeError:", str(e))
   .....: 
TypeError: data type "category" not understood

In [249]: dtype = pd.Categorical(["a"]).dtype

In [250]: try:
   .....:     np.dtype(dtype)
   .....: except TypeError as e:
   .....:     print("TypeError:", str(e))
   .....: 
TypeError: data type not understood
```

Dtype comparisons work:

``` python
In [251]: dtype == np.str_
Out[251]: False

In [252]: np.str_ == dtype
Out[252]: False
```

To check if a Series contains Categorical data, use ``hasattr(s, 'cat')``:

``` python
In [253]: hasattr(pd.Series(['a'], dtype='category'), 'cat')
Out[253]: True

In [254]: hasattr(pd.Series(['a']), 'cat')
Out[254]: False
```

Using NumPy functions on a ``Series`` of type ``category`` should not work as *Categoricals*
are not numeric data (even in the case that ``.categories`` is numeric).

``` python
In [255]: s = pd.Series(pd.Categorical([1, 2, 3, 4]))

In [256]: try:
   .....:     np.sum(s)
   .....: except TypeError as e:
   .....:     print("TypeError:", str(e))
   .....: 
TypeError: Categorical cannot perform the operation sum
```

::: tip Note

If such a function works, please file a bug at [https://github.com/pandas-dev/pandas](https://github.com/pandas-dev/pandas)!

:::

### dtype in apply

Pandas currently does not preserve the dtype in apply functions: If you apply along rows you get
a *Series* of ``object`` *dtype* (same as getting a row -> getting one element will return a
basic type) and applying along columns will also convert to object. ``NaN`` values are unaffected.
You can use ``fillna`` to handle missing values before applying a function.

``` python
In [257]: df = pd.DataFrame({"a": [1, 2, 3, 4],
   .....:                    "b": ["a", "b", "c", "d"],
   .....:                    "cats": pd.Categorical([1, 2, 3, 2])})
   .....: 

In [258]: df.apply(lambda row: type(row["cats"]), axis=1)
Out[258]: 
0    <class 'int'>
1    <class 'int'>
2    <class 'int'>
3    <class 'int'>
dtype: object

In [259]: df.apply(lambda col: col.dtype, axis=0)
Out[259]: 
a          int64
b         object
cats    category
dtype: object
```

### Categorical index

``CategoricalIndex`` is a type of index that is useful for supporting
indexing with duplicates. This is a container around a ``Categorical``
and allows efficient indexing and storage of an index with a large number of duplicated elements.
See the [advanced indexing docs](advanced.html#indexing-categoricalindex) for a more detailed
explanation.

Setting the index will create a ``CategoricalIndex``:

``` python
In [260]: cats = pd.Categorical([1, 2, 3, 4], categories=[4, 2, 3, 1])

In [261]: strings = ["a", "b", "c", "d"]

In [262]: values = [4, 2, 3, 1]

In [263]: df = pd.DataFrame({"strings": strings, "values": values}, index=cats)

In [264]: df.index
Out[264]: CategoricalIndex([1, 2, 3, 4], categories=[4, 2, 3, 1], ordered=False, dtype='category')

# This now sorts by the categories order
In [265]: df.sort_index()
Out[265]: 
  strings  values
4       d       1
2       b       2
3       c       3
1       a       4
```

### Side effects

Constructing a ``Series`` from a ``Categorical`` will not copy the input
``Categorical``. This means that changes to the ``Series`` will in most cases
change the original ``Categorical``:

``` python
In [266]: cat = pd.Categorical([1, 2, 3, 10], categories=[1, 2, 3, 4, 10])

In [267]: s = pd.Series(cat, name="cat")

In [268]: cat
Out[268]: 
[1, 2, 3, 10]
Categories (5, int64): [1, 2, 3, 4, 10]

In [269]: s.iloc[0:2] = 10

In [270]: cat
Out[270]: 
[10, 10, 3, 10]
Categories (5, int64): [1, 2, 3, 4, 10]

In [271]: df = pd.DataFrame(s)

In [272]: df["cat"].cat.categories = [1, 2, 3, 4, 5]

In [273]: cat
Out[273]: 
[5, 5, 3, 5]
Categories (5, int64): [1, 2, 3, 4, 5]
```

Use ``copy=True`` to prevent such a behaviour or simply don’t reuse ``Categoricals``:

``` python
In [274]: cat = pd.Categorical([1, 2, 3, 10], categories=[1, 2, 3, 4, 10])

In [275]: s = pd.Series(cat, name="cat", copy=True)

In [276]: cat
Out[276]: 
[1, 2, 3, 10]
Categories (5, int64): [1, 2, 3, 4, 10]

In [277]: s.iloc[0:2] = 10

In [278]: cat
Out[278]: 
[1, 2, 3, 10]
Categories (5, int64): [1, 2, 3, 4, 10]
```

::: tip Note

This also happens in some cases when you supply a NumPy array instead of a ``Categorical``:
using an int array (e.g. ``np.array([1,2,3,4])``) will exhibit the same behavior, while using
a string array (e.g. ``np.array(["a","b","c","a"])``) will not.

:::
