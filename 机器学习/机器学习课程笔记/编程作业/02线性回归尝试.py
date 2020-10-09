# 吴恩达线性回归第一部分
# 这是第一个线性回归（机器学习算法）用来预测房价，感觉有点神奇。
import numpy as np

# 构造了样本数据集
x = np.arange(0,100,1)
loss = np.random.rand(100)-0.5
y = 2*x+6+loss

# 对样本数据集进行线性回归y=a0+a1x
# 给出参数的初始值
a0 = -10
a1 = -10
w = 0.0001 # 表示梯度下降速度

# 对a0进行梯度下降

for i in range(1000):
    a0 = a0-100*w*(1/100)*np.sum(a0+a1*x-y)
    a1 = a1-w*(1/100)*np.sum((a0+a1*x-y)*x)

print(a0,a1)




