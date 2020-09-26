# 嵌入GTK3 Panzoom

演示通过pygobject访问GTK3的NavigationToolbar。

```python
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

from matplotlib.backends.backend_gtk3 import (
    NavigationToolbar2GTK3 as NavigationToolbar)
from matplotlib.backends.backend_gtk3agg import (
    FigureCanvasGTK3Agg as FigureCanvas)
from matplotlib.figure import Figure
import numpy as np

win = Gtk.Window()
win.connect("delete-event", Gtk.main_quit)
win.set_default_size(400, 300)
win.set_title("Embedding in GTK")

f = Figure(figsize=(5, 4), dpi=100)
a = f.add_subplot(1, 1, 1)
t = np.arange(0.0, 3.0, 0.01)
s = np.sin(2*np.pi*t)
a.plot(t, s)

vbox = Gtk.VBox()
win.add(vbox)

# Add canvas to vbox
canvas = FigureCanvas(f)  # a Gtk.DrawingArea
vbox.pack_start(canvas, True, True, 0)

# Create toolbar
toolbar = NavigationToolbar(canvas, win)
vbox.pack_start(toolbar, False, False, 0)

win.show_all()
Gtk.main()
```

## 下载这个示例
            
- [下载python源码: embedding_in_gtk3_panzoom_sgskip.py](https://matplotlib.org/_downloads/embedding_in_gtk3_panzoom_sgskip.py)
- [下载Jupyter notebook: embedding_in_gtk3_panzoom_sgskip.ipynb](https://matplotlib.org/_downloads/embedding_in_gtk3_panzoom_sgskip.ipynb)