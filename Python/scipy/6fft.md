
## 傅里叶变换

对时域信号计算傅里叶变换以检查其在频域中的行为。 傅里叶变换可用于信号和噪声处理，图像处理，音频信号处理等领域。SciPy提供fftpack模块，可让用户计算快速傅立叶变换。
以下是一个正弦函数的例子，它将用于使用fftpack模块计算傅里叶变换。

## 一维傅里叶变换

```py
#Importing the fft and inverse fft functions from fftpackage
from scipy.fftpack import fft

#create an array with random n numbers
x = np.array([1.0, 2.0, 1.0, -1.0, 1.5])

#Applying the fft function
y = fft(x)
print (y)
```

## 离散余弦变换

```py
from scipy.fftpack import dct
mydict = dct(np.array([4., 3., 5., 10., 5., 3.]))
print(mydict)
```