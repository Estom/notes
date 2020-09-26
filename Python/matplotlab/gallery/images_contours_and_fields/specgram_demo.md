# 频谱图演示

频谱图的演示 ([specgram()](https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.specgram.html#matplotlib.axes.Axes.specgram))。

```python
import matplotlib.pyplot as plt
import numpy as np

# Fixing random state for reproducibility
np.random.seed(19680801)

dt = 0.0005
t = np.arange(0.0, 20.0, dt)
s1 = np.sin(2 * np.pi * 100 * t)
s2 = 2 * np.sin(2 * np.pi * 400 * t)

# create a transient "chirp"
mask = np.where(np.logical_and(t > 10, t < 12), 1.0, 0.0)
s2 = s2 * mask

# add some noise into the mix
nse = 0.01 * np.random.random(size=len(t))

x = s1 + s2 + nse  # the signal
NFFT = 1024  # the length of the windowing segments
Fs = int(1.0 / dt)  # the sampling frequency

fig, (ax1, ax2) = plt.subplots(nrows=2)
ax1.plot(t, x)
Pxx, freqs, bins, im = ax2.specgram(x, NFFT=NFFT, Fs=Fs, noverlap=900)
# The `specgram` method returns 4 objects. They are:
# - Pxx: the periodogram
# - freqs: the frequency vector
# - bins: the centers of the time bins
# - im: the matplotlib.image.AxesImage instance representing the data in the plot
plt.show()
```

![频谱图示例](https://matplotlib.org/_images/sphx_glr_specgram_demo_001.png)

## 参考

此示例中显示了以下函数的使用方法：

```python
import matplotlib
matplotlib.axes.Axes.specgram
matplotlib.pyplot.specgram
```

## 下载这个示例

- [下载python源码: specgram_demo.py](https://matplotlib.org/_downloads/specgram_demo.py)
- [下载Jupyter notebook: specgram_demo.ipynb](https://matplotlib.org/_downloads/specgram_demo.ipynb)