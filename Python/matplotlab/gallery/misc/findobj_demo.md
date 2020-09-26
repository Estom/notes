# Findobj演示

递归查找符合某些条件的所有对象

![Findobj演示](https://matplotlib.org/_images/sphx_glr_findobj_demo_001.png)

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.text as text

a = np.arange(0, 3, .02)
b = np.arange(0, 3, .02)
c = np.exp(a)
d = c[::-1]

fig, ax = plt.subplots()
plt.plot(a, c, 'k--', a, d, 'k:', a, c + d, 'k')
plt.legend(('Model length', 'Data length', 'Total message length'),
           loc='upper center', shadow=True)
plt.ylim([-1, 20])
plt.grid(False)
plt.xlabel('Model complexity --->')
plt.ylabel('Message length --->')
plt.title('Minimum Message Length')


# match on arbitrary function
def myfunc(x):
    return hasattr(x, 'set_color') and not hasattr(x, 'set_facecolor')


for o in fig.findobj(myfunc):
    o.set_color('blue')

# match on class instances
for o in fig.findobj(text.Text):
    o.set_fontstyle('italic')


plt.show()
```

## 下载这个示例
            
- [下载python源码: findobj_demo.py](https://matplotlib.org/_downloads/findobj_demo.py)
- [下载Jupyter notebook: findobj_demo.ipynb](https://matplotlib.org/_downloads/findobj_demo.ipynb)