# 数学文本演示

使用Matplotlib的内部LaTeX解析器和布局引擎。 有关真正的LaTeX渲染，请参阅text.usetex选项。

![数学文本演示](https://matplotlib.org/_images/sphx_glr_mathtext_demo_001.png)

```python
import matplotlib.pyplot as plt

fig, ax = plt.subplots()

ax.plot([1, 2, 3], 'r', label=r'$\sqrt{x^2}$')
ax.legend()

ax.set_xlabel(r'$\Delta_i^j$', fontsize=20)
ax.set_ylabel(r'$\Delta_{i+1}^j$', fontsize=20)
ax.set_title(r'$\Delta_i^j \hspace{0.4} \mathrm{versus} \hspace{0.4} '
             r'\Delta_{i+1}^j$', fontsize=20)

tex = r'$\mathcal{R}\prod_{i=\alpha_{i+1}}^\infty a_i\sin(2 \pi f x_i)$'
ax.text(1, 1.6, tex, fontsize=20, va='bottom')

fig.tight_layout()
plt.show()
```

## 下载这个示例
            
- [下载python源码: mathtext_demo.py](https://matplotlib.org/_downloads/mathtext_demo.py)
- [下载Jupyter notebook: mathtext_demo.ipynb](https://matplotlib.org/_downloads/mathtext_demo.ipynb)