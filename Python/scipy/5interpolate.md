
## 定义

插值是在直线或曲线上的两点之间找到值的过程。 为了帮助记住它的含义，我们应该将“inter”这个词的第一部分想象为“输入”，表示要查看原来数据的“内部”。 这种插值工具不仅适用于统计学，而且在科学，商业或需要预测两个现有数据点内的值时也很有用。

```py
import numpy as np
from scipy import interpolate
import matplotlib.pyplot as plt
x = np.linspace(0, 4, 12)
y = np.cos(x**2/3+4)


plt.plot(x, y,’o’)
plt.show()
```

## 一维插值

一维插值scipy.interpolate中的interp1d类是一种创建基于固定数据点的函数的便捷方法，可以使用线性插值在给定数据定义的域内的任意位置评估该函数。
通过使用上述数据，创建一个插值函数并绘制一个新的插值图。
```
f1 = interp1d(x, y,kind = 'linear')

f2 = interp1d(x, y, kind = 'cubic'


```