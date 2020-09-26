# STIX 字体演示

![STIX 字体演示](https://matplotlib.org/_images/sphx_glr_stix_fonts_demo_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np

tests = [
    r'$\mathcircled{123} \mathrm{\mathcircled{123}}'
    r' \mathbf{\mathcircled{123}}$',
    r'$\mathsf{Sans \Omega} \mathrm{\mathsf{Sans \Omega}}'
    r' \mathbf{\mathsf{Sans \Omega}}$',
    r'$\mathtt{Monospace}$',
    r'$\mathcal{CALLIGRAPHIC}$',
    r'$\mathbb{Blackboard \pi}$',
    r'$\mathrm{\mathbb{Blackboard \pi}}$',
    r'$\mathbf{\mathbb{Blackboard \pi}}$',
    r'$\mathfrak{Fraktur} \mathbf{\mathfrak{Fraktur}}$',
    r'$\mathscr{Script}$']


plt.figure(figsize=(8, (len(tests) * 1) + 2))
plt.plot([0, 0], 'r')
plt.axis([0, 3, -len(tests), 0])
plt.yticks(-np.arange(len(tests)))
for i, s in enumerate(tests):
    plt.text(0.1, -i, s, fontsize=32)

plt.show()
```

## 下载这个示例
            
- [下载python源码: stix_fonts_demo.py](https://matplotlib.org/_downloads/stix_fonts_demo.py)
- [下载Jupyter notebook: stix_fonts_demo.ipynb](https://matplotlib.org/_downloads/stix_fonts_demo.ipynb)