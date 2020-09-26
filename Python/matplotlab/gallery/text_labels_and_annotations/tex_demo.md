# 使用纹理渲染数学方程

如果设置了rc参数text.usetex，则可以使用TeX渲染所有matplotlib文本。这当前在agg和ps后端上工作，并且要求你在系统上正确安装了[Text render With LaTeX](https://matplotlib.org/tutorials/text/usetex.html)教程中描述的tex和其他依赖项。第一次运行脚本时，你将看到tex和相关工具的大量输出。下一次，运行可能是静默的，因为许多信息都被缓存。

注意如何使用unicode提供y轴的标签！

![使用纹理渲染数学方程示例](https://matplotlib.org/_images/sphx_glr_tex_demo_001.png)

```python
import numpy as np
import matplotlib
matplotlib.rcParams['text.usetex'] = True
import matplotlib.pyplot as plt


t = np.linspace(0.0, 1.0, 100)
s = np.cos(4 * np.pi * t) + 2

fig, ax = plt.subplots(figsize=(6, 4), tight_layout=True)
ax.plot(t, s)

ax.set_xlabel(r'\textbf{time (s)}')
ax.set_ylabel('\\textit{Velocity (\N{DEGREE SIGN}/sec)}', fontsize=16)
ax.set_title(r'\TeX\ is Number $\displaystyle\sum_{n=1}^\infty'
             r'\frac{-e^{i\pi}}{2^n}$!', fontsize=16, color='r')
plt.show()
```

## 下载这个示例
            
- [下载python源码: tex_demo.py](https://matplotlib.org/_downloads/tex_demo.py)
- [下载Jupyter notebook: tex_demo.ipynb](https://matplotlib.org/_downloads/tex_demo.ipynb)