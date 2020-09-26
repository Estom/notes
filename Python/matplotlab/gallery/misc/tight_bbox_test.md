# 严密的Bbox测试

![严密的Bbox测试示例](https://matplotlib.org/_images/sphx_glr_tight_bbox_test_001.png)

输出：

```python
saving tight_bbox_test.png
saving tight_bbox_test.pdf
saving tight_bbox_test.svg
saving tight_bbox_test.svgz
saving tight_bbox_test.eps
```

```python
import matplotlib.pyplot as plt
import numpy as np

ax = plt.axes([0.1, 0.3, 0.5, 0.5])

ax.pcolormesh(np.array([[1, 2], [3, 4]]))
plt.yticks([0.5, 1.5], ["long long tick label",
                        "tick label"])
plt.ylabel("My y-label")
plt.title("Check saved figures for their bboxes")
for ext in ["png", "pdf", "svg", "svgz", "eps"]:
    print("saving tight_bbox_test.%s" % (ext,))
    plt.savefig("tight_bbox_test.%s" % (ext,), bbox_inches="tight")
plt.show()
```

## 下载这个示例
            
- [下载python源码: tight_bbox_test.py](https://matplotlib.org/_downloads/tight_bbox_test.py)
- [下载Jupyter notebook: tight_bbox_test.ipynb](https://matplotlib.org/_downloads/tight_bbox_test.ipynb)