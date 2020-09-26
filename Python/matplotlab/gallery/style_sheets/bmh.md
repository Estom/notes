# 黑客贝叶斯方法样式表 

这个例子演示了贝叶斯黑客方法 [[1]](https://matplotlib.org/gallery/style_sheets/bmh.html#id2) 在线书籍中使用的风格。

[[1]](https://matplotlib.org/gallery/style_sheets/bmh.html#id1)   http://camdavidsonpilon.github.io/Probabilistic-Programming-and-Bayesian-Methods-for-Hackers/

![黑客贝叶斯方法样式表示例](https://matplotlib.org/_images/sphx_glr_bmh_001.png)

```python
from numpy.random import beta
import matplotlib.pyplot as plt


plt.style.use('bmh')


def plot_beta_hist(ax, a, b):
    ax.hist(beta(a, b, size=10000), histtype="stepfilled",
            bins=25, alpha=0.8, density=True)


fig, ax = plt.subplots()
plot_beta_hist(ax, 10, 10)
plot_beta_hist(ax, 4, 12)
plot_beta_hist(ax, 50, 12)
plot_beta_hist(ax, 6, 55)
ax.set_title("'bmh' style sheet")

plt.show()
```

## 下载这个示例
            
- [下载python源码: bmh.py](https://matplotlib.org/_downloads/bmh.py)
- [下载Jupyter notebook: bmh.ipynb](https://matplotlib.org/_downloads/bmh.ipynb)