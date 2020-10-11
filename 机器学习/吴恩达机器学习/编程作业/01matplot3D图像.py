# 使用numpy实现线性回归
import numpy as np
import matplotlib.pyplot as plt


# 尝试使用matplot画了一个三维图像。
x_1 = np.arange(0,10,0.1)
x_1 = np.expand_dims(x_1,0)
x_1 = np.repeat(x_1,100,axis=0)
x_2= np.arange(0,10,0.1)
x_2 = np.expand_dims(x_2,1)
x_2 = np.repeat(x_2,100,axis=1)

y = np.repe
y = ((x_1+x_2-10)**2)

print(x_1.flatten())
ax = plt.axes(projection='3d')

ax.scatter3D(x_1.flatten(),x_2.flatten(),y.flatten(),c=y, cmap='Greens')

plt.show()
