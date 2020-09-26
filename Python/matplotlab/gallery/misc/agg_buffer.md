# Agg缓冲区

使用后端AGG以RGB字符串的形式访问地物画布，然后将其转换为数组并将其传递给Pillow进行渲染。

![Agg缓冲区](https://matplotlib.org/_images/sphx_glr_agg_buffer_001.png)

```python
import numpy as np

from matplotlib.backends.backend_agg import FigureCanvasAgg
import matplotlib.pyplot as plt

plt.plot([1, 2, 3])

canvas = plt.get_current_fig_manager().canvas

agg = canvas.switch_backends(FigureCanvasAgg)
agg.draw()
s, (width, height) = agg.print_to_buffer()

# Convert to a NumPy array.
X = np.fromstring(s, np.uint8).reshape((height, width, 4))

# Pass off to PIL.
from PIL import Image
im = Image.frombytes("RGBA", (width, height), s)

# Uncomment this line to display the image using ImageMagick's `display` tool.
# im.show()
```

## 下载这个示例
            
- [下载python源码: agg_buffer.py](https://matplotlib.org/_downloads/agg_buffer.py)
- [下载Jupyter notebook: agg_buffer.ipynb](https://matplotlib.org/_downloads/agg_buffer.ipynb)