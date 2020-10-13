import numpy as np
import matplotlib.pylab as plt
import scipy.io as sio
import math
import scipy.linalg as la
from mpl_toolkits.mplot3d import Axes3D

# ================== Part 1: Load Example Dataset  ===================
print('Visualizing example dataset for outlier detection.')
datainfo = sio.loadmat('ex8data1.mat')
X = datainfo['X']
Xval = datainfo['Xval']
Yval = datainfo['yval'][:, 0]

plt.plot(X[:, 0], X[:, 1], 'bx')
plt.axis([0, 30, 0, 30])
plt.xlabel('Latency (ms)')
plt.ylabel('Throughput (mb/s)')
plt.show()
_ = input('Press [Enter] to continue.')

# ================== Part 2: Estimate the dataset statistics ===================
# 高斯估计
def estimateGauss(x):
    m, n = x.shape
    mu = np.sum(x, 0)/m
    sigma = np.sum(np.power(x-mu, 2), 0)/m
    return mu, sigma

# 多变量高斯估计
def multivariateGaussian(x, mu, sigma2):
    k = np.size(mu, 0)
    sigma2 = np.diag(sigma2)
    x = x-mu
    p = (2*math.pi)**(-k/2)*la.det(sigma2)**(-0.5)*np.exp(-0.5*np.sum(x.dot(la.pinv(sigma2))*x, 1))
    return p

# 观测拟合效果
def visualFit(x, mu, sigma2):
    temp = np.arange(0, 35, 0.5)
    x1, x2 = np.meshgrid(temp, temp)
    z = multivariateGaussian(np.vstack((x1.flatten(), x2.flatten())).T, mu, sigma2)
    z = z.reshape(x1.shape)
    plt.plot(x[:, 0], x[:, 1], 'bx')
    plt.contour(x1, x2, z, np.power(10.0, np.arange(-20, 0, 3)))
    plt.xlabel('Latency (ms)')
    plt.ylabel('Throughput (mb/s)')

print('Visualizing Gaussian fit.')
mu, sigma2 = estimateGauss(X)
p = multivariateGaussian(X, mu, sigma2)
visualFit(X, mu, sigma2)
# plt.show()
_ = input('Press [Enter] to continue.')

# ================== Part 3: Find Outliers ===================
def selectThreshold(yval, pval):
    bestEpsilon = 0.0
    bestF1 = 0.0
    F1 = 0.0
    stepsize = (np.max(pval)-np.min(pval))/1000
    arrlist = np.arange(np.min(pval), np.max(pval), stepsize).tolist()
    for epsilon in arrlist:
        tp = np.sum(np.logical_and(pval < epsilon, yval == 1))
        fp = np.sum(np.logical_and(pval < epsilon, yval == 0))
        fn = np.sum(np.logical_and(pval >= epsilon, yval == 1))
        if tp+fp == 0 or tp+fn == 0:
            F1 = -1
        else:
            prec = tp/(tp+fp)
            rec = tp/(tp+fn)
            F1 = 2*prec*rec/(prec+rec)
        if F1 > bestF1:
            bestF1 = F1
            bestEpsilon = epsilon
    return bestF1, bestEpsilon


pval = multivariateGaussian(Xval, mu, sigma2)
F1, epsilon = selectThreshold(Yval, pval)
print('Best epsilon found using cross-validation: ', epsilon)
print('Best F1 on Cross Validation Set: ', F1)
print('(you should see a value epsilon of about 8.99e-05)')

outliers = np.where(p < epsilon)
plt.plot(X[outliers, 0], X[outliers, 1], 'o', mfc='none', ms=8, mec='r')
plt.show()
_ = input('Press [Enter] to continue.')

# ================== Part 4: Multidimensional Outliers ===================
datainfo = sio.loadmat('ex8data2.mat')
X = datainfo['X']
Xval = datainfo['Xval']
Yval = datainfo['yval'][:, 0]
mu, sigma2 = estimateGauss(X)
p = multivariateGaussian(X, mu, sigma2)
pval = multivariateGaussian(Xval, mu, sigma2)
F1, epsilon = selectThreshold(Yval, pval)
print('Best epsilon found using cross-validation: ', epsilon)
print('Best F1 on Cross Validation Set: ', F1)
print('# Outliers found: ', np.sum(p < epsilon))
print('(you should see a value epsilon of about 1.38e-18)')