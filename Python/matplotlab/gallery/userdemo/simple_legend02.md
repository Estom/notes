# 简单的Legend02

![简单的Legend02示例](https://matplotlib.org/_images/sphx_glr_simple_legend02_001.png)

```python
import matplotlib.pyplot as plt

fig, ax = plt.subplots()

line1, = ax.plot([1, 2, 3], label="Line 1", linestyle='--')
line2, = ax.plot([3, 2, 1], label="Line 2", linewidth=4)

# Create a legend for the first line.
first_legend = ax.legend(handles=[line1], loc='upper right')

# Add the legend manually to the current Axes.
ax.add_artist(first_legend)

# Create another legend for the second line.
ax.legend(handles=[line2], loc='lower right')

plt.show()
```

## 下载这个示例
            
- [下载python源码: simple_legend02.py](https://matplotlib.org/_downloads/simple_legend02.py)
- [下载Jupyter notebook: simple_legend02.ipynb](https://matplotlib.org/_downloads/simple_legend02.ipynb)