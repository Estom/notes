import numpy as np
import matplotlib.pylab as plt
import scipy.optimize as op

# 加载数据
data = np.loadtxt('ex2data2.txt', delimiter=',')
X = data[:, 0:2]
Y = data[:, 2]

def plotData(x, y):
    pos = np.where(y == 1)
    neg = np.where(y == 0)
    p1 = plt.scatter(x[pos, 0], x[pos, 1], marker='+', s=50, color='b')
    p2 = plt.scatter(x[neg, 0], x[neg, 1], marker='o', s=50, color='y')
    plt.legend((p1, p2), ('Admitted', 'Not admitted'), loc='upper right', fontsize=8)
    plt.xlabel('Exam 1 score')
    plt.ylabel('Exam 2 score')
    plt.show()

plotData(X, Y)

# =========== Part 1: Regularized Logistic Regression ============
# 向高维扩展
def mapFeature(x1, x2):
    degree = 6
    col = int(degree*(degree+1)/2+degree+1)
    out = np.ones((np.size(x1, 0), col))
    count = 1
    for i in range(1, degree+1):
        for j in range(i+1):
            out[:, count] = np.power(x1, i-j)*np.power(x2, j)
            count += 1
    return out

X = mapFeature(X[:, 0], X[:, 1])
init_theta = np.zeros((np.size(X, 1),))
lamd = 1

# sigmoid函数
def sigmoid(z):
    g = 1/(1+np.exp(-1*z))
    return g

# 损失函数
def costFuncReg(theta, x, y, lam):
    m = np.size(y, 0)
    h = sigmoid(x.dot(theta))
    j=-1/m*(y.dot(np.log(h))+(1-y).dot(np.log(1-h)))+lam/(2*m)*theta[1:].dot(theta[1:])
    return j

# 梯度函数
def gradFuncReg(theta, x, y, lam):
    m = np.size(y, 0)
    h = sigmoid(x.dot(theta))
    grad = np.zeros(np.size(theta, 0))
    grad[0] = 1/m*(x[:, 0].dot(h-y))
    grad[1:] = 1/m*(x[:, 1:].T.dot(h-y))+lam*theta[1:]/m
    return grad

cost = costFuncReg(init_theta, X, Y, lamd)
print('Cost at initial theta (zeros): ', cost)
_ = input('Press [Enter] to continue.')

# ============= Part 2: Regularization and Accuracies =============
init_theta = np.zeros((np.size(X, 1),))
lamd = 1
result = op.minimize(costFuncReg, x0=init_theta, method='BFGS', jac=gradFuncReg, args=(X, Y, lamd))
theta = result.x

def plotDecisionBoundary(theta, x, y):
    pos = np.where(y == 1)
    neg = np.where(y == 0)
    p1 = plt.scatter(x[pos, 1], x[pos, 2], marker='+', s=60, color='r')
    p2 = plt.scatter(x[neg, 1], x[neg, 2], marker='o', s=60, color='y')
    u = np.linspace(-1, 1.5, 50)
    v = np.linspace(-1, 1.5, 50)
    z = np.zeros((np.size(u, 0), np.size(v, 0)))
    for i in range(np.size(u, 0)):
        for j in range(np.size(v, 0)):
            z[i, j] = mapFeature(np.array([u[i]]), np.array([v[j]])).dot(theta)
    z = z.T
    [um, vm] = np.meshgrid(u, v)
    plt.contour(um, vm, z, levels=[0], lw=2)
    plt.legend((p1, p2), ('Admitted', 'Not admitted'), loc='upper right', fontsize=8)
    plt.xlabel('Microchip Test 1')
    plt.ylabel('Microchip Test 2')
    plt.title('lambda = 1')
    plt.show()

plotDecisionBoundary(theta, X, Y)

# 预测给定值
def predict(theta, x):
    m = np.size(X, 0)
    p = np.zeros((m,))
    pos = np.where(x.dot(theta) >= 0)
    neg = np.where(x.dot(theta) < 0)
    p[pos] = 1
    p[neg] = 0
    return p

p = predict(theta, X)
print('Train Accuracy: ', np.sum(p == Y)/np.size(Y, 0))