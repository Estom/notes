# 花式文本框演示

![花式文本框演示](https://matplotlib.org/_images/sphx_glr_fancytextbox_demo_001.png)

```python
import matplotlib.pyplot as plt

plt.text(0.6, 0.5, "test", size=50, rotation=30.,
         ha="center", va="center",
         bbox=dict(boxstyle="round",
                   ec=(1., 0.5, 0.5),
                   fc=(1., 0.8, 0.8),
                   )
         )

plt.text(0.5, 0.4, "test", size=50, rotation=-30.,
         ha="right", va="top",
         bbox=dict(boxstyle="square",
                   ec=(1., 0.5, 0.5),
                   fc=(1., 0.8, 0.8),
                   )
         )

plt.show()
```

## 下载这个示例
            
- [下载python源码: fancytextbox_demo.py](https://matplotlib.org/_downloads/fancytextbox_demo.py)
- [下载Jupyter notebook: fancytextbox_demo.ipynb](https://matplotlib.org/_downloads/fancytextbox_demo.ipynb)