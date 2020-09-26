---
sidebarDepth: 3
sidebar: auto
---

# The Lifecycle of a Plot

This tutorial aims to show the beginning, middle, and end of a single
visualization using Matplotlib. We'll begin with some raw data and
end by saving a figure of a customized visualization. Along the way we'll try
to highlight some neat features and best-practices using Matplotlib.

::: tip Note

This tutorial is based off of
[this excellent blog post](http://pbpython.com/effective-matplotlib.html)
by Chris Moffitt. It was transformed into this tutorial by Chris Holdgraf.

:::

## A note on the Object-Oriented API vs Pyplot

Matplotlib has two interfaces. The first is an object-oriented (OO)
interface. In this case, we utilize an instance of [``axes.Axes``](https://matplotlib.org/api/axes_api.html#matplotlib.axes.Axes)
in order to render visualizations on an instance of [``figure.Figure``](https://matplotlib.orgapi/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure).

The second is based on MATLAB and uses a state-based interface. This is
encapsulated in the ``pyplot`` module. See the [pyplot tutorials](pyplot.html) for a more in-depth look at the pyplot
interface.

Most of the terms are straightforward but the main thing to remember
is that:

- The Figure is the final image that may contain 1 or more Axes.
- The Axes represent an individual plot (don't confuse this with the word
"axis", which refers to the x/y axis of a plot).

We call methods that do the plotting directly from the Axes, which gives
us much more flexibility and power in customizing our plot.

::: tip Note

In general, try to use the object-oriented interface over the pyplot
interface.

:::

## Our data

We'll use the data from the post from which this tutorial was derived.
It contains sales information for a number of companies.

``` python
# sphinx_gallery_thumbnail_number = 10
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter

data = {'Barton LLC': 109438.50,
        'Frami, Hills and Schmidt': 103569.59,
        'Fritsch, Russel and Anderson': 112214.71,
        'Jerde-Hilpert': 112591.43,
        'Keeling LLC': 100934.30,
        'Koepp Ltd': 103660.54,
        'Kulas Inc': 137351.96,
        'Trantow-Barrows': 123381.38,
        'White-Trantow': 135841.99,
        'Will LLC': 104437.60}
group_data = list(data.values())
group_names = list(data.keys())
group_mean = np.mean(group_data)
```

## Getting started

This data is naturally visualized as a barplot, with one bar per
group. To do this with the object-oriented approach, we'll first generate
an instance of [``figure.Figure``](https://matplotlib.orgapi/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure) and
[``axes.Axes``](https://matplotlib.org/api/axes_api.html#matplotlib.axes.Axes). The Figure is like a canvas, and the Axes
is a part of that canvas on which we will make a particular visualization.

::: tip Note

Figures can have multiple axes on them. For information on how to do this,
see the [Tight Layout tutorial](https://matplotlib.org/intermediate/tight_layout_guide.html).

:::

``` python
fig, ax = plt.subplots()
```

![sphx_glr_lifecycle_001](https://matplotlib.org/_images/sphx_glr_lifecycle_001.png)

Now that we have an Axes instance, we can plot on top of it.

``` python
fig, ax = plt.subplots()
ax.barh(group_names, group_data)
```

![sphx_glr_lifecycle_002](https://matplotlib.org/_images/sphx_glr_lifecycle_002.png)

## Controlling the style

There are many styles available in Matplotlib in order to let you tailor
your visualization to your needs. To see a list of styles, we can use
``pyplot.style``.

``` python
print(plt.style.available)
```

Out:

``` 
['seaborn-dark', 'dark_background', 'seaborn-pastel', 'seaborn-colorblind', 'tableau-colorblind10', 'seaborn-notebook', 'seaborn-dark-palette', 'grayscale', 'seaborn-poster', 'seaborn', 'bmh', 'seaborn-talk', 'seaborn-ticks', '_classic_test', 'ggplot', 'seaborn-white', 'classic', 'Solarize_Light2', 'seaborn-paper', 'fast', 'fivethirtyeight', 'seaborn-muted', 'seaborn-whitegrid', 'seaborn-darkgrid', 'seaborn-bright', 'seaborn-deep']
```

You can activate a style with the following:

``` python
plt.style.use('fivethirtyeight')
```

Now let's remake the above plot to see how it looks:

``` python
fig, ax = plt.subplots()
ax.barh(group_names, group_data)
```

![sphx_glr_lifecycle_003](https://matplotlib.org/_images/sphx_glr_lifecycle_003.png)

The style controls many things, such as color, linewidths, backgrounds,
etc.

## Customizing the plot

Now we've got a plot with the general look that we want, so let's fine-tune
it so that it's ready for print. First let's rotate the labels on the x-axis
so that they show up more clearly. We can gain access to these labels
with the [``axes.Axes.get_xticklabels()``](https://matplotlib.orgapi/_as_gen/matplotlib.axes.Axes.get_xticklabels.html#matplotlib.axes.Axes.get_xticklabels) method:

``` python
fig, ax = plt.subplots()
ax.barh(group_names, group_data)
labels = ax.get_xticklabels()
```

![sphx_glr_lifecycle_004](https://matplotlib.org/_images/sphx_glr_lifecycle_004.png)

If we'd like to set the property of many items at once, it's useful to use
the [``pyplot.setp()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.setp.html#matplotlib.pyplot.setp) function. This will take a list (or many lists) of
Matplotlib objects, and attempt to set some style element of each one.

``` python
fig, ax = plt.subplots()
ax.barh(group_names, group_data)
labels = ax.get_xticklabels()
plt.setp(labels, rotation=45, horizontalalignment='right')
```

![sphx_glr_lifecycle_005](https://matplotlib.org/_images/sphx_glr_lifecycle_005.png)

It looks like this cut off some of the labels on the bottom. We can
tell Matplotlib to automatically make room for elements in the figures
that we create. To do this we'll set the ``autolayout`` value of our
rcParams. For more information on controlling the style, layout, and
other features of plots with rcParams, see
[Customizing Matplotlib with style sheets and rcParams](customizing.html).

``` python
plt.rcParams.update({'figure.autolayout': True})

fig, ax = plt.subplots()
ax.barh(group_names, group_data)
labels = ax.get_xticklabels()
plt.setp(labels, rotation=45, horizontalalignment='right')
```

![sphx_glr_lifecycle_006](https://matplotlib.org/_images/sphx_glr_lifecycle_006.png)

Next, we'll add labels to the plot. To do this with the OO interface,
we can use the [``axes.Axes.set()``](https://matplotlib.orgapi/_as_gen/matplotlib.axes.Axes.set.html#matplotlib.axes.Axes.set) method to set properties of this
Axes object.

``` python
fig, ax = plt.subplots()
ax.barh(group_names, group_data)
labels = ax.get_xticklabels()
plt.setp(labels, rotation=45, horizontalalignment='right')
ax.set(xlim=[-10000, 140000], xlabel='Total Revenue', ylabel='Company',
       title='Company Revenue')
```

![sphx_glr_lifecycle_007](https://matplotlib.org/_images/sphx_glr_lifecycle_007.png)

We can also adjust the size of this plot using the [``pyplot.subplots()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.subplots.html#matplotlib.pyplot.subplots)
function. We can do this with the ``figsize`` kwarg.

::: tip Note

While indexing in NumPy follows the form (row, column), the figsize
kwarg follows the form (width, height). This follows conventions in
visualization, which unfortunately are different from those of linear
algebra.

:::

``` python
fig, ax = plt.subplots(figsize=(8, 4))
ax.barh(group_names, group_data)
labels = ax.get_xticklabels()
plt.setp(labels, rotation=45, horizontalalignment='right')
ax.set(xlim=[-10000, 140000], xlabel='Total Revenue', ylabel='Company',
       title='Company Revenue')
```

![sphx_glr_lifecycle_008](https://matplotlib.org/_images/sphx_glr_lifecycle_008.png)

For labels, we can specify custom formatting guidelines in the form of
functions by using the [``ticker.FuncFormatter``](https://matplotlib.orgapi/ticker_api.html#matplotlib.ticker.FuncFormatter) class. Below we'll
define a function that takes an integer as input, and returns a string
as an output.

``` python
def currency(x, pos):
    """The two args are the value and tick position"""
    if x >= 1e6:
        s = '${:1.1f}M'.format(x*1e-6)
    else:
        s = '${:1.0f}K'.format(x*1e-3)
    return s

formatter = FuncFormatter(currency)
```

We can then apply this formatter to the labels on our plot. To do this,
we'll use the ``xaxis`` attribute of our axis. This lets you perform
actions on a specific axis on our plot.

``` python
fig, ax = plt.subplots(figsize=(6, 8))
ax.barh(group_names, group_data)
labels = ax.get_xticklabels()
plt.setp(labels, rotation=45, horizontalalignment='right')

ax.set(xlim=[-10000, 140000], xlabel='Total Revenue', ylabel='Company',
       title='Company Revenue')
ax.xaxis.set_major_formatter(formatter)
```

![sphx_glr_lifecycle_009](https://matplotlib.org/_images/sphx_glr_lifecycle_009.png)

## Combining multiple visualizations

It is possible to draw multiple plot elements on the same instance of
[``axes.Axes``](https://matplotlib.org/api/axes_api.html#matplotlib.axes.Axes). To do this we simply need to call another one of
the plot methods on that axes object.

``` python
fig, ax = plt.subplots(figsize=(8, 8))
ax.barh(group_names, group_data)
labels = ax.get_xticklabels()
plt.setp(labels, rotation=45, horizontalalignment='right')

# Add a vertical line, here we set the style in the function call
ax.axvline(group_mean, ls='--', color='r')

# Annotate new companies
for group in [3, 5, 8]:
    ax.text(145000, group, "New Company", fontsize=10,
            verticalalignment="center")

# Now we'll move our title up since it's getting a little cramped
ax.title.set(y=1.05)

ax.set(xlim=[-10000, 140000], xlabel='Total Revenue', ylabel='Company',
       title='Company Revenue')
ax.xaxis.set_major_formatter(formatter)
ax.set_xticks([0, 25e3, 50e3, 75e3, 100e3, 125e3])
fig.subplots_adjust(right=.1)

plt.show()
```

![sphx_glr_lifecycle_010](https://matplotlib.org/_images/sphx_glr_lifecycle_010.png)

## Saving our plot

Now that we're happy with the outcome of our plot, we want to save it to
disk. There are many file formats we can save to in Matplotlib. To see
a list of available options, use:

``` python
print(fig.canvas.get_supported_filetypes())
```

Out:

``` 
{'ps': 'Postscript', 'eps': 'Encapsulated Postscript', 'pdf': 'Portable Document Format', 'pgf': 'PGF code for LaTeX', 'png': 'Portable Network Graphics', 'raw': 'Raw RGBA bitmap', 'rgba': 'Raw RGBA bitmap', 'svg': 'Scalable Vector Graphics', 'svgz': 'Scalable Vector Graphics', 'jpg': 'Joint Photographic Experts Group', 'jpeg': 'Joint Photographic Experts Group', 'tif': 'Tagged Image File Format', 'tiff': 'Tagged Image File Format'}
```

We can then use the [``figure.Figure.savefig()``](https://matplotlib.orgapi/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure.savefig) in order to save the figure
to disk. Note that there are several useful flags we'll show below:

- ``transparent=True`` makes the background of the saved figure transparent
if the format supports it.
- ``dpi=80`` controls the resolution (dots per square inch) of the output.
- ``bbox_inches="tight"`` fits the bounds of the figure to our plot.

``` python
# Uncomment this line to save the figure.
# fig.savefig('sales.png', transparent=False, dpi=80, bbox_inches="tight")
```

**Total running time of the script:** ( 0 minutes 1.566 seconds)

## Download

- [Download Python source code: lifecycle.py](https://matplotlib.org/_downloads/9f5af95225ff5984a6cc962463c43459/lifecycle.py)
- [Download Jupyter notebook: lifecycle.ipynb](https://matplotlib.org/_downloads/db19d93870c5df97263c5f5a2e835466/lifecycle.ipynb)
        