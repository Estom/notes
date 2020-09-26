---
sidebarDepth: 3
sidebar: auto
---

# Typesetting With XeLaTeX/LuaLaTeX

How to typeset text with the ``pgf`` backend in Matplotlib.

Using the ``pgf`` backend, matplotlib can export figures as pgf drawing commands
that can be processed with pdflatex, xelatex or lualatex. XeLaTeX and LuaLaTeX
have full unicode support and can use any font that is installed in the operating
system, making use of advanced typographic features of OpenType, AAT and
Graphite. Pgf pictures created by ``plt.savefig('figure.pgf')`` can be
embedded as raw commands in LaTeX documents. Figures can also be directly
compiled and saved to PDF with ``plt.savefig('figure.pdf')`` by either
switching to the backend

``` python
matplotlib.use('pgf')
```

or registering it for handling pdf output

``` python
from matplotlib.backends.backend_pgf import FigureCanvasPgf
matplotlib.backend_bases.register_backend('pdf', FigureCanvasPgf)
```

The second method allows you to keep using regular interactive backends and to
save xelatex, lualatex or pdflatex compiled PDF files from the graphical user interface.

Matplotlib's pgf support requires a recent [LaTeX](http://www.tug.org) installation that includes
the TikZ/PGF packages (such as [TeXLive](http://www.tug.org/texlive/)), preferably with XeLaTeX or LuaLaTeX
installed. If either pdftocairo or ghostscript is present on your system,
figures can optionally be saved to PNG images as well. The executables
for all applications must be located on your [``PATH``](https://matplotlib.orgfaq/environment_variables_faq.html#envvar-PATH).

Rc parameters that control the behavior of the pgf backend:


---





Parameter
Documentation



pgf.preamble
Lines to be included in the LaTeX preamble

pgf.rcfonts
Setup fonts from rc params using the fontspec package

pgf.texsystem
Either "xelatex" (default), "lualatex" or "pdflatex"




::: tip Note

TeX defines a set of special characters, such as:

``` python
# $ % & ~ _ ^ \ { }
```

Generally, these characters must be escaped correctly. For convenience,
some characters (_,^,%) are automatically escaped outside of math
environments.

:::

## Multi-Page PDF Files

The pgf backend also supports multipage pdf files using ``PdfPages``

``` python
from matplotlib.backends.backend_pgf import PdfPages
import matplotlib.pyplot as plt

with PdfPages('multipage.pdf', metadata={'author': 'Me'}) as pdf:

    fig1, ax1 = plt.subplots()
    ax1.plot([1, 5, 3])
    pdf.savefig(fig1)

    fig2, ax2 = plt.subplots()
    ax2.plot([1, 5, 3])
    pdf.savefig(fig2)
```

## Font specification

The fonts used for obtaining the size of text elements or when compiling
figures to PDF are usually defined in the matplotlib rc parameters. You can
also use the LaTeX default Computer Modern fonts by clearing the lists for
``font.serif``, ``font.sans-serif`` or ``font.monospace``. Please note that
the glyph coverage of these fonts is very limited. If you want to keep the
Computer Modern font face but require extended unicode support, consider
installing the [Computer Modern Unicode](https://sourceforge.net/projects/cm-unicode/)
fonts *CMU Serif*, *CMU Sans Serif*, etc.

When saving to ``.pgf``, the font configuration matplotlib used for the
layout of the figure is included in the header of the text file.

``` python
"""
=========
Pgf Fonts
=========

"""

import matplotlib.pyplot as plt
plt.rcParams.update({
    "font.family": "serif",
    "font.serif": [],                    # use latex default serif font
    "font.sans-serif": ["DejaVu Sans"],  # use a specific sans-serif font
})

plt.figure(figsize=(4.5, 2.5))
plt.plot(range(5))
plt.text(0.5, 3., "serif")
plt.text(0.5, 2., "monospace", family="monospace")
plt.text(2.5, 2., "sans-serif", family="sans-serif")
plt.text(2.5, 1., "comic sans", family="Comic Sans MS")
plt.xlabel("µ is not $\\mu$")
plt.tight_layout(.5)
```

## Custom preamble

Full customization is possible by adding your own commands to the preamble.
Use the ``pgf.preamble`` parameter if you want to configure the math fonts,
using ``unicode-math`` for example, or for loading additional packages. Also,
if you want to do the font configuration yourself instead of using the fonts
specified in the rc parameters, make sure to disable ``pgf.rcfonts``.

``` python
"""
============
Pgf Preamble
============

"""

import matplotlib as mpl
mpl.use("pgf")
import matplotlib.pyplot as plt
plt.rcParams.update({
    "font.family": "serif",  # use serif/main font for text elements
    "text.usetex": True,     # use inline math for ticks
    "pgf.rcfonts": False,    # don't setup fonts from rc parameters
    "pgf.preamble": [
         "\\usepackage{units}",          # load additional packages
         "\\usepackage{metalogo}",
         "\\usepackage{unicode-math}",   # unicode math setup
         r"\setmathfont{xits-math.otf}",
         r"\setmainfont{DejaVu Serif}",  # serif font via preamble
         ]
})

plt.figure(figsize=(4.5, 2.5))
plt.plot(range(5))
plt.xlabel("unicode text: я, ψ, €, ü, \\unitfrac[10]{°}{µm}")
plt.ylabel("\\XeLaTeX")
plt.legend(["unicode math: $λ=∑_i^∞ μ_i^2$"])
plt.tight_layout(.5)
```

## Choosing the TeX system

The TeX system to be used by matplotlib is chosen by the ``pgf.texsystem``
parameter. Possible values are ``'xelatex'`` (default), ``'lualatex'`` and
``'pdflatex'``. Please note that when selecting pdflatex the fonts and
unicode handling must be configured in the preamble.

``` python
"""
=============
Pgf Texsystem
=============

"""

import matplotlib.pyplot as plt
plt.rcParams.update({
    "pgf.texsystem": "pdflatex",
    "pgf.preamble": [
         r"\usepackage[utf8x]{inputenc}",
         r"\usepackage[T1]{fontenc}",
         r"\usepackage{cmbright}",
         ]
})

plt.figure(figsize=(4.5, 2.5))
plt.plot(range(5))
plt.text(0.5, 3., "serif", family="serif")
plt.text(0.5, 2., "monospace", family="monospace")
plt.text(2.5, 2., "sans-serif", family="sans-serif")
plt.xlabel(r"µ is not $\mu$")
plt.tight_layout(.5)
```

## Troubleshooting

- Please note that the TeX packages found in some Linux distributions and
MiKTeX installations are dramatically outdated. Make sure to update your
package catalog and upgrade or install a recent TeX distribution.
- On Windows, the [``PATH``](https://matplotlib.orgfaq/environment_variables_faq.html#envvar-PATH) environment variable may need to be modified
to include the directories containing the latex, dvipng and ghostscript
executables. See [Environment Variables](https://matplotlib.orgfaq/environment_variables_faq.html#environment-variables) and
[Setting environment variables in windows](https://matplotlib.orgfaq/environment_variables_faq.html#setting-windows-environment-variables) for details.
- A limitation on Windows causes the backend to keep file handles that have
been opened by your application open. As a result, it may not be possible
to delete the corresponding files until the application closes (see
[#1324](https://github.com/matplotlib/matplotlib/issues/1324)).
- Sometimes the font rendering in figures that are saved to png images is
very bad. This happens when the pdftocairo tool is not available and
ghostscript is used for the pdf to png conversion.
- Make sure what you are trying to do is possible in a LaTeX document,
that your LaTeX syntax is valid and that you are using raw strings
if necessary to avoid unintended escape sequences.
- The ``pgf.preamble`` rc setting provides lots of flexibility, and lots of
ways to cause problems. When experiencing problems, try to minimalize or
disable the custom preamble.
- Configuring an ``unicode-math`` environment can be a bit tricky. The
TeXLive distribution for example provides a set of math fonts which are
usually not installed system-wide. XeTeX, unlike LuaLatex, cannot find
these fonts by their name, which is why you might have to specify
``\setmathfont{xits-math.otf}`` instead of ``\setmathfont{XITS Math}`` or
alternatively make the fonts available to your OS. See this
[tex.stackexchange.com question](http://tex.stackexchange.com/questions/43642)
for more details.
- If the font configuration used by matplotlib differs from the font setting
in yout LaTeX document, the alignment of text elements in imported figures
may be off. Check the header of your ``.pgf`` file if you are unsure about
the fonts matplotlib used for the layout.
- Vector images and hence ``.pgf`` files can become bloated if there are a lot
of objects in the graph. This can be the case for image processing or very
big scatter graphs. In an extreme case this can cause TeX to run out of
memory: "TeX capacity exceeded, sorry" You can configure latex to increase
the amount of memory available to generate the ``.pdf`` image as discussed on
[tex.stackexchange.com](http://tex.stackexchange.com/questions/7953).
Another way would be to "rasterize" parts of the graph causing problems
using either the ``rasterized=True`` keyword, or ``.set_rasterized(True)`` as per
[this example](https://matplotlib.orggallery/misc/rasterization_demo.html).
- If you still need help, please see [Getting help](https://matplotlib.orgfaq/troubleshooting_faq.html#reporting-problems)

## Download

- [Download Python source code: pgf.py](https://matplotlib.org/_downloads/33c57cdb935b0436624e8a3471dedc5e/pgf.py)
- [Download Jupyter notebook: pgf.ipynb](https://matplotlib.org/_downloads/216a4d9bdb6721e8ad7fda0b85a793ae/pgf.ipynb)
        