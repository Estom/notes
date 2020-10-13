import numpy as np
import matplotlib.pylab as plt
from scipy import linalg

# ================ Part 1: Feature Normalization ================
print('Loading data ...')
data = np.loadtxt('ex1data2.txt', delimiter=',')
X = data[:, 0:2]
Y = data[:, 2]
m = np.size(Y, 0)

print('First 10 examples from the dataset:')
for i in range(10):
    print('x=[%.0f %.0f], y=%.0f' %(X[i, 0], X[i, 1], Y[i]))
_ = input('Press [Enter] to continue.')

print('Normalizing Features...')

# 归一化函数
def featureNormalize(x):
    mu = np.mean(x, axis=0)
    sigma = np.std(x, axis=0)
    x_norm = np.divide(x-mu, sigma)
    return x_norm, mu, sigma

X, mu, sigma = featureNormalize(X)

X = np.concatenate((np.ones((m, 1)), X), axis=1)

# ================ Part 2: Gradient Descent ================
print('Running gradient descent ...')

# 计算损失函数值
def computeCostMulti(x, y, theta):
    m = np.size(y, 0)
    j = (x.dot(theta)-y).dot(x.dot(theta)-y)/(2*m)
    return j

def gradientDescentMulti(x, y, theta, alpha, num_iters):
    m = np.size(y, 0)
    j_history = np.zeros((num_iters,))
    for i in range(num_iters):
        theta = theta-alpha*(X.T.dot(X.dot(theta)-y)/m)
        j_history[i] = computeCostMulti(x, y, theta)
    return theta, j_history

alpha = 0.01
num_iters = 400

theta = np.zeros((3,))
theta, j_history = gradientDescentMulti(X, Y, theta, alpha, num_iters)

plt.plot(np.arange(np.size(j_history, 0)), j_history, '-b', lw=2)
plt.xlabel('Number of iterations')
plt.ylabel('Cost J')
plt.show()

print('Theta computed from gradient descent: ', theta)

# Estimate the price of a 1650 sq-ft, 3 br house
X_test = np.array([1650, 3])
X_test = np.divide(X_test-mu, sigma)
X_test = np.hstack((1, X_test))
price = X_test.dot(theta)
print('Predicted price of a 1650 sq-ft, 3 br house (using gradient descent): ', price)
_ = input('Press [Enter] to continue.')

# ================ Part 3: Normal Equations ================
data = np.loadtxt('ex1data2.txt', delimiter=',')
X = data[:, 0:2]
Y = data[:, 2]
m = np.size(Y, 0)

X = np.concatenate((np.ones((m, 1)), X), axis=1)

# 利用标准公式求解theta
def normalEqn(x, y):
    theta = linalg.pinv(X.T.dot(X)).dot(X.T).dot(y)
    return theta


theta = normalEqn(X, Y)
print('Theta computed from the normal equations: ', theta)

# Estimate the price of a 1650 sq-ft, 3 br house
X_test = np.array([1, 1650, 3])
price = X_test.dot(theta)
print('Predicted price of a 1650 sq-ft, 3 br house (using normal equations): ', price)

