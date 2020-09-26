# 打印标准输出

将PNG打印到标准输出。

用法：python print_stdout.py > somefile.png

```python
import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

plt.plot([1, 2, 3])
plt.savefig(sys.stdout.buffer)
```

## 下载这个示例
            
- [下载python源码: print_stdout_sgskip.py](https://matplotlib.org/_downloads/print_stdout_sgskip.py)
- [下载Jupyter notebook: print_stdout_sgskip.ipynb](https://matplotlib.org/_downloads/print_stdout_sgskip.ipynb)