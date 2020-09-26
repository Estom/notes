# 注释Simple01

![注释Simple01示例](https://matplotlib.org/_images/sphx_glr_annotate_simple01_001.png)

```python
import matplotlib.pyplot as plt


fig, ax = plt.subplots(figsize=(3, 3))

ax.annotate("",
            xy=(0.2, 0.2), xycoords='data',
            xytext=(0.8, 0.8), textcoords='data',
            arrowprops=dict(arrowstyle="->",
                            connectionstyle="arc3"),
            )

plt.show()
```

## 下载这个示例
            
- [下载python源码: annotate_simple01.py](https://matplotlib.org/_downloads/annotate_simple01.py)
- [下载Jupyter notebook: annotate_simple01.ipynb](https://matplotlib.org/_downloads/annotate_simple01.ipynb)