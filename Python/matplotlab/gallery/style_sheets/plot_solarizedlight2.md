# Solarized Light样式表

这显示了一个“Solarized_Light”样式的示例，它试图复制以下样式：

- http://ethanschoonover.com/solarized
- https://github.com/jrnold/ggthemes
- http://pygal.org/en/stable/documentation/builtin_styles.html#light-solarized

并且:

使用调色板的所有8个重音 - 从蓝色开始

进行:

- 为条形图和堆积图创建Alpha值。 .33或.5
- 应用布局规则

![Solarized Light样式表示例](https://matplotlib.org/_images/sphx_glr_plot_solarizedlight2_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np
x = np.linspace(0, 10)
with plt.style.context('Solarize_Light2'):
    plt.plot(x, np.sin(x) + x + np.random.randn(50))
    plt.plot(x, np.sin(x) + 2 * x + np.random.randn(50))
    plt.plot(x, np.sin(x) + 3 * x + np.random.randn(50))
    plt.plot(x, np.sin(x) + 4 + np.random.randn(50))
    plt.plot(x, np.sin(x) + 5 * x + np.random.randn(50))
    plt.plot(x, np.sin(x) + 6 * x + np.random.randn(50))
    plt.plot(x, np.sin(x) + 7 * x + np.random.randn(50))
    plt.plot(x, np.sin(x) + 8 * x + np.random.randn(50))
    # Number of accent colors in the color scheme
    plt.title('8 Random Lines - Line')
    plt.xlabel('x label', fontsize=14)
    plt.ylabel('y label', fontsize=14)

plt.show()
```

## 下载这个示例
            
- [下载python源码: plot_solarizedlight2.py](https://matplotlib.org/_downloads/plot_solarizedlight2.py)
- [下载Jupyter notebook: plot_solarizedlight2.ipynb](https://matplotlib.org/_downloads/plot_solarizedlight2.ipynb)