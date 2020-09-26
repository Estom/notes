# pyplot动画

通过调用绘图命令之间的[暂停](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.pause.html#matplotlib.pyplot.pause)来生成动画。

此处显示的方法仅适用于简单，低性能的使用。 对于要求更高的应用程序，请查看``动画模块``和使用它的示例。

请注意，调用[time.sleep](https://docs.python.org/3/library/time.html#time.sleep)而不是[暂停](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.pause.html#matplotlib.pyplot.pause)将不起作用。

![pyplot动画](https://matplotlib.org/_images/sphx_glr_animation_demo_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

np.random.seed(19680801)
data = np.random.random((50, 50, 50))

fig, ax = plt.subplots()

for i in range(len(data)):
    ax.cla()
    ax.imshow(data[i])
    ax.set_title("frame {}".format(i))
    # Note that using time.sleep does *not* work here!
    plt.pause(0.1)
```

**脚本总运行时间：**（0分7.211秒）

## 下载这个示例
            
- [下载python源码: animation_demo.py](https://matplotlib.org/_downloads/animation_demo.py)
- [下载Jupyter notebook: animation_demo.ipynb](https://matplotlib.org/_downloads/animation_demo.ipynb)