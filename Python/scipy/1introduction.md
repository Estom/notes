## 功能概述
SciPy is a collection of mathematical algorithms and convenience functions built on the NumPy extension of Python.

Scipy是一个高级的科学计算库，建立在低一级的numpy的多维数组之上。Scipy有很多子模块可以完成不同的操作，如傅里叶变换、插值运算、优化算法和数学统计等。Scipy的常用的子模块如下：
```py
scipy.cluster	        向量量化k-means
scipy.constants	        数学常量
scipy.fftpack	        快速傅里叶变换
scipy.integrate	        积分
scipy.interpolate	    插值
scipy.io	            数据输入输出
scipy.linalg	        线性代数
scipy.ndimage	        N维图像
scipy.odr	            正交距离回归
scipy.optimize	        优化算法
scipy.signal	        信号处理
scipy.sparse	        稀疏矩阵
scipy.spatial	        空间数据结构和算法
scipy.special	        特殊数学函数
scipy.stats	            统计函数

>>> from scipy import linalg, optimize
```


> numpy提供了ndarray对象和关于该对象的基本操作和基本运算。scipy提供了ndarray的科学计算。


## 查看帮助

```py
help(optimize.fmin)

np.info(optimize.fmin)
```