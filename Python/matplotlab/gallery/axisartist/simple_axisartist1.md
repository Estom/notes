# 简单的Axisartist1

![简单的Axisartist1](https://matplotlib.org/_images/sphx_glr_simple_axisartist1_001.png)

```python
import matplotlib.pyplot as plt
import mpl_toolkits.axisartist as AA

fig = plt.figure(1)
fig.subplots_adjust(right=0.85)
ax = AA.Subplot(fig, 1, 1, 1)
fig.add_subplot(ax)

# make some axis invisible
ax.axis["bottom", "top", "right"].set_visible(False)

# make an new axis along the first axis axis (x-axis) which pass
# through y=0.
ax.axis["y=0"] = ax.new_floating_axis(nth_coord=0, value=0,
                                      axis_direction="bottom")
ax.axis["y=0"].toggle(all=True)
ax.axis["y=0"].label.set_text("y = 0")

ax.set_ylim(-2, 4)

plt.show()
```

## 下载这个示例
            
- [下载python源码: simple_axisartist1.py](https://matplotlib.org/_downloads/simple_axisartist1.py)
- [下载Jupyter notebook: simple_axisartist1.ipynb](https://matplotlib.org/_downloads/simple_axisartist1.ipynb)