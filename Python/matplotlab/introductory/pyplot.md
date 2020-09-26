---
sidebarDepth: 3
sidebar: auto
---

# Pyplot tutorial

An introduction to the pyplot interface.

## Intro to pyplot

[``matplotlib.pyplot``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.html#module-matplotlib.pyplot) is a collection of command style functions
that make matplotlib work like MATLAB.
Each ``pyplot`` function makes
some change to a figure: e.g., creates a figure, creates a plotting area
in a figure, plots some lines in a plotting area, decorates the plot
with labels, etc.

In [``matplotlib.pyplot``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.html#module-matplotlib.pyplot) various states are preserved
across function calls, so that it keeps track of things like
the current figure and plotting area, and the plotting
functions are directed to the current axes (please note that "axes" here
and in most places in the documentation refers to the *axes*
[part of a figure](usage.html#figure-parts)
and not the strict mathematical term for more than one axis).

::: tip Note

the pyplot API is generally less-flexible than the object-oriented API.
Most of the function calls you see here can also be called as methods
from an ``Axes`` object. We recommend browsing the tutorials and
examples to see how this works.

:::

Generating visualizations with pyplot is very quick:

``` python
import matplotlib.pyplot as plt
plt.plot([1, 2, 3, 4])
plt.ylabel('some numbers')
plt.show()
```

![sphx_glr_pyplot_001](https://matplotlib.org/_images/sphx_glr_pyplot_001.png)

You may be wondering why the x-axis ranges from 0-3 and the y-axis
from 1-4. If you provide a single list or array to the
[``plot()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.plot.html#matplotlib.pyplot.plot) command, matplotlib assumes it is a
sequence of y values, and automatically generates the x values for
you. Since python ranges start with 0, the default x vector has the
same length as y but starts with 0. Hence the x data are
``[0,1,2,3]``.

[``plot()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.plot.html#matplotlib.pyplot.plot) is a versatile command, and will take
an arbitrary number of arguments. For example, to plot x versus y,
you can issue the command:

``` python
plt.plot([1, 2, 3, 4], [1, 4, 9, 16])
```

![sphx_glr_pyplot_002](https://matplotlib.org/_images/sphx_glr_pyplot_002.png)

### Formatting the style of your plot

For every x, y pair of arguments, there is an optional third argument
which is the format string that indicates the color and line type of
the plot. The letters and symbols of the format string are from
MATLAB, and you concatenate a color string with a line style string.
The default format string is 'b-', which is a solid blue line. For
example, to plot the above with red circles, you would issue

``` python
plt.plot([1, 2, 3, 4], [1, 4, 9, 16], 'ro')
plt.axis([0, 6, 0, 20])
plt.show()
```

![sphx_glr_pyplot_003](https://matplotlib.org/_images/sphx_glr_pyplot_003.png)

See the [``plot()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.plot.html#matplotlib.pyplot.plot) documentation for a complete
list of line styles and format strings. The
[``axis()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.axis.html#matplotlib.pyplot.axis) command in the example above takes a
list of ``[xmin, xmax, ymin, ymax]`` and specifies the viewport of the
axes.

If matplotlib were limited to working with lists, it would be fairly
useless for numeric processing. Generally, you will use [numpy](http://www.numpy.org) arrays. In fact, all sequences are
converted to numpy arrays internally. The example below illustrates a
plotting several lines with different format styles in one command
using arrays.

``` python
import numpy as np

# evenly sampled time at 200ms intervals
t = np.arange(0., 5., 0.2)

# red dashes, blue squares and green triangles
plt.plot(t, t, 'r--', t, t**2, 'bs', t, t**3, 'g^')
plt.show()
```

![sphx_glr_pyplot_004](https://matplotlib.org/_images/sphx_glr_pyplot_004.png)

## Plotting with keyword strings

There are some instances where you have data in a format that lets you
access particular variables with strings. For example, with
[``numpy.recarray``](https://docs.scipy.org/doc/numpy/reference/generated/numpy.recarray.html#numpy.recarray) or [``pandas.DataFrame``](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html#pandas.DataFrame).

Matplotlib allows you provide such an object with
the ``data`` keyword argument. If provided, then you may generate plots with
the strings corresponding to these variables.

``` python
data = {'a': np.arange(50),
        'c': np.random.randint(0, 50, 50),
        'd': np.random.randn(50)}
data['b'] = data['a'] + 10 * np.random.randn(50)
data['d'] = np.abs(data['d']) * 100

plt.scatter('a', 'b', c='c', s='d', data=data)
plt.xlabel('entry a')
plt.ylabel('entry b')
plt.show()
```

![sphx_glr_pyplot_005](https://matplotlib.org/_images/sphx_glr_pyplot_005.png)

## Plotting with categorical variables

It is also possible to create a plot using categorical variables.
Matplotlib allows you to pass categorical variables directly to
many plotting functions. For example:

``` python
names = ['group_a', 'group_b', 'group_c']
values = [1, 10, 100]

plt.figure(figsize=(9, 3))

plt.subplot(131)
plt.bar(names, values)
plt.subplot(132)
plt.scatter(names, values)
plt.subplot(133)
plt.plot(names, values)
plt.suptitle('Categorical Plotting')
plt.show()
```

![sphx_glr_pyplot_006](https://matplotlib.org/_images/sphx_glr_pyplot_006.png)

## Controlling line properties

Lines have many attributes that you can set: linewidth, dash style,
antialiased, etc; see [``matplotlib.lines.Line2D``](https://matplotlib.orgapi/_as_gen/matplotlib.lines.Line2D.html#matplotlib.lines.Line2D). There are
several ways to set line properties

- Use keyword args:

``` python
plt.plot(x, y, linewidth=2.0)
```
- Use the setter methods of a ``Line2D`` instance. ``plot`` returns a list
of ``Line2D`` objects; e.g., ``line1, line2 = plot(x1, y1, x2, y2)``. In the code
below we will suppose that we have only
one line so that the list returned is of length 1. We use tuple unpacking with
``line,`` to get the first element of that list:

``` python
line, = plt.plot(x, y, '-')
line.set_antialiased(False) # turn off antialiasing
```
- Use the [``setp()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.setp.html#matplotlib.pyplot.setp) command. The example below
uses a MATLAB-style command to set multiple properties
on a list of lines. ``setp`` works transparently with a list of objects
or a single object. You can either use python keyword arguments or
MATLAB-style string/value pairs:

``` python
lines = plt.plot(x1, y1, x2, y2)
# use keyword args
plt.setp(lines, color='r', linewidth=2.0)
# or MATLAB style string value pairs
plt.setp(lines, 'color', 'r', 'linewidth', 2.0)
```

Here are the available [``Line2D``](https://matplotlib.orgapi/_as_gen/matplotlib.lines.Line2D.html#matplotlib.lines.Line2D) properties.


---





Property
Value Type


```
alpha
float

animated
[True | False]

antialiased or aa
[True | False]

clip_box
a matplotlib.transform.Bbox instance

clip_on
[True | False]

clip_path
a Path instance and a Transform instance, a Patch

color or c
any matplotlib color

contains
the hit testing function

dash_capstyle
['butt' | 'round' | 'projecting']

dash_joinstyle
['miter' | 'round' | 'bevel']

dashes
sequence of on/off ink in points

data
(np.array xdata, np.array ydata)

figure
a matplotlib.figure.Figure instance

label
any string

linestyle or ls
[ '-' | '--' | '-.' | ':' | 'steps' | ...]

linewidth or lw
float value in points

marker
[ '+' | ',' | '.' | '1' | '2' | '3' | '4' ]

markeredgecolor or mec
any matplotlib color

markeredgewidth or mew
float value in points

markerfacecolor or mfc
any matplotlib color

markersize or ms
float

markevery
[ None | integer | (startind, stride) ]

picker
used in interactive line selection

pickradius
the line pick selection radius

solid_capstyle
['butt' | 'round' | 'projecting']

solid_joinstyle
['miter' | 'round' | 'bevel']

transform
a matplotlib.transforms.Transform instance

visible
[True | False]

xdata
np.array

ydata
np.array

zorder
any number
```



To get a list of settable line properties, call the
[``setp()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.setp.html#matplotlib.pyplot.setp) function with a line or lines
as argument

``` python
In [69]: lines = plt.plot([1, 2, 3])

In [70]: plt.setp(lines)
  alpha: float
  animated: [True | False]
  antialiased or aa: [True | False]
  ...snip
```

## Working with multiple figures and axes

MATLAB, and [``pyplot``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.html#module-matplotlib.pyplot), have the concept of the current
figure and the current axes. All plotting commands apply to the
current axes. The function [``gca()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.gca.html#matplotlib.pyplot.gca) returns the
current axes (a [``matplotlib.axes.Axes``](https://matplotlib.org/api/axes_api.html#matplotlib.axes.Axes) instance), and
[``gcf()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.gcf.html#matplotlib.pyplot.gcf) returns the current figure
([``matplotlib.figure.Figure``](https://matplotlib.orgapi/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure) instance). Normally, you don't have
to worry about this, because it is all taken care of behind the
scenes. Below is a script to create two subplots.

``` python
def f(t):
    return np.exp(-t) * np.cos(2*np.pi*t)

t1 = np.arange(0.0, 5.0, 0.1)
t2 = np.arange(0.0, 5.0, 0.02)

plt.figure()
plt.subplot(211)
plt.plot(t1, f(t1), 'bo', t2, f(t2), 'k')

plt.subplot(212)
plt.plot(t2, np.cos(2*np.pi*t2), 'r--')
plt.show()
```

![sphx_glr_pyplot_007](https://matplotlib.org/_images/sphx_glr_pyplot_007.png)

The [``figure()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.figure.html#matplotlib.pyplot.figure) command here is optional because
``figure(1)`` will be created by default, just as a ``subplot(111)``
will be created by default if you don't manually specify any axes. The
[``subplot()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.subplot.html#matplotlib.pyplot.subplot) command specifies ``numrows,
numcols, plot_number`` where ``plot_number`` ranges from 1 to
``numrows*numcols``. The commas in the ``subplot`` command are
optional if ``numrows*numcols<10``. So ``subplot(211)`` is identical
to ``subplot(2, 1, 1)``.

You can create an arbitrary number of subplots
and axes. If you want to place an axes manually, i.e., not on a
rectangular grid, use the [``axes()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.axes.html#matplotlib.pyplot.axes) command,
which allows you to specify the location as ``axes([left, bottom,
width, height])`` where all values are in fractional (0 to 1)
coordinates. See [Axes Demo](https://matplotlib.orggallery/subplots_axes_and_figures/axes_demo.html) for an example of
placing axes manually and [Basic Subplot Demo](https://matplotlib.orggallery/subplots_axes_and_figures/subplot_demo.html) for an
example with lots of subplots.

You can create multiple figures by using multiple
[``figure()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.figure.html#matplotlib.pyplot.figure) calls with an increasing figure
number. Of course, each figure can contain as many axes and subplots
as your heart desires:

``` python
import matplotlib.pyplot as plt
plt.figure(1)                # the first figure
plt.subplot(211)             # the first subplot in the first figure
plt.plot([1, 2, 3])
plt.subplot(212)             # the second subplot in the first figure
plt.plot([4, 5, 6])


plt.figure(2)                # a second figure
plt.plot([4, 5, 6])          # creates a subplot(111) by default

plt.figure(1)                # figure 1 current; subplot(212) still current
plt.subplot(211)             # make subplot(211) in figure1 current
plt.title('Easy as 1, 2, 3') # subplot 211 title
```

You can clear the current figure with [``clf()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.clf.html#matplotlib.pyplot.clf)
and the current axes with [``cla()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.cla.html#matplotlib.pyplot.cla). If you find
it annoying that states (specifically the current image, figure and axes)
are being maintained for you behind the scenes, don't despair: this is just a thin
stateful wrapper around an object oriented API, which you can use
instead (see [Artist tutorial](https://matplotlib.org/intermediate/artists.html))

If you are making lots of figures, you need to be aware of one
more thing: the memory required for a figure is not completely
released until the figure is explicitly closed with
[``close()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.close.html#matplotlib.pyplot.close). Deleting all references to the
figure, and/or using the window manager to kill the window in which
the figure appears on the screen, is not enough, because pyplot
maintains internal references until [``close()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.close.html#matplotlib.pyplot.close)
is called.

## Working with text

The [``text()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.text.html#matplotlib.pyplot.text) command can be used to add text in
an arbitrary location, and the [``xlabel()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.xlabel.html#matplotlib.pyplot.xlabel),
[``ylabel()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.ylabel.html#matplotlib.pyplot.ylabel) and [``title()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.title.html#matplotlib.pyplot.title)
are used to add text in the indicated locations (see [Text in Matplotlib Plots](https://matplotlib.org/text/text_intro.html)
for a more detailed example)

``` python
mu, sigma = 100, 15
x = mu + sigma * np.random.randn(10000)

# the histogram of the data
n, bins, patches = plt.hist(x, 50, density=1, facecolor='g', alpha=0.75)


plt.xlabel('Smarts')
plt.ylabel('Probability')
plt.title('Histogram of IQ')
plt.text(60, .025, r'$\mu=100,\ \sigma=15$')
plt.axis([40, 160, 0, 0.03])
plt.grid(True)
plt.show()
```

![sphx_glr_pyplot_008](https://matplotlib.org/_images/sphx_glr_pyplot_008.png)

All of the [``text()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.text.html#matplotlib.pyplot.text) commands return an
[``matplotlib.text.Text``](https://matplotlib.orgapi/text_api.html#matplotlib.text.Text) instance. Just as with with lines
above, you can customize the properties by passing keyword arguments
into the text functions or using [``setp()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.setp.html#matplotlib.pyplot.setp):

``` python
t = plt.xlabel('my data', fontsize=14, color='red')
```

These properties are covered in more detail in [Text properties and layout](https://matplotlib.org/text/text_props.html).

### Using mathematical expressions in text

matplotlib accepts TeX equation expressions in any text expression.
For example to write the expression \(\sigma_i=15\) in the title,
you can write a TeX expression surrounded by dollar signs:

``` python
plt.title(r'$\sigma_i=15$')
```

The ``r`` preceding the title string is important -- it signifies
that the string is a *raw* string and not to treat backslashes as
python escapes. matplotlib has a built-in TeX expression parser and
layout engine, and ships its own math fonts -- for details see
[Writing mathematical expressions](https://matplotlib.org/text/mathtext.html). Thus you can use mathematical text across platforms
without requiring a TeX installation. For those who have LaTeX and
dvipng installed, you can also use LaTeX to format your text and
incorporate the output directly into your display figures or saved
postscript -- see [Text rendering With LaTeX](https://matplotlib.org/text/usetex.html).

### Annotating text

The uses of the basic [``text()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.text.html#matplotlib.pyplot.text) command above
place text at an arbitrary position on the Axes. A common use for
text is to annotate some feature of the plot, and the
[``annotate()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.annotate.html#matplotlib.pyplot.annotate) method provides helper
functionality to make annotations easy. In an annotation, there are
two points to consider: the location being annotated represented by
the argument ``xy`` and the location of the text ``xytext``. Both of
these arguments are ``(x,y)`` tuples.

``` python
ax = plt.subplot(111)

t = np.arange(0.0, 5.0, 0.01)
s = np.cos(2*np.pi*t)
line, = plt.plot(t, s, lw=2)

plt.annotate('local max', xy=(2, 1), xytext=(3, 1.5),
             arrowprops=dict(facecolor='black', shrink=0.05),
             )

plt.ylim(-2, 2)
plt.show()
```

![sphx_glr_pyplot_009](https://matplotlib.org/_images/sphx_glr_pyplot_009.png)

In this basic example, both the ``xy`` (arrow tip) and ``xytext``
locations (text location) are in data coordinates. There are a
variety of other coordinate systems one can choose -- see
[Basic annotation](https://matplotlib.org/text/annotations.html#annotations-tutorial) and [Advanced Annotation](https://matplotlib.org/text/annotations.html#plotting-guide-annotation) for
details. More examples can be found in
[Annotating Plots](https://matplotlib.orggallery/text_labels_and_annotations/annotation_demo.html).

## Logarithmic and other nonlinear axes

[``matplotlib.pyplot``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.html#module-matplotlib.pyplot) supports not only linear axis scales, but also
logarithmic and logit scales. This is commonly used if data spans many orders
of magnitude. Changing the scale of an axis is easy:

An example of four plots with the same data and different scales for the y axis
is shown below.

``` python
from matplotlib.ticker import NullFormatter  # useful for `logit` scale

# Fixing random state for reproducibility
np.random.seed(19680801)

# make up some data in the interval ]0, 1[
y = np.random.normal(loc=0.5, scale=0.4, size=1000)
y = y[(y > 0) & (y < 1)]
y.sort()
x = np.arange(len(y))

# plot with various axes scales
plt.figure()

# linear
plt.subplot(221)
plt.plot(x, y)
plt.yscale('linear')
plt.title('linear')
plt.grid(True)


# log
plt.subplot(222)
plt.plot(x, y)
plt.yscale('log')
plt.title('log')
plt.grid(True)


# symmetric log
plt.subplot(223)
plt.plot(x, y - y.mean())
plt.yscale('symlog', linthreshy=0.01)
plt.title('symlog')
plt.grid(True)

# logit
plt.subplot(224)
plt.plot(x, y)
plt.yscale('logit')
plt.title('logit')
plt.grid(True)
# Format the minor tick labels of the y-axis into empty strings with
# `NullFormatter`, to avoid cumbering the axis with too many labels.
plt.gca().yaxis.set_minor_formatter(NullFormatter())
# Adjust the subplot layout, because the logit one may take more space
# than usual, due to y-tick labels like "1 - 10^{-3}"
plt.subplots_adjust(top=0.92, bottom=0.08, left=0.10, right=0.95, hspace=0.25,
                    wspace=0.35)

plt.show()
```

![sphx_glr_pyplot_010](https://matplotlib.org/_images/sphx_glr_pyplot_010.png)

It is also possible to add your own scale, see [Developer's guide for creating scales and transformations](https://matplotlib.orgdevel/add_new_projection.html#adding-new-scales) for
details.

**Total running time of the script:** ( 0 minutes 1.262 seconds)

## Download

- [Download Python source code: pyplot.py](https://matplotlib.org/_downloads/2dc0b600c5a44dd0a9ee2d1b44a67235/pyplot.py)
- [Download Jupyter notebook: pyplot.ipynb](https://matplotlib.org/_downloads/a5d09473b82821f8a7203a3d071d953a/pyplot.ipynb)
        