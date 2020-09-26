# 默认文本旋转演示

默认情况下，Matplotlib执行文本布局的方式与某些人相反，因此本示例旨在使其更加清晰。

文本由其边界框（围绕墨水矩形的矩形框）对齐。 操作的顺序是旋转然后对齐。 基本上，文本以x，y位置为中心，围绕此点旋转，然后根据旋转文本的边界框对齐。

因此，如果指定left，bottom alignment，则旋转文本的边界框的左下角将位于文本的x，y坐标处。

但是一张图片胜过千言万语！

![默认文本旋转演示](https://matplotlib.org/_images/sphx_glr_text_rotation_001.png)

```python
import matplotlib.pyplot as plt
import numpy as np


def addtext(ax, props):
    ax.text(0.5, 0.5, 'text 0', props, rotation=0)
    ax.text(1.5, 0.5, 'text 45', props, rotation=45)
    ax.text(2.5, 0.5, 'text 135', props, rotation=135)
    ax.text(3.5, 0.5, 'text 225', props, rotation=225)
    ax.text(4.5, 0.5, 'text -45', props, rotation=-45)
    for x in range(0, 5):
        ax.scatter(x + 0.5, 0.5, color='r', alpha=0.5)
    ax.set_yticks([0, .5, 1])
    ax.set_xlim(0, 5)
    ax.grid(True)


# the text bounding box
bbox = {'fc': '0.8', 'pad': 0}

fig, axs = plt.subplots(2, 1)

addtext(axs[0], {'ha': 'center', 'va': 'center', 'bbox': bbox})
axs[0].set_xticks(np.arange(0, 5.1, 0.5), [])
axs[0].set_ylabel('center / center')

addtext(axs[1], {'ha': 'left', 'va': 'bottom', 'bbox': bbox})
axs[1].set_xticks(np.arange(0, 5.1, 0.5))
axs[1].set_ylabel('left / bottom')

plt.show()
```

## 下载这个示例
            
- [下载python源码: text_rotation.py](https://matplotlib.org/_downloads/text_rotation.py)
- [下载Jupyter notebook: text_rotation.ipynb](https://matplotlib.org/_downloads/text_rotation.ipynb)