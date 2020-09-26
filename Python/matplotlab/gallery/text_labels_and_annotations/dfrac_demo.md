# \dfrac 和 \frac之间的区别

在此示例中，说明了 \dfrac和\frac TeX宏之间的差异; 特别是，使用Mathtex时显示样式和文本样式分数之间的差异。

*New in version 2.1*.

**注意**：要将 \dfrac与LaTeX引擎一起使用（text.usetex：True），您需要使用text.latex.preamble rc导入amsmath包，这是一个不受支持的功能; 因此，在 \frac宏之前使用 \displaystyle选项来获取LaTeX引擎的这种行为可能是个更好的主意。

![dfrac喝frac公式](https://matplotlib.org/_images/sphx_glr_dfrac_demo_001.png)

```python
import matplotlib.pyplot as plt

fig = plt.figure(figsize=(5.25, 0.75))
fig.text(0.5, 0.3, r'\dfrac: $\dfrac{a}{b}$',
         horizontalalignment='center', verticalalignment='center')
fig.text(0.5, 0.7, r'\frac: $\frac{a}{b}$',
         horizontalalignment='center', verticalalignment='center')
plt.show()
```

## 下载这个示例
            
- [下载python源码: dfrac_demo.py](https://matplotlib.org/_downloads/dfrac_demo.py)
- [下载Jupyter notebook: dfrac_demo.ipynb](https://matplotlib.org/_downloads/dfrac_demo.ipynb)