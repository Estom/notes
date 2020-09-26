# Pyplot 数学文本(Mathtext)

在文本标签中使用数学表达式。有关MathText的概述，请参阅[编写数学表达式](https://matplotlib.org/tutorials/text/mathtext.html)。

```python
import numpy as np
import matplotlib.pyplot as plt
t = np.arange(0.0, 2.0, 0.01)
s = np.sin(2*np.pi*t)

plt.plot(t,s)
plt.title(r'$\alpha_i > \beta_i$', fontsize=20)
plt.text(1, -0.6, r'$\sum_{i=0}^\infty x_i$', fontsize=20)
plt.text(0.6, 0.6, r'$\mathcal{A}\mathrm{sin}(2 \omega t)$',
         fontsize=20)
plt.xlabel('time (s)')
plt.ylabel('volts (mV)')
plt.show()
```

![数学文本示例](https://matplotlib.org/_images/sphx_glr_pyplot_mathtext_001.png)

## 参考

此示例显示了以下函数、方法、类和模块的使用：

```python
import matplotlib
matplotlib.pyplot.text
matplotlib.axes.Axes.text
```

## 下载这个示例
            
- [下载python源码: pyplot_mathtext.py](https://matplotlib.org/_downloads/pyplot_mathtext.py)
- [下载Jupyter notebook: pyplot_mathtext.ipynb](https://matplotlib.org/_downloads/pyplot_mathtext.ipynb)