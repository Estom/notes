# Markevery示例

此示例演示了使用Line2D对象的``markevery``属性在数据点子集上显示标记的各种选项。

整数参数非常直观。例如 markevery = 5 将从第一个数据点开始绘制每个第5个标记。

浮点参数允许标记沿着线以大致相等的距离间隔开。沿着标记之间的线的理论距离通过将轴边界对角线的显示坐标距离乘以 markevery 值来确定。将显示最接近理论距离的数据点。

切片或列表/数组也可以与 markevery 一起使用以指定要显示的标记。

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

# define a list of markevery cases to plot
cases = [None,
         8,
         (30, 8),
         [16, 24, 30], [0, -1],
         slice(100, 200, 3),
         0.1, 0.3, 1.5,
         (0.0, 0.1), (0.45, 0.1)]

# define the figure size and grid layout properties
figsize = (10, 8)
cols = 3
gs = gridspec.GridSpec(len(cases) // cols + 1, cols)
gs.update(hspace=0.4)
# define the data for cartesian plots
delta = 0.11
x = np.linspace(0, 10 - 2 * delta, 200) + delta
y = np.sin(x) + 1.0 + delta
```

将每个Markevery案例绘制为线性x和y标度

```python
fig1 = plt.figure(num=1, figsize=figsize)
ax = []
for i, case in enumerate(cases):
    row = (i // cols)
    col = i % cols
    ax.append(fig1.add_subplot(gs[row, col]))
    ax[-1].set_title('markevery=%s' % str(case))
    ax[-1].plot(x, y, 'o', ls='-', ms=4, markevery=case)
```

![Markevery示例图示](https://matplotlib.org/_images/sphx_glr_markevery_demo_001.png)

将每个Markevery案例绘制为log x和y scale

```python
fig2 = plt.figure(num=2, figsize=figsize)
axlog = []
for i, case in enumerate(cases):
    row = (i // cols)
    col = i % cols
    axlog.append(fig2.add_subplot(gs[row, col]))
    axlog[-1].set_title('markevery=%s' % str(case))
    axlog[-1].set_xscale('log')
    axlog[-1].set_yscale('log')
    axlog[-1].plot(x, y, 'o', ls='-', ms=4, markevery=case)
fig2.tight_layout()
```

![Markevery示例图示2](https://matplotlib.org/_images/sphx_glr_markevery_demo_003.png)

将每个Markevery案例绘制为线性x和y比例，但放大时请注意放大时的行为。当指定开始标记偏移时，它始终相对于可能与第一个可见数据点不同的第一个数据点进行解释。

```python
fig3 = plt.figure(num=3, figsize=figsize)
axzoom = []
for i, case in enumerate(cases):
    row = (i // cols)
    col = i % cols
    axzoom.append(fig3.add_subplot(gs[row, col]))
    axzoom[-1].set_title('markevery=%s' % str(case))
    axzoom[-1].plot(x, y, 'o', ls='-', ms=4, markevery=case)
    axzoom[-1].set_xlim((6, 6.7))
    axzoom[-1].set_ylim((1.1, 1.7))
fig3.tight_layout()

# define data for polar plots
r = np.linspace(0, 3.0, 200)
theta = 2 * np.pi * r
```

![Markevery示例图示3](https://matplotlib.org/_images/sphx_glr_markevery_demo_005.png)

绘制每个Markevery案例的极坐标图。

```python
fig4 = plt.figure(num=4, figsize=figsize)
axpolar = []
for i, case in enumerate(cases):
    row = (i // cols)
    col = i % cols
    axpolar.append(fig4.add_subplot(gs[row, col], projection='polar'))
    axpolar[-1].set_title('markevery=%s' % str(case))
    axpolar[-1].plot(theta, r, 'o', ls='-', ms=4, markevery=case)
fig4.tight_layout()

plt.show()
```

![Markevery示例图示4](https://matplotlib.org/_images/sphx_glr_markevery_demo_007.png)

## 下载这个示例

- [下载python源码: markevery_demo.py](https://matplotlib.org/_downloads/markevery_demo.py)
- [下载Jupyter notebook: markevery_demo.ipynb](https://matplotlib.org/_downloads/markevery_demo.ipynb)