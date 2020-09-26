# Usetex 字体效果

此脚本演示了pdf usetex现在支持pdftex.map中指定的字体效果。

![Usetex 字体效果示例](https://matplotlib.org/_images/sphx_glr_usetex_fonteffects_001.png)

```python
import matplotlib
import matplotlib.pyplot as plt
matplotlib.rc('text', usetex=True)


def setfont(font):
    return r'\font\a %s at 14pt\a ' % font


for y, font, text in zip(range(5),
                         ['ptmr8r', 'ptmri8r', 'ptmro8r',
                          'ptmr8rn', 'ptmrr8re'],
                         ['Nimbus Roman No9 L ' + x for x in
                          ['', 'Italics (real italics for comparison)',
                           '(slanted)', '(condensed)', '(extended)']]):
    plt.text(0, y, setfont(font) + text)

plt.ylim(-1, 5)
plt.xlim(-0.2, 0.6)
plt.setp(plt.gca(), frame_on=False, xticks=(), yticks=())
plt.title('Usetex font effects')
plt.savefig('usetex_fonteffects.pdf')
```

脚本的总运行时间：（0分1.262秒）

## 下载这个示例
            
- [下载python源码: usetex_fonteffects.py](https://matplotlib.org/_downloads/usetex_fonteffects.py)
- [下载Jupyter notebook: usetex_fonteffects.ipynb](https://matplotlib.org/_downloads/usetex_fonteffects.ipynb)