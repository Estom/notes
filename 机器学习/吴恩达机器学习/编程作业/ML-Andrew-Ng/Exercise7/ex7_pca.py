import numpy as np
import matplotlib.pylab as plt
import scipy.io as sio
import numpy.linalg as la
import math
import matplotlib.cm as cm
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.colors as pltcolor

# ================== Part 1: Load Example Dataset  ===================
print('Visualizing example dataset for PCA.')
datainfo = sio.loadmat('ex7data1.mat')
X = datainfo['X']
plt.plot(X[:, 0], X[:, 1], 'bo')
plt.axis([0.5, 6.5, 2, 8])
plt.axis('equal')
_ = input('Press [Enter] to continue.')

# =============== Part 2: Principal Component Analysis ===============
# 归一化
def featureNormalize(x):
    mu = np.mean(x, 0)
    sigma = np.std(x, 0, ddof=1)
    x_norm = (x-mu)/sigma
    return x_norm, mu, sigma

# pca
def pca(x):
    m, n = np.shape(x)
    sigma = 1/m*x.T.dot(x)
    u, s, _ = la.svd(sigma)
    return u, s

# 两点连线
def drawLine(p1, p2, lc='k-', lwidth=2):
    x = np.array([p1[0], p2[0]])
    y = np.array([p1[1], p2[1]])
    plt.plot(x, y, lc, lw=lwidth)

print('Running PCA on example dataset.')
x_norm, mu, sigma = featureNormalize(X)
u, s = pca(x_norm)
drawLine(mu, mu+1.5*s[0]*u[:, 0])
drawLine(mu, mu+1.5*s[1]*u[:, 1])
plt.show()

print('Top eigenvector: ')
print(' U(:,1) = %f %f ' %(u[0, 0], u[1, 0]))
print('(you should expect to see -0.707107 -0.707107)')
_ = input('Press [Enter] to continue.')

# =================== Part 3: Dimension Reduction ===================
# 映射数据
def projectData(x, u, k):
    z = x.dot(u[:, 0:k])
    return z

# 数据复原
def recoverData(z, u, k):
    x_rec = np.asmatrix(z).dot(u[:, 0:k].T)
    return np.asarray(x_rec)

print('Dimension reduction on example dataset.')
plt.plot(x_norm[:, 0], x_norm[:, 1], 'bo')
plt.axis([-4, 3, -4, 3])
plt.axis('equal')

k = 1
z = projectData(x_norm, u, k)
print('Projection of the first example: ', z[0])
print('(this value should be about 1.481274)')
x_rec = recoverData(z, u, k)
print('Approximation of the first example: %f %f' % (x_rec[0, 0], x_rec[0, 1]))
plt.plot(x_rec[:, 0], x_rec[:, 1], 'ro')
for i in range(np.size(x_norm, 0)):
    drawLine(x_norm[i, :], x_rec[i, :], 'k--', 1)
plt.show()
_ = input('Press [Enter] to continue.')

# =============== Part 4: Loading and Visualizing Face Data =============
# 显示数据
def displayData(x):
    width = round(math.sqrt(np.size(x, 1)))
    m, n = np.shape(x)
    height = int(n/width)
    # 显示图像的数量
    drows = math.floor(math.sqrt(m))
    dcols = math.ceil(m/drows)

    pad = 1
    # 建立一个空白“背景布”
    darray = -1*np.ones((pad+drows*(height+pad), pad+dcols*(width+pad)))

    curr_ex = 0
    for j in range(drows):
        for i in range(dcols):
            if curr_ex >= m:
                break
            max_val = np.max(np.abs(x[curr_ex, :]))
            darray[pad+j*(height+pad):pad+j*(height+pad)+height, pad+i*(width+pad):pad+i*(width+pad)+width]\
                = x[curr_ex, :].reshape((height, width))/max_val
            curr_ex += 1
        if curr_ex >= m:
            break

    plt.imshow(darray.T, cmap='gray')


