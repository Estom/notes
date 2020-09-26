# Pgf字体

![Pgf字体](https://matplotlib.org/_images/sphx_glr_pgf_fonts_001.png)

```python
import matplotlib.pyplot as plt
plt.rcParams.update({
    "font.family": "serif",
    "font.serif": [],                    # use latex default serif font
    "font.sans-serif": ["DejaVu Sans"],  # use a specific sans-serif font
})

plt.figure(figsize=(4.5, 2.5))
plt.plot(range(5))
plt.text(0.5, 3., "serif")
plt.text(0.5, 2., "monospace", family="monospace")
plt.text(2.5, 2., "sans-serif", family="sans-serif")
plt.text(2.5, 1., "comic sans", family="Comic Sans MS")
plt.xlabel("µ is not $\\mu$")
plt.tight_layout(.5)

plt.savefig("pgf_fonts.pdf")
plt.savefig("pgf_fonts.png")
```

## 下载这个示例
            
- [下载python源码: pgf_fonts.py](https://matplotlib.org/_downloads/pgf_fonts.py)
- [下载Jupyter notebook: pgf_fonts.ipynb](https://matplotlib.org/_downloads/pgf_fonts.ipynb)