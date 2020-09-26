# Pyplot 文本(Text)

```python
import numpy as np
import matplotlib.pyplot as plt

# Fixing random state for reproducibility
np.random.seed(19680801)

mu, sigma = 100, 15
x = mu + sigma * np.random.randn(10000)

# the histogram of the data
n, bins, patches = plt.hist(x, 50, density=True, facecolor='g', alpha=0.75)


plt.xlabel('Smarts')
plt.ylabel('Probability')
plt.title('Histogram of IQ')
plt.text(60, .025, r'$\mu=100,\ \sigma=15$')
plt.axis([40, 160, 0, 0.03])
plt.grid(True)
plt.show()
```

![Pyplot 文本示例](https://matplotlib.org/_images/sphx_glr_pyplot_text_001.png)

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.pyplot.hist
matplotlib.pyplot.xlabel
matplotlib.pyplot.ylabel
matplotlib.pyplot.text
matplotlib.pyplot.grid
matplotlib.pyplot.show
```

## 下载这个示例
            
- [下载python源码: pyplot_text.py](https://matplotlib.org/_downloads/pyplot_text.py)
- [下载Jupyter notebook: pyplot_text.ipynb](https://matplotlib.org/_downloads/pyplot_text.ipynb)