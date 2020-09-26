# 多进程

演示使用多处理在一个过程中生成数据并在另一个过程中绘图。

由Robert Cimrman撰写

```python
import multiprocessing as mp
import time

import matplotlib.pyplot as plt
import numpy as np

# Fixing random state for reproducibility
np.random.seed(19680801)
```

## 进程类

此类绘制从管道接收的数据。

```python
class ProcessPlotter(object):
    def __init__(self):
        self.x = []
        self.y = []

    def terminate(self):
        plt.close('all')

    def call_back(self):
        while self.pipe.poll():
            command = self.pipe.recv()
            if command is None:
                self.terminate()
                return False
            else:
                self.x.append(command[0])
                self.y.append(command[1])
                self.ax.plot(self.x, self.y, 'ro')
        self.fig.canvas.draw()
        return True

    def __call__(self, pipe):
        print('starting plotter...')

        self.pipe = pipe
        self.fig, self.ax = plt.subplots()
        timer = self.fig.canvas.new_timer(interval=1000)
        timer.add_callback(self.call_back)
        timer.start()

        print('...done')
        plt.show()
```

## 绘图类

此类使用多处理来生成一个进程，以运行上面的类中的代码。 初始化时，它会创建一个管道和一个ProcessPlotter实例，它将在一个单独的进程中运行。

从命令行运行时，父进程将数据发送到生成的进程，然后通过ProcessPlotter中指定的回调函数绘制：__call__。

```python
class NBPlot(object):
    def __init__(self):
        self.plot_pipe, plotter_pipe = mp.Pipe()
        self.plotter = ProcessPlotter()
        self.plot_process = mp.Process(
            target=self.plotter, args=(plotter_pipe,), daemon=True)
        self.plot_process.start()

    def plot(self, finished=False):
        send = self.plot_pipe.send
        if finished:
            send(None)
        else:
            data = np.random.random(2)
            send(data)


def main():
    pl = NBPlot()
    for ii in range(10):
        pl.plot()
        time.sleep(0.5)
    pl.plot(finished=True)


if __name__ == '__main__':
    if plt.get_backend() == "MacOSX":
        mp.set_start_method("forkserver")
    main()
```

## 下载这个示例
            
- [下载python源码: multiprocess_sgskip.py](https://matplotlib.org/_downloads/multiprocess_sgskip.py)
- [下载Jupyter notebook: multiprocess_sgskip.ipynb](https://matplotlib.org/_downloads/multiprocess_sgskip.ipynb)