print('Loading face dataset.')
datainfo = sio.loadmat('ex7faces.mat')
X = datainfo['X']
displayData(X[0:100, :])
plt.show()
_ = input('Press [Enter] to continue.')

# =========== Part 5: PCA on Face Data: Eigenfaces  ===================
print('Running PCA on face dataset\n(this mght take a minute or two ...)')
x_norm, mu, sigma = featureNormalize(X)
u, s = pca(x_norm)
displayData(u[:, 0:36].T)
plt.show()
_ = input('Press [Enter] to continue.')

# ============= Part 6: Dimension Reduction for Faces =================
print('Dimension reduction for face dataset.')
K = 100
Z = projectData(x_norm, u, K)
print('the project data Z has a size of ', np.shape(Z))
_ = input('Press [Enter] to continue.')

# ==== Part 7: Visualization of Faces after PCA Dimension Reduction ====
print('Visualizing the projected (reduced dimension) faces.')
X_rec = recoverData(Z, u, K)
fig = plt.figure()
plt.subplot(121)
displayData(x_norm[0:100, :])
plt.title('Original faces')
plt.subplot(122)
displayData(X_rec[0:100, :])
plt.title('Recovered faces')
plt.show()
_ = input('Press [Enter] to continue.')

# === Part 8(a): Optional (ungraded) Exercise: PCA for Visualization ===
# 生成初始点
def kMeansInitCenter(x, k):
    randidx = np.random.permutation(np.size(x, 0))
    center = x[randidx[0: k], :]
    return center

# 找出最邻近点
def findCloseCenter(x, center):
    k, l = np.shape(center)
    xtemp = np.tile(x, k)
    centertemp = center.flatten()
    xtemp = np.power(xtemp-centertemp, 2)
    xt = np.zeros((np.size(xtemp, 0), k))
    for i in range(k):
        for j in range(l):
            xt[:, i] = xt[:, i]+xtemp[:, i*l+j]
    idx = np.argmin(xt, 1)+1
    return idx

# 找出中心点
def computeCenter(x, idx, k):
    m, n = np.shape(x)
    center = np.zeros((k, n))
    for i in range(k):
        pos = np.where(idx == i+1)
        center[i, :] = np.sum(x[pos], 0)/np.size(x[pos], 0)
    return center

# k均值聚类
def runkMeans(x, init_center, max_iter):
    m, n = np.shape(x)
    k = np.size(init_center, 0)
    center = init_center
    idx = np.zeros((m,))

    for i in range(max_iter):
        idx = findCloseCenter(x, center)
        center = computeCenter(x, idx, k)
    return center, idx

A = plt.imread('bird_small.png')
img_size = np.shape(A)
X = A.reshape(img_size[0]*img_size[1], img_size[2])
K = 16
max_iter = 10
init_center = kMeansInitCenter(X, K)
center, idx = runkMeans(X, init_center, max_iter)

sel = np.floor(np.random.random((1000,))*np.size(X, 0)).astype(int)+1
colors = cm.rainbow(np.linspace(0, 1, K))
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.scatter(X[sel, 0], X[sel, 1], X[sel, 2], c=idx[sel], cmap=pltcolor.ListedColormap(colors), marker='o')
ax.set_title('Pixel dataset plotted in 3D. Color shows centroid memberships')
plt.show()
_ = input('Press [Enter] to continue.')

# === Part 8(b): Optional (ungraded) Exercise: PCA for Visualization ===
X_norm, mu, sigma = featureNormalize(X)
u, s = pca(X_norm)
Z = projectData(X_norm, u, 2)

colors = cm.rainbow(np.linspace(0, 1, K))
plt.scatter(Z[sel, 0], Z[sel, 1], c=idx[sel], cmap=pltcolor.ListedColormap(colors), marker='o')
plt.title('Pixel dataset plotted in 2D, using PCA for dimensionality reduction')
plt.show()
_ = input('Press [Enter] to continue.')

