# 注释Simple03

![注释Simple03示例](https://matplotlib.org/_images/sphx_glr_annotate_simple03_001.png)

```python
import matplotlib.pyplot as plt


fig, ax = plt.subplots(figsize=(3, 3))

ann = ax.annotate("Test",
                  xy=(0.2, 0.2), xycoords='data',
                  xytext=(0.8, 0.8), textcoords='data',
                  size=20, va="center", ha="center",
                  bbox=dict(boxstyle="round4", fc="w"),
                  arrowprops=dict(arrowstyle="-|>",
                                  connectionstyle="arc3,rad=-0.2",
                                  fc="w"),
                  )

plt.show()
```

## 下载这个示例
            
- [下载python源码: annotate_simple03.py](https://matplotlib.org/_downloads/annotate_simple03.py)
- [下载Jupyter notebook: annotate_simple03.ipynb](https://matplotlib.org/_downloads/annotate_simple03.ipynb)