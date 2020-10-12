import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.axes3d import Axes3D

x, y = np.mgrid[-5:5:.1, -5:5:.1]
sigma = [[1, 0.9], [0.9, 3]]
# print(x.size)

xf = x.flatten()
yf = y.flatten()

xy = np.stack((xf, yf), axis=1)

# print(xy)
z1 = 1/(2*np.pi*np.sqrt(np.linalg.det(sigma)))
z2 = -1/2.0*np.sum(np.matmul(xy, sigma)*xy, axis=1)

z = z1*np.exp(z2)
z = np.reshape(z, (100, 100))
# print(z2)

print(x.shape, y.shape, z.shape)

figure = plt.figure()
ax = Axes3D(figure)
ax.plot_surface(x, y, z, rstride=1, cstride=1, cmap=plt.get_cmap('rainbow'))

plt.show()
