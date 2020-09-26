---
sidebarDepth: 3
sidebar: auto
---

# Customizing Figure Layouts Using GridSpec and Other Functions

How to create grid-shaped combinations of axes.

[``subplots()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.subplots.html#matplotlib.pyplot.subplots)

[``GridSpec``](https://matplotlib.orgapi/_as_gen/matplotlib.gridspec.GridSpec.html#matplotlib.gridspec.GridSpec)

[``SubplotSpec``](https://matplotlib.orgapi/_as_gen/matplotlib.gridspec.SubplotSpec.html#matplotlib.gridspec.SubplotSpec)

[``subplot2grid()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.subplot2grid.html#matplotlib.pyplot.subplot2grid)

``` python
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
```

## Basic Quickstart Guide

These first two examples show how to create a basic 2-by-2 grid using
both [``subplots()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.subplots.html#matplotlib.pyplot.subplots) and [``gridspec``](https://matplotlib.orgapi/gridspec_api.html#module-matplotlib.gridspec).

Using [``subplots()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.subplots.html#matplotlib.pyplot.subplots) is quite simple.
It returns a [``Figure``](https://matplotlib.orgapi/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure) instance and an array of
[``Axes``](https://matplotlib.org/api/axes_api.html#matplotlib.axes.Axes) objects.

``` python
fig1, f1_axes = plt.subplots(ncols=2, nrows=2, constrained_layout=True)
```

![sphx_glr_gridspec_001](https://matplotlib.org/_images/sphx_glr_gridspec_001.png)

For a simple use case such as this, [``gridspec``](https://matplotlib.orgapi/gridspec_api.html#module-matplotlib.gridspec) is
perhaps overly verbose.
You have to create the figure and [``GridSpec``](https://matplotlib.orgapi/_as_gen/matplotlib.gridspec.GridSpec.html#matplotlib.gridspec.GridSpec)
instance separately, then pass elements of gridspec instance to the
[``add_subplot()``](https://matplotlib.orgapi/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure.add_subplot) method to create the axes
objects.
The elements of the gridspec are accessed in generally the same manner as
numpy arrays.

``` python
fig2 = plt.figure(constrained_layout=True)
spec2 = gridspec.GridSpec(ncols=2, nrows=2, figure=fig2)
f2_ax1 = fig2.add_subplot(spec2[0, 0])
f2_ax2 = fig2.add_subplot(spec2[0, 1])
f2_ax3 = fig2.add_subplot(spec2[1, 0])
f2_ax4 = fig2.add_subplot(spec2[1, 1])
```

![sphx_glr_gridspec_002](https://matplotlib.org/_images/sphx_glr_gridspec_002.png)

The power of gridspec comes in being able to create subplots that span
rows and columns. Note the
[Numpy slice](https://docs.scipy.org/doc/numpy/reference/arrays.indexing.html)
syntax for selecting the part of the gridspec each subplot will occupy.

Note that we have also used the convenience method [``Figure.add_gridspec``](https://matplotlib.orgapi/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure.add_gridspec)
instead of [``gridspec.GridSpec``](https://matplotlib.orgapi/_as_gen/matplotlib.gridspec.GridSpec.html#matplotlib.gridspec.GridSpec), potentially saving the user an import,
and keeping the namespace cleaner.

``` python
fig3 = plt.figure(constrained_layout=True)
gs = fig3.add_gridspec(3, 3)
f3_ax1 = fig3.add_subplot(gs[0, :])
f3_ax1.set_title('gs[0, :]')
f3_ax2 = fig3.add_subplot(gs[1, :-1])
f3_ax2.set_title('gs[1, :-1]')
f3_ax3 = fig3.add_subplot(gs[1:, -1])
f3_ax3.set_title('gs[1:, -1]')
f3_ax4 = fig3.add_subplot(gs[-1, 0])
f3_ax4.set_title('gs[-1, 0]')
f3_ax5 = fig3.add_subplot(gs[-1, -2])
f3_ax5.set_title('gs[-1, -2]')
```

![sphx_glr_gridspec_003](https://matplotlib.org/_images/sphx_glr_gridspec_003.png)

[``gridspec``](https://matplotlib.orgapi/gridspec_api.html#module-matplotlib.gridspec) is also indispensable for creating subplots
of different widths via a couple of methods.

The method shown here is similar to the one above and initializes a
uniform grid specification,
and then uses numpy indexing and slices to allocate multiple
"cells" for a given subplot.

``` python
fig4 = plt.figure(constrained_layout=True)
spec4 = fig4.add_gridspec(ncols=2, nrows=2)
anno_opts = dict(xy=(0.5, 0.5), xycoords='axes fraction',
                 va='center', ha='center')

f4_ax1 = fig4.add_subplot(spec4[0, 0])
f4_ax1.annotate('GridSpec[0, 0]', **anno_opts)
fig4.add_subplot(spec4[0, 1]).annotate('GridSpec[0, 1:]', **anno_opts)
fig4.add_subplot(spec4[1, 0]).annotate('GridSpec[1:, 0]', **anno_opts)
fig4.add_subplot(spec4[1, 1]).annotate('GridSpec[1:, 1:]', **anno_opts)
```

![sphx_glr_gridspec_004](https://matplotlib.org/_images/sphx_glr_gridspec_004.png)

Another option is to use the ``width_ratios`` and ``height_ratios``
parameters. These keyword arguments are lists of numbers.
Note that absolute values are meaningless, only their relative ratios
matter. That means that ``width_ratios=[2, 4, 8]`` is equivalent to
``width_ratios=[1, 2, 4]`` within equally wide figures.
For the sake of demonstration, we'll blindly create the axes within
``for`` loops since we won't need them later.

``` python
fig5 = plt.figure(constrained_layout=True)
widths = [2, 3, 1.5]
heights = [1, 3, 2]
spec5 = fig5.add_gridspec(ncols=3, nrows=3, width_ratios=widths,
                          height_ratios=heights)
for row in range(3):
    for col in range(3):
        ax = fig5.add_subplot(spec5[row, col])
        label = 'Width: {}\nHeight: {}'.format(widths[col], heights[row])
        ax.annotate(label, (0.1, 0.5), xycoords='axes fraction', va='center')
```

![sphx_glr_gridspec_005](https://matplotlib.org/_images/sphx_glr_gridspec_005.png)

Learning to use ``width_ratios`` and ``height_ratios`` is particularly
useful since the top-level function [``subplots()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.subplots.html#matplotlib.pyplot.subplots)
accepts them within the ``gridspec_kw`` parameter.
For that matter, any parameter accepted by
[``GridSpec``](https://matplotlib.orgapi/_as_gen/matplotlib.gridspec.GridSpec.html#matplotlib.gridspec.GridSpec) can be passed to
[``subplots()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.subplots.html#matplotlib.pyplot.subplots) via the ``gridspec_kw`` parameter.
This example recreates the previous figure without directly using a
gridspec instance.

``` python
gs_kw = dict(width_ratios=widths, height_ratios=heights)
fig6, f6_axes = plt.subplots(ncols=3, nrows=3, constrained_layout=True,
        gridspec_kw=gs_kw)
for r, row in enumerate(f6_axes):
    for c, ax in enumerate(row):
        label = 'Width: {}\nHeight: {}'.format(widths[c], heights[r])
        ax.annotate(label, (0.1, 0.5), xycoords='axes fraction', va='center')
```

![sphx_glr_gridspec_006](https://matplotlib.org/_images/sphx_glr_gridspec_006.png)

The ``subplots`` and ``gridspec`` methods can be combined since it is
sometimes more convenient to make most of the subplots using ``subplots``
and then remove some and combine them. Here we create a layout with
the bottom two axes in the last column combined.

``` python
fig7, f7_axs = plt.subplots(ncols=3, nrows=3)
gs = f7_axs[1, 2].get_gridspec()
# remove the underlying axes
for ax in f7_axs[1:, -1]:
    ax.remove()
axbig = fig7.add_subplot(gs[1:, -1])
axbig.annotate('Big Axes \nGridSpec[1:, -1]', (0.1, 0.5),
               xycoords='axes fraction', va='center')

fig7.tight_layout()
```

![sphx_glr_gridspec_007](https://matplotlib.org/_images/sphx_glr_gridspec_007.png)

## Fine Adjustments to a Gridspec Layout

When a GridSpec is explicitly used, you can adjust the layout
parameters of subplots that are created from the GridSpec. Note this
option is not compatible with ``constrained_layout`` or
[``Figure.tight_layout``](https://matplotlib.orgapi/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure.tight_layout) which both adjust subplot sizes to fill the
figure.

``` python
fig8 = plt.figure(constrained_layout=False)
gs1 = fig8.add_gridspec(nrows=3, ncols=3, left=0.05, right=0.48, wspace=0.05)
f8_ax1 = fig8.add_subplot(gs1[:-1, :])
f8_ax2 = fig8.add_subplot(gs1[-1, :-1])
f8_ax3 = fig8.add_subplot(gs1[-1, -1])
```

![sphx_glr_gridspec_008](https://matplotlib.org/_images/sphx_glr_gridspec_008.png)

This is similar to [``subplots_adjust()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.subplots_adjust.html#matplotlib.pyplot.subplots_adjust), but it only
affects the subplots that are created from the given GridSpec.

For example, compare the left and right sides of this figure:

``` python
fig9 = plt.figure(constrained_layout=False)
gs1 = fig9.add_gridspec(nrows=3, ncols=3, left=0.05, right=0.48,
                        wspace=0.05)
f9_ax1 = fig9.add_subplot(gs1[:-1, :])
f9_ax2 = fig9.add_subplot(gs1[-1, :-1])
f9_ax3 = fig9.add_subplot(gs1[-1, -1])

gs2 = fig9.add_gridspec(nrows=3, ncols=3, left=0.55, right=0.98,
                        hspace=0.05)
f9_ax4 = fig9.add_subplot(gs2[:, :-1])
f9_ax5 = fig9.add_subplot(gs2[:-1, -1])
f9_ax6 = fig9.add_subplot(gs2[-1, -1])
```

![sphx_glr_gridspec_009](https://matplotlib.org/_images/sphx_glr_gridspec_009.png)

## GridSpec using SubplotSpec

You can create GridSpec from the [``SubplotSpec``](https://matplotlib.orgapi/_as_gen/matplotlib.gridspec.SubplotSpec.html#matplotlib.gridspec.SubplotSpec),
in which case its layout parameters are set to that of the location of
the given SubplotSpec.

Note this is also available from the more verbose
[``gridspec.GridSpecFromSubplotSpec``](https://matplotlib.orgapi/_as_gen/matplotlib.gridspec.GridSpecFromSubplotSpec.html#matplotlib.gridspec.GridSpecFromSubplotSpec).

``` python
fig10 = plt.figure(constrained_layout=True)
gs0 = fig10.add_gridspec(1, 2)

gs00 = gs0[0].subgridspec(2, 3)
gs01 = gs0[1].subgridspec(3, 2)

for a in range(2):
    for b in range(3):
        fig10.add_subplot(gs00[a, b])
        fig10.add_subplot(gs01[b, a])
```

![sphx_glr_gridspec_010](https://matplotlib.org/_images/sphx_glr_gridspec_010.png)

## A Complex Nested GridSpec using SubplotSpec

Here's a more sophisticated example of nested GridSpec where we put
a box around each cell of the outer 4x4 grid, by hiding appropriate
spines in each of the inner 3x3 grids.

``` python
import numpy as np
from itertools import product


def squiggle_xy(a, b, c, d, i=np.arange(0.0, 2*np.pi, 0.05)):
    return np.sin(i*a)*np.cos(i*b), np.sin(i*c)*np.cos(i*d)


fig11 = plt.figure(figsize=(8, 8), constrained_layout=False)

# gridspec inside gridspec
outer_grid = fig11.add_gridspec(4, 4, wspace=0.0, hspace=0.0)

for i in range(16):
    inner_grid = outer_grid[i].subgridspec(3, 3, wspace=0.0, hspace=0.0)
    a, b = int(i/4)+1, i % 4+1
    for j, (c, d) in enumerate(product(range(1, 4), repeat=2)):
        ax = fig11.add_subplot(inner_grid[j])
        ax.plot(*squiggle_xy(a, b, c, d))
        ax.set_xticks([])
        ax.set_yticks([])
        fig11.add_subplot(ax)

all_axes = fig11.get_axes()

# show only the outside spines
for ax in all_axes:
    for sp in ax.spines.values():
        sp.set_visible(False)
    if ax.is_first_row():
        ax.spines['top'].set_visible(True)
    if ax.is_last_row():
        ax.spines['bottom'].set_visible(True)
    if ax.is_first_col():
        ax.spines['left'].set_visible(True)
    if ax.is_last_col():
        ax.spines['right'].set_visible(True)

plt.show()
```

![sphx_glr_gridspec_011](https://matplotlib.org/_images/sphx_glr_gridspec_011.png)

### References

The usage of the following functions and methods is shown in this example:

``` python
matplotlib.pyplot.subplots
matplotlib.figure.Figure.add_gridspec
matplotlib.figure.Figure.add_subplot
matplotlib.gridspec.GridSpec
matplotlib.gridspec.SubplotSpec.subgridspec
matplotlib.gridspec.GridSpecFromSubplotSpec
```

**Total running time of the script:** ( 0 minutes 8.732 seconds)

## Download

- [Download Python source code: gridspec.py](https://matplotlib.org/_downloads/54501e30d0a29665618afe715673cb41/gridspec.py)
- [Download Jupyter notebook: gridspec.ipynb](https://matplotlib.org/_downloads/0eaf234b06f4f7a6a52fa9ca11b63755/gridspec.ipynb)
        