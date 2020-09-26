# 帧抓取

直接使用MovieWriter抓取单个帧并将其写入文件。 这避免了任何事件循环集成，因此甚至可以与Agg后端一起使用。 建议不要在交互式设置中使用。

```python
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.animation import FFMpegWriter

# Fixing random state for reproducibility
np.random.seed(19680801)


metadata = dict(title='Movie Test', artist='Matplotlib',
                comment='Movie support!')
writer = FFMpegWriter(fps=15, metadata=metadata)

fig = plt.figure()
l, = plt.plot([], [], 'k-o')

plt.xlim(-5, 5)
plt.ylim(-5, 5)

x0, y0 = 0, 0

with writer.saving(fig, "writer_test.mp4", 100):
    for i in range(100):
        x0 += 0.1 * np.random.randn()
        y0 += 0.1 * np.random.randn()
        l.set_data(x0, y0)
        writer.grab_frame()
```

## 下载这个示例
            
- [下载python源码: frame_grabbing_sgskip.py](https://matplotlib.org/_downloads/frame_grabbing_sgskip.py)
- [下载Jupyter notebook: frame_grabbing_sgskip.ipynb](https://matplotlib.org/_downloads/frame_grabbing_sgskip.ipynb)