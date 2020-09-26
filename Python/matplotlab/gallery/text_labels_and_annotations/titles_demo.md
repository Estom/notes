# 标题组演示

Matplotlib可以显示打印标题居中，与一组轴的左侧齐平，并与一组轴的右侧齐平。

![设置标题示例](https://matplotlib.org/_images/sphx_glr_titles_demo_001.png)

```python
import matplotlib.pyplot as plt

plt.plot(range(10))

plt.title('Center Title')
plt.title('Left Title', loc='left')
plt.title('Right Title', loc='right')

plt.show()
```

## 下载这个示例
            
- [下载python源码: titles_demo.py](https://matplotlib.org/_downloads/titles_demo.py)
- [下载Jupyter notebook: titles_demo.ipynb](https://matplotlib.org/_downloads/titles_demo.ipynb)