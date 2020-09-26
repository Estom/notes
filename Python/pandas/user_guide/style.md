# Styling

*New in version 0.17.1*

Provisional: This is a new feature and still under development. We’ll be adding features and possibly making breaking changes in future releases. We’d love to hear your feedback.

This document is written as a Jupyter Notebook, and can be viewed or downloaded [here](http://nbviewer.ipython.org/github/pandas-dev/pandas/blob/master/doc/source/style.ipynb).

You can apply **conditional formatting**, the visual styling of a DataFrame depending on the data within, by using the ``DataFrame.style`` property. This is a property that returns a ``Styler`` object, which has useful methods for formatting and displaying DataFrames.

The styling is accomplished using CSS. You write “style functions” that take scalars, ``DataFrame``s or ``Series``, and return *like-indexed* DataFrames or Series with CSS ``"attribute: value"`` pairs for the values. These functions can be incrementally passed to the ``Styler`` which collects the styles before rendering.

## Building styles

Pass your style functions into one of the following methods:

- ``Styler.applymap``: elementwise
- ``Styler.apply``: column-/row-/table-wise

Both of those methods take a function (and some other keyword arguments) and applies your function to the DataFrame in a certain way. ``Styler.applymap`` works through the DataFrame elementwise. ``Styler.apply`` passes each column or row into your DataFrame one-at-a-time or the entire table at once, depending on the ``axis`` keyword argument. For columnwise use ``axis=0``, rowwise use ``axis=1``, and for the entire table at once use ``axis=None``.

For ``Styler.applymap`` your function should take a scalar and return a single string with the CSS attribute-value pair.

For ``Styler.apply`` your function should take a Series or DataFrame (depending on the axis parameter), and return a Series or DataFrame with an identical shape where each value is a string with a CSS attribute-value pair.

Let’s see some examples.

![style02](https://static.pypandas.cn/public/static/images/style/user_guide_style_02.png)

Here’s a boring example of rendering a DataFrame, without any (visible) styles:

![style03](https://static.pypandas.cn/public/static/images/style/user_guide_style_03.png)

*Note*: The ``DataFrame.style`` attribute is a property that returns a ``Styler`` object. ``Styler`` has a ``_repr_html_`` method defined on it so they are rendered automatically. If you want the actual HTML back for further processing or for writing to file call the ``.render()`` method which returns a string.

The above output looks very similar to the standard DataFrame HTML representation. But we’ve done some work behind the scenes to attach CSS classes to each cell. We can view these by calling the ``.render`` method.

``` javascript
df.style.highlight_null().render().split('\n')[:10]
```

``` javascript
['<style  type="text/css" >',
 '    #T_acfc12d6_a988_11e9_a75e_31802e421a9brow0_col2 {',
 '            background-color:  red;',
 '        }</style><table id="T_acfc12d6_a988_11e9_a75e_31802e421a9b" ><thead>    <tr>        <th class="blank level0" ></th>        <th class="col_heading level0 col0" >A</th>        <th class="col_heading level0 col1" >B</th>        <th class="col_heading level0 col2" >C</th>        <th class="col_heading level0 col3" >D</th>        <th class="col_heading level0 col4" >E</th>    </tr></thead><tbody>',
 '                <tr>',
 '                        <th id="T_acfc12d6_a988_11e9_a75e_31802e421a9blevel0_row0" class="row_heading level0 row0" >0</th>',
 '                        <td id="T_acfc12d6_a988_11e9_a75e_31802e421a9brow0_col0" class="data row0 col0" >1</td>',
 '                        <td id="T_acfc12d6_a988_11e9_a75e_31802e421a9brow0_col1" class="data row0 col1" >1.32921</td>',
 '                        <td id="T_acfc12d6_a988_11e9_a75e_31802e421a9brow0_col2" class="data row0 col2" >nan</td>',
 '                        <td id="T_acfc12d6_a988_11e9_a75e_31802e421a9brow0_col3" class="data row0 col3" >-0.31628</td>']
```

The ``row0_col2`` is the identifier for that particular cell. We’ve also prepended each row/column identifier with a UUID unique to each DataFrame so that the style from one doesn’t collide with the styling from another within the same notebook or page (you can set the ``uuid`` if you’d like to tie together the styling of two DataFrames).

When writing style functions, you take care of producing the CSS attribute / value pairs you want. Pandas matches those up with the CSS classes that identify each cell.

Let’s write a simple style function that will color negative numbers red and positive numbers black.

![style04](https://static.pypandas.cn/public/static/images/style/user_guide_style_04.png)

In this case, the cell’s style depends only on it’s own value. That means we should use the ``Styler.applymap`` method which works elementwise.

![style05](https://static.pypandas.cn/public/static/images/style/user_guide_style_05.png)

Notice the similarity with the standard ``df.applymap``, which operates on DataFrames elementwise. We want you to be able to reuse your existing knowledge of how to interact with DataFrames.

Notice also that our function returned a string containing the CSS attribute and value, separated by a colon just like in a ```` tag. This will be a common theme.</p>

Finally, the input shapes matched. ``Styler.applymap`` calls the function on each scalar input, and the function returns a scalar output.

Now suppose you wanted to highlight the maximum value in each column. We can’t use ``.applymap`` anymore since that operated elementwise. Instead, we’ll turn to ``.apply`` which operates columnwise (or rowwise using the ``axis`` keyword). Later on we’ll see that something like ``highlight_max`` is already defined on ``Styler`` so you wouldn’t need to write this yourself.

![style06](https://static.pypandas.cn/public/static/images/style/user_guide_style_06.png)

In this case the input is a ``Series``, one column at a time. Notice that the output shape of ``highlight_max`` matches the input shape, an array with ``len(s)`` items.

We encourage you to use method chains to build up a style piecewise, before finally rending at the end of the chain.

![style07](https://static.pypandas.cn/public/static/images/style/user_guide_style_07.png)

Above we used ``Styler.apply`` to pass in each column one at a time.

Debugging Tip: If you’re having trouble writing your style function, try just passing it into DataFrame.apply. Internally, Styler.apply uses DataFrame.apply so the result should be the same.

What if you wanted to highlight just the maximum value in the entire table? Use ``.apply(function, axis=None)`` to indicate that your function wants the entire table, not one column or row at a time. Let’s try that next.

We’ll rewrite our ``highlight-max`` to handle either Series (from ``.apply(axis=0 or 1)``) or DataFrames (from ``.apply(axis=None)``). We’ll also allow the color to be adjustable, to demonstrate that ``.apply``, and ``.applymap`` pass along keyword arguments.

![style08](https://static.pypandas.cn/public/static/images/style/user_guide_style_08.png)

When using ``Styler.apply(func, axis=None)``, the function must return a DataFrame with the same index and column labels.

![style09](https://static.pypandas.cn/public/static/images/style/user_guide_style_09.png)

### Building Styles Summary

Style functions should return strings with one or more CSS ``attribute: value`` delimited by semicolons. Use

- ``Styler.applymap(func)`` for elementwise styles
- ``Styler.apply(func, axis=0)`` for columnwise styles
- ``Styler.apply(func, axis=1)`` for rowwise styles
- ``Styler.apply(func, axis=None)`` for tablewise styles

And crucially the input and output shapes of ``func`` must match. If ``x`` is the input then ``func(x).shape == x.shape``.

## Finer control: slicing

Both ``Styler.apply``, and ``Styler.applymap`` accept a ``subset`` keyword. This allows you to apply styles to specific rows or columns, without having to code that logic into your ``style`` function.

The value passed to ``subset`` behaves similar to slicing a DataFrame.

- A scalar is treated as a column label
- A list (or series or numpy array)
- A tuple is treated as ``(row_indexer, column_indexer)``

Consider using ``pd.IndexSlice`` to construct the tuple for the last one.

![style10](https://static.pypandas.cn/public/static/images/style/user_guide_style_10.png)

For row and column slicing, any valid indexer to ``.loc`` will work.

![style11](https://static.pypandas.cn/public/static/images/style/user_guide_style_11.png)

Only label-based slicing is supported right now, not positional.

If your style function uses a ``subset`` or ``axis`` keyword argument, consider wrapping your function in a ``functools.partial``, partialing out that keyword.

``` python
my_func2 = functools.partial(my_func, subset=42)
```

## Finer Control: Display Values

We distinguish the *display* value from the *actual* value in ``Styler``. To control the display value, the text is printed in each cell, use ``Styler.format``. Cells can be formatted according to a [format spec string](https://docs.python.org/3/library/string.html#format-specification-mini-language) or a callable that takes a single value and returns a string.

![style12](https://static.pypandas.cn/public/static/images/style/user_guide_style_12.png)

Use a dictionary to format specific columns.

![style13](https://static.pypandas.cn/public/static/images/style/user_guide_style_13.png)

Or pass in a callable (or dictionary of callables) for more flexible handling.

![style14](https://static.pypandas.cn/public/static/images/style/user_guide_style_14.png)

## Builtin styles

Finally, we expect certain styling functions to be common enough that we’ve included a few “built-in” to the ``Styler``, so you don’t have to write them yourself.

![style15](https://static.pypandas.cn/public/static/images/style/user_guide_style_15.png)

You can create “heatmaps” with the ``background_gradient`` method. These require matplotlib, and we’ll use [Seaborn](http://stanford.edu/~mwaskom/software/seaborn/) to get a nice colormap.

``` python
import seaborn as sns

cm = sns.light_palette("green", as_cmap=True)

s = df.style.background_gradient(cmap=cm)
s

/opt/conda/envs/pandas/lib/python3.7/site-packages/matplotlib/colors.py:479: RuntimeWarning: invalid value encountered in less
  xa[xa < 0] = -1
```

![style16](https://static.pypandas.cn/public/static/images/style/user_guide_style_16.png)

``Styler.background_gradient`` takes the keyword arguments ``low`` and ``high``. Roughly speaking these extend the range of your data by ``low`` and ``high`` percent so that when we convert the colors, the colormap’s entire range isn’t used. This is useful so that you can actually read the text still.

![style17](https://static.pypandas.cn/public/static/images/style/user_guide_style_17.png)

There’s also ``.highlight_min`` and ``.highlight_max``.

![style18](https://static.pypandas.cn/public/static/images/style/user_guide_style_18.png)

Use ``Styler.set_properties`` when the style doesn’t actually depend on the values.

![style19](https://static.pypandas.cn/public/static/images/style/user_guide_style_19.png)

### Bar charts

You can include “bar charts” in your DataFrame.

![style20](https://static.pypandas.cn/public/static/images/style/user_guide_style_20.png)

New in version 0.20.0 is the ability to customize further the bar chart: You can now have the ``df.style.bar`` be centered on zero or midpoint value (in addition to the already existing way of having the min value at the left side of the cell), and you can pass a list of ``[color_negative, color_positive]``.

Here’s how you can change the above with the new ``align='mid'`` option:

![style21](https://static.pypandas.cn/public/static/images/style/user_guide_style_21.png)

The following example aims to give a highlight of the behavior of the new align options:

``` python
import pandas as pd
from IPython.display import HTML

# Test series
test1 = pd.Series([-100,-60,-30,-20], name='All Negative')
test2 = pd.Series([10,20,50,100], name='All Positive')
test3 = pd.Series([-10,-5,0,90], name='Both Pos and Neg')

head = """
<table>
    <thead>
        <th>Align</th>
        <th>All Negative</th>
        <th>All Positive</th>
        <th>Both Neg and Pos</th>
    </thead>
    </tbody>

"""

aligns = ['left','zero','mid']
for align in aligns:
    row = "<tr><th>{}</th>".format(align)
    for serie in [test1,test2,test3]:
        s = serie.copy()
        s.name=''
        row += "<td>{}</td>".format(s.to_frame().style.bar(align=align,
                                                           color=['#d65f5f', '#5fba7d'],
                                                           width=100).render()) #testn['width']
    row += '</tr>'
    head += row

head+= """
</tbody>
</table>"""


HTML(head)
```

![style22](https://static.pypandas.cn/public/static/images/style/user_guide_style_22.png)

## Sharing styles

Say you have a lovely style built up for a DataFrame, and now you want to apply the same style to a second DataFrame. Export the style with ``df1.style.export``, and import it on the second DataFrame with ``df1.style.set``

![style23](https://static.pypandas.cn/public/static/images/style/user_guide_style_23.png)

Notice that you’re able share the styles even though they’re data aware. The styles are re-evaluated on the new DataFrame they’ve been ``use``d upon.

## Other Options

You’ve seen a few methods for data-driven styling. ``Styler`` also provides a few other options for styles that don’t depend on the data.

- precision
- captions
- table-wide styles
- hiding the index or columns

Each of these can be specified in two ways:

- A keyword argument to ``Styler.__init__``
- A call to one of the ``.set_`` or ``.hide_`` methods, e.g. ``.set_caption`` or ``.hide_columns``

The best method to use depends on the context. Use the ``Styler`` constructor when building many styled DataFrames that should all share the same properties. For interactive use, the``.set_`` and ``.hide_`` methods are more convenient.

### Precision

You can control the precision of floats using pandas’ regular ``display.precision`` option.

![style24](https://static.pypandas.cn/public/static/images/style/user_guide_style_24.png)

Or through a ``set_precision`` method.

![style25](https://static.pypandas.cn/public/static/images/style/user_guide_style_25.png)

Setting the precision only affects the printed number; the full-precision values are always passed to your style functions. You can always use ``df.round(2).style`` if you’d prefer to round from the start.

### Captions

Regular table captions can be added in a few ways.

![style26](https://static.pypandas.cn/public/static/images/style/user_guide_style_26.png)

### Table styles

The next option you have are “table styles”. These are styles that apply to the table as a whole, but don’t look at the data. Certain sytlings, including pseudo-selectors like ``:hover`` can only be used this way.

![style27](https://static.pypandas.cn/public/static/images/style/user_guide_style_27.png)

``table_styles`` should be a list of dictionaries. Each dictionary should have the ``selector`` and ``props`` keys. The value for ``selector`` should be a valid CSS selector. Recall that all the styles are already attached to an ``id``, unique to each ``Styler``. This selector is in addition to that ``id``. The value for ``props`` should be a list of tuples of ``('attribute', 'value')``.

``table_styles`` are extremely flexible, but not as fun to type out by hand. We hope to collect some useful ones either in pandas, or preferable in a new package that [builds on top](#Extensibility) the tools here.

### Hiding the Index or Columns

The index can be hidden from rendering by calling ``Styler.hide_index``. Columns can be hidden from rendering by calling ``Styler.hide_columns`` and passing in the name of a column, or a slice of columns.

![style28](https://static.pypandas.cn/public/static/images/style/user_guide_style_28.png)

### CSS classes

Certain CSS classes are attached to cells.

- Index and Column names include ``index_name`` and ``level`` where ``k`` is its level in a MultiIndex
- Index label cells include
``row_heading``
``row`` where ``n`` is the numeric position of the row
``level`` where ``k`` is the level in a MultiIndex
- ``row_heading``
- ``row`` where ``n`` is the numeric position of the row
- ``level`` where ``k`` is the level in a MultiIndex
- Column label cells include
``col_heading``
``col`` where ``n`` is the numeric position of the column
``level`` where ``k`` is the level in a MultiIndex
- ``col_heading``
- ``col`` where ``n`` is the numeric position of the column
- ``level`` where ``k`` is the level in a MultiIndex
- Blank cells include ``blank``
- Data cells include ``data``

### Limitations

- DataFrame only ``(use Series.to_frame().style)``
- The index and columns must be unique
- No large repr, and performance isn’t great; this is intended for summary DataFrames
- You can only style the *values*, not the index or columns
- You can only apply styles, you can’t insert new HTML entities

Some of these will be addressed in the future.

### Terms

- Style function: a function that’s passed into ``Styler.apply`` or ``Styler.applymap`` and returns values like ``'css attribute: value'``
- Builtin style functions: style functions that are methods on ``Styler``
- table style: a dictionary with the two keys ``selector`` and ``props``. ``selector`` is the CSS selector that ``props`` will apply to. ``props`` is a list of ``(attribute, value)`` tuples. A list of table styles passed into ``Styler``.

## Fun stuff

Here are a few interesting examples.

``Styler`` interacts pretty well with widgets. If you’re viewing this online instead of running the notebook yourself, you’re missing out on interactively adjusting the color palette.

![style29](https://static.pypandas.cn/public/static/images/style/user_guide_style_29.png)

![style30](https://static.pypandas.cn/public/static/images/style/user_guide_style_30.png)

## Export to Excel

*New in version 0.20.0*

Experimental: This is a new feature and still under development. We’ll be adding features and possibly making breaking changes in future releases. We’d love to hear your feedback.

Some support is available for exporting styled ``DataFrames`` to Excel worksheets using the ``OpenPyXL`` or ``XlsxWriter`` engines. CSS2.2 properties handled include:

- ``background-color``
- ``border-style``, ``border-width``, ``border-color`` and their {``top``, ``right``, ``bottom``, ``left`` variants}
- ``color``
- ``font-family``
- ``font-style``
- ``font-weight``
- ``text-align``
- ``text-decoration``
- ``vertical-align``
- ``white-space: nowrap``
- Only CSS2 named colors and hex colors of the form ``#rgb`` or ``#rrggbb`` are currently supported.
- The following pseudo CSS properties are also available to set excel specific style properties:
``number-format``
- ``number-format``

``` python
df.style.\
    applymap(color_negative_red).\
    apply(highlight_max).\
    to_excel('styled.xlsx', engine='openpyxl')
```

A screenshot of the output:

![excel](https://static.pypandas.cn/public/static/images/style-excel.png)

## Extensibility

The core of pandas is, and will remain, its “high-performance, easy-to-use data structures”. With that in mind, we hope that ``DataFrame.style`` accomplishes two goals

- Provide an API that is pleasing to use interactively and is “good enough” for many tasks
- Provide the foundations for dedicated libraries to build on

If you build a great library on top of this, let us know and we’ll [link](http://pandas.pydata.org/pandas-docs/stable/ecosystem.html) to it.

### Subclassing

If the default template doesn’t quite suit your needs, you can subclass Styler and extend or override the template. We’ll show an example of extending the default template to insert a custom header before each table.


``` python
from jinja2 import Environment, ChoiceLoader, FileSystemLoader
from IPython.display import HTML
from pandas.io.formats.style import Styler
```

We’ll use the following template:


``` python
with open("templates/myhtml.tpl") as f:
    print(f.read())
```

Now that we’ve created a template, we need to set up a subclass of ``Styler`` that knows about it.


``` python
class MyStyler(Styler):
    env = Environment(
        loader=ChoiceLoader([
            FileSystemLoader("templates"),  # contains ours
            Styler.loader,  # the default
        ])
    )
    template = env.get_template("myhtml.tpl")
```

Notice that we include the original loader in our environment’s loader. That’s because we extend the original template, so the Jinja environment needs to be able to find it.

Now we can use that custom styler. It’s ``__init__`` takes a DataFrame.

![style31](https://static.pypandas.cn/public/static/images/style/user_guide_style_31.png)

Our custom template accepts a ``table_title`` keyword. We can provide the value in the ``.render`` method.

![style32](https://static.pypandas.cn/public/static/images/style/user_guide_style_32.png)

For convenience, we provide the ``Styler.from_custom_template`` method that does the same as the custom subclass.

![style33](https://static.pypandas.cn/public/static/images/style/user_guide_style_33.png)

Here’s the template structure:

![style34](https://static.pypandas.cn/public/static/images/style/user_guide_style_34.png)

See the template in the [GitHub repo](https://github.com/pandas-dev/pandas) for more details.
