# 在matplotlib中使用重音文本

Matplotlib通过tex、mathtext或unicode支持重音字符。

使用mathtext，提供以下重音：hat，breve，grave，bar，acute，tilde，vec，dot，ddot。所有这些语法都具有相同的语法，例如，要创建一个overbar，你可以使用 bar{o} 或者使用 o 元音来执行 ddot{o}。 还提供了快捷方式，例如： "o 'e `e ~n .x ^y

![绘制重音文本示例](https://matplotlib.org/_images/sphx_glr_accented_text_001.png)

![绘制重音文本示例2](https://matplotlib.org/_images/sphx_glr_accented_text_002.png)

```python
import matplotlib.pyplot as plt

# Mathtext demo
fig, ax = plt.subplots()
ax.plot(range(10))
ax.set_title(r'$\ddot{o}\acute{e}\grave{e}\hat{O}'
             r'\breve{i}\bar{A}\tilde{n}\vec{q}$', fontsize=20)

# Shorthand is also supported and curly braces are optional
ax.set_xlabel(r"""$\"o\ddot o \'e\`e\~n\.x\^y$""", fontsize=20)
ax.text(4, 0.5, r"$F=m\ddot{x}$")
fig.tight_layout()

# Unicode demo
fig, ax = plt.subplots()
ax.set_title("GISCARD CHAHUTÉ À L'ASSEMBLÉE")
ax.set_xlabel("LE COUP DE DÉ DE DE GAULLE")
ax.set_ylabel('André was here!')
ax.text(0.2, 0.8, 'Institut für Festkörperphysik', rotation=45)
ax.text(0.4, 0.2, 'AVA (check kerning)')

plt.show()
```

## 下载这个示例
            
- [下载python源码: accented_text.py](https://matplotlib.org/_downloads/accented_text.py)
- [下载Jupyter notebook: accented_text.ipynb](https://matplotlib.org/_downloads/accented_text.ipynb)