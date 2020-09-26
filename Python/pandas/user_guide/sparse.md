# Sparse data structures

::: tip Note

``SparseSeries`` and ``SparseDataFrame`` have been deprecated. Their purpose
is served equally well by a [``Series``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.html#pandas.Series) or [``DataFrame``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html#pandas.DataFrame) with
sparse values. See [Migrating](#sparse-migration) for tips on migrating.

:::

Pandas provides data structures for efficiently storing sparse data.
These are not necessarily sparse in the typical “mostly 0”. Rather, you can view these
objects as being “compressed” where any data matching a specific value (``NaN`` / missing value, though any value
can be chosen, including 0) is omitted. The compressed values are not actually stored in the array.

``` python
In [1]: arr = np.random.randn(10)

In [2]: arr[2:-2] = np.nan

In [3]: ts = pd.Series(pd.SparseArray(arr))

In [4]: ts
Out[4]: 
0    0.469112
1   -0.282863
2         NaN
3         NaN
4         NaN
5         NaN
6         NaN
7         NaN
8   -0.861849
9   -2.104569
dtype: Sparse[float64, nan]
```

Notice the dtype, ``Sparse[float64, nan]``. The ``nan`` means that elements in the
array that are ``nan`` aren’t actually stored, only the non-``nan`` elements are.
Those non-``nan`` elements have a ``float64`` dtype.

The sparse objects exist for memory efficiency reasons. Suppose you had a
large, mostly NA ``DataFrame``:

``` python
In [5]: df = pd.DataFrame(np.random.randn(10000, 4))

In [6]: df.iloc[:9998] = np.nan

In [7]: sdf = df.astype(pd.SparseDtype("float", np.nan))

In [8]: sdf.head()
Out[8]: 
    0   1   2   3
0 NaN NaN NaN NaN
1 NaN NaN NaN NaN
2 NaN NaN NaN NaN
3 NaN NaN NaN NaN
4 NaN NaN NaN NaN

In [9]: sdf.dtypes
Out[9]: 
0    Sparse[float64, nan]
1    Sparse[float64, nan]
2    Sparse[float64, nan]
3    Sparse[float64, nan]
dtype: object

In [10]: sdf.sparse.density
Out[10]: 0.0002
```

As you can see, the density (% of values that have not been “compressed”) is
extremely low. This sparse object takes up much less memory on disk (pickled)
and in the Python interpreter.

``` python
In [11]: 'dense : {:0.2f} bytes'.format(df.memory_usage().sum() / 1e3)
Out[11]: 'dense : 320.13 bytes'

In [12]: 'sparse: {:0.2f} bytes'.format(sdf.memory_usage().sum() / 1e3)
Out[12]: 'sparse: 0.22 bytes'
```

Functionally, their behavior should be nearly
identical to their dense counterparts.

## SparseArray

[``SparseArray``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.SparseArray.html#pandas.SparseArray) is a [``ExtensionArray``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.api.extensions.ExtensionArray.html#pandas.api.extensions.ExtensionArray)
for storing an array of sparse values (see [dtypes](https://pandas.pydata.org/pandas-docs/stable/getting_started/basics.html#basics-dtypes) for more
on extension arrays). It is a 1-dimensional ndarray-like object storing
only values distinct from the ``fill_value``:

``` python
In [13]: arr = np.random.randn(10)

In [14]: arr[2:5] = np.nan

In [15]: arr[7:8] = np.nan

In [16]: sparr = pd.SparseArray(arr)

In [17]: sparr
Out[17]: 
[-1.9556635297215477, -1.6588664275960427, nan, nan, nan, 1.1589328886422277, 0.14529711373305043, nan, 0.6060271905134522, 1.3342113401317768]
Fill: nan
IntIndex
Indices: array([0, 1, 5, 6, 8, 9], dtype=int32)
```

A sparse array can be converted to a regular (dense) ndarray with ``numpy.asarray()``

``` python
In [18]: np.asarray(sparr)
Out[18]: 
array([-1.9557, -1.6589,     nan,     nan,     nan,  1.1589,  0.1453,
           nan,  0.606 ,  1.3342])
```

## SparseDtype

The ``SparseArray.dtype`` property stores two pieces of information

1. The dtype of the non-sparse values
1. The scalar fill value

``` python
In [19]: sparr.dtype
Out[19]: Sparse[float64, nan]
```

A [``SparseDtype``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.SparseDtype.html#pandas.SparseDtype) may be constructed by passing each of these

``` python
In [20]: pd.SparseDtype(np.dtype('datetime64[ns]'))
Out[20]: Sparse[datetime64[ns], NaT]
```

The default fill value for a given NumPy dtype is the “missing” value for that dtype,
though it may be overridden.

``` python
In [21]: pd.SparseDtype(np.dtype('datetime64[ns]'),
   ....:                fill_value=pd.Timestamp('2017-01-01'))
   ....: 
Out[21]: Sparse[datetime64[ns], 2017-01-01 00:00:00]
```

Finally, the string alias ``'Sparse[dtype]'`` may be used to specify a sparse dtype
in many places

``` python
In [22]: pd.array([1, 0, 0, 2], dtype='Sparse[int]')
Out[22]: 
[1, 0, 0, 2]
Fill: 0
IntIndex
Indices: array([0, 3], dtype=int32)
```

## Sparse accessor

*New in version 0.24.0.* 

Pandas provides a ``.sparse`` accessor, similar to ``.str`` for string data, ``.cat``
for categorical data, and ``.dt`` for datetime-like data. This namespace provides
attributes and methods that are specific to sparse data.

``` python
In [23]: s = pd.Series([0, 0, 1, 2], dtype="Sparse[int]")

In [24]: s.sparse.density
Out[24]: 0.5

In [25]: s.sparse.fill_value
Out[25]: 0
```

This accessor is available only on data with ``SparseDtype``, and on the [``Series``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.html#pandas.Series)
class itself for creating a Series with sparse data from a scipy COO matrix with.

*New in version 0.25.0.* 

A ``.sparse`` accessor has been added for [``DataFrame``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html#pandas.DataFrame) as well.
See [Sparse accessor](https://pandas.pydata.org/pandas-docs/stable/reference/frame.html#api-frame-sparse) for more.

## Sparse calculation

You can apply NumPy [ufuncs](https://docs.scipy.org/doc/numpy/reference/ufuncs.html)
to ``SparseArray`` and get a ``SparseArray`` as a result.

``` python
In [26]: arr = pd.SparseArray([1., np.nan, np.nan, -2., np.nan])

In [27]: np.abs(arr)
Out[27]: 
[1.0, nan, nan, 2.0, nan]
Fill: nan
IntIndex
Indices: array([0, 3], dtype=int32)
```

The *ufunc* is also applied to ``fill_value``. This is needed to get
the correct dense result.

``` python
In [28]: arr = pd.SparseArray([1., -1, -1, -2., -1], fill_value=-1)

In [29]: np.abs(arr)
Out[29]: 
[1.0, 1, 1, 2.0, 1]
Fill: 1
IntIndex
Indices: array([0, 3], dtype=int32)

In [30]: np.abs(arr).to_dense()
Out[30]: array([1., 1., 1., 2., 1.])
```

## Migrating

In older versions of pandas, the ``SparseSeries`` and ``SparseDataFrame`` classes (documented below)
were the preferred way to work with sparse data. With the advent of extension arrays, these subclasses
are no longer needed. Their purpose is better served by using a regular Series or DataFrame with
sparse values instead.

::: tip Note

There’s no performance or memory penalty to using a Series or DataFrame with sparse values,
rather than a SparseSeries or SparseDataFrame.

:::

This section provides some guidance on migrating your code to the new style. As a reminder,
you can use the python warnings module to control warnings. But we recommend modifying
your code, rather than ignoring the warning.

**Construction**

From an array-like, use the regular [``Series``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.html#pandas.Series) or
[``DataFrame``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html#pandas.DataFrame) constructors with [``SparseArray``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.SparseArray.html#pandas.SparseArray) values.

``` python
# Previous way
>>> pd.SparseDataFrame({"A": [0, 1]})
```

``` python
# New way
In [31]: pd.DataFrame({"A": pd.SparseArray([0, 1])})
Out[31]: 
   A
0  0
1  1
```

From a SciPy sparse matrix, use [``DataFrame.sparse.from_spmatrix()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.sparse.from_spmatrix.html#pandas.DataFrame.sparse.from_spmatrix),

``` python
# Previous way
>>> from scipy import sparse
>>> mat = sparse.eye(3)
>>> df = pd.SparseDataFrame(mat, columns=['A', 'B', 'C'])
```

``` python
# New way
In [32]: from scipy import sparse

In [33]: mat = sparse.eye(3)

In [34]: df = pd.DataFrame.sparse.from_spmatrix(mat, columns=['A', 'B', 'C'])

In [35]: df.dtypes
Out[35]: 
A    Sparse[float64, 0.0]
B    Sparse[float64, 0.0]
C    Sparse[float64, 0.0]
dtype: object
```

**Conversion**

From sparse to dense, use the ``.sparse`` accessors

``` python
In [36]: df.sparse.to_dense()
Out[36]: 
     A    B    C
0  1.0  0.0  0.0
1  0.0  1.0  0.0
2  0.0  0.0  1.0

In [37]: df.sparse.to_coo()
Out[37]: 
<3x3 sparse matrix of type '<class 'numpy.float64'>'
	with 3 stored elements in COOrdinate format>
```

From dense to sparse, use [``DataFrame.astype()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.astype.html#pandas.DataFrame.astype) with a [``SparseDtype``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.SparseDtype.html#pandas.SparseDtype).

``` python
In [38]: dense = pd.DataFrame({"A": [1, 0, 0, 1]})

In [39]: dtype = pd.SparseDtype(int, fill_value=0)

In [40]: dense.astype(dtype)
Out[40]: 
   A
0  1
1  0
2  0
3  1
```

**Sparse Properties**

Sparse-specific properties, like ``density``, are available on the ``.sparse`` accessor.

``` python
In [41]: df.sparse.density
Out[41]: 0.3333333333333333
```

**General differences**

In a ``SparseDataFrame``, *all* columns were sparse. A [``DataFrame``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html#pandas.DataFrame) can have a mixture of
sparse and dense columns. As a consequence, assigning new columns to a ``DataFrame`` with sparse
values will not automatically convert the input to be sparse.

``` python
# Previous Way
>>> df = pd.SparseDataFrame({"A": [0, 1]})
>>> df['B'] = [0, 0]  # implicitly becomes Sparse
>>> df['B'].dtype
Sparse[int64, nan]
```

Instead, you’ll need to ensure that the values being assigned are sparse

``` python
In [42]: df = pd.DataFrame({"A": pd.SparseArray([0, 1])})

In [43]: df['B'] = [0, 0]  # remains dense

In [44]: df['B'].dtype
Out[44]: dtype('int64')

In [45]: df['B'] = pd.SparseArray([0, 0])

In [46]: df['B'].dtype
Out[46]: Sparse[int64, 0]
```

The ``SparseDataFrame.default_kind`` and ``SparseDataFrame.default_fill_value`` attributes
have no replacement.

## Interaction with scipy.sparse

Use [``DataFrame.sparse.from_spmatrix()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.sparse.from_spmatrix.html#pandas.DataFrame.sparse.from_spmatrix) to create a ``DataFrame`` with sparse values from a sparse matrix.

*New in version 0.25.0.* 

``` python
In [47]: from scipy.sparse import csr_matrix

In [48]: arr = np.random.random(size=(1000, 5))

In [49]: arr[arr < .9] = 0

In [50]: sp_arr = csr_matrix(arr)

In [51]: sp_arr
Out[51]: 
<1000x5 sparse matrix of type '<class 'numpy.float64'>'
	with 517 stored elements in Compressed Sparse Row format>

In [52]: sdf = pd.DataFrame.sparse.from_spmatrix(sp_arr)

In [53]: sdf.head()
Out[53]: 
          0    1    2         3    4
0  0.956380  0.0  0.0  0.000000  0.0
1  0.000000  0.0  0.0  0.000000  0.0
2  0.000000  0.0  0.0  0.000000  0.0
3  0.000000  0.0  0.0  0.000000  0.0
4  0.999552  0.0  0.0  0.956153  0.0

In [54]: sdf.dtypes
Out[54]: 
0    Sparse[float64, 0.0]
1    Sparse[float64, 0.0]
2    Sparse[float64, 0.0]
3    Sparse[float64, 0.0]
4    Sparse[float64, 0.0]
dtype: object
```

All sparse formats are supported, but matrices that are not in [``COOrdinate``](https://docs.scipy.org/doc/scipy/reference/sparse.html#module-scipy.sparse) format will be converted, copying data as needed.
To convert back to sparse SciPy matrix in COO format, you can use the [``DataFrame.sparse.to_coo()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.sparse.to_coo.html#pandas.DataFrame.sparse.to_coo) method:

``` python
In [55]: sdf.sparse.to_coo()
Out[55]: 
<1000x5 sparse matrix of type '<class 'numpy.float64'>'
	with 517 stored elements in COOrdinate format>
```

meth:*Series.sparse.to_coo* is implemented for transforming a ``Series`` with sparse values indexed by a [``MultiIndex``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.MultiIndex.html#pandas.MultiIndex) to a [``scipy.sparse.coo_matrix``](https://docs.scipy.org/doc/scipy/reference/generated/scipy.sparse.coo_matrix.html#scipy.sparse.coo_matrix).

The method requires a ``MultiIndex`` with two or more levels.

``` python
In [56]: s = pd.Series([3.0, np.nan, 1.0, 3.0, np.nan, np.nan])

In [57]: s.index = pd.MultiIndex.from_tuples([(1, 2, 'a', 0),
   ....:                                      (1, 2, 'a', 1),
   ....:                                      (1, 1, 'b', 0),
   ....:                                      (1, 1, 'b', 1),
   ....:                                      (2, 1, 'b', 0),
   ....:                                      (2, 1, 'b', 1)],
   ....:                                     names=['A', 'B', 'C', 'D'])
   ....: 

In [58]: s
Out[58]: 
A  B  C  D
1  2  a  0    3.0
         1    NaN
   1  b  0    1.0
         1    3.0
2  1  b  0    NaN
         1    NaN
dtype: float64

In [59]: ss = s.astype('Sparse')

In [60]: ss
Out[60]: 
A  B  C  D
1  2  a  0    3.0
         1    NaN
   1  b  0    1.0
         1    3.0
2  1  b  0    NaN
         1    NaN
dtype: Sparse[float64, nan]
```

In the example below, we transform the ``Series`` to a sparse representation of a 2-d array by specifying that the first and second ``MultiIndex`` levels define labels for the rows and the third and fourth levels define labels for the columns. We also specify that the column and row labels should be sorted in the final sparse representation.

``` python
In [61]: A, rows, columns = ss.sparse.to_coo(row_levels=['A', 'B'],
   ....:                                     column_levels=['C', 'D'],
   ....:                                     sort_labels=True)
   ....: 

In [62]: A
Out[62]: 
<3x4 sparse matrix of type '<class 'numpy.float64'>'
	with 3 stored elements in COOrdinate format>

In [63]: A.todense()
Out[63]: 
matrix([[0., 0., 1., 3.],
        [3., 0., 0., 0.],
        [0., 0., 0., 0.]])

In [64]: rows
Out[64]: [(1, 1), (1, 2), (2, 1)]

In [65]: columns
Out[65]: [('a', 0), ('a', 1), ('b', 0), ('b', 1)]
```

Specifying different row and column labels (and not sorting them) yields a different sparse matrix:

``` python
In [66]: A, rows, columns = ss.sparse.to_coo(row_levels=['A', 'B', 'C'],
   ....:                                     column_levels=['D'],
   ....:                                     sort_labels=False)
   ....: 

In [67]: A
Out[67]: 
<3x2 sparse matrix of type '<class 'numpy.float64'>'
	with 3 stored elements in COOrdinate format>

In [68]: A.todense()
Out[68]: 
matrix([[3., 0.],
        [1., 3.],
        [0., 0.]])

In [69]: rows
Out[69]: [(1, 2, 'a'), (1, 1, 'b'), (2, 1, 'b')]

In [70]: columns
Out[70]: [0, 1]
```

A convenience method [``Series.sparse.from_coo()``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.sparse.from_coo.html#pandas.Series.sparse.from_coo) is implemented for creating a ``Series`` with sparse values from a ``scipy.sparse.coo_matrix``.

``` python
In [71]: from scipy import sparse

In [72]: A = sparse.coo_matrix(([3.0, 1.0, 2.0], ([1, 0, 0], [0, 2, 3])),
   ....:                       shape=(3, 4))
   ....: 

In [73]: A
Out[73]: 
<3x4 sparse matrix of type '<class 'numpy.float64'>'
	with 3 stored elements in COOrdinate format>

In [74]: A.todense()
Out[74]: 
matrix([[0., 0., 1., 2.],
        [3., 0., 0., 0.],
        [0., 0., 0., 0.]])
```

The default behaviour (with ``dense_index=False``) simply returns a ``Series`` containing
only the non-null entries.

``` python
In [75]: ss = pd.Series.sparse.from_coo(A)

In [76]: ss
Out[76]: 
0  2    1.0
   3    2.0
1  0    3.0
dtype: Sparse[float64, nan]
```

Specifying ``dense_index=True`` will result in an index that is the Cartesian product of the
row and columns coordinates of the matrix. Note that this will consume a significant amount of memory
(relative to ``dense_index=False``) if the sparse matrix is large (and sparse) enough.

``` python
In [77]: ss_dense = pd.Series.sparse.from_coo(A, dense_index=True)

In [78]: ss_dense
Out[78]: 
0  0    NaN
   1    NaN
   2    1.0
   3    2.0
1  0    3.0
   1    NaN
   2    NaN
   3    NaN
2  0    NaN
   1    NaN
   2    NaN
   3    NaN
dtype: Sparse[float64, nan]
```

## Sparse subclasses

The ``SparseSeries`` and ``SparseDataFrame`` classes are deprecated. Visit their
API pages for usage.
