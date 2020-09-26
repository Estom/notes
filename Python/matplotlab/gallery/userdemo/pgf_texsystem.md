# Pgf文本系统

![Pgf文本系统示例](https://matplotlib.org/_images/sphx_glr_pgf_texsystem_001.png)

```python
import matplotlib.pyplot as plt
plt.rcParams.update({
    "pgf.texsystem": "pdflatex",
    "pgf.preamble": [
         r"\usepackage[utf8x]{inputenc}",
         r"\usepackage[T1]{fontenc}",
         r"\usepackage{cmbright}",
         ]
})

plt.figure(figsize=(4.5, 2.5))
plt.plot(range(5))
plt.text(0.5, 3., "serif", family="serif")
plt.text(0.5, 2., "monospace", family="monospace")
plt.text(2.5, 2., "sans-serif", family="sans-serif")
plt.xlabel(r"µ is not $\mu$")
plt.tight_layout(.5)

plt.savefig("pgf_texsystem.pdf")
plt.savefig("pgf_texsystem.png")
```

## 下载这个示例
            
- [下载python源码: pgf_texsystem.py](https://matplotlib.org/_downloads/pgf_texsystem.py)
- [下载Jupyter notebook: pgf_texsystem.ipynb](https://matplotlib.org/_downloads/pgf_texsystem.ipynb)