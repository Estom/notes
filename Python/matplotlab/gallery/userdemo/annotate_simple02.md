# 注释Simple02

![注释Simple02示例](https://matplotlib.org/_images/sphx_glr_annotate_simple02_001.png)

```python
import matplotlib.pyplot as plt


fig, ax = plt.subplots(figsize=(3, 3))

ax.annotate("Test",
            xy=(0.2, 0.2), xycoords='data',
            xytext=(0.8, 0.8), textcoords='data',
            size=20, va="center", ha="center",
            arrowprops=dict(arrowstyle="simple",
                            connectionstyle="arc3,rad=-0.2"),
            )

plt.show()
```

## 下载这个示例
            
- [下载python源码: annotate_simple02.py](https://matplotlib.org/_downloads/annotate_simple02.py)
- [下载Jupyter notebook: annotate_simple02.ipynb](https://matplotlib.org/_downloads/annotate_simple02.ipynb)