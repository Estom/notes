# 地理预测

这显示了使用子图的4个可能的投影。Matplotlib还支持 [Basemaps Toolkit](https://matplotlib.org/basemap) 和 [Cartopy](http://scitools.org.uk/cartopy) 用于地理预测。

```python
import matplotlib.pyplot as plt
```

```python
plt.figure()
plt.subplot(111, projection="aitoff")
plt.title("Aitoff")
plt.grid(True)
```

![地理预测示例](https://matplotlib.org/_images/sphx_glr_geo_demo_001.png)

```python
plt.figure()
plt.subplot(111, projection="hammer")
plt.title("Hammer")
plt.grid(True)
```

![地理预测示例2](https://matplotlib.org/_images/sphx_glr_geo_demo_002.png)

```python
plt.figure()
plt.subplot(111, projection="lambert")
plt.title("Lambert")
plt.grid(True)
```

![地理预测示例3](https://matplotlib.org/_images/sphx_glr_geo_demo_003.png)

```python
plt.figure()
plt.subplot(111, projection="mollweide")
plt.title("Mollweide")
plt.grid(True)

plt.show()
```

![地理预测示例4](https://matplotlib.org/_images/sphx_glr_geo_demo_004.png)

## 下载这个示例
            
- [下载python源码: geo_demo.py](https://matplotlib.org/_downloads/geo_demo.py)
- [下载Jupyter notebook: geo_demo.ipynb](https://matplotlib.org/_downloads/geo_demo.ipynb)