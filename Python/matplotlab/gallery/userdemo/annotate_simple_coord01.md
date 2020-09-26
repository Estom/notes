# 简单Coord01注释示例

![简单Coord01注释示例](https://matplotlib.org/_images/sphx_glr_annotate_simple_coord01_001.png)

```python
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(3, 2))
an1 = ax.annotate("Test 1", xy=(0.5, 0.5), xycoords="data",
                  va="center", ha="center",
                  bbox=dict(boxstyle="round", fc="w"))
an2 = ax.annotate("Test 2", xy=(1, 0.5), xycoords=an1,
                  xytext=(30, 0), textcoords="offset points",
                  va="center", ha="left",
                  bbox=dict(boxstyle="round", fc="w"),
                  arrowprops=dict(arrowstyle="->"))
plt.show()
```

## 下载这个示例
            
- [下载python源码: annotate_simple_coord01.py](https://matplotlib.org/_downloads/annotate_simple_coord01.py)
- [下载Jupyter notebook: annotate_simple_coord01.ipynb](https://matplotlib.org/_downloads/annotate_simple_coord01.ipynb)

