# 简单Coord02注释示例

![简单Coord02注释示例](https://matplotlib.org/_images/sphx_glr_annotate_simple_coord02_001.png)

```python
import matplotlib.pyplot as plt


fig, ax = plt.subplots(figsize=(3, 2))
an1 = ax.annotate("Test 1", xy=(0.5, 0.5), xycoords="data",
                  va="center", ha="center",
                  bbox=dict(boxstyle="round", fc="w"))

an2 = ax.annotate("Test 2", xy=(0.5, 1.), xycoords=an1,
                  xytext=(0.5, 1.1), textcoords=(an1, "axes fraction"),
                  va="bottom", ha="center",
                  bbox=dict(boxstyle="round", fc="w"),
                  arrowprops=dict(arrowstyle="->"))

fig.subplots_adjust(top=0.83)
plt.show()
```

## 下载这个示例
            
- [下载python源码: annotate_simple_coord02.py](https://matplotlib.org/_downloads/annotate_simple_coord02.py)
- [下载Jupyter notebook: annotate_simple_coord02.ipynb](https://matplotlib.org/_downloads/annotate_simple_coord02.ipynb)