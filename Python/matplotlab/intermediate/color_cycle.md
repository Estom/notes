---
sidebarDepth: 3
sidebar: auto
---

# Styling with cycler

Demo of custom property-cycle settings to control colors and other style
properties for multi-line plots.

::: tip Note

More complete documentation of the ``cycler`` API can be found
[here](http://matplotlib.org/cycler/).

:::

This example demonstrates two different APIs:

1. Setting the default rc parameter specifying the property cycle.
This affects all subsequent axes (but not axes already created).
1. Setting the property cycle for a single pair of axes.

``` python
from cycler import cycler
import numpy as np
import matplotlib.pyplot as plt
```

First we'll generate some sample data, in this case, four offset sine
curves.

``` python
x = np.linspace(0, 2 * np.pi, 50)
offsets = np.linspace(0, 2 * np.pi, 4, endpoint=False)
yy = np.transpose([np.sin(x + phi) for phi in offsets])
```

Now ``yy`` has shape

``` python
print(yy.shape)
```

Out:

``` 
(50, 4)
```

So ``yy[:, i]`` will give you the ``i``-th offset sine curve. Let's set the
default ``prop_cycle`` using [``matplotlib.pyplot.rc()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.rc.html#matplotlib.pyplot.rc). We'll combine a
color cycler and a linestyle cycler by adding (``+``) two ``cycler``'s
together. See the bottom of this tutorial for more information about
combining different cyclers.

``` python
default_cycler = (cycler(color=['r', 'g', 'b', 'y']) +
                  cycler(linestyle=['-', '--', ':', '-.']))

plt.rc('lines', linewidth=4)
plt.rc('axes', prop_cycle=default_cycler)
```

Now we'll generate a figure with two axes, one on top of the other. On the
first axis, we'll plot with the default cycler. On the second axis, we'll
set the ``prop_cycle`` using [``matplotlib.axes.Axes.set_prop_cycle()``](https://matplotlib.orgapi/_as_gen/matplotlib.axes.Axes.set_prop_cycle.html#matplotlib.axes.Axes.set_prop_cycle),
which will only set the ``prop_cycle`` for this [``matplotlib.axes.Axes``](https://matplotlib.org/api/axes_api.html#matplotlib.axes.Axes)
instance. We'll use a second ``cycler`` that combines a color cycler and a
linewidth cycler.

``` python
custom_cycler = (cycler(color=['c', 'm', 'y', 'k']) +
                 cycler(lw=[1, 2, 3, 4]))

fig, (ax0, ax1) = plt.subplots(nrows=2)
ax0.plot(yy)
ax0.set_title('Set default color cycle to rgby')
ax1.set_prop_cycle(custom_cycler)
ax1.plot(yy)
ax1.set_title('Set axes color cycle to cmyk')

# Add a bit more space between the two plots.
fig.subplots_adjust(hspace=0.3)
plt.show()
```

![sphx_glr_color_cycle_001](https://matplotlib.org/_images/sphx_glr_color_cycle_001.png)

## Setting ``prop_cycle`` in the ``matplotlibrc`` file or style files

Remember, if you want to set a custom cycler in your
``.matplotlibrc`` file or a style file (``style.mplstyle``), you can set the
``axes.prop_cycle`` property:

``` python
axes.prop_cycle : cycler(color='bgrcmyk')
```

## Cycling through multiple properties

You can add cyclers:

``` python
from cycler import cycler
cc = (cycler(color=list('rgb')) +
      cycler(linestyle=['-', '--', '-.']))
for d in cc:
    print(d)
```

Results in:

``` python
{'color': 'r', 'linestyle': '-'}
{'color': 'g', 'linestyle': '--'}
{'color': 'b', 'linestyle': '-.'}
```

You can multiply cyclers:

``` python
from cycler import cycler
cc = (cycler(color=list('rgb')) *
      cycler(linestyle=['-', '--', '-.']))
for d in cc:
    print(d)
```

Results in:

``` python
{'color': 'r', 'linestyle': '-'}
{'color': 'r', 'linestyle': '--'}
{'color': 'r', 'linestyle': '-.'}
{'color': 'g', 'linestyle': '-'}
{'color': 'g', 'linestyle': '--'}
{'color': 'g', 'linestyle': '-.'}
{'color': 'b', 'linestyle': '-'}
{'color': 'b', 'linestyle': '--'}
{'color': 'b', 'linestyle': '-.'}
```

## Download

- [Download Python source code: color_cycle.py](https://matplotlib.org/_downloads/6d214f31d57999a93c8a6e18f0ce6aab/color_cycle.py)
- [Download Jupyter notebook: color_cycle.ipynb](https://matplotlib.org/_downloads/e2174f7bdc06ad628a756f14967811ee/color_cycle.ipynb)
        