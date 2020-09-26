# Pythonic Matplotlib

有些人喜欢编写更多的面向对象的Python代码，而不是使用pyPLOT接口来编写matplotlib。此示例向您展示了如何实现。

除非您是应用程序开发人员，否则我建议使用部分pyplot接口，尤其是图形，close，subplot，axes和show命令。 这些隐藏了您在正常图形创建中不需要看到的很多复杂性，例如实例化DPI实例，管理图形元素的边界框，创建和实现GUI窗口以及在其中嵌入图形。

如果您是应用程序开发人员并希望在应用程序中嵌入matplotlib，请遵循示例/ embedding_in_wx.py，examples / embedding_in_gtk.py或examples / embedding_in_tk.py的主题。 在这种情况下，您需要控制所有图形的创建，将它们嵌入应用程序窗口等。

如果您是Web应用程序开发人员，您可能希望使用webapp_demo.py中的示例，该示例显示如何直接使用后端agg图形画布，而不包含pyplot中存在的全局变量（当前图形，当前轴） 接口。 但请注意，没有理由说pyplot接口不适用于Web应用程序开发人员。

如果您在pyplot接口中编写的示例目录中看到一个示例，并且您希望使用真正的python方法调用来模拟它，则可以轻松进行映射。 其中许多示例使用“set”来控制图形属性。 以下是将这些命令映射到实例方法的方法。

set的语法是：

```python
plt.setp(object or sequence, somestring, attribute)
```

如果使用对象调用，则设置调用：

```python
object.set_somestring(attribute)
```

如果使用序列调用，则set：

```python
for object in sequence:
   object.set_somestring(attribute)
```

因此，对于您的示例，如果a是您的轴对象，则可以执行以下操作：

```python
a.set_xticklabels([])
a.set_yticklabels([])
a.set_xticks([])
a.set_yticks([])
```

![Pythonic Matplotlib示例](https://matplotlib.org/_images/sphx_glr_pythonic_matplotlib_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

t = np.arange(0.0, 1.0, 0.01)

fig, (ax1, ax2) = plt.subplots(2)

ax1.plot(t, np.sin(2*np.pi * t))
ax1.grid(True)
ax1.set_ylim((-2, 2))
ax1.set_ylabel('1 Hz')
ax1.set_title('A sine wave or two')

ax1.xaxis.set_tick_params(labelcolor='r')

ax2.plot(t, np.sin(2 * 2*np.pi * t))
ax2.grid(True)
ax2.set_ylim((-2, 2))
l = ax2.set_xlabel('Hi mom')
l.set_color('g')
l.set_fontsize('large')

plt.show()
```

## 下载这个示例
            
- [下载python源码: pythonic_matplotlib.py](https://matplotlib.org/_downloads/pythonic_matplotlib.py)
- [下载Jupyter notebook: pythonic_matplotlib.ipynb](https://matplotlib.org/_downloads/pythonic_matplotlib.ipynb)