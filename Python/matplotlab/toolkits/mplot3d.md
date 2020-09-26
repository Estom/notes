---
sidebarDepth: 3
sidebar: auto
---

# The mplot3d Toolkit

Generating 3D plots using the mplot3d toolkit.

Contents

- [The mplot3d Toolkit](#the-mplot3d-toolkit)
[Getting started](#getting-started)
[Line plots](#line-plots)
[Scatter plots](#scatter-plots)
[Wireframe plots](#wireframe-plots)
[Surface plots](#surface-plots)
[Tri-Surface plots](#tri-surface-plots)
[Contour plots](#contour-plots)
[Filled contour plots](#filled-contour-plots)
[Polygon plots](#polygon-plots)
[Bar plots](#bar-plots)
[Quiver](#quiver)
[2D plots in 3D](#d-plots-in-3d)
[Text](#text)
[Subplotting](#subplotting)
- [Getting started](#getting-started)
[Line plots](#line-plots)
[Scatter plots](#scatter-plots)
[Wireframe plots](#wireframe-plots)
[Surface plots](#surface-plots)
[Tri-Surface plots](#tri-surface-plots)
[Contour plots](#contour-plots)
[Filled contour plots](#filled-contour-plots)
[Polygon plots](#polygon-plots)
[Bar plots](#bar-plots)
[Quiver](#quiver)
[2D plots in 3D](#d-plots-in-3d)
[Text](#text)
[Subplotting](#subplotting)
- [Line plots](#line-plots)
- [Scatter plots](#scatter-plots)
- [Wireframe plots](#wireframe-plots)
- [Surface plots](#surface-plots)
- [Tri-Surface plots](#tri-surface-plots)
- [Contour plots](#contour-plots)
- [Filled contour plots](#filled-contour-plots)
- [Polygon plots](#polygon-plots)
- [Bar plots](#bar-plots)
- [Quiver](#quiver)
- [2D plots in 3D](#d-plots-in-3d)
- [Text](#text)
- [Subplotting](#subplotting)

## Getting started

An Axes3D object is created just like any other axes using
the projection='3d' keyword.
Create a new [``matplotlib.figure.Figure``](https://matplotlib.orgapi/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure) and
add a new axes to it of type ``Axes3D``:

``` python
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
```

*New in version 1.0.0:* This approach is the preferred method of creating a 3D axes.

::: tip Note

Prior to version 1.0.0, the method of creating a 3D axes was
different. For those using older versions of matplotlib, change
``ax = fig.add_subplot(111, projection='3d')``
to ``ax = Axes3D(fig)``.

:::

See the [mplot3d FAQ](https://matplotlib.orgapi/toolkits/mplot3d/faq.html#toolkit-mplot3d-faq) for more information about the mplot3d
toolkit.

### Line plots


``Axes3D.````plot``(*self*, *xs*, *ys*, **args*, *zdir='z'*, ***kwargs*)[[source]](https://matplotlib.org_modules/mpl_toolkits/mplot3d/axes3d.html#Axes3D.plot)[¶](#mpl_toolkits.mplot3d.Axes3D.plot)

Plot 2D or 3D data.


---



Parameters:
xs : 1D array-like
x coordinates of vertices.

ys : 1D array-like
y coordinates of vertices.

zs : scalar or 1D array-like
z coordinates of vertices; either one for all points or one for
each point.

zdir : {'x', 'y', 'z'}
When plotting 2D data, the direction to use as z ('x', 'y' or 'z');
defaults to 'z'.

**kwargs
Other arguments are forwarded to [matplotlib.axes.Axes.plot](https://matplotlib.org/../api/_as_gen/matplotlib.axes.Axes.plot.html#matplotlib.axes.Axes.plot).







Lines3d

### Scatter plots


``Axes3D.````scatter``(*self*, *xs*, *ys*, *zs=0*, *zdir='z'*, *s=20*, *c=None*, *depthshade=True*, **args*, ***kwargs*)[[source]](https://matplotlib.org_modules/mpl_toolkits/mplot3d/axes3d.html#Axes3D.scatter)[¶](#mpl_toolkits.mplot3d.Axes3D.scatter)

Create a scatter plot.


---



Parameters:
xs, ys : array-like
The data positions.

zs : float or array-like, optional, default: 0
The z-positions. Either an array of the same length as xs and
ys or a single value to place all points in the same plane.

zdir : {'x', 'y', 'z', '-x', '-y', '-z'}, optional, default: 'z'
The axis direction for the zs. This is useful when plotting 2D
data on a 3D Axes. The data must be passed as xs, ys. Setting
zdir to 'y' then plots the data to the x-z-plane.
See also [Plot 2D data on 3D plot](https://matplotlib.org/../gallery/mplot3d/2dcollections3d.html).

s : scalar or array-like, optional, default: 20
The marker size in points**2. Either an array of the same length
as xs and ys or a single value to make all markers the same
size.

c : color, sequence, or sequence of color, optional
The marker color. Possible values:

A single color format string.
A sequence of color specifications of length n.
A sequence of n numbers to be mapped to colors using cmap and
norm.
A 2-D array in which the rows are RGB or RGBA.

For more details see the c argument of [[scatter](https://matplotlib.org/../api/_as_gen/matplotlib.axes.Axes.scatter.html#matplotlib.axes.Axes.scatter)](https://matplotlib.org/../api/_as_gen/matplotlib.axes.Axes.scatter.html#matplotlib.axes.Axes.scatter).

depthshade : bool, optional, default: True
Whether to shade the scatter markers to give the appearance of
depth.

**kwargs
All other arguments are passed on to scatter.




Returns:
paths : [PathCollection](https://matplotlib.org/../api/collections_api.html#matplotlib.collections.PathCollection)







Scatter3d

### Wireframe plots


``Axes3D.````plot_wireframe``(*self*, *X*, *Y*, *Z*, **args*, ***kwargs*)[[source]](https://matplotlib.org_modules/mpl_toolkits/mplot3d/axes3d.html#Axes3D.plot_wireframe)[¶](#mpl_toolkits.mplot3d.Axes3D.plot_wireframe)

Plot a 3D wireframe.

::: tip Note

The *rcount* and *ccount* kwargs, which both default to 50,
determine the maximum number of samples used in each direction. If
the input data is larger, it will be downsampled (by slicing) to
these numbers of points.

:::


---



Parameters:
X, Y, Z : 2d arrays
Data values.

rcount, ccount : int
Maximum number of samples used in each direction. If the input
data is larger, it will be downsampled (by slicing) to these
numbers of points. Setting a count to zero causes the data to be
not sampled in the corresponding direction, producing a 3D line
plot rather than a wireframe plot. Defaults to 50.

New in version 2.0.


rstride, cstride : int
Downsampling stride in each direction. These arguments are
mutually exclusive with rcount and ccount. If only one of
rstride or cstride is set, the other defaults to 1. Setting a
stride to zero causes the data to be not sampled in the
corresponding direction, producing a 3D line plot rather than a
wireframe plot.
'classic' mode uses a default of rstride = cstride = 1 instead
of the new default of rcount = ccount = 50.

**kwargs
Other arguments are forwarded to [Line3DCollection](https://matplotlib.org/../api/_as_gen/mpl_toolkits.mplot3d.art3d.Line3DCollection.html#mpl_toolkits.mplot3d.art3d.Line3DCollection).







Wire3d

### Surface plots


``Axes3D.````plot_surface``(*self*, *X*, *Y*, *Z*, **args*, *norm=None*, *vmin=None*, *vmax=None*, *lightsource=None*, ***kwargs*)[[source]](https://matplotlib.org_modules/mpl_toolkits/mplot3d/axes3d.html#Axes3D.plot_surface)[¶](#mpl_toolkits.mplot3d.Axes3D.plot_surface)

Create a surface plot.

By default it will be colored in shades of a solid color, but it also
supports color mapping by supplying the *cmap* argument.

::: tip Note

The *rcount* and *ccount* kwargs, which both default to 50,
determine the maximum number of samples used in each direction. If
the input data is larger, it will be downsampled (by slicing) to
these numbers of points.

:::


---



Parameters:
X, Y, Z : 2d arrays
Data values.

rcount, ccount : int
Maximum number of samples used in each direction. If the input
data is larger, it will be downsampled (by slicing) to these
numbers of points. Defaults to 50.

New in version 2.0.


rstride, cstride : int
Downsampling stride in each direction. These arguments are
mutually exclusive with rcount and ccount. If only one of
rstride or cstride is set, the other defaults to 10.
'classic' mode uses a default of rstride = cstride = 10 instead
of the new default of rcount = ccount = 50.

color : color-like
Color of the surface patches.

cmap : Colormap
Colormap of the surface patches.

facecolors : array-like of colors.
Colors of each individual patch.

norm : Normalize
Normalization for the colormap.

vmin, vmax : float
Bounds for the normalization.

shade : bool
Whether to shade the facecolors. Defaults to True. Shading is
always disabled when cmap is specified.

lightsource : [LightSource](https://matplotlib.org/../api/_as_gen/matplotlib.colors.LightSource.html#matplotlib.colors.LightSource)
The lightsource to use when shade is True.

**kwargs
Other arguments are forwarded to [Poly3DCollection](https://matplotlib.org/../api/_as_gen/mpl_toolkits.mplot3d.art3d.Poly3DCollection.html#mpl_toolkits.mplot3d.art3d.Poly3DCollection).







Surface3d

Surface3d 2

Surface3d 3

### Tri-Surface plots


``Axes3D.````plot_trisurf``(*self*, **args*, *color=None*, *norm=None*, *vmin=None*, *vmax=None*, *lightsource=None*, ***kwargs*)[[source]](https://matplotlib.org_modules/mpl_toolkits/mplot3d/axes3d.html#Axes3D.plot_trisurf)[¶](#mpl_toolkits.mplot3d.Axes3D.plot_trisurf)

Plot a triangulated surface.

The (optional) triangulation can be specified in one of two ways;
either:

``` python
plot_trisurf(triangulation, ...)
```

where triangulation is a [``Triangulation``](https://matplotlib.orgapi/tri_api.html#matplotlib.tri.Triangulation)
object, or:

``` python
plot_trisurf(X, Y, ...)
plot_trisurf(X, Y, triangles, ...)
plot_trisurf(X, Y, triangles=triangles, ...)
```

in which case a Triangulation object will be created. See
[``Triangulation``](https://matplotlib.orgapi/tri_api.html#matplotlib.tri.Triangulation) for a explanation of
these possibilities.

The remaining arguments are:

``` python
plot_trisurf(..., Z)
```

where *Z* is the array of values to contour, one per point
in the triangulation.


---



Parameters:
X, Y, Z : array-like
Data values as 1D arrays.

color
Color of the surface patches.

cmap
A colormap for the surface patches.

norm : Normalize
An instance of Normalize to map values to colors.

vmin, vmax : scalar, optional, default: None
Minimum and maximum value to map.

shade : bool
Whether to shade the facecolors. Defaults to True. Shading is
always disabled when cmap is specified.

lightsource : [LightSource](https://matplotlib.org/../api/_as_gen/matplotlib.colors.LightSource.html#matplotlib.colors.LightSource)
The lightsource to use when shade is True.

**kwargs
All other arguments are passed on to
[Poly3DCollection](https://matplotlib.org/../api/_as_gen/mpl_toolkits.mplot3d.art3d.Poly3DCollection.html#mpl_toolkits.mplot3d.art3d.Poly3DCollection)







Examples

([Source code](https://matplotlib.orggallery/mplot3d/trisurf3d.py), [png](https://matplotlib.orggallery/mplot3d/trisurf3d.png), [pdf](https://matplotlib.orggallery/mplot3d/trisurf3d.pdf))

![trisurf3d1](https://matplotlib.org/_images/trisurf3d1.png)

([Source code](https://matplotlib.orggallery/mplot3d/trisurf3d_2.py), [png](https://matplotlib.orggallery/mplot3d/trisurf3d_2.png), [pdf](https://matplotlib.orggallery/mplot3d/trisurf3d_2.pdf))

![trisurf3d_21](https://matplotlib.org/_images/trisurf3d_21.png)

*New in version 1.2.0:* This plotting function was added for the v1.2.0 release.

Trisurf3d

### Contour plots


``Axes3D.````contour``(*self*, *X*, *Y*, *Z*, **args*, *extend3d=False*, *stride=5*, *zdir='z'*, *offset=None*, ***kwargs*)[[source]](https://matplotlib.org_modules/mpl_toolkits/mplot3d/axes3d.html#Axes3D.contour)[¶](#mpl_toolkits.mplot3d.Axes3D.contour)

Create a 3D contour plot.


---



Parameters:
X, Y, Z : array-likes
Input data.

extend3d : bool
Whether to extend contour in 3D; defaults to False.

stride : int
Step size for extending contour.

zdir : {'x', 'y', 'z'}
The direction to use; defaults to 'z'.

offset : scalar
If specified, plot a projection of the contour lines at this
position in a plane normal to zdir

*args, **kwargs
Other arguments are forwarded to [matplotlib.axes.Axes.contour](https://matplotlib.org/../api/_as_gen/matplotlib.axes.Axes.contour.html#matplotlib.axes.Axes.contour).




Returns:
matplotlib.contour.QuadContourSet







Contour3d

Contour3d 2

Contour3d 3

### Filled contour plots


``Axes3D.````contourf``(*self*, *X*, *Y*, *Z*, **args*, *zdir='z'*, *offset=None*, ***kwargs*)[[source]](https://matplotlib.org_modules/mpl_toolkits/mplot3d/axes3d.html#Axes3D.contourf)[¶](#mpl_toolkits.mplot3d.Axes3D.contourf)

Create a 3D filled contour plot.


---



Parameters:
X, Y, Z : array-likes
Input data.

zdir : {'x', 'y', 'z'}
The direction to use; defaults to 'z'.

offset : scalar
If specified, plot a projection of the contour lines at this
position in a plane normal to zdir

*args, **kwargs
Other arguments are forwarded to [matplotlib.axes.Axes.contourf](https://matplotlib.org/../api/_as_gen/matplotlib.axes.Axes.contourf.html#matplotlib.axes.Axes.contourf).




Returns:
matplotlib.contour.QuadContourSet







Notes

*New in version 1.1.0:* The *zdir* and *offset* parameters.

Contourf3d

*New in version 1.1.0:* The feature demoed in the second contourf3d example was enabled as a
result of a bugfix for version 1.1.0.

### Polygon plots


``Axes3D.````add_collection3d``(*self*, *col*, *zs=0*, *zdir='z'*)[[source]](https://matplotlib.org_modules/mpl_toolkits/mplot3d/axes3d.html#Axes3D.add_collection3d)[¶](#mpl_toolkits.mplot3d.Axes3D.add_collection3d)

Add a 3D collection object to the plot.

2D collection types are converted to a 3D version by
modifying the object and adding z coordinate information.

Supported are:

- PolyCollection
- LineCollection
- PatchCollection

Polys3d

### Bar plots


``Axes3D.````bar``(*self*, *left*, *height*, *zs=0*, *zdir='z'*, **args*, ***kwargs*)[[source]](https://matplotlib.org_modules/mpl_toolkits/mplot3d/axes3d.html#Axes3D.bar)[¶](#mpl_toolkits.mplot3d.Axes3D.bar)

Add 2D bar(s).


---



Parameters:
left : 1D array-like
The x coordinates of the left sides of the bars.

height : 1D array-like
The height of the bars.

zs : scalar or 1D array-like
Z coordinate of bars; if a single value is specified, it will be
used for all bars.

zdir : {'x', 'y', 'z'}
When plotting 2D data, the direction to use as z ('x', 'y' or 'z');
defaults to 'z'.

**kwargs
Other arguments are forwarded to [matplotlib.axes.Axes.bar](https://matplotlib.org/../api/_as_gen/matplotlib.axes.Axes.bar.html#matplotlib.axes.Axes.bar).




Returns:
mpl_toolkits.mplot3d.art3d.Patch3DCollection







Bars3d

### Quiver


``Axes3D.````quiver``(*X*, *Y*, *Z*, *U*, *V*, *W*, */*, *length=1*, *arrow_length_ratio=.3*, *pivot='tail'*, *normalize=False*, ***kwargs*)[[source]](https://matplotlib.org_modules/mpl_toolkits/mplot3d/axes3d.html#Axes3D.quiver)[¶](#mpl_toolkits.mplot3d.Axes3D.quiver)

Plot a 3D field of arrows.

The arguments could be array-like or scalars, so long as they
they can be broadcast together. The arguments can also be
masked arrays. If an element in any of argument is masked, then
that corresponding quiver element will not be plotted.


---



Parameters:
X, Y, Z : array-like
The x, y and z coordinates of the arrow locations (default is
tail of arrow; see pivot kwarg)

U, V, W : array-like
The x, y and z components of the arrow vectors

length : float
The length of each quiver, default to 1.0, the unit is
the same with the axes

arrow_length_ratio : float
The ratio of the arrow head with respect to the quiver,
default to 0.3

pivot : {'tail', 'middle', 'tip'}
The part of the arrow that is at the grid point; the arrow
rotates about this point, hence the name pivot.
Default is 'tail'

normalize : bool
When True, all of the arrows will be the same length. This
defaults to False, where the arrows will be different lengths
depending on the values of u,v,w.

**kwargs
Any additional keyword arguments are delegated to
[LineCollection](https://matplotlib.org/../api/collections_api.html#matplotlib.collections.LineCollection)







Quiver3d

### 2D plots in 3D

2dcollections3d

### Text


``Axes3D.````text``(*self*, *x*, *y*, *z*, *s*, *zdir=None*, ***kwargs*)[[source]](https://matplotlib.org_modules/mpl_toolkits/mplot3d/axes3d.html#Axes3D.text)[¶](#mpl_toolkits.mplot3d.Axes3D.text)

Add text to the plot. kwargs will be passed on to Axes.text,
except for the ``zdir`` keyword, which sets the direction to be
used as the z direction.

Text3d

### Subplotting

Having multiple 3D plots in a single figure is the same
as it is for 2D plots. Also, you can have both 2D and 3D plots
in the same figure.

*New in version 1.0.0:* Subplotting 3D plots was added in v1.0.0. Earlier version can not
do this.

Subplot3d

## Download

- [Download Python source code: mplot3d.py](https://matplotlib.org/_downloads/3227f29a1f1a9db7dd710eac0e54c41e/mplot3d.py)
- [Download Jupyter notebook: mplot3d.ipynb](https://matplotlib.org/_downloads/7105a36ab795ee5c5746ba7f95602c0d/mplot3d.ipynb)
        