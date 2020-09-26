# Pgf序言

```python
import matplotlib as mpl
mpl.use("pgf")
import matplotlib.pyplot as plt
plt.rcParams.update({
    "font.family": "serif",  # use serif/main font for text elements
    "text.usetex": True,     # use inline math for ticks
    "pgf.rcfonts": False,    # don't setup fonts from rc parameters
    "pgf.preamble": [
         "\\usepackage{units}",          # load additional packages
         "\\usepackage{metalogo}",
         "\\usepackage{unicode-math}",   # unicode math setup
         r"\setmathfont{xits-math.otf}",
         r"\setmainfont{DejaVu Serif}",  # serif font via preamble
         ]
})

plt.figure(figsize=(4.5, 2.5))
plt.plot(range(5))
plt.xlabel("unicode text: я, ψ, €, ü, \\unitfrac[10]{°}{µm}")
plt.ylabel("\\XeLaTeX")
plt.legend(["unicode math: $λ=∑_i^∞ μ_i^2$"])
plt.tight_layout(.5)

plt.savefig("pgf_preamble.pdf")
plt.savefig("pgf_preamble.png")
```

## 下载这个示例
            
- [下载python源码: pgf_preamble_sgskip.py](https://matplotlib.org/_downloads/pgf_preamble_sgskip.py)
- [下载Jupyter notebook: pgf_preamble_sgskip.ipynb](https://matplotlib.org/_downloads/pgf_preamble_sgskip.ipynb)