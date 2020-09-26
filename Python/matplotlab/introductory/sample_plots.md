---
sidebarDepth: 3
sidebar: auto
---

# Sample plots in Matplotlib

Here you'll find a host of example plots with the code that
generated them.

## Line Plot

Here's how to create a line plot with text labels using
[``plot()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.plot.html#matplotlib.pyplot.plot).

<center>
  <a href="/gallery/lines_bars_and_markers/simple_plot.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_simple_plot_0011.png">
  </a>
  <p>
    <b>Simple Plot</b>
  </p>
</center>

## Multiple subplots in one figure

Multiple axes (i.e. subplots) are created with the
[``subplot()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.subplot.html#matplotlib.pyplot.subplot) function:

<center>
  <a href="/gallery/subplots_axes_and_figures/subplot.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_subplot_0011.png">
  </a>
  <p>
    <b>Subplot</b>
  </p>
</center>

## Images

Matplotlib can display images (assuming equally spaced
horizontal dimensions) using the [``imshow()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.imshow.html#matplotlib.pyplot.imshow) function.

<center>
  <a href="/gallery/images_contours_and_fields/image_demo.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_image_demo_0031.png">
  </a>
</center>

**Example of using [``imshow()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.imshow.html#matplotlib.pyplot.imshow) to display a CT scan**

## Contouring and pseudocolor

The [``pcolormesh()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.pcolormesh.html#matplotlib.pyplot.pcolormesh) function can make a colored
representation of a two-dimensional array, even if the horizontal dimensions
are unevenly spaced. The
[``contour()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.contour.html#matplotlib.pyplot.contour) function is another way to represent
the same data:

<center>
  <a href="/gallery/images_contours_and_fields/pcolormesh_levels.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_pcolormesh_levels_0011.png">
  </a>
</center>

**Example comparing [``pcolormesh()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.pcolormesh.html#matplotlib.pyplot.pcolormesh) and [``contour()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.contour.html#matplotlib.pyplot.contour) for plotting two-dimensional data**

## Histograms

The [``hist()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.hist.html#matplotlib.pyplot.hist) function automatically generates
histograms and returns the bin counts or probabilities:

<center>
  <a href="/gallery/statistics/histogram_features.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_histogram_features_0011.png">
  </a>
  <p>
    <b>Histogram Features</b>
  </p>
</center>

## Paths

You can add arbitrary paths in Matplotlib using the
[``matplotlib.path``](https://matplotlib.org/api/path_api.html#module-matplotlib.path) module:

<center>
  <a href="/gallery/shapes_and_collections/path_patch.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_path_patch_0011.png">
  </a>
  <p>
    <b>Path Patch</b>
  </p>
</center>

## Three-dimensional plotting

The mplot3d toolkit (see [Getting started](https://matplotlib.org//toolkits/mplot3d.html#toolkit-mplot3d-tutorial) and
[3D plotting](https://matplotlib.org/gallery/index.html#mplot3d-examples-index)) has support for simple 3d graphs
including surface, wireframe, scatter, and bar charts.

<center>
  <a href="/gallery/mplot3d/surface3d.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_surface3d_0011.png">
  </a>
  <p>
    <b>Surface3d</b>
  </p>
</center>

Thanks to John Porter, Jonathon Taylor, Reinier Heeres, and Ben Root for
the ``mplot3d`` toolkit. This toolkit is included with all standard Matplotlib
installs.

## Streamplot

The [``streamplot()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.streamplot.html#matplotlib.pyplot.streamplot) function plots the streamlines of
a vector field. In addition to simply plotting the streamlines, it allows you
to map the colors and/or line widths of streamlines to a separate parameter,
such as the speed or local intensity of the vector field.

<center>
  <a href="/gallery/images_contours_and_fields/plot_streamplot.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_plot_streamplot_0011.png">
  </a>
  <p>
    <b>Streamplot with various plotting options.</b>
  </p>
</center>

This feature complements the [``quiver()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.quiver.html#matplotlib.pyplot.quiver) function for
plotting vector fields. Thanks to Tom Flannaghan and Tony Yu for adding the
streamplot function.

## Ellipses

In support of the [Phoenix](http://www.jpl.nasa.gov/news/phoenix/main.php)
mission to Mars (which used Matplotlib to display ground tracking of
spacecraft), Michael Droettboom built on work by Charlie Moad to provide
an extremely accurate 8-spline approximation to elliptical arcs (see
[``Arc``](https://matplotlib.org/api/_as_gen/matplotlib.patches.Arc.html#matplotlib.patches.Arc)), which are insensitive to zoom level.

<center>
  <a href="/gallery/shapes_and_collections/ellipse_demo.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_ellipse_demo_0011.png">
  </a>
  <p>
    <b>Ellipse Demo</b>
  </p>
</center>

## Bar charts

Use the [``bar()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.bar.html#matplotlib.pyplot.bar) function to make bar charts, which
includes customizations such as error bars:

<center>
  <a href="/gallery/statistics/barchart_demo.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_barchart_demo_0011.png">
  </a>
  <p>
    <b>Barchart Demo</b>
  </p>
</center>

You can also create stacked bars
([bar_stacked.py](https://matplotlib.org/gallery/lines_bars_and_markers/bar_stacked.html)),
or horizontal bar charts
([barh.py](https://matplotlib.org/gallery/lines_bars_and_markers/barh.html)).

## Pie charts

The [``pie()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.pie.html#matplotlib.pyplot.pie) function allows you to create pie
charts. Optional features include auto-labeling the percentage of area,
exploding one or more wedges from the center of the pie, and a shadow effect.
Take a close look at the attached code, which generates this figure in just
a few lines of code.

<center>
  <a href="/gallery/pie_and_polar_charts/pie_features.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_pie_features_0011.png">
  </a>
  <p>
    <b>Pie Features</b>
  </p>
</center>

## Tables

The [``table()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.table.html#matplotlib.pyplot.table) function adds a text table
to an axes.

<center>
  <a href="/gallery/misc/table_demo.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_table_demo_0011.png">
  </a>
  <p>
    <b>Table Demo</b>
  </p>
</center>

## Scatter plots

The [``scatter()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.scatter.html#matplotlib.pyplot.scatter) function makes a scatter plot
with (optional) size and color arguments. This example plots changes
in Google's stock price, with marker sizes reflecting the
trading volume and colors varying with time. Here, the
alpha attribute is used to make semitransparent circle markers.

<center>
  <a href="/gallery/lines_bars_and_markers/scatter_demo2.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_scatter_demo2_0011.png">
  </a>
  <p>
    <b>Scatter Demo2</b>
  </p>
</center>

## GUI widgets

Matplotlib has basic GUI widgets that are independent of the graphical
user interface you are using, allowing you to write cross GUI figures
and widgets. See [``matplotlib.widgets``](https://matplotlib.org/api/widgets_api.html#module-matplotlib.widgets) and the
[widget examples](https://matplotlib.org/gallery/index.html).

<center>
  <a href="/gallery/widgets/slider_demo.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_slider_demo_0011.png">
  </a>
  <p>
    <b>Slider and radio-button GUI.</b>
  </p>
</center>

## Filled curves

The [``fill()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.fill.html#matplotlib.pyplot.fill) function lets you
plot filled curves and polygons:

<center>
  <a href="/gallery/lines_bars_and_markers/fill.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_fill_0011.png">
  </a>
  <p>
    <b>Fill</b>
  </p>
</center>

Thanks to Andrew Straw for adding this function.

## Date handling

You can plot timeseries data with major and minor ticks and custom
tick formatters for both.

<center>
  <a href="/gallery/text_labels_and_annotations/date.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_date_0011.png">
  </a>
  <p>
    <b>Date</b>
  </p>
</center>

See [``matplotlib.ticker``](https://matplotlib.org/api/ticker_api.html#module-matplotlib.ticker) and [``matplotlib.dates``](https://matplotlib.org/api/dates_api.html#module-matplotlib.dates) for details and usage.

## Log plots

The [``semilogx()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.semilogx.html#matplotlib.pyplot.semilogx),
[``semilogy()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.semilogy.html#matplotlib.pyplot.semilogy) and
[``loglog()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.loglog.html#matplotlib.pyplot.loglog) functions simplify the creation of
logarithmic plots.

<center>
  <a href="/gallery/scales/log_demo.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_log_demo_0011.png">
  </a>
  <p>
    <b>Log Demo</b>
  </p>
</center>

Thanks to Andrew Straw, Darren Dale and Gregory Lielens for contributions
log-scaling infrastructure.

## Polar plots

The [``polar()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.polar.html#matplotlib.pyplot.polar) function generates polar plots.

<center>
  <a href="/gallery/pie_and_polar_charts/polar_demo.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_polar_demo_0011.png">
  </a>
  <p>
    <b>Polar Demo</b>
  </p>
</center>

## Legends

The [``legend()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.legend.html#matplotlib.pyplot.legend) function automatically
generates figure legends, with MATLAB-compatible legend-placement
functions.

<center>
  <a href="/gallery/text_labels_and_annotations/legend.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_legend_0011.png">
  </a>
  <p>
    <b>Legend</b>
  </p>
</center>

Thanks to Charles Twardy for input on the legend function.

## TeX-notation for text objects

Below is a sampling of the many TeX expressions now supported by Matplotlib's
internal mathtext engine. The mathtext module provides TeX style mathematical
expressions using [FreeType](https://www.freetype.org/)
and the DejaVu, BaKoMa computer modern, or [STIX](http://www.stixfonts.org)
fonts. See the [``matplotlib.mathtext``](https://matplotlib.org/api/mathtext_api.html#module-matplotlib.mathtext) module for additional details.

<center>
  <a href="/gallery/text_labels_and_annotations/mathtext_examples.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_mathtext_examples_0011.png">
  </a>
  <p>
    <b>Mathtext Examples</b>
  </p>
</center>

Matplotlib's mathtext infrastructure is an independent implementation and
does not require TeX or any external packages installed on your computer. See
the tutorial at [Writing mathematical expressions](https://matplotlib.org//text/mathtext.html).

## Native TeX rendering

Although Matplotlib's internal math rendering engine is quite
powerful, sometimes you need TeX. Matplotlib supports external TeX
rendering of strings with the *usetex* option.

<center>
  <a href="/gallery/text_labels_and_annotations/tex_demo.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_tex_demo_0011.png">
  </a>
  <p>
    <b>Tex Demo</b>
  </p>
</center>

## EEG GUI

You can embed Matplotlib into pygtk, wx, Tk, or Qt applications.
Here is a screenshot of an EEG viewer called [pbrain](https://github.com/nipy/pbrain).

![eeg_small](https://matplotlib.org/_images/eeg_small.png)

The lower axes uses [``specgram()``](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.specgram.html#matplotlib.pyplot.specgram)
to plot the spectrogram of one of the EEG channels.

For examples of how to embed Matplotlib in different toolkits, see:

- [Embedding in GTK3](https://matplotlib.org/gallery/user_interfaces/embedding_in_gtk3_sgskip.html)
- [Embedding in wx #2](https://matplotlib.org/gallery/user_interfaces/embedding_in_wx2_sgskip.html)
- [Matplotlib With Glade 3](https://matplotlib.org/gallery/user_interfaces/mpl_with_glade3_sgskip.html)
- [Embedding in Qt](https://matplotlib.org/gallery/user_interfaces/embedding_in_qt_sgskip.html)
- [Embedding in Tk](https://matplotlib.org/gallery/user_interfaces/embedding_in_tk_sgskip.html)

## XKCD-style sketch plots

Just for fun, Matplotlib supports plotting in the style of ``xkcd``.

<center>
  <a href="/gallery/showcase/xkcd.html">
    <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_xkcd_0011.png">
  </a>
  <p>
    <b>xkcd</b>
  </p>
</center>

## Subplot example

Many plot types can be combined in one figure to create
powerful and flexible representations of data.

<center>
  <img style="width: 50%" src="https://matplotlib.org/_images/sphx_glr_sample_plots_001.png">
</center>

``` python
import matplotlib.pyplot as plt
import numpy as np

np.random.seed(19680801)
data = np.random.randn(2, 100)

fig, axs = plt.subplots(2, 2, figsize=(5, 5))
axs[0, 0].hist(data[0])
axs[1, 0].scatter(data[0], data[1])
axs[0, 1].plot(data[0], data[1])
axs[1, 1].hist2d(data[0], data[1])

plt.show()
```

## Download

- [Download Python source code: sample_plots.py](https://matplotlib.org/_downloads/6b0f2d1b3dc8d0e75eaa96feb738e947/sample_plots.py)
- [Download Jupyter notebook: sample_plots.ipynb](https://matplotlib.org/_downloads/dcfd63fc031d50e9c085f5dc4aa458b1/sample_plots.ipynb)
