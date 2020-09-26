---
sidebarDepth: 3
sidebar: auto
---

# Annotations

Annotating text with Matplotlib.

Table of Contents

- [Annotations](#annotations)
- [Basic annotation](#basic-annotation)
- [Advanced Annotation](#advanced-annotation)
[Annotating with Text with Box](#annotating-with-text-with-box)
[Annotating with Arrow](#annotating-with-arrow)
[Placing Artist at the anchored location of the Axes](#placing-artist-at-the-anchored-location-of-the-axes)
[Using Complex Coordinates with Annotations](#using-complex-coordinates-with-annotations)
[Using ConnectionPatch](#using-connectionpatch)
[Advanced Topics](#advanced-topics)


[Zoom effect between Axes](#zoom-effect-between-axes)
[Define Custom BoxStyle](#define-custom-boxstyle)
- [Annotating with Text with Box](#annotating-with-text-with-box)
- [Annotating with Arrow](#annotating-with-arrow)
- [Placing Artist at the anchored location of the Axes](#placing-artist-at-the-anchored-location-of-the-axes)
- [Using Complex Coordinates with Annotations](#using-complex-coordinates-with-annotations)
- [Using ConnectionPatch](#using-connectionpatch)
[Advanced Topics](#advanced-topics)
- [Advanced Topics](#advanced-topics)
- [Zoom effect between Axes](#zoom-effect-between-axes)
- [Define Custom BoxStyle](#define-custom-boxstyle)
# Basic annotation

The uses of the basic [``text()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.text.html#matplotlib.pyplot.text) will place text
at an arbitrary position on the Axes. A common use case of text is to
annotate some feature of the plot, and the
``annotate()`` method provides helper functionality
to make annotations easy. In an annotation, there are two points to
consider: the location being annotated represented by the argument
``xy`` and the location of the text ``xytext``. Both of these
arguments are ``(x,y)`` tuples.

Annotation Basic

In this example, both the ``xy`` (arrow tip) and ``xytext`` locations
(text location) are in data coordinates. There are a variety of other
coordinate systems one can choose -- you can specify the coordinate
system of ``xy`` and ``xytext`` with one of the following strings for
``xycoords`` and ``textcoords`` (default is 'data')


---





argument
coordinate system



'figure points'
points from the lower left corner of the figure

'figure pixels'
pixels from the lower left corner of the figure

'figure fraction'
0,0 is lower left of figure and 1,1 is upper right

'axes points'
points from lower left corner of axes

'axes pixels'
pixels from lower left corner of axes

'axes fraction'
0,0 is lower left of axes and 1,1 is upper right

'data'
use the axes data coordinate system




For example to place the text coordinates in fractional axes
coordinates, one could do:

``` python
ax.annotate('local max', xy=(3, 1),  xycoords='data',
            xytext=(0.8, 0.95), textcoords='axes fraction',
            arrowprops=dict(facecolor='black', shrink=0.05),
            horizontalalignment='right', verticalalignment='top',
            )
```

For physical coordinate systems (points or pixels) the origin is the
bottom-left of the figure or axes.

Optionally, you can enable drawing of an arrow from the text to the annotated
point by giving a dictionary of arrow properties in the optional keyword
argument ``arrowprops``.


---





arrowprops key
description



width
the width of the arrow in points

frac
the fraction of the arrow length occupied by the head

headwidth
the width of the base of the arrow head in points

shrink
move the tip and base some percent away from
the annotated point and text

**kwargs
any key for [matplotlib.patches.Polygon](https://matplotlib.org/../api/_as_gen/matplotlib.patches.Polygon.html#matplotlib.patches.Polygon),
e.g., facecolor




In the example below, the ``xy`` point is in native coordinates
(``xycoords`` defaults to 'data'). For a polar axes, this is in
(theta, radius) space. The text in this example is placed in the
fractional figure coordinate system. [``matplotlib.text.Text``](https://matplotlib.orgapi/text_api.html#matplotlib.text.Text)
keyword args like ``horizontalalignment``, ``verticalalignment`` and
``fontsize`` are passed from ``annotate`` to the
``Text`` instance.

Annotation Polar

For more on all the wild and wonderful things you can do with
annotations, including fancy arrows, see [Advanced Annotation](#plotting-guide-annotation)
and [Annotating Plots](https://matplotlib.orggallery/text_labels_and_annotations/annotation_demo.html).

Do not proceed unless you have already read [Basic annotation](#annotations-tutorial),
[``text()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.text.html#matplotlib.pyplot.text) and [``annotate()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.annotate.html#matplotlib.pyplot.annotate)!
# Advanced Annotation

## Annotating with Text with Box

Let's start with a simple example.

Annotate Text Arrow

The [``text()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.text.html#matplotlib.pyplot.text) function in the pyplot module (or
text method of the Axes class) takes bbox keyword argument, and when
given, a box around the text is drawn.

``` python
bbox_props = dict(boxstyle="rarrow,pad=0.3", fc="cyan", ec="b", lw=2)
t = ax.text(0, 0, "Direction", ha="center", va="center", rotation=45,
            size=15,
            bbox=bbox_props)
```

The patch object associated with the text can be accessed by:

``` python
bb = t.get_bbox_patch()
```

The return value is an instance of FancyBboxPatch and the patch
properties like facecolor, edgewidth, etc. can be accessed and
modified as usual. To change the shape of the box, use the *set_boxstyle*
method.

``` python
bb.set_boxstyle("rarrow", pad=0.6)
```

The arguments are the name of the box style with its attributes as
keyword arguments. Currently, following box styles are implemented.


---






Class
Name
Attrs



Circle
circle
pad=0.3

DArrow
darrow
pad=0.3

LArrow
larrow
pad=0.3

RArrow
rarrow
pad=0.3

Round
round
pad=0.3,rounding_size=None

Round4
round4
pad=0.3,rounding_size=None

Roundtooth
roundtooth
pad=0.3,tooth_size=None

Sawtooth
sawtooth
pad=0.3,tooth_size=None

Square
square
pad=0.3




Fancybox Demo

Note that the attribute arguments can be specified within the style
name with separating comma (this form can be used as "boxstyle" value
of bbox argument when initializing the text instance)

``` python
bb.set_boxstyle("rarrow,pad=0.6")
```

## Annotating with Arrow

The [``annotate()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.annotate.html#matplotlib.pyplot.annotate) function in the pyplot module
(or annotate method of the Axes class) is used to draw an arrow
connecting two points on the plot.

``` python
ax.annotate("Annotation",
            xy=(x1, y1), xycoords='data',
            xytext=(x2, y2), textcoords='offset points',
            )
```

This annotates a point at ``xy`` in the given coordinate (``xycoords``)
with the text at ``xytext`` given in ``textcoords``. Often, the
annotated point is specified in the *data* coordinate and the annotating
text in *offset points*.
See [``annotate()``](https://matplotlib.orgapi/_as_gen/matplotlib.pyplot.annotate.html#matplotlib.pyplot.annotate) for available coordinate systems.

An arrow connecting two points (xy & xytext) can be optionally drawn by
specifying the ``arrowprops`` argument. To draw only an arrow, use
empty string as the first argument.

``` python
ax.annotate("",
            xy=(0.2, 0.2), xycoords='data',
            xytext=(0.8, 0.8), textcoords='data',
            arrowprops=dict(arrowstyle="->",
                            connectionstyle="arc3"),
            )
```

Annotate Simple01

The arrow drawing takes a few steps.

1. a connecting path between two points are created. This is
controlled by ``connectionstyle`` key value.
1. If patch object is given (*patchA* & *patchB*), the path is clipped to
avoid the patch.
1. The path is further shrunk by given amount of pixels (*shrinkA*
& *shrinkB*)
1. The path is transmuted to arrow patch, which is controlled by the
``arrowstyle`` key value.

Annotate Explain

The creation of the connecting path between two points is controlled by
``connectionstyle`` key and the following styles are available.


---





Name
Attrs



angle
angleA=90,angleB=0,rad=0.0

angle3
angleA=90,angleB=0

arc
angleA=0,angleB=0,armA=None,armB=None,rad=0.0

arc3
rad=0.0

bar
armA=0.0,armB=0.0,fraction=0.3,angle=None




Note that "3" in ``angle3`` and ``arc3`` is meant to indicate that the
resulting path is a quadratic spline segment (three control
points). As will be discussed below, some arrow style options can only
be used when the connecting path is a quadratic spline.

The behavior of each connection style is (limitedly) demonstrated in the
example below. (Warning : The behavior of the ``bar`` style is currently not
well defined, it may be changed in the future).

Connectionstyle Demo

The connecting path (after clipping and shrinking) is then mutated to
an arrow patch, according to the given ``arrowstyle``.


---





Name
Attrs



-
None

->
head_length=0.4,head_width=0.2

-[
widthB=1.0,lengthB=0.2,angleB=None

|-|
widthA=1.0,widthB=1.0

-|>
head_length=0.4,head_width=0.2

<-
head_length=0.4,head_width=0.2

<->
head_length=0.4,head_width=0.2

<|-
head_length=0.4,head_width=0.2

<|-|>
head_length=0.4,head_width=0.2

fancy
head_length=0.4,head_width=0.4,tail_width=0.4

simple
head_length=0.5,head_width=0.5,tail_width=0.2

wedge
tail_width=0.3,shrink_factor=0.5




Fancyarrow Demo

Some arrowstyles only work with connection styles that generate a
quadratic-spline segment. They are ``fancy``, ``simple``, and ``wedge``.
For these arrow styles, you must use the "angle3" or "arc3" connection
style.

If the annotation string is given, the patchA is set to the bbox patch
of the text by default.

Annotate Simple02

As in the text command, a box around the text can be drawn using
the ``bbox`` argument.

Annotate Simple03

By default, the starting point is set to the center of the text
extent. This can be adjusted with ``relpos`` key value. The values
are normalized to the extent of the text. For example, (0,0) means
lower-left corner and (1,1) means top-right.

Annotate Simple04

## Placing Artist at the anchored location of the Axes

There are classes of artists that can be placed at an anchored location
in the Axes. A common example is the legend. This type of artist can
be created by using the OffsetBox class. A few predefined classes are
available in ``mpl_toolkits.axes_grid1.anchored_artists`` others in
``matplotlib.offsetbox``

``` python
from matplotlib.offsetbox import AnchoredText
at = AnchoredText("Figure 1a",
                  prop=dict(size=15), frameon=True,
                  loc='upper left',
                  )
at.patch.set_boxstyle("round,pad=0.,rounding_size=0.2")
ax.add_artist(at)
```

Anchored Box01

The *loc* keyword has same meaning as in the legend command.

A simple application is when the size of the artist (or collection of
artists) is known in pixel size during the time of creation. For
example, If you want to draw a circle with fixed size of 20 pixel x 20
pixel (radius = 10 pixel), you can utilize
``AnchoredDrawingArea``. The instance is created with a size of the
drawing area (in pixels), and arbitrary artists can added to the
drawing area. Note that the extents of the artists that are added to
the drawing area are not related to the placement of the drawing
area itself. Only the initial size matters.

``` python
from mpl_toolkits.axes_grid1.anchored_artists import AnchoredDrawingArea

ada = AnchoredDrawingArea(20, 20, 0, 0,
                          loc='upper right', pad=0., frameon=False)
p1 = Circle((10, 10), 10)
ada.drawing_area.add_artist(p1)
p2 = Circle((30, 10), 5, fc="r")
ada.drawing_area.add_artist(p2)
```

The artists that are added to the drawing area should not have a
transform set (it will be overridden) and the dimensions of those
artists are interpreted as a pixel coordinate, i.e., the radius of the
circles in above example are 10 pixels and 5 pixels, respectively.

Anchored Box02

Sometimes, you want your artists to scale with the data coordinate (or
coordinates other than canvas pixels). You can use
``AnchoredAuxTransformBox`` class. This is similar to
``AnchoredDrawingArea`` except that the extent of the artist is
determined during the drawing time respecting the specified transform.

``` python
from mpl_toolkits.axes_grid1.anchored_artists import AnchoredAuxTransformBox

box = AnchoredAuxTransformBox(ax.transData, loc='upper left')
el = Ellipse((0,0), width=0.1, height=0.4, angle=30)  # in data coordinates!
box.drawing_area.add_artist(el)
```

The ellipse in the above example will have width and height
corresponding to 0.1 and 0.4 in data coordinates and will be
automatically scaled when the view limits of the axes change.

Anchored Box03

As in the legend, the bbox_to_anchor argument can be set. Using the
HPacker and VPacker, you can have an arrangement(?) of artist as in the
legend (as a matter of fact, this is how the legend is created).

Anchored Box04

Note that unlike the legend, the ``bbox_transform`` is set
to IdentityTransform by default.

## Using Complex Coordinates with Annotations

The Annotation in matplotlib supports several types of coordinates as
described in [Basic annotation](#annotations-tutorial). For an advanced user who wants
more control, it supports a few other options.

## Using ConnectionPatch

The ConnectionPatch is like an annotation without text. While the annotate
function is recommended in most situations, the ConnectionPatch is useful when
you want to connect points in different axes.

``` python
from matplotlib.patches import ConnectionPatch
xy = (0.2, 0.2)
con = ConnectionPatch(xyA=xy, xyB=xy, coordsA="data", coordsB="data",
                      axesA=ax1, axesB=ax2)
ax2.add_artist(con)
```

The above code connects point xy in the data coordinates of ``ax1`` to
point xy in the data coordinates of ``ax2``. Here is a simple example.

Connect Simple01

While the ConnectionPatch instance can be added to any axes, you may want to add
it to the axes that is latest in drawing order to prevent overlap by other
axes.

### Advanced Topics

## Zoom effect between Axes

``mpl_toolkits.axes_grid1.inset_locator`` defines some patch classes useful
for interconnecting two axes. Understanding the code requires some
knowledge of how mpl's transform works. But, utilizing it will be
straight forward.

Axes Zoom Effect

## Define Custom BoxStyle

You can use a custom box style. The value for the ``boxstyle`` can be a
callable object in the following forms.:

``` python
def __call__(self, x0, y0, width, height, mutation_size,
             aspect_ratio=1.):
    '''
    Given the location and size of the box, return the path of
    the box around it.

      - *x0*, *y0*, *width*, *height* : location and size of the box
      - *mutation_size* : a reference scale for the mutation.
      - *aspect_ratio* : aspect-ratio for the mutation.
    '''
    path = ...
    return path
```

Here is a complete example.

Custom Boxstyle01

However, it is recommended that you derive from the
matplotlib.patches.BoxStyle._Base as demonstrated below.

Custom Boxstyle02

Similarly, you can define a custom ConnectionStyle and a custom ArrowStyle.
See the source code of ``lib/matplotlib/patches.py`` and check
how each style class is defined.

## Download

- [Download Python source code: annotations.py](https://matplotlib.org/_downloads/e9b9ec3e7de47d2ccae486e437e86de2/annotations.py)
- [Download Jupyter notebook: annotations.ipynb](https://matplotlib.org/_downloads/c4f2a18ccd63dc25619141aee3712b03/annotations.ipynb)
        